package Gideon::ResultSet;
use Moose;
use overload
  '@{}'    => sub { $_[0]->elements },
  fallback => 1;

has driver => ( is => 'ro', required => 1 );
has target => ( is => 'ro', required => 1 );
has query  => ( is => 'ro' );
has elements => ( is => 'ro', builder => '_build_elements', lazy => 1 );

sub size {
    my $self = shift;
    return scalar @{ $self->elements };
}

sub _build_elements {
    my $self     = shift;
    my @elements = $self->driver->find( %{ $self->query } );
    return \@elements;
}

sub find {
    my ( $self, %query ) = @_;

    return $self->new(
        driver => $self->driver,
        target => $self->target,
        query  => $self->_combine_query( \%query )
    );
}

sub _combine_query {
    my ( $self, $query2 ) = @_;
    my $query = $self->query;

    return $query  unless $query2;
    return $query2 unless $query;

    my $new_query = {};
    my @keys = keys %{ { %$query, %$query2 } };

    foreach my $key (@keys) {
        my $value1 = $query->{$key};
        my $value2 = $query2->{$key};

        $new_query->{$key} = $value1 unless $value2;
        $new_query->{$key} = $value2 unless $value1;

        if ( $value1 and $value2 ) {
            $new_query->{$key} = [ -and => $value1, $value2 ];
        }

    }

    return $new_query;
}

__PACKAGE__->meta->make_immutable;
