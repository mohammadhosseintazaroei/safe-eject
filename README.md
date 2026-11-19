# Safe Eject

[![CI](https://github.com/mohammadhosseintazaroei/safe-eject/actions/workflows/ci.yml/badge.svg)](https://github.com/mohammadhosseintazaroei/safe-eject/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**One-click safe removal of USB drives on Ubuntu / GNOME.**
No more *"Volume is busy"* or *"target is busy"*.

---

## Why

You click **Eject** on an external drive and get:

> Volume is busy — One or more applications are keeping the volume busy.

Very often the application is **Files (Nautilus) itself**. It keeps a handle open on the drive even after you navigate away, so it blocks its own eject. The usual fix (quit Nautilus, unmount, power off) is a chain of terminal commands. Safe Eject does it with one click.

## What it does

1. Quits Nautilus (`nautilus -q`) so it releases the drive.
2. Runs `sync` to flush pending writes.
3. Unmounts every partition of the USB drive (`udisksctl unmount`).
4. Powers the drive off (`udisksctl power-off`) and tells you it is safe to unplug.

### It never forces anything

If something is still using the drive, Safe Eject shows **which application** is holding it and stops. There is no `-f`, no lazy unmount and no `kill`, so you cannot corrupt your data by clicking it.

### Other behavior

- Only drives that report a **USB** transport are considered. Internal disks are never touched.
- If more than one USB drive is mounted, it asks which one to eject.
- Messages are in English, or Persian when your locale starts with `fa`.

## Requirements

Ubuntu or another GNOME-based distribution with:

| Tool | Package (Debian/Ubuntu) |
|---|---|
| `bash`, `lsblk` | `bash`, `util-linux` |
| `udisksctl` | `udisks2` |
| `zenity` | `zenity` |
| `notify-send` | `libnotify-bin` |
| `fuser` | `psmisc` |

A default Ubuntu desktop already has all of them. On a minimal system:

```bash
sudo apt install udisks2 zenity libnotify-bin psmisc util-linux
```

## Install

### Option 1: current user only (recommended, no sudo)

```bash
git clone https://github.com/mohammadhosseintazaroei/safe-eject.git
cd safe-eject
./install.sh
```

Installs:

- `~/.local/bin/safe-eject`
- `~/.local/share/applications/safe-eject.desktop`

Make sure `~/.local/bin` is in your `PATH` if you want to run it from the terminal (Ubuntu adds it automatically after you log in again).

### Option 2: system-wide for all users

```bash
git clone https://github.com/mohammadhosseintazaroei/safe-eject.git
cd safe-eject
sudo make install            # installs under /usr/local
# or choose a prefix:
sudo make install PREFIX=/usr
```

### Option 3: no install, just run

```bash
git clone https://github.com/mohammadhosseintazaroei/safe-eject.git
cd safe-eject
./safe-eject
```

## Usage

### From the desktop (GUI)

1. Plug in your drive and use it as normal.
2. When you are done, press **Super** (Windows key) and type **Safe Eject**, then press Enter.
3. Wait for the notification **"Safe to remove the drive"**, then unplug the cable.

Tip: right-click the icon and choose **Pin to Dash** to keep it one click away.

### From the terminal (CLI)

```bash
safe-eject             # eject the USB drive (asks if there is more than one)
safe-eject --help      # show usage
safe-eject --version   # show version
```

### Optional: keyboard shortcut

GNOME: *Settings → Keyboard → Keyboard Shortcuts → Custom Shortcuts → +*
Name `Safe Eject`, Command `safe-eject` (or `~/.local/bin/safe-eject`), then choose a key combination, for example `Super+E`.

## What you will see

| Situation | Result |
|---|---|
| Everything works | Notification: *Safe to remove the drive* |
| An app is still using the drive | Dialog listing the app. Close it and run again |
| No USB drive mounted | Notification: *No mounted USB drive found* |
| Unmounted but power-off failed | Dialog with the error from `udisksctl` |

## Troubleshooting

**The icon does not show up in search.** Log out and back in, or press `Alt+F2`, type `r` and Enter (X11 only). You can also double-click `~/.local/share/applications/safe-eject.desktop`.

**"target is busy" with an application listed.** Close that application (a terminal `cd`'d into the drive counts too) and run Safe Eject again. It will not force-close anything.

**Nothing happens / no drive found.** Check that the drive is USB and mounted:

```bash
lsblk -o NAME,TRAN,MOUNTPOINTS
```

Only rows whose `TRAN` is `usb` are handled.

**Files windows closed unexpectedly.** Safe Eject quits Nautilus on purpose, because that is the most common reason a drive stays busy. Reopen Files afterwards.

**Other file managers (Nemo, Thunar, Dolphin).** Not handled yet. The script still unmounts, but if your file manager holds the drive you must close it yourself. Contributions are welcome.

## Uninstall

```bash
./uninstall.sh              # if installed with install.sh
sudo make uninstall         # if installed with make install
```

## How it works (for the curious)

```
lsblk (find USB disks with mounted partitions)
  └─ nautilus -q ── release the handle Files keeps on the drive
       └─ sync
            └─ udisksctl unmount -b <partition>   (each partition, no force)
                 └─ udisksctl power-off -b <disk>
```

On failure it uses `fuser -vm <mountpoint>` to tell you which process still holds the drive.

## Contributing

Issues and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md). Run `make lint` (ShellCheck) before opening a PR.

## License

[MIT](LICENSE) © 2026 Mohammad Hossein
