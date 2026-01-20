-- PostgreSQL compatible tests from edge
-- 26 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS t;
CREATE TABLE t (
    key TEXT PRIMARY KEY,
    _date DATE,
    _float4 REAL,
    _float8 DOUBLE PRECISION,
    _int2 INT2,
    _int4 INT4,
    _int8 INT8
);
RESET client_min_messages;

-- Test 1: statement (line 28)
INSERT
INTO
    t
VALUES
    (
        'min',
        '4713-01-02 BC',
        -3.40282346638528859811704183484516925440e+38,
        -4e307,
        -32767,
        -2147483647,
        -9223372036854775807
    ),
    (
        'max',
        '5874897-12-30',
        3.40282346638528859811704183484516925440e+38,
        4e307,
        32766,
        2147483646,
        9223372036854775806
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
SELECT _date - 1 FROM t WHERE key = 'min';

-- Test 6: query (line 91)
SELECT _int2 - 1::INT2 FROM t WHERE key = 'min';

-- Test 7: query (line 97)
SELECT _int4 - 1::INT4 FROM t WHERE key = 'min';

-- Test 8: statement (line 102)
SELECT _int8 - 1::INT8 FROM t WHERE key = 'min';

-- Test 9: query (line 105)
SELECT _float8 - 1e300 FROM t WHERE key = 'min';

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
SELECT _date + 1 FROM t WHERE key = 'max';

-- Test 13: query (line 142)
SELECT _int2 + 1::INT2 FROM t WHERE key = 'max';

-- Test 14: query (line 148)
SELECT _int4 + 1::INT4 FROM t WHERE key = 'max';

-- Test 15: statement (line 153)
SELECT _int8 + 1::INT8 FROM t WHERE key = 'max';

-- Test 16: query (line 156)
SELECT _float8 + 1e300 FROM t WHERE key = 'max';

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
	SELECT
	    sum(t._int2),
	    sum(t._int4),
	    sum(t._int8),
	    sum(t._float4::float8),
	    sum(t._float8),
	    avg(t._int2),
	    avg(t._int4),
	    avg(t._int8),
	    avg(t._float4),
	    avg(t._float8::numeric)
FROM
    t, t AS u
WHERE
    t.key = 'min'
;

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
	SELECT
	    sum(t._int2),
	    sum(t._int4),
	    sum(t._int8),
	    sum(t._float4::float8),
	    sum(t._float8),
	    avg(t._int2),
	    avg(t._int4),
	    avg(t._int8),
	    avg(t._float4),
	    avg(t._float8::numeric)
FROM
    t
;

-- Test 26: query (line 252)
SELECT
    sum(t._int2), sum(t._int4), sum(t._int8)
FROM
    t
;
