-- PostgreSQL compatible tests from schema
-- 309 tests

-- Test 1: statement (line 5)
CREATE SCHEMA IF NOT EXISTS public

-- Test 2: statement (line 8)
CREATE SCHEMA IF NOT EXISTS crdb_internal

-- Test 3: statement (line 11)
CREATE SCHEMA IF NOT EXISTS pg_catalog

-- Test 4: statement (line 14)
CREATE SCHEMA IF NOT EXISTS information_schema

-- Test 5: statement (line 17)
CREATE SCHEMA derp

-- Test 6: statement (line 20)
CREATE SCHEMA IF NOT EXISTS derp

-- Test 7: statement (line 23)
CREATE SCHEMA derp

-- Test 8: statement (line 26)
CREATE SCHEMA public

-- Test 9: statement (line 29)
CREATE SCHEMA crdb_internal

-- Test 10: statement (line 32)
CREATE SCHEMA pg_catalog

-- Test 11: statement (line 35)
CREATE SCHEMA information_schema

-- Test 12: statement (line 38)
CREATE SCHEMA pg_temp

-- Test 13: statement (line 41)
CREATE SCHEMA sc AUTHORIZATION bob

-- Test 14: statement (line 45)
CREATE SCHEMA myschema;
CREATE TABLE myschema.tb (x INT);
CREATE TYPE myschema.typ AS ENUM ('user', 'defined', 'schema');
CREATE VIEW myschema.v AS SELECT x FROM myschema.tb;
CREATE SEQUENCE myschema.s

-- Test 15: query (line 52)
SELECT
  database_name, parent_id, schema_name, parent_schema_id, name, table_id
FROM crdb_internal.tables
WHERE database_name = 'test'

-- Test 16: query (line 62)
SELECT * FROM myschema.tb

-- Test 17: query (line 66)
SELECT * FROM myschema.v

-- Test 18: query (line 70)
SELECT last_value FROM myschema.s

-- Test 19: query (line 75)
SELECT 'user'::myschema.typ, ARRAY['defined']::myschema._typ

-- Test 20: statement (line 81)
SET search_path TO myschema,public

-- Test 21: query (line 85)
SELECT * FROM tb

-- Test 22: query (line 89)
SELECT 'user'::typ, ARRAY['defined']::_typ

-- Test 23: statement (line 95)
CREATE TABLE tb2 (x typ)

-- Test 24: query (line 98)
SELECT * FROM tb2

-- Test 25: query (line 102)
SELECT * FROM myschema.tb2

-- Test 26: statement (line 107)
SET search_path TO public

-- Test 27: statement (line 111)
ALTER SCHEMA public OWNER TO testuser

-- Test 28: query (line 114)
SELECT schema_name, owner FROM [SHOW SCHEMAS] WHERE schema_name = 'public'

-- Test 29: statement (line 120)
CREATE TEMP TABLE myschema.tmp (x int)

-- Test 30: statement (line 124)
CREATE TABLE pg_catalog.bad (x int)

-- Test 31: statement (line 129)
ALTER SCHEMA public RENAME TO private

-- Test 32: statement (line 133)
ALTER SCHEMA pg_catalog RENAME TO mysql_catalog

-- Test 33: statement (line 136)
ALTER SCHEMA pg_catalog OWNER TO root

-- Test 34: statement (line 140)
ALTER SCHEMA myschema RENAME TO pg_temp_not_temp

-- Test 35: statement (line 144)
ALTER SCHEMA myschema RENAME TO public

-- Test 36: statement (line 147)
CREATE SCHEMA yourschema

-- Test 37: statement (line 150)
ALTER SCHEMA myschema RENAME TO yourschema

-- Test 38: statement (line 153)
ALTER SCHEMA myschema RENAME TO myschema2

-- Test 39: statement (line 156)
CREATE SCHEMA myschema2;
CREATE TABLE myschema2.tb2 (a INT PRIMARY KEY);

-- Test 40: statement (line 160)
ALTER SCHEMA myschema2 RENAME TO myschema3

-- Test 41: query (line 164)
SELECT * FROM myschema3.tb2

-- Test 42: statement (line 170)
SET autocommit_before_ddl = false

-- Test 43: statement (line 173)
CREATE SCHEMA myschema2

-- Test 44: statement (line 176)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 45: statement (line 179)
ALTER SCHEMA myschema2 RENAME TO another_schema

-- Test 46: statement (line 182)
ALTER SCHEMA another_schema RENAME TO another_one

-- Test 47: statement (line 185)
ROLLBACK

-- Test 48: statement (line 188)
RESET autocommit_before_ddl

-- Test 49: statement (line 192)
CREATE SCHEMA empty;
DROP SCHEMA empty

let $schema_id
SELECT id FROM system.namespace WHERE name = 'myschema2'

-- Test 50: statement (line 201)
CREATE TABLE myschema2.myschema_t1 (x INT);
CREATE TABLE myschema2.myschema_t2 (x INT);
CREATE SEQUENCE myschema2.myschema_seq1;
CREATE TABLE myschema2.myschema_t3 (x INT DEFAULT nextval('myschema2.myschema_seq1'));
CREATE TYPE myschema2.myschema_ty1 AS ENUM ('schema');
CREATE SCHEMA otherschema;
CREATE VIEW otherschema.otherschema_v1 AS SELECT x FROM myschema2.myschema_t1;
CREATE TABLE otherschema.otherschema_t1 (x INT);
CREATE SEQUENCE otherschema.otherschema_seq1 OWNED BY myschema2.myschema_t1.x;

-- Test 51: statement (line 212)
DROP SCHEMA myschema2

-- Test 52: statement (line 216)
DROP SCHEMA myschema2 CASCADE

-- Test 53: query (line 219)
SELECT table_name FROM [SHOW TABLES] WHERE table_name LIKE 'myschema2%' OR table_name LIKE 'otherschema%'

-- Test 54: query (line 224)
SELECT name FROM [SHOW ENUMS] WHERE name LIKE 'myschema2%'

-- Test 55: query (line 229)
SELECT id FROM system.namespace WHERE name = 'myschema2'

-- Test 56: query (line 233)
SELECT * FROM system.descriptor WHERE id = $schema_id

# We can't resolve a schema dropped in the same transaction.
statement ok
CREATE SCHEMA dropped

statement ok
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

statement ok
DROP SCHEMA dropped

statement error pq: cannot create "dropped.t" because the target database or schema does not exist
CREATE TABLE dropped.t (x INT)

statement ok
ROLLBACK

# Test that we can drop multiple schemas as part of a single DROP statement.
statement ok
CREATE SCHEMA scdrop1;
CREATE SCHEMA scdrop2;
CREATE SCHEMA scdrop3;
CREATE TABLE scdrop1.scdrop1_t1 (x INT);
CREATE TABLE scdrop1.scdrop1_t2 (x INT);
CREATE TABLE scdrop2.scdrop2_t1 (x INT);
CREATE VIEW scdrop2.scdrop2_v1 AS SELECT x FROM scdrop1.scdrop1_t1;
CREATE VIEW scdrop3.scdrop3_v1 AS SELECT x FROM scdrop2.scdrop2_v1;

statement ok
DROP SCHEMA scdrop1, scdrop2, scdrop3 CASCADE

query T
SELECT table_name FROM [SHOW TABLES] WHERE table_name LIKE 'scdrop%'

subtest create_schemas_with_database_prefixes

# Ensure that schemas can be created using with database prefixes
statement ok
CREATE DATABASE create_schemas;

statement ok
CREATE SCHEMA create_schemas.schema1;

statement ok
CREATE SCHEMA create_schemas.schema2 AUTHORIZATION root;

query T
SELECT catalog_name FROM create_schemas.information_schema.schemata WHERE schema_name = 'schema1';

-- Test 57: query (line 286)
SELECT catalog_name FROM create_schemas.information_schema.schemata WHERE schema_name = 'schema2';

-- Test 58: statement (line 291)
CREATE SCHEMA create_schemas.schema1;

-- Test 59: statement (line 294)
CREATE SCHEMA create_schemas.schema2 AUTHORIZATION root;

-- Test 60: statement (line 297)
CREATE SCHEMA IF NOT EXISTS create_schemas.schema1;

-- Test 61: statement (line 300)
CREATE SCHEMA IF NOT EXISTS create_schemas.schema2 AUTHORIZATION root;

-- Test 62: statement (line 303)
CREATE SCHEMA system.schema3;

-- Test 63: statement (line 309)
CREATE DATABASE scdrop4_db;

-- Test 64: statement (line 312)
CREATE DATABASE scdrop6_db;

-- Test 65: statement (line 315)
CREATE SCHEMA scdrop4_db.scdrop4;

-- Test 66: statement (line 318)
CREATE SCHEMA scdrop5;

-- Test 67: statement (line 321)
CREATE SCHEMA scdrop6_db.scdrop6;

-- Test 68: statement (line 324)
DROP SCHEMA scdrop4_db.scdrop4, scdrop5, scdrop6_db.scdrop6;

-- Test 69: statement (line 328)
CREATE SCHEMA scdrop4_db.scdrop4;
CREATE SCHEMA scdrop5;
CREATE SCHEMA scdrop6_db.scdrop6;
CREATE TABLE scdrop4_db.scdrop4.scdrop4_t1 (x INT);
CREATE TABLE scdrop5.scdrop5_t1 (x INT);
CREATE TABLE scdrop6_db.scdrop6.scdrop6_t1 (x INT);
CREATE VIEW scdrop4_db.scdrop4.scdrop4_v1 AS SELECT x FROM scdrop4_db.scdrop4.scdrop4_t1;
CREATE VIEW scdrop5.scdrop5_v1 AS SELECT x FROM scdrop5.scdrop5_t1;
CREATE VIEW scdrop6_db.scdrop6.scdrop6_v1 AS SELECT x FROM scdrop6_db.scdrop6.scdrop6_t1;

-- Test 70: statement (line 339)
DROP SCHEMA scdrop4_db.scdrop4, scdrop5, scdrop6_db.scdrop6 RESTRICT;

-- Test 71: statement (line 342)
DROP SCHEMA IF EXISTS scdrop4_db.scdrop4, scdrop5, scdrop6_db.scdrop6 CASCADE;

-- Test 72: statement (line 345)
DROP SCHEMA IF EXISTS scdrop4_db.scdrop4, scdrop5, scdrop6_db.scdrop6 CASCADE;

-- Test 73: statement (line 348)
DROP SCHEMA scdrop4_db.scdrop4, scdrop5, scdrop6_db.scdrop6 CASCADE;

-- Test 74: query (line 351)
SELECT schema_name FROM scdrop4_db.information_schema.schemata WHERE schema_name = 'scdrop4_db';

query T
SELECT table_name FROM [SHOW TABLES] WHERE table_name LIKE 'scdrop%'

subtest alter_schema_with_database_prefix

# We should be able to alter schemas in different databases
statement ok
CREATE DATABASE with_alter_schema;
CREATE ROLE jay;
CREATE SCHEMA with_alter_schema.schema_to_alter AUTHORIZATION jay;

statement ok
ALTER SCHEMA with_alter_schema.schema_to_alter RENAME TO altered_schema;

statement ok
ALTER SCHEMA with_alter_schema.altered_schema OWNER TO root;

statement ok
USE with_alter_schema

query T
SELECT owner from [SHOW SCHEMAS] WHERE schema_name = 'altered_schema';

-- Test 75: statement (line 379)
ALTER SCHEMA with_alter_schema.schema_to_alter RENAME TO altered_schema;

-- Test 76: statement (line 385)
CREATE DATABASE with_schemas;
USE with_schemas;
CREATE SCHEMA dropschema1;
CREATE SCHEMA dropschema2;
CREATE TABLE dropschema1.dropschema1_tb (x INT);
CREATE TYPE dropschema1.dropschema1_typ AS ENUM ('schema');
CREATE TABLE dropschema2.dropschema2_tb (y INT);
USE test

-- Test 77: statement (line 395)
DROP DATABASE with_schemas CASCADE

-- Test 78: query (line 400)
SELECT id FROM system.namespace WHERE name LIKE 'dropschema%'

# Test privilege interactions with schemas.
subtest privileges

# Have root create a schema.
statement ok
CREATE SCHEMA privs

statement ok
GRANT CREATE ON DATABASE test TO testuser

# Test user shouldn't be able to create in privs yet.
user testuser

statement error pq: user testuser does not have CREATE privilege on schema privs
CREATE TABLE privs.denied (x INT)

statement error pq: user testuser does not have CREATE privilege on schema privs
CREATE TYPE privs.denied AS ENUM ('denied')

user root

statement ok
GRANT CREATE ON SCHEMA privs TO testuser

statement ok
CREATE DATABASE db2; USE db2; CREATE SCHEMA privs; USE test

statement error target database or schema does not exist
SHOW GRANTS ON SCHEMA non_existent

query TTTT
SELECT database_name, schema_name, grantee, privilege_type FROM
[SHOW GRANTS ON SCHEMA privs]
ORDER BY database_name, schema_name, grantee

-- Test 79: statement (line 445)
CREATE TABLE privs.tbl (x INT)

-- Test 80: statement (line 448)
CREATE TYPE privs.typ AS ENUM ('allowed')

-- Test 81: statement (line 454)
REVOKE CREATE ON SCHEMA privs FROM testuser

user testuser

-- Test 82: statement (line 459)
CREATE TABLE privs.denied (x INT)

-- Test 83: statement (line 462)
CREATE TYPE privs.denied AS ENUM ('denied')

-- Test 84: statement (line 466)
ALTER SCHEMA privs RENAME TO denied

-- Test 85: statement (line 469)
DROP SCHEMA privs

-- Test 86: statement (line 476)
CREATE TABLE privs.usage_tbl (x INT);
CREATE TYPE privs.usage_typ AS ENUM ('usage');

user testuser

-- Test 87: statement (line 484)
SELECT * FROM privs.usage_tbl

-- Test 88: statement (line 487)
SELECT 'usage'::privs.usage_typ

-- Test 89: statement (line 490)
ALTER TABLE privs.usage_tbl ADD COLUMN y INT DEFAULT NULL

-- Test 90: statement (line 493)
CREATE INDEX ON privs.usage_tbl (x)

-- Test 91: statement (line 496)
COMMENT ON TABLE privs.usage_tbl IS 'foo'

-- Test 92: statement (line 499)
COMMENT ON COLUMN privs.usage_tbl.x IS 'foo'

-- Test 93: statement (line 502)
ALTER TYPE privs.usage_typ ADD VALUE 'denied'

-- Test 94: statement (line 509)
CREATE DATABASE otherdb;
CREATE SCHEMA otherdb.privs;
CREATE DATABASE otherdb2;
CREATE SCHEMA otherdb2.privs;

-- Test 95: statement (line 516)
GRANT CREATE ON SCHEMA privs, otherdb.privs, otherdb2.privs TO testuser;

user testuser

-- Test 96: statement (line 521)
CREATE TABLE test.privs.fail_tbl();

-- Test 97: statement (line 524)
CREATE TABLE otherdb.privs.fail_tbl();

-- Test 98: statement (line 527)
CREATE TABLE otherdb2.privs.fail_tbl();

-- Test 99: statement (line 533)
SET SESSION sql_safe_updates=false;

-- Test 100: statement (line 536)
USE ""

-- Test 101: query (line 539)
SELECT database_name, schema_name, grantee, privilege_type FROM
[SHOW GRANTS ON SCHEMA test.privs, otherdb.privs, otherdb2.privs]
WHERE grantee = 'testuser'
ORDER BY database_name, schema_name, grantee

-- Test 102: statement (line 549)
use test

-- Test 103: query (line 552)
SELECT database_name, schema_name, grantee, privilege_type FROM
[SHOW GRANTS ON SCHEMA privs, otherdb.privs, otherdb2.privs]
WHERE grantee = 'testuser'
ORDER BY database_name, schema_name, grantee

-- Test 104: statement (line 564)
REVOKE CREATE ON SCHEMA privs, otherdb.privs, otherdb2.privs FROM testuser;

user testuser

-- Test 105: statement (line 569)
CREATE TABLE test.privs.fail_tbl();

-- Test 106: statement (line 572)
CREATE TABLE otherdb.privs.fail_tbl();

-- Test 107: statement (line 575)
CREATE TABLE otherdb2.privs.fail_tbl();

-- Test 108: statement (line 584)
CREATE USER user1;

-- Test 109: statement (line 588)
CREATE SCHEMA AUTHORIZATION user1

-- Test 110: statement (line 591)
CREATE SCHEMA AUTHORIZATION typo

-- Test 111: statement (line 594)
CREATE SCHEMA AUTHORIZATION user1

-- Test 112: statement (line 597)
CREATE SCHEMA IF NOT EXISTS AUTHORIZATION user1

-- Test 113: statement (line 600)
CREATE SCHEMA user1_schema AUTHORIZATION user1

-- Test 114: query (line 604)
SELECT
  nspname, usename
FROM
  pg_catalog.pg_namespace
  LEFT JOIN pg_catalog.pg_user ON pg_namespace.nspowner = pg_user.usesysid
WHERE
  nspname LIKE 'user1%';

-- Test 115: statement (line 617)
CREATE DATABASE perms

user testuser

-- Test 116: statement (line 622)
USE perms

-- Test 117: statement (line 625)
CREATE SCHEMA test

user root

-- Test 118: statement (line 630)
GRANT CREATE ON DATABASE perms TO testuser

user testuser

-- Test 119: statement (line 635)
USE perms

-- Test 120: statement (line 638)
CREATE SCHEMA test

user root

-- Test 121: statement (line 643)
USE defaultdb

-- Test 122: statement (line 651)
CREATE DATABASE new_db

-- Test 123: statement (line 654)
USE new_db

-- Test 124: statement (line 657)
CREATE SCHEMA new_db.s1

user testuser

-- Test 125: statement (line 662)
USE new_db

-- Test 126: statement (line 666)
CREATE TABLE new_db.public.bar()

-- Test 127: statement (line 669)
CREATE TABLE new_db.s1.bar()

user root

-- Test 128: statement (line 674)
CREATE SCHEMA AUTHORIZATION testuser

user testuser

-- Test 129: statement (line 679)
CREATE TABLE new_db.s1.bar()

-- Test 130: statement (line 682)
CREATE TABLE new_db.testuser.bar()

-- Test 131: statement (line 687)
DROP SCHEMA testuser CASCADE

-- Test 132: statement (line 697)
CREATE SCHEMA testuser

-- Test 133: statement (line 700)
GRANT ALL ON SCHEMA testuser TO testuser

-- Test 134: statement (line 703)
CREATE TABLE public.public_table(a INT)

-- Test 135: statement (line 706)
GRANT SELECT ON public.public_table TO testuser

user testuser

-- Test 136: statement (line 711)
CREATE TABLE test_table(a INT);

-- Test 137: statement (line 714)
SELECT * FROM public.test_table

-- Test 138: statement (line 717)
SELECT * FROM testuser.test_table

-- Test 139: statement (line 723)
CREATE TABLE public.test_table(a INT, b INT)

-- Test 140: statement (line 726)
GRANT SELECT ON public.test_table TO testuser

user testuser

-- Test 141: query (line 731)
SELECT * FROM test_table

-- Test 142: query (line 736)
SELECT * FROM public.test_table

-- Test 143: query (line 741)
SELECT * FROM public_table

-- Test 144: query (line 749)
SELECT * FROM test_table

-- Test 145: query (line 754)
SELECT * FROM testuser.test_table

-- Test 146: statement (line 764)
CREATE SCHEMA sch;
CREATE TABLE sch.table_to_rename();
CREATE TABLE sch.table_exists();
CREATE TABLE public_table_to_rename();
CREATE TABLE public_table_exists();

-- Test 147: statement (line 771)
ALTER TABLE sch.table_to_rename RENAME TO renamed_table;

-- Test 148: statement (line 774)
ALTER TABLE sch.renamed_table RENAME TO sch.renamed_table_2;

-- Test 149: statement (line 777)
ALTER TABLE sch.renamed_table_2 RENAME TO sch.table_exists;

-- Test 150: statement (line 780)
ALTER TABLE public_table_to_rename RENAME TO public.renamed_public_table;

-- Test 151: statement (line 783)
ALTER TABLE renamed_public_table RENAME TO public_table_exists;

-- Test 152: statement (line 788)
CREATE DATABASE for_show;

-- Test 153: statement (line 791)
USE for_show;

-- Test 154: statement (line 794)
CREATE TABLE t1 (i INT PRIMARY KEY);

-- Test 155: statement (line 797)
CREATE SCHEMA sc1;

-- Test 156: statement (line 800)
CREATE TABLE sc1.t1 (i INT PRIMARY KEY);

-- Test 157: query (line 803)
SELECT schema_name, table_name FROM [SHOW TABLES]

-- Test 158: query (line 809)
SELECT schema_name, table_name FROM [SHOW TABLES FROM sc1]

-- Test 159: statement (line 814)
USE test

-- Test 160: query (line 817)
SELECT schema_name, table_name FROM [SHOW TABLES FROM for_show]

-- Test 161: query (line 823)
SELECT schema_name, table_name FROM [SHOW TABLES FROM for_show.sc1]

-- Test 162: statement (line 829)
CREATE SCHEMA sc2

-- Test 163: statement (line 832)
CREATE TYPE sc3 as enum('foo')

-- Test 164: statement (line 840)
CREATE DATABASE samename

-- Test 165: statement (line 843)
USE samename

-- Test 166: statement (line 846)
CREATE SCHEMA foo;
CREATE SCHEMA bar

-- Test 167: statement (line 850)
DROP SCHEMA foo

-- Test 168: statement (line 853)
CREATE SCHEMA samename

-- Test 169: statement (line 856)
DROP SCHEMA bar

-- Test 170: statement (line 859)
CREATE TABLE samename.samename.t (i INT PRIMARY KEY)

-- Test 171: statement (line 862)
SHOW TABLES

-- Test 172: statement (line 865)
DROP DATABASE samename CASCADE;

-- Test 173: statement (line 873)
CREATE DATABASE comment_db

-- Test 174: statement (line 876)
CREATE SCHEMA comment_db.foo

-- Test 175: statement (line 879)
COMMENT ON SCHEMA comment_db.foo IS 'foo'

-- Test 176: query (line 882)
SELECT comment FROM system.comments LIMIT 1

-- Test 177: statement (line 887)
USE comment_db

-- Test 178: statement (line 890)
COMMENT ON SCHEMA foo IS 'bar'

-- Test 179: query (line 893)
SELECT comment FROM system.comments LIMIT 1

-- Test 180: statement (line 898)
DROP SCHEMA foo

-- Test 181: query (line 901)
SELECT comment FROM system.comments LIMIT 1

-- Test 182: statement (line 905)
DROP DATABASE comment_db

-- Test 183: statement (line 908)
USE test

-- Test 184: statement (line 915)
SET CLUSTER SETTING server.eventlog.enabled = false

-- Test 185: statement (line 918)
CREATE SCHEMA sc

-- Test 186: statement (line 921)
DROP SCHEMA sc

-- Test 187: statement (line 924)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE SCHEMA sc;
COMMIT

-- Test 188: statement (line 929)
DROP SCHEMA sc

-- Test 189: statement (line 932)
SET CLUSTER SETTING server.eventlog.enabled = false

-- Test 190: statement (line 938)
CREATE SCHEMA sc;
CREATE TABLE sc.xy (x INT, y INT);
INSERT INTO sc.xy VALUES (1, 1);

-- Test 191: query (line 943)
SELECT * FROM sc.xy;

-- Test 192: statement (line 948)
ALTER SCHEMA sc RENAME TO sc1;

-- Test 193: query (line 951)
SELECT * FROM sc.xy;

query II
SELECT * FROM sc1.xy;

-- Test 194: statement (line 959)
DROP SCHEMA sc1 CASCADE;

-- Test 195: statement (line 963)
CREATE DATABASE d;
USE d;
CREATE TABLE d.xy (x INT, y INT);
INSERT INTO d.xy VALUES (1, 1);

-- Test 196: query (line 969)
SELECT * FROM d.xy;

-- Test 197: statement (line 974)
ALTER DATABASE d RENAME TO d1;
USE d1;

-- Test 198: query (line 978)
SELECT * FROM d.xy;

query II
SELECT * FROM d1.xy;

-- Test 199: statement (line 986)
USE test;

-- Test 200: statement (line 989)
DROP DATABASE d1 CASCADE;

-- Test 201: statement (line 994)
CREATE TABLE xy (x INT, y INT);
INSERT INTO xy VALUES (1, 1);

-- Test 202: query (line 998)
SELECT * FROM xy;

-- Test 203: statement (line 1003)
CREATE DATABASE d;
USE d;

-- Test 204: query (line 1007)
SELECT * FROM xy;

statement ok
USE test;

statement ok
DROP DATABASE d;
DROP TABLE xy;

# Regression tests for #96674.
subtest alter_udt_schema

# Renaming the schema should invalidate a schema-qualified UDT reference.
statement ok
CREATE SCHEMA sc;
CREATE TYPE sc.t AS ENUM ('HELLO');

query T
SELECT 'HELLO'::sc.t;

-- Test 205: statement (line 1030)
ALTER SCHEMA sc RENAME TO sc1;

-- Test 206: query (line 1033)
SELECT 'HELLO'::sc.t;

query T
SELECT 'HELLO'::sc1.t;

-- Test 207: statement (line 1041)
DROP SCHEMA sc1 CASCADE;

-- Test 208: statement (line 1045)
CREATE DATABASE d;
USE d;
CREATE TYPE d.t AS ENUM ('HELLO');

-- Test 209: query (line 1050)
SELECT 'HELLO'::d.t;

-- Test 210: statement (line 1055)
ALTER DATABASE d RENAME TO d1;
USE d1;

-- Test 211: query (line 1059)
SELECT 'HELLO'::d.t;

query T
SELECT 'HELLO'::d1.t;

-- Test 212: statement (line 1067)
USE test;

-- Test 213: statement (line 1070)
DROP DATABASE d1 CASCADE;

-- Test 214: statement (line 1074)
CREATE TYPE t AS ENUM ('HELLO');

-- Test 215: query (line 1077)
SELECT 'HELLO'::t;

-- Test 216: statement (line 1082)
CREATE DATABASE d;
USE d;

-- Test 217: query (line 1086)
SELECT 'HELLO'::t;

statement ok
USE test;

statement ok
DROP DATABASE d;
DROP TYPE t;

subtest alter_udf_schema

# Renaming the schema should invalidate a schema-qualified UDF reference.
statement ok
CREATE SCHEMA sc;
CREATE FUNCTION sc.fn(INT) RETURNS INT LANGUAGE SQL AS 'SELECT $1';

query I
SELECT sc.fn(1);

-- Test 218: statement (line 1108)
ALTER SCHEMA sc RENAME TO sc1;

-- Test 219: query (line 1111)
SELECT sc.fn(1);

query I
SELECT sc1.fn(1);

-- Test 220: statement (line 1119)
DROP SCHEMA sc1 CASCADE;

-- Test 221: statement (line 1123)
CREATE DATABASE d;
USE d;
CREATE FUNCTION fn(INT) RETURNS INT LANGUAGE SQL AS 'SELECT $1';

-- Test 222: query (line 1128)
SELECT d.public.fn(1);

-- Test 223: statement (line 1133)
ALTER DATABASE d RENAME TO d1;
USE d1;

-- Test 224: query (line 1137)
SELECT d.public.fn(1);

query I
SELECT d1.public.fn(1);

-- Test 225: statement (line 1145)
USE test;

-- Test 226: statement (line 1148)
DROP DATABASE d1 CASCADE;

-- Test 227: statement (line 1152)
CREATE FUNCTION fn(INT) RETURNS INT LANGUAGE SQL AS 'SELECT $1';

-- Test 228: query (line 1155)
SELECT fn(1);

-- Test 229: statement (line 1160)
CREATE DATABASE d;
USE d;

-- Test 230: query (line 1164)
SELECT fn(1);

statement ok
USE test;

statement ok
DROP DATABASE d;
DROP FUNCTION fn;

# Regression test for #97757 - invalidate the query cache after changes to the
# search path cause a function call to resolve to a UDF when it previously
# resolved to a builtin function.
subtest invalidate-builtin

statement ok
CREATE FUNCTION public.abs(val INT) RETURNS INT CALLED ON NULL INPUT LANGUAGE SQL AS $$ SELECT val+100 $$;

query I
SELECT abs(1);

-- Test 231: statement (line 1187)
SET search_path = public, pg_catalog;

-- Test 232: query (line 1191)
SELECT abs(1);

-- Test 233: statement (line 1196)
RESET search_path;

-- Test 234: query (line 1200)
SELECT abs(1);

-- Test 235: statement (line 1208)
SET search_path = public,      a,     "   b  ",   c

-- Test 236: query (line 1211)
SHOW search_path

-- Test 237: statement (line 1218)
SET search_path = '$user', 'public'

-- Test 238: query (line 1221)
SHOW search_path

-- Test 239: statement (line 1228)
SET search_path = '$user, public'

-- Test 240: query (line 1231)
SHOW search_path

-- Test 241: statement (line 1237)
SET search_path = 'Abc', 'public'

-- Test 242: query (line 1240)
SHOW search_path

-- Test 243: statement (line 1246)
SET search_path = Abc, 'public'

-- Test 244: query (line 1249)
SHOW search_path

-- Test 245: statement (line 1255)
SET search_path = ''

-- Test 246: query (line 1258)
SHOW search_path

-- Test 247: statement (line 1264)
SET search_path = ""

-- Test 248: query (line 1267)
SHOW search_path

-- Test 249: statement (line 1273)
SET search_path = "  ", abc

-- Test 250: query (line 1276)
SHOW search_path

-- Test 251: statement (line 1282)
SET search_path = 'a\bc', "d\ef", 'g-hi', "j-kl"

-- Test 252: query (line 1285)
SHOW search_path

-- Test 253: statement (line 1290)
SET search_path = abc, def,

-- Test 254: statement (line 1301)
RESET search_path;

-- Test 255: statement (line 1304)
CREATE DATABASE testdb1;
USE testdb1;
CREATE TABLE ab (a INT PRIMARY KEY, b INT);
INSERT INTO ab VALUES (1, 1);
CREATE TABLE xy (x INT, y INT, FOREIGN KEY (x) REFERENCES ab(a));
GRANT ALL ON xy TO testuser;
GRANT ALL ON ab TO testuser;

-- Test 256: statement (line 1313)
CREATE DATABASE testdb2;
USE testdb2;
CREATE TABLE ab (a INT PRIMARY KEY, b INT);
INSERT INTO ab VALUES (1, 1);
CREATE TABLE xy (x INT, y INT, FOREIGN KEY (x) REFERENCES ab(a));
CREATE USER testuser2;
GRANT ALL ON xy TO testuser2;
GRANT ALL ON ab TO testuser2;

user testuser

-- Test 257: statement (line 1325)
USE testdb1

-- Test 258: statement (line 1328)
INSERT into xy VALUES(1, 1)

user testuser2

-- Test 259: statement (line 1333)
USE testdb2

-- Test 260: statement (line 1336)
INSERT into xy VALUES(1, 1)

-- Test 261: statement (line 1339)
INSERT into xy VALUES(1, 1)

user testuser

-- Test 262: statement (line 1344)
USE testdb1

-- Test 263: statement (line 1347)
INSERT into xy VALUES(1, 1)

user root

-- Test 264: statement (line 1352)
USE test;

-- Test 265: statement (line 1355)
REVOKE ALL ON testdb2.xy FROM testuser2;
REVOKE ALL ON testdb2.ab FROM testuser2;
DROP USER testuser2;
DROP DATABASE testdb1 CASCADE;
DROP DATABASE testdb2 CASCADE;

-- Test 266: statement (line 1366)
CREATE DATABASE should_have_create

-- Test 267: statement (line 1369)
USE should_have_create

-- Test 268: query (line 1372)
SELECT database_name, schema_name, grantee, privilege_type FROM [SHOW GRANTS ON SCHEMA public] WHERE grantee = 'public'

-- Test 269: statement (line 1378)
SET CLUSTER SETTING sql.auth.public_schema_create_privilege.enabled = false

-- Test 270: statement (line 1381)
CREATE DATABASE should_not_have_create

-- Test 271: statement (line 1384)
USE should_not_have_create

-- Test 272: query (line 1387)
SELECT database_name, schema_name, grantee, privilege_type FROM [SHOW GRANTS ON SCHEMA public] WHERE grantee = 'public'

-- Test 273: statement (line 1392)
RESET CLUSTER SETTING sql.auth.public_schema_create_privilege.enabled

-- Test 274: statement (line 1400)
CREATE SCHEMA my_pg_temp_123_123;

-- Test 275: statement (line 1403)
DROP SCHEMA  my_pg_temp_123_123;

-- Test 276: statement (line 1412)
create database foo;

-- Test 277: statement (line 1415)
create database bar;

-- Test 278: statement (line 1418)
create user foo_user;

-- Test 279: statement (line 1421)
create user bar_user;

-- Test 280: statement (line 1424)
create ROLE foo_role;

-- Test 281: statement (line 1427)
create ROLE bar_role;

-- Test 282: statement (line 1430)
use foo;

-- Test 283: statement (line 1433)
CREATE TABLE baz (
  id   int NOT NULL,
  name varchar NOT NULL,
  PRIMARY KEY (id)
);

-- Test 284: statement (line 1440)
CREATE FUNCTION qux() RETURNS void LANGUAGE SQL AS $$
    SELECT * FROM baz;
$$;

-- Test 285: statement (line 1445)
ALTER TABLE baz OWNER TO foo_role;

-- Test 286: statement (line 1448)
use bar;

-- Test 287: statement (line 1451)
CREATE TABLE baz (
  id   int NOT NULL,
  name varchar NOT NULL,
  PRIMARY KEY (id)
);

-- Test 288: statement (line 1458)
CREATE FUNCTION qux() RETURNS void LANGUAGE SQL AS $$
    SELECT * FROM baz;
$$;

-- Test 289: statement (line 1463)
ALTER TABLE baz OWNER TO bar_role;

-- Test 290: statement (line 1466)
GRANT foo_role TO foo_user;

-- Test 291: statement (line 1469)
GRANT bar_role TO bar_user;

-- Test 292: statement (line 1472)
use foo;
set role foo_user;

-- Test 293: query (line 1476)
select * from baz;

-- Test 294: query (line 1480)
SELECT qux();

-- Test 295: statement (line 1485)
use bar;
set role bar_user;

-- Test 296: query (line 1489)
select * from baz;

-- Test 297: query (line 1493)
SELECT qux();

-- Test 298: statement (line 1504)
set role root;
use defaultdb;

skipif config local-legacy-schema-changer

-- Test 299: statement (line 1509)
CREATE SCHEMA ""."";

onlyif config local-legacy-schema-changer

-- Test 300: statement (line 1513)
CREATE SCHEMA ""."";

-- Test 301: statement (line 1516)
CREATE SCHEMA "";

-- Test 302: statement (line 1526)
CREATE SCHEMA drop_schema_with_triggers;

-- Test 303: statement (line 1529)
CREATE TYPE drop_schema_with_triggers.typ_1 AS ENUM ('foo');

-- Test 304: statement (line 1532)
CREATE TYPE typ_2_drop_schema_with_triggers AS ENUM ('foo');

-- Test 305: statement (line 1535)
CREATE TABLE drop_schema_with_triggers.t1 (
	n INT8 PRIMARY KEY, j INT8 UNIQUE
);

-- Test 306: statement (line 1540)
CREATE TABLE t2_drop_schema_with_triggers (
	n
		INT8 PRIMARY KEY,
	j
		INT8 REFERENCES drop_schema_with_triggers.t1 (j)
);

-- Test 307: statement (line 1548)
CREATE FUNCTION drop_schema_with_triggers.trigger_function_w4_520()
	RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$ BEGIN SELECT 'foo'::drop_schema_with_triggers.typ_1, 'foo'::public.typ_2_drop_schema_with_triggers FROM drop_schema_with_triggers.t1;RETURN NEW;END; $$;

skipif config local-legacy-schema-changer

-- Test 308: statement (line 1555)
CREATE TRIGGER trigger_w4_521 BEFORE UPDATE OR DELETE ON drop_schema_with_triggers.t1 FOR EACH ROW EXECUTE FUNCTION drop_schema_with_triggers.trigger_function_w4_520();

skipif config local-legacy-schema-changer

-- Test 309: statement (line 1559)
DROP SCHEMA drop_schema_with_triggers CASCADE;

