#! /usr/bin/perl
use Test::Most qw/no_plan/;

use Pogoda::Test;
my ($cfg, $dbc) = pogoda_test;

use_ok('Pogoda::Users');

my $params = {
    login => 'shlyappa',
    passwd => 'sekret',
    passwd2 => 'sekret',
    email => 'kkapp@rambler.ru',
};

my $user = add_user($dbc, $params);

ok($user, 'Added user!');

my @users = debug_all_users($dbc);
is(@users, 2, '2 users after adding');

is($users[1]->passwd, 'sekret', 'Verified added user passwd');

$params->{passwd2} .= 'bad';

throws_ok { $rv = add_user($dbc, $params) } qr/passwd not verified/i, 'Refused non-identical second passwd';

is(debug_all_users($dbc), 2, 'Still 2 sample after failed adding');

ok(check_user($dbc, $params), 'Checked user');
