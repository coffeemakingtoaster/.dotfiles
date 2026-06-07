# shellcheck shell=bash
# Shared logger for the dotfiles installer.
#
# Sourced from install.sh and every apply.sh. Sourcing is idempotent so
# nested apply.sh scripts do not double-initialize.
#
# Public API:
#   log_init           Initialize the logfile path. Idempotent.
#   log_info  "msg"    Informational message.
#   log_warn  "msg"    Warning, non-fatal.
#   log_err   "msg"    Error message (does NOT exit; caller decides).
#   log_ok    "msg"    Success message.
#   log_step  "name" "msg"  Module-scoped step, prefixed with [name].
#
# Environment:
#   LOGFILE            Set by log_init. Defaults to
#                      ${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/install-<ts>.log
#   DOTFILES_NO_COLOR  If non-empty, disables ANSI colors.

if [ -n "${__DOTFILES_LOG_SH__:-}" ]; then
	return 0
fi
__DOTFILES_LOG_SH__=1

LOGFILE="${LOGFILE:-}"

_log_color() {
	if [ -n "${DOTFILES_NO_COLOR:-}" ] || [ ! -t 1 ]; then
		return 1
	fi
	return 0
}

_log_ts() {
	printf '%(%H:%M:%S)T'
}

_log_emit() {
	local level="$1" color="$2" reset="$3" msg="$4"
	local line
	line="[$( _log_ts )] $level $msg"
	if [ -n "$LOGFILE" ]; then
		printf '%s\n' "$line" >> "$LOGFILE"
	fi
	if _log_color; then
		printf '%s%s%s%s\n' "$color" "$line" "$reset" ""
	else
		printf '%s\n' "$line"
	fi
}

log_init() {
	if [ -n "$LOGFILE" ]; then
		return 0
	fi
	local logdir="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
	mkdir -p "$logdir"
	LOGFILE="$logdir/install-$(date +%Y%m%d-%H%M%S).log"
	{
		printf 'dotfiles install log\n'
		printf 'started: %s\n' "$(date)"
		printf 'host:    %s\n' "$(uname -a)"
		printf -- '---\n'
	} > "$LOGFILE"
}

log_info() {
	_log_emit "[INFO ] " "" "" "$*"
}

log_warn() {
	_log_emit "[WARN ] " "$(printf '\033[1;33m')" "$(printf '\033[0m')" "$*"
}

log_err() {
	_log_emit "[ERROR] " "$(printf '\033[1;31m')" "$(printf '\033[0m')" "$*"
}

log_ok() {
	_log_emit "[OK   ] " "$(printf '\033[1;32m')" "$(printf '\033[0m')" "$*"
}

log_step() {
	local module="$1"; shift
	_log_emit "[INFO ] " "" "" "[$module] $*"
}
