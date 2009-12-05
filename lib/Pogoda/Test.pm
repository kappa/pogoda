package Pogoda::Test;

use base 'Exporter';

our @EXPORT = qw/pogoda_test/;

use YAML qw/LoadFile/;
use Pogoda::DB;

sub pogoda_test {
    my $cfg = LoadFile('config.yml');
    
    system("rm $cfg->{sqlite_file_test}");
    system("sqlite3 $cfg->{sqlite_file_test} < sql/schema.sql");

    my $dbc = Pogoda::DB->connect("dbi:SQLite:dbname=$cfg->{sqlite_file_test}");

    return ($cfg, $dbc);
}

1;
