#!/usr/bin/perl

#
#
# Filters lines with no HTTP, e.g. those that are invalid requests, FTP requests, PROPFIND, etc.
#
# Generate data with
# cat Access.log |  perl ~/weblog.pl > AccessTable.dat
# Or more specifically
#  grep -v 'PhotoAlbum/149\.jpg HTTP/1.0" 400' Access.log | grep -v '"HTTP/1.1 200 OK"' | perl ~/weblog.pl > AccessTable.dat
#
#  We filter that line as it has been corrupted with part of the date at the end.
#
#
#
# Then read into R with 
#    read.table("AccessTable.dat", sep = "\t", quote = "", comment = "")

while(<>) {
    if(m/HTTP/) {
      $_ =~ s/\t//;
      $_ =~ s|([0-9.]+) - [A-Za-z0-9.-]+ \[(.+) -[0-9]{4}\] ["]([A-Za-z]+) (.*) HTTP[\\/]?([.01]+)(Content-.*)?["] ([0-9]+) ([-0-9]+)|$1	$2	$3	$4	$5	$7	$8|;

#      $_ =~ s|([0-9.]+) - [A-Za-z.-]+ \[(.+) -[0-9]{4}\] "([A-Z]+) (.*) HTTP/?([.01]+)" ([0-9]+) ([-0-9]+)|$1	$2	$3	$4	$5	$6	$7|;

      $_ =~ s/\t\t/\tNA\t/;
      print $_;
    }
}
