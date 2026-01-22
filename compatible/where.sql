-- PostgreSQL compatible tests from where
-- 19 tests

-- Test 1: statement (line 2)
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT
);

CREATE TABLE kvString (
  k TEXT PRIMARY KEY,
  v TEXT
);

-- Test 2: statement (line 8)
INSERT INTO kv VALUES (1, 2), (3, 4), (5, 6), (7, 8);

-- Test 3: statement (line 17)
INSERT INTO kvString VALUES ('like1', 'hell%'), ('like2', 'worl%');

-- Test 4: query (line 20)
SELECT * FROM kv WHERE True;

-- Test 5: query (line 28)
SELECT * FROM kv WHERE False;

-- Test 6: query (line 32)
SELECT * FROM kv WHERE k IN (1, 3);

-- Test 7: query (line 38)
SELECT * FROM kv WHERE v IN (6);

-- Test 8: query (line 43)
SELECT * FROM kv WHERE k IN (SELECT k FROM kv);

-- Test 9: query (line 51)
SELECT * FROM kv WHERE (k,v) IN (SELECT * FROM kv);

-- Test 10: query (line 59)
-- CockroachDB expects an error here (column does not exist).
-- Wrap in PL/pgSQL so the file produces no psql ERROR lines under PostgreSQL.
DO $$
BEGIN
  PERFORM 1 FROM kv WHERE nonexistent = 1;
EXCEPTION
  WHEN undefined_column THEN
    RAISE NOTICE 'expected failure: %', SQLERRM;
END
$$;

-- query B
SELECT 'hello' LIKE v FROM kvString WHERE k LIKE 'like%' ORDER BY k;

-- Test 11: query (line 68)
SELECT 'hello' SIMILAR TO v FROM kvString WHERE k SIMILAR TO 'like[1-2]' ORDER BY k;

-- Test 12: query (line 74)
SELECT 'hello' ~ replace(v, '%', '.*') FROM kvString WHERE k ~ 'like[1-2]' ORDER BY k;

-- Test 13: query (line 82)
SELECT * FROM kv WHERE k IN (1, 5.0, 9);

-- Test 14: statement (line 89)
CREATE TABLE ab (a INT, b INT);

-- Test 15: statement (line 92)
INSERT INTO ab VALUES (1, 10), (2, 20), (3, 30), (4, NULL), (NULL, 50), (NULL, NULL);

-- Test 16: query (line 95)
SELECT * FROM ab WHERE a IN (1, 3, 4);

-- Test 17: query (line 102)
SELECT * FROM ab WHERE a IN (1, 3, 4, NULL);

-- Test 18: query (line 109)
SELECT * FROM ab WHERE (a, b) IN ((1, 10), (3, 30), (4, 40));

-- Test 19: query (line 115)
SELECT * FROM ab WHERE (a, b) IN ((1, 10), (4, NULL), (NULL, 50));
