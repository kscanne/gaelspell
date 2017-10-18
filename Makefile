# Makefile ispell-gaeilge
# INSTALLATION=gaeilgemor
# INSTALLATION=gaeilgelit
INSTALLATION=gaeilge
ISPELLDIR=/usr/lib/ispell
ISPELLBIN=/usr/bin
INSTALL=/usr/bin/install
SHELL=/bin/sh
MAKE=/usr/bin/make
GALLPERSONAL=aitiuil eachtar gall giorr gno romhanach
GAELPERSONAL=daoine logainm miotas.txt stair.txt treise
PERSONAL=$(GALLPERSONAL) $(GAELPERSONAL)

#   Shouldn't have to change anything below here
RELEASE=4.8
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
	LC_ALL=C $(SORT) $(RAWWORDS) $(PERSONAL) | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ/-]" | iconv -f UTF-8 -t iso-8859-1 > gaeilge.focail
	iconv -f UTF-8 -t iso-8859-1 $(AFFIXFILE) > tempaff.txt
	$(ISPELLBIN)/buildhash gaeilge.focail tempaff.txt gaeilge.hash
	rm -f gaeilge.focail tempaff.txt

gaeilgelit.hash: $(RAWWORDS) $(LITWORDS) gaeilgelit.aff $(PERSONAL)
	LC_ALL=C $(SORT) $(RAWWORDS) $(LITWORDS) $(PERSONAL) | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ/-]" | iconv -f UTF-8 -t iso-8859-1 > gaeilge.focail
	iconv -f UTF-8 -t iso-8859-1 gaeilgelit.aff > tempaff.txt
	$(ISPELLBIN)/buildhash gaeilge.focail tempaff.txt gaeilgelit.hash
	rm -f gaeilge.focail tempaff.txt

gaeilgemor.hash: $(RAWWORDS) $(LITWORDS) $(ALTWORDS) $(ALTAFFIXFILE) $(PERSONAL)
	LC_ALL=C $(SORT) $(RAWWORDS) $(LITWORDS) $(ALTWORDS) $(PERSONAL) | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ/-]" | iconv -f UTF-8 -t iso-8859-1 > gaeilge.focail
	iconv -f UTF-8 -t iso-8859-1 $(ALTAFFIXFILE) > tempaff.txt
	$(ISPELLBIN)/buildhash gaeilge.focail tempaff.txt gaeilgemor.hash
	rm -f gaeilge.focail tempaff.txt

$(ALTAFFIXFILE): $(AFFIXFILE) gaeilgemor.diff
	patch -o gaeilgemor.aff gaeilge.aff < gaeilgemor.diff

# "personal" file used in gramadoir-ga "lexfromdb", that's all
personal: biobla $(PERSONAL)
	sort -u $(PERSONAL) > ./personal
	rm -f $(HOME)/.ispell_$(INSTALLATION)
	LC_ALL=C sort -u biobla | iconv -f UTF-8 -t iso-8859-1 > $(HOME)/.ispell_$(INSTALLATION)

gaeilgelit.aff: $(AFFIXFILE)
	cp $(AFFIXFILE) gaeilgelit.aff

install: $(INSTALLATION).hash $(INSTALLATION).aff
	$(INSTALL_DATA) $(INSTALLATION).hash $(ISPELLDIR)
	iconv -f UTF-8 -t iso-8859-1 $(INSTALLATION).aff > tempaff.txt
	$(INSTALL_DATA) tempaff.txt $(ISPELLDIR)/$(INSTALLATION).aff
	rm -f tempaff.txt

installall: gaeilge.hash gaeilgelit.hash gaeilgemor.hash gaeilgelit.aff
	$(INSTALL_DATA) gaeilge.hash $(ISPELLDIR)
	iconv -f UTF-8 -t iso-8859-1 $(AFFIXFILE) > tempaff.txt
	$(INSTALL_DATA) tempaff.txt $(ISPELLDIR)/$(AFFIXFILE)
	$(INSTALL_DATA) gaeilgelit.hash $(ISPELLDIR)
	iconv -f UTF-8 -t iso-8859-1 gaeilgelit.aff > tempaff.txt
	$(INSTALL_DATA) tempaff.txt $(ISPELLDIR)/gaeilgelit.aff
	$(INSTALL_DATA) gaeilgemor.hash $(ISPELLDIR)
	iconv -f UTF-8 -t iso-8859-1 $(ALTAFFIXFILE) > tempaff.txt
	$(INSTALL_DATA) tempaff.txt $(ISPELLDIR)/$(ALTAFFIXFILE)
	rm -f tempaff.txt

clean:
	rm -f *.cnt *.stat *.bak *.tar *.tar.gz *.zip *.tar.bz2 gaeilge sounds.txt repl aspellrev.txt IG2.* EN.temp IG.missp IG.temp IG.temp2 personal accents.txt ga-*dictionary.xpi *.oxt mimetype SentenceExceptList.xml WordExceptList.xml DocumentList.xml acor_ga-IE.dat validalts.txt ga_inclusion.txt ga_corpus.txt a.tmp seanghaeilge.dic README_ga-Latg-IE.txt README_ga_IE.txt gaelspell.txt caighdean.txt gaeilge.dic ga-media-freq.txt ga_corpus-utf8.txt ga-word-freq.txt ga-freq.txt ga-phrases-freq.txt ga_inclusion-utf8.txt twitter-survey.txt gaelspellalt-ascii.txt gaelspell-anything.txt gaelspellalt.txt text-freq.txt ga-phrases.txt README_hyph_ga_IE.txt README_th_ga_IE_v2.txt hyph_ga_IE.dic th_ga_IE_v2.dat th_ga_IE_v2.idx

# Clean back to what gets packaged up in an ispell-gaeilge tarball
# So don't wipe out generated ChangeLog, giorr, romhanach, etc.
# See veryclean, maintainer-clean below
distclean:
	$(MAKE) clean
	rm -f *.hash aspell.txt aspelllit.txt aspellalt.txt ga_IE.dic gaeilgelit.aff $(ALTAFFIXFILE) ga_IE.aff gaelu ga-Latg-IE.dic ga-Latg-IE.aff

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
MYSPELL=/usr/bin/hunspell

gaeilgehyph.hash: gaeilge.hyp gaeilgehyph.aff
	iconv -f UTF-8 -t iso-8859-1 gaeilge.hyp > temphyp
	iconv -f UTF-8 -t iso-8859-1 gaeilgehyph.aff > tempaff.txt
	$(ISPELLBIN)/buildhash temphyp tempaff.txt gaeilgehyph.hash
	rm -f temphyp tempaff.txt

gaeilgemor.diff:
	(diff -u $(AFFIXFILE) $(ALTAFFIXFILE) > gaeilgemor.diff; echo)

# clean everything not tracked in version control.
# So, distclean PLUS kill files that are makeable
# from backend database
veryclean:
	$(MAKE) distclean
	rm -f miotas.txt stair.txt romhanach ChangeLog giorr athfhocail-pre.txt gaeilge-pre.mor

# clean a few files that are in version control, but which I generate
# from the backend database periodically
maintainer-clean:
	$(MAKE) veryclean
	rm -f athfhocail gaeilge.raw gaeilge.lit gaeilge.mor

# GNU sort ignores "/" so words don't come out in correct alphabetical
# order, which is desirable for readability and clean CVS logs
GOODSORT=bash ./isort

# flip BH for historical compat, clean CVS
# note that gaeilge.mor is not complete after this - in "groom"
# I also add words from *alts.txt files to it (see gaeilge.mor target)
# Need to do this after athfhocail and aspellalt.txt have been
# regenerated.  Gin 7 generates the three gaeilge.* files.
# Note that the files Gin 7 creates are ISO-8859-1 and don't have
# a trailing newline; call to "utf" and the sort process fix those issues
gaeilge.raw gaeilge.lit gaeilge-pre.mor: ${HOME}/math/code/data/Dictionary/IG
	$(GIN) 7
	utf gaeilge.raw gaeilge.lit gaeilge.mor
	sed -i 's/\/BH/\/HB/' gaeilge.raw gaeilge.lit gaeilge.mor
	$(GOODSORT) $(RAWWORDS) > tempfile
	mv tempfile $(RAWWORDS)
	$(GOODSORT) gaeilge.lit > tempfile
	mv tempfile gaeilge.lit
	$(GOODSORT) gaeilge.mor > gaeilge-pre.mor

gaeilge.mor: gaeilge-pre.mor dinneenalts.txt fgbalts.txt myalts.txt riaalts.txt
	cat gaeilge-pre.mor | sed 's/\/.*//' > headwordtemp.txt
	(cat gaeilge-pre.mor; cat dinneenalts.txt fgbalts.txt myalts.txt riaalts.txt | sed 's/ .*//' | keepif -n headwordtemp.txt | LC_ALL=C sort -u) > $@
	rm -f headwordtemp.txt
	$(GOODSORT) $(ALTWORDS) > tempfile
	mv tempfile $(ALTWORDS)

athfhocail-pre.txt: ${HOME}/math/code/data/Dictionary/IG
	$(GIN) 10
	mv -f athfhocail $@
	utf $@
	egrep "^m'[^ ]+ ([BbCcDdFfGgMmPpTt][^']|[Ss][aeiouáéíóúlnr])[^ ]+$$" $@ | LC_ALL=C sort -u | sed "s/^.'\([^ ]*\) \(.*\)$$/\/^m'\1 \2$$\/s\/ \\\\(.\\\\)\/ mo \\\\1h\/\n\/^d'\1 \2$$\/s\/ \\\\(.\\\\)\/ do \\\\1h\/\n\/^b'\1 \2$$\/s\/ \\\\(.\\\\)\/ ba \\\\1h\//" > cleanup.sed
	egrep "^m'[^ ]+ ([HhJjKkLlNnRr]|[Ss][^aeiouáéíóúlnr])[^ ]+$$" $@ | LC_ALL=C sort -u | sed "s/^.'\([^ ]*\) \(.*\)$$/\/^m'\1 \2$$\/s\/ \/ mo \/\n\/^d'\1 \2$$\/s\/ \/ do \/\n\/^b'\1 \2$$\/s\/ \/ ba \//" >> cleanup.sed
	cat $@ | egrep "^.[^'][^ ]+ m'" | sed "s/ m'/ d'/" > tokill.txt
	cat $@ | keepif -n tokill.txt | egrep -v "^.[^'][^ ]+ [bm]'" | sed -f cleanup.sed > tempfile
	rm -f cleanup.sed tokill.txt
	mv -f tempfile $@

# must keep sort this way so "join" works in gramadoir-ga makefile...
athfhocail: athfhocail-pre.txt dinneenalts.txt fgbalts.txt myalts.txt riaalts.txt
	LC_ALL=C sort -u athfhocail-pre.txt dinneenalts.txt fgbalts.txt myalts.txt riaalts.txt | LC_ALL=C sort -k1,1 > $@

giorr : giorr.in
	cat giorr.in | sed 's/ .*//' | sort -f | sort -u > $@

# giorr done above
# don't sort apost since that causes rebuild of aposttodo.txt for caighdean
sortpersonal: FORCE
	LC_ALL=C sort -u aitiuil | LC_ALL=C sort -f > tempfile
	mv tempfile aitiuil
	LC_ALL=C sort -u daoine | LC_ALL=C sort -f > tempfile
	mv tempfile daoine
	LC_ALL=C sort -u eachtar | LC_ALL=C sort -f > tempfile
	mv tempfile eachtar
	LC_ALL=C sort -u gall | LC_ALL=C sort -f > tempfile
	mv tempfile gall
	LC_ALL=C sort -u gno | LC_ALL=C sort -f > tempfile
	mv tempfile gno
	LC_ALL=C sort -u logainm | LC_ALL=C sort -f > tempfile
	mv tempfile logainm
	LC_ALL=C sort -u miotas | LC_ALL=C sort -f > tempfile
	mv tempfile miotas
	LC_ALL=C sort -u stair | LC_ALL=C sort -f > tempfile
	mv tempfile stair
	LC_ALL=C sort -u treise | LC_ALL=C sort -f > tempfile
	mv tempfile treise
	LC_ALL=C sort -u gaelu.in | LC_ALL=C sort -f > tempfile
	mv tempfile gaelu.in
	LC_ALL=C sort -u earraidi | LC_ALL=C sort -f > tempfile
	mv tempfile earraidi
	LC_ALL=C sort -u uimhreacha | LC_ALL=C sort -f > tempfile
	mv tempfile uimhreacha
	LC_ALL=C sort -u myalts.txt | LC_ALL=C sort -f > tempfile
	mv tempfile myalts.txt
	LC_ALL=C sort -u riaalts.txt | LC_ALL=C sort -f > tempfile
	mv tempfile riaalts.txt

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
	sed 's/^[^ ]* //' earraidi | tr " " "\n" | keepif -n ./a.tmp | egrep -v '^[0-9]' | sort -u
#	sed 's/^[^ ]* //' athfhocail | tr " " "\n" | keepif -n ./a.tmp | sort -u
	sed 's/^[^ ]* //' gaelu | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ-]" | keepif -n ./a.tmp | sort -u
	rm -f a.tmp

gaelu: gaelu.in buildgael miotas stair
	bash buildgael > gaelu

$(HOME)/gaeilge/diolaim/comp/gaelu: gaelu
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
aspell.txt: $(RAWWORDS) gaeilge.hash
	cat $(RAWWORDS) | iconv -f UTF-8 -t iso-8859-1 | $(ISPELLBIN)/ispell -d./gaeilge -e3 | iconv -f iso-8859-1 -t UTF-8 | tr " " "\n" | egrep -v '\/' | sort -u > $@

aspelllit.txt: $(RAWWORDS) $(LITWORDS) gaeilgelit.hash
	cat $(RAWWORDS) $(LITWORDS) | iconv -f UTF-8 -t iso-8859-1 | $(ISPELLBIN)/ispell -d./gaeilgelit -e3 | iconv -f iso-8859-1 -t UTF-8 | tr " " "\n" | egrep -v '\/' | sort -u > $@

aspellalt.txt: $(RAWWORDS) $(LITWORDS) $(ALTWORDS) gaeilgemor.hash
	cat $(RAWWORDS) $(LITWORDS) $(ALTWORDS) | iconv -f UTF-8 -t iso-8859-1 | $(ISPELLBIN)/ispell -d./gaeilgemor -e3 | iconv -f iso-8859-1 -t UTF-8 | tr " " "\n" | egrep -v '\/' | sort -u > $@

# (1) generate all words by unmunching hunspell dic/aff
# and be sure they're all in aspell.txt (i.e. gen. by ispell affix file)
# (2) generate all words w/ ispell affix file and be sure hunspell
# .dic/.aff pair accepts them
# (3) If (1) and (2) pass, then aspell.txt is the same for ispell/hunspell.  
# Convert that file to poncanna, and be sure ga-Latg .dic/.aff accept 'em all
aspelltest: ga_IE.dic ga_IE.aff aspell.txt personal
	unmunch ./ga_IE | keepif -n aspell.txt | keepif -n personal
	cat aspell.txt | $(MYSPELL) -d ./ga_IE -l
	cat aspell.txt | perl ~/gaeilge/ocr/toponc.pl | $(MYSPELL) -d ./ga-Latg-IE -l

# Scrabble3D
# No poncanna, like the "official" rules
gaeilge.dic: aspell.txt
	(echo '[Header]'; echo "Version=$(RELEASE)"; echo 'Author=Kevin Scannell'; echo 'StandardCategory=GaelSpell'; echo 'Licence=GNU GPLv2'; echo "Comment=This is Kevin Scannell's GaelSpell Irish word list"; echo '[Categories]'; echo '[Words]'; cat aspell.txt | egrep '..' | egrep -v '[A-ZÁÉÍÓÚ]' | tr 'a-záéíóú' 'A-ZÁÉÍÓÚ' | egrep -v "[JKQVWXYZ'-]") > $@

scrabble-heads.txt: ${HOME}/seal/ig7
	cat ${HOME}/seal/ig7 | egrep '^[a-záéíóú][^ ]+\.' | sed 's/\..*//' 

# poncanna, but also "free" H's at beginning, FORHALLA, etc.
#	(echo '[Header]'; echo "Version=$(RELEASE)"; echo 'Author=Kevin Scannell'; echo 'StandardCategory=unknown'; echo 'Licence=GNU GPLv2'; echo "Comment=This is Kevin Scannell's GaelSpell Irish word list"; echo '[Categories]'; echo '[Words]'; cat aspell.txt | egrep -v '[A-ZÁÉÍÓÚ]' | tr 'a-záéíóú' 'A-ZÁÉÍÓÚ' | egrep -v "[JKQVWXYZ'-]" | sed 's/BH/Ḃ/g; s/CH/Ċ/g; s/DH/Ḋ/g; s/FH/Ḟ/g; s/GH/Ġ/g; s/MH/Ṁ/g; s/PH/Ṗ/g; s/SH/Ṡ/g; s/TH/Ṫ/g') > $@
# For poncanna and no free h's at all:
seanghaeilge.dic: aspell.txt
	(echo '[Header]'; echo "Version=$(RELEASE)"; echo 'Author=Kevin Scannell'; echo 'StandardCategory=GaelSpell'; echo 'Licence=GNU GPLv2'; echo "Comment=This is Kevin Scannell's GaelSpell Irish word list"; echo '[Replace]'; echo 'Ḃ=BH'; echo 'Ċ=CH'; echo 'Ḋ=DH'; echo 'Ḟ=FH'; echo 'Ġ=GH'; echo 'Ṁ=MH'; echo 'Ṗ=PH'; echo 'Ṡ=SH'; echo 'Ṫ=TH'; echo '[Categories]'; echo '[Words]'; cat aspell.txt | egrep '..' | egrep -v '[A-ZÁÉÍÓÚ]' | tr 'a-záéíóú' 'A-ZÁÉÍÓÚ' | egrep -v "[JKQVWXYZ'-]" | egrep -v '^H' | egrep -v '[^BCDFGMPST]H' | sed 's/BH/Ḃ/g; s/CH/Ċ/g; s/DH/Ḋ/g; s/FH/Ḟ/g; s/GH/Ġ/g; s/MH/Ṁ/g; s/PH/Ṗ/g; s/SH/Ṡ/g; s/TH/Ṫ/g') > $@

# these aspell functions are unimplemented according to K.A. 7/2/03
repl: athfhocail earraidi gaelu
	(echo "personal_repl-1.1 ga 0 utf-8"; sort -u athfhocail earraidi gaelu) > $@
	cp -f $@ $(HOME)/.aspell.ga.prepl

installweb: FORCE
	$(INSTALL_DATA) index.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) index-en.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) cuidiu.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) sonrai.html $(HOME)/public_html/ispell
	$(INSTALL_DATA) sios.html $(HOME)/public_html/ispell

dist: FORCE
	$(MAKE) ChangeLog stair.txt miotas.txt romhanach giorr
	sed '/development only/,$$d' ./Makefile > makefile
	chmod 644 $(AFFIXFILE) gaeilgemor.diff $(RAWWORDS) $(LITWORDS) $(ALTWORDS) COPYING README ChangeLog makefile aitiuil biobla daoine eachtar gall giorr gno logainm miotas.txt romhanach stair.txt treise makefile
	chmod 755 igcheck
	ln -s gaelspell ../$(APPNAME)
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
	tar rvhf $(TARFILE) -C .. $(APPNAME)/treise
	gzip $(TARFILE)
	rm -f ../$(APPNAME)
	rm -f makefile

# relies on fact that H affix always immediately follows the slash :/
# though see "obainn" - one exception
ga-Latg-IE.dic: $(RAWWORDS)
	(cat $(RAWWORDS) $(GAELPERSONAL) latecaps | perl ${HOME}/gaeilge/ocr/toponc.pl; cat $(GALLPERSONAL)) > $@
	sed -i "1s/.*/`cat $@ | wc -l`\n&/" $@

ga-Latg-IE.aff: ga_IE.aff
	cat ga_IE.aff | sed 's/WORDCHAR/WORDC{H}AR/' | perl ${HOME}/gaeilge/ocr/toponc.pl | sed '/^SFX/s/\[\^h/[^ḃċḋḟġṁṗṡṫ/' > $@

ga_IE.dic: $(RAWWORDS) $(PERSONAL) latecaps
	rm -f $@
	$(GOODSORT) $(RAWWORDS) $(PERSONAL) latecaps > $@
	sed -i "1s/.*/`cat $@ | wc -l`\n&/" $@

ga_IE.aff: $(AFFIXFILE) myspell-header hunspell-header
	cat myspell-header hunspell-header > myspelltemp.txt
	./ispellaff2myspell --charset=latin1 gaeilge.aff --myheader myspelltemp.txt | sed 's/""/0/' | sed '40,$$s/"//g' | perl -p -e 's/^PFX S( +)([a-z])( +)[a-z]h( +)[a-z](.*)/print "PFX S$$1$$2$$3$$2h$$4$$2$$5\nPFX S$$1\u$$2$$3\u$$2h$$4\u$$2$$5";/e' | sed 's/S Y 9$$/S Y 18/' | sed 's/\([]A-Z]\)1$$/\1/' > $@
	rm -f myspelltemp.txt

ga-Latg-IE-dictionary.xpi: ga-Latg-IE.dic ga-Latg-IE.aff README_ga-Latg-IE.txt
	make-exts ga-Latg-IE Irish Ireland $(RELEASE) 'GaelSpell Seanchló'

mycheck: ga_IE.dic aspell.txt ga_IE.aff personal
	cat aspell.txt personal | $(MYSPELL) -l -d ./ga_IE

README_ga_IE.txt: README COPYING
	(echo; echo "1. Version"; echo; echo "This is version $(RELEASE) of hunspell-gaeilge."; echo; echo "2. Copyright"; echo; cat README; echo; echo "3. Copying"; echo; cat COPYING) > README_ga_IE.txt

README_ga-Latg-IE.txt: README_ga_IE.txt
	cp -f README_ga_IE.txt $@

#  * Don't want to use local make-exts since it doesn't package up
#    the thesaurus and hyphenation patterns in xx_YY-pack or .oxt...
# creates old ga_IE.zip and ga_IE-pack.zip for OOo (now defunct, Summer 2008)
# also creates xpi for Mozilla programs - filenames must be ga.* 
# for the spell checker to appear localized in context menu
# Summer 2008: now creates oxt installable extension for OOo also
# Back to rebuilding hyphenation.  Used to just grab from:	wget http://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/hyph_ga_IE.zip
#	wget http://ftp.services.openoffice.org/pub/OpenOffice.org/contrib/dictionaries/thes_ga_IE_v2.zip
mydist: ga_IE.dic README_ga_IE.txt ga_IE.aff install.rdf
	rm -f thes.txt hyph_ga_IE.zip ga_IE.zip
	rm -Rf dictionaries
	(cd ${HOME}/gaeilge/fleiscin/fleiscin; make hyph_ga_IE.zip)
	cp -f ${HOME}/gaeilge/fleiscin/fleiscin/hyph_ga_IE.zip .
	(cd ${HOME}/gaeilge/roget/teasaras; make thes_ga_IE_v2.zip)
	cp -f ${HOME}/gaeilge/roget/teasaras/thes_ga_IE_v2.zip .
	chmod 644 ga_IE.dic ga_IE.aff README_ga_IE.txt
	zip ga_IE ga_IE.dic ga_IE.aff README_ga_IE.txt
	chmod 644 ga_IE.zip
	echo 'ga,IE,hyph_ga_IE,Irish (Ireland),hyph_ga_IE.zip' > hyph.txt
	echo 'ga,IE,ga_IE,Irish (Ireland),ga_IE.zip' > spell.txt
	echo 'ga,IE,thes_ga_IE_v2,Irish (Ireland),thes_ga_IE_v2.zip' > thes.txt
	zip ga_IE-pack ga_IE.zip hyph.txt hyph_ga_IE.zip spell.txt thes.txt thes_ga_IE_v2.zip
	mkdir dictionaries
	cp ga_IE.dic dictionaries/ga.dic
	cp ga_IE.aff dictionaries/ga.aff
	cp README_ga_IE.txt dictionaries
	zip -r ga-IE-dictionary.xpi dictionaries install.rdf
	rm -Rf hyph.txt spell.txt thes.txt META-INF dictionaries
	mkdir META-INF
	cp manifest.xml META-INF
	chmod 644 META-INF/manifest.xml
	rm -f hyph_ga_IE.dic th_ga_IE_v2.dat th_ga_IE_v2.idx README_hyph_ga_IE.txt README_th_ga_IE_v2.txt
	unzip hyph_ga_IE.zip
	unzip thes_ga_IE_v2.zip
	sed -i '/<version value=/s/.*/    <version value="$(RELEASE)" \/>/' description.xml
	rm -f focloiri-gaeilge-$(RELEASE).oxt
	zip -r focloiri-gaeilge-$(RELEASE).oxt ga_IE.aff ga_IE.dic description.xml dictionaries.xcu hyph_ga_IE.dic META-INF th_ga_IE_v2.dat th_ga_IE_v2.idx LICENSES-en.txt CEADUNAIS-ga.txt
	rm -Rf dictionaries META-INF


mimetype:
	touch $@
	
SentenceExceptList.xml: ${HOME}/gaeilge/gramadoir/gr/ga/giorr-ga.txt
	echo '<?xml version="1.0" encoding="UTF-8"?>' > $@
	echo >> $@
	echo '<block-list:block-list xmlns:block-list="http://openoffice.org/2001/block-list">' >> $@
	cat ${HOME}/gaeilge/gramadoir/gr/ga/giorr-ga.txt | iconv -f iso-8859-1 -t UTF-8 | sed 's/\[.\(.\)\]/\1/' | sed 's/.*/ <block-list:block block-list:abbreviated-name="&."\/>/' >> $@
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

# filter stuff in here out when looking for new words in a corpus;
# see twitter-survey for example...
gaelspell-anything.txt: gaelspellalt.txt gaelspellalt-ascii.txt uimhreacha
	cat gaelspellalt.txt gaelspellalt-ascii.txt uimhreacha | LC_ALL=C sort -u > $@

# used in building gaelspell-anything, in turn used to mine new words
gaelspellalt-ascii.txt: gaelspellalt.txt
	cat gaelspellalt.txt | tolow | toascii > $@

# This is the main word list input for Adaptxt!!
gaelspellalt.txt: ga-phrases.txt teacs.txt uimhreacha aspellalt.txt $(PERSONAL)
	LC_ALL=C sort -u ga-phrases.txt teacs.txt uimhreacha aspellalt.txt $(PERSONAL) > $@

# Main word list for Diarmaid
gaelspell.txt: aspell.txt $(PERSONAL)
	LC_ALL=C sort -u aspell.txt $(PERSONAL) > $@

# clean word list for Caighdeánaitheoir "clean.txt"
# used to just use gaelspell.txt but I wanted aspelllit.txt words too
caighdean.txt: aspelllit.txt $(PERSONAL) uimhreacha
	sort -u aspelllit.txt $(PERSONAL) uimhreacha > $@

gaelspell.zip: gaelspell.txt COPYING README
	zip $@ gaelspell.txt COPYING README

CORPUS=${HOME}/gaeilge/diolaim
ga-word-freq.txt: ga-phrases.txt
	(cat ga-phrases.txt; find ${CORPUS} -type f | egrep 'gaeilge/diolaim/[ln]/' | xargs cat | sed 's/[#@][A-Za-z0-9áéíóúÁÉÍÓÚ_-]*//g') | togail ga token | egrep '[A-Za-záéíóúÁÉÍÓÚ]' | LC_ALL=C sort | LC_ALL=C uniq -c | LC_ALL=C sort -n -r | sed 's/^ *//' > $@

# not used
ga-media-freq.txt:
	find ${CORPUS} -type f | egrep '/(Blaganna|Twitter)' | xargs cat | sed 's/[#@][A-Za-z0-9áéíóúÁÉÍÓÚ_-]*//g' | togail ga token | egrep '[A-Za-záéíóúÁÉÍÓÚ]' | LC_ALL=C sort | LC_ALL=C uniq -c | LC_ALL=C sort -n -r > $@

ga-phrases-freq.txt:
	egrep '^[^.]+ ' ${HOME}/seal/ig7 | egrep -v '\. v' | egrep -v '^([Aa]n|[Nn]a) ' | sed 's/\..*//' | sort -u | while read x; do echo `find ${CORPUS} -type f | egrep 'gaeilge/diolaim/[ln]/' | xargs egrep "$$x" | egrep "\b$${x}\b" | wc -l` $$x; done > $@

ga-phrases.txt: ga-phrases-freq.txt
	cat ga-phrases-freq.txt | egrep -v '^0' | sed 's/^[0-9]* //' > $@

ga-freq.txt: ga-word-freq.txt ga-phrases-freq.txt
	cat ga-word-freq.txt ga-phrases-freq.txt | LC_ALL=C sort -k1,1 -r -n > $@

# just for curiosity
text-freq.txt:
	cat teacs.txt | while read x; do echo `find ${CORPUS} -type f | egrep 'gaeilge/diolaim/[ln]/' | xargs egrep "$$x" | egrep "\b$${x}\b" | wc -l` $$x; done > $@

adaptxt-ga.zip: ga_inclusion.txt ga_corpus.txt
	zip $@ ga_inclusion.txt ga_corpus.txt

ga_corpus.txt: ga_corpus-utf8.txt
	iconv -f UTF-8 -t UCS-2LE ga_corpus-utf8.txt > $@

ga_inclusion.txt: ga_inclusion-utf8.txt
	iconv -f UTF-8 -t UCS-2LE ga_inclusion-utf8.txt > $@

#CLEANFREQ=/usr/local/share/crubadan/ga/CLEANFREQ
#CLEANFREQ=ga-media-freq.txt
CLEANFREQ=ga-freq.txt
HUNSPELLGD=${HOME}/seal/hunspell-gd
ga_inclusion-utf8.txt ga_corpus-utf8.txt: gaelspellalt.txt $(CLEANFREQ)
	perl $(HUNSPELLGD)/toadaptxt.pl ga gaelspellalt.txt $(CLEANFREQ)

twitter-survey.txt: gaelspell-anything.txt ${CORPUS}/l/Twitter
	cat ${CORPUS}/l/Twitter | sed 's/[#@][A-Za-z0-9áéíóúÁÉÍÓÚ_-]*//g' | sed 's/http[^ ]*//g' | togail ga token | egrep '[A-Za-záéíóúÁÉÍÓÚ]' | keepif -n gaelspell-anything.txt | LC_ALL=C sort | LC_ALL=C uniq -c | LC_ALL=C sort -r -n > $@

adist: aspell.txt repl ChangeLog
	LC_ALL=C sort -u aspell.txt $(PERSONAL) latecaps > a.tmp
	chmod 644 a.tmp README README.aspell gaeilge_phonet.dat info repl gaeilge.dat
	cp -f README $(ASPELLDEV)/Copyright
	cp -f README.aspell $(ASPELLDEV)/doc/README
	iconv -f UTF-8 -t iso-8859-1 gaeilge_phonet.dat > $(ASPELLDEV)/ga_phonet.dat
	iconv -f UTF-8 -t iso-8859-1 a.tmp > $(ASPELLDEV)/aspell.txt
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

# used to just run "svn2cl"
ChangeLog : FORCE
	echo 'Full history available from https://github.com/kscanne/gaelspell/commits/master' > $@

sounds.txt: FORCE
	$(ASPELL) --lang=ga soundslike < aspell.txt > sounds.txt

aspellrev.txt: aspell.txt
	cat aspell.txt | perl -p -e 's/(.*)/reverse $$1/e;' | sort | perl -p -e 's/(.*)/reverse $$1/e;' > aspellrev.txt 

FORCE:
