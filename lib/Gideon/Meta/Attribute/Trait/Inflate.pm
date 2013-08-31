package Gideon::Meta::Attribute::Trait::Inflate;
use Moose::Role;

with 'Gideon::Meta::Attribute::Trait::Inflated';

Moose::Util::meta_attribute_alias('Gideon::Inflate');

has inflator => ( is => 'ro', isa => 'CodeRef' );
has deflator => ( is => 'ro', isa => 'CodeRef' );

sub get_inflator {
    my $self = shift;
    $self->inflator;
}

sub get_deflator {
    my $self = shift;
    $self->deflator;
}

1;
