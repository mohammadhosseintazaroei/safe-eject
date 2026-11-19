PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
APPDIR ?= $(PREFIX)/share/applications

.PHONY: install uninstall lint

install:
	install -Dm755 safe-eject $(DESTDIR)$(BINDIR)/safe-eject
	sed "s|@BINDIR@|$(BINDIR)|" safe-eject.desktop > safe-eject.desktop.tmp
	install -Dm644 safe-eject.desktop.tmp $(DESTDIR)$(APPDIR)/safe-eject.desktop
	rm -f safe-eject.desktop.tmp

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/safe-eject $(DESTDIR)$(APPDIR)/safe-eject.desktop

lint:
	shellcheck safe-eject install.sh uninstall.sh
	desktop-file-validate safe-eject.desktop
