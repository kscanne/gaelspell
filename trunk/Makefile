# Makefile ispell-gaeilge
# INSTALLATION=gaeilgemor
INSTALLATION=gaeilge
ISPELLDIR=/usr/local/lib
ISPELLBIN=/usr/local/bin
MAKE=/usr/local/bin/make

#   Shouldn't have to change anything below here
SHELL=/bin/sh
RELEASE=1.1
RAWWORDS= gaeilge.raw
ALTWORDS= gaeilge.mor
AFFIXFILE= gaeilge.aff
ALTAFFIXFILE=gaeilgemor.aff
APPNAME=ispell-gaeilge-$(RELEASE)
TARFILE=$(APPNAME).tar
CODEDIR=$(HOME)/math/code
DATAFILE=$(CODEDIR)/data/Dictionary/IG
GIN=$(CODEDIR)/main/Gin
STRIP=$(CODEDIR)/main/stripdbl
INSTALL=install
INSTALL_DATA=$(INSTALL) -m 644

hashtable: $(INSTALLATION).hash

all: gaeilge.hash gaeilgemor.hash

gaeilge.hash: FORCE
	$(ISPELLBIN)/buildhash $(RAWWORDS) $(AFFIXFILE) gaeilge.hash

gaeilgemor.hash: FORCE
	sort -f $(RAWWORDS) $(ALTWORDS) > gaeilge.focail
	$(ISPELLBIN)/buildhash gaeilge.focail $(ALTAFFIXFILE) gaeilgemor.hash
	rm -f gaeilge.focail

fromdb : $(RAWWORDS) $(ALTWORDS)
	$(MAKE) all

$(RAWWORDS) : $(DATAFILE)
	$(GIN) 7
	$(MAKE) sort

$(ALTWORDS) : $(DATAFILE)
	$(GIN) 7
	$(MAKE) sort

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
	sort -f daoine > tempfile
	mv tempfile daoine
	sort -f gall > tempfile
	mv tempfile gall
	sort -f logainm > tempfile
	mv tempfile logainm
	sort -f miotas > tempfile
	mv tempfile miotas
	sort -f stair > tempfile
	mv tempfile stair

count:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 | wc -l

altcount:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 | wc -l
	cat $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 | wc -l

allcounts:
	@$(GIN) 9
	@echo 'Leagan caighdeánach:'
	grep "]:.." igtemp | wc -l
	@echo 'ceannfhocal agus'
	make count
	@echo 'focal infhillte'
	@echo 'Leagan canúnach:'
	cat igtemp | wc -l
	@echo 'ceannfhocal agus'
	make altcount
	@echo 'focal infhillte'
	@rm -f igtemp

full:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 > gaeilge.full

altfull:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 > gaeilge.full
	cat $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 > gaeilge2.full

personal:
	rm -f $(HOME)/.ispell_gaeilge
	sort -f daoine gall giorr logainm miotas stair > $(HOME)/.ispell_gaeilge
	cp biobla $(HOME)/.biobla

dist: 
	chmod 644 $(AFFIXFILE) $(ALTAFFIXFILE) $(RAWWORDS) $(ALTWORDS) COPYING README Makefile biobla daoine gall giorr logainm miotas stair
	chmod 755 igcheck
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
	tar rvhf $(TARFILE) -C .. $(APPNAME)/igcheck
	tar rvhf $(TARFILE) -C .. $(APPNAME)/logainm
	tar rvhf $(TARFILE) -C .. $(APPNAME)/miotas
	tar rvhf $(TARFILE) -C .. $(APPNAME)/stair
	gzip $(TARFILE)
	rm -f ../$(APPNAME)

install: $(INSTALLATION).hash
	$(INSTALL_DATA) $(INSTALLATION).hash $(ISPELLDIR)
	$(INSTALL_DATA) $(INSTALLATION).aff $(ISPELLDIR)

installall: gaeilge.hash gaeilgemor.hash
	$(INSTALL_DATA) gaeilge.hash $(ISPELLDIR)
	$(INSTALL_DATA) gaeilge.aff $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgemor.hash $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgemor.aff $(ISPELLDIR)

seiceail:
	@cat ../bearla/tcht
	@make fromdb
	@$(GIN) 2   # rebuilds Eng-Ir dict.
	@$(GIN) 8   # creates local EN.temp, IG.temp
	@cat EN.temp | $(ISPELLBIN)/ispell -l | sort | $(STRIP) | grep -v \' > EN.temp2
	@diff -w EN.temp2 ../bearla/Missp | grep "<" > EN.missp
	@cat IG.temp | $(ISPELLBIN)/ispell -l -d./gaeilge | sort | $(STRIP) > IG.temp2
	@diff -w IG.temp2 ../bearla/Missp.ga | grep "<" > IG.missp
	@rm -f EN.temp EN.temp2 IG.temp IG.temp2

FORCE:
