-- PostgreSQL compatible tests from proc_invokes_proc
-- 25 tests

-- Test 1: statement (line 1)
CREATE PROCEDURE a() LANGUAGE SQL AS $$
  SELECT 1;
$$;

-- Test 2: statement (line 6)
CREATE PROCEDURE b() LANGUAGE SQL AS $$
  CALL a();
$$;

-- Test 3: statement (line 12)
CREATE OR REPLACE PROCEDURE a() LANGUAGE SQL AS $$
  CALL b();
$$;

-- Test 4: statement (line 17)
DROP PROCEDURE a();

-- Test 5: statement (line 20)
DROP PROCEDURE b();
\set ON_ERROR_STOP 0
DROP PROCEDURE a();
\set ON_ERROR_STOP 1

-- Test 6: statement (line 24)
CREATE TYPE e AS ENUM ('foo', 'bar');

-- Test 7: statement (line 27)
CREATE PROCEDURE a() LANGUAGE SQL AS $$
  SELECT 'foo'::e;
$$;

-- Test 8: statement (line 32)
CREATE PROCEDURE b() LANGUAGE SQL AS $$
  CALL a();
$$;

-- Test 9: statement (line 37)
DROP TYPE e;

-- Test 10: statement (line 40)
DROP PROCEDURE b();
DROP PROCEDURE a();
\set ON_ERROR_STOP 0
DROP TYPE e;
\set ON_ERROR_STOP 1

-- Test 11: statement (line 45)
CREATE TABLE ab (
  a INT PRIMARY KEY,
  b INT
);

-- Test 12: statement (line 51)
CREATE PROCEDURE ins_ab(new_a INT, new_b INT) LANGUAGE SQL AS $$
  INSERT INTO ab VALUES (new_a, new_b);
$$;

-- Test 13: statement (line 56)
CREATE PROCEDURE ins3() LANGUAGE SQL AS $$
  CALL ins_ab(1, 10);
  CALL ins_ab(2, 20);
  CALL ins_ab(3, 30);
$$;

-- Test 14: statement (line 63)
CALL ins_ab(4, 40);

-- Test 15: statement (line 66)
CALL ins3();

-- Test 16: statement (line 69)
\set ON_ERROR_STOP 0
CALL ins3();
\set ON_ERROR_STOP 1

-- Test 17: query (line 72)
SELECT * FROM ab;

-- Test 18: statement (line 84)
DROP PROCEDURE ins_ab(INT, INT);

-- Test 19: statement (line 87)
DROP PROCEDURE ins3();
\set ON_ERROR_STOP 0
DROP PROCEDURE ins_ab(INT, INT);
\set ON_ERROR_STOP 1
DROP TABLE ab;

-- Test 20: statement (line 92)
CREATE TABLE i (i INT);

-- Test 21: statement (line 95)
CREATE PROCEDURE insert1(n INT) LANGUAGE SQL AS $$
  INSERT INTO i VALUES (n);
$$;

-- Test 22: statement (line 100)
CREATE PROCEDURE insert2(n INT) LANGUAGE SQL AS $$
  CALL insert1(n);
$$;

-- Test 23: statement (line 105)
CALL insert2(11);

-- Test 24: query (line 108)
SELECT * FROM i;

-- Test 25: statement (line 113)
DROP PROCEDURE insert2(INT);
DROP PROCEDURE insert1(INT);
DROP TABLE i;
