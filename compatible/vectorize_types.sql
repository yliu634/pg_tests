-- PostgreSQL compatible tests from vectorize_types
-- 15 tests

-- Test 1: statement (line 23)
INSERT
  INTO all_types
VALUES (
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
       ),
       (
       false,
       '123',
       '2019-10-22',
       1.23,
       123,
       123,
       123,
       123,
       1.23,
       '123',
       '63616665-6630-3064-6465-616462656562',
       '2001-1-18 1:00:00.001',
       '2001-1-18 1:00:00.001-8',
       '12:34:56.123456',
       '127.0.0.1',
       '[1, "hello", {"a": ["foo", {"b": 3}]}]'
       )

-- Test 2: query (line 63)
SELECT * FROM all_types ORDER BY 1

-- Test 3: statement (line 72)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET default_int_size = 4;
CREATE TABLE t44904(c0 INT);
INSERT INTO t44904 VALUES(0);
COMMIT

-- Test 4: query (line 79)
SELECT CAST(0 BETWEEN(CASE NULL WHEN c0 = 0 THEN NULL END) AND 0 IS TRUE AS INT) FROM t44904

-- Test 5: statement (line 86)
CREATE TABLE t45038(c0 INT); INSERT INTO t45038 VALUES(NULL)

-- Test 6: query (line 89)
SELECT sum(c) FROM (SELECT CAST((IF(IF(false, false, c0 IS NULL), NULL, NULL)) BETWEEN 0 AND 0 IS TRUE AS INT) c FROM t45038)

-- Test 7: statement (line 94)
RESET default_int_size

-- Test 8: statement (line 99)
CREATE TABLE t46714_0(c0 INT4); CREATE TABLE t46714_1(c0 INT4); INSERT INTO t46714_0 VALUES (0); INSERT INTO t46714_1 VALUES (0)

-- Test 9: query (line 102)
SELECT 1 FROM t46714_0, t46714_1 GROUP BY t46714_0.c0 * t46714_1.c0

-- Test 10: query (line 107)
SELECT * FROM t46714_0 ORDER BY c0 + c0

-- Test 11: statement (line 114)
CREATE TABLE t47131_0(c0 INT2 UNIQUE); INSERT INTO t47131_0 VALUES(1)

-- Test 12: query (line 117)
SELECT * FROM t47131_0 WHERE (t47131_0.c0 + t47131_0.c0::INT4) = 0

-- Test 13: query (line 121)
SELECT 'a'::"char" FROM t47131_0

-- Test 14: statement (line 128)
CREATE TABLE t64676 (
  i INT,
  d DATE,
  u UUID
);
INSERT INTO t64676 VALUES
  (1, '2021-05-05', '00000000-0000-0000-0000-100000000000'),
  (2, '2021-05-05', '00000000-0000-0000-0000-200000000000'),
  (3, '2021-05-05', '00000000-0000-0000-0000-300000000000'),
  (4, '2021-05-05', '00000000-0000-0000-0000-400000000000'),
  (5, '2021-05-05', '00000000-0000-0000-0000-500000000000')

-- Test 15: statement (line 141)
SELECT i + d FROM t64676

