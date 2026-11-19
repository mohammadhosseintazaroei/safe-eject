"""Safe Eject - Nautilus context-menu extension.

Adds a "Safe Eject" entry to the right-click menu whenever you are browsing
inside a USB drive. It simply runs the `safe-eject` command from this project.

Requires: python3-nautilus (Nautilus 4.x API, Ubuntu 24.04 / GNOME 46+).
"""
import os
import shutil
import subprocess

import gi

gi.require_version("Nautilus", "4.0")
from gi.repository import GObject, Nautilus  # noqa: E402


def _safe_eject_cmd():
    found = shutil.which("safe-eject")
    if found:
        return found
    local = os.path.expanduser("~/.local/bin/safe-eject")
    return local if os.access(local, os.X_OK) else None


def _is_usb_path(path):
    """True if `path` lives on a partition whose parent disk is on the USB bus."""
    try:
        src = subprocess.run(
            ["findmnt", "-no", "SOURCE", "-T", path],
            capture_output=True, text=True, timeout=3,
        ).stdout.strip()
        if not src.startswith("/dev/"):
            return False
        parent = subprocess.run(
            ["lsblk", "-no", "PKNAME", src],
            capture_output=True, text=True, timeout=3,
        ).stdout.split()
        disk = "/dev/" + parent[0] if parent else src
        tran = subprocess.run(
            ["lsblk", "-dno", "TRAN", disk],
            capture_output=True, text=True, timeout=3,
        ).stdout.strip()
        return tran == "usb"
    except (OSError, subprocess.SubprocessError, IndexError):
        return False


class SafeEjectExtension(GObject.GObject, Nautilus.MenuProvider):
    def _item(self, path):
        if not path or not _safe_eject_cmd() or not _is_usb_path(path):
            return []
        item = Nautilus.MenuItem(
            name="SafeEject::eject",
            label="Safe Eject",
            tip="Quit Files, sync, unmount and power off this USB drive",
        )
        item.connect("activate", self._on_activate)
        return [item]

    def _on_activate(self, _menu):
        cmd = _safe_eject_cmd()
        if cmd:
            # Detached: safe-eject quits Nautilus, which would kill a child process.
            subprocess.Popen([cmd], start_new_session=True,
                             stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

    def get_file_items(self, files):
        if not files:
            return []
        loc = files[0].get_location()
        return self._item(loc.get_path() if loc else None)

    def get_background_items(self, folder):
        loc = folder.get_location() if folder else None
        return self._item(loc.get_path() if loc else None)
