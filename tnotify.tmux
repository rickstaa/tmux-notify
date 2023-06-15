#!/usr/bin/env bash

# Get current directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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
  mkdir $PID_DIR
fi

# Bind plugin keys
tmux unbind-key m
tmux unbind-key M
tmux unbind-key M-m
tmux unbind-key C-m
tmux unbind-key C-M-m

tmux bind-key m run-shell -b "$CURRENT_DIR/scripts/notify.sh"
tmux bind-key M run-shell -b "$CURRENT_DIR/scripts/cancel.sh"
tmux bind-key M-m run-shell -b "$CURRENT_DIR/scripts/notify.sh true"
tmux bind-key C-m run-shell -b "$CURRENT_DIR/scripts/notify.sh false true"
tmux bind-key C-M-m run-shell -b "$CURRENT_DIR/scripts/notify.sh true true"

# Print deprecated message
deprication_warning="'ChanderG/tmux-notify' is no longer maintained. Please switch to 'rickstaa/tmux-notify'. See https://github.com/ChanderG/tmux-notify/issues/38 for more information."
if [[ "$OSTYPE" =~ ^darwin ]]; then # If macOS
  osascript -e 'display notification "'"$deprication_warning"'" with title "tmux-notify"'
else
  # notify-send does not always work due to changing dbus params
  # see https://superuser.com/questions/1118878/using-notify-send-in-a-tmux-session-shows-error-no-notification#1118896
  notify-send "WARNING" "${deprication_warning}"
fi
