#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../lib/log.sh
. "$(dirname "$0")/../lib/log.sh"
log_init

log_step "herdr" "setting up herdr"
if [ "$(uname)" == "Darwin" ]; then
	brew install fzf herdr
elif [ "${DISTRO:-}" = "fedora" ]; then
	sudo dnf install -y fzf
	curl -fsSL https://herdr.dev/install.sh | sh
else
	sudo apt install -y fzf
	curl -fsSL https://herdr.dev/install.sh | sh
fi

log_step "herdr" "copying config"
mkdir -p ~/.config/herdr
cp ./config.toml ~/.config/herdr/config.toml

log_step "herdr" "running setup of 'base' workspace"
setup_herdr_base_workspace() {
    if [[ "$(id -u)" -eq 0 ]]; then
        echo "Run Herdr initialization as the target user, not root." >&2
        return 1
    fi

    command -v herdr >/dev/null 2>&1 || {
        log_err "Error: herdr is not installed or not on PATH." >&2
        return 1
    }

    command -v jq >/dev/null 2>&1 || {
        log_err "Error: jq is required for Herdr initialization." >&2
        return 1
    }

    local workspace_json=""
    local base_id=""
    local attempt=0

    # Query the existing server first.
    if ! workspace_json="$(herdr workspace list 2>/dev/null)"; then
        log_step "herdr" "Starting Herdr's headless server for initial setup..."

        nohup herdr server </dev/null >/dev/null 2>&1 &

        # Wait for the server to accept CLI requests.
        while (( attempt < 50 )); do
            if workspace_json="$(herdr workspace list 2>/dev/null)"; then
                break
            fi

            sleep 0.2
            attempt=$((attempt + 1))
        done
    fi

    if [[ -z "$workspace_json" ]]; then
        log_err "Error: Herdr server did not become available." >&2
        return 1
    fi

    # Find a workspace called "base", if one already exists.
    base_id="$(
        jq -r '
            [.result.workspaces[]?
              | select(.label == "base")
              | .workspace_id][0] // empty
        ' <<< "$workspace_json"
    )" || return 1

    if [[ -n "$base_id" ]]; then
        log_step "herdr" "workspace 'base' already exists; preserving focus."
        return 0
    fi

    # Create and focus base only on initial setup.
    herdr workspace create \
        --cwd "$HOME" \
        --label "base" \
        --focus
}

setup_herdr_base_workspace
