#!/usr/bin/env bash

# get id of the current active pane
PANEID=$(tmux list-panes | grep "active" | awk -F\] '{print $3}' | awk '{print $1}')

tmux display-message "Montoring pane..."

while true; do
  # capture pane output
  output=$(tmux capture-pane -pt $PANEID)
  # run tests to determine if work is done
  # if so, break and notify
  lc=$(echo $output | rev | head -c1)

  if [[ "$lc" == "$" ]]; then
    notify-send "Tmux pane task completed!"
    break
  fi

  sleep 5
done
