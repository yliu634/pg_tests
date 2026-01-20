-- PostgreSQL compatible tests from gc_job_mixed
-- 6 tests

-- Test 1: statement (line 3)
CREATE DATABASE db

-- Test 2: statement (line 14)
ALTER TABLE db.kv ALTER PRIMARY KEY USING COLUMNS (k)

-- Test 3: statement (line 17)
DROP TABLE db.kv

-- Test 4: statement (line 20)
DROP DATABASE db

-- Test 5: query (line 23)
SELECT description FROM crdb_internal.jobs WHERE job_type = 'SCHEMA CHANGE GC'

-- Test 6: query (line 30)
SELECT count(*) FROM crdb_internal.lost_descriptors_with_data

