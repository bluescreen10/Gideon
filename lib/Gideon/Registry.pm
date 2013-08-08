package Gideon::Registry;

my %stores;
my $cache;

sub register_store {
    my ( $class, $name, $resource ) = @_;
    $stores{$name} = $resource;
    return $resource;
}

sub register_cache {
    my ( $class, $resource ) = @_;
    $cache = $resource;
    return $resource;
}

sub get_store {
    my ( $class, $name ) = @_;
    return $stores{$name};
}

sub get_cache {
    return $cache;
}

sub has_cache {
    return defined $cache;
}

1;
