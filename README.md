# Safe Eject

One-click safe removal of USB drives on Ubuntu / GNOME.

## The problem

You click *Eject* on an external drive and get **"Volume is busy"** or
**"target is busy"**. The culprit is usually the file manager itself: Nautilus
keeps a handle open on the drive even after you navigate away from it, so it
blocks its own eject.

## What it does

Safe Eject runs these steps with a single click:

1. Quits Nautilus (`nautilus -q`) so it releases the drive.
2. Runs `sync` to flush pending writes.
3. Unmounts every partition of the USB drive (`udisksctl unmount`).
4. Powers the drive off (`udisksctl power-off`).

It **never forces anything**. If something is still using the drive, it shows
you which application is holding it and stops, so you never risk corrupting
data.

If more than one USB drive is mounted it asks which one to eject. Messages are
shown in English, or in Persian when your locale is `fa*`.

## Install

```bash
git clone https://github.com/mohammadhosseintazaroei/safe-eject.git
cd safe-eject
./install.sh
```

This installs for the current user only (no `sudo`):

- `~/.local/bin/safe-eject`
- `~/.local/share/applications/safe-eject.desktop`

Then press **Super** and search for **Safe Eject**. Right-click it and choose
*Pin to Dash* to keep it handy.

## Requirements

`bash`, `lsblk`, `udisksctl` (udisks2), `zenity`, `notify-send`, `fuser`
(psmisc). All of these are present on a default Ubuntu desktop install.

## Uninstall

```bash
./uninstall.sh
```

## Notes

- Only drives that report a USB transport are listed, so internal disks are
  never touched.
- Closing Nautilus also closes your open Files windows. That is the price of
  releasing the drive reliably.
- Tested on Ubuntu with GNOME.

## License

MIT
