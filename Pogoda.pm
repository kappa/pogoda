package Pogoda;
use Dancer;
use Template;
use Pogoda::Samples;
use Pogoda::Users;
use Pogoda::DB;
use Data::Dumper;

get '/' => sub {
    my @samples = debug_all_samples(vars->{dbc});

    template 'index' => { samples => \@samples };
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
        redirect '/user?back=/sample';
    }
    template 'sample_web_form';
};
post '/sample' => sub {
    if (! session('user_id')) {
        redirect '/sample';
    }
    if (params->{submit}) {
        add_sample(vars->{dbc}, params);

        template 'thanks';
    }
    else {
        status 503;
    }
};

get '/user' => sub {
    template 'login_or_reg';
};

post '/login' => sub {
    my $user;
    if (params->{login} && params->{passwd}
        && ($user = check_user(vars->{dbc}, params)))
    {
        session user_id => $user->id;
        session user_login => $user->login;
    }

    redirect params->{back} || '/';
};

post '/reg' => sub {
    my $user = add_user(vars->{dbc}, params);

    session user_id => $user->id;
    session user_login => $user->login;

    template 'thanks';
};

# --------------------------------------------------
# API
# --------------------------------------------------

get '/get_test_data' => sub {
    my @samples = debug_all_samples(vars->{dbc});

    template 'test_data' => { samples => \@samples };
};

get '/test_sample_form' => sub {
    template 'sample_form';
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
