-- PostgreSQL compatible tests from cross_join
-- 2 tests

-- Test 1: statement (line 87)
-- CRDB has an implicit hidden `rowid` primary key when none is declared; model it
-- explicitly for PostgreSQL.
CREATE TABLE t105882 (
  rowid BIGSERIAL PRIMARY KEY,
  c0 INT
);
INSERT INTO t105882 (c0) VALUES (1);

-- Test 2: query (line 91)
SELECT (
  SELECT count(t2.rowid) FROM t105882 t2
  WHERE ((t1.rowid) IN (SELECT max(t3.rowid) FROM t105882 t3))
)
FROM t105882 t1;
