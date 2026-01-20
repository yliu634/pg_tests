-- PostgreSQL compatible tests from vectorize_overloads
-- 51 tests

-- Test 1: query (line 113)
SELECT _inet & _inet FROM many_types

-- Test 2: query (line 121)
SELECT _float^_float FROM many_types

-- Test 3: query (line 129)
SELECT _int^_decimal FROM many_types

-- Test 4: query (line 137)
SELECT _inet - _int2 FROM many_types

-- Test 5: query (line 145)
SELECT _inet - 1 FROM many_types

-- Test 6: query (line 153)
SELECT _int4 + _inet FROM many_types

-- Test 7: query (line 161)
SELECT 2 + _inet FROM many_types

-- Test 8: query (line 169)
SELECT _time + _interval FROM many_types

-- Test 9: query (line 177)
SELECT _json - _int FROM many_types

-- Test 10: query (line 185)
SELECT _bytes || _bytes FROM many_types

-- Test 11: query (line 193)
SELECT _string || _string FROM many_types

-- Test 12: query (line 201)
SELECT _json || _json FROM many_types

-- Test 13: query (line 209)
SELECT _varbit || _varbit FROM many_types

-- Test 14: query (line 217)
SELECT _int2 >> 1 FROM many_types

-- Test 15: query (line 225)
SELECT _int4 >> 3 FROM many_types

-- Test 16: statement (line 233)
SELECT _int << 64 FROM many_types

-- Test 17: statement (line 236)
SELECT _int << -10 FROM many_types

-- Test 18: query (line 239)
SELECT _int >> 63 FROM many_types

-- Test 19: query (line 247)
SELECT _varbit >> 1 FROM many_types

-- Test 20: query (line 255)
SELECT _varbit << 1 FROM many_types

-- Test 21: query (line 263)
SELECT _varbit << 3 FROM many_types

-- Test 22: query (line 271)
SELECT _int2^_int FROM many_types WHERE _int2 < 10 AND _int < 10

-- Test 23: query (line 276)
SELECT _int2^_int2 FROM many_types WHERE _int2 < 10

-- Test 24: statement (line 283)
SELECT _int2^_int4 FROM many_types

-- Test 25: query (line 286)
SELECT _json -> _int2 FROM many_types

-- Test 26: query (line 294)
SELECT _json -> _int4 FROM many_types

-- Test 27: query (line 302)
SELECT _json -> _int FROM many_types

-- Test 28: query (line 310)
SELECT _json -> 2 FROM many_types

-- Test 29: query (line 318)
SELECT _json -> 2 -> 'a' FROM many_types

-- Test 30: query (line 326)
SELECT _json #> _stringarray, _json #> '{2,a}' FROM many_types ORDER BY _int

-- Test 31: query (line 334)
SELECT _json #> _stringarray #> '{1,b}', _json #> '{2,a}' #> '{1,b}' FROM many_types ORDER BY _int

-- Test 32: query (line 342)
SELECT _json #> '{}' FROM many_types

-- Test 33: query (line 350)
SELECT _json #> _stringarray #> '{d}', _json #> '{c}' #> '{d}' FROM many_types

-- Test 34: query (line 358)
SELECT _json #>> _stringarray, _json #>> '{2,a}' FROM many_types ORDER BY _int

-- Test 35: query (line 366)
SELECT _json #> '{2,a}' #>> _stringarray, _json #> '{2,a}' #>> '{1,b}' FROM many_types

-- Test 36: query (line 374)
SELECT _json #>> '{}' FROM many_types

-- Test 37: query (line 382)
SELECT _json #> '{c}' #>> '{d}' FROM many_types

-- Test 38: query (line 394)
SELECT _json -> 5  = '1' FROM many_types

-- Test 39: query (line 402)
SELECT _json -> _int -> 'a' = '["foo", {"b": 3}]' FROM many_types

-- Test 40: statement (line 416)
SELECT '18b5:7e2:b3b:6f35:c48:eb6a:d607:6c61/108':::INET::INET & broadcast('13.83.69.95/21':::INET::INET)::INET::INET FROM many_types WHERE _bool

-- Test 41: query (line 419)
SELECT '[2, "hi", {"b": ["bar", {"c": 4}]}]'::jsonb -> _int FROM many_types

-- Test 42: query (line 430)
SELECT B'11' >= _varbit FROM many_types

-- Test 43: query (line 438)
SELECT _int, _int2, _int // _int2 FROM many_types WHERE _int2 <> 0

-- Test 44: statement (line 446)
SELECT ((-1.234E+401)::DECIMAL * '-53 years -10 mons -377 days -08:33:40.519057'::INTERVAL::INTERVAL)::INTERVAL FROM many_types

-- Test 45: statement (line 451)
CREATE TABLE t70738 (
    i INTERVAL,
    i2 INT2,
    i4 INT4,
    i8 INT8
);
INSERT INTO t70738 VALUES ('1 day'::INTERVAL, 1, 1, 1);

-- Test 46: statement (line 460)
SELECT * FROM t70738 AS t1
JOIN t70738 as t2 ON t1.i8 = t2.i4
WHERE (t2.i / t1.i8) = '1 day'

-- Test 47: statement (line 465)
SELECT * FROM t70738 AS t1
JOIN t70738 as t2 ON t1.i8 = t2.i2
WHERE (t2.i / t1.i8) = '1 day'

-- Test 48: statement (line 471)
CREATE TABLE t88141 (i INTERVAL);
INSERT INTO t88141 (i) VALUES (NULL);
SET testing_optimizer_random_seed = 6320964980407535657;
SET testing_optimizer_disable_rule_probability = 0.500000;

-- Test 49: query (line 477)
SELECT i
FROM t88141
WHERE NOT (i IN (
    SELECT '1 day'::INTERVAL
    FROM t88141 t1 JOIN t88141 t2 ON true
    WHERE false
));

-- Test 50: statement (line 488)
RESET testing_optimizer_random_seed;
RESET testing_optimizer_disable_rule_probability;

-- Test 51: query (line 492)
SELECT _interval + _timestamp FROM many_types WHERE _timestamp - _interval IS NOT NULL

