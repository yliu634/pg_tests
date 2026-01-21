-- PostgreSQL compatible tests from float
-- 29 tests

-- Test 1: statement (line 4)
CREATE TABLE p (f float NULL);
CREATE UNIQUE INDEX p_f_idx ON p (f);

-- Test 2: statement (line 7)
INSERT INTO p VALUES (NULL), ('NaN'::float), ('Inf'::float), ('-Inf'::float), ('0'::float), (1), (-1);

-- Test 3: statement (line 12)
-- Expected ERROR (0 and -0 compare equal under PostgreSQL btree/unique semantics).
\set ON_ERROR_STOP 0
INSERT INTO p VALUES ('-0'::float);
\set ON_ERROR_STOP 1

-- Test 4: query (line 15)
SELECT * FROM p WHERE f = 'NaN';

-- Test 5: statement (line 60)
CREATE TABLE i (f float);

-- Test 6: statement (line 63)
INSERT INTO i VALUES (0), ('-0'::float);

-- Test 7: query (line 66)
SELECT * FROM i WHERE f = 0 ORDER BY f::text;

-- Test 8: statement (line 72)
CREATE INDEX i_f_asc ON i (f);

-- Test 9: query (line 75)
SELECT * FROM i WHERE f = 0 ORDER BY f::text;

-- Test 10: statement (line 81)
CREATE INDEX i_f_desc ON i (f DESC);

-- Test 11: query (line 84)
SELECT * FROM i ORDER BY f, f::text;

-- Test 12: query (line 90)
SELECT * FROM i ORDER BY f DESC, f::text DESC;

-- Test 13: statement (line 96)
-- Expected ERROR (0 and -0 are duplicates for a unique index).
\set ON_ERROR_STOP 0
CREATE UNIQUE INDEX ON i (f);
\set ON_ERROR_STOP 1

-- Test 14: statement (line 101)
CREATE TABLE vals(f FLOAT);
INSERT INTO vals VALUES
  (0.0),
  (123.4567890123456789),
  (12345678901234567890000),
  (0.0001234567890123456789);

-- Test 15: statement (line 113)
SET extra_float_digits = 3;

-- Test 16: statement (line 124)
SET extra_float_digits = -8;

-- Test 17: statement (line 135)
SET extra_float_digits = -15;

-- Test 18: statement (line 146)
DROP TABLE vals;

-- Test 19: statement (line 149)
RESET extra_float_digits;

-- Test 20: query (line 154)
SELECT -0.1234567890123456, 123456789012345.6, 1234567.890123456;

-- Test 21: statement (line 160)
-- Expected ERROR (row/record values are not numeric).
\set ON_ERROR_STOP 0
SELECT ROW()::float8 = 'NaN'::float8;
\set ON_ERROR_STOP 1

-- Test 22: statement (line 163)
-- Expected ERROR (row/record values are not numeric).
\set ON_ERROR_STOP 0
SELECT ROW()::float8 <> 'NaN'::float8;
\set ON_ERROR_STOP 1

-- Test 23: query (line 169)
SELECT 'nan'::float = 'NaN'::float, 'nan'::float <> 'NaN'::float;

-- Test 24: query (line 174)
SELECT 'nan'::decimal = 'NaN'::decimal, 'nan'::decimal <> 'NaN'::decimal;

-- Test 25: statement (line 179)
CREATE TABLE t87605 (col2 FLOAT8 NULL);

-- Test 26: statement (line 182)
INSERT INTO t87605 VALUES (1.234567890123456e+13), (1.234567890123456e+6);

-- Test 27: query (line 187)
SELECT trunc(col2::float8 / 1.0::float8) FROM t87605 ORDER BY 1;

-- Test 28: statement (line 195)
CREATE TABLE t89961 (a float PRIMARY KEY);
CREATE INDEX t89961_a_desc_idx ON t89961 (a DESC);

-- Test 29: statement (line 198)
INSERT INTO t89961 VALUES ('NaN');
