package Gideon::Meta::Class::Trait::Persisted;
use Moose::Role;

#ABSTRACT: Persisted class role

has '__is_persisted' => ( is => 'rw', isa => 'Bool' );

1;

__END__

=pod

=head1 NAME

Gideon::Meta::Class::Trait::Persisted

=head1 DESCRIPTION

Attribute used by Gideon to determine if an object is persisted within a data store
or not

=cut
