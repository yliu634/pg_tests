-- PostgreSQL compatible tests from drop_temp
-- 12 tests

SET client_min_messages = warning;
DROP ROLE IF EXISTS tmp_dropper;
DROP ROLE IF EXISTS root;
CREATE USER root SUPERUSER;

-- Test 1: statement (line 8)
SET ROLE root;
CREATE TEMP TABLE t_tmp(X int);

-- Test 2: statement (line 11)
CREATE TEMP SEQUENCE s_tmp START 1 INCREMENT 1;

-- Test 3: statement (line 14)
CREATE USER tmp_dropper;

-- Test 4: statement (line 17)
SET ROLE tmp_dropper;

-- Test 5: statement (line 20)
\set ON_ERROR_STOP 0
DROP TABLE t_tmp;

-- Test 6: statement (line 23)
DROP SEQUENCE s_tmp;
\set ON_ERROR_STOP 1

-- Test 7: statement (line 26)
SET ROLE root;

-- Test 8: statement (line 29)
-- CockroachDB supports a DROP privilege. PostgreSQL uses ownership for DROP, so
-- transfer ownership to allow tmp_dropper to drop these temp objects.
ALTER TABLE t_tmp OWNER TO tmp_dropper;
ALTER SEQUENCE s_tmp OWNER TO tmp_dropper;

-- Test 9: statement (line 34)
SET ROLE tmp_dropper;

-- Test 10: statement (line 37)
DROP TABLE t_tmp;

-- Test 11: statement (line 40)
DROP SEQUENCE s_tmp;

-- Test 12: statement (line 43)
SET ROLE root;

RESET client_min_messages;
