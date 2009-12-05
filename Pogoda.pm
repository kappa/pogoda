package Pogoda;
use Dancer;
use Template;

get '/' => sub {
    template 'index';
};

true;
