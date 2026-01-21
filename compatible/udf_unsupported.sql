-- PostgreSQL compatible tests from udf_unsupported
-- 30 tests

-- Test 1: statement (line 3)
CREATE FUNCTION test_tbl_f() RETURNS INT IMMUTABLE LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 2: statement (line 6)
CREATE TABLE test_tbl_t (a INT PRIMARY KEY, b INT);

-- Test 3: statement (line 10)
INSERT INTO test_tbl_t VALUES (1, 1);

-- Test 4: statement (line 13)
ALTER TABLE test_tbl_t ADD COLUMN c int GENERATED ALWAYS AS (test_tbl_f()) STORED;

-- Test 5: statement (line 16)
ALTER TABLE test_tbl_t ADD COLUMN d int DEFAULT (test_tbl_f());

-- Test 6: statement (line 19)
CREATE INDEX t_idx_partial ON test_tbl_t(b) WHERE test_tbl_f() > 0;

-- Test 7: statement (line 22)
CREATE INDEX idx_b ON test_tbl_t (test_tbl_f());

-- Test 8: statement (line 30)
-- CRDB tests use cross-database names; in PostgreSQL we approximate with schemas.
CREATE SCHEMA cross_db1_sc;
CREATE TYPE cross_db1_sc.workday AS ENUM ('MON');
CREATE TABLE cross_db1_sc.tbl(a INT PRIMARY KEY, b cross_db1_sc.workday);
CREATE VIEW cross_db1_sc.v AS SELECT a FROM cross_db1_sc.tbl;

-- Test 9: statement (line 37)
CREATE FUNCTION f_cross_db(cross_db1_sc.workday) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 10: statement (line 40)
CREATE FUNCTION f_cross_db() RETURNS cross_db1_sc.workday LANGUAGE SQL AS $$ SELECT 'MON'::cross_db1_sc.workday $$;

-- Test 11: statement (line 43)
-- PostgreSQL does not allow overloading by return type.
\set ON_ERROR_STOP 0
CREATE FUNCTION f_cross_db() RETURNS INT LANGUAGE SQL AS $$ SELECT a FROM cross_db1_sc.tbl $$;

-- Test 12: statement (line 46)
CREATE FUNCTION f_cross_db() RETURNS INT LANGUAGE SQL AS $$ SELECT a FROM cross_db1_sc.v $$;
\set ON_ERROR_STOP 1

-- Test 13: statement (line 55)
CREATE FUNCTION err() RETURNS VOID LANGUAGE SQL AS 'CREATE TABLE t (a INT)';

-- Test 14: statement (line 58)
\set ON_ERROR_STOP 0
CREATE FUNCTION err() RETURNS VOID LANGUAGE SQL AS 'ALTER TABLE t ADD COLUMN b BOOL';

-- Test 15: statement (line 61)
CREATE FUNCTION err() RETURNS VOID LANGUAGE SQL AS 'DROP TABLE t';

-- Test 16: statement (line 70)
CREATE FUNCTION err() RETURNS VOID LANGUAGE SQL AS 'PREPARE p AS SELECT * FROM t';
\set ON_ERROR_STOP 1

-- Test 17: statement (line 79)
CREATE FUNCTION rec(i INT) RETURNS INT LANGUAGE SQL AS 'SELECT CASE i WHEN 0 THEN 0 ELSE i + rec(i-1) END';

-- Test 18: statement (line 83)
CREATE FUNCTION other_udf() RETURNS INT LANGUAGE SQL AS 'SELECT 1';

-- Test 19: statement (line 86)
\set ON_ERROR_STOP 0
CREATE FUNCTION err() RETURNS INT LANGUAGE SQL AS 'SELECT other_udf()';

-- Test 20: statement (line 95)
CREATE FUNCTION rec(VARIADIC arr INT[]) RETURNS INT LANGUAGE SQL AS '1';

-- Test 21: statement (line 105)
CREATE FUNCTION crdb_internal.f_102964 () RETURNS INT AS 'SELECT 1' LANGUAGE sql;

-- Test 22: statement (line 108)
CREATE FUNCTION information_schema.f_102964 () RETURNS INT AS 'SELECT 1' LANGUAGE sql;

-- Test 23: statement (line 111)
CREATE FUNCTION pg_catalog.f_102964 () RETURNS INT AS 'SELECT 1' LANGUAGE sql;

-- Test 24: statement (line 114)
CREATE FUNCTION pg_extension.f_102964 () RETURNS INT AS 'SELECT 1' LANGUAGE sql;

-- Test 25: statement (line 120)
CREATE TEMP TABLE t_102964 (i INT PRIMARY KEY);

-- Capture the per-session temp schema name so we can qualify objects into it.
SELECT nspname AS temp_schema_102964
FROM pg_namespace
WHERE oid = pg_my_temp_schema()
\gset

-- Test 26: statement (line 126)
CREATE FUNCTION :"temp_schema_102964".f_102964 () RETURNS INT AS 'SELECT 1' LANGUAGE sql;

-- Test 27: statement (line 133)
CREATE FUNCTION f_call() RETURNS INT LANGUAGE SQL AS 'SELECT 1';

-- Test 28: statement (line 137)
CALL f_call();

-- Test 29: statement (line 140)
CREATE OR REPLACE FUNCTION f_call() RETURNS INT LANGUAGE SQL AS '';

-- Test 30: statement (line 144)
CALL f_call();
\set ON_ERROR_STOP 1
