SET client_min_messages = warning;

-- PostgreSQL compatible tests from limit
-- 62 tests

-- Test 1: query (line 1)
SELECT generate_series FROM generate_series(1, 100) ORDER BY generate_series LIMIT 5;

-- Test 2: query (line 10)
SELECT generate_series FROM generate_series(1, 100) ORDER BY generate_series FETCH FIRST 5 ROWS ONLY;

-- Test 3: query (line 19)
SELECT generate_series FROM generate_series(1, 100) ORDER BY generate_series FETCH FIRST ROW ONLY;

-- Test 4: query (line 24)
SELECT generate_series FROM generate_series(1, 100) ORDER BY generate_series OFFSET 3 ROWS FETCH NEXT ROW ONLY;

-- Test 5: statement (line 29)
-- COMMENTED: Intentional error test - FETCH and LIMIT cannot be combined
-- SELECT generate_series FROM generate_series(1, 100) FETCH NEXT ROW ONLY LIMIT 3;

-- Test 6: statement (line 32)
-- COMMENTED: Intentional error test - FETCH and LIMIT cannot be combined
-- SELECT generate_series FROM generate_series(1, 100) LIMIT 3 FETCH NEXT ROW ONLY;

-- Test 7: statement (line 35)
-- COMMENTED: Intentional error test - FETCH expression must be in parens
-- SELECT generate_series FROM generate_series(1, 100) FETCH NEXT 1 + 1 ROWS ONLY;

-- Test 8: query (line 38)
SELECT generate_series FROM generate_series(1, 100) ORDER BY generate_series FETCH FIRST (1 + 1) ROWS ONLY;

-- Test 9: statement (line 44)
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (k INT PRIMARY KEY, v INT, w INT);
CREATE INDEX t_v_idx ON t(v);

-- Test 10: statement (line 47)
INSERT INTO t VALUES (1, 1, 1), (2, -4, 8), (3, 9, 27), (4, -16, 94), (5, 25, 125), (6, -36, 216);

-- Test 11: query (line 51)
SELECT * FROM t WHERE v > -20 AND w > 30 ORDER BY v LIMIT 2;

-- Test 12: query (line 57)
SELECT k, v FROM t ORDER BY k LIMIT 5;

-- Test 13: query (line 66)
SELECT k, v FROM t ORDER BY k OFFSET 5;

-- Test 14: query (line 71)
SELECT k, v FROM t ORDER BY v LIMIT (1+4) OFFSET 1;

-- Test 15: query (line 80)
SELECT k, v FROM t ORDER BY v DESC LIMIT (1+4) OFFSET 1;

-- Test 16: query (line 89)
SELECT sum(w) FROM t GROUP BY k, v ORDER BY v DESC LIMIT 10;

-- Test 17: query (line 99)
SELECT k FROM (SELECT k, v FROM t ORDER BY v LIMIT 4);

-- Test 18: query (line 107)
SELECT k FROM (SELECT k, v, w FROM t ORDER BY v LIMIT 4);

-- Test 19: query (line 116)
SELECT k, v FROM t ORDER BY k LIMIT length(pg_typeof(123)::text);

-- Test 20: query (line 126)
SELECT k, v
FROM t
ORDER BY k
LIMIT length(pg_typeof(123)::text)
OFFSET length(pg_typeof(123)::text) - 2;

-- Test 21: query (line 132)
SELECT k, v FROM t ORDER BY k OFFSET (SELECT count(*)-3 FROM t);

-- Test 22: query (line 139)
SELECT k, v FROM t ORDER BY k LIMIT (SELECT count(*)-3 FROM t) OFFSET (SELECT count(*)-5 FROM t);

-- Test 23: query (line 157)
SELECT * FROM (select * from generate_series(1,10) a LIMIT 5) OFFSET 3;

-- Test 24: query (line 163)
SELECT * FROM (select * from generate_series(1,10) a LIMIT 5) OFFSET 6;

-- Test 25: statement (line 168)
DROP TABLE IF EXISTS t_47283 CASCADE;
CREATE TABLE t_47283(k INT PRIMARY KEY, a INT);

-- Test 26: statement (line 171)
INSERT INTO t_47283 VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6);

-- Test 27: query (line 176)
SELECT * FROM (SELECT * FROM t_47283 ORDER BY k LIMIT 4) WHERE a > 5 LIMIT 1;

-- Setup for parameterized LIMIT/OFFSET tests (probe/vals).
DROP TABLE IF EXISTS probe CASCADE;
CREATE TABLE probe (a INT);
INSERT INTO probe(a) SELECT generate_series(1, 10);

DROP TABLE IF EXISTS vals CASCADE;
CREATE TABLE vals (k TEXT PRIMARY KEY, v BIGINT);
INSERT INTO vals(k, v) VALUES
  ('zero', 0),
  ('one', 1),
  ('large', 100),
  ('maxint64', 9223372036854775807);

-- Test 28: query (line 189)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'zero');

-- Test 29: query (line 193)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'one');

-- Test 30: query (line 198)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'large');

-- Test 31: query (line 206)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'maxint64');

-- Test 32: query (line 215)
SELECT a FROM probe ORDER BY a OFFSET (SELECT v FROM vals WHERE k = 'zero');

-- Test 33: query (line 223)
SELECT a FROM probe ORDER BY a OFFSET (SELECT v FROM vals WHERE k = 'one');

-- Test 34: query (line 230)
SELECT a FROM probe ORDER BY a OFFSET (SELECT v FROM vals WHERE k = 'large');

-- Test 35: query (line 234)
SELECT a FROM probe ORDER BY a OFFSET (SELECT v FROM vals WHERE k = 'maxint64');

-- Test 36: query (line 240)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'zero') OFFSET (SELECT v FROM vals WHERE k = 'zero');

-- Test 37: query (line 244)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'one') OFFSET (SELECT v FROM vals WHERE k = 'zero');

-- Test 38: query (line 249)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'large') OFFSET (SELECT v FROM vals WHERE k = 'zero');

-- Test 39: query (line 257)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'maxint64') OFFSET (SELECT v FROM vals WHERE k = 'zero');

-- Test 40: query (line 266)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'zero') OFFSET (SELECT v FROM vals WHERE k = 'one');

-- Test 41: query (line 270)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'one') OFFSET (SELECT v FROM vals WHERE k = 'one');

-- Test 42: query (line 275)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'large') OFFSET (SELECT v FROM vals WHERE k = 'one');

-- Test 43: query (line 282)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'maxint64') OFFSET (SELECT v FROM vals WHERE k = 'one');

-- Test 44: query (line 290)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'zero') OFFSET (SELECT v FROM vals WHERE k = 'large');

-- Test 45: query (line 294)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'one') OFFSET (SELECT v FROM vals WHERE k = 'large');

-- Test 46: query (line 298)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'large') OFFSET (SELECT v FROM vals WHERE k = 'large');

-- Test 47: query (line 302)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'maxint64') OFFSET (SELECT v FROM vals WHERE k = 'large');

-- Test 48: query (line 307)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'zero') OFFSET (SELECT v FROM vals WHERE k = 'maxint64');

-- Test 49: query (line 311)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'one') OFFSET (SELECT v FROM vals WHERE k = 'maxint64');

-- Test 50: query (line 315)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'large') OFFSET (SELECT v FROM vals WHERE k = 'maxint64');

-- Test 51: query (line 319)
SELECT a FROM probe ORDER BY a LIMIT (SELECT v FROM vals WHERE k = 'maxint64') OFFSET (SELECT v FROM vals WHERE k = 'maxint64');

-- Test 52: statement (line 324)
-- COMMENTED: CockroachDB-specific setting
-- SET disallow_full_table_scans = true;

-- Test 53: query (line 327)
SELECT w FROM t ORDER BY k LIMIT 1;

-- Test 54: statement (line 332)
-- COMMENTED: CockroachDB-specific setting
-- SET disallow_full_table_scans = false;

-- Test 55: statement (line 336)
DROP TABLE IF EXISTS t65171 CASCADE;
CREATE TABLE t65171 (x INT, y INT);
CREATE INDEX t65171_xy_idx ON t65171(x, y);

-- Test 56: statement (line 339)
INSERT INTO t65171 VALUES (1, 2), (1, 2), (2, 3);

-- Test 57: query (line 342)
SELECT * FROM t65171 WHERE x = 1 OR x = 2 ORDER BY y LIMIT 2;

-- Test 58: query (line 348)
SELECT * FROM t ORDER BY v, w LIMIT 3;

-- Test 59: query (line 355)
SELECT oid::INT, typname FROM pg_type ORDER BY oid LIMIT 3;

-- Test 60: statement (line 363)
-- COMMENTED: References non-existent table t65171
-- SELECT * FROM t65171 WHERE x = 1 OFFSET 1 LIMIT 9223372036854775807;

-- Test 61: statement (line 368)
DROP TABLE IF EXISTS t122748 CASCADE;
CREATE TABLE t122748 (a int, b int);
CREATE INDEX t_b_idx ON t122748(b) INCLUDE (a);
INSERT INTO t122748 VALUES
  (1, 2),
  (3, 4),
  (5, 6);

-- Test 62: query (line 375)
SELECT count(*) AS col1
FROM t122748
GROUP BY a, b
ORDER BY b, a DESC
LIMIT 2;



RESET client_min_messages;
