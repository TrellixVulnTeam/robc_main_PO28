# BEGIN LICENSE BLOCK
# 
#  Copyright (c) 2002-2003 Jesse Vincent <jesse@bestpractical.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of version 2 of the GNU General Public License 
#  as published by the Free Software Foundation.
# 
#  A copy of that license should have arrived with this
#  software, but in any event can be snarfed from www.gnu.org.
# 
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
# 
# END LICENSE BLOCK

package RTx::AssetTracker;
use strict;
#use vars qw/$System/;
use RTx::AssetTracker::System;
use RTx::AssetTracker::Type;
use RTx::AssetTracker::Asset;

use vars qw($VERSION
        $CORE_CONFIG_FILE
        $SITE_CONFIG_FILE
	$EtcPath
	$VarPath
	$LocalPath
	$LocalEtcPath
	$LocalLexiconPath
        $ATConfigDone
);

$VERSION = '0.0.0';
$CORE_CONFIG_FILE = "/usr/share/rt3/etc/AssetTracker/AT_Config.pm";
$SITE_CONFIG_FILE = "/usr/share/rt3/etc/AssetTracker/AT_SiteConfig.pm";
$ATConfigDone = 0;



#$BasePath = '';

#$EtcPath = '';
#$BinPath = '';
#$VarPath = '';
#$LocalPath = '';
$LocalEtcPath = "/usr/share/rt3/etc/AssetTracker";
#$LocalLexiconPath = '';



=head2 LoadConfig

Load RT's config file. First, go after the core config file.
After that, go after the site config.

=cut

sub LoadConfig {
    local *Set = sub { $_[0] = $_[1] unless defined $_[0] };
    if ( -f "$SITE_CONFIG_FILE" ) {
        require $SITE_CONFIG_FILE
          || die ("Couldn't load AT config file  '$SITE_CONFIG_FILE'\n$@");
    }
    require $CORE_CONFIG_FILE
      || die ("Couldn't load AT config file '$CORE_CONFIG_FILE'\n$@");

    RT->Init();
    RTx::AssetTracker::Type->ConfigureRoles();
    RTx::AssetTracker::Asset->ConfigureLinks();
    $ATConfigDone = 1;
}



# Create a system object for AssetTracker
$RTx::AssetTracker::System = RTx::AssetTracker::System->new($RT::SystemUser);

1;
