#! /usr/bin/perl
use Test::Most qw/no_plan/;
use YAML qw/LoadFile/;

ok(my $cfg = LoadFile('config.yml'), 'config available');
ok($cfg->{db_source}, 'db_source is in config');

use_ok('Pogoda::DB');

ok(my $dbc = Pogoda::DB->connect($cfg->{db_source}), 'connected to DB');

ok(my $samples = $dbc->resultset('Sample'), 'Found Sample resultset');
