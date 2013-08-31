package Gideon::Meta::Attribute::Trait::Inflate::DateTime;
use Moose::Role;

with 'Gideon::Meta::Attribute::Trait::Inflated';

Moose::Util::meta_attribute_alias('Gideon::Inflate::DBI::DateTime');


sub get_inflator {
    my ( $self, $source ) = @_;
    $self->inflator;
}

sub get_deflator {
    my ( $self, $source ) = @_;
    $self->deflator;
}

1;
