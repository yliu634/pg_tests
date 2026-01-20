-- PostgreSQL compatible tests from drop_database
-- 68 tests

SET client_min_messages = warning;

-- CockroachDB-only cluster settings (no-op on PostgreSQL).
-- SET CLUSTER SETTING sql.cross_db_views.enabled = TRUE;
-- SET CLUSTER SETTING sql.cross_db_sequence_references.enabled = TRUE;

DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS db_owner;
CREATE ROLE testuser LOGIN;
CREATE ROLE db_owner LOGIN CREATEDB;

-- Test 3: statement (line 8)
DROP SCHEMA IF EXISTS "foo-bar" CASCADE;
CREATE SCHEMA "foo-bar";

-- Test 4: query (line 11)
SELECT nspname AS database_name
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema'
  AND nspname <> 'public'
ORDER BY database_name;

-- Test 5: statement (line 20)
CREATE TABLE "foo-bar".t(x INT);

-- Test 6: statement (line 23)
-- Expected ERROR (cannot drop non-empty schema with RESTRICT):
\set ON_ERROR_STOP 0
DROP SCHEMA "foo-bar" RESTRICT;
\set ON_ERROR_STOP 1

-- Test 7: statement (line 26)
DROP SCHEMA "foo-bar" CASCADE;

-- Test 8: query (line 29)
SELECT c.relname AS name, n.nspname AS schema_name
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE c.relkind = 'r'
  AND c.relname = 't'
ORDER BY schema_name;

-- Test 9: query (line 34)
SELECT nspname AS database_name
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema'
  AND nspname <> 'public'
ORDER BY database_name;

-- Test 10: statement (line 52)
DROP SCHEMA IF EXISTS "foo bar" CASCADE;
CREATE SCHEMA "foo bar";

-- Test 11: query (line 55)
SELECT nspname AS database_name
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema'
  AND nspname <> 'public'
ORDER BY database_name;

-- Test 12: statement (line 64)
DROP SCHEMA "foo bar" CASCADE;

-- Test 13: query (line 67)
SELECT nspname AS database_name
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema'
  AND nspname <> 'public'
ORDER BY database_name;

-- Test 14/15: setup cross-"database" references using schemas.
DROP SCHEMA IF EXISTS d1 CASCADE;
DROP SCHEMA IF EXISTS d2 CASCADE;
CREATE SCHEMA d1;
CREATE SCHEMA d2;

CREATE TABLE d1.t1(k INT, v INT);
CREATE TABLE d2.t1(k INT, v INT);

INSERT INTO d1.t1 VALUES (1, 10), (2, 20);
INSERT INTO d2.t1 VALUES (1, 100), (3, 300);

-- Test 16-21: views spanning schemas.
CREATE VIEW d1.v1 AS SELECT k, v FROM d1.t1;
CREATE VIEW d1.v2 AS SELECT k, v FROM d1.v1;
CREATE VIEW d2.v1 AS SELECT k, v FROM d2.t1;
CREATE VIEW d2.v2 AS SELECT k, v FROM d1.t1;
CREATE VIEW d2.v3 AS SELECT k, v FROM d1.v2;
CREATE VIEW d2.v4 AS
  SELECT count(*) FROM d1.t1 AS x JOIN d2.t1 AS y ON x.k = y.k;

-- Test 22-27: grant privileges to a non-owner user.
GRANT ALL ON SCHEMA d1 TO testuser;
GRANT ALL ON d1.t1 TO testuser;
GRANT ALL ON d1.v1 TO testuser;
GRANT ALL ON d1.v2 TO testuser;
GRANT ALL ON d2.v2 TO testuser;
GRANT ALL ON d2.v3 TO testuser;

-- Test 28: attempt drop as non-owner (expected ERROR in PG).
SET ROLE testuser;
\set ON_ERROR_STOP 0
DROP SCHEMA d1 CASCADE;
\set ON_ERROR_STOP 1
RESET ROLE;

-- Test 29-33: objects still exist.
SELECT * FROM d1.v2 ORDER BY k;
SELECT * FROM d2.v1 ORDER BY k;
SELECT * FROM d2.v2 ORDER BY k;
SELECT * FROM d2.v3 ORDER BY k;
SELECT * FROM d2.v4;

-- Test 34: query (line 151)
SELECT nspname AS database_name
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema'
  AND nspname <> 'public'
ORDER BY database_name;

-- Test 35: statement (line 161)
DROP SCHEMA d1 CASCADE;

-- Test 36: query (line 164)
SELECT nspname AS database_name
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema'
  AND nspname <> 'public'
ORDER BY database_name;

-- Test 37: queries after dropping d1.
\set ON_ERROR_STOP 0
SELECT * FROM d1.v2;
SELECT * FROM d2.v2;
SELECT * FROM d2.v3;
SELECT * FROM d2.v4;
\set ON_ERROR_STOP 1
SELECT * FROM d2.v1 ORDER BY k;

-- Test 38: statement (line 189)
DROP SCHEMA d2 CASCADE;

-- Test 39: query (line 192)
SELECT nspname AS database_name
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema'
  AND nspname <> 'public'
ORDER BY database_name;

-- Test 40: query (line 200)
\set ON_ERROR_STOP 0
SELECT * FROM d2.v1;
\set ON_ERROR_STOP 1

-- drop a database containing tables with foreign key constraints, e.g. #8497
DROP SCHEMA IF EXISTS constraint_db CASCADE;
CREATE SCHEMA constraint_db;

CREATE TABLE constraint_db.t1 (
  p FLOAT PRIMARY KEY,
  a INT UNIQUE CHECK (a > 4),
  CONSTRAINT c2 CHECK (a < 99)
);

CREATE TABLE constraint_db.t2 (
  t1_id INT,
  CONSTRAINT fk FOREIGN KEY (t1_id) REFERENCES constraint_db.t1(a)
);
CREATE INDEX ON constraint_db.t2 (t1_id);

DROP SCHEMA constraint_db CASCADE;

-- CockroachDB jobs table is not available in PostgreSQL.
-- skipif config local-legacy-schema-changer
-- WITH cte AS (...) SELECT * FROM cte ORDER BY job_type, description

-- Test 41: query (line 246)
SELECT nspname AS database_name
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema'
  AND nspname <> 'public'
ORDER BY database_name;

-- Test 42-54: sequences inside vs outside the dropped schema.
DROP SCHEMA IF EXISTS db50997 CASCADE;
CREATE SCHEMA db50997;

CREATE SEQUENCE db50997.seq50997;
CREATE SEQUENCE db50997.useq50997;

CREATE TABLE db50997.t50997(a INT DEFAULT nextval('db50997.seq50997'));
CREATE TABLE db50997.t250997(a INT DEFAULT nextval('db50997.seq50997'));

DROP SCHEMA db50997 CASCADE;

SELECT count(*) FROM pg_class WHERE relkind = 'S' AND relname = 'seq50997';
SELECT count(*) FROM pg_class WHERE relkind = 'S' AND relname = 'useq50997';

DROP SCHEMA IF EXISTS db50997 CASCADE;
CREATE SCHEMA db50997;

CREATE SEQUENCE seq50997;

CREATE TABLE db50997.t50997(a INT DEFAULT nextval('seq50997'));

DROP SCHEMA db50997 CASCADE;

SELECT count(*) FROM pg_class WHERE relkind = 'S' AND relname LIKE 'seq50997';

-- Test 55-57: drop empty schema with RESTRICT.
DROP SCHEMA IF EXISTS db_73323 CASCADE;
CREATE SCHEMA db_73323;
DROP SCHEMA db_73323 RESTRICT;

-- Test 58-63: drop schema with dependent views.
DROP SCHEMA IF EXISTS db_51782 CASCADE;
CREATE SCHEMA db_51782;

CREATE TABLE db_51782.t_51782(a int, b int);
CREATE VIEW db_51782.v_51782 AS SELECT a, b FROM db_51782.t_51782;
CREATE VIEW db_51782.w_51782 AS SELECT a FROM db_51782.v_51782;

DROP SCHEMA db_51782 CASCADE;

SELECT count(*) FROM pg_class WHERE relkind = 'v' AND relname LIKE 'v_51782';
SELECT count(*) FROM pg_class WHERE relkind = 'v' AND relname LIKE 'w_51782';

-- Test 64-68: role creating/dropping a schema.
DROP SCHEMA IF EXISTS db_121808 CASCADE;

SELECT format('GRANT CREATE ON DATABASE %I TO db_owner', current_database())
\gexec
SET ROLE db_owner;

CREATE SCHEMA db_121808;
DROP SCHEMA db_121808 RESTRICT;

RESET ROLE;

SELECT format('REVOKE ALL ON DATABASE %I FROM db_owner', current_database())
\gexec

DROP ROLE db_owner;
DROP ROLE testuser;

RESET client_min_messages;
