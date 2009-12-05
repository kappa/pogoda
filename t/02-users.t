#! /usr/bin/perl
use Test::Most qw/no_plan/;
use YAML qw/LoadFile/;
use Pogoda::DB;

my $cfg = LoadFile('config.yml');

my $dbc = Pogoda::DB->connect($cfg->{db_source});

ok(my $users = $dbc->resultset('User'), 'Found Users resultset');

my $kappa = $users->search({
        login   => 'kappa',
    })->first;

ok($kappa, 'Found kappa');

is($kappa->passwd, 'passwd1');
is($kappa->name, 'Alex Kapranoff');
