package Pogoda::DB::User;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto InflateColumn::DateTime Core/);
__PACKAGE__->table('users');
__PACKAGE__->add_columns(qw/
    id
    login
    passwd
    name
    email
/);
__PACKAGE__->add_columns(ctime => {data_type => 'datetime'});
__PACKAGE__->set_primary_key('id');
__PACKAGE__->sequence(__PACKAGE__->table. '_id_seq');

1;
