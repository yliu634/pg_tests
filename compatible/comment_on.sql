-- PostgreSQL compatible tests from comment_on
-- 88 tests

-- Test 1: statement (line 3)
CREATE DATABASE db

-- Test 2: statement (line 6)
COMMENT ON DATABASE db IS 'A'

-- Test 3: query (line 9)
SHOW DATABASES WITH COMMENT

-- Test 4: statement (line 19)
COMMENT ON DATABASE db IS 'AAA'

-- Test 5: query (line 22)
SHOW DATABASES WITH COMMENT

-- Test 6: statement (line 32)
COMMENT ON DATABASE db IS NULL;

-- Test 7: query (line 35)
SHOW DATABASES WITH COMMENT

-- Test 8: statement (line 45)
CREATE SCHEMA sc

-- Test 9: statement (line 48)
COMMENT ON SCHEMA sc IS 'SC'

-- Test 10: query (line 51)
SELECT COMMENT FROM system.comments WHERE type = 4;

-- Test 11: statement (line 56)
COMMENT ON SCHEMA sc IS 'SC_AGAIN'

-- Test 12: query (line 59)
SELECT COMMENT FROM system.comments WHERE type = 4;

-- Test 13: query (line 64)
SHOW SCHEMAS WITH COMMENT

-- Test 14: statement (line 75)
CREATE SCHEMA db.schema1

-- Test 15: statement (line 78)
COMMENT ON SCHEMA db.schema1 IS 'Database_Schema'

-- Test 16: query (line 81)
SHOW SCHEMAS FROM db WITH COMMENT

-- Test 17: statement (line 92)
CREATE TABLE t(
  a INT PRIMARY KEY,
  b INT NOT NULL,
  CONSTRAINT ckb CHECK (b > 1),
  INDEX idxb (b),
  FAMILY fam_0_b_a (a, b)
);

-- Test 18: statement (line 101)
COMMENT ON TABLE t IS 'table t';

onlyif config schema-locked-disabled

-- Test 19: query (line 105)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 20: query (line 119)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 21: statement (line 132)
COMMENT ON TABLE t IS 'table t AGAIN';

onlyif config schema-locked-disabled

-- Test 22: query (line 136)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 23: query (line 150)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 24: statement (line 163)
COMMENT ON TABLE t IS NULL;

onlyif config schema-locked-disabled

-- Test 25: query (line 167)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 26: query (line 180)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 27: statement (line 192)
COMMENT ON COLUMN t.b IS 'column b';

onlyif config schema-locked-disabled

-- Test 28: query (line 196)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 29: query (line 210)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 30: statement (line 223)
COMMENT ON COLUMN t.b IS 'column b AGAIN';

-- Test 31: statement (line 226)
COMMENT ON COLUMN b IS 'unqualified column b';

onlyif config schema-locked-disabled

-- Test 32: query (line 230)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 33: query (line 244)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 34: statement (line 257)
COMMENT ON COLUMN t.b IS NULL;

onlyif config schema-locked-disabled

-- Test 35: query (line 261)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 36: query (line 274)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 37: statement (line 286)
COMMENT ON INDEX t@idxb IS 'index b';

onlyif config schema-locked-disabled

-- Test 38: query (line 290)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 39: query (line 304)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 40: statement (line 317)
COMMENT ON INDEX t@idxb IS 'index b AGAIN';

onlyif config schema-locked-disabled

-- Test 41: query (line 321)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 42: query (line 335)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 43: statement (line 348)
COMMENT ON INDEX t@idxb IS NULL;

onlyif config schema-locked-disabled

-- Test 44: query (line 352)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 45: query (line 365)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 46: statement (line 377)
COMMENT ON CONSTRAINT ckb ON t IS 'cst b';

onlyif config schema-locked-disabled

-- Test 47: query (line 381)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 48: query (line 395)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 49: statement (line 408)
COMMENT ON CONSTRAINT ckb ON t IS 'cst b AGAIN';

onlyif config schema-locked-disabled

-- Test 50: query (line 412)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 51: query (line 426)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 52: statement (line 439)
COMMENT ON CONSTRAINT ckb ON t IS NULL;

onlyif config schema-locked-disabled

-- Test 53: query (line 443)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 54: query (line 456)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 55: statement (line 471)
CREATE TABLE t_99316(a INT);

-- Test 56: statement (line 474)
INSERT INTO system.comments VALUES (4294967122, 't_99316'::regclass::OID, 0, 'bar');

-- Test 57: statement (line 478)
SELECT * FROM pg_catalog.pg_description WHERE objoid = 't'::regclass::OID;

-- Test 58: query (line 482)
SELECT * FROM crdb_internal.invalid_objects ORDER BY id;

-- Test 59: statement (line 487)
DELETE FROM system.comments WHERE type = 4294967122

-- Test 60: statement (line 490)
COMMENT ON SCHEMA sc IS NULL

-- Test 61: statement (line 493)
CREATE TYPE roach_dwellings AS ENUM ('roach_motel','roach_kitchen','roach_bathroom','roach_house');
CREATE TYPE roach_legs AS (legs INT);

onlyif config local-legacy-schema-changer

-- Test 62: statement (line 498)
COMMENT ON TYPE roach_dwellings IS 'First-CRDB-comment-on-types';

skipif config local-legacy-schema-changer

-- Test 63: statement (line 502)
COMMENT ON TYPE roach_dwellings IS 'First-CRDB-comment-on-types';

skipif config local-legacy-schema-changer

-- Test 64: statement (line 506)
COMMENT ON TYPE roach_legs IS 'Second-CRDB-comment-on-types';

skipif config local-legacy-schema-changer

-- Test 65: statement (line 510)
COMMENT ON TYPE roach_dwellings IS 'First-CRDB-comment-on-types-again';

skipif config local-legacy-schema-changer

-- Test 66: statement (line 514)
COMMENT ON TYPE roach_legs IS 'Second-CRDB-comment-on-types-again';

skipif config local-legacy-schema-changer

-- Test 67: query (line 518)
SELECT * FROM SYSTEM.COMMENTS;

-- Test 68: query (line 527)
SHOW TYPES WITH COMMENT

-- Test 69: statement (line 535)
COMMENT ON TYPE roach_dwellings IS NULL;

skipif config local-legacy-schema-changer

-- Test 70: statement (line 539)
COMMENT ON TYPE roach_legs IS NULL;

skipif config local-legacy-schema-changer

-- Test 71: query (line 543)
SHOW TYPES WITH COMMENT

-- Test 72: query (line 551)
SELECT * FROM SYSTEM.COMMENTS;

-- Test 73: statement (line 560)
INSERT INTO system.comments VALUES (32, 11111, 0, 'abc');
INSERT INTO system.comments VALUES (32, 1, 0, 'abc');

-- Test 74: statement (line 566)
SELECT count(*) FROM pg_catalog.pg_description

-- Test 75: query (line 569)
SELECT * FROM crdb_internal.invalid_objects ORDER BY id;

-- Test 76: statement (line 575)
DELETE FROM system.comments WHERE type=32;

-- Test 77: query (line 578)
SELECT * FROM crdb_internal.invalid_objects ORDER BY id;

-- Test 78: statement (line 589)
CREATE DATABASE test_db

-- Test 79: statement (line 592)
USE test_db

-- Test 80: statement (line 595)
CREATE TYPE roach_type AS ENUM ('option1', 'option2')

-- Test 81: statement (line 600)
COMMENT ON TYPE roach_type IS 'This is a test comment on a type'

skipif config local-legacy-schema-changer

-- Test 82: query (line 604)
SHOW TYPES WITH COMMENT

-- Test 83: statement (line 611)
USE defaultdb

let $schema_changer_state
SHOW use_declarative_schema_changer

-- Test 84: statement (line 617)
SET use_declarative_schema_changer = 'off'

-- Test 85: statement (line 620)
DROP DATABASE test_db CASCADE

-- Test 86: statement (line 624)
SET use_declarative_schema_changer = $schema_changer_state

-- Test 87: query (line 630)
SELECT id, database_name, schema_name, obj_name, error FROM "".crdb_internal.invalid_objects

-- Test 88: query (line 635)
SELECT database_name FROM [SHOW DATABASES] WHERE database_name = 'test_db'

