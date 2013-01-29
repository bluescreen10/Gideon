package Gideon;

use Moose;
use Moose::Exporter;

#ABSTRACT: DataMapper between storage and Moose objects

my ($import) = Moose::Exporter->build_import_methods(
    class_metaroles => { class => ['Gideon::Meta::Class'] },
    also            => ['Moose'],
    install          => [ 'unimport', 'init_meta' ],
    base_class_roles => ['Gideon::Meta::Class::Persisted::Trait'],
);

sub import {
    my ( $class, %args ) = @_;

    if ( $args{driver} ) {

        my $driver = "Gideon::$args{driver}";
        eval "use $driver";
        die "Can't load driver $args{driver}: $@" if $@;

        my $target = caller;
        no strict 'refs';
        *{ $target . "::find" }     = sub { $driver->find(@_) };
        *{ $target . "::find_one" } = sub { $driver->find_one(@_) };
        *{ $target . "::update" }   = sub { $driver->update(@_) };
        *{ $target . "::remove" }   = sub { $driver->remove(@_) };
        *{ $target . "::save" }     = sub { $driver->save(@_) };
        use strict 'refs';
    }

    @_ = ($class);
    goto &$import;
}

1;
