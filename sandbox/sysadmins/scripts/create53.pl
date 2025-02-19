#!/usr/bin/perl -w

use strict;    
use DNS::ZoneParse;
use Data::Dumper;
use WebService::Amazon::Route53;
use File::Basename;
use Getopt::Std;

my $zone = $ARGV[0] . ".";
if (not defined $zone) {
  die "Need zone.\n";
}

use constant AWS_ID => 'AKIAJKZPO45Y4YPYZPKQ';
use constant AWS_SECRET => '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';
# set ALERT_EMAIL to FALSE to disable email alerts.
use constant ALERT_EMAIL => 'q_la@evolvemediallc.com';
use constant INFO_EMAIL => 'q_cm@evolvemediallc.com';


# lets check if the zone exists on r53.
my $myTime=time();
my $r53 = WebService::Amazon::Route53->new(id => AWS_ID, key => AWS_SECRET);
my $myzone = $r53->find_hosted_zone(name => $zone);
if (!$myzone) {
    print "[" . localtime() . "] $zone does not exist on route53...creating it.\n";
    my $response = $r53->create_hosted_zone(name => $zone, caller_reference => "${zone}new_${myTime}" );

    if (!$response) {
        # something went wrong zone wasn't created
        my $msg = "Zone $zone creation failed on route53!" . Dumper($response) . "\n";
        send_email($msg,'[ERROR] Zone creation failed!', ALERT_EMAIL);
	print "[ERROR] Zone creation failed!" . Dumper($response) . "\n";
	exit 1;
    }
    
    my $msg = "Created the following $zone on route53.\nThe following NS servers were assigned:\n" . Dumper($response->{delegation_set}{name_servers});
    send_email($msg,'[DNSINFO] $zone created@route53', INFO_EMAIL);
    print $msg;
} else {
   print "$zone aleady exists on route53!\n";
}

###############
###############
sub send_email {
       	my $msg = shift;
        my $subject = shift;
       	my $email_to = shift;
        if ($email_to) {
            my $from = 'push53@gorillanation.com';
            open(MAIL, "|/usr/sbin/sendmail -t");

            # Email Header
            print MAIL "To: " . $email_to . "\n";
            print MAIL "From: $from\n";
            print MAIL "Subject: $subject\n\n";
            # Email Body
            print MAIL $msg;
            close(MAIL);
        }
}
