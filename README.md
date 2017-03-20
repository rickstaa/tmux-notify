# tmux-notify

Tmux plugin to notify you when processes complete. 

## Use cases

+ When you have already started a process in a pane and wish to be notified; that is can't use a manual trigger
+ Working in different containers (Docker) -> can't choose the shell -> and can't use a shell level feature
+ Working over ssh but your tmux is on client side

## Install

Using [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm), add:

```
set -g @plugin 'ChanderG/tmux-notify'
```
to your `.tmux.conf`.

Use `prefix + I` to install.

## Usage

`prefix + m`: Start monitoring a pane to notify; exits after first notification.
`prefix + M`: Cancel monitoring of a pane.

## Pre-requisites

bash, notify-send on the machine with the tmux server.
Tested only on Linux.

## How does it work?

Pretty naive approach actually. Checks if pane content ends in $ every 10 seconds.
Will add other prompt end characters as needed.

## License

MIT
