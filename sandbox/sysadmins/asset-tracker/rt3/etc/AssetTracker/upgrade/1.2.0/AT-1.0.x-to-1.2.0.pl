#!/usr/bin/perl

use lib "/opt/rt3/lib";
use lib "/usr/share/rt3/lib";

use RT;
use RTx::AssetTracker::Asset;
use RTx::AssetTracker::Assets;
use RTx::AssetTracker;

RT::LoadConfig;
RTx::AssetTracker::LoadConfig.
RT::Init;

my $Assets = RTx::AssetTracker::Assets->new($RT::SystemUser);
$Assets->Limit(FIELD => 'Parent', VALUE => 0, OPERATOR => '>');
unless ($Assets->Count) {
    print "No assets with parents.\n";
    exit 0;
}

while (my $asset = $Assets->Next) {

    next unless $asset->Parent;
    print "Processing Asset: ", $asset->Name, "\n";

    my $parent = RTx::AssetTracker::Asset->new($RT::SystemUser);
    my ($rv, $msg) = $parent->Load($asset->Parent);

    unless ($rv) {
        print STDERR "Error processing parent: $msg\n\n";
        next;
    }

    ($rv, $msg) = $asset->AddLink( Target => $parent->URI,
                     Type => 'ComponentOf',
                     TransactionData => 'Converted from Parent',
                     Silent => 0 );

    unless ($rv or $msg =~ /Link already exists/ ) {
        print STDERR "Error adding link: $msg\n\n";
        next;
    }

    print "$msg\n";

}
