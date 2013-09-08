package Gideon::Plugin::ResultSet;
use Moose;
use Gideon::ResultSet;

#ABSTRACT: Plugin for creating Gideon::ResulSet

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

__END__

=head1 NAME

Gideon::Plugin::ResultSet

=head1 DESCRIPTION

When C<find> is called in scalar context returns L<Gideon::ResultSet> preserving
query and options. This prevents calling the database until is absolutely necessary

=cut
