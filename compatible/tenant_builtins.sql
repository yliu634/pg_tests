-- PostgreSQL compatible tests from tenant_builtins
-- 3 tests

-- Test 1: statement (line 185)
RESET sql.defaults.vectorize;

-- Test 2: query (line 188)
SHOW sql.defaults.vectorize;

-- Test 3: statement (line 221)
SET jobs.registry.interval.adopt = '1s';
