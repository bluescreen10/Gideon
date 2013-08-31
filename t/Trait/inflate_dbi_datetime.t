#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 2;

BEGIN {

    package MyClass;
    use Moose;
    use Gideon::Meta::Attribute::Trait::DBI::Inflate::DateTime;

    has attribute => (
        is     => 'rw',
        traits => ['Gideon::DBI::Inflate::DateTime'],
    );

    __PACKAGE__->meta->make_immutable;
}

{
    no warnings;
    *DBI::_dbtype_names = sub { ('MySQL') };
}

my $class = MyClass->new;

my ($inflator) =
  map  { $_->get_inflator }
  grep { $_->does('Gideon::Inflated') } MyClass->meta->get_all_attributes;

my ($deflator) =
  map  { $_->get_deflator }
  grep { $_->does('Gideon::Inflated') } MyClass->meta->get_all_attributes;

my $timestamp = DateTime->new(
    year   => 2013,
    month  => 1,
    day    => 2,
    hour   => 11,
    minute => 22,
    second => 33
);

is $inflator->("2013-01-02 11:22:33"), $timestamp, 'Inflator Result';
is $deflator->($timestamp), "2013-01-02 11:22:33", 'Deflator Result';
