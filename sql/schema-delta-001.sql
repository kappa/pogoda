create table users (
	id INTEGER PRIMARY KEY,
	login TEXT,
	passwd TEXT,
	name TExT,
	ctime TIMESTAMP
);

insert into users (login, passwd, name) values ('kappa', 'passwd1', 'Alex Kapranoff');
