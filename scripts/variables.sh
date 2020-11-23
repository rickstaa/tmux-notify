#!/usr/bin/env bash
## -- Add tmux plugin variables

## Main variables
export SUPPORTED_VERSION="1.9"
export PID_DIR=~/.tmux/notify

## Tnotify tmux options

# Notification verbosity settings
export verbose_option="@tnotify-verbose"
export verbose_default="off"
export verbose_msg_option="@tnotify-verbose-msg"
export verbose_msg_default="(#S, #I:#P) Tmux pane task completed!"

# Monitor checker interval
export monitor_sleep_duration="@tnotify-sleep-duration"
export monitor_sleep_duration_default=10
