-- PostgreSQL compatible tests from serial
-- 15 tests

-- Test 1: statement (line 3)
CREATE TABLE serial (
  a SERIAL PRIMARY KEY,
  b INT DEFAULT 7,
  c SERIAL,
  UNIQUE (c)
);

-- Test 2: query (line 12)
SELECT
  pg_get_serial_sequence('serial', 'a') AS a_seq,
  pg_get_serial_sequence('serial', 'c') AS c_seq;

-- Test 3: statement (line 18)
-- PostgreSQL sequences do not automatically advance when inserting explicit
-- values into SERIAL columns. Sync the sequence so subsequent DEFAULT inserts
-- continue from the current max value.
INSERT INTO serial (a, b) VALUES (1, 2);
SELECT setval(pg_get_serial_sequence('serial', 'a'), (SELECT max(a) FROM serial));

-- Test 4: statement (line 28)
INSERT INTO serial (a, b) VALUES (DEFAULT, DEFAULT), (DEFAULT, 3);

-- Test 5: statement (line 31)
INSERT INTO serial (b) VALUES (2);

-- Test 6: query (line 34)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM serial;

-- Test 7: query (line 37)
SELECT a, b, c FROM serial ORDER BY a;

-- Test 8: statement (line 41)
CREATE TABLE smallbig (
  a SMALLSERIAL,
  b BIGSERIAL,
  c INT
);

-- Test 9: statement (line 48)
INSERT INTO smallbig (c) VALUES (7), (7);

-- Test 10: query (line 51)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM smallbig;

-- Test 11: query (line 54)
SELECT
  pg_get_serial_sequence('smallbig', 'a') AS a_seq,
  pg_get_serial_sequence('smallbig', 'b') AS b_seq;

-- Test 12: statement (line 60)
CREATE TABLE serial_2 ("capITALS" SERIAL);

-- Test 13: query (line 63)
SELECT pg_get_serial_sequence('serial_2', 'capITALS');

-- Test 14: statement (line 66)
CREATE SCHEMA "schema-hyphen";
CREATE TABLE "schema-hyphen"."Serial_3" ("capITALS" SERIAL);

-- Test 15: query (line 70)
SELECT pg_get_serial_sequence('"schema-hyphen"."Serial_3"', 'capITALS');
