# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'Allstar'
#

CREATE TABLE Allstar (
  playerID varchar(10) NOT NULL default '',
  yearID smallint(4) unsigned NOT NULL default '0',
  lgID char(2) NOT NULL default '',
  PRIMARY KEY  (playerID,yearID,lgID),
  KEY playerID (playerID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'AwardsManagers'
#

CREATE TABLE AwardsManagers (
  managerID varchar(10) NOT NULL default '',
  awardID varchar(25) NOT NULL default '',
  yearID smallint(4) NOT NULL default '0',
  lgID char(2) NOT NULL default '',
  tie char(1) default NULL,
  notes varchar(100) default NULL,
  PRIMARY KEY  (yearID,awardID,lgID,managerID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'AwardsPlayers'
#

CREATE TABLE AwardsPlayers (
  playerID varchar(9) NOT NULL default '',
  awardID varchar(25) NOT NULL default '',
  yearID smallint(4) NOT NULL default '0',
  lgID char(2) NOT NULL default '',
  tie char(1) default NULL,
  notes varchar(100) default NULL,
  PRIMARY KEY  (yearID,awardID,lgID,playerID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'AwardsShareManagers'
#

CREATE TABLE AwardsShareManagers (
  awardID varchar(25) NOT NULL default '',
  yearID smallint(4) NOT NULL default '0',
  lgID char(2) NOT NULL default '',
  managerID varchar(10) NOT NULL default '',
  pointsWon int(4) default NULL,
  pointsMax int(4) default NULL,
  votesFirst int(4) default NULL,
  PRIMARY KEY  (awardID,yearID,lgID,managerID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'AwardsSharePlayers'
#

CREATE TABLE AwardsSharePlayers (
  awardID varchar(25) NOT NULL default '',
  yearID smallint(4) NOT NULL default '0',
  lgID char(2) NOT NULL default '',
  playerID varchar(9) NOT NULL default '',
  pointsWon double(5,1) default NULL,
  pointsMax int(4) default NULL,
  votesFirst double(5,1) default NULL,
  PRIMARY KEY  (awardID,yearID,lgID,playerID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'BattingPost'
#

CREATE TABLE BattingPost (
  yearID int(4) NOT NULL default '0',
  round varchar(10) NOT NULL default '',
  playerID varchar(9) NOT NULL default '',
  teamID char(3) NOT NULL default '',
  lgID char(2) NOT NULL default '',
  G int(2) NOT NULL default '0',
  AB int(2) NOT NULL default '0',
  R int(2) NOT NULL default '0',
  H int(2) NOT NULL default '0',
  2B int(2) NOT NULL default '0',
  3B int(2) NOT NULL default '0',
  HR int(2) NOT NULL default '0',
  RBI int(2) NOT NULL default '0',
  SB int(2) NOT NULL default '0',
  CS int(2) default NULL,
  BB int(2) NOT NULL default '0',
  SO int(2) NOT NULL default '0',
  IBB int(2) default NULL,
  HBP int(2) default NULL,
  SH int(2) default NULL,
  SF int(2) default NULL,
  GIDP int(2) default NULL,
  PRIMARY KEY  (yearID,round,playerID),
  KEY playerID (playerID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'Batting'
#

CREATE TABLE Batting (
  playerID varchar(9) NOT NULL default '',
  yearID smallint(4) unsigned NOT NULL default '0',
  stint int(2) NOT NULL default '0',
  teamID char(3) NOT NULL default '',
  lgID char(2) NOT NULL default '',
  G smallint(3) unsigned default NULL,
  AB smallint(3) NOT NULL default '0',
  R smallint(3) unsigned default NULL,
  H smallint(3) unsigned default NULL,
  2B smallint(3) unsigned default NULL,
  3B smallint(3) unsigned default NULL,
  HR smallint(3) unsigned NOT NULL default '0',
  RBI smallint(3) unsigned default NULL,
  SB smallint(3) unsigned default NULL,
  CS smallint(3) unsigned default NULL,
  BB smallint(3) unsigned default NULL,
  SO smallint(3) unsigned default NULL,
  IBB smallint(3) unsigned default NULL,
  HBP smallint(3) unsigned default NULL,
  SH smallint(3) unsigned default NULL,
  SF smallint(3) unsigned default NULL,
  GIDP smallint(3) unsigned default NULL,
  PRIMARY KEY  (playerID,yearID,stint),
  KEY playerID (playerID),
  KEY team (teamID,yearID,lgID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'FieldingOF'
#

CREATE TABLE FieldingOF (
  playerID varchar(9) NOT NULL default '',
  yearID smallint(4) unsigned NOT NULL default '0',
  stint int(2) NOT NULL default '0',
  Glf int(3) default NULL,
  Gcf int(3) default NULL,
  Grf int(3) default NULL,
  PRIMARY KEY  (playerID,yearID,stint),
  KEY playerID (playerID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'Fielding'
#

CREATE TABLE Fielding (
  playerID varchar(9) NOT NULL default '',
  yearID smallint(4) unsigned NOT NULL default '0',
  stint int(2) NOT NULL default '0',
  teamID char(3) NOT NULL default '',
  lgID char(2) NOT NULL default '',
  POS char(2) NOT NULL default '',
  G smallint(3) unsigned default NULL,
  GS int(3) default NULL,
  InnOuts int(5) default NULL,
  PO smallint(3) unsigned default NULL,
  A smallint(3) unsigned default NULL,
  E smallint(2) unsigned default NULL,
  DP smallint(3) unsigned default NULL,
  PB int(3) default NULL,
  ZR double(5,3) default NULL,
  PRIMARY KEY  (playerID,yearID,stint,POS),
  KEY playerID (playerID),
  KEY team (teamID,yearID,lgID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'HallOfFame'
#

CREATE TABLE HallOfFame (
  hofID varchar(10) NOT NULL default '',
  yearID smallint(4) NOT NULL default '0',
  votedBy varchar(64) default NULL,
  ballots smallint(5) default NULL,
  needed int(4) default NULL,
  votes smallint(5) default NULL,
  inducted enum('Y','N') default 'N',
  category varchar(20) default NULL,
  PRIMARY KEY  (hofID,yearID),
  KEY hofID (hofID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'ManagersHalf'
#

CREATE TABLE ManagersHalf (
  managerID varchar(10) NOT NULL default '',
  yearID smallint(4) NOT NULL default '0',
  teamID char(3) NOT NULL default '',
  lgID char(2) NOT NULL default '',
  inseason int(2) default NULL,
  half smallint(1) NOT NULL default '1',
  G smallint(3) NOT NULL default '0',
  W smallint(3) NOT NULL default '0',
  L smallint(3) NOT NULL default '0',
  rank smallint(1) NOT NULL default '0',
  PRIMARY KEY  (yearID,teamID,managerID,half)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'Managers'
#

CREATE TABLE Managers (
  managerID varchar(10) NOT NULL default '',
  yearID smallint(4) NOT NULL default '0',
  teamID char(3) NOT NULL default '',
  lgID char(2) NOT NULL default '',
  inseason smallint(1) NOT NULL default '1',
  G smallint(3) NOT NULL default '0',
  W smallint(3) NOT NULL default '0',
  L smallint(3) NOT NULL default '0',
  rank smallint(1) NOT NULL default '0',
  plyrMgr enum('Y','N') default 'N',
  PRIMARY KEY  (managerID,yearID,teamID,inseason),
  KEY team (teamID,yearID,lgID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'Master'
#

CREATE TABLE Master (
  lahmanID int(9) NOT NULL auto_increment,
  playerID varchar(10) NOT NULL default '',
  managerID varchar(10) NOT NULL default '',
  hofID varchar(10) NOT NULL default '',
  birthYear int(4) default NULL,
  birthMonth int(2) default NULL,
  birthDay int(2) default NULL,
  birthCountry varchar(50) default NULL,
  birthState char(2) default NULL,
  birthCity varchar(50) default NULL,
  deathYear int(4) default NULL,
  deathMonth int(2) default NULL,
  deathDay int(2) default NULL,
  deathCountry varchar(50) default NULL,
  deathState char(2) default NULL,
  deathCity varchar(50) default NULL,
  nameFirst varchar(50) default NULL,
  nameLast varchar(50) NOT NULL default '',
  nameNote varchar(255) default NULL,
  nameGiven varchar(255) default NULL,
  nameNick varchar(255) default NULL,
  weight int(3) default NULL,
  height double(4,1) default NULL,
  bats enum('L','R','B') default NULL,
  throws enum('L','R','B') default NULL,
  debut date default NULL,
  college varchar(50) default NULL,
  lahman40ID varchar(9) default NULL,
  lahman45ID varchar(9) default NULL,
  retroID varchar(9) default NULL,
  holtzID varchar(9) default NULL,
  bbrefID varchar(9) default NULL,
  PRIMARY KEY  (lahmanID),
  KEY playerID (playerID),
  KEY managerID (managerID),
  KEY hofID (hofID),
  KEY lahman40ID (lahman40ID),
  KEY lahman45ID (lahman45ID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'PitchingPost'
#

CREATE TABLE PitchingPost (
  playerID varchar(9) NOT NULL default '',
  yearID int(4) NOT NULL default '0',
  round varchar(10) NOT NULL default '',
  teamID char(3) NOT NULL default '',
  lgID char(2) NOT NULL default '',
  W smallint(2) unsigned default NULL,
  L smallint(2) unsigned default NULL,
  G smallint(3) unsigned default NULL,
  GS smallint(3) unsigned default NULL,
  CG smallint(3) unsigned default NULL,
  SHO smallint(3) unsigned default NULL,
  SV smallint(3) unsigned default NULL,
  IPouts int(5) unsigned default NULL,
  H smallint(3) unsigned default NULL,
  ER smallint(3) unsigned default NULL,
  HR smallint(3) unsigned default NULL,
  BB smallint(3) unsigned default NULL,
  SO smallint(3) unsigned default NULL,
  BAOpp decimal(5,3) unsigned default NULL,
  ERA decimal(5,2) default NULL,
  IBB smallint(3) default NULL,
  WP smallint(3) default NULL,
  HBP smallint(3) default NULL,
  BK smallint(3) default NULL,
  BFP smallint(6) default NULL,
  GF smallint(3) default NULL,
  R smallint(3) default NULL,
  SH smallint(3) default NULL,
  SF smallint(3) default NULL,
  GIDP smallint(3) default NULL,
  PRIMARY KEY  (playerID,yearID,round),
  KEY player (playerID),
  KEY player2 (playerID,yearID,teamID,lgID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'Pitching'
#

CREATE TABLE Pitching (
  playerID varchar(9) NOT NULL default '',
  yearID smallint(4) unsigned NOT NULL default '0',
  stint int(2) NOT NULL default '0',
  teamID char(3) NOT NULL default '',
  lgID char(2) NOT NULL default '',
  W smallint(2) unsigned default NULL,
  L smallint(2) unsigned default NULL,
  G smallint(3) unsigned default NULL,
  GS smallint(3) unsigned default NULL,
  CG smallint(3) unsigned default NULL,
  SHO smallint(3) unsigned default NULL,
  SV smallint(3) unsigned default NULL,
  IPouts int(5) unsigned default NULL,
  H smallint(3) unsigned default NULL,
  ER smallint(3) unsigned default NULL,
  HR smallint(3) unsigned default NULL,
  BB smallint(3) unsigned default NULL,
  SO smallint(3) unsigned default NULL,
  BAOpp decimal(5,3) unsigned default NULL,
  ERA decimal(5,2) unsigned default NULL,
  IBB smallint(3) unsigned default NULL,
  WP smallint(3) unsigned default NULL,
  HBP smallint(3) unsigned default NULL,
  BK smallint(3) unsigned default NULL,
  BFP smallint(6) unsigned default NULL,
  GF smallint(3) unsigned default NULL,
  R smallint(3) unsigned default NULL,
  PRIMARY KEY  (playerID,yearID,stint),
  KEY playerID (playerID),
  KEY team (teamID,yearID,lgID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'Salaries'
#

CREATE TABLE Salaries (
  yearID smallint(4) unsigned NOT NULL default '0',
  teamID char(3) NOT NULL default '',
  lgID char(2) NOT NULL default '',
  playerID varchar(9) NOT NULL default '',
  salary double(10,2) NOT NULL default '0.00',
  PRIMARY KEY  (yearID,teamID,lgID,playerID),
  KEY playerID (playerID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'SeriesPost'
#

CREATE TABLE SeriesPost (
  yearID smallint(4) NOT NULL default '0',
  round varchar(5) NOT NULL default '',
  teamIDwinner char(3) NOT NULL default '',
  lgIDwinner char(2) NOT NULL default '',
  teamIDloser char(3) NOT NULL default '',
  lgIDloser char(2) NOT NULL default '',
  wins smallint(1) NOT NULL default '0',
  losses smallint(1) NOT NULL default '0',
  ties int(1) default '0',
  PRIMARY KEY  (yearID,round)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'TeamsFranchises'
#

CREATE TABLE TeamsFranchises (
  franchID char(3) NOT NULL default '',
  franchName varchar(50) NOT NULL default '',
  active enum('Y','N','NA') NOT NULL default 'Y',
  NAassoc char(3) default NULL,
  PRIMARY KEY  (franchID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'TeamsHalf'
#

CREATE TABLE TeamsHalf (
  yearID smallint(4) unsigned NOT NULL default '0',
  lgID char(2) NOT NULL default '',
  teamID char(3) NOT NULL default '',
  Half enum('1','2','') NOT NULL default '',
  divID char(1) default NULL,
  DivWin enum('Y','N') NOT NULL default 'N',
  Rank smallint(3) unsigned NOT NULL default '0',
  G smallint(3) unsigned default NULL,
  W smallint(3) unsigned default NULL,
  L smallint(3) unsigned default NULL,
  PRIMARY KEY  (yearID,teamID,lgID,Half)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'Teams'
#

CREATE TABLE Teams (
  yearID smallint(4) unsigned NOT NULL default '0',
  lgID char(2) NOT NULL default '',
  teamID char(3) NOT NULL default '',
  franchID char(3) NOT NULL default 'UNK',
  divID char(1) default NULL,
  Rank smallint(3) unsigned NOT NULL default '0',
  G smallint(3) unsigned default NULL,
  Ghome int(3) default NULL,
  W smallint(3) unsigned default NULL,
  L smallint(3) unsigned default NULL,
  DivWin enum('Y','N') NOT NULL default 'N',
  WCWin enum('Y','N') NOT NULL default 'N',
  LgWin enum('Y','N') NOT NULL default 'N',
  WSWin enum('Y','N') NOT NULL default 'N',
  R smallint(4) unsigned default NULL,
  AB smallint(4) unsigned default NULL,
  H smallint(4) unsigned default NULL,
  2B smallint(4) unsigned default NULL,
  3B smallint(3) unsigned default NULL,
  HR smallint(3) unsigned default NULL,
  BB smallint(4) unsigned default NULL,
  SO smallint(4) unsigned default NULL,
  SB smallint(3) unsigned default NULL,
  CS smallint(3) unsigned default NULL,
  HBP smallint(3) default NULL,
  SF smallint(3) default NULL,
  RA smallint(4) unsigned default NULL,
  ER smallint(4) default NULL,
  ERA decimal(4,2) default NULL,
  CG smallint(3) unsigned default NULL,
  SHO smallint(3) unsigned default NULL,
  SV smallint(3) unsigned default NULL,
  IPouts int(5) default NULL,
  HA smallint(4) unsigned default NULL,
  HRA smallint(4) unsigned default NULL,
  BBA smallint(4) unsigned default NULL,
  SOA smallint(4) unsigned default NULL,
  E int(5) default NULL,
  DP int(4) default NULL,
  FP decimal(5,3) default NULL,
  name varchar(50) NOT NULL default '',
  park varchar(255) default NULL,
  attendance int(7) default NULL,
  BPF int(3) default NULL,
  PPF int(3) default NULL,
  teamIDBR char(3) default NULL,
  teamIDlahman45 char(3) default NULL,
  teamIDretro char(3) default NULL,
  PRIMARY KEY  (yearID,lgID,teamID),
  KEY team (teamID,yearID,lgID)
) TYPE=MyISAM;
# MySQL dump 8.14
#
# Host: localhost    Database: BDB
#--------------------------------------------------------
# Server version	3.23.38

#
# Table structure for table 'xref_stats'
#

CREATE TABLE xref_stats (
  playerID varchar(10) NOT NULL default '',
  statsID int(5) default NULL,
  PRIMARY KEY  (playerID),
  KEY statsID (statsID)
) TYPE=MyISAM;



CREATE TABLE FieldingPost (
 PlayerID varchar(10) NOT NULL default '',
 yearID smallint(4)  unsigned NOT NULL default '0',
 teamID char(3) NOT NULL default '',
 lgID char(2) NOT NULL default '',
 round varchar(10) NOT NULL default '',
  POS char(2) NOT NULL default '',
  G smallint(3) unsigned default NULL,
  GS int(3) default NULL,
  InnOuts int(5) default NULL,
  PO smallint(3) unsigned default NULL,
  A smallint(3) unsigned default NULL,
  E smallint(2) unsigned default NULL,
  DP smallint(3) unsigned default NULL, 
  TP smallint(3) unsigned default NULL, 
  PB int(3) default NULL,
  SB smallint(3) unsigned default NULL,
  CS smallint(3) unsigned default NULL,
#  PRIMARY KEY  (playerID,yearID, teamID),  # okay since no trades in post-season.
  KEY playerID (playerID),
  KEY team (teamID,yearID,lgID)
) TYPE=MyISAM;
