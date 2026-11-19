#!/bin/bash
# Installs the Safe Eject Nautilus right-click extension for the current user.
# This is optional and independent from the main safe-eject tool, but the
# extension needs the `safe-eject` command, so it installs it if missing.
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
EXTDIR="${HOME}/.local/share/nautilus-python/extensions"

if ! python3 -c "import gi; gi.require_version('Nautilus','4.0')" 2>/dev/null; then
  echo "python3-nautilus (Nautilus 4.x) is not installed."
  echo "Install it first, then run this script again:"
  echo "  sudo apt install python3-nautilus"
  exit 1
fi

if ! command -v safe-eject >/dev/null && [ ! -x "${HOME}/.local/bin/safe-eject" ]; then
  echo "Installing the main safe-eject tool first..."
  "$HERE/../install.sh"
fi

mkdir -p "$EXTDIR"
install -m 644 "$HERE/safe_eject_menu.py" "$EXTDIR/safe_eject_menu.py"

echo "Installed. Restart Files to load it:  nautilus -q"
