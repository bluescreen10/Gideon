use strict;
use warnings;
use MooseX::Test::Role;
use Gideon::Driver;
use Test::More tests => 7;

{

    package TestClass;
    use Moose;
    with 'Gideon::Meta::Class::Trait::Persisted';

    __PACKAGE__->meta->make_immutable;
}

# find multiple in array context
{
    my $test_name   = 'Find multiple dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _find => sub {
            is $_[1], 'TestClass', $test_name;
            is_deeply $_[2], { id   => 1 },    $test_name;
            is_deeply $_[3], { desc => 'id' }, $test_name;
            return [ TestClass->new ];
        }
    );

    $fake_driver->find(
        'TestClass',
        id     => 1,
        -order => { desc => 'id' }
    );
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
            return [ TestClass->new ];
        }
    );

    $fake_driver->find_one(
        'TestClass',
        name   => { like => 'john' },
        -order => { asc  => 'id' },
    );
}
