-- PostgreSQL compatible tests from tenant_span_stats
-- 8 tests

-- Test 1: statement (line 4)
CREATE SCHEMA a;

-- Test 2: statement (line 8)
CREATE TABLE a.b (id INT PRIMARY KEY);

-- Test 3: statement (line 12)
INSERT INTO a.b SELECT generate_series(1, 10);

-- Test 4: statement (line 16)
CREATE TABLE a.c (id INT PRIMARY KEY);

-- Test 5: statement (line 79)
SELECT * FROM a.b;

-- Test 6: statement (line 90)
SET client_min_messages = warning;
DROP ROLE IF EXISTS testuser2;
RESET client_min_messages;
CREATE ROLE testuser2;

-- Test 7: statement (line 119)
-- CockroachDB role options are not supported in PostgreSQL.
-- ALTER ROLE testuser2 WITH NOVIEWACTIVITY

-- Test 8: statement (line 123)
-- ALTER ROLE testuser2 WITH VIEWACTIVITYREDACTED
