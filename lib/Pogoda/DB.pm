#! /usr/bin/perl
use strict;
use warnings;

package Pogoda::DB;
use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_classes('Sample');

1;
