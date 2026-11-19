# Contributing

Issues and pull requests are welcome.

1. Fork and create a branch.
2. Keep the script POSIX-friendly Bash and pass `make lint` (ShellCheck).
3. Never add forced unmounts (`-f`, `-l`, `kill`): the project's promise is that it never forces anything.
4. Test with a real USB drive and describe how in the PR.

Ideas: support for Nemo / Thunar / Caja / Dolphin, more translations, KDE support.
