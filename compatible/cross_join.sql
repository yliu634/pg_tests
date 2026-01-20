-- PostgreSQL compatible tests from cross_join
-- 2 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS t105882;
RESET client_min_messages;

-- Test 1: statement (line 87)
CREATE TABLE t105882 (c0 INT);
INSERT INTO t105882 (c0) VALUES(1);

-- Test 2: query (line 91)
SELECT (
  SELECT count(t2.ctid) FROM t105882 t2
  WHERE ((t1.ctid) IN (SELECT max(t3.ctid) FROM t105882 t3))
)
FROM t105882 t1;
