#!/usr/bin/env bash
# Usage: notify <refocus> <telegram>
## -- Start monitoring script

# Get current directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source helpers and variables
source "${CURRENT_DIR}/helpers.sh"
source "${CURRENT_DIR}/variables.sh"

## Functions

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

## Main script

# Monitor pane if it is not already monitored
if [[ ! -f "$PID_FILE_PATH" ]]; then  # If pane not yet monitored
  # job started - create pid-file
  echo "$$" > "$PID_FILE_PATH"
  
  # Display tnotify start messsage
  tmux display-message "Monitoring pane..."
  
  # Construct tnotify finish message
  if verbose_enabled; then  # If @tnotify-verbose is enabled
    verbose_msg_value="$(get_tmux_option "$verbose_msg_option" "$verbose_msg_default")"
    complete_message=$(tmux display-message -p "$verbose_msg_value")
    verbose_msg_title="$(get_tmux_option "$verbose_title_option" "$verbose_title_default")"
    complete_title=$(tmux display-message -p "$verbose_msg_title")
  else  # If @tnotify-verbose is disabled
    complete_message="Tmux pane task completed!"
  fi
  
  prompt_regex_value="$(get_tmux_option "$prompt_regex" "$prompt_regex_default")"
  if [[ -z "$prompt_regex_value" ]]; then
    # Create bash suffix list
    # NOTE: Looks complicated but uses shell parameter expansion
    # see https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
    prompt_regex_value="$(get_tmux_option "$prompt_suffixes" "$prompt_suffixes_default")"
    prompt_regex_value=${prompt_regex_value// /} # Remove whitespace
    prompt_regex_value=${prompt_regex_value//,/|} # Replace comma with or operator
    prompt_regex_value=$(escape_glob_chars "$prompt_regex_value")
    prompt_regex_value="\(${prompt_regex_value}\)$"
  fi
  
  # Check process status every 10 seconds to see if has is finished
  while true; do
    # capture pane output
    output=$(tmux capture-pane -pt %"$PANE_ID")
    
    # run tests to determine if work is done
    # if so, break and notify
    if echo "$output" | tail -n2 | grep -e $prompt_regex_value &> /dev/null; then
      # tmux display-message "$@"
      if [[ "$1" == "true" ]]; then
        tmux switch -t \$"$SESSION_ID"
        tmux select-window -t @"$WINDOW_ID"
        tmux select-pane -t %"$PANE_ID"
      fi
      notify "$complete_message" "$complete_title" $2
      break
    fi
    
    # Sleep for a given time
    monitor_sleep_duration_value=$(get_tmux_option "$monitor_sleep_duration" "$monitor_sleep_duration_default")
    sleep "$monitor_sleep_duration_value"
  done
  
  # job done - remove pid file
  if [[ -f "$PID_FILE_PATH" ]]; then
    rm "$PID_FILE_PATH"
  fi
  
  # Execute custom command if specified by user
  custom_command="$(get_tmux_option "$custom_notify_command" "$custom_notify_command_default")"
  if [[ -n "$custom_command" ]]; then
    eval "${custom_command}"
  fi
  
  exit 0
else  # If pane is already being monitored
  
  # Display pane already monitored message
  tmux display-message "Pane already monitored..."
  exit 0
fi
