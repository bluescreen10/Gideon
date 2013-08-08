use strict;
use warnings;
use Gideon::Registry;
use Gideon::Plugin::Cache;
use Test::MockObject;
use Test::More tests => 9;

{
    my %query = (
        id     => 1,
        -order => { desc => 'id' }
    );

    my $fake_cache = Test::MockObject->new->mock(
        get => sub {
            ok $_[1], 'Key';
            return;
        }
      )->mock(
        set => sub {
            ok $_[1], 'Key';
            is scalar @{ $_[2] }, 1, 'Elements';
            is $_[3], '10m', 'Expiration';
        }
      );

    my $fake_driver = Test::MockObject->new->mock(
        find => sub {
            my ( $self, $target, %actual_query ) = @_;
            is $target, 'TestClass', 'Test Class';
            is_deeply \%actual_query, \%query, 'Query';
            return ['Some Result'];
        }
    );

    Gideon::Registry->register_cache($fake_cache);
    my $plugin = Gideon::Plugin::Cache->new( next => $fake_driver );

    my $rs = $plugin->find( 'TestClass', %query, -cache_for => '10m' );
    is scalar @$rs, 1, '1 result back';
}

{
    my %query = (
        id     => 1,
        -order => { desc => 'id' }
    );

    my $fake_cache = Test::MockObject->new->mock(
        get => sub {
            ok $_[1], 'Key';
            return ['Some Result'];
        }
    );

    Gideon::Registry->register_cache($fake_cache);
    my $plugin = Gideon::Plugin::Cache->new( next => undef );

    my $rs = $plugin->find( 'TestClass', %query, -cache_for => '10m', );
    is scalar @$rs, 1, '1 result back';
}
