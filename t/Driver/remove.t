use strict;
use warnings;
use MooseX::Test::Role;
use Gideon::Driver;
use Test::More tests => 3;

{

    package TestClass;
    use Moose;
    with 'Gideon::Meta::Class::Trait::Persisted';

    __PACKAGE__->meta->make_immutable;
}

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

    my $instance = TestClass->new;
    $instance->__is_persisted(1);
    $fake_driver->remove($instance);
    ok !$instance->__is_persisted, 'Instance is no more persisted';
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
