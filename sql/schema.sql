create table samples (
	id INTEGER PRIMARY KEY,
	userid INTEGER,
	geo_lat NUMBER,
	geo_long NUMBER,
	sensor_temp NUMBER,
	ctime TIMESTAMP
);

create table users (
	id INTEGER PRIMARY KEY,
	login TEXT,
	passwd TEXT,
	name TExT,
	ctime TIMESTAMP
);
