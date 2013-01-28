package Gideon;

use Moose;
use Moose::Exporter;

#ABSTRACT: DataMapper between storage and Moose objects

my ($import) = Moose::Exporter->build_import_methods(
    class_metaroles => { class => ['Gideon::Meta::Class'] },
    also            => ['Moose'],
    install => [ 'unimport', 'init_meta' ],
);

sub import {
    my ( $class, %args ) = @_;

    if ( $args{driver} ) {

        my $driver_class = "Gideon::$args{driver}";
        eval "use $driver_class";
        die "Can't load driver $args{driver}: $@" if $@;

        my $target = caller;
        no strict 'refs';
        *{ $target . "::find" }     = sub { $driver_class->find(@_) };
        *{ $target . "::find_one" } = sub { $driver_class->find_one(@_) };
        *{ $target . "::update" }   = sub { $driver_class->update(@_) };
        *{ $target . "::remove" }   = sub { $driver_class->remove(@_) };
        *{ $target . "::save" }     = sub { $driver_class->save(@_) };
        use strict 'refs';
    }

    @_ = ($class);
    goto &$import;
}

1;
