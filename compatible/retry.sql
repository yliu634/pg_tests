-- PostgreSQL compatible tests from retry
-- 2 tests

CREATE SCHEMA IF NOT EXISTS crdb_internal;

-- Cockroach's crdb_internal.force_error is used to deliberately raise an error.
CREATE OR REPLACE FUNCTION crdb_internal.force_error(_code TEXT, _msg TEXT)
RETURNS INT
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE EXCEPTION '%', _msg;
END;
$$;

-- Test 1: statement (line 1)
CREATE SEQUENCE s START 1 INCREMENT 1;
SELECT nextval('s');

-- Test 2: query (line 9)
\set ON_ERROR_STOP 0
SELECT
  CASE subq.val
    WHEN 2 THEN crdb_internal.force_error('bad', 'wrong')
    ELSE 0
  END
FROM (SELECT nextval('s') AS val) subq;
\set ON_ERROR_STOP 1
