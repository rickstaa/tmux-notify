#!/usr/bin/env bash
# Usage: notify <refocus> <telegram>
## -- Start monitoring script

# Get current directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source helpers and variables
source "${CURRENT_DIR}/helpers.sh"
source "${CURRENT_DIR}/variables.sh"

debug_path="$(get_tmux_option "$tmux_notify_debug_log_path" "$tmux_notify_debug_log_path_default")"

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
  debug_enabled && debug_log "$debug_path" "Created new monitor: $PID_FILE_PATH"
  
  # Construct tnotify finish message
  if verbose_enabled; then  # If @tnotify-verbose is enabled
    verbose_msg_value="$(get_tmux_option "$verbose_msg_option" "$verbose_msg_default")"
    complete_message=$(tmux display-message -p "$verbose_msg_value")
    verbose_msg_title="$(get_tmux_option "$verbose_title_option" "$verbose_title_default")"
    complete_title=$(tmux display-message -p "$verbose_msg_title")
  else  # If @tnotify-verbose is disabled
    complete_message="Tmux pane task completed!"
  fi
  
  # Create bash suffix list
  # NOTE: Looks complicated but uses shell parameter expansion
  # see https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
  prompt_suffixes="$(get_prompt_suffixes)"
  debug_enabled && debug_log "$debug_path" "Built prompt suffixes for $PID_FILE_PATH: $(cat -A <<<"$prompt_suffixes")"
  
  # Check process status every 10 seconds to see if has is finished
  while true; do
    debug_enabled && debug_log "$debug_path" "Checking pane for $PID_FILE_PATH: $PANE_ID"
    # capture pane output
    output=$(tmux capture-pane -pt %"$PANE_ID")

    noisy_enabled && tmux display-message "checking pane"
    
    recent_output=$(echo "$output" | tail -n 2)
    debug_enabled && debug_log "$debug_path" "Checking pane content for $PID_FILE_PATH: Line 1: $(head -n 1 <<<"$recent_output")"
    debug_enabled && debug_log "$debug_path" "Checking pane content for $PID_FILE_PATH: Line 2: $(tail -n 1 <<<"$recent_output")"

    # run tests to determine if work is done
    # if so, break and notify
    if echo "$recent_output" | grep -e $prompt_suffixes &> /dev/null; then
      #tmux display-message "$@"
      debug_enabled && debug_log "$debug_path" "Matched monitor for $PID_FILE_PATH"
      if [[ "$1" == "true" ]]; then # if the script was asked to change focus to the pane upon completion
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
    debug_enabled && debug_log "$debug_path" "Removed $PID_FILE_PATH"
  fi
  
  custom_command="$(get_tmux_option "$custom_notify_command" "$custom_notify_command_default")"
  if [[ -n "$custom_command" ]]; then 
    complete_command=$(tmux display-message -p "$custom_command")

    mapfile -t cmd_array < <(xargs printf '%s\n' <<<"$complete_command")
    cmd_array[0]=$(expand_home "${cmd_array[0]}")

    tmux display-message "running ${custom_command}"

    "${cmd_array[@]}" >/tmp/rn.stdout 2>/tmp/rn.stderr
    debug_log "$debug_path" "rn exit=$? stderr=[$(cat /tmp/rn.stderr)] stdout=[$(cat /tmp/rn.stdout)]"

    debug_enabled && debug_log "$debug_path" "Run custom notify command: ${custom_command} with normalised literal ${cmd_array[*]}"
  fi
  
  exit 0
else  # If pane is already being monitored
  debug_enabled && debug_log "$debug_path" "Attempt to monitor pane already being monitored."
  tmux display-message "Pane already monitored..."
  exit 0
fi
