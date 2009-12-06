#! /usr/bin/perl
use Test::Most qw/no_plan/;

use Pogoda::Test;
my ($cfg, $dbc) = pogoda_test;

use_ok('Pogoda::Samples');
use_ok('Pogoda::Users');

is(debug_all_samples($dbc), 0, '0 samples before adding');

my $params = {
    login => 'kappa',
    passwd => 'passwd1',
    geo_lat => '50',
    geo_long => '60',
    sensor_temp => '-8',
};

my $user = check_user($dbc, $params);

my $rv = add_sample($dbc, $user, $params);

ok($rv, 'Added a sample for kappa!');

my @samples = debug_all_samples($dbc);
is(@samples, 1, '1 sample after adding');

is($samples[0]->sensor_temp, -8, 'Verified added sample');

throws_ok { $rv = add_sample($dbc, undef, $params) } qr/wrong user/i, 'Refused bad user';

is(debug_all_samples($dbc), 1, 'Still 1 sample after failed adding');
