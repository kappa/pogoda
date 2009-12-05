#! /usr/bin/perl
use Test::Most qw/no_plan/;
use YAML qw/LoadFile/;

ok(my $cfg = LoadFile('config.yml'));
ok($cfg->{db_source});

use_ok('Pogoda::DB');

ok(my $dbc = Pogoda::DB->connect($cfg->{db_source}));

ok(my $samples = $dbc->resultset('Sample'));
