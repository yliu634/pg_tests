-- PostgreSQL compatible tests from gc_job_mixed
-- 6 tests

SET client_min_messages = warning;

-- Test 1: statement (line 3)
-- CockroachDB uses databases; in PostgreSQL we approximate with schemas.
DROP SCHEMA IF EXISTS db CASCADE;
CREATE SCHEMA db;

-- Test 2: statement (line 14)
-- `ALTER PRIMARY KEY ... USING COLUMNS` is CockroachDB-specific; approximate by
-- creating a table and adding a primary key.
CREATE TABLE db.kv (k INT);
ALTER TABLE db.kv ADD PRIMARY KEY (k);

-- Test 3: statement (line 17)
DROP TABLE db.kv;

-- Test 4: statement (line 20)
DROP SCHEMA db;

-- Test 5: query (line 23)
-- CockroachDB internal job tables do not exist in PostgreSQL; skip.
-- SELECT description FROM crdb_internal.jobs WHERE job_type = 'SCHEMA CHANGE GC';

-- Test 6: query (line 30)
-- CockroachDB internal table; skip.
-- SELECT count(*) FROM crdb_internal.lost_descriptors_with_data;
