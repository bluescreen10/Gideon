package Gideon::Meta::Attribute::Trait::Inflated;
use Moose::Role;

Moose::Util::meta_attribute_alias('Gideon::Inflated');

requires 'get_inflator', 'get_deflator';

1;
