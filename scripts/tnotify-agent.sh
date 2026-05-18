#!/usr/bin/env bash
# Usage: tnotify-agent.sh [agent-name]
## -- Coding-agent notification entrypoint
#
# Meant to be invoked from a coding agent's "turn finished / needs attention"
# hook (e.g. Claude Code's Stop/Notification hooks, the Codex CLI `notify`
# program) instead of the prompt-suffix poller used for shell commands. Unlike
# a shell command, an agent never returns to a `$` prompt between turns, so it
# must tell us itself when it is done; this script turns that signal into the
# same notifications (libnotify/osascript, Telegram, Pushover, custom command,
# visual bell) the rest of the plugin already produces.
#
# It relies on the fact that the agent process runs inside a tmux pane, so the
# hook subprocess inherits $TMUX/$TMUX_PANE and tmux resolves the agent's own
# pane automatically.

# Some hooks (e.g. Claude Code) pipe a JSON payload on stdin. We do not need
# it, but drain it first so the agent process never blocks writing to us.
if [[ ! -t 0 ]]; then
  cat > /dev/null 2>&1 || true
fi

# Only meaningful when the agent runs inside tmux. Bail out quietly otherwise
# so the agent is never disrupted by hook errors.
if [[ -z "$TMUX" ]]; then
  exit 0
fi

# Get current directory
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source helpers and variables
source "${CURRENT_DIR}/helpers.sh"
source "${CURRENT_DIR}/variables.sh"

agent_name="${1:-Coding agent}"

# Build the notification text (override via @tnotify-agent-msg).
agent_msg_value="$(get_tmux_option "$agent_msg_option" "$agent_msg_default")"
complete_message="${agent_msg_value//\{agent\}/$agent_name}"

# Reuse the verbose title when verbose mode is enabled, matching notify.sh.
if verbose_enabled; then
  agent_title_value="$(get_tmux_option "$verbose_title_option" "$verbose_title_default")"
  complete_title=$(tmux display-message -p "$agent_title_value")
else
  complete_title=""
fi

# Pass "true" so Telegram is notified when configured (same as prefix + C-m);
# Pushover is sent automatically when configured.
notify "$complete_message" "$complete_title" "true"

exit 0
