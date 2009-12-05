#! /usr/bin/perl
use Test::Most qw/no_plan/;

use Pogoda::Test;
my ($cfg, $dbc) = pogoda_test;

use_ok('Pogoda::Samples');

my $params = {
    login => 'kappa',
    passwd => 'passwd1',
    geo_lat => '50',
    geo_long => '60',
    sensor_temp => '-8',
};

my $rv = add_sample($dbc, $params);

ok($rv, 'Added a sample for kappa!');

$params->{passwd} .= 'bad';

throws_ok { $rv = add_sample($dbc, $params) } qr/wrong passwd/i, 'Refused bad passwd';

