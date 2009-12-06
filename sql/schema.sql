create table samples (
	id INTEGER PRIMARY KEY,
	userid INTEGER,
	geo_lat NUMBER,
	geo_long NUMBER,
	sensor_temp NUMBER,
        placeid INTEGER,
	ctime TIMESTAMP default current_timestamp
);

create table users (
	id INTEGER PRIMARY KEY,
	login TEXT,
	passwd TEXT,
	name TEXT,
	email TEXT,
	ctime TIMESTAMP default current_timestamp
);
insert into users (login, passwd, name, email) values ('kappa', 'passwd1', 'Alex Kapranoff', 'kkapp@rambler.ru');

create table places (
	id INTEGER PRIMARY KEY,
        title TEXT,
	userid INTEGER,
	geo_lat NUMBER,
	geo_long NUMBER,
	ctime TIMESTAMP default current_timestamp
);
