-- PostgreSQL compatible tests from cross_join
-- 2 tests

SET client_min_messages = warning;

DROP TABLE IF EXISTS t105882;

-- PostgreSQL has no implicit rowid; use an IDENTITY column.
CREATE TABLE t105882 (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  c0 INT
);

INSERT INTO t105882 (c0) VALUES (1);

-- Test 2: query (line 91)
SELECT (
  SELECT count(t2.id) FROM t105882 t2
  WHERE (t1.id IN (SELECT max(t3.id) FROM t105882 t3))
)
FROM t105882 t1;

RESET client_min_messages;
