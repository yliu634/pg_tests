-- PostgreSQL compatible tests from window
-- 383 tests

-- Test 1: statement (line 21)
INSERT INTO kv VALUES
(1, 2, 3, 1.0, 1, 'a', true, '1min'),
(3, 4, 5, 2, 8, 'a', true, '2sec'),
(5, NULL, 5, 9.9, -321, NULL, false, NULL),
(6, 2, 3, 4.4, 4.4, 'b', true, '1ms'),
(7, 2, 2, 6, 7.9, 'b', true, '4 days'),
(8, 4, 2, 3, 3, 'A', false, '3 years')

-- Test 2: query (line 30)
SELECT * FROM kv GROUP BY v, count(w) OVER ()

query error window functions are not allowed in GROUP BY
SELECT count(w) OVER () FROM kv GROUP BY 1

query error window functions are not allowed in RETURNING
INSERT INTO kv (k, v) VALUES (99, 100) RETURNING sum(v) OVER ()

query error column "v" does not exist
SELECT sum(v) FROM kv GROUP BY k LIMIT sum(v) OVER ()

query error column "v" does not exist
SELECT sum(v) FROM kv GROUP BY k LIMIT 1 OFFSET sum(v) OVER ()

query error window functions are not allowed in VALUES
INSERT INTO kv (k, v) VALUES (99, count(1) OVER ())

query error window functions are not allowed in WHERE
SELECT k FROM kv WHERE avg(k) OVER () > 1

query error window functions are not allowed in HAVING
SELECT 1 FROM kv GROUP BY 1 HAVING sum(1) OVER (PARTITION BY 1) > 1

query R
SELECT avg(k) OVER () FROM kv ORDER BY 1

-- Test 3: query (line 64)
SELECT avg(k) OVER (PARTITION BY v) FROM kv ORDER BY 1

-- Test 4: query (line 74)
SELECT avg(k) OVER (PARTITION BY w) FROM kv ORDER BY 1

-- Test 5: query (line 84)
SELECT avg(k) OVER (PARTITION BY b) FROM kv ORDER BY 1

-- Test 6: query (line 94)
SELECT avg(k) OVER (PARTITION BY w, b) FROM kv ORDER BY 1

-- Test 7: query (line 104)
SELECT avg(k) OVER (PARTITION BY kv.*) FROM kv ORDER BY 1

-- Test 8: query (line 114)
SELECT avg(k) OVER (ORDER BY w) FROM kv ORDER BY 1

-- Test 9: query (line 124)
SELECT avg(k) OVER (ORDER BY b) FROM kv ORDER BY 1

-- Test 10: query (line 134)
SELECT avg(k) OVER (ORDER BY w, b) FROM kv ORDER BY 1

-- Test 11: query (line 144)
SELECT avg(k) OVER (ORDER BY 1-w) FROM kv ORDER BY 1

-- Test 12: query (line 154)
SELECT avg(k) OVER (ORDER BY kv.*) FROM kv ORDER BY 1

-- Test 13: query (line 164)
SELECT avg(k) OVER (ORDER BY w DESC) FROM kv ORDER BY 1

-- Test 14: query (line 174)
SELECT avg(k) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 15: query (line 184)
SELECT avg(k) OVER w FROM kv WINDOW w AS (PARTITION BY v ORDER BY w) ORDER BY 1

-- Test 16: query (line 194)
SELECT avg(k) OVER (w) FROM kv WINDOW w AS (PARTITION BY v ORDER BY w) ORDER BY 1

-- Test 17: query (line 204)
SELECT avg(k) OVER (w ORDER BY w) FROM kv WINDOW w AS (PARTITION BY v) ORDER BY 1

-- Test 18: query (line 214)
SELECT *, avg(k) OVER (w ORDER BY w) FROM kv WINDOW w AS (PARTITION BY v) ORDER BY 1

-- Test 19: query (line 225)
SELECT *, avg(k) OVER w FROM kv WINDOW w AS (PARTITION BY v ORDER BY w) ORDER BY avg(k) OVER w, k

-- Test 20: query (line 236)
SELECT * FROM kv WINDOW w AS (PARTITION BY v ORDER BY w) ORDER BY avg(k) OVER w DESC, k

-- Test 21: query (line 247)
SELECT avg(k) OVER w FROM kv WINDOW w AS (), w AS ()

query error window "x" does not exist
SELECT avg(k) OVER x FROM kv WINDOW w AS ()

query error window "x" does not exist
SELECT avg(k) OVER (x) FROM kv WINDOW w AS ()

query error cannot override PARTITION BY clause of window "w"
SELECT avg(k) OVER (w PARTITION BY v) FROM kv WINDOW w AS ()

query error cannot override PARTITION BY clause of window "w"
SELECT avg(k) OVER (w PARTITION BY v) FROM kv WINDOW w AS (PARTITION BY v)

query error cannot override ORDER BY clause of window "w"
SELECT avg(k) OVER (w ORDER BY v) FROM kv WINDOW w AS (ORDER BY v)

query error column "a" does not exist
SELECT avg(k) OVER (PARTITION BY a) FROM kv

query error column "a" does not exist
SELECT avg(k) OVER (ORDER BY a) FROM kv

# TODO(justin): this should have pgcode 42803 but CBO currently doesn't get
# it right.
query error window functions are not allowed in aggregate
SELECT avg(avg(k) OVER ()) FROM kv ORDER BY 1

query R
SELECT avg(avg(k)) OVER () FROM kv ORDER BY 1

-- Test 22: query (line 281)
SELECT avg(k) OVER (), avg(v) OVER () FROM kv ORDER BY 1

-- Test 23: query (line 291)
SELECT now() OVER () FROM kv ORDER BY 1

query error window function rank\(\) requires an OVER clause
SELECT rank() FROM kv

query error unknown signature: rank\(int\)
SELECT rank(22) FROM kv

query error window function calls cannot be nested
SELECT avg(avg(k) OVER ()) OVER () FROM kv ORDER BY 1

query error OVER specified, but round\(\) is neither a window function nor an aggregate function
SELECT round(avg(k) OVER ()) OVER () FROM kv ORDER BY 1

query R
SELECT round(avg(k) OVER (PARTITION BY v ORDER BY w)) FROM kv ORDER BY 1

-- Test 24: query (line 316)
SELECT avg(f) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 25: query (line 326)
SELECT avg(d) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 26: query (line 336)
SELECT avg(d) OVER (PARTITION BY w ORDER BY v) FROM kv ORDER BY 1

-- Test 27: query (line 346)
SELECT (avg(d) OVER (PARTITION BY v ORDER BY w) + avg(d) OVER (PARTITION BY v ORDER BY w)) FROM kv ORDER BY 1

-- Test 28: query (line 356)
SELECT (avg(d) OVER (PARTITION BY v ORDER BY w) + avg(d) OVER (PARTITION BY w ORDER BY v)) FROM kv ORDER BY 1

-- Test 29: query (line 366)
SELECT avg(d) OVER (PARTITION BY v) FROM kv WHERE FALSE ORDER BY 1

-- Test 30: query (line 370)
SELECT avg(d) OVER (PARTITION BY v, v, v, v, v, v, v, v, v, v) FROM kv WHERE FALSE ORDER BY 1

-- Test 31: query (line 374)
SELECT avg(d) OVER (PARTITION BY v, v, v, v, v, v, v, v, v, v) FROM kv WHERE k = 3 ORDER BY 1

-- Test 32: query (line 379)
SELECT k, concat_agg(s) OVER (PARTITION BY k ORDER BY w) FROM kv ORDER BY 1

-- Test 33: query (line 389)
SELECT k, concat_agg(s) OVER (PARTITION BY v ORDER BY w, k) FROM kv ORDER BY 1

-- Test 34: query (line 399)
SELECT k, bool_and(b) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 35: query (line 409)
SELECT k, bool_or(b) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 36: query (line 419)
SELECT k, count(d) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 37: query (line 429)
SELECT k, count(*) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 38: query (line 439)
SELECT k, max(d) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 39: query (line 449)
SELECT k, min(d) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 40: query (line 459)
SELECT k, pow(max(d) OVER (PARTITION BY v), k::DECIMAL) FROM kv ORDER BY 1

-- Test 41: query (line 469)
SELECT k, max(d) OVER (PARTITION BY v) FROM kv ORDER BY 1

-- Test 42: query (line 479)
SELECT k, sum(d) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 43: query (line 489)
SELECT k, variance(d) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 44: query (line 499)
SELECT k, stddev(d) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 45: query (line 509)
SELECT k, stddev(d) OVER w FROM kv WINDOW w as (PARTITION BY v) ORDER BY variance(d) OVER w, k

-- Test 46: query (line 519)
SELECT * FROM (SELECT k, d, v, stddev(d) OVER (PARTITION BY v) FROM kv) sub ORDER BY variance(d) OVER (PARTITION BY v), k

-- Test 47: query (line 529)
SELECT k, max(stddev) OVER (ORDER BY d) FROM (SELECT k, d, stddev(d) OVER (PARTITION BY v) as stddev FROM kv) sub ORDER BY 2, k

-- Test 48: query (line 539)
SELECT k, max(stddev) OVER (ORDER BY d DESC) FROM (SELECT k, d, stddev(d) OVER (PARTITION BY v) as stddev FROM kv) sub ORDER BY 2, k

-- Test 49: query (line 549)
SELECT k, (rank() OVER wind + avg(w) OVER wind), w, (v + row_number() OVER wind), v FROM kv WINDOW wind AS (ORDER BY k) ORDER BY 1

-- Test 50: query (line 559)
SELECT s, w + k, (sum(w) OVER wind + avg(d) OVER wind), (min(w) OVER wind + d), v FROM kv WINDOW wind AS (ORDER BY w, k) ORDER BY k

-- Test 51: query (line 569)
SELECT k, v + w, round(rank() OVER wind + lead(k, 3, v) OVER wind + lag(w, 1, 2) OVER wind + f::DECIMAL + avg(d) OVER wind)::INT, round(row_number() OVER wind::FLOAT + round(f) + dense_rank() OVER wind::FLOAT)::INT FROM kv WINDOW wind as (PARTITION BY v ORDER BY k) ORDER BY k

-- Test 52: query (line 579)
SELECT (rank() OVER wind + lead(k, 3, v) OVER wind + lag(w, 1, 2) OVER wind), (row_number() OVER wind + dense_rank() OVER wind) FROM kv WINDOW wind as (PARTITION BY v ORDER BY k) ORDER BY k

-- Test 53: query (line 589)
SELECT (round(avg(k) OVER w1 + sum(w) OVER w2) + row_number() OVER w2 + d + min(d) OVER w3 + f::DECIMAL) AS big_sum, v + w AS v_plus_w, (rank() OVER w3 + first_value(d) OVER w1 + nth_value(k, 2) OVER w1) AS small_sum FROM kv WINDOW w1 AS (PARTITION BY b ORDER BY k), w2 AS (PARTITION BY w ORDER BY k), w3 AS (PARTITION BY v ORDER BY k) ORDER BY k

-- Test 54: query (line 599)
SELECT round(row_number() OVER w1 + lead(k, v, w) OVER w2 + avg(k) OVER w1), (lag(k, 1) OVER w1 + v + rank() OVER w2 + min(k) OVER w1) FROM kv WINDOW w1 AS (PARTITION BY w ORDER BY k), w2 AS (PARTITION BY b ORDER BY k) ORDER BY k

-- Test 55: query (line 609)
SELECT f::DECIMAL + round(max(k) * w * avg(d) OVER wind) + (lead(f, 2, 17::FLOAT) OVER wind::DECIMAL / d * row_number() OVER wind) FROM kv GROUP BY k, w, f, d WINDOW wind AS (ORDER BY k) ORDER BY k

-- Test 56: query (line 619)
SELECT round(max(w) * w * avg(w) OVER wind) + (lead(w, 2, 17) OVER wind::DECIMAL / w * row_number() OVER wind) FROM kv GROUP BY w WINDOW wind AS (PARTITION BY w) ORDER BY 1

-- Test 57: query (line 626)
SELECT k, avg(d) OVER w1, avg(d) OVER w2, row_number() OVER w2, sum(f) OVER w1, row_number() OVER w1, sum(f) OVER w2 FROM kv WINDOW w1 AS (ORDER BY k), w2 AS (ORDER BY w, k) ORDER BY k

-- Test 58: query (line 636)
SELECT round((avg(d) OVER wind) * max(k) + (lag(d, 1, 42.0) OVER wind) * max(d)) FROM kv GROUP BY d, k WINDOW wind AS (ORDER BY k) ORDER BY k

-- Test 59: query (line 646)
SELECT avg(k) OVER w, avg(k) OVER w + 1 FROM kv WINDOW w AS (PARTITION BY v ORDER BY w) ORDER BY k

-- Test 60: statement (line 656)
INSERT INTO kv VALUES
(9, 2, 9, .1, DEFAULT, DEFAULT, DEFAULT),
(10, 4, 9, .2, DEFAULT, DEFAULT, DEFAULT),
(11, NULL, 9, .3, DEFAULT, DEFAULT, DEFAULT)

-- Test 61: query (line 662)
SELECT k, row_number() OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 62: query (line 675)
SELECT k, v, row_number() OVER (PARTITION BY v ORDER BY k) FROM kv ORDER BY 1

-- Test 63: query (line 688)
SELECT k, v, w, row_number() OVER (PARTITION BY v ORDER BY w, k) FROM kv ORDER BY 1

-- Test 64: query (line 701)
SELECT k, v, w, v - w + 2 + row_number() OVER (PARTITION BY v ORDER BY w, k) FROM kv ORDER BY 1

-- Test 65: query (line 714)
SELECT k, row_number() OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 66: query (line 727)
SELECT k, v, w, v - w + 2 + row_number() OVER (PARTITION BY v, k ORDER BY w) FROM kv ORDER BY 1

-- Test 67: query (line 740)
SELECT avg(k), max(v), min(w), 2 + row_number() OVER () FROM kv ORDER BY 1

-- Test 68: query (line 745)
SELECT k, rank() OVER () FROM kv ORDER BY 1

-- Test 69: query (line 758)
SELECT k, v, rank() OVER (PARTITION BY v) FROM kv ORDER BY 1

-- Test 70: query (line 771)
SELECT k, v, w, rank() OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 71: query (line 784)
SELECT k, (rank() OVER w + avg(w) OVER w), k FROM kv WINDOW w AS (PARTITION BY v ORDER BY w) ORDER BY 1

-- Test 72: query (line 797)
SELECT k, (avg(w) OVER w + rank() OVER w), k FROM kv WINDOW w AS (PARTITION BY v ORDER BY w) ORDER BY 1

-- Test 73: query (line 810)
SELECT k, dense_rank() OVER () FROM kv ORDER BY 1

-- Test 74: query (line 823)
SELECT k, v, dense_rank() OVER (PARTITION BY v) FROM kv ORDER BY 1

-- Test 75: query (line 836)
SELECT k, v, w, dense_rank() OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 76: query (line 849)
SELECT k, percent_rank() OVER () FROM kv ORDER BY 1

-- Test 77: query (line 862)
SELECT k, v, percent_rank() OVER (PARTITION BY v) FROM kv ORDER BY 1

-- Test 78: query (line 875)
SELECT k, v, w, percent_rank() OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 79: query (line 888)
SELECT k, cume_dist() OVER () FROM kv ORDER BY 1

-- Test 80: query (line 901)
SELECT k, v, cume_dist() OVER (PARTITION BY v) FROM kv ORDER BY 1

-- Test 81: query (line 914)
SELECT k, v, w, cume_dist() OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 82: query (line 927)
SELECT k, ntile(-10) OVER () FROM kv ORDER BY 1

query error argument of ntile\(\) must be greater than zero
SELECT k, ntile(0) OVER () FROM kv ORDER BY 1

query II
SELECT k, ntile(NULL::INT) OVER () FROM kv ORDER BY 1

-- Test 83: query (line 946)
SELECT k, ntile(1) OVER () FROM kv ORDER BY 1

-- Test 84: query (line 959)
SELECT k, ntile(4) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 85: query (line 972)
SELECT k, ntile(20) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 86: query (line 986)
SELECT k, w, ntile(w) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 87: query (line 999)
SELECT k, v, ntile(3) OVER (PARTITION BY v ORDER BY k) FROM kv ORDER BY v, k

-- Test 88: query (line 1012)
SELECT k, v, w, ntile(6) OVER (PARTITION BY v ORDER BY w, k) FROM kv ORDER BY v, w, k

-- Test 89: query (line 1025)
SELECT k, w, ntile(w) OVER (PARTITION BY k) FROM kv ORDER BY k

-- Test 90: query (line 1038)
SELECT k, v, ntile(3) OVER (PARTITION BY v, k) FROM kv ORDER BY v, k

-- Test 91: query (line 1051)
SELECT k, v, w, ntile(6) OVER (PARTITION BY v, k ORDER BY w) FROM kv ORDER BY v, k, w

-- Test 92: query (line 1064)
SELECT k, v, w, ntile(v) OVER (PARTITION BY w ORDER BY v, k) FROM kv ORDER BY w, v, k

-- Test 93: query (line 1077)
SELECT k, v, ntile(v) OVER (ORDER BY v, k) FROM kv ORDER BY v, k

-- Test 94: query (line 1090)
SELECT k, v, ntile(v) OVER (ORDER BY v, k)
FROM (SELECT * FROM kv WHERE w != 3) ORDER BY v, k

-- Test 95: query (line 1102)
SELECT k, v, ntile(3::INT2) OVER (PARTITION BY v ORDER BY k) FROM kv ORDER BY v, k

-- Test 96: query (line 1115)
SELECT k, v, ntile(3::INT4) OVER (PARTITION BY v ORDER BY k) FROM kv ORDER BY v, k

-- Test 97: query (line 1128)
SELECT k, w, ntile(w::INT4) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 98: query (line 1141)
SELECT k, ntile(1::INT4) OVER () FROM kv ORDER BY 1

-- Test 99: query (line 1154)
SELECT k, lag(9) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 100: query (line 1167)
SELECT k, lead(9) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 101: query (line 1180)
SELECT k, lag(k) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 102: query (line 1193)
SELECT k, lag(k) OVER (PARTITION BY v ORDER BY w, k) FROM kv ORDER BY 1

-- Test 103: query (line 1206)
SELECT k, lead(k) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 104: query (line 1219)
SELECT k, lead(k) OVER (PARTITION BY v ORDER BY w, k) FROM kv ORDER BY 1

-- Test 105: query (line 1232)
SELECT k, lag(k, 3) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 106: query (line 1245)
SELECT k, lag(k, 3) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 107: query (line 1258)
SELECT k, lead(k, 3) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 108: query (line 1271)
SELECT k, lead(k, 3) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 109: query (line 1284)
SELECT k, lag(k, -5) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 110: query (line 1297)
SELECT k, lead(k, -5) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 111: query (line 1310)
SELECT k, lag(k, 0) OVER () FROM kv ORDER BY 1

-- Test 112: query (line 1323)
SELECT k, lead(k, 0) OVER () FROM kv ORDER BY 1

-- Test 113: query (line 1336)
SELECT k, lag(k, NULL::INT) OVER () FROM kv ORDER BY 1

-- Test 114: query (line 1349)
SELECT k, lead(k, NULL::INT) OVER () FROM kv ORDER BY 1

-- Test 115: query (line 1362)
SELECT k, lag(k, w) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 116: query (line 1375)
SELECT k, lag(k, w) OVER (PARTITION BY v ORDER BY w, k) FROM kv ORDER BY 1

-- Test 117: query (line 1388)
SELECT k, lead(k, w) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 118: query (line 1401)
SELECT k, lead(k, w) OVER (PARTITION BY v ORDER BY w, k) FROM kv ORDER BY 1

-- Test 119: query (line 1439)
SELECT k, lead(k, 3, -99) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 120: query (line 1452)
SELECT k, lag(k, 3, v) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 121: query (line 1465)
SELECT k, lead(k, 3, v) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 122: query (line 1478)
SELECT k, (lag(k, 5, w) OVER w + lead(k, 3, v) OVER w) FROM kv WINDOW w AS (ORDER BY k) ORDER BY 1

-- Test 123: query (line 1491)
SELECT k, lag(k) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 124: query (line 1504)
SELECT k, lead(k) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 125: query (line 1517)
SELECT k, lag(k, 0) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 126: query (line 1530)
SELECT k, lead(k, 0) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 127: query (line 1543)
SELECT k, lag(k, -5) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 128: query (line 1556)
SELECT k, lead(k, -5) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 129: query (line 1569)
SELECT k, lag(k, w - w) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 130: query (line 1582)
SELECT k, lead(k, w - w) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 131: query (line 1595)
SELECT k, lag(k, 3, -99) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 132: query (line 1608)
SELECT k, lead(k, 3, -99) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 133: query (line 1621)
SELECT k, lag(k, 3, v) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 134: query (line 1634)
SELECT k, lead(k, 3, v) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 135: query (line 1647)
SELECT k, first_value(NULL::INT) OVER () FROM kv ORDER BY 1

-- Test 136: query (line 1660)
SELECT k, first_value(1) OVER () FROM kv ORDER BY 1

-- Test 137: query (line 1673)
SELECT k, first_value(199.9 * 23.3) OVER () FROM kv ORDER BY 1

-- Test 138: query (line 1686)
SELECT k, first_value(v) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 139: query (line 1699)
SELECT k, v, w, first_value(w) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 140: query (line 1712)
SELECT k, v, w, first_value(w) OVER (PARTITION BY v ORDER BY w DESC) FROM kv ORDER BY 1

-- Test 141: query (line 1725)
SELECT k, first_value(v) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 142: query (line 1738)
SELECT k, last_value(NULL::INT) OVER () FROM kv ORDER BY 1

-- Test 143: query (line 1751)
SELECT k, last_value(1) OVER () FROM kv ORDER BY 1

-- Test 144: query (line 1764)
SELECT k, last_value(199.9 * 23.3) OVER () FROM kv ORDER BY 1

-- Test 145: query (line 1777)
SELECT k, last_value(v) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 146: query (line 1790)
SELECT k, v, w, last_value(w) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 147: query (line 1803)
SELECT k, v, w, last_value(w) OVER (PARTITION BY v ORDER BY w DESC) FROM kv ORDER BY 1

-- Test 148: query (line 1816)
SELECT k, last_value(v) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 149: query (line 1829)
SELECT k, nth_value(v, 'FOO') OVER () FROM kv ORDER BY 1

query error argument of nth_value\(\) must be greater than zero
SELECT k, nth_value(v, -99) OVER () FROM kv ORDER BY 1

query error argument of nth_value\(\) must be greater than zero
SELECT k, nth_value(v, 0) OVER () FROM kv ORDER BY 1

query II
SELECT k, nth_value(NULL::INT, 5) OVER () FROM kv ORDER BY 1

-- Test 150: query (line 1851)
SELECT k, nth_value(1, 3) OVER () FROM kv ORDER BY 1

-- Test 151: query (line 1864)
SELECT k, nth_value(1, 33) OVER () FROM kv ORDER BY 1

-- Test 152: query (line 1877)
SELECT k, nth_value(199.9 * 23.3, 7) OVER () FROM kv ORDER BY 1

-- Test 153: query (line 1890)
SELECT k, nth_value(v, 8) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 154: query (line 1903)
SELECT k, v, w, nth_value(w, 2) OVER (PARTITION BY v ORDER BY w) FROM kv ORDER BY 1

-- Test 155: query (line 1916)
SELECT k, v, w, nth_value(w, 2) OVER (PARTITION BY v ORDER BY w DESC) FROM kv ORDER BY 1

-- Test 156: query (line 1929)
SELECT k, nth_value(v, k) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 157: query (line 1942)
SELECT k, nth_value(v, v) OVER (ORDER BY k) FROM kv ORDER BY 1

-- Test 158: query (line 1955)
SELECT k, nth_value(v, 1) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 159: query (line 1968)
SELECT k, nth_value(v, v) OVER (PARTITION BY k) FROM kv ORDER BY 1

-- Test 160: statement (line 1982)
INSERT INTO kv VALUES (12, -1, DEFAULT, DEFAULT, DEFAULT, DEFAULT)

-- Test 161: query (line 1985)
SELECT k, nth_value(v, v) OVER () FROM kv ORDER BY 1

statement count 1
DELETE FROM kv WHERE k = 12

query error FILTER specified but rank\(\) is not an aggregate function
SELECT k, rank() FILTER (WHERE k=1) OVER () FROM kv

query TT
SELECT i, avg(i) OVER (ORDER BY i) FROM kv ORDER BY i

-- Test 162: query (line 2009)
SELECT max(i) * (row_number() OVER (ORDER BY max(i))) FROM (SELECT 1 AS i, 2 AS j) GROUP BY j

-- Test 163: query (line 2014)
SELECT (1/j) * max(i) * (row_number() OVER (ORDER BY max(i))) FROM (SELECT 1 AS i, 2 AS j) GROUP BY j

-- Test 164: query (line 2019)
SELECT max(i) * (1/j) * (row_number() OVER (ORDER BY max(i))) FROM (SELECT 1 AS i, 2 AS j) GROUP BY j

-- Test 165: statement (line 2025)
SELECT final_variance(1.2, 1.2, 123) OVER (PARTITION BY k) FROM kv

-- Test 166: statement (line 2028)
CREATE TABLE products (
  group_id serial PRIMARY KEY,
  group_name VARCHAR (255) NOT NULL,
  product_name VARCHAR (255) NOT NULL,
  price DECIMAL (11, 2),
  priceInt INT,
  priceFloat FLOAT,
  pDate DATE,
  pTime TIME,
  pTimestamp TIMESTAMP,
  pTimestampTZ TIMESTAMPTZ,
  pInterval INTERVAL
)

-- Test 167: statement (line 2043)
INSERT INTO products (group_name, product_name, price, priceInt, priceFloat, pDate, pTime, pTimestamp, pTimestampTZ, pInterval) VALUES
('Smartphone', 'Microsoft Lumia', 200, 200, 200, '2018-07-30', TIME '01:23:45', TIMESTAMP '2018-07-30 01:23:45', TIMESTAMPTZ '2018-07-30 01:23:45', INTERVAL '1 months 2 days 3 hours 4 minutes 5 seconds'),
('Smartphone', 'HTC One', 400, 400, 400, '2018-07-31', TIME '12:34:56', TIMESTAMP '2018-07-31 12:34:56', TIMESTAMPTZ '2018-07-31 12:34:56', INTERVAL '1 days 2 hours 3 minutes 4 seconds'),
('Smartphone', 'Nexus', 500, 500, 500, '2018-07-30', TIME '11:23:45', TIMESTAMP '2018-07-30 11:23:45', TIMESTAMPTZ '2018-07-30 11:23:45', INTERVAL '1 hours 2 minutes 3 seconds'),
('Smartphone', 'iPhone', 900, 900, 900, '2018-07-31', TIME '07:34:56', TIMESTAMP '2018-07-31 07:34:56', TIMESTAMPTZ '2018-07-31 07:34:56', INTERVAL '1 minutes 2 seconds'),
('Laptop', 'HP Elite', 1200, 1200, 1200, '2018-07-30', TIME '01:23:45', TIMESTAMP '2018-07-30 01:23:45', TIMESTAMPTZ '2018-07-30 01:23:45', INTERVAL '1 months 2 days 3 hours 4 minutes 5 seconds'),
('Laptop', 'Lenovo Thinkpad', 700, 700, 700, '2018-07-31', TIME '12:34:56', TIMESTAMP '2018-07-31 12:34:56', TIMESTAMPTZ '2018-07-31 12:34:56', INTERVAL '1 days 2 hours 3 minutes 4 seconds'),
('Laptop', 'Sony VAIO', 700, 700, 700, '2018-07-30', TIME '11:23:45', TIMESTAMP '2018-07-30 11:23:45', TIMESTAMPTZ '2018-07-30 11:23:45', INTERVAL '1 hours 2 minutes 3 seconds'),
('Laptop', 'Dell', 800, 800, 800, '2018-07-31', TIME '07:34:56', TIMESTAMP '2018-07-31 07:34:56', TIMESTAMPTZ '2018-07-31 07:34:56', INTERVAL '1 minutes 2 seconds'),
('Tablet', 'iPad', 700, 700, 700, '2018-07-30', TIME '01:23:45', TIMESTAMP '2018-07-30 01:23:45', TIMESTAMPTZ '2018-07-30 01:23:45', INTERVAL '1 months 2 days 3 hours 4 minutes 5 seconds'),
('Tablet', 'Kindle Fire', 150, 150, 150, '2018-07-31', TIME '12:34:56', TIMESTAMP '2018-07-31 12:34:56', TIMESTAMPTZ '2018-07-31 12:34:56', INTERVAL '1 days 2 hours 3 minutes 4 seconds'),
('Tablet', 'Samsung', 200, 200, 200, '2018-07-30', TIME '11:23:45', TIMESTAMP '2018-07-30 11:23:45', TIMESTAMPTZ '2018-07-30 11:23:45', INTERVAL '1 hours 2 minutes 3 seconds')

-- Test 168: statement (line 2057)
SELECT avg(price) OVER (w) FROM products WINDOW w AS (ROWS 1 PRECEDING)

-- Test 169: statement (line 2060)
SELECT avg(price) OVER (w ORDER BY price) FROM products WINDOW w AS (ROWS 1 PRECEDING)

-- Test 170: statement (line 2063)
SELECT avg(price) OVER (ROWS NULL PRECEDING) FROM products

-- Test 171: statement (line 2066)
SELECT avg(price) OVER (ROWS BETWEEN NULL PRECEDING AND 1 FOLLOWING) FROM products

-- Test 172: statement (line 2069)
SELECT price, avg(price) OVER (PARTITION BY price ROWS -1 PRECEDING) AS avg_price FROM products

-- Test 173: statement (line 2072)
SELECT price, avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY price ROWS -1 PRECEDING)

-- Test 174: statement (line 2075)
SELECT avg(price) OVER (ROWS BETWEEN 1 PRECEDING AND NULL FOLLOWING) FROM products

-- Test 175: statement (line 2078)
SELECT price, avg(price) OVER (PARTITION BY price ROWS BETWEEN 1 FOLLOWING AND -1 FOLLOWING) AS avg_price FROM products

-- Test 176: statement (line 2081)
SELECT price, avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY price ROWS BETWEEN 1 FOLLOWING AND -1 FOLLOWING)

-- Test 177: statement (line 2084)
SELECT product_name, price, min(price) OVER (PARTITION BY group_name ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS min_over_three, max(price) OVER (PARTITION BY group_name ROWS BETWEEN UNBOUNDED PRECEDING AND -1 FOLLOWING) AS max_over_partition FROM products ORDER BY group_id

-- Test 178: statement (line 2087)
SELECT avg(price) OVER (PARTITION BY group_name ROWS 1.5 PRECEDING) AS avg_price FROM products

-- Test 179: statement (line 2090)
SELECT avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY group_name ROWS 1.5 PRECEDING)

-- Test 180: statement (line 2093)
SELECT avg(price) OVER (PARTITION BY group_name ROWS BETWEEN 1.5 PRECEDING AND UNBOUNDED FOLLOWING) AS avg_price FROM products

-- Test 181: statement (line 2096)
SELECT avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY group_name ROWS BETWEEN 1.5 PRECEDING AND UNBOUNDED FOLLOWING)

-- Test 182: statement (line 2099)
SELECT avg(price) OVER (PARTITION BY group_name ROWS BETWEEN UNBOUNDED PRECEDING AND 1.5 FOLLOWING) AS avg_price FROM products

-- Test 183: statement (line 2102)
SELECT avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY group_name ROWS BETWEEN UNBOUNDED PRECEDING AND 1.5 FOLLOWING)

-- Test 184: query (line 2105)
SELECT product_name, price, first_value(product_name) OVER w AS first FROM products WHERE price = 200 OR price = 700 WINDOW w as (PARTITION BY price ORDER BY product_name RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ORDER BY price, product_name

-- Test 185: query (line 2114)
SELECT product_name, price, last_value(product_name) OVER w AS last FROM products WHERE price = 200 OR price = 700 WINDOW w as (PARTITION BY price ORDER BY product_name RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ORDER BY price, product_name

-- Test 186: query (line 2123)
SELECT product_name, price, nth_value(product_name, 2) OVER w AS second FROM products WHERE price = 200 OR price = 700 WINDOW w as (PARTITION BY price ORDER BY product_name RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) ORDER BY price, product_name

-- Test 187: query (line 2132)
SELECT product_name, group_name, price, avg(price) OVER (PARTITION BY group_name ORDER BY price, product_name ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS avg_of_three FROM products ORDER BY group_name, price, product_name

-- Test 188: query (line 2147)
SELECT product_name, group_name, price, avg(priceFloat) OVER (PARTITION BY group_name ORDER BY price, product_name ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS avg_of_three_floats FROM products ORDER BY group_name, price, product_name

-- Test 189: query (line 2162)
SELECT product_name, group_name, price, avg(priceInt) OVER (PARTITION BY group_name ORDER BY price, product_name ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS avg_of_three_ints FROM products ORDER BY group_name, price, product_name

-- Test 190: query (line 2177)
SELECT group_name, product_name, price, avg(price) OVER (PARTITION BY group_name ORDER BY group_id ROWS (SELECT count(*) FROM PRODUCTS WHERE price = 200) PRECEDING) AS running_avg_of_three FROM products ORDER BY group_id

-- Test 191: query (line 2192)
SELECT group_name, product_name, price, sum(price) OVER (PARTITION BY group_name ORDER BY group_id ROWS 2 PRECEDING) AS running_sum FROM products ORDER BY group_id

-- Test 192: query (line 2207)
SELECT group_name, product_name, price, array_agg(price) OVER (PARTITION BY group_name ORDER BY group_id ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) AS array_agg_price FROM products ORDER BY group_id

-- Test 193: query (line 2222)
SELECT group_name, product_name, price, array_agg(price) OVER (w ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING), array_agg(price) OVER (w ROWS BETWEEN UNBOUNDED PRECEDING AND 3 FOLLOWING), array_agg(price) OVER (w GROUPS BETWEEN 3 PRECEDING AND UNBOUNDED FOLLOWING), array_agg(price) OVER (w RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) FROM products WINDOW w AS (PARTITION BY group_name ORDER BY group_id DESC) ORDER BY group_id

-- Test 194: query (line 2237)
SELECT group_name, product_name, price, avg(price) OVER (PARTITION BY group_name RANGE UNBOUNDED PRECEDING) AS avg_price FROM products ORDER BY group_id

-- Test 195: query (line 2252)
SELECT group_name, product_name, price, min(price) OVER (PARTITION BY group_name ROWS BETWEEN 1 PRECEDING AND 2 PRECEDING) AS min_over_empty_frame FROM products ORDER BY group_id

-- Test 196: query (line 2267)
SELECT product_name, price, min(price) OVER (PARTITION BY group_name ORDER BY group_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS min_over_three, max(price) OVER (PARTITION BY group_name ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_over_partition FROM products ORDER BY group_id

-- Test 197: query (line 2282)
SELECT group_name, product_name, price, min(price) OVER (PARTITION BY group_name ROWS CURRENT ROW) AS min_over_single_row FROM products ORDER BY group_id

-- Test 198: query (line 2297)
SELECT group_name, product_name, price, avg(price) OVER (PARTITION BY group_name ORDER BY group_id ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING) AS running_avg FROM products ORDER BY group_id

-- Test 199: query (line 2312)
SELECT product_name, price, min(price) OVER (PARTITION BY group_name ORDER BY group_id ROWS UNBOUNDED PRECEDING), max(price) OVER (PARTITION BY group_name ORDER BY group_id ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING), sum(price) OVER (PARTITION BY group_name ORDER BY group_id ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING), avg(price) OVER (PARTITION BY group_name ROWS CURRENT ROW) FROM products ORDER BY group_id

-- Test 200: query (line 2327)
SELECT avg(price) OVER w1, avg(price) OVER w2, avg(price) OVER w1 FROM products WINDOW w1 AS (PARTITION BY group_name ORDER BY group_id ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING), w2 AS (ORDER BY group_id ROWS 1 PRECEDING) ORDER BY group_id

-- Test 201: query (line 2343)
SELECT group_name, product_name, price, sum(price) OVER (RANGE CURRENT ROW) FROM products ORDER BY group_id

-- Test 202: query (line 2358)
SELECT group_name, product_name, price, sum(price) OVER (RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) FROM products ORDER BY group_id

-- Test 203: query (line 2373)
SELECT group_name, product_name, price, sum(price) OVER (RANGE BETWEEN CURRENT ROW AND CURRENT ROW) FROM products ORDER BY group_id

-- Test 204: query (line 2388)
SELECT group_name, product_name, price, sum(price) OVER (RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) FROM products ORDER BY group_id

-- Test 205: statement (line 2403)
SELECT count(*) FILTER (WHERE count(*) > 5) OVER () FROM products

-- Test 206: statement (line 2406)
SELECT count(*) FILTER (WHERE count(*) OVER () > 5) OVER () FROM products

-- Test 207: statement (line 2409)
SELECT count(*) FILTER (WHERE 1) OVER () FROM products

-- Test 208: statement (line 2412)
SELECT price FILTER (WHERE price=1) OVER () FROM products

-- Test 209: query (line 2415)
SELECT count(*) FILTER (WHERE true) OVER (), count(*) FILTER (WHERE false) OVER () FROM products

-- Test 210: query (line 2430)
SELECT avg(price) FILTER (WHERE price > 300) OVER w1, sum(price) FILTER (WHERE group_name = 'Smartphone') OVER w2, avg(price) FILTER (WHERE price = 200 OR price = 700) OVER w1, avg(price) FILTER (WHERE price < 900) OVER w2 FROM products WINDOW w1 AS (ORDER BY group_id), w2 AS (PARTITION BY group_name ORDER BY price, group_id) ORDER BY group_id

-- Test 211: statement (line 2445)
SELECT count(DISTINCT group_name) OVER (), count(DISTINCT product_name) OVER () FROM products

-- Test 212: statement (line 2448)
SELECT sum(price) OVER (RANGE 100 PRECEDING) FROM products

-- Test 213: statement (line 2451)
SELECT sum(price) OVER (ORDER BY price, priceint RANGE 100 PRECEDING) FROM products

-- Test 214: statement (line 2454)
SELECT sum(price) OVER (ORDER BY pdate RANGE '-1 days' PRECEDING) FROM products

-- Test 215: statement (line 2457)
SELECT sum(price) OVER (ORDER BY ptime RANGE BETWEEN '-1 hours' PRECEDING AND '1 hours' FOLLOWING) FROM products

-- Test 216: statement (line 2460)
SELECT sum(price) OVER (ORDER BY ptime RANGE BETWEEN '1 hours' PRECEDING AND '-1 hours' FOLLOWING) FROM products

-- Test 217: statement (line 2463)
SELECT sum(price) OVER (ORDER BY ptimestamp RANGE 123.4 PRECEDING) FROM products

-- Test 218: statement (line 2466)
SELECT sum(price) OVER (ORDER BY ptimestamptz RANGE BETWEEN 123 PRECEDING AND CURRENT ROW) FROM products

-- Test 219: statement (line 2469)
SELECT sum(price) OVER (ORDER BY price RANGE BETWEEN 123.4 PRECEDING AND '1 days' FOLLOWING) FROM products

-- Test 220: statement (line 2472)
SELECT sum(price) OVER (ORDER BY product_name RANGE 'foo' PRECEDING) FROM products

-- Test 221: query (line 2475)
SELECT group_name, product_name, price, sum(priceint) OVER (PARTITION BY group_name ORDER BY priceint RANGE 200 PRECEDING) FROM products ORDER BY group_name, priceint, group_id

-- Test 222: query (line 2490)
SELECT group_name, product_name, price, sum(price) OVER (PARTITION BY group_name ORDER BY price RANGE 200.002 PRECEDING) FROM products ORDER BY group_name, price, group_id

-- Test 223: query (line 2505)
SELECT group_name, product_name, price, sum(pricefloat) OVER (PARTITION BY group_name ORDER BY pricefloat RANGE BETWEEN 200.01 PRECEDING AND 99.99 FOLLOWING) FROM products ORDER BY group_name, priceint, group_id

-- Test 224: query (line 2520)
SELECT group_name, product_name, price, sum(price) OVER (PARTITION BY group_name ORDER BY price RANGE BETWEEN 99.99 PRECEDING AND 100.00 PRECEDING) FROM products ORDER BY group_name, priceint, group_id

-- Test 225: query (line 2535)
SELECT group_name, product_name, price, sum(priceint) OVER (PARTITION BY group_name ORDER BY priceint RANGE BETWEEN 300 PRECEDING AND 50 PRECEDING) FROM products ORDER BY group_name, priceint, group_id

-- Test 226: query (line 2550)
SELECT group_name, product_name, price, sum(priceint) OVER (PARTITION BY group_name ORDER BY priceint RANGE BETWEEN 50 FOLLOWING AND 300 FOLLOWING) FROM products ORDER BY group_name, priceint, group_id

-- Test 227: query (line 2565)
SELECT group_name, price, sum(price) OVER (PARTITION BY group_name ORDER BY price RANGE BETWEEN 49.999 FOLLOWING AND 300.001 FOLLOWING) FROM products ORDER BY group_name, price, group_id

-- Test 228: query (line 2580)
SELECT group_name, price, sum(pricefloat) OVER (PARTITION BY group_name ORDER BY pricefloat RANGE BETWEEN 50 FOLLOWING AND 300 FOLLOWING) FROM products ORDER BY group_name, price, group_id

-- Test 229: query (line 2595)
SELECT group_name, product_name, price, nth_value(pricefloat, 2) OVER (PARTITION BY group_name ORDER BY pricefloat RANGE BETWEEN 1.23 FOLLOWING AND 500.23 FOLLOWING) FROM products ORDER BY group_name, pricefloat, group_id

-- Test 230: query (line 2610)
SELECT group_name, product_name, pdate, price, sum(price) OVER (ORDER BY pdate RANGE '1 days' PRECEDING) FROM products ORDER BY pdate, group_id

-- Test 231: query (line 2625)
SELECT product_name, ptime, price, avg(price) OVER (ORDER BY ptime RANGE BETWEEN '1 hours 15 minutes' PRECEDING AND '1 hours 15 minutes' FOLLOWING) FROM products ORDER BY ptime, group_id

-- Test 232: query (line 2640)
SELECT group_name, product_name, ptime, price, min(price) OVER (PARTITION BY group_name ORDER BY ptime RANGE BETWEEN '1 hours' FOLLOWING AND UNBOUNDED FOLLOWING) FROM products ORDER BY group_name, ptime

-- Test 233: query (line 2655)
SELECT group_name, product_name, ptimestamp, price, first_value(price) OVER (PARTITION BY group_name ORDER BY ptimestamp RANGE BETWEEN '12 hours' PRECEDING AND '6 hours' FOLLOWING) FROM products ORDER BY group_name, ptimestamp

-- Test 234: query (line 2670)
SELECT group_name, product_name, ptimestamptz, price, avg(price) OVER (PARTITION BY group_name ORDER BY ptimestamptz RANGE BETWEEN '1 days 12 hours' PRECEDING AND CURRENT ROW) FROM products ORDER BY group_name, ptimestamptz

-- Test 235: query (line 2685)
SELECT product_name, pinterval, price, avg(price) OVER (ORDER BY pinterval RANGE BETWEEN '2 hours 34 minutes 56 seconds' PRECEDING AND '3 months' FOLLOWING) FROM products ORDER BY pinterval, group_id

-- Test 236: query (line 2700)
SELECT group_name, product_name, price, sum(priceint) OVER (PARTITION BY group_name ORDER BY priceint DESC RANGE 200 PRECEDING) FROM products ORDER BY group_name, priceint DESC, group_id

-- Test 237: query (line 2715)
SELECT group_name, product_name, price, sum(price) OVER (PARTITION BY group_name ORDER BY price DESC RANGE 200.002 PRECEDING) FROM products ORDER BY group_name, price DESC, group_id

-- Test 238: query (line 2730)
SELECT group_name, product_name, price, sum(pricefloat) OVER (PARTITION BY group_name ORDER BY pricefloat DESC RANGE BETWEEN 200.01 PRECEDING AND 99.99 FOLLOWING) FROM products ORDER BY group_name, priceint DESC, group_id

-- Test 239: query (line 2745)
SELECT group_name, product_name, price, sum(price) OVER (PARTITION BY group_name ORDER BY price DESC RANGE BETWEEN 99.99 PRECEDING AND 100.00 PRECEDING) FROM products ORDER BY group_name, priceint DESC, group_id

-- Test 240: query (line 2760)
SELECT group_name, product_name, price, sum(priceint) OVER (PARTITION BY group_name ORDER BY priceint DESC RANGE BETWEEN 300 PRECEDING AND 50 PRECEDING) FROM products ORDER BY group_name, priceint DESC, group_id

-- Test 241: query (line 2775)
SELECT group_name, product_name, price, sum(priceint) OVER (PARTITION BY group_name ORDER BY priceint DESC RANGE BETWEEN 50 FOLLOWING AND 300 FOLLOWING) FROM products ORDER BY group_name, priceint DESC, group_id

-- Test 242: query (line 2790)
SELECT group_name, price, sum(price) OVER (PARTITION BY group_name ORDER BY price DESC RANGE BETWEEN 49.999 FOLLOWING AND 300.001 FOLLOWING) FROM products ORDER BY group_name, price DESC, group_id

-- Test 243: query (line 2805)
SELECT group_name, price, sum(pricefloat) OVER (PARTITION BY group_name ORDER BY pricefloat DESC RANGE BETWEEN 50 FOLLOWING AND 300 FOLLOWING) FROM products ORDER BY group_name, price DESC, group_id

-- Test 244: query (line 2820)
SELECT group_name, product_name, price, nth_value(pricefloat, 2) OVER (PARTITION BY group_name ORDER BY pricefloat DESC RANGE BETWEEN 1.23 FOLLOWING AND 500.23 FOLLOWING) FROM products ORDER BY group_name, pricefloat DESC, group_id

-- Test 245: query (line 2835)
SELECT group_name, product_name, pdate, price, sum(price) OVER (ORDER BY pdate DESC RANGE '1 days' PRECEDING) FROM products ORDER BY pdate DESC, group_id

-- Test 246: query (line 2850)
SELECT product_name, ptime, price, avg(price) OVER (ORDER BY ptime DESC RANGE BETWEEN '1 hours 15 minutes' PRECEDING AND '1 hours 15 minutes' FOLLOWING) FROM products ORDER BY ptime DESC, group_id

-- Test 247: query (line 2865)
SELECT group_name, product_name, ptime, price, min(price) OVER (PARTITION BY group_name ORDER BY ptime DESC RANGE BETWEEN '1 hours' FOLLOWING AND UNBOUNDED FOLLOWING) FROM products ORDER BY group_name, ptime DESC

-- Test 248: query (line 2880)
SELECT group_name, product_name, ptimestamp, price, first_value(price) OVER (PARTITION BY group_name ORDER BY ptimestamp DESC RANGE BETWEEN '12 hours' PRECEDING AND '6 hours' FOLLOWING) FROM products ORDER BY group_name, ptimestamp DESC

-- Test 249: query (line 2895)
SELECT group_name, product_name, ptimestamptz, price, avg(price) OVER (PARTITION BY group_name ORDER BY ptimestamptz DESC RANGE BETWEEN '1 days 12 hours' PRECEDING AND CURRENT ROW) FROM products ORDER BY group_name, ptimestamptz DESC

-- Test 250: query (line 2910)
SELECT product_name, pinterval, price, avg(price) OVER (ORDER BY pinterval DESC RANGE BETWEEN '2 hours 34 minutes 56 seconds' PRECEDING AND '3 months' FOLLOWING) FROM products ORDER BY pinterval DESC, group_id

-- Test 251: query (line 2925)
SELECT group_name, price, product_name, array_agg(product_name) OVER (PARTITION BY group_name ORDER BY price, group_id) FROM products ORDER BY group_id

-- Test 252: query (line 2940)
SELECT product_name, array_agg(product_name) OVER (ORDER BY group_id) FROM products ORDER BY group_id

-- Test 253: statement (line 2955)
SELECT avg(price) OVER (GROUPS group_id PRECEDING) FROM products

-- Test 254: statement (line 2958)
SELECT avg(price) OVER (GROUPS 1 PRECEDING) FROM products

-- Test 255: statement (line 2961)
SELECT avg(price) OVER (ORDER BY group_id GROUPS NULL PRECEDING) FROM products

-- Test 256: statement (line 2964)
SELECT avg(price) OVER (ORDER BY group_id GROUPS BETWEEN NULL PRECEDING AND 1 FOLLOWING) FROM products

-- Test 257: statement (line 2967)
SELECT price, avg(price) OVER (PARTITION BY price ORDER BY group_id GROUPS -1 PRECEDING) AS avg_price FROM products

-- Test 258: statement (line 2970)
SELECT price, avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY price ORDER BY group_id GROUPS -1 PRECEDING)

-- Test 259: statement (line 2973)
SELECT avg(price) OVER (ORDER BY group_id GROUPS BETWEEN 1 PRECEDING AND NULL FOLLOWING) FROM products

-- Test 260: statement (line 2976)
SELECT price, avg(price) OVER (PARTITION BY price ORDER BY group_id GROUPS BETWEEN 1 FOLLOWING AND -1 FOLLOWING) AS avg_price FROM products

-- Test 261: statement (line 2979)
SELECT price, avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY price ORDER BY group_id GROUPS BETWEEN 1 FOLLOWING AND -1 FOLLOWING)

-- Test 262: statement (line 2982)
SELECT product_name, price, min(price) OVER (PARTITION BY group_name ORDER BY group_id GROUPS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS min_over_three, max(price) OVER (PARTITION BY group_name ORDER BY group_id GROUPS BETWEEN UNBOUNDED PRECEDING AND -1 FOLLOWING) AS max_over_partition FROM products ORDER BY group_id

-- Test 263: statement (line 2985)
SELECT avg(price) OVER (PARTITION BY group_name ORDER BY group_id GROUPS 1.5 PRECEDING) AS avg_price FROM products

-- Test 264: statement (line 2988)
SELECT avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY group_name ORDER BY group_id GROUPS 1.5 PRECEDING)

-- Test 265: statement (line 2991)
SELECT avg(price) OVER (PARTITION BY group_name ORDER BY group_id GROUPS BETWEEN 1.5 PRECEDING AND UNBOUNDED FOLLOWING) AS avg_price FROM products

-- Test 266: statement (line 2994)
SELECT avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY group_name ORDER BY group_id GROUPS BETWEEN 1.5 PRECEDING AND UNBOUNDED FOLLOWING)

-- Test 267: statement (line 2997)
SELECT avg(price) OVER (PARTITION BY group_name ORDER BY group_id GROUPS BETWEEN UNBOUNDED PRECEDING AND 1.5 FOLLOWING) AS avg_price FROM products

-- Test 268: statement (line 3000)
SELECT avg(price) OVER w AS avg_price FROM products WINDOW w AS (PARTITION BY group_name ORDER BY group_id GROUPS BETWEEN UNBOUNDED PRECEDING AND 1.5 FOLLOWING)

-- Test 269: query (line 3003)
SELECT price, sum(price) OVER (ORDER BY price GROUPS UNBOUNDED PRECEDING), sum(price) OVER (ORDER BY price GROUPS 100 PRECEDING), sum(price) OVER (ORDER BY price GROUPS 1 PRECEDING), sum(price) OVER (ORDER BY group_name GROUPS CURRENT ROW) FROM products ORDER BY price, group_id

-- Test 270: query (line 3018)
SELECT price, dense_rank() OVER w, avg(price) OVER (w GROUPS BETWEEN UNBOUNDED PRECEDING AND 100 PRECEDING), avg(price) OVER (w GROUPS BETWEEN UNBOUNDED PRECEDING AND 2 PRECEDING), avg(price) OVER (w GROUPS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), avg(price) OVER (w GROUPS BETWEEN UNBOUNDED PRECEDING AND 2 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN UNBOUNDED PRECEDING AND 100 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) FROM products WINDOW w AS (ORDER BY price) ORDER BY price

-- Test 271: query (line 3033)
SELECT price, dense_rank() OVER w, avg(price) OVER (w GROUPS BETWEEN 4 PRECEDING AND 100 PRECEDING), avg(price) OVER (w GROUPS BETWEEN 3 PRECEDING AND 2 PRECEDING), avg(price) OVER (w GROUPS BETWEEN 2 PRECEDING AND CURRENT ROW), avg(price) OVER (w GROUPS BETWEEN 1 PRECEDING AND 2 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN 1 PRECEDING AND 100 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING) FROM products WINDOW w AS (ORDER BY price) ORDER BY price

-- Test 272: query (line 3048)
SELECT price, dense_rank() OVER w, avg(price) OVER (w GROUPS BETWEEN 0 PRECEDING AND 0 PRECEDING), avg(price) OVER (w GROUPS BETWEEN 0 PRECEDING AND CURRENT ROW), avg(price) OVER (w GROUPS BETWEEN 0 PRECEDING AND 0 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN CURRENT ROW AND CURRENT ROW), avg(price) OVER (w GROUPS BETWEEN CURRENT ROW AND 2 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN CURRENT ROW AND 100 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) FROM products WINDOW w AS (ORDER BY price) ORDER BY price

-- Test 273: query (line 3063)
SELECT price, dense_rank() OVER w, avg(price) OVER (w GROUPS BETWEEN 3 FOLLOWING AND 100 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN 3 FOLLOWING AND 1 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN 2 FOLLOWING AND 6 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN 3 FOLLOWING AND 3 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN 0 FOLLOWING AND 4 FOLLOWING), avg(price) OVER (w GROUPS BETWEEN 5 FOLLOWING AND UNBOUNDED FOLLOWING) FROM products WINDOW w AS (ORDER BY price) ORDER BY price

-- Test 274: query (line 3078)
SELECT group_name, product_name, price, avg(price) OVER (PARTITION BY group_name ORDER BY price GROUPS BETWEEN CURRENT ROW AND 3 FOLLOWING), avg(price) OVER (ORDER BY price GROUPS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) FROM products ORDER BY group_id

-- Test 275: query (line 3093)
SELECT group_name, product_name, price, avg(price) OVER (ORDER BY group_id GROUPS BETWEEN 1 PRECEDING AND 2 PRECEDING), avg(price) OVER (ORDER BY price GROUPS BETWEEN CURRENT ROW AND CURRENT ROW) FROM products ORDER BY group_id

-- Test 276: query (line 3108)
SELECT
	price, array_agg(price) OVER w, sum(price) OVER w
FROM
	products
WINDOW
	w AS (
		ORDER BY
			price
		RANGE
			UNBOUNDED PRECEDING EXCLUDE CURRENT ROW
	)
ORDER BY
	price

-- Test 277: query (line 3135)
SELECT
	price, array_agg(price) OVER w, max(price) OVER w
FROM
	products
WINDOW
	w AS (
		ORDER BY
			price
		RANGE
			UNBOUNDED PRECEDING EXCLUDE GROUP
	)
ORDER BY
	price

-- Test 278: query (line 3162)
SELECT
	price, array_agg(price) OVER w, avg(price) OVER w
FROM
	products
WINDOW
	w AS (
		ORDER BY
			price
		RANGE
			UNBOUNDED PRECEDING EXCLUDE TIES
	)
ORDER BY
	price

-- Test 279: query (line 3189)
SELECT
	price, array_agg(price) OVER w, avg(price) OVER w
FROM
	products
WINDOW
	w AS (
		ORDER BY
			price
		RANGE
			UNBOUNDED PRECEDING EXCLUDE NO OTHERS
	)
ORDER BY
	price

-- Test 280: query (line 3216)
SELECT
	first_value(product_name) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE CURRENT ROW
	),
	first_value(product_name) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE GROUP
	),
	first_value(product_name) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE TIES
	),
	first_value(product_name) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE NO OTHERS
	)
FROM
	products
WINDOW
	w AS (ORDER BY group_id)
ORDER BY
	group_id

-- Test 281: query (line 3249)
SELECT
	last_value(product_name) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE CURRENT ROW
	),
	last_value(product_name) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE GROUP
	),
	last_value(product_name) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE TIES
	),
	last_value(product_name) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE NO OTHERS
	)
FROM
	products
WINDOW
	w AS (ORDER BY group_id)
ORDER BY
	group_id

-- Test 282: query (line 3282)
SELECT
	nth_value(product_name, 2) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE CURRENT ROW
	),
	nth_value(product_name, 3) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE GROUP
	),
	nth_value(product_name, 4) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE TIES
	),
	nth_value(product_name, 5) OVER (
		w RANGE UNBOUNDED PRECEDING EXCLUDE NO OTHERS
	)
FROM
	products
WINDOW
	w AS (ORDER BY group_id)
ORDER BY
	group_id

-- Test 283: statement (line 3317)
CREATE TABLE x (a INT)

-- Test 284: statement (line 3320)
INSERT INTO x VALUES (1), (2), (3)

-- Test 285: query (line 3323)
SELECT a, json_agg(a) OVER (ORDER BY a) FROM x ORDER BY a

-- Test 286: query (line 3331)
SELECT
    row_number() OVER (PARTITION BY s)
FROM
    (SELECT sum(a) AS s FROM (SELECT a FROM x UNION ALL SELECT a FROM x) GROUP BY a)

-- Test 287: statement (line 3343)
SELECT sum(a) OVER (PARTITION BY count(a) OVER ()) FROM x

-- Test 288: statement (line 3346)
SELECT sum(a) OVER (ORDER BY count(a) OVER ()) FROM x

-- Test 289: statement (line 3349)
SELECT sum(a) OVER (PARTITION BY count(a) OVER () + 1) FROM x

-- Test 290: statement (line 3352)
SELECT sum(a) OVER (ORDER BY count(a) OVER () + 1) FROM x

-- Test 291: query (line 3359)
SELECT sum(a) OVER (PARTITION BY (SELECT count(*) FROM x GROUP BY a LIMIT 1))::INT FROM x

-- Test 292: query (line 3369)
SELECT
    min(a) OVER (PARTITION BY (a, a)) AS min,
    max(a) OVER (PARTITION BY (a, a)) AS max
FROM
    (SELECT 1 AS a)

-- Test 293: query (line 3378)
SELECT
    min(a) OVER (PARTITION BY (())) AS min,
    max(a) OVER (PARTITION BY (())) AS max
FROM
    (SELECT 1 AS a)

-- Test 294: query (line 3387)
SELECT string_agg('foo', s) OVER () FROM (SELECT * FROM kv LIMIT 1)

-- Test 295: query (line 3393)
SELECT jsonb_agg(a) OVER (ORDER BY a GROUPS BETWEEN 5 FOLLOWING AND UNBOUNDED FOLLOWING) FROM x

-- Test 296: statement (line 3400)
CREATE TABLE abc (a INT PRIMARY KEY, b INT, c INT)

-- Test 297: statement (line 3403)
INSERT INTO abc VALUES
  (1, 10, 20),
  (2, 10, 20),
  (3, 10, 20),
  (4, 10, 30),
  (5, 10, 30),
  (6, 10, 30)

-- Test 298: query (line 3412)
SELECT
  avg(a) OVER (),
  avg(a) OVER (ORDER BY a),
  avg(a) OVER (ORDER BY b),
  avg(a) OVER (ORDER BY c),
  avg(b) OVER (),
  avg(b) OVER (ORDER BY a),
  avg(b) OVER (ORDER BY b),
  avg(b) OVER (ORDER BY c),
  avg(c) OVER (),
  avg(c) OVER (ORDER BY a),
  avg(c) OVER (ORDER BY b),
  avg(c) OVER (ORDER BY c)
FROM abc

-- Test 299: query (line 3435)
SELECT
  avg(a) OVER            (RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(a) OVER (ORDER BY a RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(a) OVER (ORDER BY b RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(a) OVER (ORDER BY c RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(b) OVER            (RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(b) OVER (ORDER BY a RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(b) OVER (ORDER BY b RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(b) OVER (ORDER BY c RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(c) OVER            (RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(c) OVER (ORDER BY a RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(c) OVER (ORDER BY b RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING),
  avg(c) OVER (ORDER BY c RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM abc

-- Test 300: query (line 3458)
SELECT array_agg(a) OVER (w RANGE 1 PRECEDING) FROM x WINDOW w AS (ORDER BY a DESC) ORDER BY a

-- Test 301: statement (line 3465)
SELECT array_agg(a) OVER (w GROUPS 1 PRECEDING) FROM x WINDOW w AS (PARTITION BY a)

-- Test 302: query (line 3468)
SELECT array_agg(a) OVER (w GROUPS 1 PRECEDING) FROM x WINDOW w AS (PARTITION BY a ORDER BY a DESC) ORDER BY a

-- Test 303: statement (line 3476)
DROP TABLE IF EXISTS t

-- Test 304: statement (line 3479)
CREATE TABLE t (a INT PRIMARY KEY, b INT)

-- Test 305: statement (line 3482)
INSERT INTO t VALUES (1, 1), (2, NULL), (3, 3)

-- Test 306: query (line 3485)
SELECT min(b) OVER () FROM t

-- Test 307: query (line 3492)
SELECT a, b, sum(b) OVER (ROWS 0 PRECEDING) FROM t ORDER BY a

-- Test 308: query (line 3499)
SELECT a, b, avg(b) OVER () FROM t ORDER BY a

-- Test 309: query (line 3506)
SELECT a, b, avg(b) OVER (ROWS 0 PRECEDING) FROM t ORDER BY a

-- Test 310: statement (line 3513)
CREATE TABLE wxyz (w INT PRIMARY KEY, x INT, y INT, z INT)

-- Test 311: statement (line 3516)
INSERT INTO wxyz VALUES
  (1, 10, 1, 1),
  (2, 10, 2, 0),
  (3, 10, 1, 1),
  (4, 10, 2, 0),
  (5, 10, 2, 1),
  (6, 10, 2, 0)

-- Test 312: query (line 3526)
SELECT *, rank() OVER (PARTITION BY z ORDER BY y) FROM wxyz ORDER BY y LIMIT 2

-- Test 313: query (line 3532)
SELECT *, dense_rank() OVER (PARTITION BY z ORDER BY y) FROM wxyz ORDER BY y LIMIT 2

-- Test 314: query (line 3538)
SELECT *, avg(w) OVER (PARTITION BY z ORDER BY y) FROM wxyz ORDER BY y LIMIT 2

-- Test 315: query (line 3544)
SELECT *, rank() OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY y LIMIT 2

-- Test 316: query (line 3550)
SELECT *, dense_rank() OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY y LIMIT 2

-- Test 317: query (line 3556)
SELECT *, avg(w) OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY y LIMIT 2

-- Test 318: query (line 3562)
SELECT *, rank() OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY w, y LIMIT 2

-- Test 319: query (line 3568)
SELECT *, dense_rank() OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY w, y LIMIT 2

-- Test 320: query (line 3574)
SELECT *, avg(w) OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY w, y LIMIT 2

-- Test 321: query (line 3580)
SELECT *, rank() OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY w LIMIT 2

-- Test 322: query (line 3586)
SELECT *, dense_rank() OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY w LIMIT 2

-- Test 323: query (line 3592)
SELECT *, avg(w) OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY w LIMIT 2

-- Test 324: query (line 3598)
SELECT *, rank() OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY y, w LIMIT 2

-- Test 325: query (line 3604)
SELECT *, dense_rank() OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY y, w LIMIT 2

-- Test 326: query (line 3610)
SELECT *, avg(w) OVER (PARTITION BY w ORDER BY y) FROM wxyz ORDER BY y, w LIMIT 2

-- Test 327: query (line 3616)
SELECT *, rank() OVER (PARTITION BY w, z ORDER BY y) FROM wxyz ORDER BY w, z, y LIMIT 2

-- Test 328: query (line 3622)
SELECT *, dense_rank() OVER (PARTITION BY w, z ORDER BY y) FROM wxyz ORDER BY w, z, y LIMIT 2

-- Test 329: query (line 3628)
SELECT *, avg(w) OVER (PARTITION BY w, z ORDER BY y) FROM wxyz ORDER BY w, z, y LIMIT 2

-- Test 330: query (line 3634)
SELECT *, rank() OVER (PARTITION BY w, z ORDER BY y) FROM wxyz ORDER BY z, w, y LIMIT 2

-- Test 331: query (line 3640)
SELECT *, dense_rank() OVER (PARTITION BY w, z ORDER BY y) FROM wxyz ORDER BY z, w, y LIMIT 2

-- Test 332: query (line 3646)
SELECT *, avg(w) OVER (PARTITION BY w, z ORDER BY y) FROM wxyz ORDER BY z, w, y LIMIT 2

-- Test 333: statement (line 3659)
INSERT INTO string_agg_test VALUES
  (1, 1, 'A'),
  (2, 2, 'B'),
  (3, 3, 'C'),
  (4, 4, 'D'),
  (5, 3, 'C'),
  (6, 4, 'D'),
  (7, 4, 'D'),
  (8, 4, 'D'),
  (9, 3, 'C'),
  (10, 2, 'B')

-- Test 334: query (line 3672)
SELECT company_id, string_agg(employee, ',')
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 335: query (line 3690)
SELECT company_id, string_agg(employee::BYTES, b',')
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 336: query (line 3708)
SELECT company_id, string_agg(employee, '')
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 337: query (line 3726)
SELECT company_id, string_agg(employee::BYTES, b'')
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 338: query (line 3744)
SELECT company_id, string_agg(employee, NULL)
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 339: query (line 3762)
SELECT company_id, string_agg(employee::BYTES, NULL)
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 340: query (line 3798)
SELECT company_id, string_agg(NULL::BYTES, employee::BYTES)
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 341: query (line 3834)
SELECT company_id, string_agg(NULL::BYTES, NULL)
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 342: query (line 3870)
SELECT company_id, string_agg(NULL, NULL::BYTES)
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 343: query (line 3888)
SELECT company_id, string_agg(NULL, NULL)
OVER (PARTITION BY company_id ORDER BY id)
FROM string_agg_test
ORDER BY company_id, id;

query IT colnames
SELECT company_id, string_agg(employee, lower(employee))
OVER (PARTITION BY company_id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 344: query (line 3912)
SELECT company_id, string_agg(lower(employee), employee)
OVER (PARTITION BY company_id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 345: statement (line 3930)
SELECT company_id, string_agg(employee, employee, employee)
OVER (PARTITION BY company_id)
FROM string_agg_test
ORDER BY company_id, id;

-- Test 346: statement (line 3976)
CREATE TABLE t38901 (a INT PRIMARY KEY); INSERT INTO t38901 VALUES (1), (2), (3)

-- Test 347: query (line 3979)
SELECT array_agg(a) OVER (ORDER BY a ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING) FROM t38901 ORDER BY a

-- Test 348: query (line 3987)
SELECT
	a,
	b,
	count(*) OVER (ORDER BY b),
	count(*) OVER (
		ORDER BY
			b
		RANGE
			BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	),
	count(*) OVER (
		ORDER BY
			b
		ROWS
			BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	)
FROM
	(VALUES (1, 1), (2, 1), (3, 2), (4, 2)) AS t (a, b)
ORDER BY
	a, b

-- Test 349: query (line 4014)
SELECT
  *,
  array_agg(v) OVER (wv RANGE BETWEEN UNBOUNDED PRECEDING AND 0 PRECEDING),
  array_agg(v) OVER (wv RANGE BETWEEN 0 PRECEDING AND 1 PRECEDING),
  array_agg(f) OVER (wf RANGE BETWEEN UNBOUNDED PRECEDING AND -0.0 PRECEDING),
  array_agg(f) OVER (wf RANGE BETWEEN 0.0 PRECEDING AND 1.0 PRECEDING),
  array_agg(d) OVER (wd RANGE BETWEEN 0.0 FOLLOWING AND 0.0 FOLLOWING),
  array_agg(d) OVER (wd RANGE BETWEEN 1.0 FOLLOWING AND UNBOUNDED FOLLOWING),
  array_agg(i) OVER (wi RANGE BETWEEN '1s'::INTERVAL PRECEDING AND '0s'::INTERVAL PRECEDING),
  array_agg(i) OVER (wi RANGE BETWEEN '1s'::INTERVAL FOLLOWING AND '1s'::INTERVAL FOLLOWING)
FROM
  kv
WINDOW
  wv AS (ORDER BY v DESC),
  wf AS (ORDER BY f),
  wd AS (ORDER BY d DESC),
  wi AS (ORDER BY i)
ORDER BY
  k

-- Test 350: query (line 4047)
SELECT
  *,
  array_agg(v) OVER (wv RANGE BETWEEN UNBOUNDED PRECEDING AND 0 PRECEDING),
  array_agg(v) OVER (wv RANGE BETWEEN 0 PRECEDING AND 1 PRECEDING),
  array_agg(f) OVER (wf RANGE BETWEEN UNBOUNDED PRECEDING AND -0.0 PRECEDING),
  array_agg(f) OVER (wf RANGE BETWEEN 0.0 PRECEDING AND 1.0 PRECEDING),
  array_agg(d) OVER (wd RANGE BETWEEN 0.0 FOLLOWING AND 0.0 FOLLOWING),
  array_agg(d) OVER (wd RANGE BETWEEN 1.0 FOLLOWING AND UNBOUNDED FOLLOWING),
  array_agg(i) OVER (wi RANGE BETWEEN '1s'::INTERVAL PRECEDING AND '0s'::INTERVAL PRECEDING),
  array_agg(i) OVER (wi RANGE BETWEEN '1s'::INTERVAL FOLLOWING AND '1s'::INTERVAL FOLLOWING)
FROM
  kv
WINDOW
  wv AS (PARTITION BY v ORDER BY v),
  wf AS (PARTITION BY f ORDER BY f DESC),
  wd AS (PARTITION BY d ORDER BY d),
  wi AS (PARTITION BY i ORDER BY i DESC)
ORDER BY
  k

-- Test 351: query (line 4079)
SELECT count(*) >= 26 FROM crdb_internal.feature_usage WHERE feature_name LIKE 'sql.plan.window_function%' AND usage_count > 0

-- Test 352: query (line 4085)
SELECT
  max(k) OVER (w GROUPS BETWEEN 9223372036854775807 FOLLOWING AND UNBOUNDED FOLLOWING),
  max(k) OVER (w GROUPS BETWEEN UNBOUNDED PRECEDING AND 9223372036854775807 FOLLOWING)
FROM kv WINDOW w AS (PARTITION BY b ORDER BY v)

-- Test 353: statement (line 4104)
CREATE TABLE t53442_a (a INT8 PRIMARY KEY);
CREATE TABLE t53442_b (b INT2 PRIMARY KEY);

-- Test 354: statement (line 4108)
SELECT max(b::INT8) OVER (PARTITION BY b ORDER BY b RANGE 1 PRECEDING)
FROM t53442_b NATURAL JOIN t53442_a
WHERE false

-- Test 355: statement (line 4113)
SELECT max(b::INT8) OVER (PARTITION BY b ORDER BY a RANGE 1 PRECEDING)
FROM t53442_b NATURAL JOIN t53442_a
WHERE false

-- Test 356: query (line 4124)
SELECT json_object_agg(s, s) OVER (ORDER BY s DESC) FROM t54604

-- Test 357: query (line 4133)
SELECT jsonb_object_agg(s, s) OVER (ORDER BY s RANGE UNBOUNDED PRECEDING) FROM t54604

-- Test 358: statement (line 4143)
CREATE TABLE t55944 (x decimal);
INSERT INTO t55944 (x)
VALUES (1.0),
       (20.0),
       (25.0),
       (41.0),
       (55.5),
       (60.9),
       (72.0),
       (88.0),
       (88.0),
       (89.0);

-- Test 359: query (line 4157)
SELECT x,
       sqrdiff(x) OVER (ORDER BY x) as sqrdiff,
       var_pop(x) OVER (ORDER BY x) as var_pop,
       var_samp(x) OVER (ORDER BY x) as var_samp,
       stddev_pop(x) OVER (ORDER BY x) as stddev_pop,
       stddev_samp(x) OVER (ORDER BY x) as stddev_samp
FROM t55944
ORDER BY x

-- Test 360: statement (line 4180)
CREATE TABLE t64793 (b TEXT)

-- Test 361: statement (line 4183)
INSERT INTO t64793 VALUES
('alpha'),
(NULL::TEXT)

-- Test 362: query (line 4188)
SELECT lag(b, 0) OVER (ORDER BY b DESC) FROM t64793 ORDER BY b

-- Test 363: statement (line 4196)
CREATE TABLE t65978 (c INT);
INSERT INTO t65978 VALUES (1), (2);

-- Test 364: query (line 4200)
SELECT max(c) OVER (ROWS BETWEEN 9223372036854775807::INT8 FOLLOWING AND UNBOUNDED FOLLOWING) FROM t65978

-- Test 365: query (line 4206)
SELECT max(c) OVER (ORDER BY c ROWS BETWEEN UNBOUNDED PRECEDING AND 9223372036854775807::INT8 FOLLOWING) FROM t65978

-- Test 366: query (line 4212)
SELECT max(c) OVER (ROWS BETWEEN 9223372036854775807::INT8 PRECEDING AND UNBOUNDED FOLLOWING) FROM t65978

-- Test 367: query (line 4218)
SELECT max(c) OVER (ORDER BY c ROWS BETWEEN UNBOUNDED PRECEDING AND 9223372036854775807::INT8 PRECEDING) FROM t65978

-- Test 368: query (line 4226)
SELECT k, first_value(k) OVER (ORDER BY v GROUPS BETWEEN 0 PRECEDING AND 2 PRECEDING) FROM kv ORDER BY 1

-- Test 369: query (line 4241)
SELECT min(x)
OVER
(
  ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  EXCLUDE CURRENT ROW
)
FROM (VALUES (NULL::INT), (NULL::INT), (1)) v(x);

-- Test 370: statement (line 4256)
DROP TABLE IF EXISTS t;

-- Test 371: statement (line 4259)
CREATE TABLE t (x DATE);
INSERT INTO t VALUES ('5874897-01-01'::DATE), ('1999-01-08'::DATE);
SET vectorize=off;

-- Test 372: query (line 4264)
SELECT first_value(x) OVER (ORDER BY x RANGE BETWEEN CURRENT ROW AND '0 YEAR'::INTERVAL FOLLOWING) FROM t;

statement ok
RESET vectorize;

# Regression test for incorrect results for min and max when the window frame
# shrinks.
statement ok
DROP TABLE IF EXISTS t;

statement ok
CREATE TABLE t (a INT);
INSERT INTO t VALUES (1), (-1), (NULL);
SET vectorize=off;

query III rowsort
SELECT a, max(a) OVER w, min(a) OVER w FROM t
WINDOW w AS (ORDER BY a DESC RANGE BETWEEN 10 PRECEDING AND UNBOUNDED FOLLOWING);

-- Test 373: statement (line 4288)
RESET vectorize;

-- Test 374: statement (line 4294)
DROP TABLE IF EXISTS t;

-- Test 375: query (line 4304)
SELECT x, y, first_value(y) OVER (PARTITION BY x ROWS BETWEEN CURRENT ROW AND CURRENT ROW) FROM t;

-- Test 376: statement (line 4317)
CREATE TABLE t74087 AS
  SELECT
    g::INT2 AS _int2, g::INT4 AS _int4
  FROM
    ROWS FROM (generate_series(1, 5)) AS g;

-- Test 377: query (line 4324)
SELECT
  lag(_int2, _int4, _int2) OVER w,
  lead(_int4, _int2, _int4) OVER w,
  first_value(_int2) OVER w,
  last_value(_int4) OVER w,
  nth_value(_int2, _int4) OVER w,
  min(_int4) OVER w,
  row_number() OVER w,
  rank() OVER w,
  dense_rank() OVER w,
  percent_rank() OVER w,
  cume_dist() OVER w,
  ntile(_int2) OVER w
FROM t74087 WINDOW w AS (ORDER BY _int4);

-- Test 378: query (line 4348)
SELECT lead(x, 10, y::INT4) OVER () FROM (VALUES (1, 2)) v(x, y);

-- Test 379: statement (line 4354)
CREATE TABLE nulls_last_test (
    id INT NULL
);
INSERT INTO nulls_last_test VALUES
  (1),
  (2),
  (null),
  (3);

-- Test 380: query (line 4364)
SELECT
  id,
  row_number() OVER (ORDER BY id NULLS LAST) AS row_num_using_nulls_last,
  row_number() OVER (ORDER BY COALESCE(id, 999)) AS row_num_using_coalesce
FROM
  nulls_last_test
ORDER BY
  id NULLS LAST

-- Test 381: statement (line 4379)
SET null_ordered_last = true

-- Test 382: query (line 4383)
SELECT
  id,
  row_number() OVER (ORDER BY id) AS row_num_using_nulls_last,
  row_number() OVER (ORDER BY COALESCE(id, 999)) AS row_num_using_coalesce
FROM
  nulls_last_test
ORDER BY
  id

-- Test 383: statement (line 4398)
RESET null_ordered_last

