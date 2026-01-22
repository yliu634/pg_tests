-- PostgreSQL compatible tests from privileges_table
-- 105 tests

SET client_min_messages = warning;

-- Roles are cluster-scoped in PostgreSQL; make the test re-runnable.
DROP ROLE IF EXISTS bar;
DROP ROLE IF EXISTS testuser;

CREATE ROLE bar LOGIN;
CREATE ROLE testuser LOGIN;
GRANT bar TO :"USER";
GRANT testuser TO :"USER";

-- Test 1: statement (line 3)
DROP DATABASE IF EXISTS a;
CREATE DATABASE a;

-- Test 2: statement (line 6)
\connect a

-- Minimal SHOW CREATE helper for PostgreSQL: surface table metadata in a stable way.
CREATE OR REPLACE FUNCTION pg_show_create_table(
  tab regclass,
  redact boolean,
  ignore_foreign_keys boolean
)
RETURNS TABLE(kind text, name text, detail text)
LANGUAGE sql
AS $$
  WITH
  cols AS (
    SELECT
      'column'::text AS kind,
      a.attname::text AS name,
      pg_catalog.format_type(a.atttypid, a.atttypmod)
        || CASE WHEN a.attnotnull THEN ' NOT NULL' ELSE '' END AS detail
    FROM pg_catalog.pg_attribute a
    WHERE a.attrelid = tab AND a.attnum > 0 AND NOT a.attisdropped
  ),
  cons AS (
    SELECT
      'constraint'::text AS kind,
      c.conname::text AS name,
      pg_catalog.pg_get_constraintdef(c.oid) AS detail
    FROM pg_catalog.pg_constraint c
    WHERE c.conrelid = tab
      AND (NOT ignore_foreign_keys OR c.contype <> 'f')
  ),
  idx AS (
    SELECT
      'index'::text AS kind,
      i.relname::text AS name,
      pg_catalog.pg_get_indexdef(i.oid) AS detail
    FROM pg_catalog.pg_index x
    JOIN pg_catalog.pg_class i ON i.oid = x.indexrelid
    WHERE x.indrelid = tab
  ),
  comments AS (
    SELECT
      'comment'::text AS kind,
      'table'::text AS name,
      CASE WHEN redact THEN '<redacted>' ELSE pg_catalog.obj_description(tab, 'pg_class') END AS detail
    WHERE pg_catalog.obj_description(tab, 'pg_class') IS NOT NULL
    UNION ALL
    SELECT
      'comment',
      ('column ' || a.attname)::text,
      CASE WHEN redact THEN '<redacted>' ELSE pg_catalog.col_description(tab, a.attnum) END
    FROM pg_catalog.pg_attribute a
    WHERE a.attrelid = tab
      AND a.attnum > 0
      AND NOT a.attisdropped
      AND pg_catalog.col_description(tab, a.attnum) IS NOT NULL
    UNION ALL
    SELECT
      'comment',
      ('index ' || i.relname)::text,
      CASE WHEN redact THEN '<redacted>' ELSE pg_catalog.obj_description(i.oid, 'pg_class') END
    FROM pg_catalog.pg_index x
    JOIN pg_catalog.pg_class i ON i.oid = x.indexrelid
    WHERE x.indrelid = tab
      AND pg_catalog.obj_description(i.oid, 'pg_class') IS NOT NULL
  )
  SELECT kind, name, detail
  FROM (
    SELECT * FROM cols
    UNION ALL SELECT * FROM cons
    UNION ALL SELECT * FROM idx
    UNION ALL SELECT * FROM comments
  ) s
  ORDER BY kind, name;
$$;

-- Test 3: statement (line 9)
DROP TABLE IF EXISTS t;
CREATE TABLE t (k INT PRIMARY KEY, v INT);

-- let $t_id
-- SELECT id FROM system.namespace WHERE name = 't'
-- Cockroach-only: numeric table reference by descriptor ID.

-- Test 4: statement (line 15)
-- SELECT * from [$t_id as num_ref]

-- Test 5: statement (line 18)
SELECT table_schema, table_name, lower(grantee) AS grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't'
ORDER BY grantee, privilege_type;

-- Test 6: statement (line 21)
-- (covered by role setup above)

-- Test 7: statement (line 24)
GRANT ALL ON TABLE t TO bar WITH GRANT OPTION;

-- Test 8: statement (line 27)
REVOKE ALL ON TABLE t FROM bar;

-- Test 9: statement (line 30)
INSERT INTO t VALUES (1, 1), (2, 2);

-- Test 10: statement (line 33)
SELECT * FROM t ORDER BY k;

-- Test 11: statement (line 36)
DELETE FROM t;

-- Test 12: statement (line 39)
DELETE FROM t WHERE k = 1;

-- Test 13: statement (line 42)
UPDATE t SET v = 0;

-- Test 14: statement (line 45)
UPDATE t SET v = 2 WHERE k = 2;

-- Test 15: statement (line 48)
-- Cockroach-only: schema_locked table option.

-- Test 16: statement (line 51)
TRUNCATE t;

-- Test 17: statement (line 54)
-- Cockroach-only: schema_locked table option.

-- Test 18: statement (line 57)
DROP TABLE t;

-- Test 19: statement (line 60)
CREATE TABLE t (k INT PRIMARY KEY, v INT);

-- let $t_id
-- SELECT id FROM system.namespace WHERE name = 't'

-- Test 20: statement (line 70)
-- Already connected to database a.

-- Test 21: statement (line 73)
SELECT table_schema, table_name, lower(grantee) AS grantee, privilege_type, is_grantable
FROM information_schema.role_table_grants
WHERE table_schema = 'public' AND table_name = 't'
ORDER BY grantee, privilege_type;

-- Test 22: statement (line 76)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false) WHERE kind = 'column';

-- Test 23: statement (line 79)
\set ON_ERROR_STOP 0
SELECT r FROM t;
\set ON_ERROR_STOP 1

-- Test 24: statement (line 82)
-- SELECT * from [$t_id as num_ref]

-- Test 25: statement (line 85)
GRANT ALL ON TABLE t TO bar;

-- Test 26: statement (line 88)
REVOKE ALL ON TABLE t FROM bar;

-- Test 27: statement (line 91)
INSERT INTO t VALUES (1, 1), (2, 2);

-- Test 28: statement (line 94)
SELECT * FROM t ORDER BY k;

-- Test 29: statement (line 97)
SELECT 1;

-- Test 30: statement (line 100)
DELETE FROM t;

-- Test 31: statement (line 103)
DELETE FROM t WHERE k = 1;

-- Test 32: statement (line 106)
UPDATE t SET v = 0;

-- Test 33: statement (line 109)
UPDATE t SET v = 2 WHERE k = 2;

-- Test 34: statement (line 112)
TRUNCATE t;

-- Test 35: statement (line 115)
DROP TABLE t;

-- Test 36: statement (line 121)
CREATE TABLE t (k INT PRIMARY KEY, v INT);
GRANT SELECT ON TABLE t TO testuser WITH GRANT OPTION;

-- user testuser
SET ROLE testuser;
\set ON_ERROR_STOP 0

-- Test 37: query (line 126)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false) WHERE kind = 'column';

-- Test 38: statement (line 132)
GRANT ALL ON TABLE t TO bar;

-- Test 39: statement (line 135)
REVOKE ALL ON TABLE t FROM bar;

-- Test 40: statement (line 138)
INSERT INTO t VALUES (1, 1), (2, 2);

-- Test 41: statement (line 141)
INSERT INTO t VALUES (1, 1), (2, 2)
ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- Test 42: statement (line 144)
SELECT * FROM t ORDER BY k;

-- Test 43: statement (line 147)
SELECT 1;

-- Test 44: statement (line 150)
DELETE FROM t;

-- Test 45: statement (line 153)
DELETE FROM t WHERE k = 1;

-- Test 46: statement (line 156)
UPDATE t SET v = 0;

-- Test 47: statement (line 159)
UPDATE t SET v = 2 WHERE k = 2;

-- Test 48: statement (line 162)
TRUNCATE t;

-- Test 49: statement (line 165)
DROP TABLE t;

-- Test 50: statement (line 171)
GRANT ALL ON TABLE t TO testuser WITH GRANT OPTION;

-- Test 51: statement (line 174)
REVOKE SELECT ON TABLE t FROM testuser;

-- user testuser (already)

-- Test 52: statement (line 179)
GRANT INSERT ON TABLE t TO bar WITH GRANT OPTION;

-- Test 53: statement (line 182)
REVOKE INSERT ON TABLE t FROM bar;

-- Test 54: statement (line 185)
GRANT ALL ON TABLE t TO bar;

-- Test 55: statement (line 188)
GRANT SELECT ON TABLE t TO bar;

-- Test 56: statement (line 191)
INSERT INTO t VALUES (1, 1), (2, 2);

-- Test 57: statement (line 194)
SELECT * FROM t ORDER BY k;

-- Test 58: statement (line 197)
SELECT 1;

-- Test 59: statement (line 200)
DELETE FROM t;

-- Test 60: statement (line 203)
DELETE FROM t WHERE k = 1;

-- Test 61: statement (line 206)
UPDATE t SET v = 0;

-- Test 62: statement (line 209)
UPDATE t SET v = 2 WHERE k = 2;

-- Test 63: statement (line 212)
-- Cockroach-only: schema_locked table option.

-- Test 64: statement (line 215)
TRUNCATE t;

-- Test 65: statement (line 218)
-- Cockroach-only: schema_locked table option.

-- Test 66: statement (line 221)
DROP TABLE t;

-- Back to root for DDL/GRANT setup.
RESET ROLE;
\set ON_ERROR_STOP 1

-- Test 67: statement (line 227)
DROP TABLE IF EXISTS t;
CREATE TABLE t (k INT PRIMARY KEY, v INT);

-- Test 68: statement (line 230)
GRANT ALL ON TABLE t TO testuser WITH GRANT OPTION;

-- user testuser
SET ROLE testuser;
\set ON_ERROR_STOP 0

-- Test 69: statement (line 235)
GRANT ALL ON TABLE t TO bar WITH GRANT OPTION;

-- Test 70: statement (line 238)
REVOKE ALL ON TABLE t FROM bar;

-- Test 71: statement (line 241)
INSERT INTO t VALUES (1, 1), (2, 2);

-- Test 72: statement (line 244)
SELECT * FROM t ORDER BY k;

-- Test 73: statement (line 247)
SELECT 1;

-- Test 74: statement (line 250)
DELETE FROM t;

-- Test 75: statement (line 253)
DELETE FROM t WHERE k = 1;

-- Test 76: statement (line 256)
UPDATE t SET v = 0;

-- Test 77: statement (line 259)
UPDATE t SET v = 2 WHERE k = 2;

-- Test 78: statement (line 262)
-- Cockroach-only: schema_locked table option.

-- Test 79: statement (line 265)
TRUNCATE t;

-- Test 80: statement (line 268)
-- Cockroach-only: schema_locked table option.

-- Test 81: statement (line 271)
DROP TABLE t;

-- Back to root for DDL/GRANT setup.
RESET ROLE;
\set ON_ERROR_STOP 1

-- Test 82: statement (line 277)
DROP TABLE IF EXISTS t;
CREATE TABLE t (k INT PRIMARY KEY, v INT);

-- Test 83: statement (line 280)
GRANT INSERT ON TABLE t TO testuser WITH GRANT OPTION;

-- user testuser
SET ROLE testuser;
\set ON_ERROR_STOP 0

-- Test 84: statement (line 285)
INSERT INTO t VALUES (1, 2);

-- Test 85: statement (line 288)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO NOTHING;

-- Test 86: statement (line 291)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO UPDATE SET v = excluded.v;

-- Test 87: statement (line 294)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- user root
RESET ROLE;
\set ON_ERROR_STOP 1

-- Test 88: statement (line 299)
GRANT SELECT ON TABLE t TO testuser WITH GRANT OPTION;

-- user testuser
SET ROLE testuser;
\set ON_ERROR_STOP 0

-- Test 89: statement (line 304)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO NOTHING;

-- Test 90: statement (line 307)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- Test 91: statement (line 310)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- Test 92: statement (line 316)
RESET ROLE;
\set ON_ERROR_STOP 1
GRANT UPDATE ON TABLE t TO testuser WITH GRANT OPTION;
SET ROLE testuser;
\set ON_ERROR_STOP 0

-- Test 93: statement (line 321)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- Test 94: statement (line 324)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- user root
RESET ROLE;
\set ON_ERROR_STOP 1

-- Test 95: statement (line 329)
DROP TABLE t;

-- Test 96: statement (line 334)
CREATE TABLE t (k INT PRIMARY KEY, v INT);

-- user testuser
SET ROLE testuser;
\set ON_ERROR_STOP 0

-- Test 97: statement (line 339)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false) WHERE kind = 'column';

-- Test 98: statement (line 342)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false);

-- Test 99: statement (line 345)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false) WHERE kind = 'index';

-- Test 100: statement (line 348)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false) WHERE kind = 'constraint';

-- user root
RESET ROLE;
\set ON_ERROR_STOP 1

-- Test 101: statement (line 353)
GRANT SELECT ON TABLE t TO testuser WITH GRANT OPTION;

-- user testuser
SET ROLE testuser;
\set ON_ERROR_STOP 0

-- Test 102: statement (line 358)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false) WHERE kind = 'column';

-- Test 103: statement (line 361)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false);

-- Test 104: statement (line 364)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false) WHERE kind = 'index';

-- Test 105: statement (line 367)
SELECT * FROM pg_show_create_table('public.t'::regclass, false, false) WHERE kind = 'constraint';

RESET ROLE;
\set ON_ERROR_STOP 1
\connect postgres
DROP DATABASE a;
DROP ROLE bar;
DROP ROLE testuser;

RESET client_min_messages;
