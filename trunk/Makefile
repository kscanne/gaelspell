# Makefile ispell-gaeilge
# INSTALLATION=gaeilgemor
# INSTALLATION=gaeilgelit
INSTALLATION=gaeilge
ISPELLDIR=/usr/lib/ispell
ISPELLBIN=/usr/bin
INSTALL=/usr/bin/install
SHELL=/bin/sh
MAKE=/usr/bin/make
PERSONAL=aitiuil daoine eachtar gall giorr gno logainm miotas.txt romhanach stair.txt

#   Shouldn't have to change anything below here
RELEASE=4.4
RAWWORDS= gaeilge.raw
LITWORDS= gaeilge.lit dinneenok.txt
ALTWORDS= gaeilge.mor
AFFIXFILE= gaeilge.aff
ALTAFFIXFILE=gaeilgemor.aff
INSTALL_DATA=$(INSTALL) -m 444

SORT=/usr/bin/sort -u

hashtable: $(INSTALLATION).hash

all: gaeilge.hash gaeilgelit.hash gaeilgemor.hash

# grep -v filters out Malmö, São, LC_ALL=C needed!
gaeilge.hash: $(RAWWORDS) $(AFFIXFILE) $(PERSONAL)
	LC_ALL=C $(SORT) $(RAWWORDS) $(PERSONAL) | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ/-]" | iconv -f utf8 -t iso-8859-1 > gaeilge.focail
	iconv -f utf8 -t iso-8859-1 $(AFFIXFILE) > tempaff.txt
	$(ISPELLBIN)/buildhash gaeilge.focail tempaff.txt gaeilge.hash
	rm -f gaeilge.focail tempaff.txt

gaeilgelit.hash: $(RAWWORDS) $(LITWORDS) gaeilgelit.aff $(PERSONAL)
	LC_ALL=C $(SORT) $(RAWWORDS) $(LITWORDS) $(PERSONAL) | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ/-]" | iconv -f utf8 -t iso-8859-1 > gaeilge.focail
	iconv -f utf8 -t iso-8859-1 gaeilgelit.aff > tempaff.txt
	$(ISPELLBIN)/buildhash gaeilge.focail tempaff.txt gaeilgelit.hash
	rm -f gaeilge.focail tempaff.txt

gaeilgemor.hash: $(RAWWORDS) $(LITWORDS) $(ALTWORDS) $(ALTAFFIXFILE) $(PERSONAL)
	LC_ALL=C $(SORT) $(RAWWORDS) $(LITWORDS) $(ALTWORDS) $(PERSONAL) | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ/-]" | iconv -f utf8 -t iso-8859-1 > gaeilge.focail
	iconv -f utf8 -t iso-8859-1 $(ALTAFFIXFILE) > tempaff.txt
	$(ISPELLBIN)/buildhash gaeilge.focail tempaff.txt gaeilgemor.hash
	rm -f gaeilge.focail tempaff.txt

$(ALTAFFIXFILE): $(AFFIXFILE) gaeilgemor.diff
	patch -o gaeilgemor.aff gaeilge.aff < gaeilgemor.diff

# "personal" file used in gramadoir-ga "lexfromdb", that's all
personal: biobla $(PERSONAL)
	sort -u $(PERSONAL) > ./personal
	rm -f $(HOME)/.ispell_$(INSTALLATION)
	LC_ALL=C sort -u biobla | iconv -f utf8 -t iso-8859-1 > $(HOME)/.ispell_$(INSTALLATION)

gaeilgelit.aff: $(AFFIXFILE)
	cp $(AFFIXFILE) gaeilgelit.aff

install: $(INSTALLATION).hash $(INSTALLATION).aff
	$(INSTALL_DATA) $(INSTALLATION).hash $(ISPELLDIR)
	iconv -f utf8 -t iso-8859-1 $(INSTALLATION).aff > tempaff.txt
	$(INSTALL_DATA) tempaff.txt $(ISPELLDIR)/$(INSTALLATION).aff
	rm -f tempaff.txt

installall: gaeilge.hash gaeilgelit.hash gaeilgemor.hash gaeilgelit.aff
	$(INSTALL_DATA) gaeilge.hash $(ISPELLDIR)
	iconv -f utf8 -t iso-8859-1 $(AFFIXFILE) > tempaff.txt
	$(INSTALL_DATA) tempaff.txt $(ISPELLDIR)/$(AFFIXFILE)
	$(INSTALL_DATA) gaeilgelit.hash $(ISPELLDIR)
	iconv -f utf8 -t iso-8859-1 gaeilgelit.aff > tempaff.txt
	$(INSTALL_DATA) tempaff.txt $(ISPELLDIR)/gaeilgelit.aff
	$(INSTALL_DATA) gaeilgemor.hash $(ISPELLDIR)
	iconv -f utf8 -t iso-8859-1 $(ALTAFFIXFILE) > tempaff.txt
	$(INSTALL_DATA) tempaff.txt $(ISPELLDIR)/$(ALTAFFIXFILE)
	rm -f tempaff.txt

clean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.zip *.tar.bz2 gaeilge sounds.txt repl aspellrev.txt IG2.* EN.temp IG.missp IG.temp IG.temp2 personal accents.txt ga-IE-dictionary.xpi focloiri-gaeilge-*.oxt mimetype SentenceExceptList.xml WordExceptList.xml DocumentList.xml acor_ga-IE.dat validalts.txt

# not giorr, romhanach, etc.  see veryclean
distclean:
	$(MAKE) clean
	rm -f *.hash aspell.txt aspelllit.txt aspellalt.txt ga_IE.dic gaeilgelit.aff $(ALTAFFIXFILE) ga_IE.aff gaelu

#############################################################################
### Remainder is for development only
#############################################################################

APPNAME=ispell-gaeilge-$(RELEASE)
MYAPPNAME=hunspell-gaeilge-$(RELEASE)
TARFILE=$(APPNAME).tar
MYTARFILE=$(MYAPPNAME).tar
CODEDIR=$(HOME)/clar/denartha
GIN=$(CODEDIR)/Gin
ASPELL=/usr/bin/aspell
MYSPELL=/usr/local/bin/hunspell

gaeilgehyph.hash: gaeilge.hyp gaeilgehyph.aff
	iconv -f utf8 -t iso-8859-1 gaeilge.hyp > temphyp
	iconv -f utf8 -t iso-8859-1 gaeilgehyph.aff > tempaff.txt
	$(ISPELLBIN)/buildhash temphyp tempaff.txt gaeilgehyph.hash
	rm -f temphyp tempaff.txt

gaeilgemor.diff:
	(diff -u $(AFFIXFILE) $(ALTAFFIXFILE) > gaeilgemor.diff; echo)

# like "maintainer" clean -- distclean PLUS kill files that are makeable
# from backend database
veryclean:
	$(MAKE) distclean
	rm -f athfhocail gaeilge.raw gaeilge.lit gaeilge.mor miotas.txt stair.txt romhanach README_ga_IE.txt ChangeLog giorr

# flip BH for historical compat, clean CVS
# note that gaeilge.mor is not complete after this - in "groom"
# I also add words from *alts.txt files to it, see "justalts" target
# below - need to do this after athfhocail and aspellalt.txt have been
# regenerated.  Gin 7 generates the three gaeilge.* files.
fromdb : FORCE
	$(GIN) 7
	utf gaeilge.raw gaeilge.lit gaeilge.mor
	sed -i 's/\/BH/\/HB/' gaeilge.raw gaeilge.lit gaeilge.mor
	$(MAKE) sort

# must keep sort this way so "join" works in gramadoir-ga makefile...
athfromdb : FORCE
	$(GIN) 10
	utf athfhocail
	LC_ALL=C sort -u athfhocail dinneenalts.txt fgbalts.txt myalts.txt | LC_ALL=C sort -k1,1 > tempfile
	mv -f tempfile athfhocail

justalts : FORCE
	cat athfhocail | sed 's/ .*//' | keepif -n ./aspellalt.txt | LC_ALL=C sort -u >> $(ALTWORDS)
	$(MAKE) sort
	$(MAKE) all
	$(MAKE) aspellalt.txt
	echo 'Should be no output:'
	cat athfhocail | sed 's/ .*//' | keepif -n ./aspellalt.txt

# GNU sort ignores "/" so words don't come out in correct alphabetical
# order, which is desirable for readability and clean CVS logs
GOODSORT=bash ./isort

sort: FORCE
	$(GOODSORT) $(RAWWORDS) > tempfile
	mv tempfile $(RAWWORDS)
	$(GOODSORT) gaeilge.lit > tempfile
	mv tempfile gaeilge.lit
	$(GOODSORT) $(ALTWORDS) > tempfile
	mv tempfile $(ALTWORDS)

giorr : giorr.in
	cat giorr.in | sed 's/ .*//' | sort -f > $@

# giorr done above
sortpersonal: FORCE
	LC_ALL=C sort -f aitiuil > tempfile
	mv tempfile aitiuil
	LC_ALL=C sort -f daoine > tempfile
	mv tempfile daoine
	LC_ALL=C sort -f eachtar > tempfile
	mv tempfile eachtar
	LC_ALL=C sort -f gall > tempfile
	mv tempfile gall
	LC_ALL=C sort -f gno > tempfile
	mv tempfile gno
	LC_ALL=C sort -f logainm > tempfile
	mv tempfile logainm
	LC_ALL=C sort -f miotas > tempfile
	mv tempfile miotas
	LC_ALL=C sort -f stair > tempfile
	mv tempfile stair
	LC_ALL=C sort -f gaelu.in > tempfile
	mv tempfile gaelu.in
	LC_ALL=C sort -f earraidi > tempfile
	mv tempfile earraidi
	LC_ALL=C sort -f uimhreacha > tempfile
	mv tempfile uimhreacha
	LC_ALL=C sort -f myalts.txt > tempfile
	mv tempfile myalts.txt

stair.txt : stair
	sed 's/^[^:]*://' stair | sort -u > $@

miotas.txt : miotas
	sed 's/^[^:]*://' miotas | sort -u > $@

romhanach : roman.pl
	perl roman.pl > $@

accents.txt : aspell.txt
	comh.pl -a aspell.txt | sed 's/: / /' > accents-a.txt
	counts.pl /usr/local/share/crubadan/ga/FREQ.aimsigh accents-a.txt | perl -p -e '/([^ ]+) ([0-9]+) ([^ ]+) ([0-9]+)$$/; if ($$2 == 0) {$$ans='INF';} else {$$ans=$$4/$$2;} s/^/$$ans /;' | sort -k1,1 -n -r -k5,5 -n -r > $@
	rm -f accents-a.txt

# compare eilefromdb target in gramadoir-ga Makefile
validalts.txt : aspell.txt athfhocail
	sed 's/ .*//' athfhocail | keepif ./aspell.txt | LC_ALL=C sort -u | LC_ALL=C join athfhocail - | LC_ALL=C sort -k1,1 | egrep '^' | egrep -v ' .* ' > ./tempvalid.txt
	counts.pl /usr/local/share/crubadan/ga/FREQ.aimsigh tempvalid.txt | sort -k4,4 -r -n > $@
	rm -f tempvalid.txt

# checks to see if right-hand side of replacements are known-correct words
# athfhocail check is now defunct b/c of fgbalts, dinneenalts - don't
# want to add those right-hand side lists wholesale without careful auditing
checkearr: aspelllit.txt
	$(MAKE) gaelu
	LC_ALL=C sort -u aspelllit.txt $(PERSONAL) > a.tmp
	sed 's/^[^ ]* //' earraidi | tr " " "\n" | keepif -n ./a.tmp | sort -u
#	sed 's/^[^ ]* //' athfhocail | tr " " "\n" | keepif -n ./a.tmp | sort -u
	sed 's/^[^ ]* //' gaelu | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ-]" | keepif -n ./a.tmp | sort -u
	rm -f a.tmp

gaelu: gaelu.in
	bash buildgael > gaelu

$(HOME)/gaeilge/diolaim/comp/gaelu : gaelu
	cat gaelu | sed 's/ .*//' | egrep -n '^' | sed 's/:/: /' > $@-b
	cat gaelu | sed 's/^[^ ]* //' | egrep -n '^' | sed 's/:/: /' > $@

count: aspell.txt
	cat aspell.txt | wc -l

litcount: aspelllit.txt
	cat aspelllit.txt | wc -l

altcount: aspellalt.txt
	cat aspellalt.txt | wc -l

# Gin 9 writes igtemp to current working dir;
# looks a bit like ig7, but no multiword headwords
# ok that it's latin-1 since we just want line count
allcounts: FORCE 
	@$(MAKE) aspell.txt aspelllit.txt aspellalt.txt
	@$(GIN) 9  
	@utf igtemp
	@echo 'Leagan caighdeánach:'
	@egrep '^' igtemp | wc -l
	@rm -f igtemp
	@echo 'ceannfhocal agus'
	@$(MAKE) count
	@echo 'focal infhillte'
	@echo 'Leagan litearta:'
	@$(MAKE) litcount
	@echo 'focal infhillte'
	@echo 'Leagan canúnach:'
	@$(MAKE) altcount
	@echo 'focal infhillte'

# ispell -e3 will only work with latin-1 input 
aspell.txt: gaeilge.hash
	cat $(RAWWORDS) | iconv -f utf8 -t iso-8859-1 | $(ISPELLBIN)/ispell -d./gaeilge -e3 | iconv -f iso-8859-1 -t utf8 | tr " " "\n" | egrep -v '\/' | sort -u > aspell.txt

aspelllit.txt: gaeilgelit.hash
	cat $(RAWWORDS) $(LITWORDS) | iconv -f utf8 -t iso-8859-1 | $(ISPELLBIN)/ispell -d./gaeilgelit -e3 | iconv -f iso-8859-1 -t utf8 | tr " " "\n" | egrep -v '\/' | sort -u > aspelllit.txt

aspellalt.txt: gaeilgemor.hash
	cat $(RAWWORDS) $(LITWORDS) $(ALTWORDS) | iconv -f utf8 -t iso-8859-1 | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 | iconv -f iso-8859-1 -t utf8 | tr " " "\n" | egrep -v '\/' | sort -u > aspellalt.txt

# these aspell functions are unimplemented according to K.A. 7/2/03
apersonal: $(PERSONAL) giorr
	(echo "personal_repl-1.1 ga 0 utf-8"; sort -u athfhocail earraidi gaelu) > repl
	cp -f repl $(HOME)/.aspell.ga.prepl
#	(echo "personal_ws-1.1 ga 0"; sort -u $(PERSONAL)) > pearsanta
#	cp -f pearsanta $(HOME)/.aspell.ga.pws
#	rm -f $(HOME)/.aspell.ga.rpl
#	cat athfhocail | $(ASPELL) --lang=ga create repl $(HOME)/.aspell.ga.rpl
#	rm -f $(HOME)/.aspell.ga.per
#	sort -u $(PERSONAL) | $(ASPELL) --lang=ga create personal $(HOME)/.aspell.ga.per < tempwords 

installweb: FORCE
	$(INSTALL_DATA) index.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) index-en.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) cuidiu.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) sonrai.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) sios.html $(HOME)/public_html/ispell

dist: FORCE
	$(MAKE) ChangeLog stair.txt miotas.txt romhanach giorr
	sed '/development only/,$$d' ./Makefile > makefile
	chmod 644 $(AFFIXFILE) gaeilgemor.diff $(RAWWORDS) $(LITWORDS) $(ALTWORDS) COPYING README ChangeLog makefile aitiuil biobla daoine eachtar gall giorr gno logainm miotas.txt romhanach stair.txt makefile
	chmod 755 igcheck
	ln -s ispell-gaeilge ../$(APPNAME)
	tar cvhf $(TARFILE) -C .. $(APPNAME)/$(AFFIXFILE) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/gaeilgemor.diff
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(RAWWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/gaeilge.lit
	tar rvhf $(TARFILE) -C .. $(APPNAME)/$(ALTWORDS) 
	tar rvhf $(TARFILE) -C .. $(APPNAME)/dinneenok.txt
	tar rvhf $(TARFILE) -C .. $(APPNAME)/COPYING
	tar rvhf $(TARFILE) -C .. $(APPNAME)/ChangeLog
	tar rvhf $(TARFILE) -C .. $(APPNAME)/README
	tar rvhf $(TARFILE) -C .. $(APPNAME)/makefile
	tar rvhf $(TARFILE) -C .. $(APPNAME)/aitiuil
	tar rvhf $(TARFILE) -C .. $(APPNAME)/biobla
	tar rvhf $(TARFILE) -C .. $(APPNAME)/daoine
	tar rvhf $(TARFILE) -C .. $(APPNAME)/eachtar
	tar rvhf $(TARFILE) -C .. $(APPNAME)/gall
	tar rvhf $(TARFILE) -C .. $(APPNAME)/giorr
	tar rvhf $(TARFILE) -C .. $(APPNAME)/gno
	tar rvhf $(TARFILE) -C .. $(APPNAME)/igcheck
	tar rvhf $(TARFILE) -C .. $(APPNAME)/logainm
	tar rvhf $(TARFILE) -C .. $(APPNAME)/miotas.txt
	tar rvhf $(TARFILE) -C .. $(APPNAME)/romhanach
	tar rvhf $(TARFILE) -C .. $(APPNAME)/stair.txt
	gzip $(TARFILE)
	rm -f ../$(APPNAME)
	rm -f makefile

ga_IE.dic: $(RAWWORDS)
	rm -f $@
	$(GOODSORT) $(RAWWORDS) $(PERSONAL) > tempfile
	cat tempfile | wc -l | tr -d " " > tempcount
	cat tempcount tempfile > $@
	rm -f tempfile tempcount

ga_IE.aff: $(AFFIXFILE) myspell-header hunspell-header
	cat myspell-header hunspell-header > myspelltemp.txt
	./ispellaff2myspell --charset=latin1 gaeilge.aff --myheader myspelltemp.txt | sed 's/""/0/' | sed '40,$$s/"//g' | perl -p -e 's/^PFX S( +)([a-z])( +)[a-z]h( +)[a-z](.*)/print "PFX S$$1$$2$$3$$2h$$4$$2$$5\nPFX S$$1\u$$2$$3\u$$2h$$4\u$$2$$5";/e' | sed 's/S Y 9$$/S Y 18/' | sed 's/\([]A-Z]\)1$$/\1/' > ga_IE.aff
	rm -f myspelltemp.txt

mycheck: ga_IE.dic aspell.txt ga_IE.aff
	cat aspell.txt | $(MYSPELL) -l -d ./ga_IE

README_ga_IE.txt: README COPYING
	(echo; echo "1. Version"; echo; echo "This is version $(RELEASE) of hunspell-gaeilge."; echo; echo "2. Copyright"; echo; cat README; echo; echo "3. Copying"; echo; cat COPYING) > README_ga_IE.txt

# creates old ga_IE.zip and ga_IE-pack.zip for OOo (now defunct, Summer 2008)
# also creates xpi for Mozilla programs - filenames must be ga.* 
# for the spell checker to appear localized in context menu
# Summer 2008: now creates oxt installable extension for OOo also
mydist: ga_IE.dic README_ga_IE.txt ga_IE.aff install.rdf install.js
	rm -f thes.txt hyph_ga_IE.zip ga_IE.zip
	rm -Rf dictionaries
	chmod 644 ga_IE.dic ga_IE.aff README_ga_IE.txt
	zip ga_IE ga_IE.dic ga_IE.aff README_ga_IE.txt
	chmod 644 ga_IE.zip
	echo 'ga,IE,hyph_ga_IE,Irish (Ireland),hyph_ga_IE.zip' > hyph.txt
	echo 'ga,IE,ga_IE,Irish (Ireland),ga_IE.zip' > spell.txt
	echo 'ga,IE,thes_ga_IE_v2,Irish (Ireland),thes_ga_IE_v2.zip' > thes.txt
	wget http://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/hyph_ga_IE.zip
	wget http://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/thes_ga_IE_v2.zip
	zip ga_IE-pack ga_IE.zip hyph.txt hyph_ga_IE.zip spell.txt thes.txt thes_ga_IE_v2.zip
	mkdir dictionaries
	cp ga_IE.dic dictionaries/ga.dic
	cp ga_IE.aff dictionaries/ga.aff
	cp README_ga_IE.txt dictionaries
	zip -r ga-IE-dictionary.xpi dictionaries install.rdf install.js
	rm -Rf hyph.txt spell.txt thes.txt META-INF
	mkdir META-INF
	cp manifest.xml META-INF
	chmod 644 META-INF/manifest.xml
	cp hyph_ga_IE.zip dictionaries
	cp thes_ga_IE_v2.zip dictionaries
	(cd dictionaries; unzip hyph_ga_IE.zip; unzip thes_ga_IE_v2.zip; rm -f *.zip; mv ga.dic ga_IE.dic; mv ga.aff ga_IE.aff)
	sed -i '/<version value=/s/.*/    <version value="$(RELEASE)" \/>/' description.xml
	zip -r focloiri-gaeilge-$(RELEASE).oxt dictionaries META-INF description.xml dictionaries.xcu LICENSES-en.txt CEADUNAIS-ga.txt
	rm -Rf dictionaries META-INF


mimetype:
	touch $@
	
SentenceExceptList.xml: ${HOME}/gaeilge/gramadoir/gr/ga/giorr-ga.txt
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	echo >> $@
	echo '<block-list:block-list xmlns:block-list="http://openoffice.org/2001/block-list">' >> $@
	cat ${HOME}/gaeilge/gramadoir/gr/ga/giorr-ga.txt | iconv -f iso-8859-1 -t utf8 | sed 's/\[.\(.\)\]/\1/' | sed 's/.*/ <block-list:block block-list:abbreviated-name="&."\/>/' >> $@
	echo '</block-list:block-list>' >> $@
	
WordExceptList.xml: leadingcaps
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	echo >> $@
	echo '<block-list:block-list xmlns:block-list="http://openoffice.org/2001/block-list">' >> $@
	cat leadingcaps | sed 's/.*/ <block-list:block block-list:abbreviated-name="&"\/>/' >> $@
	echo '</block-list:block-list>' >> $@

DocumentList.xml: earraidi
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	echo >> $@
	echo '<block-list:block-list xmlns:block-list="http://openoffice.org/2001/block-list">' >> $@
	echo ' <block-list:block block-list:abbreviated-name="(C)" block-list:name="©"/>' >> $@
	echo ' <block-list:block block-list:abbreviated-name="(R)" block-list:name="®"/>' >> $@
	cat earraidi | sed 's/^\([^ ]*\) \(.*\)$$/ <block-list:block block-list:abbreviated-name="\1" block-list:name="\2"\/>/' >> $@
	echo '</block-list:block-list>' >> $@

META-INF/manifest.xml: acor-manifest.xml
	rm -Rf META-INF
	mkdir META-INF
	cp acor-manifest.xml META-INF/manifest.xml
	chmod 644 META-INF/manifest.xml

acor_ga-IE.dat: mimetype SentenceExceptList.xml WordExceptList.xml DocumentList.xml META-INF/manifest.xml
	rm -f $@ acor-ga.zip
	zip -r acor-ga.zip mimetype SentenceExceptList.xml WordExceptList.xml DocumentList.xml META-INF
	mv acor-ga.zip $@

# creates hunspell-gaeilge-x.x.tar.gz
mytardist: ga_IE.dic ChangeLog
	cp README README.txt
	chmod 644 ga_IE.dic ga_IE.aff COPYING README.txt
	ln -s ispell-gaeilge ../$(MYAPPNAME)
	tar cvhf $(MYTARFILE) -C .. $(MYAPPNAME)/ga_IE.dic
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/ga_IE.aff
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/COPYING
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/ChangeLog
	tar rvhf $(MYTARFILE) -C .. $(MYAPPNAME)/README.txt
	gzip $(MYTARFILE)
	rm -f ../$(MYAPPNAME) README.txt

ASPELLDEV = ${HOME}/gaeilge/ispell/ga-build

adist: aspell.txt apersonal ChangeLog
	LC_ALL=C sort -u aspell.txt $(PERSONAL) > a.tmp
	chmod 644 a.tmp README README.aspell gaeilge_phonet.dat info repl gaeilge.dat
	cp -f README $(ASPELLDEV)/Copyright
	cp -f README.aspell $(ASPELLDEV)/doc/README
	iconv -f utf8 -t iso-8859-1 gaeilge_phonet.dat > $(ASPELLDEV)/ga_phonet.dat
	iconv -f utf8 -t iso-8859-1 a.tmp > $(ASPELLDEV)/aspell.txt
	cp -f info $(ASPELLDEV)
	cp -f repl $(ASPELLDEV)/doc
	cp -f ChangeLog $(ASPELLDEV)/doc
	cp -f gaeilge.dat $(ASPELLDEV)/ga.dat
	aspellproc ga
	mv ${ASPELLDEV}/*.bz2 .
	rm -f ${ASPELLDEV}/aspell.txt ${ASPELLDEV}/ga_phonet.dat ${ASPELLDEV}/ga.wl
#     no need for aspell6 dictionary - if I do one and use affixes,
#     need to improve the .dat file, see aspell manual for additional fields
#	sed -i '/^mode aspell5/d' $(ASPELLDEV)/info
#	aspellproc ga
#	mv ${ASPELLDEV}/*.bz2 .
#	rm -f a.tmp

ChangeLog : FORCE
	cvs2cl --FSF
	utf ChangeLog

sounds.txt: FORCE
	$(ASPELL) --lang=ga soundslike < aspell.txt > sounds.txt

aspellrev.txt: aspell.txt
	cat aspell.txt | perl -p -e 's/(.*)/reverse $$1/e;' | sort | perl -p -e 's/(.*)/reverse $$1/e;' > aspellrev.txt 

seiceail: FORCE
	$(MAKE) fromdb
	$(MAKE) aspelllit.txt
	$(GIN) 2   # rebuilds Eng-Ir dict.
	$(GIN) 8   # creates local EN.temp, IG.temp
	utf EN.temp IG.temp
	cat IG.temp dinneenok.txt | tr " " "\n" | sort -u > IG.temp2
	diff -w aspelllit.txt IG.temp2 | egrep '^[<>]' > IG.missp
	echo "forms generated by ispell/affix file but not by Dict/IG:"
	-egrep '^<' IG.missp
	egrep '^>' IG.missp | sed 's/^> //' > IG2.txt
	echo "forms generated by Dict/IG but not in ispell/gen. by affix file:"
	cat IG2.txt | gram-ga.pl --ionchod=utf8 --litriu
	rm -f EN.temp EN.temp2 IG.temp2 IG2.txt IG2.mis
#	@$(MAKE) distclean
# the stuff in IG.missp should be mostly be labelled ">", meaning they are 
# words generated by "all_inflections", but hopefully just from compound
# words like "déan a bheag de" where the inflection code isn't done
# and you get "dhéanadar" vs. "rinneadar", etc.
#   Anything with a "<" is more worrisome; these are either 
#   things incorrectly absent from all_inflections (hence Gramadoir)
#   or else unwanted things in ispell generation code (fhuarthas was 
#   discovered this way)

FORCE:
