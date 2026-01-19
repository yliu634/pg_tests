-- PostgreSQL compatible tests from expression_index
-- 239 tests

-- Test 1: query (line 20)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 2: query (line 40)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 3: query (line 60)
SELECT create_statement FROM [SHOW CREATE TABLE t WITH REDACT]

-- Test 4: query (line 80)
SELECT create_statement FROM [SHOW CREATE TABLE t WITH REDACT]

-- Test 5: query (line 99)
SELECT * FROM [SHOW COLUMNS FROM t] ORDER BY column_name

-- Test 6: statement (line 112)
CREATE TABLE err (a INT, INDEX ((a + 10)), CHECK (crdb_internal_idx_expr > 0))

-- Test 7: statement (line 116)
CREATE TABLE err (a INT, INDEX ((a + 10)), UNIQUE (crdb_internal_idx_expr))

-- Test 8: statement (line 121)
CREATE TABLE err (a INT, INDEX ((a + 10)), comp INT AS (crdb_internal_idx_expr + 10) STORED)

-- Test 9: statement (line 125)
CREATE TABLE err (a INT, INDEX ((a + 10)), INDEX (crdb_internal_idx_expr))

-- Test 10: statement (line 130)
CREATE TABLE err (a INT, INDEX ((a + 10)), INDEX (a) WHERE crdb_internal_idx_expr > 0)

-- Test 11: statement (line 134)
CREATE TABLE err (a INT, INDEX ((a + 10)), FOREIGN KEY (crdb_internal_idx_expr) REFERENCES t(a))

-- Test 12: statement (line 138)
CREATE TABLE name_collision (a INT, INDEX ((a + 10)), crdb_internal_idx_expr INT)

-- Test 13: query (line 141)
SELECT * FROM (
  SELECT json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 'name_collision'::REGCLASS
) AS cols WHERE cols.desc->'name' = '"crdb_internal_idx_expr_1"'

-- Test 14: statement (line 150)
CREATE TABLE err (a INT, INDEX ((a + random()::INT)))

-- Test 15: statement (line 153)
CREATE TABLE err (a INT, INDEX ((a + z)))

-- Test 16: statement (line 156)
CREATE TABLE err (a INT, comp INT AS (a + 10) STORED, INDEX ((comp + 100)))

-- Test 17: statement (line 159)
CREATE TABLE err (a INT, INDEX (a, (NULL)))

-- Test 18: statement (line 162)
CREATE TABLE t_null_cast (a INT, INDEX (a, (NULL::TEXT)))

-- Test 19: statement (line 165)
CREATE TABLE err (a INT, b INT, INDEX (a, (row(a, b))))

-- Test 20: statement (line 168)
CREATE TABLE err (a INT, b INT, INVERTED INDEX (a, (a + b)))

-- Test 21: statement (line 171)
CREATE TABLE err (a INT, b INT, INVERTED INDEX (a, (row(a, b))))

-- Test 22: statement (line 174)
CREATE TABLE err (a INT, j JSON, INVERTED INDEX (a, (j->'a') DESC))

-- Test 23: statement (line 177)
CREATE TABLE err (a INT, b INT, VECTOR INDEX (a, (a + b)))

-- Test 24: statement (line 180)
CREATE TABLE err (a INT, vec1 VECTOR, VECTOR INDEX ((vec1::VECTOR(3)), a))

-- Test 25: statement (line 183)
CREATE TABLE err (a INT, vec1 VECTOR, VECTOR INDEX (a, (vec1::VECTOR(3)) DESC))

-- Test 26: statement (line 186)
CREATE TABLE err (a INT, vec1 VECTOR(3), VECTOR INDEX (a, (vec1::VECTOR)))

-- Test 27: statement (line 189)
CREATE TABLE err (a INT, vec1 VECTOR, INDEX (a, (vec1::VECTOR(3))))

-- Test 28: statement (line 192)
CREATE TABLE err (a INT, INDEX ((a + random()::INT)))

-- Test 29: statement (line 195)
CREATE TABLE err (a INT, INDEX ((a + z)))

-- Test 30: statement (line 198)
CREATE TABLE err (a INT, comp INT AS (a + 10) STORED, INDEX ((comp + 10)))

-- Test 31: statement (line 204)
CREATE TABLE err (a INT, UNIQUE ((a + 10)))

-- Test 32: statement (line 210)
ALTER TABLE t ADD CONSTRAINT err UNIQUE ((a + 10))

-- Test 33: statement (line 213)
DROP TABLE t

-- Test 34: statement (line 228)
CREATE INDEX t_a_plus_b_idx ON t ((a + b))

-- Test 35: statement (line 231)
CREATE INDEX t_lower_c_idx ON t (lower(c))

-- Test 36: statement (line 234)
CREATE INDEX t_lower_c_a_plus_b_idx ON t (lower(c), (a + b))

-- Test 37: statement (line 237)
CREATE INDEX t_a_plus_ten_idx ON t ((a + 10))

-- Test 38: statement (line 240)
CREATE INDEX err ON t ((a + 10), (a + 10))

onlyif config schema-locked-disabled

-- Test 39: query (line 244)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 40: query (line 264)
SELECT create_statement FROM [SHOW CREATE TABLE t]

-- Test 41: statement (line 284)
ALTER TABLE t SET (schema_locked=false);

-- Test 42: statement (line 288)
ALTER TABLE t ADD CONSTRAINT err CHECK (crdb_internal_idx_expr_2 > 0)

-- Test 43: statement (line 292)
ALTER TABLE t ALTER COLUMN crdb_internal_idx_expr_2 SET NOT NULL

-- Test 44: statement (line 296)
ALTER TABLE t ADD CONSTRAINT err UNIQUE (crdb_internal_idx_expr_2)

-- Test 45: statement (line 301)
ALTER TABLE t ADD COLUMN err INT AS (crdb_internal_idx_expr_2 + 10) STORED

-- Test 46: statement (line 305)
CREATE INDEX err ON t (crdb_internal_idx_expr_2)

-- Test 47: statement (line 310)
CREATE INDEX err ON t (a) WHERE crdb_internal_idx_expr_2 > 0

skipif config schema-locked-disabled

-- Test 48: statement (line 314)
ALTER TABLE t RESET (schema_locked);

-- Test 49: statement (line 318)
CREATE TABLE child (a INT REFERENCES t(crdb_internal_idx_expr_2))

-- Test 50: statement (line 321)
CREATE TABLE child (a INT)

-- Test 51: statement (line 324)
ALTER TABLE child ADD CONSTRAINT err FOREIGN KEY (a) REFERENCES t(crdb_internal_idx_expr_2)

-- Test 52: statement (line 327)
ALTER TABLE t ADD CONSTRAINT err FOREIGN KEY (crdb_internal_idx_expr_2) REFERENCES child(a)

-- Test 53: statement (line 331)
ALTER TABLE t DROP COLUMN crdb_internal_idx_expr_2

-- Test 54: statement (line 336)
ALTER TABLE t RENAME COLUMN a TO crdb_internal_idx_expr_2

-- Test 55: statement (line 340)
ALTER TABLE t RENAME COLUMN crdb_internal_idx_expr_2 TO err

-- Test 56: statement (line 345)
ALTER TABLE t ADD COLUMN crdb_internal_idx_expr_2 INT

onlyif config local-legacy-schema-changer

-- Test 57: query (line 349)
SELECT * FROM (
  SELECT json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 't'::REGCLASS
) AS cols WHERE cols.desc->'name' = '"crdb_internal_idx_expr_2"'

-- Test 58: query (line 359)
SELECT * FROM (
  SELECT json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 't'::REGCLASS
) AS cols WHERE cols.desc->'name' = '"crdb_internal_idx_expr_2"'

-- Test 59: statement (line 368)
DROP INDEX t_lower_c_a_plus_b_idx

-- Test 60: query (line 375)
SELECT cols.desc FROM (
  SELECT id, json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 't'::REGCLASS
) AS cols WHERE cols.desc->>'name' IN ('crdb_internal_idx_expr', 'crdb_internal_idx_expr_1')
ORDER BY id

-- Test 61: query (line 387)
SELECT cols.desc FROM (
  SELECT id, json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 't'::REGCLASS
) AS cols WHERE cols.desc->>'name' IN ('crdb_internal_idx_expr', 'crdb_internal_idx_expr_1')
ORDER BY id

-- Test 62: statement (line 398)
DROP INDEX t_a_plus_b_idx

-- Test 63: query (line 403)
SELECT * FROM (
  SELECT json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 't'::REGCLASS
) AS cols WHERE cols.desc->>'name' = 'crdb_internal_idx_expr'

-- Test 64: statement (line 413)
ALTER TABLE t ADD COLUMN crdb_internal_idx_expr INT

-- Test 65: statement (line 416)
ALTER TABLE t DROP COLUMN crdb_internal_idx_expr

skipif config schema-locked-disabled

-- Test 66: statement (line 420)
ALTER TABLE t SET (schema_locked=false);

-- Test 67: statement (line 423)
CREATE INDEX err ON t ((a + random()::INT))

-- Test 68: statement (line 426)
CREATE INDEX err ON t ((a + z))

-- Test 69: statement (line 429)
CREATE INDEX err ON t ((comp + 10))

-- Test 70: statement (line 432)
CREATE INDEX err ON t (a, (NULL), b)

-- Test 71: statement (line 435)
CREATE INDEX t_cast_idx ON t (a, (NULL::TEXT), b)

skipif config schema-locked-disabled

-- Test 72: statement (line 439)
ALTER TABLE t RESET (schema_locked);

-- Test 73: statement (line 442)
CREATE INDEX err ON t (a, (j->'a'));

-- Test 74: statement (line 445)
DROP INDEX err

-- Test 75: statement (line 448)
CREATE INDEX err ON t (a, (row(a, b)));

-- Test 76: statement (line 451)
CREATE INVERTED INDEX err ON t ((j->'a'), j);

-- Test 77: statement (line 454)
DROP INDEX err

-- Test 78: statement (line 457)
CREATE INVERTED INDEX err ON t (a, (a + b));

-- Test 79: statement (line 460)
CREATE INVERTED INDEX err ON t (a, (row(a, b)));

-- Test 80: statement (line 463)
CREATE INVERTED INDEX err ON t (a, (j->'a') DESC);

-- Test 81: statement (line 466)
CREATE INVERTED INDEX ON t (a, (j->'a') ASC);

-- Test 82: statement (line 469)
CREATE VECTOR INDEX err ON t (b, (v::VECTOR(3)));

-- Test 83: statement (line 472)
DROP INDEX err

-- Test 84: statement (line 475)
CREATE VECTOR INDEX err ON t (a, (a + b))

-- Test 85: statement (line 478)
CREATE VECTOR INDEX err ON t ((v::VECTOR(3)), a)

-- Test 86: statement (line 481)
CREATE VECTOR INDEX err ON t (a, (v::VECTOR(3)) DESC)

-- Test 87: statement (line 484)
CREATE VECTOR INDEX err ON t (a, (v::VECTOR))

-- Test 88: statement (line 487)
CREATE INDEX err ON t (a, (v::VECTOR(3)))

-- Test 89: statement (line 490)
CREATE TABLE other (
  a INT
)

-- Test 90: statement (line 496)
CREATE INDEX err ON other ((t.a + 10))

-- Test 91: statement (line 501)
SELECT crdb_internal_idx_expr FROM t

-- Test 92: statement (line 504)
SELECT * FROM t WHERE crdb_internal_idx_expr > 0

-- Test 93: statement (line 507)
SELECT t.crdb_internal_idx_expr FROM t

-- Test 94: statement (line 510)
SELECT * FROM t WHERE t.crdb_internal_idx_expr > 0

-- Test 95: statement (line 514)
CREATE VIEW v(a) AS SELECT crdb_internal_idx_expr FROM t

-- Test 96: statement (line 517)
CREATE TABLE pk (
  k INT PRIMARY KEY,
  UNIQUE INDEX ((k + 10))
)

-- Test 97: statement (line 523)
ALTER TABLE pk ALTER PRIMARY KEY USING COLUMNS (crdb_internal_idx_expr)

-- Test 98: statement (line 528)
CREATE TABLE src (
  k INT PRIMARY KEY,
  a INT,
  b INT,
  j JSON,
  v VECTOR,
  comp INT8 AS (1 + 10) VIRTUAL,
  INDEX ((a + b)),
  INDEX named_idx ((a + 1)),
  UNIQUE INDEX ((a + 10)),
  INVERTED INDEX ((a + b), (j->'a')),
  VECTOR INDEX (b, (v::VECTOR(3)))
);
CREATE TABLE copy (LIKE src);
CREATE TABLE copy_generated (LIKE src INCLUDING GENERATED);
CREATE TABLE copy_indexes (LIKE src INCLUDING INDEXES);
CREATE TABLE copy_all (LIKE src INCLUDING ALL)

onlyif config schema-locked-disabled

-- Test 99: query (line 548)
SELECT create_statement FROM [SHOW CREATE TABLE copy]

-- Test 100: query (line 563)
SELECT create_statement FROM [SHOW CREATE TABLE copy]

-- Test 101: query (line 579)
SELECT count(*) FROM (
  SELECT json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 'copy'::REGCLASS
) AS cols WHERE cols.desc->>'name' LIKE 'crdb_internal_idx_expr%'

-- Test 102: query (line 589)
SELECT create_statement FROM [SHOW CREATE TABLE copy_generated]

-- Test 103: query (line 604)
SELECT create_statement FROM [SHOW CREATE TABLE copy_generated]

-- Test 104: query (line 620)
SELECT count(*) FROM (
  SELECT json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 'copy_generated'::REGCLASS
) AS cols WHERE cols.desc->>'name' LIKE 'crdb_internal_idx_expr%'

-- Test 105: query (line 630)
SELECT create_statement FROM [SHOW CREATE TABLE copy_indexes]

-- Test 106: query (line 649)
SELECT create_statement FROM [SHOW CREATE TABLE copy_indexes]

-- Test 107: query (line 669)
SELECT count(*) FROM (
  SELECT json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 'copy_indexes'::REGCLASS
) AS cols WHERE cols.desc->>'name' LIKE 'crdb_internal_idx_expr%'

-- Test 108: query (line 679)
SELECT create_statement FROM [SHOW CREATE TABLE copy_all]

-- Test 109: query (line 698)
SELECT create_statement FROM [SHOW CREATE TABLE copy_all]

-- Test 110: query (line 718)
SELECT count(*) FROM (
  SELECT json_array_elements(
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'table'->'columns'
  ) AS desc FROM system.descriptor WHERE id = 'copy_all'::REGCLASS
) AS cols WHERE cols.desc->>'name' LIKE 'crdb_internal_idx_expr%'

-- Test 111: query (line 744)
SELECT create_statement FROM [SHOW CREATE TABLE anon]

-- Test 112: query (line 762)
SELECT create_statement FROM [SHOW CREATE TABLE anon]

-- Test 113: statement (line 779)
DROP TABLE anon;

-- Test 114: query (line 797)
SELECT create_statement FROM [SHOW CREATE TABLE anon]

-- Test 115: query (line 816)
SELECT create_statement FROM [SHOW CREATE TABLE anon]

-- Test 116: statement (line 835)
CREATE INDEX t_a_plus_b_idx ON t ((a + b));

-- Test 117: statement (line 838)
CREATE INDEX t_lower_c_a_plus_b_idx ON t (lower(c), (a + b))

-- Test 118: statement (line 841)
INSERT INTO t VALUES
  (1, 10, 100, 'Foo'),
  (2, 20, 200, 'FOO'),
  (3, 10, 100, 'foo'),
  (4, 40, 400, 'BAR'),
  (5, 100, 10, 'Food')

-- Test 119: query (line 849)
SELECT k, a, b, c, comp FROM t@t_a_plus_b_idx WHERE a + b = 110

-- Test 120: query (line 857)
SELECT k, a, b, c, comp FROM t@t_a_plus_b_idx WHERE a + b > 110

-- Test 121: query (line 864)
SELECT k, a, b, c, comp FROM t@t_lower_c_idx WHERE lower(c) = 'foo'

-- Test 122: query (line 872)
SELECT k, a, b, c, comp FROM t@t_lower_c_idx WHERE lower(c) LIKE 'foo%'

-- Test 123: query (line 881)
SELECT k, a, b, c, comp FROM t@t_lower_c_a_plus_b_idx WHERE lower(c) = 'foo' AND a + b > 110

-- Test 124: statement (line 887)
CREATE TABLE d (a INT, j JSON);
CREATE INDEX json_expr_index on d ((j->'a'))

-- Test 125: statement (line 891)
INSERT INTO d VALUES
        (1, '{"a": "hello"}'),
        (2, '{"a": "b"}'),
        (3, '{"a": "bye"}'),
        (4, '{"a": "json"}')

-- Test 126: query (line 898)
SELECT a, j from d@json_expr_index where j->'a' = '"b"' ORDER BY a

-- Test 127: query (line 903)
SELECT a, j from d@json_expr_index where j->'a' = '"b"' OR j->'a' = '"bye"' ORDER BY a

-- Test 128: query (line 909)
SELECT a, j from d@json_expr_index where j->'a' > '"a"' ORDER BY a

-- Test 129: query (line 917)
SELECT a, j from d@json_expr_index where j->'a' <= '"hello"' ORDER BY a

-- Test 130: statement (line 925)
INSERT INTO d VALUES
        (5, '{"a": "forward", "json": "inverted"}'),
        (6, '{"a": "c", "b": "d"}')

-- Test 131: statement (line 931)
CREATE INVERTED INDEX json_inv on d ((j->'a'), j)

-- Test 132: query (line 934)
SELECT a, j from d@json_inv where j->'a' = '"forward"' AND j->'json' = '"inverted"' ORDER BY a

-- Test 133: query (line 939)
SELECT a, j from d@json_inv where j->'a' = '"c"' AND j->'json' = '"inverted"' ORDER BY a

-- Test 134: query (line 943)
SELECT a, j from d@json_inv where j->'a' = '"c"' AND j->'b' = '"d"' ORDER BY a

-- Test 135: statement (line 951)
CREATE INDEX t_a_times_two_idx ON t ((a * 2))

-- Test 136: query (line 954)
SELECT k, a, b, c, comp FROM t@t_a_times_two_idx WHERE a * 2 = 20

-- Test 137: query (line 961)
SELECT k, a, b, c, comp FROM t@t_a_times_two_idx WHERE a * 2 < 100

-- Test 138: statement (line 973)
BEGIN

-- Test 139: statement (line 976)
CREATE TABLE bf (a INT, b INT)

-- Test 140: statement (line 979)
INSERT INTO bf VALUES (1, 10), (6, 60)

-- Test 141: statement (line 982)
CREATE INDEX a_plus_b ON bf ((a + b))

-- Test 142: statement (line 985)
COMMIT

-- Test 143: query (line 988)
SELECT * FROM bf@a_plus_b WHERE a + b = 66

-- Test 144: statement (line 994)
DROP TABLE bf

-- Test 145: statement (line 1000)
CREATE TABLE bf (a INT) WITH (schema_locked = false)

-- Test 146: statement (line 1003)
SET autocommit_before_ddl = false

-- Test 147: statement (line 1006)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 148: statement (line 1009)
SET LOCAL autocommit_before_ddl=off;

-- Test 149: statement (line 1012)
ALTER TABLE bf ADD COLUMN b INT DEFAULT 10

-- Test 150: statement (line 1015)
CREATE INDEX a_plus_b ON bf ((a + b))

-- Test 151: statement (line 1018)
ABORT

-- Test 152: statement (line 1021)
RESET autocommit_before_ddl

-- Test 153: statement (line 1024)
DROP TABLE bf

-- Test 154: statement (line 1029)
CREATE TYPE enum AS ENUM ('Foo', 'BAR', 'baz')

-- Test 155: statement (line 1032)
CREATE TABLE bf (a enum)

-- Test 156: statement (line 1035)
INSERT INTO bf VALUES ('Foo'), ('BAR'), ('baz')

-- Test 157: statement (line 1048)
DROP TABLE bf

-- Test 158: statement (line 1054)
BEGIN

-- Test 159: statement (line 1057)
CREATE TABLE bf (a enum)

-- Test 160: statement (line 1060)
INSERT INTO bf VALUES ('Foo'), ('BAR'), ('baz')

-- Test 161: statement (line 1066)
COMMIT

-- Test 162: statement (line 1076)
DROP TABLE bf

-- Test 163: statement (line 1081)
CREATE TABLE bf (k INT NOT NULL, a INT, INDEX a_plus_10 ((a + 10)))

-- Test 164: statement (line 1084)
INSERT INTO bf VALUES (1, 1), (6, 6)

-- Test 165: statement (line 1087)
ALTER TABLE bf ADD PRIMARY KEY (k)

-- Test 166: query (line 1090)
SELECT * FROM bf@a_plus_10 WHERE a + 10 IN (11, 16)

-- Test 167: statement (line 1096)
DROP TABLE bf

-- Test 168: statement (line 1103)
CREATE TABLE l (
    a INT PRIMARY KEY,
    b INT,
    INDEX a_plus_b ((a + b))
)

-- Test 169: statement (line 1110)
INSERT INTO l VALUES (1, 1), (6, 6)

-- Test 170: statement (line 1113)
ALTER TABLE l SET (schema_locked=false);

-- Test 171: statement (line 1116)
TRUNCATE l

-- Test 172: statement (line 1119)
ALTER TABLE l RESET (schema_locked);

-- Test 173: query (line 1122)
SELECT * FROM l@a_plus_b

-- Test 174: statement (line 1126)
INSERT INTO l VALUES (1, 1), (7, 7)

-- Test 175: query (line 1129)
SELECT * FROM l@a_plus_b

-- Test 176: statement (line 1137)
CREATE TABLE inv (
  k INT PRIMARY KEY,
  i INT,
  j JSON,
  INVERTED INDEX j_a ((j->'a')),
  INVERTED INDEX j_a_b ((j->'a'->'b')),
  INVERTED INDEX i_j_a (i, (j->'a')),
  INVERTED INDEX i_plus_100_j_a ((i+100), (j->'a'))
);

-- Test 177: statement (line 1148)
INSERT INTO inv VALUES
  (1, 1, 'null'),
  (2, 1, 'true'),
  (3, 1, '1'),
  (4, 1, '""'),
  (5, 1, '"x"'),
  (6, 1, '{}'),
  (7, 1, '[]'),
  (8, 1, '{"a": null}'),
  (9, 1, '{"a": true}'),
  (10, 1, '{"a": 1}'),
  (11, 1, '{"a": ""}'),
  (12, 1, '{"a": "x"}'),
  (13, 1, '{"a": []}'),
  (14, 1, '{"a": [null, 1, true, ""]}'),
  (15, 1, '{"a": ["x", "y", "z"]}'),
  (16, 2, '{"a": ["x", "y", "z"]}'),
  (17, 1, '{"a": ["p", "q"]}'),
  (18, 1, '{"a": [1, "x"]}'),
  (19, 2, '{"a": [1, "x"]}'),
  (20, 1, '{"a": {}}'),
  (21, 1, '{"a": {"b": null}}'),
  (22, 1, '{"a": {"b": true}}'),
  (23, 1, '{"a": {"b": 1}}'),
  (24, 1, '{"a": {"b": ""}}'),
  (25, 1, '{"a": {"b": "x"}}'),
  (26, 1, '{"a": {"b": []}}'),
  (27, 1, '{"a": {"b": [null, 1, true, ""]}}'),
  (28, 1, '{"a": {"b": ["x", "y", "z"]}}'),
  (29, 1, '{"a": {"b": ["p", "q"]}}'),
  (30, 1, '{"a": {"b": [1, "x"]}}'),
  (31, 1, '{"a": {"b": {}}}'),
  (32, 1, '{"a": {"b": {"x": "y"}}}'),
  (33, 1, '{"a": {"b": {"p": "q"}}}')

-- Test 178: query (line 1184)
SELECT j FROM inv@j_a WHERE j->'a' @> '"x"' ORDER BY k

-- Test 179: query (line 1193)
SELECT j FROM inv@j_a_b WHERE j->'a'->'b' @> '"x"' ORDER BY k

-- Test 180: query (line 1200)
SELECT i, j FROM inv@i_j_a WHERE i = 1 AND j->'a' @> '"x"' ORDER BY k

-- Test 181: query (line 1207)
SELECT i, j FROM inv@i_plus_100_j_a WHERE i+100 = 101 AND j->'a' @> '"x"' ORDER BY k

-- Test 182: statement (line 1216)
DROP INDEX j_a;
DROP INDEX j_a_b;
DROP INDEX i_j_a

-- Test 183: statement (line 1221)
CREATE INVERTED INDEX j_a ON inv ((j->'a'));
CREATE INVERTED INDEX j_a_b ON inv ((j->'a'->'b'));
CREATE INVERTED INDEX i_j_a ON inv (i, (j->'a'))

-- Test 184: query (line 1226)
SELECT j FROM inv@j_a WHERE j->'a' @> '"x"' ORDER BY k

-- Test 185: query (line 1235)
SELECT j FROM inv@j_a_b WHERE j->'a'->'b' @> '"x"' ORDER BY k

-- Test 186: query (line 1242)
SELECT i, j FROM inv@i_j_a WHERE i = 1 AND j->'a' @> '"x"' ORDER BY k

-- Test 187: query (line 1249)
SELECT i, j FROM inv@i_plus_100_j_a WHERE i+100 = 101 AND j->'a' @> '"x"' ORDER BY k

-- Test 188: statement (line 1258)
CREATE TABLE json_backfill (
  k INT PRIMARY KEY,
  j JSON,
  INDEX forward_expr ((j->'a')),
  INDEX forward (j)
)

-- Test 189: statement (line 1266)
INSERT INTO json_backfill VALUES
  (1, '[1, 2, 3]'),
  (2, '{"a": [1, 2, 3], "b": [4, 5, 6]}'),
  (3, '{"a": {"a": "b"}, "d": {"e": [1, 2, 3]}}'),
  (4, '{"a": [4, 5]}')

-- Test 190: query (line 1273)
SELECT j from json_backfill@forward_expr where j->'a' IN ('[1, 2, 3]', '[4,5]') ORDER BY k

-- Test 191: query (line 1279)
SELECT j from json_backfill@forward_expr where j->'a' = '{"a": "b"}' ORDER BY k

-- Test 192: query (line 1284)
SELECT j from json_backfill@forward_expr where j->'a' > '{"a": "b"}' ORDER BY k

-- Test 193: query (line 1288)
SELECT j from json_backfill@forward_expr where j->'a' < '{"a": "b"}' ORDER BY k

-- Test 194: query (line 1294)
SELECT j from json_backfill@forward where j = '[1, 2, 3]' ORDER BY k

-- Test 195: query (line 1299)
SELECT j from json_backfill@forward where j = '{"a": [4, 5]}' OR j = '[1, 2, 3]' ORDER BY k

-- Test 196: statement (line 1306)
DROP INDEX forward_expr;
DROP INDEX forward;

-- Test 197: statement (line 1310)
CREATE INDEX forward_expr on json_backfill ((j->'a'));
CREATE INDEX forward on json_backfill (j);

-- Test 198: query (line 1314)
SELECT j from json_backfill@forward_expr where j->'a' IN ('[1, 2, 3]', '[4,5]') ORDER BY k

-- Test 199: query (line 1320)
SELECT j from json_backfill@forward_expr where j->'a' = '{"a": "b"}' ORDER BY k

-- Test 200: query (line 1325)
SELECT j from json_backfill@forward_expr where j->'a' > '{"a": "b"}' ORDER BY k

-- Test 201: query (line 1329)
SELECT j from json_backfill@forward_expr where j->'a' < '{"a": "b"}' ORDER BY k

-- Test 202: query (line 1335)
SELECT j from json_backfill@forward where j = '[1, 2, 3]' ORDER BY k

-- Test 203: query (line 1340)
SELECT j from json_backfill@forward where j = '{"a": [4, 5]}' OR j = '[1, 2, 3]' ORDER BY k

-- Test 204: statement (line 1349)
CREATE TABLE uniq (
  k INT PRIMARY KEY,
  a INT,
  b INT,
  UNIQUE INDEX ((a + b))
)

-- Test 205: statement (line 1357)
INSERT INTO uniq VALUES (1, 10, 100), (2, 20, 200)

-- Test 206: statement (line 1360)
CREATE UNIQUE INDEX uniq_idx ON uniq ((a > 0))

-- Test 207: statement (line 1363)
INSERT INTO uniq VALUES (3, 1, 109)

-- Test 208: statement (line 1366)
INSERT INTO uniq VALUES (3, 1, 109) ON CONFLICT DO NOTHING

-- Test 209: statement (line 1371)
INSERT INTO uniq VALUES (3, 1, 109) ON CONFLICT ((a + b)) DO NOTHING

-- Test 210: statement (line 1376)
INSERT INTO uniq VALUES (4, 1, 219) ON CONFLICT ((a + b)) DO UPDATE SET b = 90

-- Test 211: statement (line 1381)
CREATE TABLE t72012 (col integer);

-- Test 212: statement (line 1384)
CREATE INDEX t72012_idx ON t72012 ((abs(col)));

-- Test 213: statement (line 1387)
ALTER TABLE t72012 ALTER COLUMN col SET NOT NULL

onlyif config schema-locked-disabled

-- Test 214: query (line 1391)
SHOW CREATE TABLE t72012

-- Test 215: query (line 1402)
SHOW CREATE TABLE t72012

-- Test 216: statement (line 1413)
ALTER TABLE t72012 ALTER COLUMN col DROP NOT NULL;

-- Test 217: statement (line 1416)
INSERT INTO t72012 VALUES (NULL)

-- Test 218: statement (line 1419)
ALTER TABLE t72012 ALTER COLUMN col SET NOT NULL

-- Test 219: statement (line 1433)
ALTER TABLE t SET (schema_locked = false)

-- Test 220: statement (line 1437)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl=off;
CREATE INDEX t_a_times_three_idx ON t ((a * 3));
SELECT crdb_internal.force_retry('10ms');
COMMIT

skipif config schema-locked-disabled

-- Test 221: statement (line 1445)
ALTER TABLE t SET (schema_locked = true)

-- Test 222: statement (line 1450)
CREATE TABLE uniq_json (
  k INT PRIMARY KEY,
  j JSON,
  UNIQUE INDEX ((j->'a'))
)

-- Test 223: statement (line 1457)
INSERT INTO uniq_json VALUES
  (1, '{"a": "b"}'),
  (2, '{"a": "b"}')

-- Test 224: query (line 1477)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab]

-- Test 225: query (line 1490)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab]

-- Test 226: query (line 1502)
SELECT c.conname, c.condef
FROM pg_catalog.pg_constraint c
JOIN pg_catalog.pg_class t ON c.conrelid = t.oid
WHERE t.relname = 'expr_tab'
ORDER BY c.conname

-- Test 227: query (line 1523)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab2]

-- Test 228: query (line 1536)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab2]

-- Test 229: query (line 1548)
SELECT c.conname, c.condef
FROM pg_catalog.pg_constraint c
JOIN pg_catalog.pg_class t ON c.conrelid = t.oid
WHERE t.relname = 'expr_tab2'
ORDER BY c.conname

-- Test 230: query (line 1569)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab3]

-- Test 231: query (line 1582)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab3]

-- Test 232: query (line 1594)
SELECT c.conname, c.condef
FROM pg_catalog.pg_constraint c
JOIN pg_catalog.pg_class t ON c.conrelid = t.oid
WHERE t.relname = 'expr_tab3'
ORDER BY c.conname

-- Test 233: statement (line 1605)
CREATE TABLE expr_tab4 (
  a INT,
  b INT,
  PRIMARY KEY ((a + b)),
  INDEX ((a + 1)),
  FAMILY fam (a, b)
)

onlyif config schema-locked-disabled

-- Test 234: query (line 1615)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab4]

-- Test 235: query (line 1627)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab4]

-- Test 236: query (line 1638)
SELECT c.conname, c.condef
FROM pg_catalog.pg_constraint c
JOIN pg_catalog.pg_class t ON c.conrelid = t.oid
WHERE t.relname = 'expr_tab4'
ORDER BY c.conname

-- Test 237: query (line 1663)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab5]

-- Test 238: query (line 1680)
SELECT create_statement FROM [SHOW CREATE TABLE expr_tab5]

-- Test 239: query (line 1696)
SELECT c.conname, c.condef
FROM pg_catalog.pg_constraint c
JOIN pg_catalog.pg_class t ON c.conrelid = t.oid
WHERE t.relname = 'expr_tab5'
ORDER BY c.conname

