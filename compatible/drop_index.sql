-- PostgreSQL compatible tests from drop_index
-- 119 tests

-- Test 1: statement (line 1)
CREATE TABLE users (
  id    INT PRIMARY KEY,
  name  VARCHAR NOT NULL,
  title VARCHAR,
  INDEX foo (name),
  UNIQUE INDEX bar (id, name),
  INDEX baw (name, title)
)

-- Test 2: statement (line 11)
CREATE TABLE othertable (
   x INT,
   y INT,
   INDEX baw (x),
   INDEX yak (y, x)
)

-- Test 3: statement (line 19)
DROP INDEX baw

-- Test 4: statement (line 22)
DROP INDEX IF EXISTS baw

-- Test 5: statement (line 25)
DROP INDEX ark

-- Test 6: statement (line 28)
DROP INDEX IF EXISTS ark

-- Test 7: statement (line 31)
DROP INDEX users@ark

-- Test 8: statement (line 34)
DROP INDEX IF EXISTS users@ark

-- Test 9: statement (line 37)
DROP INDEX yak

-- Test 10: statement (line 40)
CREATE INDEX yak ON othertable (y, x)

-- Test 11: statement (line 43)
DROP INDEX IF EXISTS yak

-- Test 12: statement (line 46)
DROP TABLE othertable

-- Test 13: statement (line 49)
DROP INDEX baw

-- Test 14: statement (line 52)
INSERT INTO users VALUES (1, 'tom', 'cat'),(2, 'jerry', 'rat')

-- Test 15: query (line 55)
SHOW INDEXES FROM users

-- Test 16: statement (line 67)
DROP INDEX users@zap

-- Test 17: statement (line 70)
DROP INDEX IF EXISTS users@zap

-- Test 18: query (line 73)
SHOW INDEXES FROM users

-- Test 19: statement (line 87)
DROP INDEX IF EXISTS users@foo, users@zap

-- Test 20: query (line 90)
SHOW INDEXES FROM users

-- Test 21: statement (line 103)
DROP INDEX users@bar

onlyif config local-legacy-schema-changer

-- Test 22: statement (line 107)
DROP INDEX users@bar

user root

-- Test 23: statement (line 112)
GRANT CREATE ON TABLE users TO testuser

user testuser

-- Test 24: statement (line 117)
DROP INDEX users@bar

-- Test 25: statement (line 120)
DROP INDEX users@bar RESTRICT

-- Test 26: statement (line 123)
DROP INDEX users@bar CASCADE

-- Test 27: query (line 126)
SHOW INDEXES FROM users

-- Test 28: query (line 136)
SELECT * FROM users

-- Test 29: statement (line 142)
CREATE INDEX foo ON users (name)

-- Test 30: statement (line 145)
CREATE INDEX bar ON users (title)

-- Test 31: statement (line 148)
CREATE INDEX baz ON users (name, title)

-- Test 32: statement (line 151)
DROP INDEX IF EXISTS users@invalid, users@baz

-- Test 33: query (line 154)
SHOW INDEXES FROM users

-- Test 34: statement (line 169)
DROP INDEX users@foo

-- Test 35: statement (line 172)
DROP INDEX users@bar

-- Test 36: query (line 175)
SHOW INDEXES FROM users

-- Test 37: statement (line 185)
CREATE VIEW v2 AS SELECT name FROM v

-- Test 38: query (line 188)
SHOW TABLES

-- Test 39: statement (line 195)
GRANT ALL ON users to testuser

-- Test 40: statement (line 198)
GRANT ALL ON v to testuser

user testuser

-- Test 41: statement (line 203)
DROP INDEX users@foo CASCADE

user root

-- Test 42: statement (line 208)
DROP INDEX users@foo CASCADE

-- Test 43: query (line 211)
SHOW INDEXES FROM users

-- Test 44: query (line 219)
SHOW TABLES

-- Test 45: statement (line 228)
CREATE INDEX expr_idx ON tbl(lower(c));

-- Test 46: statement (line 231)
DROP INDEX expr_idx;

-- Test 47: query (line 234)
SELECT description FROM crdb_internal.jobs ORDER BY created DESC LIMIT 2;

-- Test 48: statement (line 243)
CREATE INDEX baz ON users (name)

-- Test 49: statement (line 248)
DROP INDEX IF EXISTS baz, zap

-- Test 50: query (line 251)
SHOW INDEXES FROM users

-- Test 51: statement (line 261)
DROP INDEX IF EXISTS baz

-- Test 52: statement (line 266)
CREATE DATABASE view_test

-- Test 53: statement (line 269)
SET DATABASE = view_test

-- Test 54: statement (line 272)
CREATE TABLE t (id INT)

-- Test 55: statement (line 275)
CREATE VIEW v AS SELECT id FROM t

-- Test 56: statement (line 278)
DROP INDEX nonexistent_index

-- Test 57: statement (line 281)
CREATE DATABASE sequence_test

-- Test 58: statement (line 284)
SET DATABASE = sequence_test

-- Test 59: statement (line 287)
CREATE SEQUENCE s

-- Test 60: statement (line 290)
DROP INDEX nonexistent_index

-- Test 61: statement (line 293)
CREATE TABLE tu (a INT UNIQUE)

-- Test 62: statement (line 296)
CREATE UNIQUE INDEX tu_a ON tu(a)

-- Test 63: statement (line 299)
DROP INDEX tu_a_key

-- Test 64: statement (line 302)
DROP INDEX tu_a

-- Test 65: statement (line 310)
CREATE TABLE fk1 (x int);

-- Test 66: statement (line 313)
CREATE TABLE fk2 (x int PRIMARY KEY);

-- Test 67: statement (line 316)
CREATE INDEX i ON fk1 (x);

-- Test 68: statement (line 319)
CREATE INDEX i2 ON fk1 (x);

-- Test 69: statement (line 322)
ALTER TABLE fk1 ADD CONSTRAINT fk1 FOREIGN KEY (x) REFERENCES fk2 (x);

-- Test 70: statement (line 325)
DROP INDEX fk1@i CASCADE

onlyif config schema-locked-disabled

-- Test 71: query (line 329)
SHOW CREATE fk1

-- Test 72: query (line 341)
SHOW CREATE fk1

-- Test 73: statement (line 355)
CREATE TABLE drop_index_test(a int);
CREATE INDEX drop_index_test_index ON drop_index_test(a);

-- Test 74: query (line 361)
DROP INDEX drop_index_test_index

-- Test 75: statement (line 370)
CREATE TABLE t (a INT PRIMARY KEY, b DECIMAL(10,1) NOT NULL DEFAULT(0), UNIQUE INDEX t_secondary (b), FAMILY (a, b));
INSERT INTO t VALUES (100, 500.5);

-- Test 76: statement (line 374)
SET autocommit_before_ddl = false;

skipif config schema-locked-disabled

-- Test 77: statement (line 378)
ALTER TABLE t SET (schema_locked=false)

-- Test 78: statement (line 381)
BEGIN;
DROP INDEX t_secondary CASCADE;
ALTER TABLE t DROP COLUMN b;
INSERT INTO t SELECT a + 1 FROM t;

skipif config #112488 weak-iso-level-configs

-- Test 79: statement (line 388)
UPSERT INTO t SELECT a + 1 FROM t;

-- Test 80: statement (line 391)
COMMIT;

-- Test 81: statement (line 394)
RESET autocommit_before_ddl

skipif config schema-locked-disabled

-- Test 82: statement (line 398)
ALTER TABLE t SET (schema_locked=true)

-- Test 83: statement (line 404)
CREATE TABLE drop_primary(); DROP INDEX drop_primary@drop_primary_pkey CASCADE;

-- Test 84: statement (line 417)
CREATE TABLE t2_96731(i INT PRIMARY KEY, j INT);

-- Test 85: statement (line 420)
CREATE UNIQUE INDEX t2_96731_idx ON t2_96731(j);

-- Test 86: statement (line 423)
CREATE TABLE t1_96731(i INT PRIMARY KEY, j INT REFERENCES t2_96731(j));

-- Test 87: statement (line 426)
DROP INDEX t2_96731_idx;

-- Test 88: statement (line 431)
CREATE UNIQUE INDEX t2_96731_idx2 ON t2_96731(j);

-- Test 89: statement (line 434)
DROP INDEX t2_96731_idx CASCADE;

-- Test 90: query (line 437)
SELECT * FROM [SHOW CONSTRAINTS FROM t1_96731] ORDER BY constraint_name

-- Test 91: statement (line 445)
DROP INDEX t2_96731_idx2 CASCADE;

-- Test 92: query (line 448)
SHOW CONSTRAINTS FROM t1_96731;

-- Test 93: statement (line 455)
CREATE UNIQUE INDEX t2_96731_idx ON t2_96731(j);

-- Test 94: statement (line 458)
ALTER TABLE t1_96731 ADD FOREIGN KEY (j) REFERENCES t2_96731(j);

-- Test 95: statement (line 466)
ALTER TABLE t2_96731 ADD CONSTRAINT unique_j UNIQUE WITHOUT INDEX (j);

-- Test 96: statement (line 469)
DROP INDEX t2_96731_idx CASCADE;

-- Test 97: query (line 472)
SELECT * FROM [SHOW CONSTRAINTS FROM t1_96731] ORDER BY constraint_name

-- Test 98: statement (line 481)
CREATE UNIQUE INDEX t2_96731_idx ON t2_96731(j);

-- Test 99: statement (line 484)
ALTER TABLE t2_96731 DROP CONSTRAINT unique_j

-- Test 100: statement (line 487)
ALTER TABLE t2_96731 ADD CONSTRAINT unique_i UNIQUE WITHOUT INDEX (i);

-- Test 101: statement (line 491)
DROP INDEX t2_96731_idx CASCADE;

-- Test 102: query (line 494)
SHOW CONSTRAINTS FROM t1_96731;

-- Test 103: statement (line 500)
DROP TABLE t1_96731, t2_96731;

-- Test 104: statement (line 511)
CREATE TABLE fk_drop_target
 ( k int primary key,
   j int);
CREATE TABLE fk_drop_ref_src(
  k int,
  j int primary key);
CREATE UNIQUE INDEX target_j
     ON fk_drop_target(j);
 CREATE TABLE fk_ref_dst(
  k int primary key,
  j int,
  m int,
   CONSTRAINT "j_fk" FOREIGN KEY (j) REFERENCES
       fk_drop_target(k),
   CONSTRAINT m_fk   FOREIGN KEY (m) REFERENCES
        fk_drop_ref_src(j)
 );

-- Test 105: statement (line 530)
DROP INDEX fk_drop_target@target_j CASCADE;

-- Test 106: query (line 533)
SELECT constraint_name from [SHOW CONSTRAINTS FROM fk_ref_dst];

-- Test 107: statement (line 548)
DROP INDEX IF EXISTS roaches@roaches_value_idx;

-- Test 108: statement (line 551)
SET sql_safe_updates = false;

-- Test 109: statement (line 556)
CREATE TABLE tab_145100 (
  id UUID PRIMARY KEY,
  i INT NOT NULL,
  j int not null,
  INDEX (i ASC) USING HASH,
  FAMILY (id, i, j)
)

-- Test 110: statement (line 565)
CREATE PROCEDURE proc_select_145100() LANGUAGE SQL AS $$
  SELECT *, crdb_internal_i_shard_16 FROM tab_145100;
$$;

-- Test 111: statement (line 570)
DROP INDEX tab_145100@tab_145100_i_idx

-- Test 112: statement (line 573)
DROP PROCEDURE proc_select_145100

-- Test 113: statement (line 576)
CREATE PROCEDURE proc_insert_145100(in_id UUID, in_i INT) LANGUAGE SQL AS $$
  INSERT INTO tab_145100 (id, i) VALUES (in_id, in_i);
$$;

-- Test 114: statement (line 581)
DROP INDEX tab_145100@tab_145100_i_idx

-- Test 115: statement (line 584)
DROP PROCEDURE proc_insert_145100

onlyif config schema-locked-disabled

-- Test 116: query (line 588)
SELECT create_statement FROM [SHOW CREATE TABLE tab_145100]

-- Test 117: query (line 600)
SELECT create_statement FROM [SHOW CREATE TABLE tab_145100]

-- Test 118: statement (line 612)
CALL proc_select_145100()

-- Test 119: statement (line 615)
DROP TABLE tab_145100

