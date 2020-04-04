#!/bin/bash
# Usage: bash test.sh
#
# This assumes groom has recently been run so
# all necessary generated files are present...

# one arg is the error message
# pipe the erroneous lines through here
testout() {
	sed "s/^/Error (${1}): /"
}

# First, check file syntaxes
# most files are just single words
egrep -v "^[A-Za-z'-]+" ainm-b ainm-f aitiuil bioblabeag ceol daoine dinneenok.txt eachtar gall gallainm-b gallainm-f giorr gno latecaps lit logainm romhanach treise | testout 'should only be single words'
# a few include replacements
egrep -v "^[A-Za-z'-]+( [A-Za-z'-]+)+" apost dinneenalts.txt earraidi fgbalts.txt gaelu.in myalts.txt riaalts.txt | egrep -v '^earraidi:ladh 1ú$' | testout 'should only be word and replacement'
# and a few allow affix flags
egrep -v "^[A-Za-z'-]+(/[A-Z]+)?$" gaeilge.raw biobla gaeilge.lit gaeilge.mor | testout 'should only be word and affix flags'
# apost entries really should have leading or trailing aposts!
cat apost | egrep -v "^'" | egrep -v "^[^ ]*' " | testout 'missing leading or trailing apostrophe'
# other files should *not* have leading or trailing aposts
egrep "(^['-]|['-]$)" ainm-b ainm-f aitiuil bioblabeag ceol daoine dinneenok.txt eachtar gall gallainm-b gallainm-f giorr gno latecaps lit logainm romhanach treise | testout 'unwanted leading or trailing apostrophe'
# including in replacements...
egrep " '" apost dinneenalts.txt earraidi fgbalts.txt gaelu.in myalts.txt riaalts.txt | testout 'unwanted leading apostrophe in replacement'
egrep " .+'( |$)" apost dinneenalts.txt earraidi fgbalts.txt gaelu.in myalts.txt riaalts.txt | testout 'unwanted trailing apostrophe in replacement'
# many are comprised of proper names, so almost all will include a capital
egrep -v '[A-Z]' ainm-? aitiuil bioblabeag ceol daoine gall gallainm-? gno lit logainm | egrep -v '^gall:van$' | testout 'missing capital letter'
egrep -v '^([hnt][AEIOUÁÉÍÓÚ]|mB|gC|n[DG]|bhF|bP|tS|dT)' latecaps | testout 'late capital letter missing'
# miotas/stair include the usual English in many cases, followed by a colon
egrep -v "^[A-Za-z'-]*:[A-Za-z'-]+$" miotas stair | testout 'malformed line in miotas or stair'
# romhanach of course has special constraints
egrep -v '^[IVXLCDM]+$' romhanach | testout 'incorrect Roman numeral'
# might as well test teacs.txt even though not included in spellcheckers
# uimhreacha is more important since it's included in caighdean
egrep -v "^[A-Za-z0-9'-]+" teacs.txt uimhreacha | testout 'should only be single words, numbers OK'
# LHS of everything in earraidi/apost MUST be a misspelling
# (if not, say for pairs like "coip cóip", it should go in myalts.txt)
# Happens to be true for dinneenalts.txt too, at least for now
cat apost dinneenalts.txt earraidi | sed 's/ .*//' | keepif aspell.txt | egrep '..' | testout 'LHS in a replacement file is correct word'
# RHS of everything in earraidi MUST be correct!
# could try this with other replacement files but they have too many
# right-hand sides not (yet?) in IG or the proper name files...
sed 's/^[^ ]* //' earraidi | tr " " "\n" | keepif -n gaelspell.txt | keepif -n aspelllit.txt | egrep -v '^(ad|droch|1ú|Meith)$' | testout 'RHS in earraidi is not a known-correct word'
# latecaps is a maintained file which is just a bunch of correct mutated
# words from aspell with a late cap in their uppercase form; this test
# checks that they all come from something in gaelspell.txt, noting that
# keepif is smart enough to handle lowercasing of eclipsis but not h-
cat latecaps | sed 's/^hA/ha/; s/^hE/he/; s/^hI/hi/; s/^hO/ho/; s/^hU/hu/; s/^hÁ/há/; s/^hÉ/hé/; s/^hÍ/hí/; s/^hÓ/hó/; s/^hÚ/hú/' | keepif -n gaelspell.txt | testout 'not uppercase version of known-correct word in latecaps'
#### Test API clients ####
# no guarantee latest version is on cadhan; this, plus the limit
# on query size and not wanting to overload the server means we'll
# be satisfied with this rough test that the thing's at least working
TESTSTR='Ní mé an ar Áit an Phuint nó na gCúig Déag atá mé curtha? ... Is mise Stoc na Cille. Éistear le mo ghlór! Caithfear éisteacht ... Óir is mé gach glór dá raibh, dá bhfuil agus dá mbeidh. Ba mé an chéad ghlór in éagruth na cruinne.'
echo "${TESTSTR}" | python ${HOME}/gaeilge/apianna/gaelspell/client.py | testout 'unwanted output from Python client'
echo "${TESTSTR}" | perl ${HOME}/gaeilge/apianna/gaelspell/client.pl | testout 'unwanted output from Perl client'
#### Test locally-built spellcheckers ####
cat gaelspell.txt | hunspell -l -d ./ga_IE | testout 'correct word reported as wrong by hunspell'
cat gaelspell.txt | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ-]" | iconv -f UTF-8 -t iso-8859-1 | ispell -d./gaeilge -l | iconv -f iso-8859-1 -t UTF-8 | testout 'correct word reported as wrong by ispell'
# aspell?
TMPFILE=`mktemp`
cat earraidi | sed 's/ .*//' | hunspell -l -d ./ga_IE > ${TMPFILE}
# hunspell buggy ATM??
#cat earraidi | sed 's/ .*//' | keepif -n "${TMPFILE}" | testout 'known-bad word NOT reported as error by hunspell' 
cat earraidi | sed 's/ .*//' | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ-]" | iconv -f UTF-8 -t iso-8859-1 | ispell -d./gaeilge -l | iconv -f iso-8859-1 -t UTF-8 > ${TMPFILE}
cat earraidi | sed 's/ .*//' | egrep '..' | LC_ALL=C grep -v "[^'a-zA-ZáéíóúÁÉÍÓÚ-]" | keepif -n "${TMPFILE}" | testout 'known-bad word NOT reported as error by ispell' 
cat "${TMPFILE}" | 
rm -f "${TMPFILE}"
#### isolate rare trigrams and grep for them ####
touch oktrigrams.txt trigram-worries.txt
cat aspell.txt | sed 's/\/.*//' | sed 's/./\L\0/g' | sed 's/^/^/' | sed 's/$$/$$/' | tr "\n" "_" | sed 's/./&\n/g' | ngramify.pl 3 | tr -d " " | egrep -v '_' | keepif -n oktrigrams.txt | sort -u |
while read x
do
	echo "$x" `egrep -i -- "$x" aspell.txt | tr "\n" " "` | sed 's/ / | /'
done > trigram-worries-new.txt
if diff -u trigram-worries.txt trigram-worries-new.txt
then
	rm -f trigram-worries-new.txt
fi
exit 1
#### IGCHECK RUNS on various input files ####
#bash igcheck aspell.txt
bash igcheck daoine
bash igcheck ainm-b
bash igcheck ainm-f
bash igcheck logainm
bash igcheck miotas.txt
bash igcheck stair.txt
bash igcheck treise
