-- PostgreSQL compatible tests from update_from
-- 33 tests

-- Test 1: statement (line 1)
CREATE TABLE abc (a int primary key, b int, c int);

-- Test 2: statement (line 4)
INSERT INTO abc VALUES (1, 20, 300), (2, 30, 400);

-- Test 3: statement (line 8)
UPDATE abc SET b = other.b + 1, c = other.c + 1 FROM abc AS other WHERE abc.a = other.a;

-- Test 4: query (line 11)
SELECT * FROM abc;

-- Test 5: statement (line 18)
UPDATE abc SET b = other.b + 1 FROM abc AS other WHERE abc.a = other.a;

-- Test 6: query (line 21)
SELECT * FROM abc;

-- Test 7: statement (line 28)
UPDATE abc SET b = other.b + 1 FROM abc AS other WHERE abc.a = other.a AND abc.a = 1;

-- Test 8: query (line 31)
SELECT * FROM abc;

-- Test 9: statement (line 38)
CREATE TABLE new_abc (a int, b int, c int);

-- Test 10: statement (line 41)
INSERT INTO new_abc VALUES (1, 2, 3), (2, 3, 4);

-- Test 11: statement (line 44)
UPDATE abc SET b = new_abc.b, c = new_abc.c FROM new_abc WHERE abc.a = new_abc.a;

-- Test 12: query (line 47)
SELECT * FROM abc;

-- Test 13: statement (line 56)
INSERT INTO new_abc VALUES (1, 1, 1);

-- Test 14: statement (line 59)
UPDATE abc SET b = new_abc.b, c = new_abc.c FROM new_abc WHERE abc.a = new_abc.a;

-- Test 15: query (line 62)
SELECT * FROM abc;

-- Test 16: query (line 69)
UPDATE abc
SET
  b = old.b + 1, c = old.c + 2
FROM
  abc AS old
WHERE
  abc.a = old.a
RETURNING
  abc.a, abc.b AS new_b, old.b as old_b, abc.c as new_c, old.c as old_c;

-- Test 17: query (line 85)
UPDATE abc SET b = old.b + 1, c = old.c + 2 FROM abc AS old WHERE abc.a = old.a RETURNING *;

-- Test 18: statement (line 93)
CREATE TABLE abc_check (a int primary key, b int, c int, check (a > 0), check (b > 0 AND b < 10));

-- Test 19: statement (line 96)
INSERT INTO abc_check VALUES (1, 2, 3), (2, 3, 4);

-- Test 20: query (line 99)
UPDATE abc_check
SET
  b = other.b, c = other.c
FROM
  abc AS other
WHERE
  abc_check.a = other.a
RETURNING
  abc_check.a, abc_check.b, abc_check.c;

-- Test 21: query (line 114)
SELECT * FROM abc;

-- Test 22: statement (line 121)
UPDATE abc SET b = other.b, c = other.c FROM (values (1, 2, 3), (2, 3, 4)) as other ("a", "b", "c") WHERE abc.a = other.a;

-- Test 23: query (line 124)
SELECT * FROM abc;

-- Test 24: statement (line 131)
CREATE TABLE ab (a INT, b INT);

-- Test 25: statement (line 134)
CREATE TABLE ac (a INT, c INT);

-- Test 26: statement (line 137)
INSERT INTO ab VALUES (1, 200), (2, 300);

-- Test 27: statement (line 140)
INSERT INTO ac VALUES (1, 300), (2, 400);

-- Test 28: statement (line 143)
UPDATE abc SET b = ab.b, c = ac.c FROM ab, ac WHERE abc.a = ab.a AND abc.a = ac.a;

-- Test 29: query (line 146)
SELECT * FROM abc;

-- Test 30: query (line 153)
UPDATE abc
SET
  b=ab.b, c = other.c
FROM
  ab, LATERAL
    (SELECT * FROM ac WHERE ab.a=ac.a) AS other
WHERE
  abc.a=ab.a
RETURNING
  *;

-- Test 31: statement (line 170)
UPDATE abc SET a = other.a FROM (SELECT x.a FROM abc AS x) AS other WHERE abc.a=other.a;

-- Test 32: statement (line 175)
CREATE TABLE t89779 (a INT);
INSERT INTO t89779 VALUES (1);

-- Test 33: query (line 179)
UPDATE t89779 SET a = 2 FROM (VALUES (1), (1)) v(i) WHERE a = i RETURNING a;
