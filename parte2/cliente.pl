use strict;
use Getopt::Long;
use CGI::Carp qw(fatalsToBrowser);
use LWP::UserAgent;
use HTTP::Request;
use HTML::TableExtract;

my $url = "https://www.wikileaks.org/hackingteam/emails/";
my $query = "?q=&mfrom=%40\@gmail.com&mto=&title=&notitle=&date=&nofrom=&noto=&count=10000&sort=0#searchresult";

my $userAgent = LWP::UserAgent->new;
$userAgent->agent("Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Mobile Safari/537.36");

my $request = HTTP::Request->new(POST => $url);
$request->content_type('application/x-www-form-urlencoded');
$request->content($query);

my $response = $userAgent->request($request);
my $content = $response->content();

my $te = HTML::TableExtract->new( headers => [qw(Date  Subject From  To)]);

$te->parse($content);
my $table = $te->tables;

my $ts = $te->tables;

foreach $ts ($te->tables) {
  print "Table (", join(',', $ts->coords), "):\n";

  my $row = $ts->rows;
  foreach $row ($ts->rows) {
    print join(',', @$row), "\n";
  }
}
