package Gideon::Driver;
use Moose::Role;
use Gideon::Exceptions;

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

    my $is_object = ref $target;

    Gideon::Exception::ObjectNotInStore->throw
      if $is_object and not $target->__is_persisted;

    my $result =
        $is_object
      ? $driver->_update_object( $target, \%changes )
      : $driver->_update( $target, \%changes, {} );

    return $target if $result;
}

sub remove {
    my ( $driver, $target, %query ) = @_;

    my $is_object = ref $target;

    Gideon::Exception::ObjectNotInStore->throw
      if $is_object and not $target->__is_persisted;

    my $result =
        $is_object
      ? $driver->_remove_object($target)
      : $driver->_remove( $target, \%query );

    return $target if $result;
}

sub save {
    my ( $class, $target ) = @_;

    my $is_object = ref $target;

    Gideon::Exception::InvalidOperation->throw unless $is_object;

    my $result =
        $target->__is_persisted
      ? $class->_update_object($target)
      : $class->_insert_object($target);

    return $target if $result;
}

1;
