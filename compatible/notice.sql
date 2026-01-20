-- PostgreSQL compatible tests from notice
-- 12 tests

-- Test 1: query (line 3)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.notice('hi'), crdb_internal.notice('i am....'), crdb_internal.notice('otan!!!');

-- Test 2: query (line 12)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.notice('debug1', 'do not see this'), crdb_internal.notice('warning', 'but you see this'), crdb_internal.notice('debug2', 'and never this');

-- Test 3: statement (line 17)
SET client_min_messages = 'debug1';

-- Test 4: query (line 20)
-- COMMENTED: CockroachDB-specific: SELECT crdb_internal.notice('debug1', 'now you see this'), crdb_internal.notice('warning', 'and you see this'), crdb_internal.notice('debug2', 'and never this');

-- Test 5: statement (line 26)
DROP SCHEMA IF EXISTS d CASCADE;
CREATE SCHEMA d;
CREATE TABLE d.t (x int);

-- Test 6: query (line 32)
ALTER TABLE d.t RENAME TO t2;

-- Test 7: statement (line 39)
DROP TYPE IF EXISTS color;
CREATE TYPE color AS ENUM ('white');

-- Test 8: statement (line 42)
ALTER TYPE color ADD VALUE 'black';

-- Test 9: query (line 47)
ALTER TYPE color ADD VALUE IF NOT EXISTS 'black';

-- Test 10: statement (line 52)
DROP MATERIALIZED VIEW IF EXISTS v;
CREATE MATERIALIZED VIEW v AS SELECT 1 AS id;
CREATE UNIQUE INDEX v_id_uidx ON v (id);

-- Test 11: query (line 57)
REFRESH MATERIALIZED VIEW CONCURRENTLY v;

-- Test 12: query (line 62)
UNLISTEN temp;
