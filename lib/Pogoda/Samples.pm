package Pogoda::Samples;

use Carp;

use base 'Exporter';

our @EXPORT = qw/add_sample debug_all_samples get_user_samples/;

sub add_sample {
    my ($dbc, $user, $params) = @_;

    if ($user) {
        my $new_sample = $dbc->resultset('Sample')->new({
            userid      => $user->id,
            (map { $_ => $params->{$_} }
                qw/sensor_temp geo_lat geo_long/)
        });
        $new_sample->insert();

        return $new_sample;
    }
    else {
        croak "Wrong user";
    }
}

sub debug_all_samples {
    my ($dbc) = @_;

    my @samples = $dbc->resultset('Sample')->all;

    return @samples;
}

sub get_user_samples {
    my ($dbc, $user_id) = @_;

    my @samples = $dbc->resultset('Sample')->search({ userid => $user_id })->all;

    return @samples;
}

1;
