#!/bin/bash
# Installs safe-eject for the current user only (no sudo needed).
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
BINDIR="${HOME}/.local/bin"
APPDIR="${HOME}/.local/share/applications"

for tool in lsblk udisksctl zenity notify-send fuser; do
  command -v "$tool" >/dev/null || echo "warning: '$tool' not found (needed at runtime)"
done

mkdir -p "$BINDIR" "$APPDIR"
install -m 755 "$HERE/safe-eject" "$BINDIR/safe-eject"
sed "s|@BINDIR@|$BINDIR|" "$HERE/safe-eject.desktop" > "$APPDIR/safe-eject.desktop"
command -v update-desktop-database >/dev/null && update-desktop-database "$APPDIR" || true

echo "Installed. Press Super and search for 'Safe Eject'."
