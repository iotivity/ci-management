#!C:\Strawberry\perl\bin\perl.exe -w

use strict;
use warnings;
use WWW::Mechanize;

my( $jenkinsServerUrl, $jenkinsSlaveJarUrl, $jnlpUrl, $username, $api_token ) = @ARGV;

my $mech = WWW::Mechanize->new();

$mech->get( "$jenkinsServerUrl/login" );

$mech->submit_form(
		   form_name => 'login',
		   fields    => { j_username  => $username,
				  j_password => $api_token,
				}
		  );

$mech->get( $jnlpUrl );

my($secret) = ($mech->content =~ m{<argument>(.+?)</argument>});

print $secret;
