SET client_min_messages = warning;

-- PostgreSQL compatible tests from name_escapes
-- 8 tests

-- The original CockroachDB test intentionally includes SQL injection-like object
-- names and Cockroach-only statements (SHOW CREATE, column families, inline
-- indexes, etc). PostgreSQL can safely exercise name escaping using quoted
-- identifiers plus catalog introspection.

-- Test 1: statement (line 3)
DROP VIEW IF EXISTS ";--alsoconcerning" CASCADE;
DROP TABLE IF EXISTS ";--dontask" CASCADE;
DROP TABLE IF EXISTS ";--notbetter" CASCADE;
DROP TABLE IF EXISTS "woo; DROP USER humpty;" CASCADE;

CREATE TABLE "woo; DROP USER humpty;" (x INT PRIMARY KEY);
CREATE TABLE ";--notbetter" (x INT PRIMARY KEY, y INT);
INSERT INTO ";--notbetter"(x, y) VALUES (1, 2), (3, 4);

-- Test 2: query (line 21)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = ';--notbetter'
ORDER BY ordinal_position;

-- Test 3: query (line 44)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = ';--notbetter'
ORDER BY ordinal_position;

-- Test 4: statement (line 67)
CREATE VIEW ";--alsoconcerning" AS SELECT x AS a, y AS b FROM ";--notbetter";

-- Test 5: query (line 70)
SELECT pg_get_viewdef('";--alsoconcerning"'::regclass, true) AS viewdef;

-- Test 6: statement (line 79)
CREATE TABLE ";--dontask" AS SELECT x AS a, y AS b FROM ";--notbetter";

-- Test 7: query (line 83)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = ';--dontask'
ORDER BY ordinal_position;

-- Test 8: query (line 94)
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = ';--dontask'
ORDER BY ordinal_position;

RESET client_min_messages;

