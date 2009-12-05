package Pogoda::Samples;

use Carp;

use base 'Exporter';

our @EXPORT = qw/add_sample/;

sub add_sample {
    my ($dbc, $params) = @_;

    my $user =
    $dbc->resultset('User')->search({ login => $params->{login} })->first;

    if ($user && $user->passwd eq $params->{passwd}) {
        my $new_sample = $dbc->resultset('Sample')->new({
            userid      => $user->id,
            (map { $_ => $params->{$_} }
                qw/sensor_temp geo_lat geo_long/)
        });
        $new_sample->insert();

        return $new_sample;
    }
    else {
        croak "Wrong passwd";
    }
}

1;
