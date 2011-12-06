#!/usr/bin/perl
use Mail::Box::Manager;

my $mgr    = Mail::Box::Manager->new;
my $folder = $mgr->open(folder => "RSPerl");
print $folder->name, "\n";
print "# messages ", $folder->nrMessages(), "\n";
$folder->close();

