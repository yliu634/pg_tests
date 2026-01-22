-- PostgreSQL compatible tests from schema_change_feature_flags
-- 63 tests

-- PG-NOT-SUPPORTED: CockroachDB schema change feature flags (`SET CLUSTER
-- SETTING feature.schema_change.enabled`) and many related schema-changer
-- statements do not exist in PostgreSQL.
--
-- The original CockroachDB-derived statements are preserved below for
-- reference, but are not executed under PostgreSQL.

SET client_min_messages = warning;

SELECT
  'skipped: schema_change_feature_flags (CockroachDB cluster setting/schema changer feature flags are not supported in PostgreSQL)'
    AS notice;

RESET client_min_messages;

/*
SET client_min_messages = warning;

-- Test 1: statement (line 10)
CREATE SCHEMA s;
CREATE TABLE t1(a INT8, b INT8);
-- CREATE DATABASE d; -- Not isolated in PostgreSQL test DBs; keep DB-scoped.
CREATE TABLE t(a INT);
CREATE INDEX i on t1 (a, b);
CREATE SEQUENCE seq;
CREATE TYPE s.typ AS ENUM ();
CREATE VIEW public.bar (x) AS SELECT 1 AS x;

-- Test 2: statement (line 21)
-- CockroachDB-only feature flag; keep running to capture expected errors.
\set ON_ERROR_STOP 0
SET CLUSTER SETTING feature.schema_change.enabled = FALSE;

-- Test 3: statement (line 25)
-- CREATE DATABASE d;

-- Test 4: statement (line 29)
CREATE TABLE t();

-- Test 5: statement (line 33)
CREATE SCHEMA s;

-- Test 6: statement (line 38)
CREATE TYPE s.typ AS ENUM ();

-- Test 7: statement (line 42)
CREATE VIEW public.bar (x) AS SELECT 1 AS x;

-- Test 8: statement (line 46)
CREATE SEQUENCE seq;

-- Test 9: statement (line 51)
CREATE INDEX on t1 (a, b);

-- Test 10: statement (line 56)
-- ALTER DATABASE d OWNER TO testuser;

-- Test 11: statement (line 60)
-- ALTER DATABASE d ADD REGION "us-west-1";

-- Test 12: statement (line 64)
-- ALTER DATABASE d DROP REGION "us-west-1";

-- Test 13: statement (line 68)
-- ALTER DATABASE d SURVIVE REGION FAILURE;

-- Test 14: statement (line 72)
-- ALTER DATABASE d RENAME TO r;

-- Test 15: statement (line 76)
-- ALTER DATABASE d CONVERT TO SCHEMA WITH PARENT test;

-- Test 16: statement (line 80)
ALTER TABLE t1 PARTITION BY NOTHING;

-- Test 17: statement (line 84)
ALTER TABLE t1 ADD CONSTRAINT a_unique UNIQUE (a);

-- Test 18: statement (line 88)
ALTER TABLE t1 RENAME CONSTRAINT a_unique to r;

-- Test 19: statement (line 96)
ALTER TABLE t1 DROP COLUMN IF EXISTS a;

-- Test 20: statement (line 100)
ALTER TABLE t1 DROP CONSTRAINT IF EXISTS a_unique;

-- Test 21: statement (line 104)
ALTER TABLE t1 ALTER COLUMN a SET NOT NULL;

-- Test 22: statement (line 108)
ALTER TABLE t1 ALTER COLUMN a DROP NOT NULL;

-- Test 23: statement (line 112)
ALTER TABLE t1 ALTER COLUMN a DROP STORED;

-- Test 24: statement (line 116)
ALTER TABLE t1 CONFIGURE ZONE USING num_replicas=5;

-- Test 25: statement (line 120)
ALTER TABLE t RENAME TO r;

-- Test 26: statement (line 124)
ALTER TABLE t SET SCHEMA s;

-- Test 27: statement (line 128)
ALTER TABLE t SET LOCALITY REGIONAL BY ROW;

-- Test 28: statement (line 140)
ALTER TABLE t1 UNSPLIT ALL;

-- Test 29: statement (line 144)
ALTER TABLE t1 RENAME COLUMN a to c;

-- Test 30: statement (line 148)
ALTER INDEX t1@i CONFIGURE ZONE DISCARD;

-- Test 31: statement (line 152)
ALTER INDEX t1@i RENAME TO r;

-- Test 32: statement (line 164)
ALTER INDEX t1@i UNSPLIT ALL;

-- Test 33: statement (line 168)
ALTER SCHEMA s RENAME TO r;

-- Test 34: statement (line 172)
ALTER SCHEMA s OWNER TO testuser;

-- Test 35: statement (line 178)
ALTER TYPE s.typ ADD VALUE 'hi';

-- Test 36: statement (line 182)
ALTER TYPE s.typ RENAME VALUE 'hi' TO 'no';

-- Test 37: statement (line 186)
ALTER TYPE s.typ RENAME TO no;

-- Test 38: statement (line 190)
ALTER TYPE s.typ SET SCHEMA s;

-- Test 39: statement (line 196)
ALTER SEQUENCE seq RENAME TO something;

-- Test 40: statement (line 200)
ALTER SEQUENCE seq SET SCHEMA s;

-- Test 41: statement (line 203)
ALTER SEQUENCE seq NO CYCLE;

-- Test 42: statement (line 207)
REASSIGN OWNED BY root TO testuser;

-- Test 43: statement (line 211)
DROP OWNED BY testuser;

-- Test 44: statement (line 215)
-- DROP DATABASE d;

-- Test 45: statement (line 219)
DROP SCHEMA s;

-- Test 46: statement (line 223)
DROP TYPE s.typ;

-- Test 47: statement (line 227)
DROP TABLE t;

-- Test 48: statement (line 231)
DROP SEQUENCE seq;

-- Test 49: statement (line 237)
ALTER VIEW public.bar SET SCHEMA s;

-- Test 50: statement (line 240)
DROP VIEW public.bar;

-- Test 51: statement (line 244)
DROP INDEX t1@i;

-- Test 52: statement (line 248)
COMMENT ON COLUMN t.a IS 'comment';

-- Test 53: statement (line 252)
-- COMMENT ON DATABASE d IS 'comment';

-- Test 54: statement (line 256)
COMMENT ON INDEX t1@i IS 'comment';

-- Test 55: statement (line 260)
COMMENT ON TABLE t IS 'comment';

-- Test 56: statement (line 263)
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 57: statement (line 266)
CREATE OR REPLACE FUNCTION f() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 58: statement (line 269)
DROP FUNCTION f();

-- Test 59: statement (line 272)
ALTER FUNCTION f() IMMUTABLE;

-- Test 60: statement (line 275)
ALTER FUNCTION f() RENAME TO g;

-- Test 61: statement (line 278)
ALTER FUNCTION f() OWNER TO new_owner;

-- Test 62: statement (line 281)
ALTER FUNCTION f() SET SCHEMA new_schema;

-- Test 63: statement (line 285)
SET CLUSTER SETTING feature.schema_change.enabled = TRUE;

\set ON_ERROR_STOP 1
RESET client_min_messages;
*/
