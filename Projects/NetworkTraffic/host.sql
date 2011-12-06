USE Network;

CREATE TABLE HostInfo (

  ip  varchar(15)  NOT NULL,
  name varchar(40) NOT NULL,
  OS   varchar(15) NOT NULL,
  note varchar(50),
  type ENUM ("Inside", "Outside", "Router/hub") NOT NULL
);

LOAD DATA INFILE "/home/duncan/NetworkData/host.data" INTO TABLE HostInfo FIELDS ENCLOSED BY '"';



