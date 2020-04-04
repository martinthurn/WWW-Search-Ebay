
# $Id: author_html.t,v 1.1 2015-06-06 19:54:11 Martin Exp $

use strict;

use Test::More 'no_plan';

use blib;
use Data::Dumper;
use Date::Manip;
use IO::Capture::Stderr;
use WWW::Search::Test;
use WWW::Search::Ebay;

use constant DEBUG_DATE => 0;

my $iDebug = 0;
my $iDump = 0;

tm_new_engine('Ebay');

my $oICE =  IO::Capture::Stderr->new;
$oICE->start;

# We need a query that returns items that end in a few minutes.  This
# one attracts Rock'n'roll fans and philatelists:
TODO:
  {
  $TODO = 'We only need one page of results in order to test the HTML';
  tm_run_test('normal', 'zeppelin', 1, 99, $iDebug, $iDump);
  }
$oICE->stop;
$TODO = '';
# goto ALL_DONE;  # for debugging

# Now get some results and inspect them:
my @ao = $WWW::Search::Test::oSearch->results();
cmp_ok(0, '<', scalar(@ao), 'got some results');
# $WWW::Search::Test::oSearch->{_debug} = 2;
foreach my $oResult (@ao)
  {
  my $sHTML = $WWW::Search::Test::oSearch->result_as_HTML($oResult);
  # diag($sHTML);
  # last;
  } # foreach
ALL_DONE:
exit 0;

__END__
