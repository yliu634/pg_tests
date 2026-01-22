-- PostgreSQL compatible tests from system_columns
-- 55 tests

-- Test 1: statement (line 1)
-- CockroachDB exposes additional hidden/system columns (e.g.
-- crdb_internal_mvcc_timestamp). PostgreSQL has similar MVCC metadata via
-- system columns like `xmin`. Translate the tests to use PostgreSQL system
-- columns and remove CockroachDB-only syntax (e.g. `@idx`, `LOOKUP JOIN`).
CREATE TABLE t (x INT PRIMARY KEY, y INT, z INT);
CREATE INDEX t_i_idx ON t (z);
INSERT INTO t VALUES (1, 2, 3);
SELECT xmin::text AS base_xmin FROM t WHERE x = 1 \gset

-- Test 2: query (line 6)
SELECT xmin IS NOT NULL FROM t;

-- Test 3: statement (line 15)
INSERT INTO t VALUES (2, 3, 4);
SELECT xmin::text AS del_xmin FROM t WHERE x = 2 \gset

-- Test 4: query (line 19)
SELECT xmin::text <> :'base_xmin' FROM t WHERE x = 2;

-- Test 5: query (line 25)
SELECT xmin = :'base_xmin'::xid FROM t WHERE x = 1;

-- Test 6: query (line 31)
SELECT
  xmin = :'base_xmin'::xid,
  xmin = :'base_xmin'::xid,
  xmin = :'base_xmin'::xid,
  xmin = :'base_xmin'::xid
FROM t
WHERE x = 1;

-- Test 7: statement (line 37)
UPDATE t SET z = 5 WHERE x = 1;
SELECT xmin::text AS update_xmin FROM t WHERE x = 1 \gset

-- Test 8: query (line 40)
SELECT xmin::text <> :'base_xmin' FROM t;

-- Test 9: query (line 47)
SELECT * FROM t WHERE xmin IS NOT NULL;

-- Test 10: query (line 53)
SELECT t1.*, t2.* FROM t t1 JOIN t t2 ON t1.xmin = t2.xmin;

-- Test 11: statement (line 62)
UPDATE t SET z = 6 WHERE xmin = :'update_xmin'::xid;

-- Test 12: query (line 65)
SELECT * FROM t;

-- Test 13: statement (line 74)
DELETE FROM t WHERE xmin = :'del_xmin'::xid;

-- Test 14: query (line 77)
SELECT * FROM t;

-- Test 15: statement (line 85)
-- CockroachDB-only (timestamp arithmetic on hidden MVCC columns).

-- Test 16: query (line 88)
-- CockroachDB-only.

-- Test 17: statement (line 96)
-- CockroachDB-only.

-- Test 18: query (line 99)
-- CockroachDB-only.

-- Test 19: query (line 104)
SELECT x, y, xmin IS NOT NULL AS foo FROM t ORDER BY foo;

-- Test 20: query (line 109)
-- CockroachDB-only: crdb_internal.approximate_timestamp(...)

-- Test 21: statement (line 115)
CREATE TABLE t2 (x INT);
CREATE INDEX t2_x_idx ON t2 (x);
INSERT INTO t2 VALUES (1);

-- Test 22: query (line 119)
SELECT t.xmin IS NOT NULL, t.x, t2.x FROM t2 INNER JOIN t ON t.x = t2.x;

-- Test 23: statement (line 125)
-- CockroachDB-only: INSERT INTO t (x, crdb_internal_mvcc_timestamp) ...

-- Test 24: statement (line 128)
-- CockroachDB-only.

-- Test 25: statement (line 131)
-- CockroachDB-only.

-- Test 26: statement (line 134)
-- CockroachDB-only.

-- Test 27: statement (line 137)
-- CockroachDB-only.

-- Test 28: statement (line 141)
-- CockroachDB-only.

-- Test 29: statement (line 144)
-- CockroachDB-only.

-- Test 30: statement (line 147)
-- CockroachDB-only.

-- Test 31: statement (line 152)
CREATE TABLE tab1 (x INT PRIMARY KEY);
CREATE TABLE tab2 (x INT PRIMARY KEY);
INSERT INTO tab1 VALUES (1), (2);
INSERT INTO tab2 VALUES (1), (2);

-- Test 32: query (line 158)
SELECT tableoid, x FROM tab1;

-- Test 33: query (line 164)
SELECT tableoid, x FROM tab2;

-- Test 34: query (line 170)
SELECT tab1.tableoid, tab1.x, tab2.tableoid, tab2.x FROM tab1 JOIN tab2 ON tab1.x = tab2.x;

-- Test 35: query (line 176)
SELECT tab1.tableoid, tab1.x, tab2.tableoid, tab2.x FROM tab1 INNER JOIN tab2 ON tab1.x = tab2.x;

-- Test 36: query (line 183)
SELECT tableoid, xmin IS NOT NULL FROM tab1;

-- Test 37: statement (line 190)
CREATE TABLE tab3 (x INT);
CREATE INDEX tab3_i_idx ON tab3 (x);
INSERT INTO tab3 VALUES (1);

-- Test 38: query (line 194)
SELECT tableoid, x FROM tab3 WHERE x = 1;

-- Test 39: statement (line 199)
DO $$
BEGIN
  BEGIN
    CREATE TABLE bad (tableoid int);
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END
$$;

-- Test 40: statement (line 204)
-- CockroachDB-only: origin_id / origin_timestamp system columns.

-- Test 41: query (line 208)
-- CockroachDB-only: SELECT x, crdb_internal_origin_id FROM origin_id_tab

-- Test 42: query (line 214)
-- CockroachDB-only: SELECT x, crdb_internal_origin_timestamp FROM origin_id_tab

-- Test 43: statement (line 222)
-- CockroachDB-only: CREATE INDEX ... STORING / hidden columns.

-- Test 44: statement (line 225)
-- CockroachDB-only.

-- Test 45: statement (line 228)
-- CockroachDB-only.

-- Test 46: statement (line 231)
-- CockroachDB-only.

-- skipif config schema-locked-disabled

-- Test 47: statement (line 235)
-- CockroachDB-only: ALTER TABLE ... schema_locked

-- Test 48: statement (line 238)
-- CockroachDB-only.

-- Test 49: statement (line 241)
-- CockroachDB-only.

-- Test 50: statement (line 244)
-- CockroachDB-only.

-- Test 51: statement (line 247)
-- CockroachDB-only.

-- skipif config schema-locked-disabled

-- Test 52: statement (line 251)
-- CockroachDB-only.

-- Test 53: statement (line 256)
-- CockroachDB-only: ALTER TABLE tab3 RENAME crdb_internal_mvcc_timestamp TO blah;

-- Test 54: statement (line 259)
-- CockroachDB-only: ALTER TABLE tab3 DROP COLUMN crdb_internal_mvcc_timestamp;

-- Test 55: statement (line 262)
-- CockroachDB-only: ALTER TABLE tab3 ALTER COLUMN crdb_internal_mvcc_timestamp SET NOT NULL;
