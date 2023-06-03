#!/usr/bin/env bash
## -- Helper functions
# Additional functions that are used in the main scripts.

# Get tmux option
get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

# Set tmux option
set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

# Escape globbing charaters
escape_glob_chars() {
  echo "$1" | sed 's/[.[\*^$()+?{|]/\\&/g'
}

# Send notification
notify() {
  # Switch notification method based on OS
  if [[ "$OSTYPE" =~ ^darwin ]]; then # If macOS
    osascript -e 'display notification "'"$1"'" with title "tmux-notify"'
  else
    # notify-send does not always work due to changing dbus params
    # see https://superuser.com/questions/1118878/using-notify-send-in-a-tmux-session-shows-error-no-notification#1118896
    notify-send "$1"
  fi
  
  # Send telegram message if telegram bot id and chat id are set
  if telegram_enabled; then
    telegram_bot_id="$(get_tmux_option "$tmux_notify_telegram_bot_id" "$tmux_notify_telegram_bot_id_default")"
    telegram_chat_id="$(get_tmux_option "$tmux_notify_telegram_channel_id" "$tmux_notify_telegram_channel_id_default")"
    send_telegram_message $telegram_bot_id $telegram_chat_id "$1"
  fi
  
  # trigger visual bell
  # your terminal emulator can be setup to set URGENT bit on visual bell
  # for eg, Xresources -> URxvt.urgentOnBell: true
  tmux split-window "echo -e \"\a\" && exit"
}

# Check if verbose option is enabled
verbose_enabled() {
  local verbose_value="$(get_tmux_option "$verbose_option" "$verbose_default")"
  [ "$verbose_value" != "on" ]
}

# Check if telegram bot id and chat id are set
telegram_enabled() {
  local telegram_id="$(get_tmux_option "$tmux_notify_telegram_bot_id" "$tmux_notify_telegram_bot_id_default")"
  local telegram_chat_id="$(get_tmux_option "$tmux_notify_telegram_channel_id" "$tmux_notify_telegram_channel_id_default")"
  [ -n "$telegram_id" ] && [ -n "$telegram_chat_id" ]
}

# Send telegram message
send_telegram_message(){
  curl "https://api.telegram.org/bot$1/sendMessage?chat_id=$2&text=$3"
}
