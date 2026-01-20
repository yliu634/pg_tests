-- PostgreSQL compatible tests from alter_type
-- 201 tests

-- Test 1: statement (line 2)
CREATE TYPE greeting AS ENUM ('hi', 'hello');
ALTER TYPE greeting RENAME TO newname

-- Test 2: query (line 7)
SELECT 'hi'::newname

-- Test 3: query (line 13)
SELECT ARRAY['hi']::_newname

-- Test 4: statement (line 19)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl=off;
ALTER TYPE newname RENAME TO renameagain

-- Test 5: query (line 24)
SELECT 'hi'::renameagain

-- Test 6: statement (line 29)
ROLLBACK

-- Test 7: statement (line 33)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TYPE newname RENAME TO new_name

-- Test 8: query (line 37)
SELECT 'hi'::new_name

-- Test 9: statement (line 42)
ALTER TYPE new_name RENAME TO new__name

-- Test 10: query (line 45)
SELECT 'hi'::new__name

-- Test 11: statement (line 50)
COMMIT

-- Test 12: statement (line 53)
ALTER TYPE new__name RENAME TO newname

-- Test 13: statement (line 57)
CREATE TABLE conflict (x INT)

-- Test 14: statement (line 60)
ALTER TYPE newname RENAME TO conflict

-- Test 15: statement (line 65)
CREATE TYPE _why AS ENUM ('pg', 'array', 'types', 'are', 'silly')

-- Test 16: statement (line 69)
ALTER TYPE newname RENAME TO why

-- Test 17: query (line 72)
SELECT ARRAY['hi']::___why

-- Test 18: statement (line 77)
CREATE TYPE names AS ENUM ('james', 'johnny')

-- Test 19: statement (line 81)
ALTER TYPE names RENAME VALUE 'james' TO 'johnny'

-- Test 20: statement (line 85)
ALTER TYPE names RENAME VALUE 'jim' TO 'jimmy'

-- Test 21: statement (line 88)
ALTER TYPE names RENAME VALUE 'james' to 'jimmy'

-- Test 22: query (line 92)
SELECT enum_range('jimmy'::names);

-- Test 23: statement (line 98)
SELECT 'james'::names

-- Test 24: statement (line 102)
BEGIN

-- Test 25: statement (line 105)
ALTER TYPE names RENAME VALUE 'jimmy' TO 'jim'

-- Test 26: statement (line 108)
ALTER TYPE names RENAME VALUE 'johnny' TO 'john'

-- Test 27: statement (line 111)
COMMIT

-- Test 28: query (line 115)
SELECT enum_range('jim'::names);

-- Test 29: statement (line 120)
SELECT 'jimmy'::names

-- Test 30: statement (line 123)
SELECT 'johnny'::names

-- Test 31: statement (line 129)
CREATE TYPE build AS ENUM ()

-- Test 32: statement (line 132)
ALTER TYPE build ADD VALUE 'c'

-- Test 33: query (line 135)
SELECT enum_range('c'::build)

-- Test 34: statement (line 141)
ALTER TYPE build ADD VALUE 'c'

-- Test 35: statement (line 144)
ALTER TYPE build ADD VALUE 'a' BEFORE 'b'

-- Test 36: statement (line 147)
ALTER TYPE build ADD VALUE 'a' AFTER 'b'

-- Test 37: statement (line 150)
ALTER TYPE build ADD VALUE IF NOT EXISTS 'c'

-- Test 38: statement (line 153)
ALTER TYPE build ADD VALUE 'f'

-- Test 39: query (line 156)
SELECT enum_range('c'::build)

-- Test 40: statement (line 161)
ALTER TYPE build ADD VALUE 'd' AFTER 'c'

-- Test 41: query (line 164)
SELECT enum_range('c'::build)

-- Test 42: statement (line 169)
ALTER TYPE build ADD VALUE 'e' BEFORE 'f'

-- Test 43: query (line 172)
SELECT enum_range('c'::build)

-- Test 44: statement (line 177)
ALTER TYPE build ADD VALUE 'a' BEFORE 'c'

-- Test 45: query (line 180)
SELECT enum_range('c'::build)

-- Test 46: statement (line 185)
ALTER TYPE build ADD VALUE 'b' AFTER 'a'

-- Test 47: query (line 188)
SELECT enum_range('c'::build)

-- Test 48: statement (line 194)
CREATE TABLE new_enum_values (x build)

-- Test 49: statement (line 197)
SET autocommit_before_ddl = false

-- Test 50: statement (line 200)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TYPE build ADD VALUE 'g';
ALTER TYPE build ADD VALUE '_a' BEFORE 'a'

-- Test 51: query (line 206)
SELECT enum_range('c'::build)

-- Test 52: query (line 211)
SELECT enum_first('c'::build)

-- Test 53: query (line 216)
SELECT enum_last('c'::build)

-- Test 54: statement (line 221)
INSERT INTO new_enum_values VALUES ('g')

-- Test 55: statement (line 224)
ROLLBACK

-- Test 56: statement (line 227)
RESET autocommit_before_ddl

-- Test 57: statement (line 231)
CREATE TYPE cache AS ENUM ('lru', 'clock')

-- Test 58: query (line 235)
SELECT 'clock'::cache

-- Test 59: statement (line 241)
ALTER TYPE cache RENAME VALUE 'clock' TO 'clock-pro'

-- Test 60: statement (line 244)
SELECT 'clock'::cache

-- Test 61: query (line 248)
SELECT 'lru'::cache

-- Test 62: statement (line 253)
ALTER TYPE cache RENAME TO store

-- Test 63: statement (line 256)
SELECT 'lru'::cache

-- Test 64: query (line 260)
SELECT 'lru'::store

-- Test 65: statement (line 265)
DROP TYPE store

-- Test 66: statement (line 268)
SELECT 'lru'::store

-- Test 67: statement (line 271)
CREATE TYPE greetings AS ENUM('hi', 'hello', 'howdy', 'yo')

-- Test 68: statement (line 274)
ALTER TYPE greetings DROP VALUE 'hi'

-- Test 69: statement (line 277)
SELECT 'hi'::greetings

-- Test 70: statement (line 280)
CREATE TABLE use_greetings(k INT PRIMARY KEY, v greetings)

-- Test 71: statement (line 283)
INSERT INTO use_greetings VALUES(1, 'yo')

-- Test 72: statement (line 286)
ALTER TYPE greetings DROP VALUE 'yo'

-- Test 73: query (line 289)
SELECT 'yo'::greetings

-- Test 74: statement (line 295)
ALTER TYPE greetings DROP VALUE 'howdy'

-- Test 75: query (line 298)
SELECT * FROM [SHOW ENUMS] WHERE name = 'greetings'

-- Test 76: statement (line 303)
SELECT 'howdy'::greetings

-- Test 77: statement (line 306)
CREATE TABLE use_greetings2(k INT PRIMARY KEY, v greetings);
INSERT INTO use_greetings2 VALUES (1, 'hello')

-- Test 78: statement (line 310)
ALTER TYPE greetings DROP VALUE 'hello'

-- Test 79: query (line 313)
SELECT 'hello'::greetings

-- Test 80: statement (line 320)
DELETE FROM use_greetings WHERE use_greetings.v = 'yo'

-- Test 81: statement (line 323)
ALTER TYPE greetings DROP VALUE 'yo'

-- Test 82: statement (line 326)
SELECT 'yo'::greetings

-- Test 83: query (line 329)
SELECT * FROM [SHOW ENUMS] WHERE name = 'greetings'

-- Test 84: statement (line 334)
CREATE TYPE alphabets AS ENUM('a', 'b', 'c', 'd', 'e', 'f');
CREATE TABLE uses_alphabets (k INT PRIMARY KEY, v1 alphabets, v2 alphabets);
INSERT INTO uses_alphabets VALUES (1, 'a', 'a'), (2, 'b', 'c')

-- Test 85: statement (line 339)
ALTER TYPE alphabets DROP VALUE 'a'

-- Test 86: statement (line 342)
ALTER TYPE alphabets DROP VALUE 'b'

-- Test 87: statement (line 345)
ALTER TYPE alphabets DROP VALUE 'c'

-- Test 88: statement (line 348)
DELETE FROM uses_alphabets WHERE k = 1

-- Test 89: statement (line 351)
ALTER TYPE alphabets DROP VALUE 'a'

-- Test 90: statement (line 355)
ALTER TYPE alphabets DROP VALUE 'b'

-- Test 91: statement (line 358)
ALTER TYPE alphabets DROP VALUE 'c'

-- Test 92: statement (line 362)
CREATE VIEW v as SELECT 'd':::alphabets;
CREATE TABLE uses_alphabets_2(k INT PRIMARY KEY, v alphabets DEFAULT 'e');

-- Test 93: statement (line 366)
ALTER TYPE alphabets DROP VALUE 'd'

-- Test 94: statement (line 369)
INSERT INTO uses_alphabets_2 VALUES(1);

-- Test 95: statement (line 373)
ALTER TYPE alphabets DROP VALUE 'e'

-- Test 96: statement (line 377)
ALTER TABLE uses_alphabets_2 SET (schema_locked=false)

-- Test 97: statement (line 380)
TRUNCATE uses_alphabets_2

-- Test 98: statement (line 383)
ALTER TABLE uses_alphabets_2 RESET (schema_locked)

-- Test 99: statement (line 386)
ALTER TYPE alphabets DROP VALUE 'e'

-- Test 100: statement (line 389)
INSERT INTO uses_alphabets_2 VALUES(1);

-- Test 101: statement (line 392)
INSERT INTO uses_alphabets_2 VALUES (2, 'f')

-- Test 102: statement (line 396)
ALTER TABLE uses_alphabets_2 DROP COLUMN v

-- Test 103: statement (line 399)
ALTER TYPE alphabets DROP VALUE 'f'

-- Test 104: statement (line 405)
CREATE TYPE a AS ENUM('a')

-- Test 105: statement (line 408)
SET autocommit_before_ddl = false

-- Test 106: statement (line 411)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TYPE a ADD VALUE 'b';
ALTER TYPE a DROP VALUE 'b';

-- Test 107: statement (line 416)
ROLLBACK

-- Test 108: statement (line 419)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TYPE a DROP VALUE 'a';
ALTER TYPE a ADD VALUE 'a';

-- Test 109: statement (line 424)
ROLLBACK

-- Test 110: statement (line 428)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TYPE a DROP VALUE 'a';
ALTER TYPE a DROP VALUE 'a'

-- Test 111: statement (line 433)
ROLLBACK

-- Test 112: statement (line 438)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TYPE a DROP VALUE 'a';
ALTER TYPE a ADD VALUE IF NOT EXISTS 'a';

-- Test 113: statement (line 443)
ROLLBACK

-- Test 114: statement (line 446)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TYPE a ADD VALUE 'b';
ALTER TYPE a ADD VALUE IF NOT EXISTS 'b';
COMMIT

-- Test 115: statement (line 454)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TYPE a ADD VALUE 'c';
ALTER TYPE a RENAME VALUE 'c' TO 'new_name';

-- Test 116: statement (line 459)
ROLLBACK

-- Test 117: statement (line 464)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TYPE a DROP VALUE 'a';
ALTER TYPE a RENAME VALUE 'a' TO 'new_name';

-- Test 118: statement (line 469)
ROLLBACK

-- Test 119: statement (line 472)
RESET autocommit_before_ddl

-- Test 120: statement (line 478)
CREATE TYPE ab_58710 AS ENUM ('a', 'b')

-- Test 121: statement (line 483)
SELECT ARRAY['c']::_ab_58710

-- Test 122: statement (line 486)
SELECT ARRAY['a']::_ab_58710;

-- Test 123: statement (line 489)
ALTER TYPE ab_58710 ADD VALUE 'c';

-- Test 124: statement (line 492)
ALTER TYPE ab_58710 DROP VALUE 'a';

-- Test 125: statement (line 497)
SELECT ARRAY['c']::_ab_58710;

-- Test 126: statement (line 500)
SELECT ARRAY['a']::_ab_58710

-- Test 127: statement (line 505)
CREATE TYPE enum_60004 AS ENUM ('a', 'b', 'c')

-- Test 128: statement (line 508)
CREATE TABLE t_60004 (k INT PRIMARY KEY, v enum_60004[])

-- Test 129: statement (line 511)
INSERT INTO t_60004 VALUES (1, ARRAY['a'])

-- Test 130: statement (line 514)
ALTER TYPE enum_60004 DROP VALUE 'a'

-- Test 131: statement (line 518)
ALTER TYPE enum_60004 DROP VALUE 'b'

-- Test 132: statement (line 521)
CREATE VIEW v_60004 AS SELECT ARRAY['c']:::_enum_60004 AS v;

-- Test 133: statement (line 524)
ALTER TYPE enum_60004 DROP VALUE 'c'

-- Test 134: statement (line 529)
CREATE TYPE alphabets_60004 AS ENUM ('a', 'b', 'c', 'd')

-- Test 135: statement (line 532)
CREATE TABLE using_alphabets_60004(k INT PRIMARY KEY, v1 alphabets_60004[], v2 alphabets_60004[])

-- Test 136: statement (line 535)
INSERT INTO using_alphabets_60004 VALUES (1, ARRAY['a', 'b', 'c'], ARRAY['a','b']), (2, ARRAY['a', 'b', 'c'], ARRAY['a','d'])

-- Test 137: statement (line 538)
CREATE TABLE using_alphabets2_60004(k INT PRIMARY KEY, v1 alphabets_60004, v2 alphabets_60004[])

-- Test 138: statement (line 541)
INSERT INTO using_alphabets2_60004 VALUES (1, 'a', ARRAY['b', 'a'])

-- Test 139: statement (line 544)
ALTER TYPE alphabets_60004 DROP VALUE 'd'

-- Test 140: statement (line 548)
DELETE FROM using_alphabets_60004 WHERE k = 2

-- Test 141: statement (line 551)
ALTER TYPE alphabets_60004 DROP VALUE 'd'

-- Test 142: statement (line 554)
ALTER TYPE alphabets_60004 DROP VALUE 'c'

-- Test 143: statement (line 557)
ALTER TYPE alphabets_60004 DROP VALUE 'b'

-- Test 144: statement (line 560)
ALTER TABLE using_alphabets_60004 SET (schema_locked=false);

-- Test 145: statement (line 563)
TRUNCATE using_alphabets_60004

-- Test 146: statement (line 566)
ALTER TABLE using_alphabets_60004 RESET (schema_locked);

-- Test 147: statement (line 570)
ALTER TYPE alphabets_60004 DROP VALUE 'c'

-- Test 148: statement (line 573)
ALTER TYPE alphabets_60004 DROP VALUE 'a'

-- Test 149: statement (line 576)
ALTER TYPE alphabets_60004 DROP VALUE 'b'

-- Test 150: statement (line 579)
ALTER TABLE using_alphabets2_60004 SET (schema_locked=false);

-- Test 151: statement (line 583)
TRUNCATE using_alphabets2_60004

-- Test 152: statement (line 586)
ALTER TABLE using_alphabets2_60004 RESET (schema_locked);

-- Test 153: statement (line 590)
ALTER TYPE alphabets_60004 DROP VALUE 'a'

-- Test 154: statement (line 593)
ALTER TYPE alphabets_60004 DROP VALUE 'b'

-- Test 155: statement (line 599)
CREATE TYPE ifNotExists AS ENUM()

-- Test 156: query (line 604)
CREATE TYPE IF NOT EXISTS ifNotExists AS ENUM();

-- Test 157: statement (line 611)
CREATE TYPE reg_64101 AS ENUM('a', 'b', 'c')

-- Test 158: statement (line 614)
CREATE VIEW v_64101 AS SELECT ARRAY['a']:::_reg_64101

-- Test 159: statement (line 617)
ALTER TYPE reg_64101 DROP VALUE 'b'

-- Test 160: statement (line 620)
ALTER TYPE reg_64101 DROP VALUE 'a'

-- Test 161: statement (line 623)
DROP VIEW v_64101;

-- Test 162: statement (line 626)
CREATE VIEW v_64101 AS SELECT ARRAY['c'::reg_64101]

-- Test 163: statement (line 629)
ALTER TYPE reg_64101 DROP VALUE 'a'

-- Test 164: statement (line 632)
ALTER TYPE reg_64101 DROP VALUE 'c'

-- Test 165: statement (line 635)
CREATE TYPE typ_64101 AS ENUM('a', 'b', 'c');

-- Test 166: statement (line 638)
CREATE TABLE t1_64101("bob""b" typ_64101);

-- Test 167: statement (line 641)
CREATE TABLE t2_64101("bob""''b" typ_64101[]);

-- Test 168: statement (line 644)
INSERT INTO t1_64101 VALUES ('a');

-- Test 169: statement (line 647)
INSERT INTO t2_64101 VALUES(ARRAY['b'])

-- Test 170: statement (line 650)
ALTER TYPE typ_64101 DROP VALUE 'c'

-- Test 171: statement (line 653)
ALTER TYPE typ_64101 DROP VALUE 'a'

-- Test 172: statement (line 656)
ALTER TYPE typ_64101 DROP VALUE 'b'

-- Test 173: statement (line 661)
ALTER TYPE sc64398.geometry RENAME TO bar

-- Test 174: statement (line 664)
ALTER TYPE sc64398.public.geometry RENAME TO bar

-- Test 175: statement (line 667)
CREATE SCHEMA sc64398;

-- Test 176: statement (line 670)
CREATE TYPE sc64398.geometry AS ENUM()

-- Test 177: statement (line 673)
ALTER TYPE sc64398.geometry RENAME TO bar

-- Test 178: statement (line 680)
CREATE TYPE abc AS ENUM ('a', 'b', 'c')

-- Test 179: statement (line 683)
CREATE VIEW abc_view AS (SELECT k FROM (SELECT 'a'::abc AS k))

-- Test 180: statement (line 686)
ALTER TYPE abc DROP VALUE 'a'

-- Test 181: statement (line 689)
CREATE VIEW abc_view2 AS (SELECT 'a'::abc < 'b'::abc)

-- Test 182: statement (line 692)
ALTER TYPE abc DROP VALUE 'b'

-- Test 183: statement (line 695)
ALTER TYPE abc DROP VALUE 'c'

-- Test 184: statement (line 698)
CREATE TYPE bar AS ENUM ('b', 'a', 'r')

-- Test 185: statement (line 701)
CREATE VIEW bar_view AS (SELECT ARRAY['b'::bar])

-- Test 186: statement (line 704)
ALTER TYPE bar DROP VALUE 'b'

-- Test 187: statement (line 713)
CREATE TYPE typ_110827 AS ENUM ('a', 'b', 'c');

-- Test 188: statement (line 716)
CREATE TABLE t_110827 (i typ_110827[]);

-- Test 189: statement (line 719)
INSERT INTO t_110827 VALUES (ARRAY['a', 'a', 'b']);

-- Test 190: statement (line 722)
ALTER TYPE typ_110827 DROP VALUE 'c';

-- Test 191: statement (line 725)
ALTER TYPE typ_110827 DROP VALUE 'a';

-- Test 192: statement (line 728)
ALTER TYPE typ_110827 DROP VALUE 'b';

-- Test 193: statement (line 738)
CREATE TYPE typ_127136 AS ENUM('a', 'b', 'c');
CREATE TABLE t_127136 (x INT PRIMARY KEY);
CREATE INDEX foo ON t_127136((x*10));
ALTER TABLE t_127136 ADD COLUMN y typ_127136;

-- Test 194: statement (line 744)
INSERT INTO t_127136 VALUES (1, 'a');

-- Test 195: statement (line 747)
ALTER TYPE typ_127136 DROP VALUE 'a';

-- Test 196: statement (line 756)
CREATE TYPE typ_127147 AS ENUM ('a', 'b', 'c');
CREATE TABLE t (x TEXT PRIMARY KEY, INDEX ((x::typ_127147)));
INSERT INTO t VALUES ('a');

-- Test 197: statement (line 761)
ALTER TYPE typ_127147 DROP VALUE 'a';

-- Test 198: statement (line 764)
ALTER TABLE t SET (schema_locked=false);

-- Test 199: statement (line 767)
TRUNCATE TABLE t;

-- Test 200: statement (line 770)
ALTER TABLE t RESET (schema_locked);

-- Test 201: statement (line 773)
ALTER TYPE typ_127147 DROP VALUE 'a';

