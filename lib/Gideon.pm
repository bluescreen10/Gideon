package Gideon;
use Moose;
use Moose::Exporter;
use Gideon::Plugin::Cache;
use Gideon::Plugin::StrictMode;
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

        my $cache = Gideon::Plugin::Cache->new( next => $driver->new );
        my $strict = Gideon::Plugin::StrictMode->new( next => $cache );
        my $result_set = Gideon::Plugin::ResultSet->new( next => $strict );

        my $target = caller;
        no strict 'refs';
        *{"${target}::find"}     = sub { $result_set->find(@_) };
        *{"${target}::find_one"} = sub { $result_set->find_one(@_) };
        *{"${target}::update"}   = sub { $result_set->update(@_) };
        *{"${target}::remove"}   = sub { $result_set->remove(@_) };
        *{"${target}::save"}     = sub { $result_set->save(@_) };
        use strict 'refs';
    }

    @_ = ($class);
    goto &$import;
}

1;
