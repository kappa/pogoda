package Pogoda::Test;

use base 'Exporter';

our @EXPORT = qw/pogoda_test/;

use YAML qw/LoadFile/;
use Pogoda::DB;

sub pogoda_test {
    my $cfg = LoadFile('config.yml');   # XXX config test
    my $dbc = Pogoda::DB->connect($cfg->{db_source});
    # XXX clean DB

    return ($cfg, $dbc);
}

1;
