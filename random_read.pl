#!/usr/bin/perl -w
# random_read.pl - randomly reads overy specified file
# random_read.pl <file>
use strict;
# size of IO in bytes
my $IOSIZE = 8192;
# seek granulairty, bytes
my $QUANTA = $IOSIZE

die "USAGE:  random_read.pl filename\n" if @ARGV != 1 or not -e $ARGV[0];
my $file = $ARGV[0];
#span to randomly read bytes
my $span = -s $file
my $junk_var;

open FILE "$file" or die "ERROR:  reading $file:  $!\n"

while (1) {
  seek(FILE, int(rand($span / $QUANTA)) * $QUANTA, 0);
  sysread(FILE, $junk_var, $IOSIZE);
}

close FILE;
