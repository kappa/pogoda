package Pogoda;
use Dancer;
use Template;
use Pogoda::Samples;
use Pogoda::Users;
use Pogoda::DB;
use Data::Dumper;

get '/' => sub {
    template 'index';
};

before sub {
    var dbc =>
        Pogoda::DB->connect("dbi:SQLite:dbname=" . set('sqlite_file_test')); # XXX
};

# --------------------------------------------------
# Web UI
# --------------------------------------------------

get '/sample' => sub {
    if (! session('user_id')) {
        redirect '/user';
    }
    template 'sample_web_form.tt';
};
post '/sample' => sub {
    if (params->{submit}) {
        add_sample(vars->{dbc}, params);

        template 'thanks.tt';
    }
    else {
        status 503;
    }
};

get '/user' => sub {
    template 'login_or_reg.tt';
};

post '/login' => sub {
    my $user;
    if (params->{login} && params->{passwd}
        && ($user = check_user(vars->{dbc}, params)))
    {
        session user_id => $user->id;
        session user_login => $user->login;
    }
};

post '/reg' => sub {
    my $user = add_user(vars->{dbc}, params);

    session user_id => $user->id;
    session user_login => $user->login;

    template 'thanks.tt';
};

# --------------------------------------------------
# API
# --------------------------------------------------

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
