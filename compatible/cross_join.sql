-- PostgreSQL compatible tests from cross_join
-- 2 tests

-- Test 1: statement (line 87)
CREATE TABLE t105882 (c0 INT);
UPSERT INTO t105882 (c0) VALUES(1);

-- Test 2: query (line 91)
SELECT (
  SELECT count(t2.rowid) FROM t105882 t2
  WHERE ((t1.rowid) IN (SELECT max(t3.rowid) FROM t105882 t3))
)
FROM t105882 t1;

