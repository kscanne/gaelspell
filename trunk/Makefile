# Makefile ispell-gaeilge
# INSTALLATION=gaeilgemor
INSTALLATION=gaeilge
ISPELLDIR=/usr/local/lib
ISPELLBIN=/usr/local/bin
MAKE=/usr/ccs/bin/make
ASPELLDATA=/usr/local/aspell
ASPELLFLAGS=--dict-dir=$(ASPELLDATA)/dict --data-dir=$(ASPELLDATA)/data
ASPELL=/usr/local/bin/aspell $(ASPELLFLAGS)
INSTALL=/usr/local/bin/install

#   Shouldn't have to change anything below here
SHELL=/bin/sh
RELEASE=1.2
RAWWORDS= gaeilge.raw
ALTWORDS= gaeilge.mor
AFFIXFILE= gaeilge.aff
ALTAFFIXFILE=gaeilgemor.aff
APPNAME=ispell-gaeilge-$(RELEASE)
AAPPNAME=aspell-gaeilge-$(RELEASE)
TARFILE=$(APPNAME).tar
ATARFILE=$(AAPPNAME).tar
CODEDIR=$(HOME)/math/code
DATAFILE=$(CODEDIR)/data/Dictionary/IG
GIN=$(CODEDIR)/main/Gin
STRIP=$(CODEDIR)/main/stripdbl
INSTALL_DATA=$(INSTALL) -m 644

hashtable: $(INSTALLATION).hash

all: gaeilge.hash gaeilgemor.hash

gaeilge.hash: FORCE
	$(ISPELLBIN)/buildhash $(RAWWORDS) $(AFFIXFILE) gaeilge.hash

gaeilgemor.hash: FORCE
	sort -f $(RAWWORDS) $(ALTWORDS) > gaeilge.focail
	$(ISPELLBIN)/buildhash gaeilge.focail $(ALTAFFIXFILE) gaeilgemor.hash
	rm -f gaeilge.focail

aspell: FORCE
	$(INSTALL_DATA) gaeilge.dat $(ASPELLDATA)/data
	$(INSTALL_DATA) gaeilge_phonet.dat $(ASPELLDATA)/data
	$(ASPELL) --lang=gaeilge create master ./gaeilge < aspell.txt
	$(INSTALL_DATA) gaeilge $(ASPELLDATA)/dict

fromdb : $(RAWWORDS) $(ALTWORDS)
	$(MAKE) all

$(RAWWORDS) : $(DATAFILE)
	$(GIN) 7
	$(MAKE) sort

$(ALTWORDS) : $(DATAFILE)
	$(GIN) 7
	$(MAKE) sort

clean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.full gaeilge sounds.txt

reallyclean:
	$(MAKE) clean
	rm -f *.hash aspell.txt aspellalt.txt

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

count: aspell.txt
	cat aspell.txt | wc -l

altcount: aspellalt.txt
	cat aspellalt.txt | wc -l

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

aspell.txt: FORCE
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 | tr " " "\n" | egrep -v '\/' | sort | $(STRIP) > aspell.txt

aspellalt.txt: FORCE
	cat $(RAWWORDS) $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 | tr " " "\n" | egrep -v '\/' | sort | $(STRIP) > aspellalt.txt

personal:
	rm -f $(HOME)/.ispell_gaeilge
	sort -f daoine gall giorr logainm miotas stair > $(HOME)/.ispell_gaeilge
	cp biobla $(HOME)/.biobla

apersonal: FORCE
	rm -f $(HOME)/.aspell.gaeilge.pws
	cat daoine gall giorr logainm miotas stair > temp.lst
	$(ASPELL) --lang=gaeilge create personal $(HOME)/.aspell.gaeilge.pws < temp.lst
	rm -f temp.lst

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

adist: 
	chmod 644 aspell.txt gaeilge.dat gaeilge_phonet.dat COPYING README biobla daoine gall giorr logainm miotas stair
	chmod 755 igcheck
	mv Makefile Makefile.tmp
	cp Makefile.asp Makefile
	chmod 644 Makefile
	ln -s ispell-gaeilge ../$(AAPPNAME)
	tar cvhf $(ATARFILE) -C .. $(AAPPNAME)/aspell.txt
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/gaeilge.dat
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/gaeilge_phonet.dat
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/COPYING
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/README
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/Makefile
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/biobla
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/daoine
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/gall
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/giorr
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/igcheck
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/logainm
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/miotas
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/stair
	gzip $(ATARFILE)
	mv Makefile.tmp Makefile
	rm -f ../$(AAPPNAME)

sounds.txt: FORCE
	$(ASPELL) --lang=gaeilge soundslike < aspell.txt > sounds.txt

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
