# Makefile ispell-gaeilge
# INSTALLATION=gaeilgemor
# INSTALLATION=gaeilgelit
INSTALLATION=gaeilge
ISPELLDIR=/usr/local/lib
ISPELLBIN=/usr/local/bin
INSTALL=/usr/local/bin/install
PERSONAL=daoine gall giorr logainm miotas stair

#   Shouldn't have to change anything below here
SHELL=/bin/sh
RELEASE=3.0
RAWWORDS= gaeilge.raw
LITWORDS= gaeilge.lit
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
INSTALL_DATA=$(INSTALL) -m 444
ASPELLDATA=/usr/local/aspell
ASPELLFLAGS=--dict-dir=$(ASPELLDATA)/dict --data-dir=$(ASPELLDATA)/data
ASPELL=/usr/local/bin/aspell $(ASPELLFLAGS)
MYSPELL=/usr/local/bin/myspell
MAKE=/usr/ccs/bin/make

hashtable: $(INSTALLATION).hash

all: gaeilge.hash gaeilgelit.hash gaeilgemor.hash

gaeilge.hash: $(RAWWORDS)
	$(ISPELLBIN)/buildhash $(RAWWORDS) $(AFFIXFILE) gaeilge.hash

gaeilgelit.hash: $(RAWWORDS) $(LITWORDS) gaeilgelit.aff
	sort -f $(RAWWORDS) $(LITWORDS) > gaeilge.focail
	$(ISPELLBIN)/buildhash gaeilge.focail gaeilgelit.aff gaeilgelit.hash
	rm -f gaeilge.focail

gaeilgemor.hash: $(RAWWORDS) $(LITWORDS) $(ALTWORDS) $(ALTAFFIXFILE)
	sort -f $(RAWWORDS) $(LITWORDS) $(ALTWORDS) > gaeilge.focail
	$(ISPELLBIN)/buildhash gaeilge.focail $(ALTAFFIXFILE) gaeilgemor.hash
	rm -f gaeilge.focail

personal: $(PERSONAL)
	rm -f $(HOME)/.ispell_$(INSTALLATION) $(HOME)/.biobla
	sort -u $(PERSONAL) > $(HOME)/.ispell_$(INSTALLATION)
	sort -u biobla > $(HOME)/.biobla

gaeilgelit.aff: $(AFFIXFILE)
	cp $(AFFIXFILE) gaeilgelit.aff

install: $(INSTALLATION).hash $(INSTALLATION).aff
	$(INSTALL_DATA) $(INSTALLATION).hash $(ISPELLDIR)
	$(INSTALL_DATA) $(INSTALLATION).aff $(ISPELLDIR)

installall: gaeilge.hash gaeilgelit.hash gaeilgemor.hash gaeilgelit.aff
	$(INSTALL_DATA) gaeilge.hash $(ISPELLDIR)
	$(INSTALL_DATA) $(AFFIXFILE) $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgelit.hash $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgelit.aff $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgemor.hash $(ISPELLDIR)
	$(INSTALL_DATA) $(ALTAFFIXFILE) $(ISPELLDIR)

clean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.full gaeilge sounds.txt gaeilgelit.aff

distclean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.full gaeilge sounds.txt gaeilgelit.aff
	rm -f *.hash aspell.txt aspelllit.txt aspellalt.txt ga.dic

#############################################################################
### Remainder is for development only
#############################################################################

aspell: aspell.txt
	$(INSTALL_DATA) gaeilge.dat $(ASPELLDATA)/data
	$(INSTALL_DATA) gaeilge_phonet.dat $(ASPELLDATA)/data
	$(ASPELL) --lang=gaeilge create master ./gaeilge < aspell.txt
	$(INSTALL_DATA) gaeilge $(ASPELLDATA)/dict
	rm -f gaeilge

gaeilgemor.diff: FORCE
	diff -e $(AFFIXFILE) $(ALTAFFIXFILE) > gaeilgemor.diff

fromdb : FORCE
	$(GIN) 7
	$(MAKE) sort
	$(MAKE) all

athfromdb : FORCE
	$(GIN) 10
	sort -u athfhocail > tempfile
	mv -f tempfile athfhocail

sort: FORCE
	sort -f $(RAWWORDS) > tempfile
	mv tempfile $(RAWWORDS)
	sort -f $(LITWORDS) > tempfile
	mv tempfile $(LITWORDS)
	sort -f $(ALTWORDS) > tempfile
	mv tempfile $(ALTWORDS)

sortpersonal: FORCE
	sort -f daoine > tempfile
	mv tempfile daoine
	sort -f gall > tempfile
	mv tempfile gall
	sort -f giorr > tempfile
	mv tempfile giorr
	sort -f logainm > tempfile
	mv tempfile logainm
	sort -f miotas > tempfile
	mv tempfile miotas
	sort -f stair > tempfile
	mv tempfile stair

count: aspell.txt
	cat aspell.txt | wc -l

litcount: aspelllit.txt
	cat aspelllit.txt | wc -l

altcount: aspellalt.txt
	cat aspellalt.txt | wc -l

allcounts: FORCE 
	@$(MAKE) aspell.txt aspelllit.txt aspellalt.txt
	@$(GIN) 9
	@echo 'Leagan caighdeánach:'
	@egrep "]:.." igtemp | wc -l
	@echo 'ceannfhocal agus'
	@$(MAKE) count
	@echo 'focal infhillte'
	@echo 'Leagan litearta:'
	@$(MAKE) litcount
	@echo 'focal infhillte'
	@echo 'Leagan canúnach:'
	@$(MAKE) altcount
	@echo 'focal infhillte'
	@rm -f igtemp

full: gaeilge.hash
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 > gaeilge.full

litfull: gaeilgelit.hash
	cat $(RAWWORDS) $(LITWORDS) | $(ISPELLBIN)/ispell -d./gaeilgelit -e3 > gaeilgelit.full

altfull: gaeilgemor.hash
	cat $(RAWWORDS) $(LITWORDS) $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 > gaeilgemor.full

aspell.txt: gaeilge.hash
	cat $(RAWWORDS) | $(ISPELLBIN)/ispell -d./gaeilge -e3 | tr " " "\n" | egrep -v '\/' | sort -u > aspell.txt

aspelllit.txt: gaeilgelit.hash
	cat $(RAWWORDS) $(LITWORDS) | $(ISPELLBIN)/ispell -d./gaeilgelit -e3 | tr " " "\n" | egrep -v '\/' | sort -u > aspelllit.txt

aspellalt.txt: gaeilgemor.hash
	cat $(RAWWORDS) $(LITWORDS) $(ALTWORDS) | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 | tr " " "\n" | egrep -v '\/' | sort -u > aspellalt.txt

apersonal: $(PERSONAL)
	rm -f $(HOME)/.aspell.gaeilge.pws
	sort -u $(PERSONAL) > temp.lst
	$(ASPELL) --lang=gaeilge create personal $(HOME)/.aspell.gaeilge.pws < temp.lst
	rm -f temp.lst
	rm -f $(HOME)/.aspell.gaeilge.prepl
	$(ASPELL) --lang=gaeilge create repl $(HOME)/.aspell.gaeilge.prepl < athfhocail

installweb: FORCE
	$(INSTALL_DATA) index.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) index-en.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) sonrai.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) sios.html $(HOME)/public_html/ispell

dist: FORCE
	chmod 644 $(AFFIXFILE) $(ALTAFFIXFILE) $(RAWWORDS) $(LITWORDS) $(ALTWORDS) COPYING README Makefile biobla daoine gall giorr logainm miotas stair
	chmod 755 igcheck
	ln -s ispell-gaeilge ../$(APPNAME)
	tar cvhf $(TARFILE) -C .. $(APPNAME)/$(AFFIXFILE) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(ALTAFFIXFILE) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(RAWWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(LITWORDS) 
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

ga.dic: $(RAWWORDS)
	rm -f ga.dic
	cat $(RAWWORDS) | wc -l | tr -d " " > tempcount
	cat tempcount $(RAWWORDS) > ga.dic
	rm -f tempcount

mycheck: ga.dic aspell.txt
	- $(MYSPELL) ga.aff ga.dic aspell.txt | egrep 'incorrect'

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
	chmod 644 aspell.txt gaeilge.dat gaeilge_phonet.dat COPYING README proper biobla Makefile info athfhocail
	ln -s ispell-gaeilge ../$(AAPPNAME)
	tar cvhf $(ATARFILE) -C .. $(AAPPNAME)/aspell.txt
	tar rvhf $(ATARFILE) -C .. $(AAPPNAME)/athfhocail
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

seiceail: FORCE
	@cat ../bearla/tcht
	@$(MAKE) fromdb
	@$(MAKE) aspelllit.txt
	@$(GIN) 2   # rebuilds Eng-Ir dict.
	@$(GIN) 8   # creates local EN.temp, IG.temp
	@cat EN.temp | $(ISPELLBIN)/ispell -l | sort -u | egrep -v \' > EN.temp2
	@diff -w EN.temp2 ../bearla/Missp | egrep "<" > EN.missp
	@cat IG.temp | tr " " "\n" | sort -u > IG.temp2
	@diff -w aspelllit.txt IG.temp2 | egrep '^[<>]' | egrep -v '^> [A-ZÁÉÍÓÚ]' > IG.missp
	@rm -f EN.temp EN.temp2 IG.temp IG.temp2
	@$(MAKE) distclean

FORCE:
