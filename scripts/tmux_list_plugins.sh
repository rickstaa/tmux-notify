#!/usr/bin/env bash

# fetching the value of "tpm_plugins" option
plugins_list=$(tmux show-option -gqv "@tpm_plugins")

# displaying variable content, line by line
for plugin in $plugins_list; do
    echo $plugin
done
