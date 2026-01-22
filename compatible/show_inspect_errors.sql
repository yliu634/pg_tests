-- PostgreSQL compatible tests from show_inspect_errors
-- 26 tests

\set ON_ERROR_STOP 1
SET client_min_messages = warning;

-- Use a dedicated role so this file can clean up after itself (roles are cluster-wide).
DROP ROLE IF EXISTS show_inspect_errors_testuser;
CREATE ROLE show_inspect_errors_testuser;

-- Minimal Postgres model of Cockroach's inspect jobs + inspect errors.
DROP SCHEMA IF EXISTS system CASCADE;
CREATE SCHEMA system;
REVOKE ALL ON SCHEMA system FROM PUBLIC;

CREATE TABLE system.jobs (
  id BIGINT PRIMARY KEY,
  owner TEXT NOT NULL,
  status TEXT NOT NULL,
  job_type TEXT NOT NULL
);

CREATE TABLE system.inspect_errors (
  job_id BIGINT NOT NULL,
  error_type TEXT NOT NULL,
  aost TEXT NOT NULL,
  database_id OID NOT NULL,
  schema_id OID NOT NULL,
  table_oid OID NOT NULL,
  details TEXT NOT NULL
);

-- Like to_regclass(), but also swallows errors for syntactically-invalid
-- relation names (e.g. "db.schema.table").
DROP FUNCTION IF EXISTS system.safe_regclass(text);
CREATE FUNCTION system.safe_regclass(in_name text)
RETURNS regclass
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN in_name::regclass;
EXCEPTION WHEN OTHERS THEN
  RETURN NULL;
END;
$$;

CREATE VIEW system.show_inspect_errors AS
SELECT
  ie.job_id,
  ie.error_type,
  ie.aost,
  ie.table_oid::regclass AS table_name,
  ie.details
FROM system.inspect_errors AS ie
JOIN system.jobs AS j ON j.id = ie.job_id
WHERE j.job_type = 'INSPECT'
  AND j.status <> 'succeeded';

-- Test 1: statement (line 3)
-- Cockroach: SHOW INSPECT ERRORS
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
ORDER BY job_id, table_name, error_type;

-- Test 2: statement (line 8)
-- Cockroach: GRANT SYSTEM INSPECT TO testuser;
GRANT USAGE ON SCHEMA system TO show_inspect_errors_testuser;
GRANT SELECT ON system.jobs, system.inspect_errors, system.show_inspect_errors TO show_inspect_errors_testuser;

-- Test 3: statement (line 11)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE bad_table
SELECT job_id, error_type
FROM system.show_inspect_errors
WHERE table_name = system.safe_regclass('bad_table');

-- Test 4: statement (line 14)
CREATE TABLE foo (a INT);
CREATE TABLE bar (b INT);

SELECT 'foo'::regclass::oid AS foo_table_id \gset
SELECT 'bar'::regclass::oid AS bar_table_id \gset
SELECT oid AS database_id FROM pg_database WHERE datname = current_database() \gset
SELECT current_schema()::regnamespace::oid AS schema_id \gset
\set aost 2025-09-23-11:02:14-04:00

-- Test 5: statement (line 34)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (555, 'show_inspect_errors_testuser', 'failed', 'INSPECT');

-- Test 6: statement (line 54)
INSERT INTO system.inspect_errors (job_id, error_type, aost, database_id, schema_id, table_oid, details)
VALUES
  (555, '555_foo', :'aost', :database_id, :schema_id, :foo_table_id, '{"detail":"555\\"foo"}'),
  (555, '555_bar', :'aost', :database_id, :schema_id, :bar_table_id, '{"detail":"555\\"bar"}');

-- Test 7: statement (line 60)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (666, 'show_inspect_errors_testuser', 'failed', 'INSPECT');

-- Test 8: statement (line 79)
INSERT INTO system.inspect_errors (job_id, error_type, aost, database_id, schema_id, table_oid, details)
VALUES
  (666, '666_foo', :'aost', :database_id, :schema_id, :foo_table_id, '{"detail1":"\\u2603 666_foo_1","detail2":"\\n666_foo_2"}');

-- Test 9: statement (line 83)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (777, 'show_inspect_errors_testuser', 'running', 'INSPECT');

-- Test 10: statement (line 102)
INSERT INTO system.inspect_errors (job_id, error_type, aost, database_id, schema_id, table_oid, details)
VALUES
  (777, '777_foo', :'aost', :database_id, :schema_id, :foo_table_id, '{"detail":"777 foo"}');

-- user testuser
SET ROLE show_inspect_errors_testuser;

-- Test 11: query (line 109)
-- Cockroach: SHOW INSPECT ERRORS
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
ORDER BY job_id, table_name, error_type;

-- Test 12: query (line 115)
-- Cockroach: SHOW INSPECT ERRORS WITH DETAILS
SELECT *
FROM system.show_inspect_errors
ORDER BY job_id, table_name, error_type;

-- Test 13: query (line 125)
-- Cockroach: SHOW INSPECT ERRORS FOR JOB 777
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE job_id = 777
ORDER BY job_id, table_name, error_type;

-- Test 14: query (line 130)
-- Cockroach: SHOW INSPECT ERRORS FOR JOB 555
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE job_id = 555
ORDER BY job_id, table_name, error_type;

-- Test 15: query (line 137)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE foo
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE table_name = 'foo'::regclass
ORDER BY job_id, table_name, error_type;

-- Test 16: query (line 143)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE bar
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE table_name = 'bar'::regclass
ORDER BY job_id, table_name, error_type;

-- Test 17: query (line 148)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE public.bar
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE table_name = 'public.bar'::regclass
ORDER BY job_id, table_name, error_type;

-- Test 18: query (line 153)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE test.public.bar
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE table_name = system.safe_regclass('test.public.bar')
ORDER BY job_id, table_name, error_type;

-- Test 19: query (line 158)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE foo FOR JOB 555 WITH DETAILS
SELECT *
FROM system.show_inspect_errors
WHERE job_id = 555
  AND table_name = 'foo'::regclass
ORDER BY job_id, table_name, error_type;

RESET ROLE;

-- Test 20: statement (line 173)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (888, 'show_inspect_errors_testuser', 'succeeded', 'INSPECT');

-- user testuser
SET ROLE show_inspect_errors_testuser;

-- Test 21: query (line 199)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE foo
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE table_name = 'foo'::regclass
ORDER BY job_id, table_name, error_type;

-- Test 22: query (line 204)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE foo FOR JOB 666
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE job_id = 666
  AND table_name = 'foo'::regclass
ORDER BY job_id, table_name, error_type;

RESET ROLE;

-- Test 23: statement (line 217)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (999, 'show_inspect_errors_testuser', 'succeeded', 'INSPECT');

-- user testuser
SET ROLE show_inspect_errors_testuser;

-- Test 24: query (line 236)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE foo
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE table_name = 'foo'::regclass
ORDER BY job_id, table_name, error_type;

-- Test 25: query (line 240)
-- Cockroach: SHOW INSPECT ERRORS FOR TABLE bar
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE table_name = 'bar'::regclass
ORDER BY job_id, table_name, error_type;

-- Test 26: query (line 245)
-- Cockroach: SHOW INSPECT ERRORS FOR JOB 999
SELECT job_id, error_type, aost, table_name
FROM system.show_inspect_errors
WHERE job_id = 999
ORDER BY job_id, table_name, error_type;

RESET ROLE;
DROP SCHEMA system CASCADE;
DROP ROLE show_inspect_errors_testuser;
RESET client_min_messages;
