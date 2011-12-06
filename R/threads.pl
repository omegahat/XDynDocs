#!/usr/local/bin/perl -w                                                                                               
                                                                                                                 
#use Mail::Box::Manager;                                                                                         
use Mail::Box::Mbox;                                                                                             
                                                                                                                 
use Mail::Thread;                                                                                                

#                                                                                                                  
# Mail::Thread
#  See http://search.cpan.org/src/SIMON/Mail-Thread-2.5/README
#      http://search.cpan.org/~rclamp/Mail-Thread/Thread.pm
                                                                                                                 
# Mail::Message                                                                                                  
#       http://search.cpan.org/dist/Mail-Box/lib/Mail/Box/Mbox/Message.pod                                       
# Mail::Address                                                                                                  
#       http://www.monster-submit.com/resources/docs/modules/Mail/Address.html                                   

# http://perl.overmeer.net/mailbox/
                                                                                                                 
my $mailspool = "$ARGV[0]";                                                                                      
                                                                                                                 
my $folder =  Mail::Box::Mbox->new(folder => $mailspool);                                                        
                                                                                                                 
my $threader = Mail::Thread->new($folder->messages());
$threader->thread;                                                                                               
                                                                                                                 
my @msgs = $folder->messages();                                                                                  
print "Number of messages: ", ($#msgs+1), "\n";                                                                  
                                                                                                                
my @threads = $threader->rootset();                                                                              
print "Number of threads: ", $#threads, "\n";                                                                    


foreach $t ($threader->rootset()) {

    if(!defined($t)) {
     next; # continue;
    }

if(0) {
    print $t->messageid(), ", ", $t->subject();

    $n = 0;
    msgCounter($t);
    print ", count ", $n, "\n";
} else {
#    if(defined($t)) {
#	print  "**** ", $t->messageid(), ", ", $t->subject(), "\n";
#    }
    showChildren($t);
#    print  "---\n";
}
}


# The children messages are not ordered by time.
sub showChildren {
    my ($t) = @_;
    
    my $p;
    if ($t->child) {
#	print $t->messageid(), ", ";
	$p = $t->child;
	while($p) {
	    print $t->messageid(), " ", $p->messageid(), "\n";
	    $p = $p->next;
	}
	$p = $t->child;
	while( defined($p) ) {
	    showChildren($p);
	    $p = $p->next;
	}
    }
}

sub msgCounter {
    my ($self) = @_;
    $n++;
    msgCounter($self->next) if $self->next; 
    msgCounter($self->child) if $self->child; 
}






