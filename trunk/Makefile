# Makefile ispell-gaeilge

ISPELLDIR=/usr/local/lib
ISPELLBIN=/usr/local/bin
MAKE=/usr/local/bin/make
RELEASE=1.0
RAWWORDS= gaeilge.raw
ALTWORDS= gaeilge.mor
AFFIXFILE= gaeilge.aff
HASHFILE= gaeilge.hash
APPNAME=ispell-gaeilge-$(RELEASE)
TARFILE=$(APPNAME).tar

beag: $(RAWWORDS) $(AFFIXFILE)
	$(ISPELLBIN)/buildhash $(RAWWORDS) $(AFFIXFILE) $(HASHFILE)

mor: $(RAWWORDS) $(ALTWORDS) $(AFFIXFILE)
	sort -f $(RAWWORDS) $(ALTWORDS) > gaeilge.focail
	$(ISPELLBIN)/buildhash gaeilge.focail $(AFFIXFILE) $(HASHFILE)
	rm gaeilge.focail

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
	cat $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 | wc -l

full:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 > gaeilge.full
	cat $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 > gaeilge2.full

tarfile: 
	$(MAKE) reallyclean
	ln -s ispell-gaeilge ../$(APPNAME)
	tar cvhf $(TARFILE) -C .. $(APPNAME)/$(AFFIXFILE) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(RAWWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(ALTWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/COPYING
	tar rvhf $(TARFILE) -C .. $(APPNAME)/README
	tar rvhf $(TARFILE) -C .. $(APPNAME)/Makefile
	gzip $(TARFILE)
	rm ../$(APPNAME)

install: $(HASHFILE)
	cp $(HASHFILE) $(ISPELLDIR)
	cp $(AFFIXFILE) $(ISPELLDIR)
	$(MAKE) reallyclean
