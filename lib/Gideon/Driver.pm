package Gideon::Driver;
use Moose::Role;
use Moose::Util qw(apply_all_roles);

requires qw(_find _update _update_object _remove _remove_object _insert_object);

sub find {
    my ( $driver, $target, %query ) = @_;

    my $order = delete $query{-order};
    $driver->_find( $target, \%query, $order );
}

sub find_one {
    my ( $driver, $target, %query ) = @_;

    my $order = delete $query{-order};
    $driver->_find( $target, \%query, $order, 1 )->[0];
}

sub update {
    my ( $driver, $target, %changes ) = @_;

    if ( ref $target ) {
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

    if ( ref $target ) {
        my $rv = $driver->_remove_object($target);
        $target->__is_persisted(undef) if $rv;
        return $rv;
    }

    else {
        $driver->_remove( $target, {} );
    }
}

sub save {
    my ( $class, $target ) = @_;

    die unless ref $target;

    if ( $target->__is_persisted ) {
        $class->_update_object($target);
    }

    else {
        if ( my $rv = $class->_insert_object($target) ) {
            $target->__is_persisted(1);
            return $rv;
        }
    }
}

1;
