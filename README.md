# tmux-notify <!-- omit in toc -->

[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green)](https://github.com/rickstaa/tmux-notify/pulse)
[![Contributions](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Tmux version](https://img.shields.io/badge/tmux-%3D%3E1.9-blue)](https://github.com/tmux/tmux/wiki)

<a href="https://github.com/rickstaa/tmux-notify"><img src="resources/tmux-notify-logo.svg" alt="tmux notify logo" width="567" height="135"/></a>

Tmux plugin to notify you when processes are finished.

> \[!NOTE]\
> Notifications are sent via [libnotify](https://gitlab.gnome.org/GNOME/libnotify), and visual bells are raised in the Tmux window. Visual bells can be mapped (in the terminal level) to the X11 urgency bit and handled by your window manager.

## Table of Contents <!-- omit in toc -->

*   [Use cases](#use-cases)
*   [Pre-requisites](#pre-requisites)
*   [Install](#install)
*   [Usage](#usage)
*   [Configuration](#configuration)
    *   [Enable verbose notification](#enable-verbose-notification)
    *   [Change monitor update period](#change-monitor-update-period)
    *   [Add additional shell suffixes](#add-additional-shell-suffixes)
    *   [Enable telegram channel notifications](#enable-telegram-channel-notifications)
    *   [Execute custom notification commands](#execute-custom-notification-commands)
*   [How does it work](#how-does-it-work)
*   [Other use cases](#other-use-cases)
    *   [Use inside a docker container](#use-inside-a-docker-container)
*   [Contributing](#contributing)
*   [References](#references)

## Use cases

*   When you have already started a process in a pane and wish to be notified (i.e. you can't use a manual trigger).
*   Working in different containers (Docker) -> can't choose the shell -> and can't use a shell-level feature.
*   Working over ssh, but your Tmux is on the client side.

## Pre-requisites

*   Bash
*   Tmux
*   `notify-send` or `osascript`.
*   **Optional**: `wget` (for telegram notifications).

> \[!NOTE]\
> Works on Linux and macOS (note: only actively tested on Linux).

## Install

Using [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm), add:

    set -g @plugin 'rickstaa/tmux-notify'

to your `.tmux.conf`.

Use `prefix + I` to install.

## Usage

*   `prefix + m`: Start monitoring a pane and notify when it finishes.

*   `prefix + alt + m`: Start monitoring a pane, return it in focus and notify when it finishes.

*   `prefix + M`: Cancel monitoring of a pane.

> \[!IMPORTANT]\
> There is a known issue with alt-based Tmux shortcuts on osx. If you encounter problems, please check [this post](https://superuser.com/questions/649960/option-key-does-not-work-as-meta-in-tmux) for a workaround.

## Configuration

### Enable verbose notification

The default notification text is `Tmux pane task completed!`. This tool also contains a verbose output option which gives more information about the pane, window, and session the task has completed.

> To enable this, put `set -g @tnotify-verbose 'on'` in the `.tmux.conf` config file.

#### Change the verbose notification message

To change the verbose notification text, put `set -g @tnotify-verbose-msg 'put your notification text here'` in the `.tmux.conf` config file. You can use all the Tmux variables in your notification text. Some useful Tmux aliases are:

*   `#D`: Pane id
*   `#P`: Pane index
*   `#T`: Pane title
*   `#S`: Session name
*   `#I`: Window index
*   `#W`: Window name

For the complete list of aliases and variables, you are referred to the `FORMATS` section of the [tmux manual](http://man7.org/linux/man-pages/man1/tmux.1.html). You can also add a notification title using `set -g @tnotify-verbose-title`. Doing so will move the verbose notification text into the notification body.

### Change monitor update period

By default, the monitor sleep period is set to 10 seconds. This means that tmux-notify checks the pane activity every 10 seconds.

> Put `set -g @tnotify-sleep-duration 'desired duration'` in the `.tmux.conf` file to change this duration.

> \[!WARNING]\
> Remember that there is a trade-off between notification speed (short sleep duration) and the amount of memory this tool needs.

### Add additional shell suffixes

The Tmux notify script uses your shell prompt suffix to check whether a command has finished. By default, it looks for the `$`, `#` and `%` suffixes.

> Put `set -g @tnotify-prompt-suffixes 'put your comma-separated bash suffix list here'` in the `.tmux.conf` file to add additional suffixes.

> \[!NOTE]\
> Feel free to open [a pull](https://github.com/rickstaa/tmux-notify/pulls) request or [issue](https://github.com/rickstaa/tmux-notify/issues) if you think your shell prompt suffix should be included by default.

### Enable telegram channel notifications

> \[!WARNING]\
> This feature requires [wget](https://www.gnu.org/software/wget/) to be installed on your system.

By default, the tool only sent operating system notifications. It can, however, also send a message to a user-specified telegram channel.

> Put `set -g @tnotify-telegram-bot-id 'your telegram bot id'` and `set -g @tnotify-telegram-channel-id 'your channel id'` in the `.tmux.conf` config file to enable this.

After enabling this option, the following key bindings are available:

*   `prefix + ctrl + m`: Start monitoring pane and notify in bash and telegram when it finishes.

*   `prefix + ctrl + alt + m`: Start monitoring a pane, return it in focus and notify in bash and telegram when it finishes.

Additionally, you can use the `set -g @tnotify-telegram-all 'on'` option to send all notifications to telegram.

> \[!NOTE]\
> You can get your telegram bot id by creating a bot using [BotFather](https://core.telegram.org/bots#6-botfather) and your channel id by sending your channel invite link to the `@username_to_id_bot` bot.

### Execute custom notification commands

You can execute a custom command after a process has finished by putting `set -g @tnotify-custom-cmd 'your custom command here'` in the `.tmux.conf` file. The custom command is executed in the pane where the process has finished. If you want to execute multiple commands, you can also put them in a bash script and execute this script (i.e. `set -g @tnotify-custom-cmd 'bash /path/to/script.sh'`).

> \[!WARNING]\
> The custom command is executed using the `eval` command, so [be careful with what you put in here](https://stackoverflow.com/a/17529221/8135687).

> \[!NOTE]\
> Please consider contributing to [this repository](https://github.com/rickstaa/tmux-notify) if your custom command is useful for others.

## How does it work

A naive approach. Checks if pane content ends with the bash prompt suffixes mentioned above every 10 seconds.

## Other use cases

### Use inside a docker container

Because tmux-notify uses [libnotify](https://gitlab.gnome.org/GNOME/libnotify) to send notifications, it needs access to the host's D-Bus socket. An excellent guide on how to do this can be found [here](https://github.com/mviereck/x11docker/wiki/How-to-connect-container-to-DBus-from-host#dbus-user-session-daemon). You can also check out the [examples/docker](examples/docker/README.md) folder for an example.

## Contributing

Feel free to open an issue if you have ideas on how to make this GitHub action better or if you want to report a bug! All contributions are welcome :rocket:. Please consult the [contribution guidelines](CONTRIBUTING.md) for more information.

## References

*   The initial version of this tool was developed by [@ChanderG](https://github.com/ChanderG).
*   Icon created with svg made by [@chanut](https://www.flaticon.com/authors/chanut) from [www.flaticon.com](https://www.flaticon.com/authors/chanut)
