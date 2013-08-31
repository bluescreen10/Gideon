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
        return Gideon::ResultSet->new(
            driver => $self->next,
            target => $target,
            query  => \%query,
        );
    }
}

__PACKAGE__->meta->make_immutable;
1;
