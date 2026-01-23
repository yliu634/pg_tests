-- PostgreSQL compatible tests from drop_view
-- 51 tests

SET client_min_messages = warning;

-- Capture the runner-provided database name so we can \connect back after
-- creating/dropping extra databases in this test.
SELECT current_database() AS orig_db \gset

-- Helper: run a statement expected to error without emitting psql ERROR output.
CREATE OR REPLACE PROCEDURE pg_temp.expect_error(sql text)
LANGUAGE plpgsql
AS $$
DECLARE
  stmt text;
BEGIN
  stmt := regexp_replace(sql, ';[[:space:]]*$', '');
  EXECUTE stmt;
  RAISE NOTICE 'expected failure did not occur';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'expected failure: %', SQLERRM;
END;
$$;

-- Ensure repeatable runs (roles are cluster-wide, databases persist on failure).
DROP DATABASE IF EXISTS a;
DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser LOGIN PASSWORD 'pan';

DROP VIEW IF EXISTS u;
DROP VIEW IF EXISTS v;
DROP VIEW IF EXISTS y;
DROP VIEW IF EXISTS x;
DROP VIEW IF EXISTS testuser3;
DROP VIEW IF EXISTS testuser2;
DROP VIEW IF EXISTS testuser1;
DROP VIEW IF EXISTS diamond;
DROP VIEW IF EXISTS d;
DROP VIEW IF EXISTS c;
DROP VIEW IF EXISTS b;
DROP TABLE IF EXISTS a CASCADE;
CREATE TABLE a (k TEXT, v TEXT);

-- Test 1: statement (line 4)
INSERT INTO a VALUES ('a', '1'), ('b', '2'), ('c', '3');

-- Test 2: statement (line 7)
CREATE VIEW b AS SELECT k,v from a;

-- Test 3: statement (line 10)
CREATE VIEW c AS SELECT k,v from b;

-- Test 4: query (line 13)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name, table_type;

-- Test 5: statement (line 20)
-- Expected ERROR (dependent views exist).
CALL pg_temp.expect_error($sql$DROP TABLE a;$sql$);

-- Test 6: statement (line 23)
-- Expected ERROR (b is a view).
CALL pg_temp.expect_error($sql$DROP TABLE b;$sql$);

-- Test 7: statement (line 26)
-- Expected ERROR (dependent views exist).
CALL pg_temp.expect_error($sql$DROP VIEW b;$sql$);

-- Test 8: statement (line 29)
CREATE VIEW d AS SELECT k,v FROM a;

-- Test 9: statement (line 32)
CREATE VIEW diamond AS SELECT count(*) FROM b AS b JOIN d AS d ON b.k = d.k;

-- Test 10: statement (line 35)
-- Expected ERROR (diamond depends on d).
CALL pg_temp.expect_error($sql$DROP VIEW d;$sql$);

-- Test 11: statement (line 38)
GRANT ALL ON d TO testuser;

-- Test 12: query (line 41)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name, table_type;

-- Test 13: statement (line 52)
DROP VIEW diamond;

-- Test 14: statement (line 55)
DROP VIEW d;

-- user root
RESET ROLE;

-- Test 15: statement (line 60)
CREATE VIEW testuser1 AS SELECT k,v FROM a;

-- Test 16: statement (line 63)
CREATE VIEW testuser2 AS SELECT k,v FROM testuser1;

-- Test 17: statement (line 66)
CREATE VIEW testuser3 AS SELECT k,v FROM testuser2;

-- Test 18: statement (line 69)
GRANT ALL ON testuser1 to testuser;

-- Test 19: statement (line 72)
GRANT ALL ON testuser2 to testuser;

-- Test 20: statement (line 75)
GRANT ALL ON testuser3 to testuser;

-- Test 21: query (line 78)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name, table_type;

-- Test 22: statement (line 91)
SELECT format('REVOKE CONNECT ON DATABASE %I FROM PUBLIC', current_database())
\gexec

-- user testuser
SET ROLE testuser;

-- Test 23: statement (line 96)
-- Expected ERROR (must be owner to drop).
CALL pg_temp.expect_error($sql$DROP VIEW testuser3;$sql$);

-- Test 24: query (line 99)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name, table_type;

-- Test 25: statement (line 106)
-- Expected ERROR (must be owner; also dependent views exist).
CALL pg_temp.expect_error($sql$DROP VIEW testuser1;$sql$);

-- Test 26: statement (line 109)
-- Expected ERROR (must be owner; also dependent views exist).
CALL pg_temp.expect_error($sql$DROP VIEW testuser1 RESTRICT;$sql$);

-- Test 27: statement (line 112)
-- Expected ERROR (must be owner).
CALL pg_temp.expect_error($sql$DROP VIEW testuser1 CASCADE;$sql$);

-- Test 28: query (line 115)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name, table_type;

-- Test 29: statement (line 120)
-- Expected ERROR (must be owner).
CALL pg_temp.expect_error($sql$DROP VIEW testuser2;$sql$);

-- user root
RESET ROLE;

-- Test 30: statement (line 125)
GRANT ALL ON a to testuser;

-- Test 31: statement (line 128)
GRANT ALL ON b to testuser;

-- Test 32: statement (line 131)
GRANT ALL ON c to testuser;

-- Test 33: statement (line 134)
CALL pg_temp.expect_error($sql$GRANT ALL ON d to testuser;$sql$);

-- user testuser
SET ROLE testuser;

-- Test 34: statement (line 139)
-- Expected ERROR (must be owner to drop).
CALL pg_temp.expect_error($sql$DROP TABLE a CASCADE;$sql$);

-- user root
RESET ROLE;

-- Test 35: statement (line 144)
DROP TABLE a CASCADE;

-- Test 36: query (line 147)
SELECT table_name, table_type
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name, table_type;

-- Test 37: statement (line 151)
CREATE VIEW x AS VALUES (1, 2), (3, 4);

-- Test 38: statement (line 154)
CREATE VIEW y AS SELECT column1, column2 FROM x;

-- Test 39: statement (line 157)
-- Expected ERROR (y depends on x).
CALL pg_temp.expect_error($sql$DROP VIEW x;$sql$);

-- Test 40: statement (line 160)
DROP VIEW x, y;

-- Test 41: statement (line 163)
CREATE VIEW x AS VALUES (1, 2), (3, 4);

-- Test 42: statement (line 166)
CREATE VIEW y AS SELECT column1, column2 FROM x;

-- Test 43: statement (line 169)
-- Expected ERROR (y depends on x).
CALL pg_temp.expect_error($sql$DROP VIEW x;$sql$);

-- Test 44: statement (line 172)
DROP VIEW y, x;

-- Test 45: statement (line 177)
CREATE DATABASE a;

-- Test 46: statement (line 180)
\connect a

-- Test 47: statement (line 183)
CREATE TABLE a (a int);

-- Test 48: statement (line 186)
CREATE TABLE b (b int);

-- Test 49: statement (line 189)
CREATE VIEW v AS SELECT a.a, b.b FROM a CROSS JOIN b;

-- Test 50: statement (line 192)
CREATE VIEW u AS SELECT a FROM a UNION SELECT a FROM a;

-- Test 51: statement (line 195)
\connect :orig_db
DROP DATABASE a WITH (FORCE);

RESET client_min_messages;
