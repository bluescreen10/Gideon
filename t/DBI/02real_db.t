{

    package Person;

    use Gideon driver => 'DBI';

    has id => (
        is     => 'rw',
        isa    => 'Int',
        column => 'person_id',
        traits => ['Gideon::DBI::Column']
    );

    has name => (
        is     => 'rw',
        isa    => 'Str',
        column => 'person_name',
        traits => ['Gideon::DBI::Column']
    );

    has city => (
        is     => 'rw',
        isa    => 'Str',
        column => 'person_city',
        traits => ['Gideon::DBI::Column']
    );

    has country => (
        is     => 'rw',
        isa    => 'Str',
        column => 'person_country',
        traits => ['Gideon::DBI::Column']
    );

    has type => (
        is     => 'rw',
        isa    => 'Str',
        column => 'person_type',
        traits => ['Gideon::DBI::Column']
    );

    __PACKAGE__->meta->store('test:person');
    __PACKAGE__->meta->make_immutable;

}

use strict;
use warnings;
use Test::More;
use DBI;
use FindBin qw($Bin);
use File::Copy;
use Gideon::StoreRegistry;

my $test_db = "$Bin/test.db";
unlink "$Bin/test.db" if -e $test_db;
copy( "$test_db.orig", $test_db ) or die "Copy failed: $!";

my $dbh =
  DBI->connect( "dbi:SQLite:dbname=$Bin/test.db", "", "", { RaiseError => 1 } );
Gideon::StoreRegistry->register( test => $dbh );

if ($DBI::errstr) {
    plan skip_all => "Can't load DB(sqlite)";
    exit(0);
}

# find all records
{
    my @all_person = Person->find;
    is scalar @all_person, 3, 'Three people on the DB';
    is $all_person[0]->city,    'Las Vegas', 'First person\'s city';
    is $all_person[0]->country, 'US',        'First person\'s country';
    is $all_person[0]->type,    10,          'First person\'s type';
    is $all_person[0]->id,      1,           'First person\'s id';
}

# Combining queries
{
    my $johns = Person->find( name => { like => '%John%' } );
    my $san_fransiscan_johns = $johns->find( city => 'San Francisco' );

    is scalar @$san_fransiscan_johns, 1, 'Number of San Franciscan John\'s';
}

# Order by Hashref
{
    my $last_person = Person->find_one( -order => { -desc => 'id' } );
    is $last_person->id, 3, 'Last person\'s id';
}

# Order by Scalar
{
    my $last_person = Person->find_one( -order => 'id DESC' );
    is $last_person->id, 3, 'Last person\'s id';
}

# Order by ArrayRef
{
    my @alphabetic = Person->find( -order => [qw(name id)] );
    is $alphabetic[0]->name, 'Foo Bar', 'Firs person in alphabetic order';
}

done_testing();

