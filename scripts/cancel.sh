#!/usr/bin/env bash

# get id of the current active pane
PANEID=$(tmux list-panes | grep "active" | awk -F\] '{print $3}' | awk '{print $1}')
PID_DIR=~/.tmux/notify

# consult pid file for the pid
PID=$(cat "$PID_DIR/$PANEID".pid)
kill $PID

# job done - remove pid file
rm "$PID_DIR/$PANEID".pid
