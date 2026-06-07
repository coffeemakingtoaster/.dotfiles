#!/usr/bin/env bash

set -euo pipefail

# shellcheck source=../lib/log.sh
. "$(dirname "$0")/../lib/log.sh"
log_init

# Install the IdeaVim config so JetBrains IDEs pick it up on launch.
# JetBrains Toolbox / IDEs themselves are not installed here — the user
# handles that out-of-band.

log_step "jetbrains" "copying .ideavimrc"
cp ./.ideavimrc "$HOME/.ideavimrc"
