#!/usr/bin/env bash
## -- Add tmux plugin variables

## Main variables
SUPPORTED_VERSION="1.9"
PID_DIR=~/.tmux/notify

## Tnotify tmux options

# Notification verbosity settings
verbose_option="@tnotify-verbose"
verbose_default="off"
verbose_msg_option="@tnotify-verbose-msg"
verbose_msg_default="(#S, #I:#P) Tmux pane task completed!"

# Monitor checker interval
monitor_sleep_duration="@tnotify-sleep-duration"
monitor_sleep_duration_default=10
