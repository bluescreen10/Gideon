package Gideon::Meta::Class::Trait::Persisted;
use Moose::Role;

has '__is_persisted' => ( is => 'rw', isa => 'Bool' );

1;
