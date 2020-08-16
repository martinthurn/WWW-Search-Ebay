
my $VERSION = 1.01;

use strict;
use warnings;

use Bit::Vector;
use Data::Dumper;
use Date::Manip;
use ExtUtils::testlib;
use Test::More;
use WWW::Search;
use WWW::Search::Test;

BEGIN
  {
  use blib;
  use_ok('WWW::Search::Ebay');
  } # end of BEGIN block

my $iDebug = 0;
my $iDump = 0;

tm_new_engine('Ebay');

CONTENTS:
diag("Sending 1-page ebay query to check contents...");
$WWW::Search::Test::sSaveOnError = q{rt-133162-failed.html};
my $sQuery = 'radeon vii';
tm_run_test('normal', $sQuery, 1, 99, $iDebug, $iDump);
# Now get the results and inspect them:
my @ao = $WWW::Search::Test::oSearch->results();
cmp_ok(0, '<', scalar(@ao), 'got some results');
my $sBidPattern = 'bid\s+'. $WWW::Search::Test::oSearch->_currency_pattern .'\s?[,.0-9]+';
my $qrBid = qr{\b$sBidPattern};
my @ara = (
           ['description', 'like', $qrBid, 'description contains bid amount'],
           ['description', 'like', qr{Item #\d+;}, 'description contains item #'],
           ['url', 'like', qr(\Ahttps?://(cgi|www)\d*\.ebay\.com)i, # ), # Emacs bug
            q'URL is from ebay.com'], # '], # Emacs bug
           ['title', 'ne', 'q{}', 'result Title is not empty'],
           ['change_date', 'date', 'change_date is really a date'],
           ['description', 'like', qr{\b(\d+|no)\s+bids?}, # }, # Emacs bug
            'result bidcount is ok'],
           ['bid_count', 'like', qr{\A\d+\Z}, 'bid_count is a number'],
           # ['shipping', 'like', qr{\A(free|[0-9\$\.]+)\Z}i, 'shipping looks like a money value'],
           ['category', 'like', qr{\A-?\d+\Z}, 'category is a number'],
          );
WWW::Search::Test::test_most_results(\@ara, 1.00);

ALL_DONE:
pass('all done');

done_testing();

__END__
