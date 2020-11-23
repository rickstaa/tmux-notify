#!/usr/bin/env bash
## -- Cancel monitoring script
# Used to cancel the current  pane monitor job

# Get current directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source helpers and variables
source "$CURRENT_DIR/helpers.sh"
source "$CURRENT_DIR/variables.sh"

# Get pane id
SESSION_NR=$(tmux list-sessions | grep "(attached)" | awk '{print $1}' | tr -d :)
WINDOW_NR=$(tmux list-windows | grep "(active)" | awk '{print $1}' | tr -d :)
PANE_NR=$(tmux list-panes | grep "active" | awk -F\] '{print $3}' | awk '{print $1}' | tr -d %)
PANE_ID=$(detox_file_name "s_${SESSION_NR}_w${WINDOW_NR}_p${PANE_NR}")
PID_FILE_PATH="${PID_DIR}/${PANE_ID}.pid"

# Cancel pane monitoring if active
if [[ -f "$PID_FILE_PATH" ]]; then

  # Retrieve monitor process PID
  PID=$(cat "$PID_FILE_PATH")

  # Kill process and remove pid file
  kill "$PID"
  rm "${PID_DIR}/${PANE_ID}.pid"

  # Display success message
  tmux display-message "Pane monitoring canceled..."
else
  tmux display-message "Pane not monitored..."
  exit 0
fi
