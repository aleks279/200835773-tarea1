use strict;
use Getopt::Std;
use CGI::Carp qw(fatalsToBrowser);
use LWP::UserAgent;
use HTTP::Request;
use HTML::TableExtract;

my %options=();
getopts("t:", \%options);

my $query_params = "";

if (defined $options{t}) {
  if ( $options{t} eq "email_from" ) {
    $query_params = "?q=&mfrom=%40@ARGV&mto=&title=&notitle=&date=&nofrom=&noto=&count=10000&sort=0#searchresult";
    makeRequest();
  } elsif ( $options{t} eq "email_to" ) {
    $query_params = "?q=&mfrom=&mto=%40@ARGV&title=&notitle=&date=&nofrom=&noto=&count=10000&sort=0#searchresult";
    makeRequest();
  } elsif ( $options{t} eq "email_content") {
    my $text = join('+', @ARGV);
    $query_params = "?q=$text&mfrom=&mto=&title=&notitle=&date=&nofrom=&noto=&count=10000&sort=0#searchresult";
    print $query_params, "\n";
    makeRequest();
  } else {
    printOptions();
  }
}

sub makeRequest{
  my $url = "https://www.wikileaks.org/hackingteam/emails/";

  my $userAgent = LWP::UserAgent->new;
  $userAgent->agent("Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Mobile Safari/537.36");

  my $request = HTTP::Request->new(POST => $url);
  $request->content_type('application/x-www-form-urlencoded');
  $request->content($query_params);

  my $response = $userAgent->request($request);
  my $content = $response->content();

  my $te = HTML::TableExtract->new( headers => [qw(Date From To)]);

  $te->parse($content);
  my $table = $te->tables;

  my $ts = $te->tables;

  foreach $ts ($te->tables) {
    my $row = $ts->rows;

    open(my $output_file, '>', 'results.csv') or die 'Shit';
    print $output_file "Date,From,To\n";
    foreach $row ($ts->rows) {
      print $output_file join(',',@$row), "\n";
    }
    close $output_file;
    print "Finished!\n";
  }
}

sub printOptions{
  print "ITCR - Ing Computacion\n";
  print "Bases de Datos II\n";
  print "Prof. Kevin Moraga\n";
  print "Tarea 1 by Saul Zamora 200835773\n";
  print "Uso:\n";
  print "perl cliente.pl -t <tipo-consulta> <texto>\n";
  print "<tipo-campo>:\n";
  print "\t email_from : remitente del email\n";
  print "\t email_to : destinatario del email\n";
  print "\t email_content : palabra(s) a buscar en el cuerpo del email\n\n";
}
