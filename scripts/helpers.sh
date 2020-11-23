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

## Detox file names
# Makes sure invalid chars are removed from a filename
detox_file_name(){
	local file_name="$1"
	echo  "$file_name" | sed -e 's/[^A-Za-z0-9._-]/_/g'
}
