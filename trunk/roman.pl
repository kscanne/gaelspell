#!/usr/bin/perl

use Roman;


#   Pipe a wordlist through this to look for Roman numerals -- did this
#   with aimsigh.com FREQ Aug 06 to find candidates for addition to gramadoir
#
#while (<>) {
#	chomp;
#	if (/^[A-Z]+$/) {
#		print "$_ = ".arabic($_)."\n" if isroman($_);
#	}
#}

my $i;

for ($i=1; $i <= 150; $i++) {
	print Roman($i)."\n";
}
for ($i=160; $i <= 300; $i += 10) {
	print Roman($i)."\n";
}
for ($i=350; $i <= 1000; $i += 50) {
	print Roman($i)."\n";
}
for ($i=1100; $i <= 3000; $i += 100) {
	print Roman($i)."\n";
}

exit 0;
