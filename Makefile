# Makefile ispell-gaeilge
# INSTALLATION=gaeilgemor
INSTALLATION=gaeilge
ISPELLDIR=/usr/local/lib
ISPELLBIN=/usr/local/bin
MAKE=/usr/ccs/bin/make
RELEASE=1.1
RAWWORDS= gaeilge.raw
ALTWORDS= gaeilge.mor
AFFIXFILE= gaeilge.aff
ALTAFFIXFILE=gaeilgemor.aff
APPNAME=ispell-gaeilge-$(RELEASE)
TARFILE=$(APPNAME).tar

hashtable: $(INSTALLATION).hash

all: gaeilge.hash gaeilgemor.hash

gaeilge.hash: $(RAWWORDS) $(AFFIXFILE)
	$(ISPELLBIN)/buildhash $(RAWWORDS) $(AFFIXFILE) gaeilge.hash

gaeilgemor.hash: $(RAWWORDS) $(ALTWORDS) $(ALTAFFIXFILE)
	sort -f $(RAWWORDS) $(ALTWORDS) > gaeilge.focail
	$(ISPELLBIN)/buildhash gaeilge.focail $(ALTAFFIXFILE) gaeilgemor.hash
	rm -f gaeilge.focail

clean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.full

reallyclean:
	$(MAKE) clean
	rm -f *.hash

#munch:
#	$(ISPELLBIN)/munchlist -v -l $(AFFIXFILE) $(RAWWORDS) > tempfile
#	mv tempfile $(RAWWORDS)

sort:
	sort -f $(RAWWORDS) > tempfile
	mv tempfile $(RAWWORDS)
	sort -f $(ALTWORDS) > tempfile
	mv tempfile $(ALTWORDS)

count:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 | wc -l

altcount:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 | wc -l
	cat $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 | wc -l

full:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 > gaeilge.full

altfull:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 > gaeilge.full
	cat $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 > gaeilge2.full

personal:
	rm -f $(HOME)/.ispell_gaeilge
	sort -f daoine gall giorr logainm miotas stair > $(HOME)/.ispell_gaeilge
	cp biobla $(HOME)/.biobla

tarfile: 
	$(MAKE) reallyclean
	ln -s ispell-gaeilge ../$(APPNAME)
	tar cvhf $(TARFILE) -C .. $(APPNAME)/$(AFFIXFILE) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(ALTAFFIXFILE) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(RAWWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(ALTWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/COPYING
	tar rvhf $(TARFILE) -C .. $(APPNAME)/README
	tar rvhf $(TARFILE) -C .. $(APPNAME)/Makefile
	tar rvhf $(TARFILE) -C .. $(APPNAME)/biobla
	tar rvhf $(TARFILE) -C .. $(APPNAME)/daoine
	tar rvhf $(TARFILE) -C .. $(APPNAME)/gall
	tar rvhf $(TARFILE) -C .. $(APPNAME)/giorr
	tar rvhf $(TARFILE) -C .. $(APPNAME)/logainm
	tar rvhf $(TARFILE) -C .. $(APPNAME)/miotas
	tar rvhf $(TARFILE) -C .. $(APPNAME)/stair
	gzip $(TARFILE)
	rm -f ../$(APPNAME)

install: $(INSTALLATION).hash
	cp $(INSTALLATION).hash $(ISPELLDIR)
	cp $(INSTALLATION).aff $(ISPELLDIR)
	$(MAKE) reallyclean

installall: gaeilge.hash gaeilgemor.hash
	cp gaeilge.hash $(ISPELLDIR)
	cp gaeilge.aff $(ISPELLDIR)
	cp gaeilgemor.hash $(ISPELLDIR)
	cp gaeilgemor.aff $(ISPELLDIR)
	$(MAKE) reallyclean
