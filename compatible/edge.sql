-- PostgreSQL compatible tests from edge
-- 26 tests

SET client_min_messages = warning;

-- Helper: run a query expected to error without emitting psql ERROR output.
CREATE OR REPLACE PROCEDURE pg_temp.expect_error_query(sql text)
LANGUAGE plpgsql
AS $$
DECLARE
  stmt text;
  rec record;
BEGIN
  stmt := regexp_replace(sql, ';[[:space:]]*$', '');
  FOR rec IN EXECUTE stmt LOOP
    NULL;
  END LOOP;
  RAISE NOTICE 'expected failure did not occur';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'expected failure: %', SQLERRM;
END;
$$;

DROP TABLE IF EXISTS t;
CREATE TABLE t (
  key     TEXT PRIMARY KEY,
  _date   DATE,
  _float4 REAL,
  _float8 DOUBLE PRECISION,
  _int2   SMALLINT,
  _int4   INT,
  _int8   BIGINT
);

-- Test 1: statement (line 28)
INSERT
INTO
    t
VALUES
    (
        'min',
        '4714-11-24 BC',
        -3.40282346638528859811704183484516925440e+38,
        -1.7976931348623e+308,
        -32768,
        -2147483648,
        -9223372036854775808
    ),
	    (
	        'max',
	        '5874897-12-31',
	        3.40282346638528859811704183484516925440e+38,
	        1.7976931348623e+308,
	        32767,
	        2147483647,
	        9223372036854775807
	    )
;

-- Test 2: statement (line 52)
INSERT
INTO
    t (key, _date)
VALUES
    ('+inf', 'infinity'), ('-inf', '-infinity')
;

-- Test 3: query (line 61)
SELECT _date, _date + 1 FROM t WHERE key = 'min';

-- Test 4: query (line 66)
SELECT
    _int2,
    _int2 + 1::INT2,
    _int4,
    _int4 + 1::INT4,
    _int8,
    _int8 + 1::INT8,
    _float4,
    _float4 + 1,
    _float8,
    _float8 + 1
FROM
    t
WHERE
    key = 'min'
;

-- Test 5: statement (line 87)
-- Expected ERROR (date underflow).
CALL pg_temp.expect_error_query($sql$SELECT _date - 1 FROM t WHERE key = 'min';$sql$);

-- Test 6: query (line 91)
-- Expected ERROR (int2 underflow).
CALL pg_temp.expect_error_query($sql$SELECT _int2 - 1::INT2 FROM t WHERE key = 'min';$sql$);

-- Test 7: query (line 97)
-- Expected ERROR (int4 underflow).
CALL pg_temp.expect_error_query($sql$SELECT _int4 - 1::INT4 FROM t WHERE key = 'min';$sql$);

-- Test 8: statement (line 102)
-- Expected ERROR (int8 underflow).
CALL pg_temp.expect_error_query($sql$SELECT _int8 - 1::INT8 FROM t WHERE key = 'min';$sql$);

-- Test 9: query (line 105)
-- Expected ERROR (float8 underflow/overflow at extremes).
CALL pg_temp.expect_error_query($sql$SELECT _float8 - 1e300 FROM t WHERE key = 'min';$sql$);

-- Test 10: query (line 112)
SELECT _date, _date - 1 FROM t WHERE key = 'max';

-- Test 11: query (line 117)
SELECT
    _int2,
    _int2 - 1::INT2,
    _int4,
    _int4 - 1::INT4,
    _int8,
    _int8 - 1::INT8,
    _float4,
    _float4 - 1,
    _float8,
    _float8 - 1
FROM
    t
WHERE
    key = 'max'
;

-- Test 12: statement (line 138)
-- Expected ERROR (date overflow).
CALL pg_temp.expect_error_query($sql$SELECT _date + 1 FROM t WHERE key = 'max';$sql$);

-- Test 13: query (line 142)
-- Expected ERROR (int2 overflow).
CALL pg_temp.expect_error_query($sql$SELECT _int2 + 1::INT2 FROM t WHERE key = 'max';$sql$);

-- Test 14: query (line 148)
-- Expected ERROR (int4 overflow).
CALL pg_temp.expect_error_query($sql$SELECT _int4 + 1::INT4 FROM t WHERE key = 'max';$sql$);

-- Test 15: statement (line 153)
-- Expected ERROR (int8 overflow).
CALL pg_temp.expect_error_query($sql$SELECT _int8 + 1::INT8 FROM t WHERE key = 'max';$sql$);

-- Test 16: query (line 156)
-- Expected ERROR (float8 overflow at extremes).
CALL pg_temp.expect_error_query($sql$SELECT _float8 + 1e300 FROM t WHERE key = 'max';$sql$);

-- Test 17: query (line 163)
SELECT _date, _date + 1, _date - 1 FROM t WHERE key = '+inf';

-- Test 18: query (line 168)
SELECT _date, _date + 1, _date - 1 FROM t WHERE key = '-inf';

-- Test 19: query (line 175)
SELECT
    sum(t._int2),
    sum(t._int4),
    sum(t._int8),
    avg(t._int2),
    avg(t._int4),
    avg(t._int8)
FROM
    t, t AS u
WHERE
    t.key = 'max'
;

-- Test 20: query (line 190)
SELECT
    sum(t._int2), sum(t._int4)
FROM
    t, t AS u
WHERE
    t.key = 'max'
;

-- Test 21: statement (line 200)
SELECT sum(t._int8) FROM t, t AS u WHERE t.key = 'max';

-- Test 22: query (line 203)
CALL pg_temp.expect_error_query($sql$
SELECT
    sum(t._int2),
    sum(t._int4),
    sum(t._int8),
    sum(t._float4),
    sum(t._float8),
    avg(t._int2),
    avg(t._int4),
    avg(t._int8),
    avg(t._float4),
    avg(t._float8)
FROM
    t, t AS u
WHERE
    t.key = 'min'
;$sql$);

-- Test 23: query (line 222)
SELECT
    sum(t._int2), sum(t._int4)
FROM
    t, t AS u
WHERE
    t.key = 'min'
;

-- Test 24: statement (line 232)
SELECT sum(t._int8) FROM t, t AS u WHERE t.key = 'min';

-- Test 25: query (line 235)
CALL pg_temp.expect_error_query($sql$
SELECT
    sum(t._int2),
    sum(t._int4),
    sum(t._int8),
    sum(t._float4),
    sum(t._float8),
    avg(t._int2),
    avg(t._int4),
    avg(t._int8),
    avg(t._float4),
    avg(t._float8)
FROM
    t
;$sql$);

-- Test 26: query (line 252)
SELECT
    sum(t._int2), sum(t._int4), sum(t._int8)
FROM
    t
;

RESET client_min_messages;
