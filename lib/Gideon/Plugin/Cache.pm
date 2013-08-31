package Gideon::Plugin::Cache;
use Moose;
use JSON;
use Gideon::Registry;

extends 'Gideon::Plugin';

my $serializer = JSON->new->utf8->canonical;

sub find_one {
    my ( $self, $target, %query ) = @_;
    $self->_compute( 'find_one', $target, %query );
}

sub find {
    my ( $self, $target, %query ) = @_;
    $self->_compute( 'find', $target, %query );
}

sub _compute {
    my ( $self, $method, $target, %query ) = @_;

    my $expiration = delete $query{-cache_for};

    if ( Gideon::Registry->has_cache and $expiration ) {
        my $key   = $self->_serialize_key( $target, \%query );
        my $cache = Gideon::Registry->get_cache;
        my $rs    = $cache->get($key);

        return $rs if $rs;

        $rs = $self->next->$method( $target, %query );
        $cache->set( $key, $rs, $expiration );
        return $rs;
    }
    else {
        return $self->next->$method( $target, %query );
    }
}

sub _serialize_key {
    my ( $self, $prefix, $obj ) = @_;
    return "$prefix:" . $serializer->encode($obj);
}

__PACKAGE__->meta->make_immutable;
1;
