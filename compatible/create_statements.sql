-- PostgreSQL compatible tests from create_statements
-- 21 tests

-- Test 1: statement (line 6)
CREATE TABLE t (
  a INT REFERENCES t,
  FAMILY "primary" (a, rowid)
)

-- Test 2: statement (line 18)
CREATE TABLE c (
	a INT NOT NULL,
	b INT NULL,
	INDEX c_a_b_idx (a ASC, b ASC),
	FAMILY fam_0_a_rowid (a, rowid),
	FAMILY fam_1_b (b)
)

-- Test 3: statement (line 27)
COMMENT ON TABLE c IS 'table'

-- Test 4: statement (line 30)
COMMENT ON COLUMN c.a IS 'column'

-- Test 5: statement (line 33)
COMMENT ON INDEX c_a_b_idx IS 'index'

onlyif config schema-locked-disabled

-- Test 6: query (line 37)
SELECT
  regexp_replace(create_statement, '\n', ' ', 'g'),
  regexp_replace(create_nofks, '\n', ' ', 'g'),
  fk_statements,
  validate_statements
FROM
  crdb_internal.create_statements
WHERE
  database_name = 'test'
AND
  schema_name NOT IN ('pg_catalog', 'pg_extension', 'crdb_internal', 'information_schema')
ORDER BY descriptor_id

-- Test 7: query (line 57)
SELECT
  regexp_replace(create_statement, '\n', ' ', 'g'),
  regexp_replace(create_nofks, '\n', ' ', 'g'),
  fk_statements,
  validate_statements
FROM
  crdb_internal.create_statements
WHERE
  database_name = 'test'
AND
  schema_name NOT IN ('pg_catalog', 'pg_extension', 'crdb_internal', 'information_schema')
ORDER BY descriptor_id

-- Test 8: query (line 76)
CREATE UNLOGGED TABLE unlogged_tbl (col int PRIMARY KEY)

-- Test 9: query (line 82)
SHOW CREATE TABLE unlogged_tbl

-- Test 10: query (line 91)
SHOW CREATE TABLE unlogged_tbl

-- Test 11: statement (line 99)
CREATE TABLE a (b INT) WITH (foo=100);

-- Test 12: statement (line 102)
CREATE TABLE a (b INT) WITH (fillfactor=true);

-- Test 13: statement (line 105)
CREATE TABLE a (b INT) WITH (toast_tuple_target=100);

-- Test 14: query (line 108)
CREATE TABLE a (b INT) WITH (fillfactor=99.9)

-- Test 15: query (line 113)
CREATE INDEX a_idx ON a(b) WITH (fillfactor=50)

-- Test 16: statement (line 118)
DROP TABLE a CASCADE;

-- Test 17: query (line 121)
CREATE TABLE a (b INT) WITH (autovacuum_enabled=off)

-- Test 18: statement (line 126)
DROP TABLE a CASCADE;

-- Test 19: query (line 129)
CREATE TABLE a (b INT) WITH (autovacuum_enabled=on)

-- Test 20: statement (line 133)
DROP TABLE a CASCADE;

-- Test 21: statement (line 136)
CREATE TABLE a (b INT) WITH (autovacuum_enabled='11')

