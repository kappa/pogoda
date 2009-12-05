#! /usr/bin/perl
use Test::Most qw/no_plan/;

use Pogoda::Test;
my ($cfg, $dbc) = pogoda_test;

use_ok('Pogoda::Samples');

is(debug_all_samples($dbc), 0, '0 samples before adding');

my $params = {
    login => 'kappa',
    passwd => 'passwd1',
    geo_lat => '50',
    geo_long => '60',
    sensor_temp => '-8',
};

my $rv = add_sample($dbc, $params);

ok($rv, 'Added a sample for kappa!');

my @samples = debug_all_samples($dbc);
is(@samples, 1, '1 sample after adding');

is($samples[0]->sensor_temp, -8, 'Verified added sample');

$params->{passwd} .= 'bad';

throws_ok { $rv = add_sample($dbc, $params) } qr/wrong passwd/i, 'Refused bad passwd';

is(debug_all_samples($dbc), 1, 'Still 1 sample after failed adding');
