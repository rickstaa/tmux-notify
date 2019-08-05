#!/usr/bin/env bash

# get id of the current active pane
PANEID=$(tmux list-panes | grep "active" | awk -F\] '{print $3}' | awk '{print $1}')
PID_DIR=~/.tmux/notify

# Cancel monitor process if active
{ # Try

# consult pid file for the pid
PID=$(cat "$PID_DIR/$PANEID".pid)

# job done - kill process and remove pid file
kill $PID
rm "$PID_DIR/$PANEID".pid

} || { # Catch
  tmux display-message "Pane not monitored..."
  exit 0
}