#!/usr/bin/env bash
## -- Add tmux plugin variables

## Main variables
if [[ -z $XDG_STATE_HOME ]]; then
    export PID_DIR=~/.tmux/notify
else
    export PID_DIR="$XDG_STATE_HOME/tmux/tmux-notify"
fi

# Get ID's
export SESSION_ID=$(tmux display-message -p '#{session_id}'  | tr -d $)
export WINDOW_ID=$(tmux display-message -p '#{window_id}' | tr -d @)
export PANE_ID=$(tmux display-message -p '#{pane_id}' | tr -d %)
export PID_FILE_PATH="${PID_DIR}/${PANE_ID}.pid"

## Tnotify tmux options

# Notification verbosity settings
export verbose_option="@tnotify-verbose"
export verbose_default="off"
export verbose_msg_option="@tnotify-verbose-msg"
export verbose_msg_default="(#S, #I:#P) Tmux pane task completed!"

# Monitor checker interval
export monitor_sleep_duration="@tnotify-sleep-duration"
export monitor_sleep_duration_default=10
