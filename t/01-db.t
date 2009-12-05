#! /usr/bin/perl
use Test::Most qw/no_plan/;
use YAML qw/LoadFile/;

ok(my $cfg = LoadFile('config.yml'), 'config available');
ok($cfg->{sqlite_file_test}, 'sqlite_file_test is in config');

use_ok('Pogoda::DB');

ok(my $dbc = Pogoda::DB->connect("dbi:SQLite:dbname=$cfg->{sqlite_file_test}"), 'connected to DB');

ok(my $samples = $dbc->resultset('Sample'), 'Found Sample resultset');
