-- PostgreSQL compatible tests from show_create
-- 43 tests

-- Test 1: statement (line 6)
CREATE TABLE c (
  a INT NOT NULL,
  b INT NULL,
  INDEX c_a_b_idx (a ASC, b ASC),
  UNIQUE WITHOUT INDEX (a, b),
  CONSTRAINT unique_a_partial UNIQUE WITHOUT INDEX (a) WHERE b > 0,
  FAMILY fam_0_a_rowid (a, rowid),
  FAMILY fam_1_b (b)
)

-- Test 2: statement (line 17)
COMMENT ON TABLE c IS 'table'

-- Test 3: statement (line 20)
COMMENT ON COLUMN c.a IS 'column'

-- Test 4: statement (line 23)
COMMENT ON INDEX c_a_b_idx IS 'index'

-- Test 5: statement (line 26)
CREATE TABLE d (d INT PRIMARY KEY)

onlyif config schema-locked-disabled

-- Test 6: query (line 30)
SHOW CREATE c

-- Test 7: query (line 50)
SHOW CREATE c

-- Test 8: statement (line 69)
ALTER TABLE c ADD CONSTRAINT check_b CHECK (b IN (1, 2, 3)) NOT VALID;
ALTER TABLE c ADD CONSTRAINT fk_a FOREIGN KEY (a) REFERENCES d (d) NOT VALID;
ALTER TABLE c ADD CONSTRAINT unique_a UNIQUE (a);
ALTER TABLE c ADD CONSTRAINT unique_b UNIQUE WITHOUT INDEX (b) NOT VALID;
ALTER TABLE c ADD CONSTRAINT unique_b_partial UNIQUE WITHOUT INDEX (b) WHERE a > 0 NOT VALID;

onlyif config schema-locked-disabled

-- Test 9: query (line 77)
SHOW CREATE c

-- Test 10: query (line 101)
SHOW CREATE c

-- Test 11: statement (line 124)
ALTER TABLE c VALIDATE CONSTRAINT check_b;
ALTER TABLE c VALIDATE CONSTRAINT fk_a;
ALTER TABLE c VALIDATE CONSTRAINT unique_b;
ALTER TABLE c VALIDATE CONSTRAINT unique_a_b;
ALTER TABLE c VALIDATE CONSTRAINT unique_b_partial;

skipif config local-legacy-schema-changer

-- Test 12: statement (line 132)
ALTER TABLE c VALIDATE CONSTRAINT unique_a;

-- Test 13: statement (line 138)
ALTER TABLE c VALIDATE CONSTRAINT unique_a;

onlyif config schema-locked-disabled

-- Test 14: query (line 142)
SHOW CREATE c

-- Test 15: query (line 166)
SHOW CREATE c

-- Test 16: query (line 190)
SHOW CREATE c WITH REDACT

-- Test 17: query (line 214)
SHOW CREATE c WITH REDACT

-- Test 18: query (line 238)
SHOW CREATE c WITH IGNORE_FOREIGN_KEYS

-- Test 19: query (line 261)
SHOW CREATE c WITH IGNORE_FOREIGN_KEYS

-- Test 20: statement (line 289)
CREATE TABLE t (c INT);

-- Test 21: statement (line 292)
COMMENT ON COLUMN t.c IS 'first comment';

onlyif config schema-locked-disabled

-- Test 22: query (line 296)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 23: query (line 307)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 24: statement (line 321)
ALTER TABLE t ALTER COLUMN c TYPE character varying;

skipif config local-legacy-schema-changer
onlyif config schema-locked-disabled

-- Test 25: query (line 326)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 26: query (line 338)
SELECT create_statement FROM [SHOW CREATE TABLE t];

-- Test 27: query (line 350)
SELECT create_statement FROM [SHOW CREATE TABLE t WITH REDACT];

-- Test 28: query (line 362)
SELECT create_statement FROM [SHOW CREATE TABLE t WITH REDACT];

-- Test 29: query (line 381)
SELECT * FROM [SHOW CREATE INDEXES FROM t1] ORDER BY index_name

-- Test 30: query (line 388)
SELECT * FROM [SHOW CREATE SECONDARY INDEXES FROM t1] ORDER BY index_name

-- Test 31: statement (line 394)
SHOW CREATE INDEXES FROM nonexistent

-- Test 32: statement (line 397)
SHOW CREATE SECONDARY INDEXES FROM nonexistent

-- Test 33: statement (line 402)
CREATE SCHEMA SC1;

-- Test 34: statement (line 405)
CREATE SCHEMA SC2;

-- Test 35: statement (line 408)
CREATE TYPE SC1.COMP1 AS (A INT, B TEXT);

-- Test 36: statement (line 411)
CREATE TYPE SC2.COMP1 AS (C SMALLINT, D BOOL);

-- Test 37: statement (line 414)
CREATE TABLE T_WITH_COMPS (C1 INT PRIMARY KEY, SC1 SC1.COMP1, SC2 SC2.COMP1, FAMILY F1(C1, SC1, SC2));

onlyif config schema-locked-disabled

-- Test 38: query (line 418)
SELECT create_statement FROM [SHOW CREATE TABLE T_WITH_COMPS];

-- Test 39: query (line 430)
SELECT create_statement FROM [SHOW CREATE TABLE T_WITH_COMPS];

-- Test 40: statement (line 441)
DROP TABLE T_WITH_COMPS;
DROP TYPE SC1.COMP1;
DROP TYPE SC2.COMP1;
DROP SCHEMA SC1;
DROP SCHEMA SC2;

-- Test 41: statement (line 453)
CREATE INDEX ON roaches USING GIN (x, y gin_trgm_ops);

onlyif config schema-locked-disabled

-- Test 42: query (line 457)
SELECT create_statement FROM [SHOW CREATE TABLE roaches];

-- Test 43: query (line 470)
SELECT create_statement FROM [SHOW CREATE TABLE roaches];

