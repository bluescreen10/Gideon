package Gideon::Meta::Attribute::Trait::DBI::Column;
use Moose::Role;

Moose::Util::meta_attribute_alias('Gideon::DBI::Column');

has column      => ( is => 'ro', isa => 'Str' );
has primary_key => ( is => 'ro', isa => 'Bool' );
has serial      => ( is => 'ro', isa => 'Bool' );

1;
