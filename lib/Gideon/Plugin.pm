package Gideon::Plugin;
use Moose;

has next => ( is => 'rw', required => 1 );

__PACKAGE__->meta->make_immutable;
1;
