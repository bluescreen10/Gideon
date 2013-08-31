package TestFor::Gideon::Plugin;
use Test::Class::Moose;
use Test::MockObject;

with 'Test::Class::Moose::Role::AutoUse';

sub test_dispatch {

    my $fake_driver = Test::MockObject->new;
    $fake_driver->mock( find     => sub { ok 1, 'find: dispatched' } );
    $fake_driver->mock( find_one => sub { ok 1, 'find: dispatched' } );
    $fake_driver->mock( remove   => sub { ok 1, 'find: dispatched' } );
    $fake_driver->mock( update   => sub { ok 1, 'find: dispatched' } );
    $fake_driver->mock( save     => sub { ok 1, 'find: dispatched' } );

    my $plugin = Gideon::Plugin->new( next => $fake_driver);
    $plugin->find;
    $plugin->find_one;
    $plugin->save;
    $plugin->remove;
    $plugin->update;
}

1;
