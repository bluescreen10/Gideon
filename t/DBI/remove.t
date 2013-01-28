{

    package Customer;
    use Gideon driver => 'DBI';

    has id => (
        is          => 'rw',
        isa         => 'Num',
        traits      => ['Gideon::DBI::Column'],
        primary_key => 1,
    );

    has name => (
        is     => 'rw',
        isa    => 'Str',
        column => 'alias',
        traits => ['Gideon::DBI::Column']
    );

    __PACKAGE__->meta->store("test:customer");
    __PACKAGE__->meta->make_immutable;
}

{

    package Person;
    use Gideon driver => 'DBI';

    has first_name => (
        is     => 'rw',
        isa    => 'Str',
        traits => ['Gideon::DBI::Column']
    );

    has last_name => (
        is     => 'rw',
        isa    => 'Str',
        traits => ['Gideon::DBI::Column']
    );

    __PACKAGE__->meta->store("test:person");
    __PACKAGE__->meta->make_immutable;
}

use strict;
use warnings;
use Test::More tests => 4;
use Gideon::StoreRegistry;
use DBI;

my $dbh = DBI->connect( 'dbi:Mock:', undef, undef, { RaiseError => 1 } );
$dbh->{mock_session} = setup_session();

Gideon::StoreRegistry->register( 'test', $dbh );

# Test _remove_object single objects
{
    my $customer = Customer->new( id => 1, name => 'joe doe' );
    ok( Gideon::DBI->_remove_object($customer), 'remove single instance' );

    my $person = Person->new( first_name => 'John', last_name => 'Doe' );
    ok(
        Gideon::DBI->_remove_object($person),
        'remove signle instance without primary key'
    );
}

# Test _remove all
{
    ok( Gideon::DBI->_remove('Customer'), 'remove all records' );
}

# Test _remove with a where condition
{
    ok( Gideon::DBI->_remove( 'Customer', { name => 'jack' }, ),
        'remove all records that match a given where condition' );
}

sub setup_session {
    DBD::Mock::Session->new(
        test => (
            {
                statement =>
                  qr/DELETE FROM customer WHERE \( id = \? \)/sm,
                results => [ ['rows'], [] ],
                bound_params => [ 1 ],
            },
            {
                statement =>
                  qr/WHERE \( \( first_name = \? AND last_name = \? \) \)/sm,
                results => [ ['rows'], [] ],
                bound_params => [ 'John', 'Doe' ],
            },

            {
                statement    => qr/DELETE FROM customer/,
                results      => [ ['rows'], [], [], [] ],
            },
            {
                statement =>
                  qr/DELETE FROM customer WHERE \( alias = \? \)/,
                results => [ ['rows'], [], [], [] ],
                bound_params => [ 'jack' ],
            },

        )
    );
}

