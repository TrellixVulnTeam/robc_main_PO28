#!/usr/bin/perl

use strict;

use lib "/opt/rt3/lib";
use lib "/usr/share/rt3/lib";

use RT;
use RT::Links;
use RTx::AssetTracker;
use RTx::AssetTracker::Assets;

RT::LoadConfig;
RTx::AssetTracker::LoadConfig.
RT::Init;

my $Assets = RTx::AssetTracker::Assets->new($RT::SystemUser);
$Assets->Limit(FIELD => 'URI', VALUE => '');
unless ($Assets->Count) {
    print "No URIs to update.\n";
}

while (my $asset = $Assets->Next) {

    next if $asset->{URI};
    print "Processing Asset: ", $asset->Name, "\n";

    # We override the URI lookup. the whole reason
    # we have a URI column is so that joins on the links table
    # aren't expensive and stupid
    $asset->__Set( Field => 'URI', Value => $asset->URI );


}

my $Links = RT::Links->new($RT::SystemUser);
$Links->Limit(FIELD => 'id', VALUE => 0, OPERATOR => '>');

$|++;
print "Fixing links. This may take a while...";
my $i = 0;
while (my $link = $Links->Next) {
    $i++;
    if ( $i == 25 ) { print '.'; $i = 0; }

    if ($link->Base =~ m|at://.*/asset/(\d+)$| && $link->LocalBase ) {
        $link->__Set( Field => 'LocalBase', Value => 0 );
    }
    
    if ($link->Target =~ m|at://.*/asset/(\d+)$| && $link->LocalTarget ) {
        $link->__Set( Field => 'LocalTarget', Value => 0 );
    }

}
print "Finished!\n";
