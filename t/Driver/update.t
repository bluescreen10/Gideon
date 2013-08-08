use strict;
use warnings;
use MooseX::Test::Role;
use Gideon::Driver;
use Test::More tests => 4;

{

    package TestClass;
    use Moose;

    has id => ( is => 'rw', isa => 'Num' );

    __PACKAGE__->meta->make_immutable;
}

# Object update
{
    my $test_name   = 'Object dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _update        => sub { ok 0, $test_name },
        _update_object => sub {
            isa_ok $_[1], 'TestClass', $test_name;
            is_deeply $_[2], { id => 2 }, 'Object updates';
        }
    );

    $fake_driver->update( TestClass->new( id => 1 ), id => 2 );
}

# Class update
{
    my $test_name   = 'Class dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _update_object => sub { ok 0, $test_name },
        _update        => sub {
            is $_[1], 'TestClass', $test_name;
            is_deeply $_[2], { name => 'charles' }, 'Class updates';
        }
    );

    $fake_driver->update( 'TestClass', name => 'charles' );
}
