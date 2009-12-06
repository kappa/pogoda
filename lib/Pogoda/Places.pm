package Pogoda::Places;
use strict;
use warnings;

use Carp;

use base 'Exporter';

our @EXPORT = qw/add_place get_user_places/;

sub add_place {
    my ($dbc, $user, $params) = @_;

    if ($user) {
        my $new_place = $dbc->resultset('Place')->new({
            userid      => $user->id,
            (map { $_ => $params->{$_} }
                qw/title geo_lat geo_long/)
        });
        $new_place->insert();

        return $new_place;
    }
    else {
        croak "Wrong user";
    }
}

sub get_user_places {
    my ($dbc, $user) = @_;

    my @places = $dbc->resultset('Place')->search({ userid => $user->id })->all;

    return @places;
}

1;
