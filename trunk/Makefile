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
PERSONAL=daoine gall giorr logainm miotas stair

#   Shouldn't have to change anything below here
SHELL=/bin/sh
RELEASE=2.0
RAWWORDS= gaeilge.raw
ALTWORDS= gaeilge.mor
AFFIXFILE= gaeilge.aff
ALTAFFIXFILE=gaeilgemor.aff
APPNAME=ispell-gaeilge-$(RELEASE)
AAPPNAME=aspell-gaeilge-$(RELEASE)
MYAPPNAME=myspell-gaeilge-$(RELEASE)
TARFILE=$(APPNAME).tar
ATARFILE=$(AAPPNAME).tar
MYTARFILE=$(MYAPPNAME).tar
CODEDIR=$(HOME)/math/code
GIN=$(CODEDIR)/main/Gin
INSTALL_DATA=$(INSTALL) -m 644

hashtable: $(INSTALLATION).hash

all: gaeilge.hash gaeilgemor.hash

gaeilge.hash: $(RAWWORDS)
	$(ISPELLBIN)/buildhash $(RAWWORDS) $(AFFIXFILE) gaeilge.hash

gaeilgemor.hash: $(RAWWORDS) $(ALTWORDS)
	sort -f $(RAWWORDS) $(ALTWORDS) > gaeilge.focail
	$(ISPELLBIN)/buildhash gaeilge.focail $(ALTAFFIXFILE) gaeilgemor.hash
	rm -f gaeilge.focail

aspell: aspell.txt
	$(INSTALL_DATA) gaeilge.dat $(ASPELLDATA)/data
	$(INSTALL_DATA) gaeilge_phonet.dat $(ASPELLDATA)/data
	$(ASPELL) --lang=gaeilge create master ./gaeilge < aspell.txt
	$(INSTALL_DATA) gaeilge $(ASPELLDATA)/dict
	rm -f gaeilge

fromdb : FORCE
	$(GIN) 7
	$(MAKE) sort
	$(MAKE) all

clean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.full gaeilge sounds.txt

distclean:
	$(MAKE) clean
	rm -f *.hash aspell.txt aspellalt.txt ga.dic

sort: FORCE
	sort -f $(RAWWORDS) > tempfile
	mv tempfile $(RAWWORDS)
	sort -f $(ALTWORDS) > tempfile
	mv tempfile $(ALTWORDS)

count: aspell.txt
	cat aspell.txt | wc -l

altcount: aspellalt.txt
	cat aspellalt.txt | wc -l

allcounts: FORCE 
	@$(MAKE) aspell.txt aspellalt.txt
	@$(GIN) 9
	@echo 'Leagan caighdeánach:'
	@grep "]:.." igtemp | wc -l
	@echo 'ceannfhocal agus'
	@$(MAKE) count
	@echo 'focal infhillte'
	@echo 'Leagan canúnach:'
	@cat igtemp | wc -l
	@echo 'ceannfhocal agus'
	@$(MAKE) altcount
	@echo 'focal infhillte'
	@rm -f igtemp

full:
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 > gaeilge.full

altfull:
	cat $(RAWWORDS) $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 > gaeilge.full

aspell.txt: gaeilge.hash
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 | tr " " "\n" | egrep -v '\/' | sort -u > aspell.txt

aspellalt.txt: gaeilgemor.hash
	cat $(RAWWORDS) $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 | tr " " "\n" | egrep -v '\/' | sort -u > aspellalt.txt

personal: $(PERSONAL)
	rm -f $(HOME)/.ispell_gaeilge $(HOME)/.biobla
	sort -u $(PERSONAL) > $(HOME)/.ispell_gaeilge
	sort -u biobla > $(HOME)/.biobla

apersonal: $(PERSONAL)
	rm -f $(HOME)/.aspell.gaeilge.pws
	sort -u $(PERSONAL) > temp.lst
	$(ASPELL) --lang=gaeilge create personal $(HOME)/.aspell.gaeilge.pws < temp.lst
	rm -f temp.lst

dist: FORCE
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

# careful with fuaim until bug is fixed
ga.dic: gaeilge.raw
	rm -f ga.dic
	cat gaeilge.raw | wc -l | tr -d " " > tempcount
	cat tempcount gaeilge.raw > ga.dic
	rm -f tempcount

mydist: ga.dic
	cp README README.txt
	chmod 644 ga.dic ga.aff COPYING README.txt
	ln -s ispell-gaeilge ../$(MYAPPNAME)
	tar cvhf $(MYTARFILE) -C .. $(MYAPPNAME)/ga.dic
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/ga.aff
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/COPYING
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/README.txt
	gzip $(MYTARFILE)
	rm -f ../$(MYAPPNAME) README.txt

adist: FORCE
	sort -u $(PERSONAL) > proper
	mv Makefile Makefile.tmp
	cp Makefile.asp Makefile
	cp README Copyright
	chmod 644 aspell.txt gaeilge.dat gaeilge_phonet.dat COPYING README proper biobla Makefile info
	ln -s ispell-gaeilge ../$(AAPPNAME)
	tar cvhf $(ATARFILE) -C .. $(AAPPNAME)/aspell.txt
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/info
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/gaeilge.dat
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/gaeilge_phonet.dat
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/COPYING
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/Copyright
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/Makefile
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/biobla
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/proper
	gzip $(ATARFILE)
	mv Makefile.tmp Makefile
	rm -f ../$(AAPPNAME) proper Copyright

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

seiceail: FORCE
	@cat ../bearla/tcht
	@$(MAKE) fromdb
	@$(GIN) 2   # rebuilds Eng-Ir dict.
	@$(GIN) 8   # creates local EN.temp, IG.temp
	@cat EN.temp | $(ISPELLBIN)/ispell -l | sort -u | grep -v \' > EN.temp2
	@diff -w EN.temp2 ../bearla/Missp | grep "<" > EN.missp
	@cat IG.temp | $(ISPELLBIN)/ispell -l -d./gaeilge | sort -u > IG.temp2
	@diff -w IG.temp2 ../bearla/Missp.ga | grep "<" > IG.missp
	@rm -f EN.temp EN.temp2 IG.temp IG.temp2
	@$(MAKE) distclean

FORCE:
