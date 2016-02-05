#!/usr/bin/perl
# google.pl - Perl script that searches Google and returns results
# This script violates Google's TOS found here:
# http://www.google.com/intl/en/policies/terms/
# Use at your own risk

use LWP::UserAgent;
use JSON;

$numArgs = $#ARGV + 1;
if($numArgs == 0){
	# No arguments? Print usage info and exit
	print "Usage:\n$0 <searchterm>\n";
	exit;
} else {
	foreach $argnum (0 .. $#ARGV) {
		$q = $q.' '.$ARGV[$argnum];
	}

	# Trim and URL Encode the query
	$q_enc = $q =~ s/^\s+|\s+$//g;
	$q_enc =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
}

# Some user feedback
print "Searching Google for '$q'...\n";

# Do the search
my $ua = LWP::UserAgent->new();
my $body = $ua->get("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=$q");

# Process the json data
my $json = from_json($body->decoded_content);

# Print results
my $i = 0;
foreach my $result (@{$json->{responseData}->{results}}){
	$i++;
	print $i.". " . $result->{titleNoFormatting} . "(" . $result->{url} . ")\n";
}
if(!$i){
	print "Sorry, but there were no results.\n";
}