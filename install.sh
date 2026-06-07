#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=lib/log.sh
. "$(dirname "$0")/lib/log.sh"
log_init

darwin_install() {
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

if [ "$(uname)" == "Darwin" ]; then
	if ! darwin_install; then
		log_err "Homebrew install failed"
		exit 1
	fi
	exit 0
fi

# Detect distro: Fedora-family uses dnf/rpm, others fall back to apt.
if command -v dnf >/dev/null 2>&1; then
	DISTRO="fedora"
	log_info "detected distro: fedora"
	sudo dnf install -y wget unzip
else
	DISTRO="debian"
	log_info "detected distro: debian (apt)"
	sudo apt-get update && sudo apt-get install -y wget unzip
fi
export DISTRO

# Pick a window manager. Honor $WM env var for non-interactive runs,
# otherwise prompt with hyprland as the default.
if [[ -n "${WM:-}" ]]; then
	wm_choice="$WM"
	log_info "WM supplied via env: $wm_choice"
else
	read -p "Which window manager? [hyprland/i3/sway] (default: hyprland): " wm_choice
	wm_choice=${wm_choice:-hyprland}
fi

case "$wm_choice" in
	hyprland|i3|sway)
		export WM="$wm_choice"
		log_info "selected WM=$WM (distro=$DISTRO)"
		;;
	*)
		log_err "unknown window manager: $wm_choice"
		exit 1
		;;
esac

directories=($(ls -l | grep '^d' | awk '{print $9}'))

ok=0
skipped=0
failed=0
failed_modules=()

for cmd in "${directories[@]}"; do
	if [[ "$cmd" == "legacy" ]]; then
		log_step "legacy" "skipped (not auto-applied)"
		skipped=$((skipped + 1))
		continue
	fi

	start_ts=$(date +%s)
	log_step "$cmd" "starting"
	if ( cd "./$cmd" && WM="$WM" DISTRO="$DISTRO" ./apply.sh ); then
		elapsed=$(( $(date +%s) - start_ts ))
		log_ok "$cmd completed in ${elapsed}s"
		ok=$((ok + 1))
	else
		rc=$?
		elapsed=$(( $(date +%s) - start_ts ))
		log_err "$cmd FAILED after ${elapsed}s (exit $rc)"
		failed=$((failed + 1))
		failed_modules+=("$cmd")
	fi
done

log_info "summary: ok=$ok skipped=$skipped failed=$failed"
log_info "log file: $LOGFILE"

if [[ $failed -gt 0 ]]; then
	log_err "failed modules: ${failed_modules[*]}"
	exit 1
fi

exit 0
