# Makefile aspell-gaeilge
ASPELLDATA=/usr/local/aspell
ASPELLFLAGS=--dict-dir=$(ASPELLDATA)/dict --data-dir=$(ASPELLDATA)/data
ASPELL=/usr/local/bin/aspell $(ASPELLFLAGS)
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

personal: FORCE
	mv $(HOME)/.aspell.gaeilge.pws $(HOME)/.aspell.gaeilge.pws.old
	$(ASPELL) --lang=gaeilge create personal $(HOME)/.aspell.gaeilge.pws < proper

sounds.txt: FORCE
	$(ASPELL) --lang=gaeilge soundslike < $(RAWWORDS) > sounds.txt

clean distclean:
	rm -f gaeilge sounds.txt

FORCE:
