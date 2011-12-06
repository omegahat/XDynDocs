#!/usr/bin/perl -w

#use Mail::Box::Manager;
use Mail::Box::Mbox;

use Mail::Thread;



# Mail::Message
#       http://search.cpan.org/dist/Mail-Box/lib/Mail/Box/Mbox/Message.pod
# Mail::Address
#       http://www.monster-submit.com/resources/docs/modules/Mail/Address.html

my $mailspool = "$ARGV[0]";
# print $mailspool,"\n";

#my $mgr    = Mail::Box::Manager->new;
#my $folder = $mgr->open(folder => $mailspool);

my $folder =  Mail::Box::Mbox->new(folder => $mailspool);

my $threader = Mail::Thread->new($folder->messages());
$threader->thread;

foreach $msg ($folder->messages()) {
   # @to = split(",", $msg->to);

    print $msg->messageId(), "\t";

      # Time stamp
# Don't use   $d=$msg->date;
    print scalar(localtime($msg->timestamp())), "\t";

#  print $msg->sender()->address(), "\t";
# We don't use sender as the mailing list R-help-bounces will appear
# to be the sender of (almost) all of the messages.
# See msg->from()->format(), and user() and host() also.
    @f = $msg->from();
    print $f[0]->address(), "\t";

# Handle the To, CC, Bcc
    @d = $msg->destinations();
    print $#d + 1, "\t";

# Subject, and get rid of any TAB and escape any \t 
# characters so that they can be read by R.
    $subj = $msg->subject();
    $subj =~ s/\t/ /g;
    $subj =~ s/\\t/\\\\t /g;
    print $subj, "\t";

    print $msg->nrLines, "\t", $msg->size();

# 
    if($msg->isMultipart()) {
	print  "\t1";
    } else {
	my @e = $msg->parts();
	print  "\t", $#e;
    }


    print "\n";
}
