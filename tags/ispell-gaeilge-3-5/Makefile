# Makefile ispell-gaeilge
# INSTALLATION=gaeilgemor
# INSTALLATION=gaeilgelit
INSTALLATION=gaeilge
ISPELLDIR=/usr/lib/ispell
ISPELLBIN=/usr/bin
INSTALL=/usr/bin/install
PERSONAL=aitiuil daoine eachtar gall giorr logainm miotas stair

#   Shouldn't have to change anything below here
SHELL=/bin/sh
RELEASE=3.5
RAWWORDS= gaeilge.raw
LITWORDS= gaeilge.lit
ALTWORDS= gaeilge.mor
HYPHWORDS= gaeilge.hyp
AFFIXFILE= gaeilge.aff
ALTAFFIXFILE=gaeilgemor.aff
APPNAME=ispell-gaeilge-$(RELEASE)
MYAPPNAME=myspell-gaeilge-$(RELEASE)
TARFILE=$(APPNAME).tar
MYTARFILE=$(MYAPPNAME).tar
CODEDIR=$(HOME)/clar/denartha
GIN=$(CODEDIR)/Gin
INSTALL_DATA=$(INSTALL) -m 444
ASPELL=/usr/bin/aspell
MYSPELL=/usr/local/bin/myspell
MAKE=/usr/bin/make
# N.B. ispell "buildhash" only works if the raw word lists are sorted with 
# "sort -f"; GNU sort doesn't collate the "/"'s correctly so you'll need
# to check the output of "$(GOODSORT) gaeilge.raw gaeilge.lit" for example
GOODSORT=isort

hashtable: $(INSTALLATION).hash

all: gaeilge.hash gaeilgelit.hash gaeilgemor.hash gaeilgehyph.hash

gaeilge.hash: $(RAWWORDS) $(AFFIXFILE)
	$(ISPELLBIN)/buildhash $(RAWWORDS) $(AFFIXFILE) gaeilge.hash

gaeilgelit.hash: $(RAWWORDS) $(LITWORDS) gaeilgelit.aff
	$(GOODSORT) $(RAWWORDS) $(LITWORDS) > gaeilge.focail
	$(ISPELLBIN)/buildhash gaeilge.focail gaeilgelit.aff gaeilgelit.hash
	rm -f gaeilge.focail

gaeilgemor.hash: $(RAWWORDS) $(LITWORDS) $(ALTWORDS) $(ALTAFFIXFILE)
	$(GOODSORT) $(RAWWORDS) $(LITWORDS) $(ALTWORDS) > gaeilge.focail
	$(ISPELLBIN)/buildhash gaeilge.focail $(ALTAFFIXFILE) gaeilgemor.hash
	rm -f gaeilge.focail

gaeilgehyph.hash: $(HYPHWORDS) gaeilgehyph.aff
	$(ISPELLBIN)/buildhash $(HYPHWORDS) gaeilgehyph.aff gaeilgehyph.hash

$(ALTAFFIXFILE): $(AFFIXFILE) gaeilgemor.diff
	patch -o gaeilgemor.aff gaeilge.aff < gaeilgemor.diff

personal: $(PERSONAL)
	rm -f $(HOME)/.ispell_$(INSTALLATION) $(HOME)/.biobla
	sort -u $(PERSONAL) | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ-]" > $(HOME)/.ispell_$(INSTALLATION)
	sort -u biobla > $(HOME)/.biobla

personalcheck: $(PERSONAL)
	rm -f $(HOME)/.ispell_$(INSTALLATION)_check $(HOME)/.biobla
	sort -u $(PERSONAL) > $(HOME)/.ispell_$(INSTALLATION)_check
	sort -u biobla > $(HOME)/.biobla

gaeilgelit.aff: $(AFFIXFILE)
	cp $(AFFIXFILE) gaeilgelit.aff

install: $(INSTALLATION).hash $(INSTALLATION).aff
	$(INSTALL_DATA) $(INSTALLATION).hash $(ISPELLDIR)
	$(INSTALL_DATA) $(INSTALLATION).aff $(ISPELLDIR)

installall: gaeilge.hash gaeilgelit.hash gaeilgemor.hash gaeilgelit.aff gaeilgehyph.hash
	$(INSTALL_DATA) gaeilge.hash $(ISPELLDIR)
	$(INSTALL_DATA) $(AFFIXFILE) $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgelit.hash $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgelit.aff $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgemor.hash $(ISPELLDIR)
	$(INSTALL_DATA) $(ALTAFFIXFILE) $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgehyph.hash $(ISPELLDIR)
	$(INSTALL_DATA) gaeilgehyph.aff $(ISPELLDIR)

clean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.full gaeilge sounds.txt gaeilgelit.aff ga.cwl repl pearsanta $(ALTAFFIXFILE)

distclean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.full gaeilge sounds.txt gaeilgelit.aff ga.cwl repl pearsanta
	rm -f *.hash aspell.txt aspelllit.txt aspellalt.txt ga.dic
	rm -f IG.temp EN.temp

#############################################################################
### Remainder is for development only
#############################################################################

gaeilgemor.diff:
	(diff -c $(AFFIXFILE) $(ALTAFFIXFILE) > gaeilgemor.diff; echo)

fromdb : FORCE
	$(GIN) 7
	$(MAKE) sort
	$(MAKE) all

athfromdb : FORCE
	$(GIN) 10
	LC_COLLATE=POSIX sort -u athfhocail | LC_COLLATE=ga_IE sort -k1,1 > tempfile
	mv -f tempfile athfhocail

sort: FORCE
	$(GOODSORT) $(RAWWORDS) > tempfile
	mv tempfile $(RAWWORDS)
	$(GOODSORT) $(LITWORDS) > tempfile
	mv tempfile $(LITWORDS)
	$(GOODSORT) $(ALTWORDS) > tempfile
	mv tempfile $(ALTWORDS)

sortpersonal: FORCE
	sort -f aitiuil > tempfile
	mv tempfile aitiuil
	sort -f daoine > tempfile
	mv tempfile daoine
	sort -f eachtar > tempfile
	mv tempfile eachtar
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
	sort -f gaelu.in > tempfile
	mv tempfile gaelu.in
	sort -f earraidi > tempfile
	mv tempfile earraidi

checkearr: FORCE
	sed 's/^[^ ]* //' earraidi | ispell -dgaeilge -l

gaelu: gaelu.in
	bash buildgael > gaelu

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

# these aspell function are unimplemented according to K.A. 7/2/03
apersonal: $(PERSONAL)
	(echo "personal_repl-1.1 ga 0"; cat athfhocail) > repl
	(echo "personal_ws-1.1 ga 0"; sort -u $(PERSONAL)) > pearsanta
	cp -f repl $(HOME)/.aspell.ga.prepl
	cp -f pearsanta $(HOME)/.aspell.ga.pws
#	rm -f $(HOME)/.aspell.ga.rpl
#	cat athfhocail | $(ASPELL) --lang=ga create repl $(HOME)/.aspell.ga.rpl
#	rm -f $(HOME)/.aspell.ga.per
#	sort -u $(PERSONAL) | $(ASPELL) --lang=ga create personal $(HOME)/.aspell.ga.per < tempwords 

installweb: FORCE
	$(INSTALL_DATA) index.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) index-en.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) sonrai.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) sios.html $(HOME)/public_html/ispell

dist: FORCE
	$(MAKE) ChangeLog
	chmod 644 $(AFFIXFILE) gaeilgemor.diff $(RAWWORDS) $(LITWORDS) $(ALTWORDS) COPYING README ChangeLog Makefile aitiuil biobla daoine eachtar gall giorr logainm miotas stair
	chmod 755 igcheck
	ln -s ispell-gaeilge ../$(APPNAME)
	tar cvhf $(TARFILE) -C .. $(APPNAME)/$(AFFIXFILE) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/gaeilgemor.diff
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(RAWWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(LITWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(ALTWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/COPYING
	tar rvhf $(TARFILE) -C .. $(APPNAME)/ChangeLog
	tar rvhf $(TARFILE) -C .. $(APPNAME)/README
	tar rvhf $(TARFILE) -C .. $(APPNAME)/Makefile
	tar rvhf $(TARFILE) -C .. $(APPNAME)/aitiuil
	tar rvhf $(TARFILE) -C .. $(APPNAME)/biobla
	tar rvhf $(TARFILE) -C .. $(APPNAME)/daoine
	tar rvhf $(TARFILE) -C .. $(APPNAME)/eachtar
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

ga.aff: $(AFFIXFILE)
	ispellaff2myspell --charset=latin1 gaeilge.aff --myheader myspell-header | sed 's/""/0/' | sed '40,$$s/"//g' | perl -p -e 's/^PFX S( +)([a-z])( +)[a-z]h( +)[a-z](.*)/print "PFX S$$1$$2$$3$$2h$$4$$2$$5\nPFX S$$1\u$$2$$3\u$$2h$$4\u$$2$$5";/e' | sed 's/S Y 9$$/S Y 18/' | sed 's/\([]A-Z]\)1$$/\1/' > ga.aff

mycheck: ga.dic aspell.txt ga.aff
	- $(MYSPELL) ga.aff ga.dic aspell.txt | egrep 'incorrect'

README_ga_IE.txt: README COPYING
	(echo; echo "1. Version"; echo; echo "2. Copyright"; echo; cat README; echo; echo "3. Copying"; echo; cat COPYING) > README_ga_IE.txt

mydist: ga.dic README_ga_IE.txt ga.aff
	chmod 644 ga.dic ga.aff README_ga_IE.txt
	zip ga_IE ga.dic ga.aff README_ga_IE.txt

mytardist: ga.dic ChangeLog
	cp README README.txt
	chmod 644 ga.dic ga.aff COPYING README.txt
	ln -s ispell-gaeilge ../$(MYAPPNAME)
	tar cvhf $(MYTARFILE) -C .. $(MYAPPNAME)/ga.dic
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/ga.aff
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/COPYING
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/ChangeLog
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/README.txt
	gzip $(MYTARFILE)
	rm -f ../$(MYAPPNAME) README.txt

ga.cwl: aspell.txt
	LANG=C; export LANG; cat aspell.txt | sort -u | word-list-compress c > ga.cwl

ASPELLDEV = ${HOME}/gaeilge/gramadoir/ga/aspell

adist: aspell.txt apersonal ChangeLog
	chmod 644 aspell.txt README README.aspell gaeilge_phonet.dat info pearsanta repl gaeilge.dat
	cp -f README $(ASPELLDEV)/Copyright
	cp -f README.aspell $(ASPELLDEV)/doc/README
	cp -f gaeilge_phonet.dat $(ASPELLDEV)/ga_phonet.dat
	cp -f aspell.txt $(ASPELLDEV)
	cp -f info $(ASPELLDEV)
	cp -f pearsanta $(ASPELLDEV)/doc
	cp -f repl $(ASPELLDEV)/doc
	cp -f ChangeLog $(ASPELLDEV)/doc
	cp -f gaeilge.dat $(ASPELLDEV)/ga.dat
	aspellproc ga
	mv ${ASPELLDEV}/*.bz2 .

ChangeLog : FORCE
	cvs2cl.pl

sounds.txt: FORCE
	$(ASPELL) --lang=ga soundslike < aspell.txt > sounds.txt

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
