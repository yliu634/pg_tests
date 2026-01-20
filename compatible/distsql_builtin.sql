-- PostgreSQL compatible tests from distsql_builtin
-- 2 tests

-- Test 1: statement (line 3)
CREATE TABLE t (c INT);

retry

-- Test 2: statement (line 13)
SELECT c FROM t
WHERE
	localtimestamp(7::INT8):::TIMESTAMPTZ
	IN ('1975-04-24 08:08:35.000071+00:00':::TIMESTAMPTZ, '1980-10-15 12:17:59.000616+00:00':::TIMESTAMPTZ);

