package Gideon::Meta::Attribute::DBI::Column;
use Moose::Role;

Moose::Util::meta_attribute_alias('Gideon::DBI::Column');

has column      => ( is => 'ro', isa => 'Str' );
has primary_key => ( is => 'ro', isa => 'Bool' );
has _is_dirty   => ( is => 'rw', isa => 'Bool' );

after set_value => sub {
    print STDERR "hello\n";
    $_[0]->_is_dirty(1);
};

1;
