package Gideon::Registry;

#ABSTRACT: Gideon Store Registry

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

__END__

=pod

=head1 NAME

Gideon::Registry - Register connection to data stores and cache

=head1 SYNOPSIS

  # Start up code
  use Gideon::Registry
  
  my $dbh = DBI->connect(...);
  Gideon::Registry->register_store( rdbm => $dbh );

=head1 DESCRIPTION

The Gideon::Registry is used typically at the start up of the program to register
the different data stores used by the application. It is also use to register a 
cache that will be used by the L<Gideon::Plugin::Cache>

=head1 METHODS

=head2 C<<register_store( name => $store ) >>

Register a instance of an store (C<$store>) under the name C<name>

=head2 C<register_cache( $cache )>

Register a C<$cache> to be used globally by Gideon

=cut
