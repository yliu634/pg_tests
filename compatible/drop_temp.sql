-- PostgreSQL compatible tests from drop_temp
-- 12 tests

-- Test 1: statement (line 8)
CREATE TEMP TABLE t_tmp(X int);

-- Test 2: statement (line 11)
CREATE TEMP SEQUENCE s_tmp START 1 INCREMENT 1;

-- Test 3: statement (line 14)
CREATE USER tmp_dropper;

-- Test 4: statement (line 17)
SET ROLE tmp_dropper;

-- Test 5: statement (line 20)
DROP TABLE t_tmp;

-- Test 6: statement (line 23)
DROP SEQUENCE s_tmp;

-- Test 7: statement (line 26)
SET ROLE root;

-- Test 8: statement (line 29)
GRANT DROP ON TABLE t_tmp to tmp_dropper;
GRANT DROP ON SEQUENCE s_tmp to tmp_dropper;

-- Test 9: statement (line 34)
SET ROLE tmp_dropper;

-- Test 10: statement (line 37)
DROP TABLE t_tmp;

-- Test 11: statement (line 40)
DROP SEQUENCE s_tmp;

-- Test 12: statement (line 43)
SET ROLE root;

