-- PostgreSQL compatible tests from role
-- 443 tests

-- Test 1: statement (line 3)
CREATE ROLE admin

-- Test 2: statement (line 6)
CREATE ROLE root

-- Test 3: statement (line 9)
CREATE ROLE IF NOT EXISTS root

-- Test 4: statement (line 12)
CREATE ROLE IF NOT EXISTS admin

-- Test 5: statement (line 15)
DROP ROLE admin

-- Test 6: statement (line 18)
DROP ROLE root

-- Test 7: statement (line 21)
DROP ROLE admin, root

-- Test 8: statement (line 24)
CREATE ROLE myrole

-- Test 9: query (line 27)
select username, options, member_of from [SHOW ROLES]

-- Test 10: statement (line 36)
CREATE ROLE myrole

-- Test 11: statement (line 39)
CREATE ROLE IF NOT EXISTS myrole

-- Test 12: statement (line 42)
CREATE USER myrole

-- Test 13: statement (line 45)
DROP USER myrole

-- Test 14: statement (line 48)
CREATE ROLE myrole

-- Test 15: statement (line 51)
CREATE USER IF NOT EXISTS myrole

-- Test 16: statement (line 54)
DROP ROLE admin, myrole

-- Test 17: query (line 57)
select username, options, member_of from [SHOW ROLES]

-- Test 18: statement (line 66)
DROP ROLE myrole

-- Test 19: query (line 69)
select username, options, member_of from [SHOW ROLES]

-- Test 20: statement (line 77)
DROP ROLE myrole

-- Test 21: statement (line 80)
DROP ROLE IF EXISTS myrole

-- Test 22: statement (line 83)
CREATE ROLE rolea

-- Test 23: statement (line 86)
CREATE ROLE roleb

-- Test 24: statement (line 89)
CREATE ROLE rolec

-- Test 25: statement (line 92)
CREATE ROLE roled

-- Test 26: statement (line 95)
DROP ROLE rolea, roleb, rolec, roled, rolee

-- Test 27: statement (line 98)
DROP ROLE IF EXISTS rolec, roled, rolee

-- Test 28: statement (line 101)
DROP ROLE rolea, roleb

-- Test 29: query (line 104)
select username, options, member_of from [SHOW ROLES]

-- Test 30: query (line 112)
SHOW ROLES

-- Test 31: statement (line 117)
CREATE USER testuser2

-- Test 32: statement (line 120)
CREATE ROLE testrole

-- Test 33: query (line 123)
SHOW GRANTS ON ROLE

-- Test 34: query (line 129)
SELECT * FROM information_schema.administrable_role_authorizations

-- Test 35: query (line 135)
SELECT * FROM information_schema.applicable_roles

-- Test 36: query (line 141)
SELECT * FROM information_schema.enabled_roles

-- Test 37: statement (line 148)
GRANT testrole TO unknownuser

-- Test 38: statement (line 151)
GRANT unknownrole TO testuser

-- Test 39: statement (line 157)
GRANT testrole TO testuser2

user root

-- Test 40: statement (line 162)
GRANT testrole TO testuser

-- Test 41: query (line 165)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 42: query (line 172)
SHOW GRANTS ON ROLE

-- Test 43: statement (line 181)
GRANT testrole TO testuser2

user root

-- Test 44: statement (line 186)
GRANT testrole TO testuser WITH ADMIN OPTION

-- Test 45: statement (line 189)
CREATE ROLE child_role;

-- Test 46: statement (line 192)
GRANT testrole to child_role;

-- Test 47: statement (line 195)
GRANT testuser TO child_role;

-- Test 48: query (line 198)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 49: query (line 207)
SELECT * FROM "".crdb_internal.kv_inherited_role_members

-- Test 50: query (line 216)
SHOW GRANTS ON ROLE FOR child_role

-- Test 51: statement (line 224)
SET ROLE child_role

-- Test 52: statement (line 228)
GRANT testrole TO testuser2 WITH ADMIN OPTION

-- Test 53: query (line 233)
SELECT * FROM information_schema.administrable_role_authorizations

-- Test 54: statement (line 239)
RESET ROLE;
DROP ROLE child_role

user testuser

-- Test 55: query (line 245)
SELECT * FROM information_schema.administrable_role_authorizations

-- Test 56: query (line 251)
SELECT * FROM information_schema.applicable_roles

-- Test 57: query (line 257)
SELECT * FROM information_schema.enabled_roles

-- Test 58: statement (line 266)
GRANT admin TO testuser

-- Test 59: query (line 270)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 60: query (line 279)
SHOW GRANTS ON ROLE

-- Test 61: query (line 288)
SHOW GRANTS ON ROLE admin

-- Test 62: query (line 295)
SHOW GRANTS ON ROLE FOR testuser

-- Test 63: query (line 302)
SHOW GRANTS ON ROLE testrole FOR testuser2

-- Test 64: query (line 308)
SHOW GRANTS ON ROLE foo,testrole

-- Test 65: query (line 315)
SHOW GRANTS ON ROLE FOR testuser, testuser2

-- Test 66: query (line 323)
SHOW GRANTS ON ROLE admin, testrole FOR root, testuser2

-- Test 67: statement (line 330)
DROP USER testuser

-- Test 68: statement (line 333)
CREATE USER testuser

-- Test 69: query (line 336)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 70: statement (line 343)
DROP ROLE testrole

-- Test 71: query (line 346)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 72: statement (line 353)
GRANT admin TO admin

-- Test 73: statement (line 356)
CREATE ROLE rolea

-- Test 74: statement (line 359)
CREATE ROLE roleb

-- Test 75: statement (line 362)
CREATE ROLE rolec

-- Test 76: statement (line 365)
CREATE ROLE roled

-- Test 77: statement (line 368)
GRANT rolea TO roleb

-- Test 78: statement (line 371)
GRANT roleb TO rolea

-- Test 79: statement (line 374)
GRANT roleb TO rolec

-- Test 80: statement (line 377)
GRANT rolec TO roled

-- Test 81: statement (line 380)
GRANT rolea TO rolea

-- Test 82: statement (line 383)
GRANT roleb TO rolea

-- Test 83: statement (line 386)
GRANT rolec TO rolea

-- Test 84: statement (line 389)
GRANT roled TO rolea

-- Test 85: statement (line 392)
CREATE ROLE rolee

-- Test 86: statement (line 396)
GRANT roled TO testuser

-- Test 87: statement (line 400)
GRANT rolec TO testuser

-- Test 88: statement (line 403)
GRANT rolea TO roleb WITH ADMIN OPTION

user testuser

-- Test 89: query (line 408)
SELECT * FROM information_schema.administrable_role_authorizations

-- Test 90: query (line 414)
SELECT * FROM information_schema.applicable_roles

-- Test 91: query (line 424)
SELECT * FROM information_schema.enabled_roles

-- Test 92: statement (line 434)
GRANT roled TO rolee

-- Test 93: statement (line 437)
GRANT rolec TO rolee

-- Test 94: statement (line 440)
GRANT roleb TO rolee

-- Test 95: statement (line 443)
GRANT rolea TO rolee

-- Test 96: query (line 446)
SELECT * FROM information_schema.administrable_role_authorizations

-- Test 97: query (line 452)
SELECT * FROM information_schema.applicable_roles

-- Test 98: query (line 462)
SELECT * FROM information_schema.enabled_roles

-- Test 99: query (line 474)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 100: statement (line 486)
DROP ROLE rolea

-- Test 101: statement (line 489)
DROP ROLE rolec

-- Test 102: query (line 492)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 103: query (line 499)
select username, options, member_of from [SHOW ROLES]

-- Test 104: statement (line 510)
DROP ROLE roleb

-- Test 105: statement (line 513)
DROP ROLE roled

-- Test 106: statement (line 516)
DROP ROLE rolee

-- Test 107: statement (line 519)
REVOKE admin FROM root

-- Test 108: statement (line 522)
REVOKE ADMIN OPTION FOR admin FROM root

-- Test 109: statement (line 525)
REVOKE ADMIN OPTION FOR admin FROM unknownuser

-- Test 110: statement (line 528)
REVOKE ADMIN OPTION FOR unknownrole FROM root

-- Test 111: statement (line 531)
CREATE ROLE CURRENT_USER

-- Test 112: statement (line 534)
CREATE ROLE SESSION_USER

-- Test 113: statement (line 537)
CREATE ROLE rolea

-- Test 114: statement (line 540)
CREATE ROLE roleb

-- Test 115: statement (line 543)
GRANT rolea,roleb TO testuser WITH ADMIN OPTION

-- Test 116: statement (line 546)
GRANT rolea TO ""

-- Test 117: statement (line 549)
REVOKE rolea FROM ""

-- Test 118: statement (line 552)
GRANT "" TO rolea

-- Test 119: statement (line 555)
REVOKE "" FROM rolea

-- Test 120: query (line 558)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 121: statement (line 568)
GRANT rolea,roleb TO root WITH ADMIN OPTION

user root

-- Test 122: query (line 573)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 123: query (line 583)
SELECT * FROM information_schema.administrable_role_authorizations

-- Test 124: query (line 591)
SELECT * FROM information_schema.applicable_roles

-- Test 125: query (line 599)
SELECT * FROM information_schema.enabled_roles

-- Test 126: query (line 610)
SELECT * FROM information_schema.administrable_role_authorizations

-- Test 127: query (line 617)
SELECT * FROM information_schema.applicable_roles

-- Test 128: query (line 624)
SELECT * FROM information_schema.enabled_roles

-- Test 129: statement (line 632)
REVOKE ADMIN OPTION FOR rolea FROM testuser

-- Test 130: statement (line 635)
REVOKE ADMIN OPTION FOR rolea FROM root

-- Test 131: statement (line 638)
REVOKE roleb FROM root

user root

-- Test 132: query (line 643)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 133: statement (line 652)
REVOKE rolea, roleb FROM testuser, root

-- Test 134: query (line 655)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 135: statement (line 663)
GRANT roLea,rOleB TO tEstUSER WITH ADMIN OPTION

-- Test 136: query (line 666)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 137: statement (line 674)
REVOKE roleA, roleB FROM TestUser

-- Test 138: query (line 677)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 139: statement (line 685)
CREATE DATABASE db1

user testuser

-- Test 140: statement (line 690)
CREATE DATABASE db2

-- Test 141: statement (line 693)
DROP DATABASE db1

-- Test 142: statement (line 696)
GRANT admin TO testuser

user root

-- Test 143: statement (line 701)
CREATE ROLE newgroup

-- Test 144: statement (line 704)
GRANT newgroup TO testuser

-- Test 145: statement (line 707)
GRANT admin TO newgroup

user testuser

-- Test 146: query (line 712)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 147: statement (line 722)
CREATE DATABASE db2

user testuser

-- Test 148: statement (line 726)
DROP DATABASE db1

-- Test 149: statement (line 732)
REVOKE admin FROM newgroup

-- Test 150: statement (line 735)
CREATE SCHEMA db2.s1;

user testuser

-- Test 151: statement (line 740)
SELECT * FROM system.role_members

-- Test 152: statement (line 744)
CREATE TABLE db2.foo (k int);

-- Test 153: statement (line 747)
CREATE TABLE db2.s1.foo (k int);

user root

-- Test 154: query (line 752)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 155: statement (line 759)
GRANT ALL ON DATABASE db2 TO newgroup

user testuser

-- Test 156: query (line 764)
SHOW GRANTS ON DATABASE db2

-- Test 157: statement (line 773)
INSERT INTO db2.foo VALUES (1),(2),(3);

-- Test 158: statement (line 776)
SELECT * FROM db2.foo

-- Test 159: statement (line 780)
GRANT newgroup TO testuser2

-- Test 160: statement (line 783)
REVOKE newgroup FROM testuser

-- Test 161: statement (line 786)
GRANT newgroup TO testuser WITH ADMIN OPTION

-- Test 162: statement (line 793)
CREATE USER user1;
GRANT admin TO testuser

user testuser

-- Test 163: statement (line 799)
GRANT admin TO user1

-- Test 164: statement (line 802)
REVOKE admin FROM user1

user root

-- Test 165: statement (line 808)
GRANT admin TO testuser WITH ADMIN OPTION

user testuser

-- Test 166: statement (line 813)
GRANT admin TO user1

-- Test 167: statement (line 816)
REVOKE admin FROM user1

user root

-- Test 168: statement (line 821)
DROP USER user1

user root

-- Test 169: statement (line 827)
REVOKE ALL ON db2.foo FROM newgroup

-- Test 170: statement (line 830)
DROP TABLE db2.foo

-- Test 171: statement (line 834)
DROP USER testuser

-- Test 172: query (line 837)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 173: statement (line 843)
DROP ROLE newgroup

-- Test 174: statement (line 846)
REVOKE ALL ON DATABASE db2 FROM newgroup

-- Test 175: statement (line 849)
DROP ROLE newgroup

-- Test 176: statement (line 854)
CREATE USER public

-- Test 177: statement (line 857)
CREATE ROLE public

-- Test 178: statement (line 860)
CREATE ROLE "none"

-- Test 179: statement (line 863)
CREATE ROLE pg_otan

-- Test 180: statement (line 866)
CREATE ROLE crdb_internal_otan

-- Test 181: statement (line 869)
CREATE ROLE foo☂

-- Test 182: statement (line 872)
DROP USER public

-- Test 183: statement (line 875)
DROP ROLE public

-- Test 184: statement (line 878)
GRANT public TO testuser

-- Test 185: statement (line 881)
GRANT admin TO public

-- Test 186: statement (line 884)
REVOKE public FROM testuser

-- Test 187: statement (line 887)
REVOKE admin FROM public

-- Test 188: statement (line 892)
CREATE USER testuser

-- Test 189: query (line 895)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 190: statement (line 904)
CREATE ROLE rolef

user root

-- Test 191: statement (line 909)
ALTER ROLE testuser CREATEROLE

user testuser

-- Test 192: statement (line 914)
CREATE ROLE rolef

-- Test 193: statement (line 917)
DROP ROLE rolef

-- Test 194: statement (line 923)
ALTER ROLE testuser NOCREATEROLE

-- Test 195: statement (line 926)
CREATE ROLE rolewithcreate WITH NOCREATEROLE CREATEROLE

-- Test 196: statement (line 929)
CREATE ROLE rolewithcreate NOCREATEROLE CREATEROLE

-- Test 197: statement (line 932)
CREATE ROLE rolewithcreate REPLICATION NOREPLICATION

-- Test 198: statement (line 935)
ALTER ROLE testrole WITH CREATEROLE NOCREATEROLE

-- Test 199: statement (line 938)
ALTER ROLE testrole CREATEROLE NOCREATEROLE

-- Test 200: statement (line 941)
ALTER ROLE testrole CONTROLJOB NOCONTROLJOB

-- Test 201: statement (line 944)
CREATE ROLE rolewithcreate WITH CREATEROLE CREATEROLE

-- Test 202: statement (line 947)
CREATE ROLE rolewithcreate WITH NOCREATEROLE NOCREATEROLE

-- Test 203: statement (line 950)
ALTER ROLE testrole WITH CREATEROLE CREATEROLE

-- Test 204: statement (line 953)
ALTER ROLE testrole WITH NOCREATEROLE NOCREATEROLE

-- Test 205: statement (line 956)
CREATE ROLE rolewithcreate WITH CREATEROLE

-- Test 206: statement (line 959)
CREATE ROLE anotherrolewithcreate CREATEROLE

-- Test 207: statement (line 962)
CREATE ROLE rolewithoutcreate WITH NOCREATEROLE

-- Test 208: statement (line 965)
CREATE ROLE IF NOT EXISTS rolewithcreate2 WITH CREATEROLE

-- Test 209: statement (line 968)
CREATE ROLE IF NOT EXISTS anotherrolewithcreate2 CREATEROLE

-- Test 210: statement (line 971)
CREATE ROLE IF NOT EXISTS rolewithoutcreate2 WITH NOCREATEROLE

-- Test 211: query (line 974)
SELECT role, member, "isAdmin" FROM system.role_members

-- Test 212: statement (line 983)
CREATE ROLE rolewithcreate3 WITH CREATEROLE

-- Test 213: statement (line 986)
ALTER ROLE rolewithcreate WITH NOCREATEROLE

user root

-- Test 214: statement (line 991)
ALTER USER testuser CREATEROLE CREATELOGIN

user testuser

-- Test 215: statement (line 996)
CREATE ROLE roleg WITH CREATEROLE

-- Test 216: statement (line 999)
ALTER ROLE roleg WITH NOCREATEROLE

-- Test 217: statement (line 1002)
DROP ROLE roleg

-- Test 218: statement (line 1005)
CREATE ROLE IF NOT EXISTS roleg

-- Test 219: statement (line 1008)
CREATE ROLE IF NOT EXISTS roleg

-- Test 220: statement (line 1011)
CREATE USER testuser3

-- Test 221: statement (line 1014)
GRANT admin to testuser3

-- Test 222: statement (line 1018)
GRANT roleg to testuser3

user root

-- Test 223: statement (line 1023)
ALTER ROLE rolewithcreate WITH NOCREATEROLE

-- Test 224: statement (line 1026)
ALTER USER testuser NOCREATEROLE

-- Test 225: statement (line 1029)
ALTER ROLE admin with NOCREATEROLE

-- Test 226: statement (line 1036)
CREATE ROLE roleh WITH CREATEROLE

-- Test 227: statement (line 1039)
ALTER ROLE roleg with NOCREATEROLE

-- Test 228: statement (line 1042)
DROP ROLE roleg

-- Test 229: statement (line 1045)
CREATE ROLE IF NOT EXISTS rolewithcreate WITH CREATEROLE

-- Test 230: statement (line 1048)
CREATE USER testuser4

-- Test 231: statement (line 1051)
ALTER USER testuser3 WITH PASSWORD 'ilov3beefjerky'

user root

-- Test 232: statement (line 1056)
ALTER ROLE rolek CREATEROLE

-- Test 233: statement (line 1059)
ALTER ROLE IF EXISTS rolek CREATEROLE

-- Test 234: statement (line 1062)
ALTER USER IF EXISTS rolek NOCREATEROLE

-- Test 235: statement (line 1068)
CREATE ROLE parentrole WITH CREATEROLE

-- Test 236: statement (line 1071)
ALTER USER testuser WITH NOCREATEROLE

-- Test 237: statement (line 1074)
GRANT parentrole TO testuser

user testuser

-- Test 238: statement (line 1079)
CREATE ROLE rolej

-- Test 239: statement (line 1085)
DELETE FROM system.role_options WHERE NOT username in ('root', 'admin')

-- Test 240: statement (line 1088)
CREATE ROLE rolewithlogin LOGIN

-- Test 241: query (line 1091)
SELECT username, option, value FROM system.role_options

-- Test 242: statement (line 1095)
CREATE ROLE rolewithnologin NOLOGIN

-- Test 243: query (line 1098)
SELECT username, option, value FROM system.role_options

-- Test 244: statement (line 1103)
ALTER ROLE rolewithlogin VALID UNTIL '2020-01-01'

-- Test 245: query (line 1106)
SELECT username, option, value FROM system.role_options ORDER BY username

-- Test 246: statement (line 1112)
ALTER ROLE rolewithlogin VALID UNTIL NULL

-- Test 247: query (line 1115)
SELECT username, option, value FROM system.role_options ORDER BY username

-- Test 248: statement (line 1121)
DROP ROLE rolewithlogin

-- Test 249: query (line 1124)
SELECT username, option, value FROM system.role_options

-- Test 250: statement (line 1129)
CREATE ROLE thisshouldntwork LOGIN NOLOGIN

-- Test 251: statement (line 1132)
CREATE ROLE thisshouldntwork LOGIN LOGIN

-- Test 252: statement (line 1135)
DROP ROLE parentrole

-- Test 253: query (line 1138)
SHOW GRANTS ON ROLE

-- Test 254: query (line 1145)
SHOW GRANTS ON ROLE admin

-- Test 255: query (line 1151)
SHOW GRANTS ON ROLE FOR root

-- Test 256: query (line 1157)
SHOW GRANTS ON ROLE admin FOR root

-- Test 257: query (line 1163)
SHOW GRANTS ON ROLE FOR testuser

-- Test 258: query (line 1168)
SHOW GRANTS ON ROLE testuser,admin FOR testuser,admin

-- Test 259: statement (line 1175)
CREATE USER public

-- Test 260: statement (line 1178)
DROP USER public

-- Test 261: statement (line 1181)
CREATE DATABASE publicdb

-- Test 262: statement (line 1184)
CREATE DATABASE privatedb;
REVOKE CONNECT ON DATABASE privatedb FROM public

-- Test 263: statement (line 1188)
CREATE TABLE publicdb.publictable (k int)

-- Test 264: statement (line 1191)
CREATE TABLE publicdb.privatetable (k int)

-- Test 265: statement (line 1194)
CREATE TABLE privatedb.publictable (k int)

-- Test 266: statement (line 1197)
CREATE TABLE privatedb.privatetable (k int)

-- Test 267: statement (line 1200)
GRANT CONNECT ON DATABASE publicdb TO public

-- Test 268: statement (line 1203)
GRANT SELECT ON publicdb.publictable TO public

-- Test 269: statement (line 1206)
GRANT SELECT ON privatedb.publictable TO public

user testuser

-- Test 270: query (line 1211)
SHOW DATABASES

-- Test 271: query (line 1220)
SHOW TABLES FROM publicdb

-- Test 272: query (line 1226)
SHOW TABLES FROM privatedb

-- Test 273: statement (line 1230)
SELECT * FROM publicdb.publictable

-- Test 274: statement (line 1233)
SELECT * FROM publicdb.privatetable

-- Test 275: statement (line 1236)
SELECT * FROM privatedb.publictable

-- Test 276: statement (line 1239)
SELECT * FROM privatedb.privatetable

-- Test 277: statement (line 1242)
INSERT INTO publicdb.publictable VALUES (1)

user root

-- Test 278: statement (line 1247)
GRANT INSERT ON publicdb.publictable TO public

user testuser

-- Test 279: statement (line 1252)
INSERT INTO publicdb.publictable VALUES (1)

user root

-- Test 280: statement (line 1258)
REVOKE ALL ON publicdb.publictable FROM public

user testuser

-- Test 281: statement (line 1263)
SELECT * FROM publicdb.publictable

-- Test 282: statement (line 1266)
INSERT INTO publicdb.publictable VALUES (1)

-- Test 283: query (line 1269)
SHOW TABLES FROM publicdb

-- Test 284: statement (line 1278)
CREATE USER myadmin;
GRANT admin TO myadmin;
ALTER USER testuser CREATEROLE

user testuser

-- Test 285: statement (line 1285)
DROP USER myadmin

-- Test 286: statement (line 1292)
ALTER USER testuser CREATEROLE;
  DROP USER testuser2;
  DROP USER testuser3;

user testuser

-- Test 287: statement (line 1301)
CREATE USER testuser3 WITH PASSWORD 'abc'

-- Test 288: statement (line 1304)
CREATE USER testuser3 LOGIN

-- Test 289: statement (line 1307)
CREATE ROLE testrole3 LOGIN

-- Test 290: statement (line 1310)
CREATE USER testuser2

-- Test 291: statement (line 1314)
CREATE ROLE testuser4

-- Test 292: statement (line 1318)
CREATE USER testuser2 NOLOGIN

-- Test 293: statement (line 1321)
ALTER USER testuser2 WITH PASSWORD 'abc'

-- Test 294: statement (line 1324)
ALTER USER testuser2 LOGIN

-- Test 295: statement (line 1327)
ALTER USER testuser2 NOLOGIN

-- Test 296: statement (line 1330)
ALTER USER testuser2 CREATELOGIN

-- Test 297: statement (line 1333)
ALTER USER testuser2 NOCREATELOGIN

-- Test 298: statement (line 1336)
ALTER USER testuser2 VALID UNTIL '2021-01-01'

-- Test 299: statement (line 1339)
CREATE ROLE otherrole

-- Test 300: statement (line 1342)
ALTER ROLE otherrole CREATELOGIN

-- Test 301: statement (line 1345)
ALTER ROLE otherrole NOCREATELOGIN

-- Test 302: statement (line 1348)
ALTER ROLE otherrole LOGIN

-- Test 303: statement (line 1351)
ALTER ROLE otherrole NOLOGIN

-- Test 304: statement (line 1354)
CREATE ROLE otherrole2 CREATELOGIN

-- Test 305: statement (line 1357)
CREATE ROLE otherrole2 NOCREATELOGIN

-- Test 306: statement (line 1360)
CREATE ROLE otherrole2 LOGIN

user root

-- Test 307: statement (line 1365)
ALTER ROLE testuser CREATELOGIN

user testuser

-- Test 308: statement (line 1370)
ALTER USER testuser PASSWORD NULL

-- Test 309: statement (line 1373)
CREATE USER testuser3 WITH PASSWORD 'abc'

-- Test 310: statement (line 1376)
ALTER USER testuser3 WITH PASSWORD 'xyz'

-- Test 311: statement (line 1379)
ALTER USER testuser3 VALID UNTIL '2021-01-01'

-- Test 312: statement (line 1382)
ALTER USER testuser3 LOGIN

-- Test 313: statement (line 1385)
ALTER USER testuser3 NOLOGIN

-- Test 314: statement (line 1388)
ALTER USER testuser3 CREATELOGIN

-- Test 315: statement (line 1391)
ALTER USER testuser3 NOCREATELOGIN

-- Test 316: statement (line 1394)
ALTER ROLE otherrole CREATELOGIN

-- Test 317: statement (line 1397)
ALTER ROLE otherrole NOCREATELOGIN

-- Test 318: statement (line 1401)
ALTER ROLE otherrole LOGIN

-- Test 319: statement (line 1404)
ALTER ROLE otherrole NOLOGIN

-- Test 320: statement (line 1407)
CREATE ROLE otherrole2 CREATELOGIN

-- Test 321: statement (line 1410)
CREATE ROLE otherrole3 NOCREATELOGIN

-- Test 322: statement (line 1413)
CREATE ROLE otherrole4 LOGIN

-- Test 323: statement (line 1420)
ALTER USER testuser NOCREATELOGIN

-- Test 324: query (line 1424)
SHOW CLUSTER SETTING sql.auth.change_own_password.enabled

-- Test 325: statement (line 1431)
CREATE USER testuser5

-- Test 326: statement (line 1434)
CREATE ROLE testuser6

-- Test 327: statement (line 1437)
CREATE USER testuser5 WITH PASSWORD 'abc'

-- Test 328: statement (line 1441)
ALTER USER testuser PASSWORD 'xyz'

-- Test 329: statement (line 1444)
ALTER USER CURRENT_USER PASSWORD '123'

-- Test 330: statement (line 1447)
ALTER USER testuser2 WITH PASSWORD 'abc'

-- Test 331: statement (line 1450)
ALTER USER testuser2 VALID UNTIL '2021-01-01'

-- Test 332: statement (line 1453)
ALTER USER testuser2 LOGIN

-- Test 333: statement (line 1456)
ALTER USER testuser2 NOLOGIN

-- Test 334: statement (line 1459)
ALTER ROLE otherrole CREATELOGIN

-- Test 335: statement (line 1462)
ALTER ROLE otherrole NOCREATELOGIN

-- Test 336: statement (line 1465)
ALTER ROLE otherrole LOGIN

-- Test 337: statement (line 1468)
ALTER ROLE otherrole NOLOGIN

-- Test 338: statement (line 1471)
CREATE ROLE otherrole4 CREATELOGIN

-- Test 339: statement (line 1474)
CREATE ROLE otherrole4 NOCREATELOGIN

-- Test 340: statement (line 1477)
CREATE ROLE otherrole4 LOGIN

user root

-- Test 341: statement (line 1484)
SET CLUSTER SETTING sql.auth.change_own_password.enabled = true

user testuser

-- Test 342: statement (line 1490)
ALTER USER testuser PASSWORD 'xyz'

-- Test 343: statement (line 1493)
ALTER USER CURRENT_USER PASSWORD '123'

-- Test 344: statement (line 1497)
ALTER USER testuser PASSWORD NULL

-- Test 345: statement (line 1501)
ALTER USER testuser2 WITH PASSWORD 'abc'

-- Test 346: statement (line 1505)
ALTER USER testuser PASSWORD 'abc' VALID UNTIL '4044-10-31'

user root

-- Test 347: statement (line 1510)
SET ROLE testuser

-- Test 348: statement (line 1514)
ALTER USER testuser PASSWORD 'cat'

-- Test 349: statement (line 1519)
ALTER USER testuser2 WITH PASSWORD 'abc'

-- Test 350: statement (line 1522)
RESET ROLE

-- Test 351: statement (line 1531)
DROP ROLE testuser

-- Test 352: statement (line 1534)
CREATE USER testuser with PROVISIONSRC 'ldap:example.com'

-- Test 353: statement (line 1537)
ALTER ROLE testuser WITH PROVISIONSRC 'ldap:example.com'

-- Test 354: statement (line 1540)
SET ROLE testuser

-- Test 355: statement (line 1545)
ALTER USER testuser PASSWORD 'cat'

-- Test 356: statement (line 1548)
ALTER USER testuser PROVISIONSRC 'ldap:example2.com'

-- Test 357: statement (line 1551)
RESET ROLE

user testuser

-- Test 358: statement (line 1557)
ALTER USER testuser PASSWORD 'xyz'

-- Test 359: statement (line 1560)
ALTER USER CURRENT_USER PASSWORD '123'

-- Test 360: statement (line 1563)
ALTER USER testuser PROVISIONSRC 'ldap:example2.com'

-- Test 361: statement (line 1567)
ALTER USER testuser PASSWORD NULL

-- Test 362: statement (line 1571)
ALTER USER testuser2 WITH PASSWORD 'abc'

-- Test 363: statement (line 1575)
ALTER USER testuser PASSWORD 'abc' VALID UNTIL '4044-10-31'

user root

-- Test 364: statement (line 1581)
DROP user testuser;
CREATE user testuser CREATEROLE;

-- Test 365: statement (line 1589)
CREATE ROLE repluser NOREPLICATION LOGIN

-- Test 366: query (line 1592)
SELECT option, value FROM system.role_options WHERE username = 'repluser'

-- Test 367: statement (line 1596)
ALTER ROLE repluser REPLICATION

-- Test 368: query (line 1599)
SELECT  option, value FROM system.role_options WHERE username = 'repluser'

-- Test 369: statement (line 1604)
DROP ROLE repluser; CREATE ROLE repluser REPLICATION LOGIN

-- Test 370: query (line 1607)
SELECT  option, value FROM system.role_options WHERE username = 'repluser'

-- Test 371: statement (line 1612)
ALTER ROLE repluser NOREPLICATION

-- Test 372: query (line 1615)
SELECT option, value FROM system.role_options WHERE username = 'repluser'

-- Test 373: statement (line 1622)
CREATE ROLE other_admin;
GRANT admin TO other_admin;
ALTER ROLE other_admin CREATEDB

user testuser

-- Test 374: statement (line 1632)
ALTER ROLE other_admin NOCREATEDB

-- Test 375: statement (line 1639)
SET CLUSTER SETTING server.user_login.password_encryption = 'crdb-bcrypt'

let $bcrypt_pw
SELECT 'CRDB-BCRYPT$'||'2a$'||'10$'||'vcmoIBvgeHjgScVHWRMWI.Z3v03WMixAw2bBS6qZihljSUuwi88Yq'

-- Test 376: statement (line 1645)
CREATE USER hash1 WITH PASSWORD '$bcrypt_pw'

-- Test 377: statement (line 1649)
CREATE USER hash2 WITH PASSWORD 'md5aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

let $scram_pw
SELECT 'SCRAM-SHA-256$'||'4096:B5VaTCvCLDzZxSYL829oVA==$'||'3Ako3mNxNtdsaSOJl0Av3i6vyV2OiSP9Ly7famdFSbw=:d7BfSmrtjwbF74mSoOhQiDSpoIvlakXKdpBNb3Meunc='

-- Test 378: statement (line 1655)
CREATE USER hash3 WITH PASSWORD '$scram_pw'

-- Test 379: statement (line 1659)
SET CLUSTER SETTING server.user_login.store_client_pre_hashed_passwords.enabled = false

-- Test 380: statement (line 1663)
CREATE USER hash4 WITH PASSWORD '$bcrypt_pw'

-- Test 381: statement (line 1667)
CREATE USER hash5 WITH PASSWORD 'md5aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

-- Test 382: statement (line 1671)
CREATE USER hash6 WITH PASSWORD '$scram_pw'

-- Test 383: query (line 1674)
SELECT username, substr("hashedPassword", 1, 7), 'CRDB-BCRYPT'||"hashedPassword" = '$bcrypt_pw' FROM system.users WHERE username LIKE 'hash%' ORDER BY 1

-- Test 384: statement (line 1682)
RESET CLUSTER SETTING server.user_login.store_client_pre_hashed_passwords.enabled;

-- Test 385: statement (line 1687)
SET CLUSTER SETTING server.user_login.password_hashes.default_cost.crdb_bcrypt = 8

-- Test 386: statement (line 1690)
CREATE USER hash7 WITH PASSWORD 'hello'

-- Test 387: query (line 1694)
SELECT username, substr("hashedPassword", 1, 7) FROM system.users WHERE username = 'hash7'

-- Test 388: statement (line 1699)
RESET CLUSTER SETTING server.user_login.password_hashes.default_cost.crdb_bcrypt;

-- Test 389: statement (line 1704)
SET CLUSTER SETTING server.user_login.password_encryption = 'scram-sha-256'

-- Test 390: statement (line 1707)
CREATE USER hash8 WITH PASSWORD 'hello world'

-- Test 391: query (line 1710)
SELECT username, substr("hashedPassword", 1, 20) FROM system.users WHERE username = 'hash8'

-- Test 392: statement (line 1715)
ALTER USER hash8 WITH PASSWORD 'hello universe'

-- Test 393: query (line 1718)
SELECT username, substr("hashedPassword", 1, 20) FROM system.users WHERE username = 'hash8'

-- Test 394: statement (line 1725)
SET CLUSTER SETTING server.user_login.password_hashes.default_cost.scram_sha_256 = 200000

-- Test 395: statement (line 1728)
ALTER USER hash8 WITH PASSWORD 'hai'

-- Test 396: query (line 1731)
SELECT username, substr("hashedPassword", 1, 20) FROM system.users WHERE username = 'hash8'

-- Test 397: statement (line 1737)
RESET CLUSTER SETTING server.user_login.password_encryption;

-- Test 398: statement (line 1740)
RESET CLUSTER SETTING server.user_login.password_hashes.default_cost.scram_sha_256

-- Test 399: statement (line 1750)
ALTER ROLE testuser NOCREATEROLE

user testuser

-- Test 400: statement (line 1755)
CREATE ROLE u_create_role_priv

user root

-- Test 401: statement (line 1760)
GRANT SYSTEM CREATEROLE TO testuser

user testuser

-- Test 402: statement (line 1765)
CREATE ROLE u_create_role_priv

user root

-- Test 403: statement (line 1770)
REVOKE SYSTEM CREATEROLE FROM testuser

user testuser

-- Test 404: statement (line 1775)
DROP ROLE u_create_role_priv

user root

-- Test 405: statement (line 1780)
CREATE ROLE parent_with_createrole

-- Test 406: statement (line 1783)
GRANT parent_with_createrole TO testuser

-- Test 407: statement (line 1786)
GRANT SYSTEM CREATEROLE TO parent_with_createrole

user testuser

-- Test 408: statement (line 1791)
DROP ROLE u_create_role_priv

user root

-- Test 409: statement (line 1796)
REVOKE SYSTEM CREATEROLE FROM parent_with_createrole

-- Test 410: statement (line 1799)
DROP ROLE parent_with_createrole

-- Test 411: statement (line 1808)
ALTER ROLE testuser CREATEROLE NOCREATELOGIN

user testuser

-- Test 412: statement (line 1813)
CREATE USER u_create_login_priv WITH PASSWORD 'roacher4lyfe'

user root

-- Test 413: statement (line 1818)
GRANT SYSTEM CREATELOGIN TO testuser

user testuser

-- Test 414: statement (line 1823)
CREATE USER u_create_login_priv WITH PASSWORD 'roacher4lyfe'

-- Test 415: statement (line 1826)
DROP USER u_create_login_priv

user root

-- Test 416: statement (line 1831)
REVOKE SYSTEM CREATELOGIN FROM testuser

user testuser

-- Test 417: statement (line 1836)
CREATE USER u_create_login_priv WITH PASSWORD 'roacher4lyfe'

user root

-- Test 418: statement (line 1841)
CREATE ROLE creator_of_logins

-- Test 419: statement (line 1844)
GRANT SYSTEM CREATELOGIN TO creator_of_logins

-- Test 420: statement (line 1847)
GRANT creator_of_logins TO testuser

user testuser

-- Test 421: statement (line 1852)
CREATE USER u_create_login_priv WITH PASSWORD 'roacher4lyfe'

-- Test 422: statement (line 1855)
DROP USER u_create_login_priv

user root

-- Test 423: statement (line 1860)
REVOKE SYSTEM CREATELOGIN FROM creator_of_logins

-- Test 424: statement (line 1863)
DROP ROLE creator_of_logins

-- Test 425: statement (line 1866)
ALTER ROLE testuser NOCREATEROLE

-- Test 426: statement (line 1875)
ALTER ROLE testuser NOCREATEDB

user testuser

-- Test 427: statement (line 1880)
CREATE DATABASE db_create_db_priv

user root

-- Test 428: statement (line 1885)
GRANT SYSTEM CREATEDB TO testuser

user testuser

-- Test 429: statement (line 1890)
CREATE DATABASE db_create_db_priv

user root

-- Test 430: statement (line 1895)
REVOKE SYSTEM CREATEDB FROM testuser

user testuser

-- Test 431: statement (line 1900)
ALTER DATABASE db_create_db_priv RENAME TO renamed_db_create_db_priv

user root

-- Test 432: statement (line 1905)
CREATE ROLE creator_of_databases

-- Test 433: statement (line 1908)
GRANT creator_of_databases TO testuser

-- Test 434: statement (line 1911)
GRANT SYSTEM CREATEDB TO creator_of_databases

user testuser

-- Test 435: statement (line 1916)
ALTER DATABASE db_create_db_priv RENAME TO renamed_db_create_db_priv

user root

-- Test 436: statement (line 1921)
DROP DATABASE renamed_db_create_db_priv

-- Test 437: statement (line 1924)
REVOKE SYSTEM CREATEDB FROM creator_of_databases

-- Test 438: statement (line 1927)
DROP ROLE creator_of_databases

-- Test 439: statement (line 1939)
ALTER ROLE testuser SUBJECT 'foo'

-- Test 440: statement (line 1951)
ALTER ROLE testuser PROVISIONSRC 'ldap:ldap.example.com'

-- Test 441: statement (line 1961)
CREATE DATABASE block_db;
USE block_db;
CREATE TABLE t(n int);
CREATE TYPE  typ AS ENUM ('open', 'closed', 'inactive');
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
CREATE ROLE block_user;
GRANT ALL ON DATABASE block_db to block_user;
GRANT ALL ON SCHEMA public to block_user;
GRANT ALL ON TABLE t to block_user;
GRANT ALL ON TYPE typ to block_user;
GRANT ALL ON FUNCTION f to block_user;

-- Test 442: statement (line 1974)
DROP ROLE block_user

-- Test 443: statement (line 1977)
USE defaultdb;

