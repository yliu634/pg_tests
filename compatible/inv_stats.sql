-- PostgreSQL compatible tests from inv_stats
-- 6 tests

-- Test 1: statement (line 4)
SET CLUSTER SETTING jobs.registry.interval.adopt = '10ms'

-- Test 2: statement (line 10)
CREATE TABLE t (j JSON, g GEOMETRY);
CREATE INVERTED INDEX ON t (j);
CREATE INVERTED INDEX ON t (g);
INSERT
INTO
  t
VALUES
  (
    '{"test": "some", "other": {"nested": true, "foo": 3}}',
    '0103000000010000000500000000000000000000000000000000000000000000000000F03F0000000000000000000000000000F03F000000000000F03F0000000000000000000000000000F03F00000000000000000000000000000000'
  );

-- Test 3: statement (line 23)
CREATE STATISTICS s FROM t

-- Test 4: query (line 45)
SHOW HISTOGRAM $hist_id_1

-- Test 5: query (line 56)
SHOW HISTOGRAM $hist_id_1

-- Test 6: statement (line 63)
CREATE TABLE t50596 (_jsonb JSONB, INVERTED INDEX (_jsonb));
INSERT INTO t50596 VALUES ('{}');
CREATE STATISTICS foo FROM t50596;
SELECT NULL FROM t50596 WHERE '1' != _jsonb;

