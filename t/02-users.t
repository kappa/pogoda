#! /usr/bin/perl
use Test::Most qw/no_plan/;

use Pogoda::Test;
my ($cfg, $dbc) = pogoda_test;

ok(my $users = $dbc->resultset('User'), 'Found Users resultset');

my $kappa = $users->search({
        login   => 'kappa',
    })->first;

ok($kappa, 'Found kappa');

is($kappa->passwd, 'passwd1');
is($kappa->name, 'Alex Kapranoff');
