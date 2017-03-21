#!/usr/bin/env bash

# get id of the current active pane
PANEID=$(tmux list-panes | grep "active" | awk -F\] '{print $3}' | awk '{print $1}')
PID_DIR=~/.tmux/notify

# write pid to file
echo "$$" > "$PID_DIR/$PANEID".pid

tmux display-message "Montoring pane..."

# if user cancels 
on_cancel()
{
  tmux display-message "Cancelling monitoring..."
  exit 0
}
trap 'on_cancel' TERM

while true; do
  # capture pane output
  output=$(tmux capture-pane -pt $PANEID)
  # run tests to determine if work is done
  # if so, break and notify
  lc=$(echo $output | tail -c2)

  if [[ "$lc" == "$" ]]; then
    notify-send "Tmux pane task completed!"
    break
  fi

  sleep 10
done

# job done - remove pid file
rm "$PID_DIR/$PANEID".pid
