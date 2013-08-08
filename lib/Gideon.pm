package Gideon;
use Moose;
use Moose::Exporter;
use Gideon::Plugin::Cache;
use Gideon::Plugin::ResultSet;
use Gideon::Meta::Class::Trait::Persisted;
use Carp qw(croak);

#ABSTRACT: DataMapper between storage and Moose objects

my ($import) = Moose::Exporter->build_import_methods(
    class_metaroles => { class => ['Gideon::Meta::Class'] },
    also            => ['Moose'],
    install          => [ 'unimport', 'init_meta' ],
    base_class_roles => ['Gideon::Meta::Class::Trait::Persisted'],
);

sub import {
    my ( $class, %args ) = @_;

    if ( $args{driver} ) {

        my $driver = "Gideon::Driver::$args{driver}";
        eval "require $driver";
        croak "Can't load driver $args{driver}: $@" if $@;

        my $chain =
          Gideon::Plugin::ResultSet->new(
            next => Gideon::Plugin::Cache->new( next => $driver->new ) );

        my $target = caller;
        no strict 'refs';
        *{ $target . "::find" }     = sub { $chain->find(@_) };
        *{ $target . "::find_one" } = sub { $chain->find_one(@_) };
        *{ $target . "::update" }   = sub { $chain->update(@_) };
        *{ $target . "::remove" }   = sub { $chain->remove(@_) };
        *{ $target . "::save" }     = sub { $chain->save(@_) };
        use strict 'refs';
    }

    @_ = ($class);
    goto &$import;
}

1;
