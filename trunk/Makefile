# Makefile ispell-gaeilge

ISPELLDIR=/usr/local/lib
ISPELLBIN=/usr/local/bin
MAKE=/usr/local/bin/make
RELEASE=0.2
RAWWORDS= gaeilge.raw
AFFIXFILE= gaeilge.aff
HASHFILE= gaeilge.hash
APPNAME=ispell-gaeilge-$(RELEASE)
TARFILE=$(APPNAME).tar

$(HASHFILE): $(RAWWORDS) $(AFFIXFILE)
	$(ISPELLBIN)/buildhash $(RAWWORDS) $(AFFIXFILE) $(HASHFILE)

clean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.full

reallyclean:
	$(MAKE) clean
	rm -f *.hash

munch:
	$(ISPELLBIN)/munchlist -v -l $(AFFIXFILE) $(RAWWORDS) > tempfile
	mv tempfile $(RAWWORDS)

sort:
	sort -f $(RAWWORDS) > tempfile
	mv tempfile $(RAWWORDS)

count:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 | wc -l

full:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 > gaeilge.full

tarfile: 
	$(MAKE) reallyclean
	ln -s ispell ../$(APPNAME)
	tar cvhf $(TARFILE) -C .. $(APPNAME)/$(AFFIXFILE) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(RAWWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/COPYING
	tar rvhf $(TARFILE) -C .. $(APPNAME)/README
	tar rvhf $(TARFILE) -C .. $(APPNAME)/Makefile
	gzip $(TARFILE)
	rm ../$(APPNAME)

install: $(HASHFILE)
	cp $(HASHFILE) $(ISPELLDIR)
	cp $(AFFIXFILE) $(ISPELLDIR)
	$(MAKE) reallyclean
