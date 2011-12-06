use Mannheim;

CREATE TABLE  offline
  (
    mac CHAR(17),
    signal INT(2),
    channelFrequency CHAR(10),
    mode  ENUM('access_point', 'adhoc'),
    time timestamp,
    id varchar(17),
    x  INT,
    y  INT,
    orientation REAL,
    frequency INT,
    orientationLevel ENUM('0', '45', '90', '135', '180', '225', '270', '315')
  );


# In R, use 
#   write.table(off, "offline.dat", sep = "\t", row.names = FALSE, quote = FALSE, col.names = FALSE)
# to create the files
# Then compress it and transfer it.

LOAD DATA INFILE '/home/duncan/Classes/StatComputing/Book/Data/GeoLocation/mannheim/offline.dat' INTO TABLE offline;


select AVG(signal), x, y, orientationLevel, mac  FROM offline WHERE mode = 'access_point' GROUP BY mac, x, y, orientationLevel;