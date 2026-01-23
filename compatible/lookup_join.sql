-- PostgreSQL compatible tests from lookup_join
-- 210 tests

-- Test 1: statement (line 3)
CREATE TABLE abc (a INT, b INT, c INT, PRIMARY KEY (a, c));
INSERT INTO abc VALUES (1, 1, 2), (2, 1, 1), (2, NULL, 2);

-- Test 2: statement (line 7)
CREATE TABLE def (d INT, e INT, f INT, PRIMARY KEY (f, e));
INSERT INTO def VALUES (1, 1, 2), (2, 1, 1), (NULL, 2, 1);

-- Test 3: statement (line 11)
CREATE TABLE def_e_desc (d INT, e INT, f INT, PRIMARY KEY (f, e));
INSERT INTO def_e_desc VALUES (1, 1, 2), (2, 1, 1), (NULL, 2, 1);

-- Test 4: statement (line 15)
CREATE TABLE def_e_decimal (d INT, e DECIMAL, f INT, PRIMARY KEY (f, e));
INSERT INTO def_e_decimal VALUES (1, 1, 2), (2, 1, 1), (NULL, 2, 1);

-- Test 5: statement (line 19)
CREATE TABLE float_xy (x FLOAT, y INT);
INSERT INTO float_xy VALUES (1, 1), (2, 1), (NULL, 2), ('NaN'::FLOAT, 3), ('+Inf'::FLOAT, 4), ('-Inf'::FLOAT, 5);

-- Test 6: statement (line 23)
CREATE TABLE string_xy (x TEXT, y INT);
INSERT INTO string_xy VALUES ('abc', 1), ('abcd', 2), ('bcd', 3), ('xyz', 4), ('', 5), (NULL, 6);

-- Test 7: statement (line 27)
CREATE TABLE time_xy (x TIME, y TIMESTAMP);
INSERT INTO time_xy
VALUES
('00:00:00'::TIME, '2016-06-22 19:10:25'::TIMESTAMP),
('24:00:00'::TIME, '2042-01-01 00:00:00'::TIMESTAMP),
('23:59:59.999999'::TIME, '1970-01-01 00:00:00'::TIMESTAMP),
('00:52:12.19515'::TIME, NULL),
(NULL, 'infinity'::TIMESTAMP),
('00:00:00'::TIME, '-infinity'::TIMESTAMP);

-- Test 8: statement (line 38)
CREATE TABLE gh (g INT, h INT);
INSERT INTO gh VALUES (NULL, 1);

-- Test 9: statement (line 44)
-- ALTER TABLE abc INJECT STATISTICS '[
--   {
--     "columns": ["a"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 100,
--     "distinct_count": 100
--   }
-- ]'

-- Test 10: statement (line 54)
-- ALTER TABLE def INJECT STATISTICS '[
--   {
--     "columns": ["f"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 10000,
--     "distinct_count": 10000
--   }
-- ]'

-- Test 11: statement (line 64)
-- ALTER TABLE def_e_desc INJECT STATISTICS '[
--   {
--     "columns": ["f"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 10000,
--     "distinct_count": 10000
--   }
-- ]'

-- Test 12: statement (line 74)
-- ALTER TABLE def_e_decimal INJECT STATISTICS '[
--   {
--     "columns": ["f"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 10000,
--     "distinct_count": 10000
--   }
-- ]'

-- Test 13: statement (line 84)
-- ALTER TABLE gh INJECT STATISTICS '[
--   {
--     "columns": ["g"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 10000,
--     "distinct_count": 10000
--   }
-- ]'

-- Test 14: query (line 94)
SELECT * FROM abc JOIN def ON f = b;

-- Test 15: query (line 102)
SELECT * FROM abc JOIN def ON f = b AND e = c;

-- Test 16: query (line 108)
SELECT * FROM abc JOIN def ON f = b WHERE a > 1 AND e > 1;

-- Test 17: query (line 113)
SELECT * FROM abc JOIN def ON f = b AND a > 1 AND e > 1;

-- Test 18: query (line 118)
SELECT * FROM abc JOIN def_e_desc ON f = b AND a > 1 AND e > 1;

-- Test 19: query (line 123)
SELECT * FROM abc JOIN def_e_decimal ON f = b AND a > 1 AND e > 1;

-- Test 20: query (line 129)
SELECT * FROM abc JOIN def ON f = b AND a > 1 AND e < -9223372036854775808;

-- Test 21: query (line 134)
SELECT * FROM abc JOIN def ON f = b AND a > 1 AND e > 9223372036854775807;

-- Test 22: query (line 139)
SELECT * FROM abc JOIN def_e_desc ON f = b AND a > 1 AND e < -9223372036854775808;

-- Test 23: query (line 144)
SELECT * FROM abc JOIN def_e_desc ON f = b AND a > 1 AND e > 9223372036854775807;

-- Test 24: query (line 149)
SELECT * FROM abc JOIN def ON f = a WHERE f > 1;

-- Test 25: query (line 156)
SELECT * FROM abc JOIN def ON f = b WHERE a >= e;

-- Test 26: query (line 163)
SELECT * FROM abc JOIN def_e_desc ON f = b WHERE a >= e;

-- Test 27: query (line 170)
SELECT * FROM abc JOIN def_e_decimal ON f = b WHERE a >= e;

-- Test 28: query (line 178)
SELECT * FROM abc JOIN def ON f = b AND a >= e;

-- Test 29: query (line 185)
SELECT * FROM abc JOIN def_e_desc ON f = b AND a >= e;

-- Test 30: query (line 192)
SELECT * FROM abc JOIN def_e_decimal ON f = b AND a >= e;

-- Test 31: query (line 200)
SELECT a, b, e FROM abc JOIN def ON f = b WHERE a >= e;

-- Test 32: query (line 208)
SELECT h FROM abc JOIN gh ON b = g;

-- Test 33: statement (line 212)
CREATE TABLE data (a INT, b INT, c INT, d INT, PRIMARY KEY (a, b, c, d));

-- Test 34: statement (line 216)
INSERT INTO data SELECT a, b, c, d FROM
   generate_series(1, 10) AS a(a),
   generate_series(1, 10) AS b(b),
   generate_series(1, 10) AS c(c),
   generate_series(1, 10) AS d(d);

-- Test 35: statement (line 223)
-- ALTER TABLE data INJECT STATISTICS '[
--   {
--     "columns": ["a"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 100000,
--     "distinct_count": 100000
--   }
-- ]'

-- Test 36: query (line 234)
SELECT count(*)
FROM (SELECT * FROM data WHERE c = 1) AS l
NATURAL JOIN (SELECT * FROM data WHERE c > 0) AS r;

-- Test 37: statement (line 241)
CREATE TABLE foo (a int, b int); INSERT INTO foo VALUES (0, 1), (0, 2), (1, 1);

-- Test 38: statement (line 244)
CREATE TABLE bar (a int PRIMARY KEY, c int); INSERT INTO bar VALUES (0, 1), (1, 2), (2, 1);

-- Test 39: query (line 247)
SELECT * FROM foo NATURAL JOIN bar;

-- Setup missing tables used by tests 40-45.
CREATE TABLE books (title TEXT, shelf INT);
CREATE TABLE books2 (title TEXT, shelf INT);
CREATE TABLE authors (name TEXT, book TEXT);
INSERT INTO books VALUES ('A', 1), ('B', 1);
INSERT INTO books2 VALUES ('A', 2), ('B', 1), ('C', 3);
INSERT INTO authors VALUES ('Alice', 'A'), ('Bob', 'B'), ('Cathy', 'C');

-- Test 40: statement (line 274)
-- ALTER TABLE books INJECT STATISTICS '[
--   {
--     "columns": ["title"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 100,
--     "distinct_count": 100
--   }
-- ]'

-- Test 41: statement (line 284)
-- ALTER TABLE books2 INJECT STATISTICS '[
--   {
--     "columns": ["title"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 10000,
--     "distinct_count": 1000
--   }
-- ]'

-- Test 42: statement (line 305)
-- ALTER TABLE authors INJECT STATISTICS '[
--   {
--     "columns": ["name"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 100,
--     "distinct_count": 100
--   }
-- ]'

-- Test 43: query (line 316)
SELECT DISTINCT b1.title FROM books as b1 JOIN books2 as b2 ON b1.title = b2.title WHERE b1.shelf <> b2.shelf;

-- Test 44: query (line 321)
SELECT DISTINCT authors.name FROM books AS b1, books2 as b2, authors WHERE b1.title = b2.title AND authors.book = b1.title AND b1.shelf <> b2.shelf;

-- Test 45: query (line 330)
SELECT a.name FROM authors AS a JOIN books2 AS b2 ON a.book = b2.title ORDER BY a.name;

-- Test 46: statement (line 354)
CREATE TABLE small (a INT PRIMARY KEY, b INT, c INT, d INT);

-- Test 47: statement (line 357)
CREATE TABLE large (a INT, b INT, c INT, d INT, PRIMARY KEY (a, b));

-- Test 48: statement (line 361)
INSERT INTO small SELECT x, 2*x, 3*x, 4*x FROM
  generate_series(1, 10) AS a(x);

-- Test 49: statement (line 365)
INSERT INTO large SELECT x, 2*x, 3*x, 4*x FROM
  generate_series(1, 10) AS a(x);

-- Test 50: statement (line 369)
-- ALTER TABLE small INJECT STATISTICS '[
--   {
--     "columns": ["a"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 100,
--     "distinct_count": 100
--   }
-- ]'

-- Test 51: statement (line 379)
-- ALTER TABLE large INJECT STATISTICS '[
--   {
--     "columns": ["a"],
--     "created_at": "2018-01-01 1:00:00.00000+00:00",
--     "row_count": 10000,
--     "distinct_count": 10000
--   }
-- ]'

-- Test 52: query (line 390)
SELECT small.a, large.c FROM small JOIN large ON small.a = large.b;

-- Test 53: query (line 400)
SELECT small.a, large.d FROM small JOIN large ON small.a = large.b;

-- Test 54: query (line 414)
SELECT small.b, large.a FROM small LEFT JOIN large ON small.b = large.a;

-- Test 55: query (line 429)
SELECT t1.a, t2.b FROM small t1 LEFT JOIN large t2 ON t1.a = t2.a AND t2.b % 6 = 0 ORDER BY t1.a;

-- Test 56: query (line 444)
SELECT small.c, large.c FROM small LEFT JOIN large ON small.c = large.b;

-- Test 57: query (line 459)
SELECT small.c, large.d FROM small LEFT JOIN large ON small.c = large.b;

-- Test 58: query (line 474)
SELECT small.c, large.c FROM small LEFT JOIN large ON small.c = large.b AND large.c < 20;

-- Test 59: query (line 489)
SELECT small.c, large.d FROM small LEFT JOIN large ON small.c = large.b AND large.d < 30;

-- Test 60: query (line 504)
SELECT small.c FROM small WHERE EXISTS(SELECT 1 FROM large WHERE small.c = large.b AND large.d < 30);

-- Test 61: query (line 511)
SELECT small.c FROM small WHERE NOT EXISTS(SELECT 1 FROM large WHERE small.c = large.b AND large.d < 30);

-- Test 62: statement (line 527)
CREATE TABLE t (a INT, b INT, c INT, d INT, e INT);

-- Test 63: statement (line 530)
CREATE TABLE u (a INT, b INT, c INT, d INT, e INT, PRIMARY KEY (a, b, c));

-- Test 64: statement (line 533)
INSERT INTO t VALUES
  (1, 2, 3, 4, 5);

-- Test 65: statement (line 537)
INSERT INTO u VALUES
  (1, 2, 3, 4, 5),
  (2, 3, 4, 5, 6),
  (3, 4, 5, 6, 7);

-- Test 66: statement (line 544)
CREATE INDEX idx ON u (d);

-- Test 67: query (line 547)
SELECT u.a FROM t JOIN u ON t.d = u.d AND t.a = u.a WHERE t.e = 5;

-- Test 68: statement (line 553)
DROP INDEX idx;

-- Test 69: statement (line 556)
CREATE UNIQUE INDEX idx ON u (d);

-- Test 70: query (line 559)
SELECT u.a FROM t JOIN u ON t.d = u.d AND t.a = u.a WHERE t.e = 5;

-- Test 71: statement (line 565)
DROP INDEX idx CASCADE;

-- Test 72: statement (line 568)
CREATE INDEX idx ON u (d, a);

-- Test 73: query (line 571)
SELECT u.a FROM t JOIN u ON t.d = u.d AND t.a = u.a AND t.b = u.b WHERE t.e = 5;

-- Test 74: statement (line 577)
DROP INDEX idx;

-- Test 75: statement (line 580)
CREATE INDEX idx ON u (d, b);

-- Test 76: query (line 583)
SELECT u.a FROM t JOIN u ON t.d = u.d AND t.a = u.a AND t.b = u.b WHERE t.e = 5;

-- Test 77: statement (line 589)
DROP INDEX idx;

-- Test 78: statement (line 592)
CREATE INDEX idx ON u (d, c);

-- Test 79: query (line 595)
SELECT u.a FROM t JOIN u ON t.d = u.d AND t.a = u.a AND t.d = u.d WHERE t.e = 5;

-- Test 80: query (line 600)
SELECT * FROM def JOIN abc ON a=f ORDER BY a;

-- Test 81: query (line 610)
SELECT * from abc WHERE EXISTS (SELECT * FROM def WHERE a=f);

-- Test 82: query (line 617)
SELECT * from abc WHERE NOT EXISTS (SELECT * FROM def WHERE a=f);

-- Test 83: query (line 621)
SELECT * from abc WHERE EXISTS (SELECT * FROM def WHERE a=f AND c=e);

-- Test 84: query (line 627)
SELECT * from abc WHERE NOT EXISTS (SELECT * FROM def WHERE a=f AND c=e);

-- Test 85: query (line 632)
SELECT * from abc WHERE EXISTS (SELECT * FROM def WHERE a=f AND d+b>1);

-- Test 86: query (line 638)
SELECT * from abc WHERE NOT EXISTS (SELECT * FROM def WHERE a=f AND d+b>1);

-- Test 87: query (line 643)
SELECT a,b from small WHERE EXISTS (SELECT a FROM data WHERE small.a=data.a) ORDER BY a;

-- Test 88: query (line 657)
SELECT a,b from small WHERE a+b<20 AND EXISTS (SELECT a FROM data WHERE small.a=data.a AND small.b+data.c>15) ORDER BY a;

-- Setup missing table for test 89.
CREATE TABLE tab4 (pk INT, col0 INT, col3 INT, col4 DECIMAL);
INSERT INTO tab4 VALUES (1, 10, NULL, 495.6), (2, 20, 10, 495.6);

-- Test 89: query (line 672)
SELECT pk FROM tab4 WHERE col0 IN (SELECT col3 FROM tab4 WHERE col4 = 495.6) AND (col3 IS NULL);

-- Test 90: statement (line 683)
CREATE TABLE t59615 (
  x INT NOT NULL CHECK (x in (1, 3)),
  y INT NOT NULL,
  z INT,
  PRIMARY KEY (x, y)
);

-- Test 91: query (line 691)
SELECT * FROM (VALUES (1), (2)) AS u(y) LEFT JOIN t59615 t ON u.y = t.y;

-- Test 92: query (line 697)
SELECT * FROM (VALUES (1), (2)) AS u(y) WHERE NOT EXISTS (
  SELECT * FROM t59615 t WHERE u.y = t.y
);

-- Test 93: statement (line 707)
CREATE TABLE t78681 (
  x INT NOT NULL CHECK (x in (1, 3)),
  y INT NOT NULL,
  PRIMARY KEY (x, y)
);

-- Test 94: statement (line 715)
-- ALTER TABLE t78681 INJECT STATISTICS '[
--   {
--     "columns": ["x"],
--     "created_at": "2018-05-01 1:00:00.00000+00:00",
--     "row_count": 10000000,
--     "distinct_count": 2
--   }
-- ]'

-- Test 95: statement (line 725)
INSERT INTO t78681 VALUES (1, 1), (3, 1);

-- Test 96: query (line 728)
SELECT * FROM (VALUES (1), (2)) AS u(y) WHERE EXISTS (
  SELECT * FROM t78681 t WHERE u.y = t.y
);

-- Setup missing table for tests 97-99.
CREATE TABLE lookup_expr (region TEXT, w INT, x INT, c INT, d INT, e INT);

-- Test 97: statement (line 747)
INSERT INTO lookup_expr VALUES
  ('east', 1, 1, 10, 10, 5),
  ('east', 2, NULL, 20, 10, 5),
  ('east', 3, 3, NULL, 10, 5),
  ('east', 4, 4, 40, 20, 5),
  ('east', 5, NULL, 50, 20, 5),
  ('west', 6, 1, 10, 20, 5),
  ('west', 7, NULL, NULL, 20, 5),
  ('west', 8, 2, 20, 20, 5),
  ('west', 9, 3, 30, 10, 5),
  ('west', 10, 4, 40, 10, 5);

-- Test 98: query (line 760)
SELECT * FROM (VALUES (1, 10), (2, 20), (3, NULL)) AS u(w, x) LEFT JOIN lookup_expr t
ON u.w = t.w AND u.x = t.x;

-- Test 99: query (line 769)
SELECT * FROM (VALUES (1, 10), (2, 20), (3, NULL)) AS u(w, x) WHERE NOT EXISTS (
  SELECT * FROM lookup_expr t WHERE u.w = t.w AND u.x = t.x
);

-- Test 100: statement (line 778)
CREATE TABLE t79384a (
  k INT NOT NULL
);

-- Test 101: statement (line 783)
CREATE TABLE t79384b (
  a INT,
  b INT,
  c INT
);

-- Test 102: statement (line 791)
INSERT INTO t79384a VALUES (1);

-- Test 103: statement (line 794)
INSERT INTO t79384b VALUES (1, 1, 1);

-- Test 104: query (line 799)
SELECT k FROM t79384a INNER JOIN t79384b ON k = a AND b IN (1, 2, 3) AND c > 0;

-- Test 105: statement (line 806)
CREATE TABLE items (
    id        INT NOT NULL PRIMARY KEY,
    chat_id   INT NOT NULL,
    author_id INT NOT NULL
);
CREATE TABLE views (
    chat_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (chat_id, user_id)
);
INSERT INTO views(chat_id, user_id) VALUES (1, 1);
INSERT INTO items(id, chat_id, author_id) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1);

-- Test 106: query (line 824)
SELECT (SELECT count(items.id)
        FROM items
        WHERE items.chat_id = views.chat_id
          AND items.author_id != views.user_id)
FROM views
WHERE chat_id = 1
  AND user_id = 1;

-- Test 107: query (line 835)
SELECT * FROM views LEFT JOIN items
ON items.chat_id = views.chat_id
AND items.author_id != views.user_id
WHERE views.chat_id = 1 and views.user_id = 1;

-- Test 108: statement (line 847)
CREATE TABLE xyz (x INT, y INT, z INT, PRIMARY KEY (x, y, z));

-- Test 109: statement (line 850)
CREATE TABLE uvw (u INT, v INT, w INT, PRIMARY KEY (u, v, w));

-- Test 110: statement (line 853)
INSERT INTO xyz VALUES (1, 1, 1), (1, 1, 2), (1, 2, 3), (2, 1, 4), (2, 1, 5), (2, 1, 6), (3, 1, 7);

-- Test 111: statement (line 856)
INSERT INTO uvw VALUES (1, 1, 1), (1, 2, 2), (1, 2, 3), (2, 1, 4), (2, 1, 5), (2, 2, 6), (2, 2, 7);

-- Test 112: query (line 859)
SELECT * FROM xyz INNER JOIN uvw ON x = u ORDER BY x, y DESC, z, u, v, w DESC;

-- Test 113: query (line 885)
SELECT * FROM xyz INNER JOIN uvw ON x = u ORDER BY x, y DESC, z, u, v, w DESC;

-- Test 114: query (line 911)
SELECT * FROM xyz INNER JOIN uvw ON x = u AND y = v ORDER BY u, x, v, y DESC, z, w DESC;

-- Test 115: query (line 926)
SELECT * FROM xyz INNER JOIN uvw ON x = u AND y = v ORDER BY u, x, v, y DESC, z, w DESC;

-- Test 116: query (line 943)
SELECT a, b, c, d, e, f FROM abc INNER JOIN def ON f <= a ORDER BY a, b, c, d, e, f;

-- Test 117: query (line 956)
SELECT a, b, c, d, e, f FROM def INNER JOIN abc ON a >= f ORDER BY a, b, c, d, e, f;

-- Test 118: query (line 969)
SELECT a, b, c, d, e, f FROM abc INNER JOIN def ON f < a ORDER BY a, b, c, d, e, f;

-- Test 119: query (line 978)
SELECT a, b, c, d, e, f FROM def INNER JOIN abc ON a > f ORDER BY a, b, c, d, e, f;

-- Test 120: query (line 987)
SELECT * FROM def INNER JOIN abc ON a >= d;

-- Test 121: query (line 997)
SELECT * FROM def INNER JOIN abc ON a > d;

-- Test 122: query (line 1004)
SELECT * FROM def INNER JOIN abc ON a >= d;

-- Test 123: query (line 1014)
SELECT * FROM def INNER JOIN abc ON a < d;

-- Test 124: query (line 1020)
SELECT * FROM def INNER JOIN abc ON a <= d;

-- Test 125: query (line 1029)
SELECT a, b, c, d, e, f FROM abc INNER JOIN def ON f < a AND f >= b ORDER BY a, b, c, d, e, f;

-- Test 126: query (line 1036)
SELECT a, b, c, d, e, f FROM def INNER JOIN abc ON f < a AND f >= b ORDER BY a, b, c, d, e, f;

-- Test 127: query (line 1043)
SELECT * FROM abc INNER JOIN def ON f < 2 AND f >= b;

-- Test 128: query (line 1052)
SELECT * FROM def INNER JOIN abc ON a < 2 AND a >= d;

-- Test 129: query (line 1058)
SELECT * FROM abc INNER JOIN def ON f = c AND e >= b;

-- Test 130: query (line 1066)
SELECT a, b, c, d, e, f FROM abc INNER JOIN def ON f = a AND e >= c ORDER BY a, b, c, d, e, f;

-- Test 131: query (line 1073)
SELECT a, b, c, d, e, f FROM def INNER JOIN abc ON f = a AND e >= c ORDER BY a, b, c, d, e, f;

-- Test 132: query (line 1080)
SELECT * FROM def INNER JOIN def_e_desc AS def2 ON def.f = def2.f AND def2.e < def.d;

-- Test 133: query (line 1086)
SELECT * FROM def INNER JOIN def_e_desc AS def2
ON def.f = def2.f AND def2.e <= def.d ORDER BY def.d, def.e, def.f, def2.d, def2.e, def2.f;

-- Test 134: query (line 1095)
SELECT * FROM def INNER JOIN def_e_desc AS def2 ON def.f = def2.f AND def2.e > def.d;

-- Test 135: query (line 1100)
SELECT * FROM def INNER JOIN def_e_desc AS def2 ON def.f = def2.f AND def2.e >= def.d;

-- Test 136: query (line 1107)
SELECT * FROM (SELECT * FROM (VALUES (-9223372036854775807::BIGINT), (9223372036854775807::BIGINT))) v(x)
LEFT JOIN abc ON a < x;

-- Test 137: query (line 1117)
SELECT * FROM (SELECT * FROM (VALUES (-9223372036854775807::BIGINT), (9223372036854775807::BIGINT))) v(x)
LEFT JOIN abc ON a > x;

-- Test 138: query (line 1127)
SELECT * FROM (SELECT * FROM (VALUES (-9223372036854775807::BIGINT), (9223372036854775807::BIGINT))) v(x)
LEFT JOIN def_e_desc ON f IN (1, 2) AND e < x;

-- Test 139: query (line 1137)
SELECT * FROM (SELECT * FROM (VALUES (-9223372036854775807::BIGINT), (9223372036854775807::BIGINT))) v(x)
LEFT JOIN def_e_desc ON f IN (1, 2) AND e > x;

-- Test 140: query (line 1147)
SELECT * FROM abc INNER JOIN def_e_decimal ON f = b AND e <= a::DECIMAL ORDER BY a, b, c, d, e, f;

-- Test 141: query (line 1155)
SELECT * FROM abc INNER JOIN def_e_decimal ON f = b AND e >= a::DECIMAL ORDER BY a, b, c, d, e, f;

-- Test 142: query (line 1163)
SELECT * FROM abc INNER JOIN def_e_decimal ON f = b AND e < a::DECIMAL ORDER BY a, b, c, d, e, f;

-- Test 143: query (line 1169)
SELECT * FROM abc INNER JOIN def_e_decimal ON f = b AND e > a::DECIMAL ORDER BY a, b, c, d, e, f;

-- Test 144: query (line 1175)
SELECT * FROM abc INNER JOIN float_xy ON x <= a::FLOAT ORDER BY a, b, c, x, y;

-- Test 145: query (line 1191)
SELECT * FROM abc INNER JOIN float_xy ON x >= a::FLOAT ORDER BY a, b, c, x, y;

-- Test 146: query (line 1203)
SELECT * FROM abc INNER JOIN float_xy ON x < a::FLOAT ORDER BY a, b, c, x, y;

-- Test 147: query (line 1216)
SELECT * FROM abc INNER JOIN float_xy ON x > a::FLOAT ORDER BY a, b, c, x, y;

-- Test 148: query (line 1225)
SELECT * FROM abc INNER JOIN float_xy ON x <= a::FLOAT ORDER BY a, b, c, x, y;

-- Test 149: query (line 1241)
SELECT * FROM abc INNER JOIN float_xy ON x >= a::FLOAT ORDER BY a, b, c, x, y;

-- Test 150: query (line 1253)
SELECT * FROM abc INNER JOIN float_xy ON x < a::FLOAT ORDER BY a, b, c, x, y;

-- Test 151: query (line 1266)
SELECT * FROM abc INNER JOIN float_xy ON x > a::FLOAT ORDER BY a, b, c, x, y;

-- Test 152: query (line 1274)
SELECT * FROM string_xy xy1 INNER JOIN string_xy xy2 ON xy2.x < xy1.x ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 153: query (line 1288)
SELECT * FROM string_xy xy1 INNER JOIN string_xy xy2 ON xy2.x > xy1.x ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 154: query (line 1302)
SELECT * FROM string_xy xy1 INNER JOIN string_xy xy2 ON xy2.x <= xy1.x ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 155: query (line 1321)
SELECT * FROM string_xy xy1 INNER JOIN string_xy xy2 ON xy2.x >= xy1.x ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 156: query (line 1340)
SELECT * FROM time_xy xy1 INNER JOIN time_xy xy2 ON xy2.x < xy1.x ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 157: query (line 1353)
SELECT * FROM time_xy xy1 INNER JOIN time_xy xy2 ON xy2.x > xy1.x ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 158: query (line 1366)
SELECT * FROM time_xy xy1 INNER JOIN time_xy xy2 ON xy2.x <= xy1.x ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 159: query (line 1386)
SELECT * FROM time_xy xy1 INNER JOIN time_xy xy2 ON xy2.x >= xy1.x ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 160: query (line 1406)
SELECT * FROM time_xy xy1 INNER JOIN time_xy xy2 ON xy2.y < xy1.y ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 161: query (line 1420)
SELECT * FROM time_xy xy1 INNER JOIN time_xy xy2 ON xy2.y > xy1.y ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 162: query (line 1434)
SELECT * FROM time_xy xy1 INNER JOIN time_xy xy2 ON xy2.y <= xy1.y ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 163: query (line 1453)
SELECT * FROM time_xy xy1 INNER JOIN time_xy xy2 ON xy2.y >= xy1.y ORDER BY xy1.x, xy1.y, xy2.x, xy2.y;

-- Test 164: statement (line 1472)
-- SET variable_inequality_lookup_join_enabled=false

-- Test 165: statement (line 1475)
SELECT a, b, c, d, e, f FROM abc INNER JOIN def ON f <= a ORDER BY a, b, c, d, e, f;

-- Test 166: statement (line 1478)
SELECT a, b, c, d, e, f FROM def INNER JOIN abc ON a >= f ORDER BY a, b, c, d, e, f;

-- Test 167: statement (line 1481)
SELECT a, b, c, d, e, f FROM abc INNER JOIN def ON f < a AND f >= b ORDER BY a, b, c, d, e, f;

-- Test 168: statement (line 1484)
-- RESET variable_inequality_lookup_join_enabled

-- Test 169: query (line 1487)
SELECT * FROM abc INNER JOIN def ON f = a ORDER BY a, c, e;

-- Test 170: query (line 1496)
SELECT * FROM abc INNER JOIN def ON f = a ORDER BY a, c, e DESC;

-- Test 171: query (line 1505)
SELECT * FROM abc INNER JOIN def_e_desc ON f = a ORDER BY a, c, e;

-- Test 172: query (line 1514)
SELECT * FROM abc INNER JOIN def_e_desc ON f = a ORDER BY a, c, e DESC;

-- Test 173: query (line 1523)
SELECT * FROM abc INNER JOIN def ON f = a AND e >= c-1 ORDER BY a, c, e;

-- Test 174: query (line 1532)
SELECT * FROM abc INNER JOIN def ON f = a AND e >= c-1 ORDER BY a, c, e DESC;

-- Test 175: query (line 1541)
SELECT * FROM abc INNER JOIN def ON f = a AND e <= c ORDER BY a, c, e;

-- Test 176: query (line 1550)
SELECT * FROM abc INNER JOIN def ON f = a AND e <= c ORDER BY a, c, e DESC;

-- Test 177: query (line 1559)
SELECT * FROM abc INNER JOIN def_e_desc ON f = a AND e >= c-1 ORDER BY a, c, e;

-- Test 178: query (line 1568)
SELECT * FROM abc INNER JOIN def_e_desc ON f = a AND e >= c-1 ORDER BY a, c, e DESC;

-- Test 179: query (line 1577)
SELECT * FROM abc INNER JOIN def_e_desc ON f = a AND e <= c ORDER BY a, c, e;

-- Test 180: query (line 1586)
SELECT * FROM abc INNER JOIN def_e_desc ON f = a AND e <= c ORDER BY a, c, e DESC;

-- Setup missing table used by tests 181-182.
CREATE TABLE t89576 (v INT, s INT);
INSERT INTO t89576 VALUES (1, 1), (2, 2);

-- Test 181: query (line 1608)
SELECT t2.v
FROM t89576 AS t1
LEFT JOIN t89576 AS t2
ON (t2.v) = (t1.v)
AND (t2.s) = (t1.s);

-- Test 182: statement (line 1622)
SELECT t2.v
FROM t89576 AS t1
LEFT JOIN t89576 AS t2
ON (t2.v) = (t1.v)
AND (t2.s) = (t1.s);

-- Test 183: statement (line 1631)
CREATE TABLE t108489_1 (k1 INT PRIMARY KEY);
CREATE TABLE t108489_2 (k2 INT PRIMARY KEY, i2 INT, u2 INT);
CREATE TABLE t108489_3 (k3 INT PRIMARY KEY, i3 INT, u3 INT, v3 INT, w3 INT);
INSERT INTO t108489_1 VALUES (1);
INSERT INTO t108489_2 VALUES (1, 1, 1);
INSERT INTO t108489_3 VALUES (1, 1, 1, 1, 1);

-- Test 184: query (line 1639)
SELECT k2 FROM t108489_1 INNER JOIN t108489_2 ON i2 = k1 AND u2 = 1 WHERE k1 = 1;

-- Test 185: query (line 1644)
SELECT k3 FROM t108489_1 INNER JOIN t108489_3 ON i3 = k1 AND u3 = 1 WHERE k1 = 1;

-- Test 186: query (line 1649)
SELECT k3, w3 FROM t108489_1 INNER JOIN t108489_3 ON i3 = k1 AND u3 = 1 WHERE k1 = 1;

-- Test 187: query (line 1654)
SELECT k3, v3, w3 FROM t108489_1 INNER JOIN t108489_3 ON i3 = k1 AND u3 = 1 WHERE k1 = 1;

-- Setup missing tables used by tests 188-189.
CREATE TABLE r_113013 (id INT PRIMARY KEY, c3 TEXT);
CREATE TABLE l_113013 (l_id INT, r_id INT, c1 TEXT);
INSERT INTO r_113013 VALUES (1, 'abc');
INSERT INTO l_113013 VALUES (1, 1, 'hello');

CREATE TABLE r_101823 (u INT, v INT);
CREATE TABLE l_101823 (a INT, b INT);
INSERT INTO l_101823 VALUES (1, 1), (2, 2);
INSERT INTO r_101823 VALUES (1, 1), (1, 2), (2, 2);

-- Test 188: query (line 1669)
SELECT length(c1), length(c3) FROM l_113013 l INNER JOIN r_113013 r ON l.r_id = r.id WHERE l.l_id = 1;

-- Test 189: query (line 1684)
SELECT count(v) FROM l_101823 LEFT JOIN r_101823 ON a = u AND b = v;

-- Test 190: statement (line 1693)
CREATE TABLE table_1_124732 (col1_6 REGCLASS);
CREATE TABLE table_3_124732 (col3_0 REGCLASS);
CREATE TABLE t_124732 (i DECIMAL);

-- Test 191: statement (line 1702)
INSERT INTO table_1_124732 (col1_6) VALUES (0);
INSERT INTO table_3_124732 (col3_0) VALUES (0);

-- Test 192: query (line 1706)
SELECT col1_6 FROM table_1_124732 INNER JOIN table_3_124732 ON col3_0 = col1_6;

-- Test 193: query (line 1711)
SELECT col1_6 FROM table_1_124732 INNER JOIN table_3_124732 ON col3_0 = col1_6;

-- Test 194: statement (line 1725)
INSERT INTO t_124732 VALUES (1.000);

-- Test 195: statement (line 1728)
SELECT * FROM (VALUES (1::DECIMAL)) AS v(i)
INNER JOIN t_124732 ON v.i = t_124732.i;

-- Test 196: query (line 1732)
SELECT * FROM (VALUES (1::DECIMAL)) AS v(i)
INNER JOIN t_124732 ON v.i = t_124732.i;

-- Test 197: statement (line 1742)
CREATE TABLE t134697 (
  a INT,
  b BIT(2),
  vb VARBIT(2),
  c CHAR(2),
  vc VARCHAR(2),
  d DECIMAL(6, 2)
);

-- Test 198: statement (line 1757)
CREATE TABLE t134697_x (
  x INT PRIMARY KEY
);

-- Test 199: statement (line 1762)
INSERT INTO t134697 VALUES (1, '11', '11', 'ab', 'ab', 1234.12);

-- Test 200: statement (line 1765)
INSERT INTO t134697_x VALUES (1);

-- Test 201: query (line 1768)
SELECT a, b FROM t134697_x
JOIN t134697 ON a = x AND b = '111';

-- Test 202: query (line 1774)
SELECT a, b FROM t134697_x
INNER JOIN t134697 ON a = x AND b = '111';

-- Test 203: query (line 1779)
SELECT a, vb FROM t134697_x
JOIN t134697 ON a = x AND vb = '111';

-- Test 204: query (line 1785)
SELECT a, vb FROM t134697_x
INNER JOIN t134697 ON a = x AND vb = '111';

-- Test 205: query (line 1790)
SELECT a, c FROM t134697_x
JOIN t134697 ON a = x AND c = 'abc';

-- Test 206: query (line 1796)
SELECT a, c FROM t134697_x
INNER JOIN t134697 ON a = x AND c = 'abc';

-- Test 207: query (line 1801)
SELECT a, vc FROM t134697_x
JOIN t134697 ON a = x AND vc = 'abc';

-- Test 208: query (line 1807)
SELECT a, vc FROM t134697_x
INNER JOIN t134697 ON a = x AND vc = 'abc';

-- Test 209: query (line 1812)
SELECT a, d FROM t134697_x
JOIN t134697 ON a = x AND d = 1234.123412::DECIMAL(8, 4);

-- Test 210: query (line 1818)
SELECT a, d FROM t134697_x
INNER JOIN t134697 ON a = x AND d = 1234.1234::DECIMAL(8, 4);
