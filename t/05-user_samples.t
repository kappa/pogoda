#! /usr/bin/perl
use Test::Most qw/no_plan/;

use Pogoda::Test;
my ($cfg, $dbc) = pogoda_test;

use Pogoda::Samples;
use Pogoda::Users;

is(debug_all_samples($dbc), 0, '0 samples before adding');

my $params = {
    login => 'kappa',
    passwd => 'passwd1',
    geo_lat => '50',
    geo_long => '60',
    sensor_temp => '-8',
};

my $user = check_user($dbc, $params);
ok($user, 'User kappa exists');

is(get_user_samples($dbc, $user->id), 0, '0 user samples before adding');

my $rv = add_sample($dbc, $params);

ok($rv, 'Added a sample for kappa!');

my @samples = debug_all_samples($dbc);
is(@samples, 1, '1 sample after adding');

is(get_user_samples($dbc, $user->id), 1, '1 user sample after adding');
