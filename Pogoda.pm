package Pogoda;
use Dancer;
use Template;
use Pogoda::Samples;
use Pogoda::DB;

get '/' => sub {
    template 'index';
};

before sub {
    var dbc =>
        Pogoda::DB->connect("dbi:SQLite:dbname=" . set('sqlite_file_test')); # XXX
};

get '/get_test_data' => sub {
    my @samples = debug_all_samples(vars->{dbc});

    template 'test_data' => { samples => \@samples };
};

get '/test_sample_form' => sub {
    template 'sample_form.tt';
};

get '/post_sample' => sub {
    eval {
        add_sample(vars->{dbc}, params);
    };
    if ($@) {
        status 500;
    }
    else {
        return "OK";
    }
};

true;
