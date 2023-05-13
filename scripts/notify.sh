#!/usr/bin/env bash
## -- Start monitoring script

# Get current directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source helpers and variables
source "${CURRENT_DIR}/helpers.sh"
source "${CURRENT_DIR}/variables.sh"

## Functions

# Send notification
notify() {
  # Switch notification method based on OS
  if [[ "$OSTYPE" =~ ^darwin ]]; then # If macOS
    osascript -e 'display notification "'"$1"'" with title "tmux-notify"'
  else
    # notify-send does not always work due to changing dbus params
    # see https://superuser.com/questions/1118878/using-notify-send-in-a-tmux-session-shows-error-no-notification#1118896
    notify-send "$1"
  fi
  
  # trigger visual bell
  # your terminal emulator can be setup to set URGENT bit on visual bell
  # for eg, Xresources -> URxvt.urgentOnBell: true
  tmux split-window "echo -e \"\a\" && exit"
}

# Handle cancelation of monitor job
on_cancel()
{
  # Wait a bit for all pane monitors to complete
  sleep "$monitor_sleep_duration_value"
  
  # Preform cleanup operation is monitoring was canceled
  if [[ -f "$PID_FILE_PATH" ]]; then
    kill "$PID"
    rm "${PID_DIR}/${PANE_ID}.pid"
  fi
  exit 0
}
trap 'on_cancel' TERM

# Check if verbose option is enabled
verbose_enabled() {
  local verbose_value="$(get_tmux_option "$verbose_option" "$verbose_default")"
  [ "$verbose_value" != "on" ]
}

## Main script

# Monitor pane if it is not already monitored
if [[ ! -f "$PID_FILE_PATH" ]]; then  # If pane not yet monitored
  
  # job started - create pid-file
  echo "$$" > "$PID_FILE_PATH"
  
  # Display tnotify start messsage
  tmux display-message "Monitoring pane..."
  
  # Construct tnotify finish message
  if verbose_enabled; then  # If @tnotify-verbose is disabled
    complete_message="Tmux pane task completed!"
  else  # If @tnotify-verbose is enabled
    verbose_msg_value="$(get_tmux_option "$verbose_msg_option" "$verbose_msg_default")"
    complete_message=$(tmux display-message -p "$verbose_msg_value")
  fi
  
  # Create bash suffix list
  # NOTE: Looks complicated but uses shell parameter expansion
  # see https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
  prompt_suffixes="$(get_tmux_option "$prompt_suffixes" "$prompt_suffixes_default")"
  prompt_suffixes=${prompt_suffixes// /} # Remove whitespace
  prompt_suffixes=${prompt_suffixes//,/|} # Replace comma with or operator
  prompt_suffixes=$(escape_glob_chars "$prompt_suffixes")
  prompt_suffixes="\(${prompt_suffixes}\)$"
  
  # Check process status every 10 seconds to see if has is finished
  while true; do
    
    # capture pane output
    output=$(tmux capture-pane -pt %"$PANE_ID")
    
    # run tests to determine if work is done
    # if so, break and notify
    if echo "$output" | tail -n2 | grep -e $prompt_suffixes &> /dev/null; then
      # tmux display-message "$@"
      if [[ "$1" == "refocus" ]]; then
        tmux switch -t \$"$SESSION_ID"
        tmux select-window -t @"$WINDOW_ID"
        tmux select-pane -t %"$PANE_ID"
      fi
      notify "$complete_message"
      break
    fi
    
    # Sleep for a given time
    monitor_sleep_duration_value=$(get_tmux_option "$monitor_sleep_duration" "$monitor_sleep_duration_default")
    sleep "$monitor_sleep_duration_value"
  done
  
  # job done - remove pid file and return
  if [[ -f "$PID_FILE_PATH" ]]; then
    rm "$PID_FILE_PATH"
  fi
  exit 0
else  # If pane is already being monitored
  
  # Display pane already monitored message
  tmux display-message "Pane already monitored..."
  exit 0
fi
