-- PostgreSQL compatible tests from show_fingerprints
-- 32 tests

-- Test 1: statement (line 1)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c INT, d INT, INDEX (b) STORING (d))

-- Test 2: query (line 11)
SHOW FINGERPRINTS FROM TABLE t

-- Test 3: statement (line 17)
INSERT INTO t VALUES (1, 2, 3, 4), (5, 6, 7, 8), (9, 10, 11, 12)

-- Test 4: query (line 27)
SHOW FINGERPRINTS FROM TABLE t

-- Test 5: query (line 34)
SHOW FINGERPRINTS FROM TABLE t

-- Test 6: query (line 47)
SHOW FINGERPRINTS FROM TABLE t WITH EXCLUDE COLUMNS = ('c')

-- Test 7: query (line 60)
SHOW FINGERPRINTS FROM TABLE t WITH EXCLUDE COLUMNS = ('a', 'b')

-- Test 8: query (line 92)
SHOW FINGERPRINTS FROM TABLE t

-- Test 9: statement (line 99)
DROP INDEX t_b_idx1

-- Test 10: statement (line 102)
UPDATE t SET b = 9

-- Test 11: query (line 112)
SHOW FINGERPRINTS FROM TABLE t

-- Test 12: statement (line 118)
UPDATE t SET c = 10

-- Test 13: query (line 128)
SHOW FINGERPRINTS FROM TABLE t

-- Test 14: statement (line 134)
UPDATE t SET d = 10

-- Test 15: query (line 144)
SHOW FINGERPRINTS FROM TABLE t

-- Test 16: query (line 162)
SHOW FINGERPRINTS FROM TABLE t

-- Test 17: statement (line 168)
UPDATE t SET e = 'foo' WHERE a = 1;

-- Test 18: query (line 178)
SHOW FINGERPRINTS FROM TABLE t

-- Test 19: statement (line 184)
DROP INDEX t@t_b_idx

-- Test 20: query (line 193)
SHOW FINGERPRINTS FROM TABLE t

-- Test 21: query (line 204)
SHOW FINGERPRINTS FROM TABLE test.t

-- Test 22: statement (line 209)
CREATE TABLE "foo""bar" ("a""b" INT PRIMARY KEY, b INT, INDEX "id""x" (b))

-- Test 23: statement (line 212)
INSERT INTO "foo""bar" VALUES (1, 2), (3, 4), (5, 6)

-- Test 24: query (line 223)
SHOW FINGERPRINTS FROM TABLE "foo""bar"

-- Test 25: statement (line 231)
CREATE TABLE blocks (block_id INT PRIMARY KEY, raw_bytes BYTES NOT NULL)

-- Test 26: statement (line 234)
INSERT INTO blocks VALUES (1, b'\x01')

-- Test 27: query (line 242)
SHOW FINGERPRINTS FROM TABLE blocks

-- Test 28: query (line 256)
SHOW FINGERPRINTS FROM TABLE t

-- Test 29: statement (line 261)
COMMIT

-- Test 30: statement (line 264)
CREATE TABLE t_w_expr_index (a INT PRIMARY KEY, b INT, c INT AS (b + 42) STORED, INDEX (c), INDEX ((b+42)))

-- Test 31: statement (line 267)
INSERT INTO t_w_expr_index VALUES (1, 1), (2, 2), (3, 3)

-- Test 32: query (line 277)
SHOW FINGERPRINTS FROM TABLE t_w_expr_index

