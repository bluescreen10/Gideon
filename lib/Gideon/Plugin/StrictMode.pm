package Gideon::Plugin::StrictMode;
use Moose;
use Gideon::Exceptions;

extends 'Gideon::Plugin';

sub find {
    my ( $self, $target, %query ) = @_;

    my $strict_mode = delete $query{-strict};
    my $result_set = $self->next->find( $target, %query );

    if ( $strict_mode and scalar @$result_set == 0 ) {
        Gideon::Exception::NotFound->throw;
    }

    $result_set;
}

sub find_one {
    my ( $self, $target, %query ) = @_;

    my $strict_mode = delete $query{-strict};
    my $result = $self->next->find_one( $target, %query );

    if ( $strict_mode and not defined $result ) {
        Gideon::Exception::NotFound->throw;
    }

    $result;
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
    my $result      = $self->next->save($target);

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

__PACKAGE__->meta->make_immutable;
1;
