PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE star (
name     TEXT PRIMARY KEY NOT NULL,
age      TEXT             NOT NULL,
core     TEXT             NOT NULL,
tag      TEXT             NOT NULL,
form     INT              NOT NULL,
tail     TEXT             NOT NULL,
location TEXT,
chksum   TEXT);
INSERT INTO star VALUES('galaxy','0.0.7','x86_64','glx',0,'xyz',NULL,NULL);
INSERT INTO star VALUES('rakudo','0.0.4','x86_64','glx',0,'xyz',NULL,NULL);
INSERT INTO star VALUES('perl6','0.0.9','x86_64','glx',0,'xyz',NULL,NULL);
INSERT INTO star VALUES('rakudo-star','0.0.2','x86_64','glx',0,'xyz',NULL,NULL);
INSERT INTO star VALUES('perl7','0.0.4','x86_64','glx',0,'xyz',NULL,NULL);
INSERT INTO star VALUES('nebula','0.0.1','x86_64','glx',0,'xyz',NULL,NULL);
CREATE TABLE planet (
starname TEXT NOT NULL,
path    TEXT KEY NOT NULL,
type    TEXT NOT NULL,
perm    INT  NOT NULL,
chksum  TEXT,
PRIMARY KEY (starname, path)
);
INSERT INTO planet VALUES('galaxy','/etc/galaxy/','d',644,NULL);
INSERT INTO planet VALUES('galaxy','/etc/galaxy/law','f',644,NULL);
INSERT INTO planet VALUES('galaxy','/var/galaxy/galaxy.db','f',644,NULL);
INSERT INTO planet VALUES('perl7','/bin/','d',644,NULL);
INSERT INTO planet VALUES('perl7','/bin/perl7','f',755,NULL);
CREATE TABLE IF NOT EXISTS "cluster" (
starname TEXT NOT NULL,
depname TEXT NOT NULL,
depage  TEXT);
INSERT INTO cluster VALUES('rakudo','galaxy','0.0.7+');
INSERT INTO cluster VALUES('perl6','rakudo',NULL);
INSERT INTO cluster VALUES('perl7','rakudo','0.0.4+');
INSERT INTO cluster VALUES('perl7','rakudo-star','0.0.2+');
COMMIT;
