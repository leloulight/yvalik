#!/usr/bin/perl -w
#<!-- <title>Проверка библиотек Perl</title> -->
#<!--order=130-->

use CGI qw/:standard/;
use CGI::Carp 'fatalsToBrowser';
my $q = new CGI;

my $Count = $q->cookie('Count');
print header(-cookie => cookie(-name => "Count", -value => ++$Count, -expires => "+10y"));

if ($q->param('doGo')) {
    print "<h2>Hello from " . $q->param('Address') . "!</h2>";
}

print <<EOT;
	<html>
	<head><title>Hello from CGI::WebOut!</title></head>
	<body>
	You have visited this page $Count times (cookie test).
	<form action="$ENV{SCRIPT_NAME}" method=post
	enctype=multipart/form-data>
	<input type=text name="Address">
	<input type=submit name=doGo value="Say hello">
	</form>
	</body>
	</html>
EOT
