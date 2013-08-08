package Gideon::Driver;
use Moose::Role;
use Moose::Util qw(apply_all_roles);

requires qw(_find _update _update_object _remove _remove_object _insert_object);

sub find {
    my ( $driver, $target, %query ) = @_;

    my $order = delete $query{-order};
    my @rs = $driver->_find( $target, \%query, $order );
    $_->__is_persisted(1) for @rs;
    return \@rs;
}

sub find_one {
    my ( $driver, $target, %query ) = @_;

    my $order = delete $query{-order};
    my ($instance) = $driver->_find( $target, \%query, $order, 1 );
    $instance->__is_persisted(1);
    return $instance;
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
    die if ref $target eq 'Gideon::ResultSet';

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
