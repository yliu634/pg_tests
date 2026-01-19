-- PostgreSQL compatible tests from grant_revoke_with_grant_option
-- 168 tests

-- Test 1: statement (line 1)
CREATE TABLE t(row INT)

-- Test 2: statement (line 4)
CREATE USER testuser2

-- Test 3: statement (line 7)
CREATE USER target

-- Test 4: query (line 11)
SELECT * FROM [SHOW GRANTS FOR public] WHERE object_name IS NULL

-- Test 5: statement (line 23)
GRANT ALL PRIVILEGES ON TABLE t TO public WITH GRANT OPTION

-- Test 6: statement (line 26)
GRANT ALL PRIVILEGES ON TABLE t TO testuser WITH GRANT OPTION

user testuser

-- Test 7: statement (line 31)
GRANT ALL PRIVILEGES ON TABLE t TO target

-- Test 8: statement (line 34)
GRANT SELECT ON TABLE t TO target

user root

-- Test 9: statement (line 39)
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLE t FROM testuser

user testuser

-- Test 10: statement (line 44)
GRANT ALL PRIVILEGES ON TABLE t TO target

-- Test 11: statement (line 47)
GRANT SELECT ON TABLE t TO target

-- Test 12: statement (line 55)
GRANT ALL PRIVILEGES ON TABLE t TO testuser WITH GRANT OPTION

user testuser

-- Test 13: statement (line 60)
GRANT SELECT, INSERT ON TABLE t TO testuser2

-- Test 14: query (line 63)
SHOW GRANTS FOR testuser2

-- Test 15: statement (line 74)
GRANT INSERT, SELECT ON TABLE t TO target

user testuser

-- Test 16: query (line 79)
SHOW GRANTS FOR testuser2

-- Test 17: statement (line 88)
GRANT SELECT, INSERT ON TABLE t TO testuser2 WITH GRANT OPTION

user testuser2

-- Test 18: statement (line 93)
GRANT INSERT, SELECT ON TABLE t TO target

user root

-- Test 19: statement (line 98)
GRANT DELETE ON TABLE t TO testuser2 WITH GRANT OPTION

user testuser2

-- Test 20: statement (line 103)
GRANT DELETE ON TABLE t TO target

user testuser

-- Test 21: statement (line 108)
GRANT DELETE, UPDATE ON TABLE t TO testuser2 WITH GRANT OPTION

-- Test 22: statement (line 111)
REVOKE INSERT ON TABLE t FROM testuser2

-- Test 23: query (line 114)
SHOW GRANTS FOR testuser2

-- Test 24: statement (line 125)
REVOKE GRANT OPTION FOR SELECT ON TABLE t FROM testuser2

-- Test 25: query (line 129)
SHOW GRANTS FOR testuser2

-- Test 26: statement (line 141)
GRANT SELECT ON TABLE t TO target

-- Test 27: statement (line 144)
GRANT DELETE, UPDATE ON TABLE t TO target

user testuser

-- Test 28: statement (line 149)
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLE t FROM testuser2

user testuser2

-- Test 29: statement (line 154)
GRANT DELETE ON TABLE t TO target

-- Test 30: statement (line 157)
GRANT UPDATE ON TABLE t TO target

-- Test 31: statement (line 160)
GRANT SELECT ON TABLE t TO target

-- Test 32: statement (line 168)
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLE t FROM testuser2

-- Test 33: statement (line 171)
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLE t FROM testuser

-- Test 34: query (line 174)
SHOW GRANTS FOR testuser

-- Test 35: statement (line 184)
GRANT SELECT, INSERT, DELETE ON TABLE t TO testuser2 WITH GRANT OPTION

user root

-- Test 36: statement (line 189)
REVOKE ALL PRIVILEGES ON TABLE t FROM testuser

-- Test 37: query (line 192)
SHOW GRANTS FOR testuser

-- Test 38: statement (line 199)
GRANT UPDATE, DELETE ON TABLE t to testuser WITH GRANT OPTION

-- Test 39: query (line 202)
SHOW GRANTS FOR testuser

-- Test 40: statement (line 212)
GRANT ALL PRIVILEGES ON TABLE t to testuser WITH GRANT OPTION

-- Test 41: query (line 215)
SHOW GRANTS FOR testuser

-- Test 42: statement (line 225)
GRANT DELETE ON TABLE t to target

user root

-- Test 43: statement (line 230)
REVOKE GRANT OPTION FOR UPDATE, DELETE ON TABLE t FROM testuser

-- Test 44: query (line 233)
SHOW GRANTS FOR testuser

-- Test 45: statement (line 243)
GRANT SELECT ON TABLE t TO testuser2 WITH GRANT OPTION

-- Test 46: statement (line 246)
GRANT UPDATE ON TABLE t TO testuser2 WITH GRANT OPTION

-- Test 47: statement (line 249)
GRANT DELETE ON TABLE t TO testuser2 WITH GRANT OPTION

-- Test 48: query (line 252)
SHOW GRANTS FOR testuser2

-- Test 49: statement (line 264)
GRANT SELECT ON TABLE t TO target

-- Test 50: statement (line 272)
GRANT ALL PRIVILEGES ON TABLE t TO testuser

-- Test 51: statement (line 275)
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLE t FROM testuser

user testuser

-- Test 52: statement (line 280)
GRANT DELETE ON TABLE t TO testuser

-- Test 53: statement (line 283)
REVOKE DELETE ON TABLE t FROM testuser

user root

-- Test 54: statement (line 288)
GRANT ALL PRIVILEGES ON TABLE t TO testuser WITH GRANT OPTION

user testuser

-- Test 55: statement (line 293)
GRANT DELETE ON TABLE t TO testuser

-- Test 56: statement (line 296)
REVOKE DELETE ON TABLE t FROM testuser

-- Test 57: query (line 299)
SHOW GRANTS FOR testuser

-- Test 58: statement (line 317)
GRANT SELECT ON TABLE t TO target

-- Test 59: statement (line 320)
REVOKE GRANT OPTION FOR SELECT ON TABLE t FROM testuser

-- Test 60: statement (line 323)
GRANT SELECT ON TABLE t TO target

user root

-- Test 61: statement (line 328)
GRANT ALL PRIVILEGES ON TABLE t TO testuser WITH GRANT OPTION

user testuser

-- Test 62: statement (line 333)
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLE t FROM testuser

-- Test 63: statement (line 336)
GRANT INSERT, DELETE ON TABLE t TO target

user root

-- Test 64: statement (line 341)
GRANT ALL PRIVILEGES ON TABLE t TO testuser WITH GRANT OPTION

-- Test 65: statement (line 344)
REVOKE ALL PRIVILEGES ON TABLE t FROM testuser

-- Test 66: query (line 347)
SHOW GRANTS FOR testuser

-- Test 67: statement (line 360)
REVOKE ALL PRIVILEGES ON TABLE t FROM testuser

-- Test 68: statement (line 363)
REVOKE ALL PRIVILEGES ON TABLE t FROM testuser2

-- Test 69: query (line 366)
SHOW GRANTS FOR testuser

-- Test 70: query (line 373)
SHOW GRANTS FOR testuser2

-- Test 71: statement (line 380)
CREATE SCHEMA s

-- Test 72: statement (line 383)
GRANT ALL PRIVILEGES ON SCHEMA s TO testuser WITH GRANT OPTION

-- Test 73: query (line 386)
SHOW GRANTS FOR testuser

-- Test 74: statement (line 396)
GRANT CREATE ON SCHEMA s TO testuser2 WITH GRANT OPTION

user root

-- Test 75: query (line 401)
SHOW GRANTS FOR testuser2

-- Test 76: statement (line 409)
REVOKE GRANT OPTION FOR ALL PRIVILEGES ON SCHEMA s FROM testuser

-- Test 77: query (line 412)
SHOW GRANTS FOR testuser

-- Test 78: statement (line 422)
GRANT CREATE ON SCHEMA s TO target

user root

-- Test 79: statement (line 427)
CREATE DATABASE d

-- Test 80: statement (line 430)
GRANT ALL PRIVILEGES ON DATABASE d TO testuser WITH GRANT OPTION

-- Test 81: query (line 433)
SHOW GRANTS ON DATABASE d

-- Test 82: statement (line 446)
GRANT testuser TO testuser2

user testuser2

-- Test 83: statement (line 451)
GRANT CONNECT ON DATABASE d TO TARGET

-- Test 84: query (line 454)
SHOW GRANTS ON DATABASE d

-- Test 85: statement (line 466)
REVOKE testuser FROM testuser2;
REVOKE CONNECT ON DATABASE d FROM target

user testuser

-- Test 86: statement (line 472)
GRANT CREATE, CONNECT ON DATABASE d TO testuser2 WITH GRANT OPTION

-- Test 87: statement (line 475)
REVOKE GRANT OPTION FOR CREATE ON DATABASE d FROM testuser2

user testuser2

-- Test 88: statement (line 480)
GRANT CONNECT ON DATABASE d TO target WITH GRANT OPTION

-- Test 89: statement (line 483)
GRANT CREATE ON DATABASE d TO target WITH GRANT OPTION

user root

-- Test 90: query (line 488)
SHOW GRANTS ON DATABASE d

-- Test 91: statement (line 500)
REVOKE ALL PRIVILEGES ON DATABASE d FROM testuser2

-- Test 92: query (line 503)
SHOW GRANTS ON DATABASE d

-- Test 93: statement (line 517)
GRANT CONNECT ON DATABASE d TO target WITH GRANT OPTION

-- Test 94: statement (line 523)
CREATE TYPE type1 as ENUM()

user testuser

-- Test 95: statement (line 529)
GRANT USAGE ON TYPE type1 TO target

user root

-- Test 96: statement (line 534)
GRANT ALL PRIVILEGES ON TYPE type1 TO testuser WITH GRANT OPTION

user testuser

-- Test 97: statement (line 539)
GRANT USAGE ON TYPE type1 TO target

-- Test 98: statement (line 547)
GRANT CREATE ON DATABASE test to testuser

-- Test 99: statement (line 550)
GRANT CREATE ON DATABASE test to testuser2

user testuser

-- Test 100: statement (line 555)
CREATE TABLE t1()

-- Test 101: query (line 560)
SHOW GRANTS ON TABLE t1;

-- Test 102: statement (line 568)
GRANT SELECT ON TABLE t1 TO testuser2

-- Test 103: query (line 574)
REVOKE ALL PRIVILEGES ON TABLE t1 FROM testuser

-- Test 104: statement (line 580)
REVOKE ALL PRIVILEGES ON TABLE t1 FROM testuser

-- Test 105: query (line 583)
SHOW GRANTS ON TABLE t1;

-- Test 106: statement (line 594)
GRANT INSERT ON TABLE t1 TO testuser2

-- Test 107: statement (line 597)
GRANT ALL PRIVILEGES ON TABLE t1 TO testuser2 WITH GRANT OPTION

-- Test 108: query (line 600)
SHOW GRANTS ON TABLE t1;

-- Test 109: query (line 609)
SHOW GRANTS ON TABLE t1;

-- Test 110: statement (line 619)
GRANT ALL PRIVILEGES ON TABLE t1 TO testuser

-- Test 111: query (line 622)
SHOW GRANTS ON TABLE t1;

-- Test 112: statement (line 634)
CREATE TABLE grant_ordering_table (id INT PRIMARY KEY);
CREATE USER grant_ordering_user

-- Test 113: statement (line 638)
GRANT ALL ON TABLE grant_ordering_table TO grant_ordering_user WITH GRANT OPTION

-- Test 114: query (line 641)
SHOW GRANTS ON grant_ordering_table FOR grant_ordering_user

-- Test 115: statement (line 647)
REVOKE GRANT OPTION FOR ALL ON TABLE grant_ordering_table FROM grant_ordering_user

-- Test 116: query (line 650)
SHOW GRANTS ON grant_ordering_table FOR grant_ordering_user

-- Test 117: statement (line 656)
GRANT SELECT ON TABLE grant_ordering_table TO grant_ordering_user WITH GRANT OPTION

-- Test 118: query (line 659)
SHOW GRANTS ON grant_ordering_table FOR grant_ordering_user

-- Test 119: statement (line 666)
REVOKE GRANT OPTION FOR ALL ON TABLE grant_ordering_table FROM grant_ordering_user

-- Test 120: query (line 669)
SHOW GRANTS ON grant_ordering_table FOR grant_ordering_user

-- Test 121: statement (line 677)
CREATE USER owner_grant_option_child

-- Test 122: statement (line 680)
GRANT testuser to owner_grant_option_child

user testuser

-- Test 123: statement (line 685)
CREATE TABLE owner_grant_option()

-- Test 124: statement (line 688)
GRANT SELECT ON TABLE owner_grant_option TO owner_grant_option_child

-- Test 125: query (line 691)
SHOW GRANTS ON TABLE owner_grant_option

-- Test 126: statement (line 704)
CREATE ROLE other_owner

-- Test 127: statement (line 707)
ALTER TABLE owner_grant_option OWNER TO other_owner

-- Test 128: query (line 710)
SHOW GRANTS ON TABLE owner_grant_option

-- Test 129: statement (line 719)
CREATE USER roach;
CREATE TYPE mood AS enum ('sad','happy');
GRANT USAGE ON TYPE mood TO roach;
CREATE SEQUENCE test_sequence;
GRANT SELECT ON SEQUENCE test_sequence TO roach;
CREATE EXTERNAL CONNECTION connection1 AS 'nodelocal://1/foo';
GRANT USAGE ON EXTERNAL CONNECTION connection1 TO roach WITH GRANT OPTION;
GRANT SYSTEM VIEWCLUSTERSETTING TO roach WITH GRANT OPTION;
GRANT SYSTEM VIEWACTIVITY TO roach;

-- Test 130: query (line 731)
SHOW GRANTS FOR roach

-- Test 131: query (line 748)
SHOW SYSTEM GRANTS FOR roach

-- Test 132: statement (line 757)
SET CLUSTER SETTING sql.auth.grant_option_inheritance.enabled = false

-- Test 133: statement (line 760)
CREATE USER parent;
CREATE USER child;
CREATE USER other;

-- Test 134: statement (line 765)
GRANT parent TO child

-- Test 135: statement (line 768)
CREATE TABLE tbl_owned_by_root (a INT PRIMARY KEY)

-- Test 136: statement (line 771)
SET ROLE parent

-- Test 137: statement (line 774)
CREATE TABLE tbl_owned_by_parent (a INT PRIMARY KEY)

-- Test 138: statement (line 777)
RESET role

-- Test 139: statement (line 780)
INSERT INTO tbl_owned_by_root VALUES (1);
INSERT INTO tbl_owned_by_parent VALUES (1);

-- Test 140: statement (line 784)
GRANT SELECT ON TABLE tbl_owned_by_root TO parent WITH GRANT OPTION

-- Test 141: statement (line 787)
SET ROLE child

-- Test 142: query (line 791)
SELECT a FROM tbl_owned_by_root LIMIT 1

-- Test 143: query (line 797)
SELECT a FROM tbl_owned_by_parent LIMIT 1

-- Test 144: statement (line 803)
GRANT SELECT ON TABLE tbl_owned_by_root TO other

-- Test 145: statement (line 807)
GRANT SELECT ON TABLE tbl_owned_by_parent TO other

-- Test 146: statement (line 810)
RESET ROLE

-- Test 147: statement (line 813)
RESET CLUSTER SETTING sql.auth.grant_option_inheritance.enabled

-- Test 148: statement (line 816)
SET ROLE child

-- Test 149: statement (line 820)
GRANT SELECT ON TABLE tbl_owned_by_root TO other

-- Test 150: statement (line 823)
GRANT SELECT ON TABLE tbl_owned_by_parent TO other

-- Test 151: statement (line 827)
REVOKE SELECT ON TABLE tbl_owned_by_root FROM other

-- Test 152: statement (line 830)
REVOKE SELECT ON TABLE tbl_owned_by_parent FROM other

-- Test 153: statement (line 833)
RESET role

-- Test 154: statement (line 840)
SET CLUSTER SETTING sql.auth.grant_option_for_owner.enabled = false

-- Test 155: statement (line 843)
SET ROLE parent

-- Test 156: statement (line 847)
GRANT SELECT ON TABLE tbl_owned_by_parent TO other

-- Test 157: statement (line 850)
SET ROLE child

-- Test 158: statement (line 854)
GRANT SELECT ON TABLE tbl_owned_by_parent TO other

-- Test 159: statement (line 857)
RESET role

-- Test 160: statement (line 860)
GRANT SELECT ON TABLE tbl_owned_by_parent TO parent WITH GRANT OPTION

-- Test 161: statement (line 865)
GRANT SELECT ON TABLE tbl_owned_by_parent TO other

-- Test 162: statement (line 868)
REVOKE SELECT ON TABLE tbl_owned_by_parent FROM other

-- Test 163: statement (line 871)
SET ROLE child

-- Test 164: statement (line 876)
GRANT SELECT ON TABLE tbl_owned_by_parent TO other

-- Test 165: statement (line 879)
REVOKE SELECT ON TABLE tbl_owned_by_parent FROM other

-- Test 166: statement (line 882)
RESET role

-- Test 167: statement (line 886)
REVOKE SELECT ON TABLE tbl_owned_by_parent FROM parent

-- Test 168: statement (line 889)
RESET CLUSTER SETTING sql.auth.grant_option_for_owner.enabled

