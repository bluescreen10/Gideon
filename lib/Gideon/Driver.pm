package Gideon::Driver;

use Moose::Role;
use Gideon::ResultSet;
use Gideon::StoreRegistry;

requires qw(_find _update _update_object _remove _remove_object);

sub find {
    my ( $driver, $target, %query ) = @_;

    my $order = delete $query{-order};

    return wantarray
      ? $driver->_find( $target, \%query, $order )
      : Gideon::ResultSet->new(
        target => $target,
        query  => \%query,
        order  => $order
      );
}

sub find_one {
    my ( $driver, $target, %query ) = @_;

    my $order = delete $query{-order};

    return ( $driver->_find( $target, \%query, $order, 1 ) )[0];
}

sub update {
    my ( $driver, $target, %changes ) = @_;

    if ( ref $target eq 'Gideon::ResultSet' ) {
        my $query = $target->query;
        delete $query->{-order};
        $driver->_update( $target->target, \%changes, $query );
    }

    elsif ( ref $target ) {
        my $rv = $driver->_update_object( $target, \%changes );

        if ($rv) {
            $target->$_( $changes{$_} ) for keys %changes;

        }

        return $rv;
    }

    else {
        $driver->_update( $target, \%changes, {} );
    }
}

sub remove {
    my ( $driver, $target ) = @_;

    if ( ref $target eq 'Gideon::ResultSet' ) {
        my $query = $target->query;
        delete $query->{-order};
        $driver->_remove( $target->target, $query );
    }

    elsif ( ref $target ) {
        $driver->_remove_object($target);
    }

    else {
        $driver->_remove( $target, {} );
    }
}

sub save { }

1;
