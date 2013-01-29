{

    package Customer;
    use Gideon driver => 'DBI';

    __PACKAGE__->meta->store("test:customer");

    has id => ( is => 'rw', isa => 'Num', traits => ['Gideon::DBI::Column'] );
    has name => (
        is     => 'rw',
        isa    => 'Str',
        column => 'alias',
        traits => ['Gideon::DBI::Column']
    );

    __PACKAGE__->meta->make_immutable;
}

use strict;
use warnings;
use Test::More tests => 6;
use Gideon::StoreRegistry;
use DBI;
use JSON qw(-convert_blessed_universally);

my $dbh = DBI->connect( 'dbi:Mock:', undef, undef, { RaiseError => 1 } );
$dbh->{mock_session} = setup_session();

Gideon::StoreRegistry->register( 'test', $dbh );

# Test find_first
{
    my @customers = Gideon::DBI->_find( 'Customer', { id => 1 }, undef, 1 );

    is scalar @customers, 1, 'Only one customer';
    is $customers[0]->id,   1,         'id is correct';
    is $customers[0]->name, 'joe doe', 'name is correct';
}

# Test find in array context
{
    my @customers = Gideon::DBI->_find( 'Customer', undef, ['id'] );

    is scalar @customers, 2, 'Has two customers';
    is $customers[0]->name, 'joe doe',    'First result\'s name';
    is $customers[1]->name, 'jack bauer', 'Second result\'s name';
}

sub setup_session {
    DBD::Mock::Session->new(
        test => (
            {
                statement => qr/SELECT alias, id FROM customer .*< 1/sm,
                results   => [ [ 'id', 'alias' ], [ 1, 'joe doe' ] ],
            },
            {
                statement => qr/SELECT alias, id FROM customer ORDER BY id/,
                results =>
                  [ [ 'alias', 'id' ], [ 'joe doe', 1 ], [ 'jack bauer', 2 ] ],
            },
        )
    );
}

