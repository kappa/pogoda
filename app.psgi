use lib '/home/kappa/work/pogoda';
use Pogoda;

use Dancer::Config 'setting';
setting apphandler  => 'PSGI';
#setting environment => 'production';
Dancer::Config->load;

my $handler = sub {
    my $env = shift;
    my $request = Dancer::Request->new($env);
    Dancer->dance($request);
};
