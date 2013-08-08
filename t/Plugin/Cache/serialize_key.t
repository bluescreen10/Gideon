use strict;
use warnings;
use Gideon::Plugin::Cache;
use Test::More tests => 3;

my $query1 = {
    a => 1,
    b => 2,
    c => { a => 1, b => 2, c => 3 },
    d => [ 1, 2, 3 ]
};

my $query2 = {
    c => { b => 2, c => 3, a => 1 },
    b => 2,
    d => [ 1, 2, 3 ],
    a => 1,
};

my $query3 = {
    c => { b => 2, c => 3, a => 2 },
    b => 2,
    d => [ 1, 2, 3 ],
    a => 1,
};

my $key1 = Gideon::Plugin::Cache->_serialize_key( __PACKAGE__, $query1 );
my $key2 = Gideon::Plugin::Cache->_serialize_key( __PACKAGE__, $query2 );
my $key3 = Gideon::Plugin::Cache->_serialize_key( __PACKAGE__, $query3 );

ok $key1, 'Not empty key';
is "$key1",   "$key2", 'same query cache key';
isnt "$key1", "$key3", 'different query cache key';
