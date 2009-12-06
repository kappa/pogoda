#! /usr/bin/perl
use Test::Most qw/no_plan/;

use Pogoda::Test;
my ($cfg, $dbc) = pogoda_test;

use Pogoda::Users;
use Pogoda::Samples;
use_ok('Pogoda::Places');

my $params = {
    login => 'kappa',
    passwd => 'passwd1',
};

my $user = check_user($dbc, $params);

my @places = get_user_places($dbc, $user);
is(@places, 1, '1 default place');

is($places[0]->title, 'ИТМО', 'Default place is ITMO!');

$params = {
    title   => 'Московский вокзал',
    geo_lat => 59.9284,
    geo_long => 30.3618,
};

ok(my $place = add_place($dbc, $user, $params), 'Added 1 place');

is(get_user_places($dbc, $user), 2, '2 places after adding');
