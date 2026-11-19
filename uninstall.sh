#!/bin/bash
# Removes the files installed by install.sh.
set -eu
rm -f "${HOME}/.local/bin/safe-eject" "${HOME}/.local/share/applications/safe-eject.desktop"
command -v update-desktop-database >/dev/null && update-desktop-database "${HOME}/.local/share/applications" || true
echo "Removed."
