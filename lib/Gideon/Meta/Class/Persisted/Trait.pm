package Gideon::Meta::Class::Persisted::Trait;
use Moose::Role;

has '__is_persisted' => ( is => 'rw', isa => 'Bool' );

1;
