package Gideon::Plugin::StrictMode;
use Moose;
use Gideon::Exceptions;

extends 'Gideon::Plugin';

sub find {
    my $self = shift;
    $self->_find( 'find', @_ );
}

sub find_one {
    my $self = shift;
    $self->_find( 'find_one', @_ );
}

sub update {
    my ( $self, $target, %changes ) = @_;

    my $strict_mode = delete $changes{-strict};
    my $result = $self->next->update( $target, %changes );

    if ( $strict_mode and not $result ) {
        Gideon::Exception::UpdateFailure->throw;
    }

    $result;
}

sub save {
    my ( $self, $target, %options ) = @_;

    my $strict_mode = delete $options{-strict};
    my $result = $self->next->save( $target );

    if ( $strict_mode and not $result ) {
        Gideon::Exception::SaveFailure->throw;
    }

    $result;
}

sub remove {
    my ( $self, $target, %query ) = @_;

    my $strict_mode = delete $query{-strict};
    my $result = $self->next->remove( $target, %query );

    if ( $strict_mode and not $result ) {
        Gideon::Exception::RemoveFailure->throw;
    }

    $result;
}

sub _find {
    my ( $self, $method, $target, %query ) = @_;

    my $strict_mode = delete $query{-strict};
    my $result_set = $self->next->$method( $target, %query );

    if ( $strict_mode and scalar @$result_set == 0 ) {
        Gideon::Exception::NotFound->throw;
    }

    $result_set;
}

__PACKAGE__->meta->make_immutable;
1;
