package Gideon::Meta::Attribute::Trait::DBI::Column;
use Moose::Role;

#ABSTRACT: Column attribute trait

Moose::Util::meta_attribute_alias('Gideon::DBI::Column');

has column      => ( is => 'ro', isa => 'Str' );
has primary_key => ( is => 'ro', isa => 'Bool' );
has serial      => ( is => 'ro', isa => 'Bool' );

1;

__END__

=pod

=head1 NAME

Gideon::Meta::Attribute::Trait::DBI::Column - Column attribute trait

=head1 DESCRIPTION

It add properties to the attribute that Gideon::Driver::DBI uses to operate on
RDB

=cut
