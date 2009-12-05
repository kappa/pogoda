create table samples (
	id INTEGER PRIMARY KEY,
	userid INTEGER,
	geo_lat NUMBER,
	geo_long NUMBER,
	sensor_temp NUMBER,
	ctime TIMESTAMP default current_timestamp
);

create table users (
	id INTEGER PRIMARY KEY,
	login TEXT,
	passwd TEXT,
	name TExT,
	ctime TIMESTAMP default current_timestamp
);
insert into users (login, passwd, name) values ('kappa', 'passwd1', 'Alex Kapranoff');
