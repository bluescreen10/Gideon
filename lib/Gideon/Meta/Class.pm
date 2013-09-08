package Gideon::Meta::Class;
use Moose::Role;

#ABSTRACT: Gideon metaclass

has store => ( is => 'rw', isa => 'Str' );

1;

__END__

=pod

=head1 NAME

Gideon::Meta::Class - Metaclass for all Gideon classes

=head1 DESCRIPTION

All Gideon classes use this metaclass

=cut
