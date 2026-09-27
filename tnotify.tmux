#!/usr/bin/env bash

# Get current directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# TODO i think redundant since we can do most of it in variables.sh
# Set PID_DIR
if [[ -z $XDG_CACHE_HOME ]]; then
  export PID_DIR=~/.tmux/notify
else
  export PID_DIR="$XDG_CACHE_HOME/tmux/tmux-notify"
fi

# Initialize variables
source "$CURRENT_DIR/scripts/helpers.sh"
source "$CURRENT_DIR/scripts/variables.sh"

# prepare pid file directory
if [[ ! -d $PID_DIR ]]; then
  mkdir -p $PID_DIR
fi

# Bind plugin keys
tmux unbind-key m
tmux unbind-key M
tmux unbind-key M-m
tmux unbind-key C-m
tmux unbind-key C-M-m

tmux bind-key m run-shell -b "$CURRENT_DIR/scripts/notify.sh 2>> $tmux_notify_error_log_path_default"
tmux bind-key M run-shell -b "$CURRENT_DIR/scripts/cancel.sh 2>> $tmux_notify_error_log_path_default"
tmux bind-key M-m run-shell -b "$CURRENT_DIR/scripts/notify.sh true 2>> $tmux_notify_error_log_path_default"
tmux bind-key C-m run-shell -b "$CURRENT_DIR/scripts/notify.sh false true 2>> $tmux_notify_error_log_path_default"
tmux bind-key C-M-m run-shell -b "$CURRENT_DIR/scripts/notify.sh true true 2>> $tmux_notify_error_log_path_default"
