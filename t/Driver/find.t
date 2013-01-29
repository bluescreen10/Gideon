{

    package TestClass;
    use Moose;
    with 'Gideon::Meta::Class::Persisted::Trait';

    __PACKAGE__->meta->make_immutable;
}

use MooseX::Test::Role;
use Gideon::Driver;
use Gideon::ResultSet;
use Test::More tests => 11;

# find multiple in array context
{
    my $test_name   = 'Find multiple dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _find => sub {
            is $_[1], 'TestClass', $test_name;
            is_deeply $_[2], { id   => 1 },    $test_name;
            is_deeply $_[3], { desc => 'id' }, $test_name;
            TestClass->new;
        }
    );

    my @rs = $fake_driver->find(
        'TestClass',
        id     => 1,
        -order => { desc => 'id' }
    );
}

# find multiple in scalar context
{
    my $test_name = 'Gideon::ResulSet returned when invoked in scalar context';

    my $fake_driver =
      consumer_of( 'Gideon::Driver', _find => sub { ok 0, $test_name } );

    my $rs = $fake_driver->find( 'TestClass', id => 1, -order => ['id'] );

    is $rs->target, 'TestClass', $test_name;
    isa_ok $rs, 'Gideon::ResultSet', $test_name;
    is_deeply $rs->query, { id => 1 }, $test_name;
    is_deeply $rs->order, ['id'], $test_name;
}

# find_one dispatched correctly
{
    my $test_name   = 'Find one dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _find => sub {
            is $_[1], 'TestClass', $test_name;
            is $_[4], 1,           $test_name;
            is_deeply $_[3], { asc => 'id' }, $test_name;
            is_deeply $_[2], { name => { like => 'john' } }, $test_name;
            return ( TestClass->new );
        }
    );

    $fake_driver->find_one(
        'TestClass',
        name   => { like => 'john' },
        -order => { asc  => 'id' },
    );
}

