Use Network;

CREATE TABLE  Services (
 service  varchar(25),
 port     integer NOT NULL,
 protocol varchar(6),
 description varchar(60)
);

LOAD DATA INFILE "port.data" INTO TABLE  Services FIELDS ENCLOSED BY '"';
