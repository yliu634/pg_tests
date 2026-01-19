-- PostgreSQL compatible tests from numeric_references
-- 44 tests

-- Test 1: statement (line 1)
CREATE TABLE x (a INT PRIMARY KEY, xx INT, b INT, c INT, INDEX bc (b,c))

-- Test 2: statement (line 4)
INSERT INTO x VALUES (1), (2), (3)

-- Test 3: statement (line 7)
CREATE VIEW view_ref AS SELECT a, 1 FROM x

let $v_id
SELECT id FROM system.namespace WHERE name='view_ref'

-- Test 4: statement (line 13)
SELECT * FROM [$v_id(1) AS _]

-- Test 5: query (line 16)
SELECT * FROM [$v_id AS _]

-- Test 6: query (line 23)
SELECT foo.a FROM [$v_id AS foo]

-- Test 7: statement (line 30)
CREATE SEQUENCE seq

let $seq_id
SELECT id FROM system.namespace WHERE name='seq'

-- Test 8: query (line 36)
SELECT * FROM [$seq_id AS _]

-- Test 9: query (line 42)
SELECT * FROM [$seq_id(1) AS _]

-- Test 10: query (line 47)
SELECT * FROM [$seq_id(1, 2) AS _]

-- Test 11: statement (line 52)
CREATE TABLE num_ref (a INT PRIMARY KEY, xx INT, b INT, c INT, INDEX bc (b,c))

-- Test 12: statement (line 55)
CREATE TABLE num_ref_hidden (a INT, b INT)

-- Test 13: statement (line 58)
ALTER TABLE num_ref RENAME COLUMN b TO d

-- Test 14: statement (line 61)
ALTER TABLE num_ref RENAME COLUMN a TO p

-- Test 15: statement (line 64)
ALTER TABLE num_ref DROP COLUMN xx

-- Test 16: statement (line 67)
INSERT INTO num_ref VALUES (1, 10, 101), (2, 20, 200), (3, 30, 300)

-- Test 17: statement (line 70)
INSERT INTO num_ref_hidden VALUES (1, 10), (2, 20), (3, 30)

-- Test 18: query (line 73)
SELECT * FROM num_ref

-- Test 19: query (line 83)
SELECT * FROM [$num_ref_id as num_ref_alias]

-- Test 20: query (line 90)
SELECT * FROM [$num_ref_id(4,3,1) AS num_ref_alias]

-- Test 21: query (line 109)
SELECT * FROM [$num_ref_id(4) AS num_ref_alias]@[$num_ref_bc]

-- Test 22: query (line 116)
SELECT * FROM [$num_ref_id(1) AS num_ref_alias]@[$num_ref_pkey]

-- Test 23: query (line 123)
SELECT * FROM [$num_ref_id(1,3,4) AS num_ref_alias(col1,col2,col3)]

-- Test 24: statement (line 131)
UPSERT INTO [$num_ref_id AS num_ref_alias] VALUES (4, 40, 400)

-- Test 25: statement (line 134)
INSERT INTO [$num_ref_id(1) AS num_ref_alias] VALUES (5)

-- Test 26: query (line 137)
SELECT * FROM [$num_ref_id as num_ref_alias]

-- Test 27: statement (line 146)
DELETE FROM [$num_ref_id AS num_ref_alias]@bc WHERE p=5

-- Test 28: query (line 149)
DELETE FROM [$num_ref_id AS num_ref_alias] WHERE d=40 RETURNING num_ref_alias.c

-- Test 29: query (line 154)
SELECT * FROM [$num_ref_id AS num_ref_alias]

-- Test 30: statement (line 161)
INSERT INTO [$num_ref_id AS num_ref_alias] (p, c) VALUES (4, 400)

-- Test 31: query (line 164)
INSERT INTO [$num_ref_id(1,4) AS num_ref_alias] VALUES (5, 500) RETURNING num_ref_alias.d

-- Test 32: query (line 169)
SELECT * FROM [$num_ref_id AS num_ref_alias]

-- Test 33: query (line 178)
UPDATE [$num_ref_id AS num_ref_alias] SET d=40 WHERE p=4 RETURNING num_ref_alias.c

-- Test 34: query (line 183)
SELECT * FROM [$num_ref_id AS num_ref_alias]

-- Test 35: statement (line 192)
INSERT INTO [$num_ref_id(1,4) AS num_ref_alias] (p,c) VALUES (6, 600)

-- Test 36: statement (line 195)
DELETE FROM [$num_ref_id(1) AS num_ref_alias]

-- Test 37: statement (line 198)
UPDATE [$num_ref_id(1) AS num_ref_alias] SET d=10

let $num_ref_hidden_id
SELECT id FROM system.namespace WHERE name='num_ref_hidden'

-- Test 38: query (line 204)
SELECT * FROM [$num_ref_hidden_id(1,3) AS num_ref_hidden]

-- Test 39: query (line 211)
SELECT count(rowid) FROM [$num_ref_hidden_id(3) AS num_ref_hidden]

-- Test 40: statement (line 219)
SELECT * FROM [$num_ref_id AS t]

-- Test 41: statement (line 222)
INSERT INTO [$num_ref_id AS t] VALUES (1)

-- Test 42: statement (line 225)
DELETE FROM [$num_ref_id AS t]

-- Test 43: statement (line 228)
UPDATE [$num_ref_id AS t] SET d=1

-- Test 44: statement (line 234)
SELECT 1::@115210

