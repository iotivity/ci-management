#!C:\Strawberry\perl\bin\perl.exe -w

use strict;
use warnings;
use WWW::Mechanize;

my( $jenkinsServerUrl, $jenkinsSlaveJarUrl, $jnlpUrl, $username, $api_token ) = @ARGV;

my $jenkinsLoginUrl = $jenkinsServerUrl;
$jenkinsLoginUrl =~ s{/$}{/login};

my $mech = WWW::Mechanize->new();

$mech->get( $jenkinsLoginUrl );

$mech->submit_form(
		   form_name => 'login',
		   fields    => { j_username  => $username,
				  j_password => $api_token,
				}
		  );

$mech->get( $jenkinsSlaveJarUrl );

open( my( $jarfh ), q{>}, 'slave.jar' ) or die "couldn't open slave.jar for writing: $!";

binmode $jarfh;

print $jarfh $mech->content;

$mech->get( $jnlpUrl );

my($secret) = ($mech->content =~ m{<argument>(.+?)</argument>});

print $secret;
