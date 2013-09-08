package Gideon::Meta::Attribute::Trait::Inflated;
use Moose::Role;

#ABSTRACT: Inflated Role

Moose::Util::meta_attribute_alias('Gideon::Inflated');

requires 'get_inflator', 'get_deflator';

1;

__END__

=head1 NAME

Gideon::Meta::Attribute::Trait::Inflated - Inflated Role

=head1 ALIAS

Gideon::Inflate

=head1 DESCRIPTION

Interface for inflated attributes

=cut
