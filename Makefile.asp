# Makefile aspell-gaeilge
ASPELL=/usr/local/bin/aspell
ASPELLDATA=/usr/local/aspell
INSTALL=/usr/local/bin/install

#   Shouldn't have to change anything below here
SHELL=/bin/sh
RAWWORDS= aspell.txt
INSTALL_DATA=$(INSTALL) -m 644

all: FORCE
	$(INSTALL_DATA) gaeilge.dat $(ASPELLDATA)/data
	$(INSTALL_DATA) gaeilge_phonet.dat $(ASPELLDATA)/data
	$(ASPELL) --lang=gaeilge create master ./gaeilge < $(RAWWORDS)
	$(INSTALL_DATA) gaeilge $(ASPELLDATA)/dict

distclean:
clean:
	rm -f gaeilge

FORCE:
