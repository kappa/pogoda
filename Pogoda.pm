package Pogoda;
use Dancer;
use Template;
use Pogoda::Samples;
use Pogoda::Users;
use Pogoda::DB;
use strict;
use warnings;

get '/' => sub {
    # XXX this filtering should be on INPUT to db
    my @samples = grep { $_->geo_lat =~ /^\d+\.\d+$/ && $_->geo_long =~ /^\d+\.\d+$/ } debug_all_samples(vars->{dbc});

    template 'index' => {
        samples => \@samples,
        user => vars->{user},
        need_gmap => 1,
    };
};

before sub {
    var dbc =>
        Pogoda::DB->connect("dbi:SQLite:dbname=" . set('sqlite_file'));

    if (session('user_id')) {
        var user => vars->{dbc}->resultset('User')->search({ id => session('user_id') })->first;
    }
};

# --------------------------------------------------
# Web UI
# --------------------------------------------------

get '/sample' => sub {
    unless (vars->{user}) {
        redirect '/login?back=/sample';
    }
    template 'sample_web_form' => {
        user => vars->{user},
        need_gmap => 1,
    };
};
post '/sample' => sub {
    unless (vars->{user}) {
        redirect '/sample';
    }
    if (params->{submit}) {
        add_sample(vars->{dbc}, vars->{user}, {params});

        template 'thanks' => {
            user => vars->{user},
            back_text => 'Вернуться в кабинет',
            back_url => '/user',
        };
    }
    else {
        status 503;
    }
};

get '/user' => sub {
    unless (vars->{user}) {
        redirect '/login?back=/user';
    }

    template 'user' => {
        user    => vars->{user},
        samples => [get_user_samples(vars->{dbc}, vars->{user})]
    };
};

get '/logout' => sub {
    if (vars->{user}) {
        session user_id => undef;
        var user => undef;
    }

    redirect params->{back} || '/';
};

get '/login' => sub {
    if (vars->{user}) {
        redirect params->{back} || '/';
    }
    else {
        template 'login' => { back => params->{back} };
    }
};

post '/login' => sub {
    my $user;
    if (params->{login} && params->{passwd}
        && ($user = check_user(vars->{dbc}, {params})))
    {
        session user_id => $user->id;
        session user_login => $user->login;
    }

    redirect params->{back} || '/user';
};

get '/reg' => sub {
    if (vars->{user}) {
        redirect params->{back} || '/';
    }
    else {
        template 'reg' => { back => params->{back} };
    }
};

post '/reg' => sub {
    my $user = add_user(vars->{dbc}, {params});

    session user_id => $user->id;
    session user_login => $user->login;

    redirect params->{back} || '/user';
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
        if (params->{login} && params->{passwd}
            && (my $user = check_user(vars->{dbc}, params)))
        {
            add_sample(vars->{dbc}, $user, params);
        }
    };
    if ($@) {
        status 503;
    }
    else {
        return "OK";
    }
};

true;
