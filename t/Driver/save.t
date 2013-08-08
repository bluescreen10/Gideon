{

    package TestClass;
    use Moose;
    with 'Gideon::Meta::Class::Trait::Persisted';

    has id => ( is => 'rw', isa => 'Num' );

    __PACKAGE__->meta->make_immutable;
}

use MooseX::Test::Role;
use Gideon::Driver;
use Gideon::ResultSet;
use Moose::Util qw(apply_all_roles);
use Test::More tests => 4;

# new object save
{
    my $test_name   = 'new object dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _update_object => sub { ok 0, $test_name },
        _insert_object => sub {
            isa_ok $_[1], 'TestClass', $test_name;
        }
    );

    my $instance = TestClass->new;
    $fake_driver->save($instance);
    ok $instance->__is_persisted, 'persisted';
}

# existent object save
{
    my $test_name   = 'existent object dispatched correctly';
    my $fake_driver = consumer_of(
        'Gideon::Driver',
        _insert_object => sub { ok 0, $test_name },
        _update_object => sub {
            isa_ok $_[1], 'TestClass', $test_name;
        }
    );

    my $instance = TestClass->new;
    $instance->__is_persisted(1);
    $fake_driver->save($instance);
}

# class save
{
    my $fake_driver = consumer_of( 'Gideon::Driver', );
    eval { $fake_driver->update( 'TestClass', name => 'charles' ); };
    ok !$@, 'class cannot be saved';
}
