use strict;
use warnings;
use Gideon::Registry;
use Test::More tests => 2;

ok( !Gideon::Registry->has_cache, 'Cache deactivated' );

my $fake_cache = {};
Gideon::Registry->register_cache($fake_cache);
ok( Gideon::Registry->has_cache, 'Cache activated' );

