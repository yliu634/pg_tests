-- PostgreSQL compatible tests from retry
-- 2 tests

-- Test 1: statement (line 1)
CREATE SEQUENCE s START 1 INCREMENT 1;
SELECT nextval('s')

-- Test 2: query (line 9)
SELECT
  CASE subq.val
    WHEN 2 THEN crdb_internal.force_error('bad', 'wrong')
    ELSE 0
  END
FROM (SELECT nextval('s') AS val) subq

