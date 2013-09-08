package Gideon::Plugin::Cache;
use Moose;
use JSON;
use Gideon::Registry;

#ABSTRACT: Cache Plugin

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

__END__

=pod

=head1 NAME

Gideon::Plugin::Cache

=head1 SYNOPSIS

  # Cached search
  my @users = User->find( -cache_for => '10m' );
  # If a cache is registered by Gideon::Registry, attempts to retrieve the results
  # from the cache, if it not exists it will cache it for 10 minutes

  # Non-cached search
  my @users = User->find;

=head1 DESCRIPTION

You can use caching for hot searches whose results don’t change much. This plugin
uses the cache registered using L<Gideon::Registry> to get/set objects from it.

=cut
