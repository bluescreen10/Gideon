use MooseX::Test::Role;
use Gideon::Driver;
use Gideon::ResultSet;
use Test::More tests => 4;

# Object remove
{
    my $test_name   = 'Object dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _remove        => sub { ok 0, $test_name },
        _remove_object => sub {
            isa_ok $_[1], 'TestClass', $test_name;
        }
    );

    $fake_driver->remove( bless( {}, 'TestClass' ) );
}

# Class update
{
    my $test_name   = 'Class dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _remove_object => sub { ok 0, $test_name },
        _remove        => sub {
            is $_[1], 'TestClass', $test_name;
        }
    );

    $fake_driver->remove('TestClass');
}

# ResultSet update
{
    my $test_name   = 'ResultSet dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _remove_object => sub { ok 0, $test_name },
        _remove        => sub {
            is $_[1], 'TestClass', $test_name;
            is_deeply $_[2], { id => 1 }, 'ResultSet where';
        }
    );

    my $rs = Gideon::ResultSet->new(
        target => 'TestClass',
        query  => { id => 1, -order => { desc => 'name' } }
    );

    $fake_driver->remove($rs);
}
