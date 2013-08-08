package Gideon::Plugin::ResultSet;
use Moose;
use Gideon::ResultSet;

extends 'Gideon::Plugin';

sub find {
    my ( $self, $target, %query ) = @_;

    if ( wantarray() ) {
        my $rs = $self->next->find( $target, %query );
        return @$rs;
    }
    else {
        my $order = delete $query{-order};
        return Gideon::ResultSet->new(
            driver => $self,
            target => $target,
            query  => \%query,
            order  => $order
        );
    }
}

__PACKAGE__->meta->make_immutable;
1;
