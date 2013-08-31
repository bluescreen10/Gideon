#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;

BEGIN {

    package MyClass;
    use Moose;
    use Gideon::Meta::Attribute::Trait::Inflate;

    has attribute => (
        is       => 'rw',
        inflator => sub { 'inflated' },
        deflator => sub { 'deflated' },
        traits   => ['Gideon::Inflate'],
    );

    __PACKAGE__->meta->make_immutable;
}

my $class = MyClass->new;

my ($inflator) =
  map  { $_->get_inflator }
  grep { $_->does('Gideon::Inflated') } MyClass->meta->get_all_attributes;

my ($deflator) =
  map  { $_->get_deflator }
  grep { $_->does('Gideon::Inflated') } MyClass->meta->get_all_attributes;

is $inflator->(), 'inflated', 'Inflator Result';
is $deflator->(), 'deflated', 'Deflator Result';
