use Mail::Box::Mbox;
use Mail::Thread;


# doAll($ARGV[0]);

sub getThreader {
    my ($folder) = @_;
    my $threader = Mail::Thread->new($folder->messages());
    $threader->thread;
    return($threader);
}

sub doAll {
    my ($file) =  @_;
    print $file, "\n";
    my  $folder = Mail::Box::Mbox->new(folder => $file);

    print "Num messages ", $folder->nrMessages(), "\n";


    my $threader = Mail::Thread->new($folder->messages());
#    $threader->thread;
  #  my $threader = &getThreader($folder);
    return($threader);
#    return(($threader, $folder));
}

