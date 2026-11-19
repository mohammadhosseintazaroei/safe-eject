# Safe Eject: Nautilus right-click extension

Optional add-on for [Safe Eject](../README.md). It adds a **Safe Eject** entry to
the right-click menu of Files (Nautilus) when you are browsing **inside a USB
drive**.

> The main tool works without this. Install the extension only if you want the
> menu entry. It is installed separately.

## Where the menu entry appears

| Right-click on | Entry shown |
|---|---|
| A file or folder inside a USB drive | Yes |
| Empty space inside a USB drive | Yes |
| The drive icon in the sidebar / Other Locations | **No** (Nautilus does not allow extensions to add items there) |
| Internal disks (SSD, HDD) | No |

## Requirements

- Ubuntu 24.04 / GNOME 46 or newer (Nautilus 4.x API)
- `python3` (preinstalled on Ubuntu) and `python3-nautilus`
- The main `safe-eject` command (installed automatically if missing)

```bash
sudo apt install python3-nautilus
```

## Install

```bash
git clone https://github.com/mohammadhosseintazaroei/safe-eject.git
cd safe-eject/nautilus-extension
./install.sh
nautilus -q          # restart Files so it loads the extension
```

Installs a single file for the current user (no `sudo` except for the apt
package above):

- `~/.local/share/nautilus-python/extensions/safe_eject_menu.py`

## Use

1. Open your USB drive in Files.
2. Right-click a file, a folder, or the empty background.
3. Click **Safe Eject**.
4. Files closes and you get a notification when it is safe to unplug.

## Uninstall

```bash
./uninstall.sh
nautilus -q
```

This removes only the extension. The main `safe-eject` tool stays installed.

## Troubleshooting

**No "Safe Eject" entry.** Check that you are inside a USB drive, that
`python3-nautilus` is installed, and that you restarted Files with
`nautilus -q`. To see load errors run Nautilus from a terminal:

```bash
nautilus -q; nautilus
```

**`Namespace Nautilus not available`.** `python3-nautilus` is missing:
`sudo apt install python3-nautilus`.

**It still says "busy".** The extension only runs `safe-eject`, which never
forces anything; it will tell you which application is holding the drive.

## How it works

The extension asks `findmnt` and `lsblk` whether the current folder is on a disk
with a USB transport. If so it shows the menu item; clicking it launches
`safe-eject` detached from Nautilus (because `safe-eject` quits Nautilus).
