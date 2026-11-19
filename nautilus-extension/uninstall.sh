#!/bin/bash
# Removes the Nautilus extension only (the main safe-eject tool stays).
set -eu
rm -f "${HOME}/.local/share/nautilus-python/extensions/safe_eject_menu.py"
echo "Removed. Restart Files to apply:  nautilus -q"
