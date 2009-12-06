package Pogoda::Users;
use strict;
use warnings;

use Carp;

use base 'Exporter';

our @EXPORT = qw/add_user debug_all_users check_user/;

sub add_user {
    my ($dbc, $params) = @_;

    unless ($params->{passwd} eq $params->{passwd2}) {
        croak 'passwd not verified';
    }

    my $user =
        $dbc->resultset('User')->new({
            login => $params->{login},
            passwd => $params->{passwd},
            name => $params->{name},
            email => $params->{email},
        }) or croak;
    $user->insert() or croak;

    return $user;
}

sub check_user {
    my ($dbc, $params) = @_;

    my $user =
    $dbc->resultset('User')->search({ login => $params->{login} })->first;

    unless ($user && $user->passwd eq $params->{passwd}) {
        croak "Wrong passwd";
    }

    return $user;
}

sub debug_all_users {
    my ($dbc) = @_;

    my @users = $dbc->resultset('User')->all;

    return @users;
}

1;
