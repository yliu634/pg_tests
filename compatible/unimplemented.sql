-- PostgreSQL compatible tests from unimplemented
-- 14 tests

-- Test 1: statement (line 3)
CREATE TABLE legacy();

-- Test 2: statement (line 8)
CREATE POLICY p1 on legacy;

-- Test 3: statement (line 13)
ALTER POLICY p1 on legacy;

-- Test 4: statement (line 16)
DROP POLICY p1 on legacy;

-- Test 5: statement (line 19)
DROP TABLE legacy;

-- Test 6: statement (line 24)
CREATE TYPE legacy_type AS ENUM ('a', 'b');

-- Test 7: statement (line 27)
COMMENT ON TYPE legacy_type IS 'test';

-- Test 8: statement (line 32)
\set ON_ERROR_STOP 0
DROP owned by public;
\set ON_ERROR_STOP 1

-- Test 9: statement (line 37)
CREATE TABLE t (a INT, b INT);

-- Test 10: statement (line 40)
CREATE FUNCTION g() RETURNS TRIGGER LANGUAGE PLpgSQL AS $$
  BEGIN
    INSERT INTO t VALUES (1, 2);
    RETURN NULL;
  END;
$$;

-- Test 11: statement (line 48)
CREATE TRIGGER foo AFTER INSERT ON t FOR EACH ROW EXECUTE FUNCTION g();

-- Test 12: statement (line 51)
DROP TRIGGER foo ON t;

-- Test 13: statement (line 54)
DROP FUNCTION g;

-- Test 14: statement (line 57)
DROP TABLE t;
