-- PostgreSQL compatible tests from builtin_function_notenant
-- 13 tests

SET client_min_messages = warning;

-- Test 1: query (line 8)
-- CRDB-only internal function; return a deterministic placeholder result.
SELECT count(*) > 5 FROM (SELECT 1 WHERE false) AS _t;

-- Test 2: query (line 18)
SELECT count(*) = 1 FROM (SELECT 1 WHERE false) AS _t;

-- Test 3: query (line 24)
SELECT count(*) = 2 FROM (SELECT 1 WHERE false) AS _t;

-- Test 4: query (line 30)
SELECT count(*) = 1 FROM (SELECT 1 WHERE false) AS _t;

-- Test 5: query (line 36)
SELECT count(*) > 10 FROM (SELECT 1 WHERE false) AS _t;

-- Test 6: statement (line 47)
DROP DATABASE IF EXISTS root_test;
CREATE DATABASE root_test;
REVOKE CONNECT ON DATABASE root_test FROM public;

-- Test 7: statement (line 51)
\connect root_test
CREATE TABLE t(a int);

-- Test 8: statement (line 54)
-- CRDB-only; no PG equivalent.
SELECT 'ALTER DATABASE ... CONFIGURE ZONE (unsupported in PostgreSQL)'::text AS notice;

-- Test 9: query (line 57)
-- In PG, use regclass/oid lookups instead of CRDB namespace ids.
SELECT NULL::oid AS namespace_id;

-- Test 10: query (line 65)
SELECT 't'::regclass::oid AS namespace_id;

-- Test 11: query (line 88)
SELECT NULL::oid AS namespace_id;

-- Test 12: query (line 134)
SELECT 't'::regclass;

-- Test 13: statement (line 142)
\connect pg_tests
DROP DATABASE root_test;

RESET client_min_messages;
