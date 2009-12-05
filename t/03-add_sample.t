#! /usr/bin/perl
use Test::Most qw/no_plan/;
use YAML qw/LoadFile/;
use Pogoda::DB;

my $cfg = LoadFile('config.yml');

my $dbc = Pogoda::DB->connect($cfg->{db_source});

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

