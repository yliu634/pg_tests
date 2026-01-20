-- PostgreSQL compatible tests from system_columns
-- 55 tests

-- Test 1: statement (line 1)
CREATE TABLE t (x INT PRIMARY KEY, y INT, z INT, INDEX i (z));
INSERT INTO t VALUES (1, 2, 3)

-- Test 2: query (line 6)
SELECT crdb_internal_mvcc_timestamp IS NOT NULL FROM t

-- Test 3: statement (line 15)
INSERT INTO t VALUES (2, 3, 4)

-- Test 4: query (line 19)
SELECT crdb_internal_mvcc_timestamp > $base_ts FROM t WHERE x = 2

-- Test 5: query (line 25)
SELECT crdb_internal_mvcc_timestamp = $base_ts FROM t@i WHERE x = 1

-- Test 6: query (line 31)
SELECT crdb_internal_mvcc_timestamp = $base_ts, crdb_internal_mvcc_timestamp = $base_ts, crdb_internal_mvcc_timestamp = $base_ts, crdb_internal_mvcc_timestamp = $base_ts FROM t@i WHERE x = 1

-- Test 7: statement (line 37)
UPDATE t SET z = 5 WHERE x = 1

-- Test 8: query (line 40)
SELECT crdb_internal_mvcc_timestamp > $base_ts FROM t

-- Test 9: query (line 47)
SELECT * FROM t WHERE crdb_internal_mvcc_timestamp IS NOT NULL

-- Test 10: query (line 53)
SELECT t1.*, t2.* FROM t t1 JOIN t t2 ON t1.crdb_internal_mvcc_timestamp = t2.crdb_internal_mvcc_timestamp

-- Test 11: statement (line 62)
UPDATE t SET z = 6 WHERE crdb_internal_mvcc_timestamp = $update_ts

-- Test 12: query (line 65)
SELECT * FROM t

-- Test 13: statement (line 74)
DELETE FROM t WHERE crdb_internal_mvcc_timestamp = $del_ts

-- Test 14: query (line 77)
SELECT * FROM t

-- Test 15: statement (line 85)
UPDATE t SET z = (crdb_internal_mvcc_timestamp + 1.0)::INT WHERE x = 1

-- Test 16: query (line 88)
SELECT z = ($update_ts + 1.0)::INT FROM t WHERE x = 1

-- Test 17: statement (line 96)
INSERT INTO t VALUES (1, 2, 3) ON CONFLICT (x) DO UPDATE SET z = (crdb_internal_mvcc_timestamp + 1.0)::INT

-- Test 18: query (line 99)
SELECT z = ($update_ts + 1.0)::INT FROM t WHERE x = 1

-- Test 19: query (line 104)
SELECT x, y, crdb_internal_mvcc_timestamp IS NOT NULL AS foo FROM t ORDER BY foo

-- Test 20: query (line 109)
SELECT crdb_internal.approximate_timestamp(crdb_internal_mvcc_timestamp) < now() FROM t

-- Test 21: statement (line 115)
CREATE TABLE t2 (x INT, INDEX (x));
INSERT INTO t2 VALUES (1)

-- Test 22: query (line 119)
SELECT t.crdb_internal_mvcc_timestamp IS NOT NULL, t.x, t2.x FROM t2 INNER LOOKUP JOIN t ON t.x = t2.x

-- Test 23: statement (line 125)
INSERT INTO t (x, crdb_internal_mvcc_timestamp) VALUES (1, 0)

-- Test 24: statement (line 128)
UPDATE t SET crdb_internal_mvcc_timestamp = 1.0 WHERE x = 1

-- Test 25: statement (line 131)
UPSERT INTO t (x, crdb_internal_mvcc_timestamp) VALUES (1, 0)

-- Test 26: statement (line 134)
INSERT INTO t VALUES (7, 8, 9, 1.0)

-- Test 27: statement (line 137)
INSERT INTO t VALUES (1, 2, 3) RETURNING crdb_internal_mvcc_timestamp

-- Test 28: statement (line 141)
CREATE TABLE bad (crdb_internal_mvcc_timestamp int)

-- Test 29: statement (line 144)
ALTER TABLE t ADD COLUMN crdb_internal_mvcc_timestamp INT

-- Test 30: statement (line 147)
ALTER TABLE t RENAME COLUMN x TO crdb_internal_mvcc_timestamp

-- Test 31: statement (line 152)
CREATE TABLE tab1 (x INT PRIMARY KEY);
CREATE TABLE tab2 (x INT PRIMARY KEY);
INSERT INTO tab1 VALUES (1), (2);
INSERT INTO tab2 VALUES (1), (2);

-- Test 32: query (line 158)
SELECT tableoid, x FROM tab1

-- Test 33: query (line 164)
SELECT tableoid, x FROM tab2

-- Test 34: query (line 170)
SELECT tab1.tableoid, tab1.x, tab2.tableoid, tab2.x FROM tab1 JOIN tab2 ON tab1.x = tab2.x

-- Test 35: query (line 176)
SELECT tab1.tableoid, tab1.x, tab2.tableoid, tab2.x FROM tab1 INNER LOOKUP JOIN tab2 ON tab1.x = tab2.x

-- Test 36: query (line 183)
SELECT tableoid, crdb_internal_mvcc_timestamp IS NOT NULL FROM tab1

-- Test 37: statement (line 190)
CREATE TABLE tab3 (x INT, INDEX i (x));
INSERT INTO tab3 VALUES (1)

-- Test 38: query (line 194)
SELECT tableoid, x FROM tab3@i WHERE x = 1

-- Test 39: statement (line 199)
CREATE TABLE bad (tableoid int)

-- Test 40: statement (line 204)
CREATE TABLE origin_id_tab (x INT PRIMARY KEY);
INSERT INTO origin_id_tab VALUES (1), (2);

-- Test 41: query (line 208)
SELECT x, crdb_internal_origin_id FROM origin_id_tab

-- Test 42: query (line 214)
SELECT x, crdb_internal_origin_timestamp FROM origin_id_tab

-- Test 43: statement (line 222)
CREATE INDEX idx ON tab3(x, tableoid)

-- Test 44: statement (line 225)
CREATE INDEX idx ON tab3(x, crdb_internal_mvcc_timestamp)

-- Test 45: statement (line 228)
CREATE INDEX idx ON tab3(x) STORING (tableoid)

-- Test 46: statement (line 231)
CREATE INDEX idx ON tab3(x) STORING (crdb_internal_mvcc_timestamp)

skipif config schema-locked-disabled

-- Test 47: statement (line 235)
ALTER TABLE tab3 SET (schema_locked=false)

-- Test 48: statement (line 238)
CREATE INDEX idx ON tab3(x, (crdb_internal_mvcc_timestamp + 10))

-- Test 49: statement (line 241)
CREATE INDEX idx ON tab3(x, crdb_internal_origin_id)

-- Test 50: statement (line 244)
CREATE INDEX idx ON tab3(x) STORING (crdb_internal_origin_id)

-- Test 51: statement (line 247)
CREATE INDEX idx ON tab3(x, (crdb_internal_origin_id + 10))

skipif config schema-locked-disabled

-- Test 52: statement (line 251)
ALTER TABLE tab3 SET (schema_locked=true)

-- Test 53: statement (line 256)
ALTER TABLE tab3 RENAME crdb_internal_mvcc_timestamp TO blah;

-- Test 54: statement (line 259)
ALTER TABLE tab3 DROP COLUMN crdb_internal_mvcc_timestamp;

-- Test 55: statement (line 262)
ALTER TABLE tab3 ALTER COLUMN crdb_internal_mvcc_timestamp SET NOT NULL;

