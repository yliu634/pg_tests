-- PostgreSQL compatible tests from sqlliveness
-- 4 tests

-- Test 1: query (line 6)
select crdb_internal.sql_liveness_is_alive(x'1f915e98f96145a5baa9f3a42c378eb6');

-- Test 2: query (line 12)
select crdb_internal.sql_liveness_is_alive(x'deadbeef');

-- Test 3: query (line 23)
SELECT count(*) FROM system.sqlliveness WHERE crdb_internal.sql_liveness_is_alive(session_id) = false;

-- Test 4: query (line 28)
SELECT count(*) > 0 FROM system.sqlliveness WHERE crdb_internal.sql_liveness_is_alive(session_id) = true;

