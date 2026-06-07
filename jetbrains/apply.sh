#!/usr/bin/env bash

# Install the IdeaVim config so JetBrains IDEs pick it up on launch.
# JetBrains Toolbox / IDEs themselves are not installed here — the user
# handles that out-of-band.

cp ./.ideavimrc "$HOME/.ideavimrc"

exit 0
