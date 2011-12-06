#!/bin/sh

while test -n "${1}" ; do
  n=`echo $1 | sed -e 's/\.csv1$//'`
    echo "LOAD DATA INFILE \"${PWD}/${1}\" INTO TABLE $n FIELDS TERMINATED BY \",\" ENCLOSED BY \"\\\"\";"
  shift
#  $n =~ s/\.txt1$//;
#  print "LOAD DATA INFILE \"$n\" INTO TABLE $n FIELDS TERMINATED BY "," ESCAPED BY "\"";
done


