package Gideon::StoreRegistry;

my %stores;

sub register {
    my ( $class, $name, $resource ) = @_;
    $stores{$name} = $resource;
    return $resource;
}

sub store {
    my ( $class, $name ) = @_;
    return $stores{$name};
}

1;
