use strict;
use warnings;
use DBI;
use Gideon::Registry;
use Test::More tests => 2;

{

    package Customer;
    use Gideon driver => 'DBI';

    has id => (
        is          => 'rw',
        isa         => 'Num',
        traits      => ['Gideon::DBI::Column'],
        primary_key => 1,
        serial      => 1,
    );

    has name => (
        is     => 'rw',
        isa    => 'Str',
        column => 'alias',
        traits => ['Gideon::DBI::Column']
    );

    has age => (
        is     => 'rw',
        isa    => 'Num',
        traits => ['Gideon::DBI::Column']
    );

    __PACKAGE__->meta->store("test:customer");
    __PACKAGE__->meta->make_immutable;
}

my $dbh = DBI->connect( 'dbi:Mock:', undef, undef, { RaiseError => 1 } );
$dbh->{mock_session}         = setup_session();
$dbh->{mock_start_insert_id} = 11;

Gideon::Registry->register_store( 'test', $dbh );
my $driver = Gideon::Driver::DBI->new;

# test _insert_object
{
    my $customer = Customer->new( name => 'joe doe', age => 41 );
    ok $driver->_insert_object($customer), 'insert object';
    is $customer->id, 11, 'serial value seeting';
}

sub setup_session {
    DBD::Mock::Session->new(
        test => (
            {
                statement =>
                  qr/INSERT INTO customer \( age, alias\) VALUES \( \?, \? \)/,
                results => [ ['rows'], [] ],
                bound_params => [ 41, 'joe doe' ],
            },
        )
    );
}
