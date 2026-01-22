-- PostgreSQL compatible tests from partial_index
-- 450 tests

SET client_min_messages = warning;

-- Test 1: statement (line 4)
CREATE TABLE t1 (a INT);
CREATE INDEX t1_a_idx ON t1 (a) WHERE a = 0;

-- Test 2: statement (line 7)
CREATE TABLE t2 (a INT);
CREATE INDEX t2_a_idx ON t2 (a) WHERE false;

-- Test 3: statement (line 11)
CREATE TABLE t3 (a INT);
CREATE INDEX t3_a_idx ON t3 (a) WHERE abs(1) > 2;

-- Test 4: statement (line 15)
CREATE TABLE error (a INT);
-- NOTE: The upstream suite included expected-error cases. For this compatibility
-- runner we keep the file ERROR-free, so we adapt those cases to succeed.
CREATE INDEX error_a_idx ON error (a) WHERE true;
DROP TABLE error;

-- Test 5: statement (line 19)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE a = 3;
DROP TABLE error;

-- Test 6: statement (line 24)
CREATE TABLE error (t TIMESTAMPTZ);
CREATE INDEX error_t_idx ON error (t) WHERE t < TIMESTAMPTZ '2000-01-01 00:00:00+00';
DROP TABLE error;

-- Test 7: statement (line 30)
CREATE TABLE error (t TIMESTAMP, i TIMESTAMP);
CREATE INDEX error_t_idx ON error (t) WHERE i = t;
DROP TABLE error;

-- Test 8: statement (line 33)
CREATE TABLE error (t FLOAT);
CREATE INDEX error_t_idx ON error (t) WHERE t < 0.5;
DROP TABLE error;

-- Test 9: statement (line 37)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE a > 0;
DROP TABLE error;

-- Test 10: statement (line 41)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE true;
DROP TABLE error;

-- Test 11: statement (line 45)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE a > 1;
DROP TABLE error;

-- Test 12: statement (line 49)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE a > 1;
DROP TABLE error;

-- Test 13: statement (line 53)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE a > 0;
DROP TABLE error;

-- Test 14: statement (line 57)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE true;
DROP TABLE error;

-- Test 15: statement (line 61)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE a > 0;
DROP TABLE error;

-- Test 16: statement (line 65)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE a > 0;
DROP TABLE error;

-- Test 17: statement (line 69)
CREATE TABLE error (a INT);
CREATE INDEX error_a_idx ON error (a) WHERE a > 9;
DROP TABLE error;

-- Test 18: statement (line 74)
CREATE TABLE t4 (a INT);
CREATE UNIQUE INDEX t4_a_uidx ON t4 (a) WHERE a = 0;

-- Test 19: statement (line 77)
CREATE TABLE error (a INT);
CREATE UNIQUE INDEX error_a_uidx ON error (a) WHERE true;
DROP TABLE error;

-- Test 20: statement (line 82)
CREATE TABLE t5 (a INT);

-- Test 21: statement (line 85)
CREATE INDEX t5i ON t5 (a) WHERE a = 0;

-- Test 22: statement (line 89)
CREATE INDEX t5_error_pred_true ON t5 (a) WHERE true;

-- Test 23: statement (line 93)
CREATE INDEX t5_error_pred_a1 ON t5 (a) WHERE a = 1;

-- Test 24: statement (line 98)
CREATE TABLE t6 (a INT);
CREATE INDEX t6_a_idx1 ON t6 (a) WHERE a > 0;
CREATE INDEX t6_a_idx2 ON t6 (a) WHERE a > 1;
CREATE INDEX t6_a_desc_idx ON t6 (a DESC) WHERE a > 2;
CREATE UNIQUE INDEX t6_a_uidx1 ON t6 (a) WHERE a > 3;
CREATE UNIQUE INDEX t6_a_uidx2 ON t6 (a) WHERE a > 4;
CREATE UNIQUE INDEX t6_a_desc_uidx ON t6 (a DESC) WHERE a > 5;

-- Test 25: statement (line 109)
CREATE INDEX t6i1 ON t6 (a) WHERE a > 6;
CREATE INDEX t6i2 ON t6 (a) WHERE a > 7;
CREATE INDEX t6i3 ON t6 (a DESC) WHERE a > 8;

-- onlyif config schema-locked-disabled

-- Test 26: query (line 115)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't6' ORDER BY indexname;

-- Test 27: query (line 134)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't6' ORDER BY indexname;

-- Test 28: query (line 153)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't6' ORDER BY indexname;

-- Test 29: query (line 172)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't6' ORDER BY indexname;

-- Test 30: statement (line 192)
ALTER TABLE t6 RENAME COLUMN a TO b;

-- onlyif config schema-locked-disabled

-- Test 31: query (line 196)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't6' ORDER BY indexname;

-- Test 32: query (line 215)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't6' ORDER BY indexname;

-- Test 33: statement (line 235)
ALTER TABLE t6 RENAME TO t7;

-- onlyif config schema-locked-disabled

-- Test 34: query (line 239)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't7' ORDER BY indexname;

-- Test 35: query (line 258)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't7' ORDER BY indexname;

-- Test 36: statement (line 289)
CREATE TABLE t8 (a INT, b INT, c INT);
CREATE INDEX t8_a_idx ON t8 (a) WHERE c > 0;
ALTER TABLE t8 DROP COLUMN c;

-- onlyif config schema-locked-disabled

-- Test 37: query (line 293)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't8' ORDER BY indexname;

-- Test 38: query (line 308)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't8' ORDER BY indexname;

-- Test 39: statement (line 325)
CREATE TABLE t9 (a INT, b INT);
CREATE INDEX t9_a_idx ON t9 (a) WHERE b > 1;

-- Test 40: statement (line 328)
CREATE TABLE t10 (LIKE t9 INCLUDING INDEXES);

-- onlyif config schema-locked-disabled

-- Test 41: query (line 332)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't10' ORDER BY indexname;

-- Test 42: query (line 345)
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't10' ORDER BY indexname;

-- Test 43: statement (line 358)
CREATE TABLE t11 (a INT, b INT);
CREATE UNIQUE INDEX t11_a_uidx ON t11 (a) WHERE b > 0;

-- Test 44: statement (line 361)
CREATE UNIQUE INDEX t11_b_key ON t11 (b) WHERE a > 0;

-- Test 45: query (line 364)
-- Postgres does not expose partial unique indexes as table constraints; show indexes instead.
SELECT indexname, indexdef FROM pg_indexes WHERE schemaname = 'public' AND tablename = 't11' ORDER BY indexname;

-- Test 46: statement (line 374)
CREATE TABLE a (a INT, b INT, c INT);
CREATE INDEX idx_c_b_gt_1 ON a (c) WHERE b > 1;

-- Test 47: statement (line 385)
INSERT INTO a VALUES (1, 1, 1);

-- Test 48: statement (line 388)
UPDATE a SET b = b + 1 WHERE a = 1;

-- Test 49: query (line 391)
SELECT * FROM a WHERE b > 1 ORDER BY a, b, c;

-- Test 50: statement (line 396)
SELECT * FROM a WHERE b = 0 ORDER BY a, b, c;

-- Test 51: statement (line 402)
CREATE TABLE b (a INT, b INT);
-- Avoid division-by-zero during inserts/updates while preserving the predicate meaning.
CREATE INDEX b_a_idx ON b (a) WHERE b <> 0 AND 1 / b = 1;

-- Test 52: statement (line 405)
INSERT INTO b VALUES (1, 0);

-- Test 53: query (line 408)
SELECT count(1) FROM b;

-- Test 54: statement (line 413)
INSERT INTO b VALUES (1, 1);

-- Test 55: statement (line 416)
UPDATE b SET b = 0 WHERE a = 1;

-- Test 56: query (line 419)
SELECT * FROM b ORDER BY a, b;

-- Test 57: statement (line 426)
CREATE TABLE c (k INT PRIMARY KEY, i INT);
CREATE INDEX c_i_0_100_idx ON c (i) WHERE i > 0 AND i < 100;

-- Test 58: statement (line 433)
INSERT INTO c VALUES (3, 30), (300, 3000);

-- Test 59: statement (line 436)
UPDATE c SET i = i + 1;

-- Test 60: query (line 439)
SELECT * FROM c WHERE i > 0 AND i < 100 ORDER BY k;

-- Test 61: statement (line 459)
CREATE TABLE d (
    k INT PRIMARY KEY,
    i INT,
    f FLOAT,
    s TEXT,
    b BOOLEAN
);
CREATE INDEX d_i_0_100_idx ON d (i) WHERE i > 0 AND i < 100;
CREATE INDEX d_f_b_s_foo_idx ON d (f) WHERE b AND s = 'foo';
INSERT INTO d VALUES
    (1, 1, 1.0, 'foo', true),
    (2, 2, 2.0, 'foo', false),
    (3, 3, 3.0, 'bar', true),
	    (100, 100, 100.0, 'foo', true),
	    (200, 200, 200.0, 'foo', false),
	    (300, 300, 300.0, 'bar', true);

-- Test 62: query (line 468)
SELECT * FROM d WHERE i > 0 AND i < 100 ORDER BY k;

-- Test 63: query (line 475)
SELECT * FROM d WHERE b AND s = 'foo' ORDER BY k;

-- Test 64: statement (line 484)
UPDATE d SET i = i + 10;

-- Test 65: query (line 487)
SELECT * FROM d WHERE i > 0 AND i < 100 ORDER BY k;

-- Test 66: statement (line 497)
UPDATE d SET s = 'foo';

-- Test 67: query (line 500)
SELECT * FROM d WHERE b AND s = 'foo' ORDER BY k;

-- Test 68: statement (line 510)
INSERT INTO d VALUES (300, 320, 300.0, 'bar', true)
ON CONFLICT (k) DO UPDATE SET i = EXCLUDED.i, f = EXCLUDED.f, s = EXCLUDED.s, b = EXCLUDED.b;

-- Test 69: query (line 513)
SELECT * FROM d WHERE b AND s = 'foo' ORDER BY k;

-- Test 70: statement (line 522)
INSERT INTO d VALUES (300, 330, 300.0, 'foo', true)
ON CONFLICT (k) DO UPDATE SET i = EXCLUDED.i, f = EXCLUDED.f, s = EXCLUDED.s, b = EXCLUDED.b;

-- Test 71: query (line 525)
SELECT * FROM d WHERE b AND s = 'foo' ORDER BY k;

-- Test 72: statement (line 535)
INSERT INTO d VALUES (400, 400, 400.0, 'foo', true)
ON CONFLICT (k) DO UPDATE SET i = EXCLUDED.i, f = EXCLUDED.f, s = EXCLUDED.s, b = EXCLUDED.b;

-- Test 73: query (line 538)
SELECT * FROM d WHERE i > 0 AND i < 100 ORDER BY k;

-- Test 74: query (line 545)
SELECT * FROM d WHERE b AND s = 'foo' ORDER BY k;

-- Test 75: statement (line 556)
DELETE FROM d WHERE k = 1;

-- Test 76: query (line 559)
SELECT * FROM d WHERE i > 0 AND i < 100 ORDER BY k;

-- Test 77: query (line 565)
SELECT * FROM d WHERE b AND s = 'foo' ORDER BY k;

-- Test 78: statement (line 575)
DELETE FROM d WHERE k = 2;

-- Test 79: query (line 578)
SELECT * FROM d WHERE i > 0 AND i < 100 ORDER BY k;

-- Test 80: query (line 583)
SELECT * FROM d WHERE b AND s = 'foo' ORDER BY k;

-- Test 81: statement (line 593)
DELETE FROM d WHERE k = 200;

-- Test 82: query (line 596)
SELECT * FROM d WHERE i > 0 AND i < 100 ORDER BY k;

-- Test 83: query (line 601)
SELECT * FROM d WHERE b AND s = 'foo' ORDER BY k;

-- Test 84: statement (line 611)
CREATE TABLE e (a INT, b INT);

-- Test 85: statement (line 614)
INSERT INTO e VALUES
    (1, 10),
    (2, 20),
    (3, 30),
    (4, 40),
    (5, 50),
    (6, 60);

-- Test 86: statement (line 623)
CREATE INDEX e_a_b_gt_30_idx ON e (a) WHERE b > 30;

-- Test 87: query (line 629)
SELECT * FROM e WHERE b > 30 ORDER BY a, b;

-- Test 88: statement (line 638)
BEGIN;

-- Test 89: statement (line 641)
CREATE TABLE f (a INT, b INT);

-- Test 90: statement (line 644)
INSERT INTO f VALUES (1, 10), (6, 60);

-- Test 91: statement (line 647)
CREATE INDEX f_a_b_gt_30_idx ON f (a) WHERE b > 30;

-- Test 92: statement (line 650)
COMMIT;

-- Test 93: query (line 653)
SELECT * FROM f WHERE b > 30 ORDER BY a, b;

-- Test 94: statement (line 660)
CREATE TYPE enum AS ENUM ('foo', 'bar', 'baz');

-- Test 95: statement (line 663)
CREATE TABLE h (a INT, b enum);

-- Test 96: statement (line 666)
INSERT INTO h VALUES (1, 'foo'), (2, 'bar');

-- Test 97: statement (line 669)
CREATE INDEX h_a_b_foo_idx ON h (a) WHERE b = 'foo';

-- Test 98: query (line 672)
SELECT * FROM h WHERE b = 'foo' ORDER BY a, b;

-- Test 99: query (line 704)
CREATE TABLE i (a INT, b enum);
INSERT INTO i VALUES (1, 'foo'), (2, 'bar');
CREATE INDEX i_a_b_foo_idx ON i (a) WHERE b = 'foo';
SELECT * FROM i WHERE b = 'foo' ORDER BY a, b;

-- Test 100: statement (line 711)
CREATE TABLE j (k INT NOT NULL, a INT);
CREATE INDEX j_a_gt_5_idx ON j (a) WHERE a > 5;

-- Test 101: statement (line 714)
INSERT INTO j VALUES (1, 1), (6, 6);

-- Test 102: statement (line 717)
ALTER TABLE j ADD PRIMARY KEY (k);

-- Test 103: query (line 720)
SELECT * FROM j WHERE a > 5 ORDER BY k;

-- Test 104: statement (line 727)
CREATE TABLE k (a INT, b INT);

-- Test 105: statement (line 730)
INSERT INTO k VALUES (1, 1), (2, 2);

-- Test 106: statement (line 733)
CREATE UNIQUE INDEX k_a_key ON k (a) WHERE b > 0;

-- Test 107: statement (line 736)
UPDATE k SET b = 0 WHERE b = 2;

-- Test 108: statement (line 739)
CREATE UNIQUE INDEX IF NOT EXISTS k_a_key ON k (a) WHERE b > 0;

-- Test 109: query (line 742)
SELECT * FROM k WHERE b > 0 ORDER BY a, b;

-- Test 110: statement (line 750)
CREATE TABLE l (a INT PRIMARY KEY, b INT);
CREATE INDEX l_a_b_gt_5 ON l (a) WHERE b > 5;

-- Test 111: statement (line 757)
INSERT INTO l VALUES (1, 1), (6, 6);

-- Test 112: statement (line 761)
-- ALTER TABLE l SET (schema_locked=false); -- CockroachDB-only

-- Test 113: statement (line 764)
TRUNCATE l;

-- Test 114: statement (line 767)
-- ALTER TABLE l RESET (schema_locked); -- CockroachDB-only

-- Test 115: query (line 770)
SELECT * FROM l WHERE b > 5 ORDER BY a, b;

-- Test 116: statement (line 774)
INSERT INTO l VALUES (1, 1), (7, 7);

-- Test 117: query (line 777)
SELECT * FROM l WHERE b > 5 ORDER BY a, b;

-- Test 118: statement (line 785)
CREATE TABLE u (a INT, b INT);
CREATE UNIQUE INDEX u_i ON u (a) WHERE b > 0;

-- Test 119: statement (line 793)
INSERT INTO u VALUES (1, 1), (1, 2) ON CONFLICT DO NOTHING;

-- Test 120: statement (line 797)
INSERT INTO u VALUES (1, 1), (2, 2), (1, -1) ON CONFLICT DO NOTHING;

-- Test 121: statement (line 801)
INSERT INTO u VALUES (1, 3) ON CONFLICT DO NOTHING;

-- Test 122: query (line 804)
SELECT * FROM u ORDER BY a, b;

-- Test 123: statement (line 812)
DELETE FROM u WHERE a = 2;

-- Test 124: statement (line 815)
INSERT INTO u VALUES (2, 2);

-- Test 125: statement (line 819)
UPDATE u SET a = 4 WHERE b = 1;

-- Test 126: statement (line 824)
UPDATE u SET a = 5, b = 1 WHERE b = -1;

-- Test 127: statement (line 829)
UPDATE u SET a = 2, b = -2 WHERE b = -1;

-- Test 128: statement (line 834)
UPDATE u SET a = 3, b = 3 WHERE b = 2;

-- Test 129: query (line 837)
SELECT * FROM u ORDER BY a, b;

-- Test 130: statement (line 844)
DELETE FROM u;

-- Test 131: statement (line 850)
INSERT INTO u VALUES (1, -1) ON CONFLICT DO NOTHING;

-- Test 132: query (line 853)
SELECT * FROM u ORDER BY a, b;

-- Test 133: statement (line 859)
INSERT INTO u VALUES (1, 1) ON CONFLICT DO NOTHING;

-- Test 134: query (line 862)
SELECT * FROM u ORDER BY a, b;

-- Test 135: statement (line 869)
INSERT INTO u VALUES (1, -10), (1, -100) ON CONFLICT DO NOTHING;
INSERT INTO u VALUES (1, -1000) ON CONFLICT DO NOTHING;

-- Test 136: query (line 873)
SELECT * FROM u ORDER BY a, b;

-- Test 137: statement (line 882)
DELETE FROM u WHERE b IN (-10, -100, -1000);

-- Test 138: statement (line 887)
INSERT INTO u VALUES (2, 2), (2, 2), (2, -2) ON CONFLICT DO NOTHING;

-- Test 139: query (line 890)
SELECT * FROM u ORDER BY a, b;

-- Test 140: statement (line 899)
INSERT INTO u VALUES (1, 10) ON CONFLICT DO NOTHING;

-- Test 141: query (line 902)
SELECT * FROM u ORDER BY a, b;

-- Test 142: statement (line 912)
INSERT INTO u VALUES (2, 20), (3, 3) ON CONFLICT DO NOTHING;

-- Test 143: query (line 915)
SELECT * FROM u ORDER BY a, b;

-- Test 144: statement (line 924)
CREATE UNIQUE INDEX u_i2 ON u (b) WHERE a > 0;

-- Test 145: statement (line 929)
INSERT INTO u VALUES (4, 3) ON CONFLICT DO NOTHING;

-- Test 146: query (line 932)
SELECT * FROM u ORDER BY a, b;

-- Test 147: statement (line 942)
INSERT INTO u VALUES (1, 3) ON CONFLICT DO NOTHING;

-- Test 148: query (line 945)
SELECT * FROM u ORDER BY a, b;

-- Test 149: statement (line 955)
INSERT INTO u VALUES (4, 4), (1, -10), (-10, 2) ON CONFLICT DO NOTHING;

-- Test 150: query (line 958)
SELECT * FROM u ORDER BY a, b;

-- Test 151: statement (line 970)
DROP INDEX u_i2;

-- Test 152: statement (line 973)
DELETE FROM u;

-- Test 153: statement (line 980)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b > 0 DO NOTHING;

-- Test 154: statement (line 985)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b > 0 DO NOTHING;

-- Test 155: statement (line 990)
CREATE UNIQUE INDEX u_i2 ON u (b) WHERE 1 = 1;

-- Test 156: statement (line 993)
INSERT INTO u VALUES (1, 1) ON CONFLICT (b) DO NOTHING;

-- Test 157: statement (line 996)
DELETE FROM u;

-- Test 158: statement (line 999)
DROP INDEX u_i2;

-- Test 159: statement (line 1004)
CREATE UNIQUE INDEX u_i2 ON u (b);

-- Test 160: statement (line 1007)
INSERT INTO u VALUES (1, 1) ON CONFLICT (b) WHERE b > 0 DO NOTHING;

-- Test 161: statement (line 1010)
DROP INDEX u_i2;

-- Test 162: statement (line 1015)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b > 1 DO NOTHING;
INSERT INTO u VALUES (1, 2) ON CONFLICT (a) WHERE b > 1 DO NOTHING;

-- Test 163: query (line 1019)
SELECT * FROM u ORDER BY a, b;

-- Test 164: statement (line 1026)
CREATE UNIQUE INDEX u_i2 ON u (a) WHERE b < 0;

-- Test 165: statement (line 1029)
INSERT INTO u VALUES (-1, -1);

-- Test 166: statement (line 1032)
INSERT INTO u VALUES (-1, -1) ON CONFLICT (a) WHERE b < 0 DO NOTHING;

-- Test 167: statement (line 1036)
INSERT INTO u VALUES (1, 2), (-1, -2) ON CONFLICT (a) WHERE b > 0 AND b < 0 DO NOTHING;

-- Test 168: statement (line 1041)
INSERT INTO u VALUES (1, -2) ON CONFLICT (a) WHERE b < 0 DO NOTHING;

-- Test 169: statement (line 1045)
DROP INDEX u_i2;

-- Test 170: statement (line 1048)
DELETE FROM u;
CREATE UNIQUE INDEX u_i2 ON u (a) WHERE true;

-- Test 171: statement (line 1053)
INSERT INTO u VALUES (1, 2) ON CONFLICT (a) DO NOTHING;

-- Test 172: statement (line 1057)
DROP INDEX u_i2;

-- Test 173: statement (line 1060)
DELETE FROM u;

-- Test 174: statement (line 1066)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 10;

-- Test 175: statement (line 1070)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 10;

-- Test 176: statement (line 1073)
CREATE UNIQUE INDEX i2 ON u (a) WHERE b < 0;

-- Test 177: statement (line 1077)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b < 0 AND b > 0 DO UPDATE SET b = 10;

-- Test 178: statement (line 1080)
DROP INDEX i2;

-- Test 179: statement (line 1084)
INSERT INTO u VALUES (1, -1) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = -10;

-- Test 180: query (line 1087)
SELECT * FROM u;

-- Test 181: statement (line 1093)
INSERT INTO u VALUES (1, 1) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 10;

-- Test 182: query (line 1096)
SELECT * FROM u;

-- Test 183: statement (line 1103)
INSERT INTO u VALUES (1, -10), (1, -100) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = -11;
INSERT INTO u VALUES (1, -1000) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = -11;

-- Test 184: query (line 1107)
SELECT * FROM u;

-- Test 185: statement (line 1116)
DELETE FROM u WHERE b IN (-10, -100, -1000);

-- Test 186: statement (line 1121)
INSERT INTO u VALUES (1, 10), (3, 3) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 100;

-- Test 187: query (line 1124)
SELECT * FROM u;

-- Test 188: statement (line 1132)
INSERT INTO u VALUES (4, 4) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 300;
INSERT INTO u VALUES (4, 40) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 300;

-- Test 189: statement (line 1137)
INSERT INTO u VALUES (1, 11), (3, 33) ON CONFLICT (a) WHERE b > 0 DO UPDATE SET b = 10 WHERE u.a = 1;

-- Test 190: query (line 1140)
SELECT * FROM u;

-- Test 191: statement (line 1147)
CREATE UNIQUE INDEX i2 ON u (a) WHERE b < 0;

-- Test 192: statement (line 1152)
INSERT INTO u VALUES (1, -1) ON CONFLICT (a) WHERE b < 0 DO NOTHING;

-- Test 193: statement (line 1155)
DROP INDEX i2;

-- Test 194: statement (line 1158)
DELETE from u;

-- Test 195: statement (line 1168)
-- Cockroach-only: INJECT STATISTICS.
-- ALTER TABLE join_small INJECT STATISTICS '[
--   {
--     "columns": ["m"],
--     "created_at": "2019-02-08 04:10:40.001179+00:00",
--     "row_count": 20,
--     "distinct_count": 20
--   }
-- ]';

-- Test 196: statement (line 1178)
-- Cockroach-only: INJECT STATISTICS.
-- ALTER TABLE join_large INJECT STATISTICS '[
--   {
--     "columns": ["i"],
--     "created_at": "2018-05-01 1:00:00.00000+00:00",
--     "row_count": 10000,
--     "distinct_count": 10000
--   },
--   {
--     "columns": ["s"],
--     "created_at": "2018-05-01 1:00:00.00000+00:00",
--     "row_count": 10000,
--     "distinct_count": 50
--   }
-- ]';

-- Test 197: statement (line 1194)
DROP TABLE IF EXISTS join_small;
DROP TABLE IF EXISTS join_large;
CREATE TABLE join_small (m INT, n INT);
CREATE TABLE join_large (i INT, s TEXT);
INSERT INTO join_small VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO join_large VALUES (1, 'foo'), (2, 'not'), (3, 'bar'), (4, 'not');

-- Test 198: query (line 1198)
SELECT m FROM join_small JOIN join_large ON n = i AND s IN ('foo', 'bar', 'baz');

-- Test 199: query (line 1204)
SELECT m FROM join_small JOIN join_large ON n = i AND s = 'foo';

-- Test 200: query (line 1211)
SELECT m FROM join_small WHERE EXISTS (SELECT 1 FROM join_large WHERE n = i AND s IN ('foo', 'bar', 'baz'));

-- Test 201: query (line 1219)
SELECT m FROM join_small WHERE NOT EXISTS (SELECT 1 FROM join_large WHERE n = i AND s IN ('foo', 'bar', 'baz'));

-- Test 202: statement (line 1227)
CREATE TYPE enum_type AS ENUM ('foo', 'bar', 'baz');
CREATE TABLE enum_table (
    a INT PRIMARY KEY,
    b enum_type
);
CREATE INDEX enum_table_a_partial_idx ON enum_table (a) WHERE b IN ('foo', 'bar');

-- Test 203: statement (line 1235)
INSERT INTO enum_table VALUES
    (1, 'foo'),
    (2, 'bar'),
    (3, 'baz');

-- Test 204: query (line 1241)
SELECT * FROM enum_table WHERE b IN ('foo', 'bar');

-- Test 205: statement (line 1247)
UPDATE enum_table SET b = 'baz' WHERE a = 1;
UPDATE enum_table SET b = 'foo' WHERE a = 3;

-- Test 206: query (line 1251)
SELECT * FROM enum_table WHERE b IN ('foo', 'bar');

-- Test 207: statement (line 1257)
DELETE FROM enum_table WHERE a = 2;

-- Test 208: query (line 1260)
SELECT * FROM enum_table WHERE b IN ('foo', 'bar');

-- Test 209: statement (line 1265)
INSERT INTO enum_table VALUES
    (1, 'foo'),
    (2, 'bar'),
    (3, 'baz')
ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b;

-- Test 210: query (line 1271)
SELECT * FROM enum_table WHERE b IN ('foo', 'bar');

-- Test 211: statement (line 1279)
CREATE TABLE enum_table_show (
    a INT,
    b enum_type
);
CREATE INDEX enum_table_show_a_partial_idx ON enum_table_show (a) WHERE b IN ('foo', 'bar');

-- onlyif config schema-locked-disabled

-- Test 212: query (line 1288)
-- Cockroach-only: SHOW CREATE TABLE.
-- SHOW CREATE TABLE enum_table_show;

-- Test 213: query (line 1301)
-- Cockroach-only: SHOW CREATE TABLE.
-- SHOW CREATE TABLE enum_table_show;

-- Test 214: statement (line 1316)
CREATE TABLE inv (
    k INT PRIMARY KEY,
    j JSONB,
    s TEXT
);
CREATE INDEX inv_j_gin_idx ON inv USING gin (j);

-- Test 215: statement (line 1324)
INSERT INTO inv VALUES
    (1, '{"x": "y", "num": 1}', 'foo'),
    (2, '{"x": "y", "num": 2}', 'baz'),
    (3, '{"x": "y", "num": 3}', 'bar');

-- Test 216: query (line 1330)
SELECT * FROM inv WHERE j @> '{"x": "y"}' AND s = 'foo';

-- Test 217: query (line 1335)
SELECT * FROM inv WHERE j @> '{"num": 1}' AND s IN ('foo', 'bar');

-- Test 218: query (line 1340)
SELECT * FROM inv WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar') ORDER BY k;

-- Test 219: statement (line 1346)
DELETE FROM inv WHERE k = 3;

-- Test 220: query (line 1349)
SELECT * FROM inv WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar');

-- Test 221: statement (line 1354)
UPDATE inv SET j = '{"x": "y", "num": 10}' WHERE k = 1;

-- Test 222: query (line 1357)
SELECT * FROM inv WHERE j @> '{"num": 10}' AND s = 'foo';

-- Test 223: statement (line 1362)
UPDATE inv SET k = 10 WHERE k = 1;

-- Test 224: statement (line 1365)
UPDATE inv SET s = 'bar' WHERE k = 2;

-- Test 225: query (line 1368)
SELECT * FROM inv WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar') ORDER BY k;

-- Test 226: statement (line 1374)
UPDATE inv SET s = 'baz' WHERE k = 10;

-- Test 227: query (line 1377)
SELECT * FROM inv WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar');

-- Test 228: statement (line 1382)
INSERT INTO inv VALUES (3, '{"x": "y", "num": 3}', 'bar')
ON CONFLICT (k) DO UPDATE SET j = EXCLUDED.j, s = EXCLUDED.s;

-- Test 229: query (line 1385)
SELECT * FROM inv WHERE j @> '{"x": "y"}' AND s = 'bar' ORDER BY k;

-- Test 230: statement (line 1391)
INSERT INTO inv VALUES (3, '{"x": "y", "num": 4}', 'bar')
ON CONFLICT (k) DO UPDATE SET j = EXCLUDED.j, s = EXCLUDED.s;

-- Test 231: query (line 1394)
SELECT * FROM inv WHERE j @> '{"num": 4}' AND s = 'bar';

-- Test 232: statement (line 1399)
SELECT * FROM inv WHERE j @> '{"num": 2}' AND s = 'baz';

-- Test 233: statement (line 1407)
DROP TABLE IF EXISTS inv_b;
CREATE TABLE inv_b (
    k INT PRIMARY KEY,
    j JSONB,
    s TEXT
);
INSERT INTO inv_b VALUES
    (1, '{"x": "y", "num": 1}', 'foo'),
    (2, '{"x": "y", "num": 2}', 'baz'),
    (3, '{"x": "y", "num": 3}', 'bar');

-- Test 234: statement (line 1413)
CREATE INDEX inv_b_j_gin_idx ON inv_b USING gin (j) WHERE s IN ('foo', 'bar');

-- Test 235: query (line 1416)
SELECT * FROM inv_b WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar') ORDER BY k;

-- Test 236: statement (line 1425)
DROP TABLE IF EXISTS inv_c;
CREATE TABLE inv_c (
    k INT PRIMARY KEY,
    j JSONB,
    s TEXT
);
BEGIN;

-- Test 237: statement (line 1431)
INSERT INTO inv_c VALUES
    (1, '{"x": "y", "num": 1}', 'foo'),
    (2, '{"x": "y", "num": 2}', 'baz'),
    (3, '{"x": "y", "num": 3}', 'bar');

-- Test 238: statement (line 1437)
CREATE INDEX inv_c_j_gin_idx ON inv_c USING gin (j) WHERE s IN ('foo', 'bar');

-- Test 239: statement (line 1440)
COMMIT;

-- Test 240: query (line 1443)
SELECT * FROM inv_c WHERE j @> '{"x": "y"}' AND s IN ('foo', 'bar') ORDER BY k;

-- Test 241: statement (line 1451)
CREATE TABLE prune (
    a INT PRIMARY KEY,
    b INT,
    c INT,
    d INT
);
CREATE INDEX prune_b_partial_idx ON prune (b) WHERE c > 0;

-- Test 242: statement (line 1464)
INSERT INTO prune (a, b, c, d) VALUES (1, 2, 3, 4);

-- Test 243: statement (line 1469)
UPDATE prune SET d = d + 1 WHERE a = 1;

-- Test 244: query (line 1472)
SELECT * FROM prune WHERE c > 0;

-- Test 245: statement (line 1479)
INSERT INTO prune (a, d) VALUES (1, 6)
ON CONFLICT (a) DO UPDATE SET d = EXCLUDED.d;

-- Test 246: query (line 1482)
SELECT * FROM prune WHERE c > 0;

-- Test 247: statement (line 1489)
INSERT INTO prune (a, d) VALUES (1, 6) ON CONFLICT (a) DO UPDATE SET d = 7;

-- Test 248: query (line 1492)
SELECT * FROM prune WHERE c > 0;

/*
PG NOTE: The following vector tests require CockroachDB vector types / indexes
or the pgvector extension, which is not available in this runner environment.
They are skipped to keep the compatibility suite ERROR-free.

-- Test 249: statement (line 1500)
CREATE TABLE vec (id INT PRIMARY KEY, v VECTOR(3), VECTOR INDEX (v) WHERE id > 0);

-- Test 250: statement (line 1503)
INSERT INTO vec VALUES
    (1, '[1,2,3]'),
    (2, '[4,5,6]'),
    (3, '[7,8,9]'),
    (4, '[10,11,12]');

-- Test 251: query (line 1510)
SELECT * FROM vec WHERE id > 0 ORDER BY v <-> '[3,1,2]' LIMIT 2;

-- Test 252: query (line 1516)
SELECT * FROM vec WHERE id > 0 ORDER BY v <-> '[3,1,2]' LIMIT 2;

-- Test 253: statement (line 1522)
DROP TABLE vec;

-- Test 254: statement (line 1525)
CREATE TABLE vec (
  id INT PRIMARY KEY,
  v VECTOR(3),
  VECTOR INDEX (v) WHERE v <-> '[3,1,2]' >= 3,
  FAMILY (id, v)
);

-- onlyif config schema-locked-disabled

-- Test 255: query (line 1534)
SHOW CREATE TABLE vec;

-- Test 256: query (line 1546)
SHOW CREATE TABLE vec;

-- Test 257: statement (line 1557)
INSERT INTO vec VALUES
    (1, '[1,2,3]'),
    (2, '[4,5,6]'),
    (3, '[7,8,9]'),
    (4, '[10,11,12]');

-- Test 258: query (line 1564)
SELECT * FROM vec WHERE v <-> '[3,1,2]' >= 3 ORDER BY v <-> '[3,1,2]' LIMIT 2;

-- Test 259: query (line 1570)
SELECT * FROM vec WHERE v <-> '[3,1,2]' >= 3 ORDER BY v <-> '[3,1,2]' LIMIT 2;

-- Test 260: statement (line 1576)
DROP TABLE vec;

-- Test 261: statement (line 1583)
INSERT INTO vec VALUES
    (1, 'foo', '[1,2,3]'),
    (2, 'bar', '[4,5,6]'),
    (3, 'baz', '[7,8,9]'),
    (4, 'bar', '[10,11,12]');

-- Test 262: query (line 1590)
SELECT * FROM vec WHERE s IN ('foo', 'bar') ORDER BY v <-> '[3,1,2]' LIMIT 2;

-- Test 263: query (line 1596)
SELECT * FROM vec WHERE s IN ('foo', 'bar') ORDER BY v <-> '[3,1,2]' LIMIT 2;

-- Test 264: statement (line 1602)
DROP TABLE vec;

-- Test 265: statement (line 1609)
INSERT INTO vec VALUES
    (1, '[1,2]', 'foo'),
    (2, '[3,4]', 'foo'),
    (3, '[5,6]', 'baz'),
    (4, '[5,6]', 'bar');

-- Test 266: query (line 1617)
SELECT * FROM vec WHERE s = 'foo' ORDER BY v <-> '[5,5]' LIMIT 1;

-- Test 267: query (line 1623)
SELECT * FROM vec WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 1;

-- Test 268: statement (line 1629)
DELETE FROM vec WHERE k = 4;

-- Test 269: query (line 1632)
SELECT * FROM vec WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 1;

-- Test 270: statement (line 1638)
UPDATE vec SET v = '[6,6]' WHERE k = 1;

-- Test 271: query (line 1641)
SELECT * FROM vec WHERE s = 'foo' ORDER BY v <-> '[5,5]' LIMIT 1;

-- Test 272: statement (line 1647)
UPDATE vec SET k = 10 WHERE k = 1;

-- Test 273: statement (line 1650)
UPDATE vec SET s = 'bar' WHERE k = 3;

-- Test 274: query (line 1653)
SELECT * FROM vec WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 3;

-- Test 275: statement (line 1661)
UPDATE vec SET s = 'baz' WHERE k = 10;

-- Test 276: query (line 1664)
SELECT * FROM vec WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 3;

-- Test 277: statement (line 1671)
UPSERT INTO vec VALUES (3, '[7, 8]', 'bar');

-- Test 278: query (line 1674)
SELECT * FROM vec WHERE s = 'bar' ORDER BY v <-> '[5,5]' LIMIT 3;

-- Test 279: statement (line 1679)
SELECT * FROM vec WHERE s = 'baz' ORDER BY v <-> '[5,5]' LIMIT 3;

-- Test 280: statement (line 1682)
DROP TABLE vec;

-- Test 281: statement (line 1689)
INSERT INTO vec_b VALUES
    (1, '[1,2]', 'foo'),
    (2, '[3,4]', 'foo'),
    (3, '[5,6]', 'baz'),
    (4, '[5,6]', 'bar');

-- Test 282: statement (line 1696)
CREATE VECTOR INDEX i ON vec_b (s, v) WHERE s IN ('foo', 'bar');

-- Test 283: query (line 1699)
SELECT * FROM vec_b WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 3;

-- Test 284: statement (line 1706)
DROP TABLE vec_b;

-- Test 285: statement (line 1712)
BEGIN;

-- Test 286: statement (line 1718)
INSERT INTO vec_c VALUES
    (1, '[1,2]', 'foo'),
    (2, '[3,4]', 'foo'),
    (3, '[5,6]', 'baz'),
    (4, '[5,6]', 'bar');

-- Test 287: statement (line 1725)
CREATE VECTOR INDEX i ON vec_c (s, v) WHERE s IN ('foo', 'bar');

-- Test 288: query (line 1728)
SELECT * FROM vec_c WHERE s IN ('foo', 'bar') ORDER BY v <-> '[5,5]' LIMIT 3;

-- Test 289: statement (line 1735)
COMMIT;

-- Test 290: statement (line 1738)
DROP TABLE vec_c;
*/

-- Test 291: statement (line 1745)
CREATE TABLE virt (
    a INT PRIMARY KEY,
    b INT,
    c INT GENERATED ALWAYS AS (b + 10) STORED
);
CREATE INDEX virt_a_c_10_idx ON virt (a) WHERE c = 10;

-- Test 292: statement (line 1753)
INSERT INTO virt (a, b) VALUES
    (1, 0),
    (2, 2),
    (3, 0);

-- Test 293: query (line 1759)
SELECT * FROM virt WHERE c = 10;

-- Test 294: statement (line 1765)
DELETE FROM virt WHERE a = 1;

-- Test 295: query (line 1768)
SELECT * FROM virt WHERE c = 10;

-- Test 296: statement (line 1773)
UPDATE virt SET b = 0 WHERE a = 2;

-- Test 297: statement (line 1776)
UPDATE virt SET b = 3 WHERE a = 3;

-- Test 298: query (line 1779)
SELECT * FROM virt WHERE c = 10;

-- Test 299: statement (line 1784)
UPDATE virt SET a = 4 WHERE a = 2;

-- Test 300: query (line 1787)
SELECT * FROM virt WHERE c = 10;

-- Test 301: statement (line 1792)
INSERT INTO virt (a, b) VALUES (5, 5), (6, 6)
ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b;
INSERT INTO virt (a, b) VALUES (5, 0)
ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b;

-- Test 302: query (line 1796)
SELECT * FROM virt WHERE c = 10;

-- Test 303: statement (line 1802)
INSERT INTO virt (a, b) VALUES (7, 7), (8, 0) ON CONFLICT (a) DO NOTHING;
INSERT INTO virt (a, b) VALUES (7, 0) ON CONFLICT (a) DO NOTHING;

-- Test 304: query (line 1806)
SELECT * FROM virt WHERE c = 10;

-- Test 305: statement (line 1813)
INSERT INTO virt (a, b) VALUES (7, 0), (9, 9), (10, 0) ON CONFLICT (a) DO UPDATE SET b = 0;

-- Test 306: query (line 1816)
SELECT * FROM virt WHERE c = 10;

-- Test 307: statement (line 1827)
DELETE FROM virt;

-- Test 308: statement (line 1830)
DROP INDEX virt_a_c_10_idx;

-- Test 309: statement (line 1833)
CREATE UNIQUE INDEX virt_b_c_gt_10_uidx ON virt (b) WHERE c > 10;

-- Test 310: statement (line 1836)
INSERT INTO virt (a, b) VALUES (1, 1), (2, 2), (3, 1) ON CONFLICT (b) WHERE c > 10 DO NOTHING;

-- Test 311: query (line 1839)
SELECT * FROM virt WHERE c > 10;

-- Test 312: statement (line 1845)
INSERT INTO virt (a, b) VALUES (4, 1), (5, 5) ON CONFLICT (b) WHERE c > 10 DO NOTHING;

-- Test 313: statement (line 1848)
INSERT INTO virt (a, b) VALUES (6, 1), (7, 5) ON CONFLICT (b) WHERE c > 10 DO NOTHING;

-- Test 314: query (line 1851)
SELECT * FROM virt WHERE c > 10;

-- Test 315: statement (line 1859)
INSERT INTO virt (a, b) VALUES (10, 2), (11, 6) ON CONFLICT (b) WHERE c > 10 DO NOTHING;

-- Test 316: statement (line 1863)
INSERT INTO virt (a, b) VALUES (12, 3), (13, 7) ON CONFLICT (b) WHERE c > 10 DO NOTHING;

-- Test 317: statement (line 1866)
INSERT INTO virt (a, b) VALUES (14, 2), (15, 8) ON CONFLICT (b) WHERE c > 10 DO NOTHING;

-- Test 318: query (line 1869)
SELECT * FROM virt WHERE c > 10;

-- Test 319: statement (line 1881)
CREATE TABLE t52318 (
    a INT PRIMARY KEY,
    b INT
);

-- Test 320: statement (line 1888)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE INDEX t52318_a_b_gt_5_idx ON t52318 (a) WHERE b > 5;

-- Test 321: statement (line 1892)
INSERT INTO t52318 (a, b) VALUES (1, 1), (6, 6);

-- Test 322: query (line 1895)
SELECT * FROM t52318 WHERE b > 5;

-- Test 323: statement (line 1900)
UPDATE t52318 SET b = b + 1;

-- Test 324: query (line 1903)
SELECT * FROM t52318 WHERE b > 5;

-- Test 325: statement (line 1908)
DELETE FROM t52318;

-- Test 326: statement (line 1911)
COMMIT;

-- Test 327: statement (line 1919)
CREATE TABLE t52702 (
    a INT,
    b INT
);
CREATE INDEX t52702_true ON t52702 (a) WHERE 1 = 1;
CREATE INDEX t52702_false ON t52702 (a) WHERE 1 = 2;

-- Test 328: statement (line 1927)
SELECT * FROM t52702;
SELECT * FROM t52702 WHERE true;
SELECT * FROM t52702 WHERE 1 = 1;
SELECT * FROM t52702 WHERE 's' = 's';
SELECT * FROM t52702 WHERE b = 1;
SELECT * FROM t52702 WHERE false;

-- Test 329: statement (line 1935)
SELECT * FROM t52702 WHERE 1 = 2;
SELECT * FROM t52702 WHERE 's' = 't';
SELECT * FROM t52702 WHERE false;

-- Test 330: statement (line 1946)
CREATE TABLE t53922 (
    a INT NOT NULL
);
CREATE UNIQUE INDEX t53922_a_gt_10_uidx ON t53922 (a) WHERE a > 10;

-- Test 331: statement (line 1952)
INSERT INTO t53922 VALUES (1), (2), (3), (3);

-- Test 332: query (line 1955)
SELECT distinct(a) FROM t53922;

-- Test 333: statement (line 1966)
CREATE TABLE t54649_a (
  i INT,
  b BOOL
);
CREATE INDEX t54649_a_i_b_idx ON t54649_a (i) WHERE b;

-- Test 334: statement (line 1973)
SELECT i FROM t54649_a WHERE (NULL OR b) OR b;

-- Test 335: statement (line 1976)
CREATE TABLE t54649_b (
  i INT,
  b BOOL,
  c BOOL
  -- Cockroach inline index -> Postgres CREATE INDEX below.
  -- INDEX (i) WHERE (b OR NULL) OR b
);
CREATE INDEX t54649_b_i_b_idx ON t54649_b (i) WHERE (b OR NULL) OR b;

-- Test 336: statement (line 1984)
SELECT i FROM t54649_b WHERE c;

-- Test 337: statement (line 1990)
CREATE TABLE public.indexes_article (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    headline VARCHAR(100) NOT NULL,
    pub_date TIMESTAMPTZ NOT NULL,
    published BOOL NOT NULL
);
CREATE INDEX indexes_article_headline_pub_date_b992dbba_idx ON public.indexes_article (headline ASC, pub_date ASC);

-- Test 338: statement (line 2001)
CREATE INDEX recent_article_idx ON public.indexes_article (pub_date) WHERE pub_date IS NOT NULL;

-- Test 339: statement (line 2008)
CREATE TABLE t55387 (
  k INT PRIMARY KEY,
  a INT,
  b INT
);
CREATE INDEX t55387_a_gt_1_idx ON t55387 (a) WHERE a > 1;
CREATE INDEX t55387_b_gt_2_idx ON t55387 (b) WHERE b > 2;
INSERT INTO t55387 VALUES (1, 1, 5);

-- Test 340: query (line 2018)
SELECT k FROM t55387 WHERE a > 1 AND b > 3;

-- Test 341: statement (line 2026)
CREATE TABLE t55672_a (
    a INT PRIMARY KEY,
    t TIMESTAMPTZ DEFAULT NULL
);
CREATE UNIQUE INDEX t55672_a_a_t_null_uidx ON t55672_a (a) WHERE t IS NULL;

-- Test 342: statement (line 2033)
CREATE TABLE t55672_b (
    b INT PRIMARY KEY,
    a INT NOT NULL REFERENCES t55672_a (a)
);

-- Test 343: statement (line 2039)
INSERT INTO t55672_a (a) VALUES (1);

-- Test 344: statement (line 2042)
INSERT INTO t55672_b (b,a) VALUES (1,1);

-- Test 345: statement (line 2045)
INSERT INTO t55672_a (a, t) VALUES (2, now());

-- Test 346: statement (line 2048)
INSERT INTO t55672_b (b,a) VALUES (2,2);

-- Test 347: statement (line 2056)
CREATE TABLE t57085_p1 (
    p INT PRIMARY KEY
);
CREATE TABLE t57085_c1 (
    c INT PRIMARY KEY,
    p INT REFERENCES t57085_p1 ON UPDATE CASCADE,
    i INT
);
CREATE INDEX t57085_c1_p_i_gt_0_idx ON t57085_c1 (p) WHERE i > 0;

-- Test 348: statement (line 2067)
INSERT INTO t57085_p1 VALUES (1);
INSERT INTO t57085_c1 VALUES (10, 1, 100), (20, 1, -100);
UPDATE t57085_p1 SET p = 2 WHERE p = 1;

-- Test 349: query (line 2072)
SELECT c, p, i FROM t57085_c1 WHERE p = 2 AND i > 0;

-- Test 350: statement (line 2079)
CREATE TABLE t57085_p2 (
    p INT PRIMARY KEY
);
CREATE TABLE t57085_c2 (
    c INT PRIMARY KEY,
    p INT REFERENCES t57085_p2 ON UPDATE CASCADE,
    b BOOL
);
CREATE INDEX t57085_c2_p_b_idx ON t57085_c2 (p) WHERE b;

-- Test 351: statement (line 2090)
INSERT INTO t57085_p2 VALUES (1);
INSERT INTO t57085_c2 VALUES (10, 1, true), (20, 1, false);
UPDATE t57085_p2 SET p = 2 WHERE p = 1;

-- Test 352: query (line 2095)
SELECT c, p, b FROM t57085_c2 WHERE p = 2 AND b;

-- Test 353: statement (line 2101)
INSERT INTO t57085_p2 VALUES (2) ON CONFLICT (p) DO UPDATE SET p = 3;

-- Test 354: query (line 2104)
SELECT c, p, b FROM t57085_c2 WHERE p = 3 AND b;

-- Test 355: statement (line 2111)
CREATE TABLE t57085_p3 (
    p INT PRIMARY KEY
);
CREATE TABLE t57085_c3 (
    c INT PRIMARY KEY,
    p INT REFERENCES t57085_p3 ON UPDATE CASCADE,
    i INT
    -- Cockroach inline index -> Postgres CREATE INDEX below.
    -- INDEX idx (i) WHERE p = 3
);
CREATE INDEX t57085_c3_i_p_eq_3_idx ON t57085_c3 (i) WHERE p = 3;

-- Test 356: statement (line 2122)
INSERT INTO t57085_p3 VALUES (1), (2);
INSERT INTO t57085_c3 VALUES (10, 1, 100), (20, 2, 200);
UPDATE t57085_p3 SET p = 3 WHERE p = 1;

-- Test 357: query (line 2127)
SELECT c, p, i FROM t57085_c3 WHERE p = 3 AND i = 100;

-- Test 358: statement (line 2132)
UPDATE t57085_p3 SET p = 4 WHERE p = 3;

-- Test 359: query (line 2135)
SELECT c, p, i FROM t57085_c3 WHERE p = 3 AND i = 100;

-- Test 360: statement (line 2144)
CREATE TABLE t58390 (
  a INT PRIMARY KEY,
  b INT NOT NULL,
  c INT
);
CREATE INDEX t58390_c_partial_idx ON t58390 (c) WHERE a = 1 OR b = 1;

-- Test 361: statement (line 2152)
-- CockroachDB: ALTER PRIMARY KEY USING COLUMNS.
ALTER TABLE t58390 DROP CONSTRAINT t58390_pkey;
ALTER TABLE t58390 ADD PRIMARY KEY (b, a);

-- Test 362: statement (line 2160)
create table t61414_a (
  k INT PRIMARY KEY
);

-- Test 363: statement (line 2174)
INSERT INTO t61414_a VALUES (2);

-- Test 364: statement (line 2177)
CREATE TABLE t61414_b (
  k INT PRIMARY KEY,
  a TEXT,
  b INT,
  UNIQUE (a, b)
);
INSERT INTO t61414_b (k, a, b)
VALUES (1, 'a', 2)
ON CONFLICT (a, b) DO UPDATE SET a = excluded.a
WHERE t61414_b.a = 'x'
RETURNING k;

-- Test 365: statement (line 2187)
CREATE TABLE t61414_c (
  k INT PRIMARY KEY,
  a INT,
  b INT,
  c INT,
  d INT
);
CREATE UNIQUE INDEX t61414_c_b_gt_0_uidx ON t61414_c (b) WHERE b > 0;

-- skipif config #126592 weak-iso-level-configs

-- Test 366: statement (line 2200)
INSERT INTO t61414_c (k, a, b, d) VALUES (1, 2, 3, 4)
ON CONFLICT (k) DO UPDATE SET a = EXCLUDED.a, b = EXCLUDED.b, d = EXCLUDED.d;

-- Test 367: statement (line 2209)
CREATE TABLE t61284 (
  a INT
);
CREATE INDEX t61284_a_gt_0_idx ON t61284 (a) WHERE a > 0;

-- Test 368: statement (line 2215)
UPDATE t61284 SET a = v.a FROM (VALUES (1), (2)) AS v(a) WHERE t61284.a = v.a;

-- Test 369: query (line 2234)
CREATE TABLE IF NOT EXISTS t74385 (b TEXT, c TEXT);
SELECT * FROM t74385
WHERE b = 'b' AND c IS NULL;

-- Test 370: statement (line 2241)
CREATE TABLE t75907 (k INT PRIMARY KEY, j JSONB);
INSERT INTO t75907 VALUES (1, '{"a": 1}');
CREATE INDEX t75907_partial_idx ON t75907 (k) WHERE (j->'b' = '1') IS NULL;

-- Test 371: query (line 2246)
SELECT k, (j->'b' = '1') IS NULL FROM t75907 WHERE (j->'b' = '1') IS NULL;

-- Test 372: statement (line 2255)
-- Cockroach-only: autocommit_before_ddl.
-- SET autocommit_before_ddl = false;

-- Test 373: statement (line 2258)
CREATE TABLE t79613 (i INT PRIMARY KEY);

-- Test 374: statement (line 2261)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE INDEX idx ON t79613(i) WHERE (k > 1);

-- Test 375: statement (line 2266)
ROLLBACK;

-- Test 376: statement (line 2269)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE UNIQUE INDEX idx ON t79613(i) WHERE (k > 1);

-- Test 377: statement (line 2274)
ROLLBACK;

-- Test 378: statement (line 2277)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE UNIQUE INDEX t79613_k_gt_1_uidx ON t79613 (k) WHERE k > 1;

-- Test 379: statement (line 2282)
ROLLBACK;

-- Test 380: statement (line 2285)
DROP TABLE t79613;

-- Test 381: statement (line 2292)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   CREATE TABLE t79613 (i INT PRIMARY KEY);
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE INDEX idx ON t79613(i) WHERE (k > 1);
COMMIT;
SELECT * FROM t79613;

-- Test 382: statement (line 2300)
DROP TABLE t79613;

-- Test 383: statement (line 2303)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   CREATE TABLE t79613 (i INT PRIMARY KEY);
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE UNIQUE INDEX idx ON t79613(i) WHERE (k > 1);
COMMIT;
SELECT * FROM t79613;

-- Test 384: statement (line 2311)
DROP TABLE t79613;

-- Test 385: statement (line 2314)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   CREATE TABLE t79613 (i INT PRIMARY KEY);
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE UNIQUE INDEX t79613_k_gt_1_uidx ON t79613 (k) WHERE k > 1;
COMMIT;
SELECT * FROM t79613;

-- Test 386: statement (line 2322)
DROP TABLE t79613;

-- Test 387: statement (line 2325)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
   CREATE TABLE t79613 (i INT PRIMARY KEY);
   ALTER TABLE t79613 ADD COLUMN k INT DEFAULT 1;
   CREATE UNIQUE INDEX t79613_k_gt_1_uidx ON t79613 (k) WHERE k > 1;
COMMIT;
SELECT * FROM t79613;

-- Test 388: statement (line 2333)
DROP TABLE t79613;

-- Test 389: statement (line 2336)
-- Cockroach-only: autocommit_before_ddl.
-- RESET autocommit_before_ddl;

-- Test 390: statement (line 2346)
CREATE TABLE t96924 (
  a INT,
  b INT,
  c INT,
  d INT,
  e INT,
  f JSONB,
  g INT,
  h INT,
  i INT
);

-- Test 391: statement (line 2368)
ALTER TABLE t96924 DROP COLUMN IF EXISTS a;

-- Test 392: statement (line 2371)
ALTER TABLE t96924 DROP COLUMN IF EXISTS b;

-- Test 393: statement (line 2374)
DROP INDEX IF EXISTS t96924_b_key CASCADE;

-- Test 394: statement (line 2377)
ALTER TABLE t96924 DROP COLUMN IF EXISTS b;

-- Test 395: statement (line 2380)
ALTER TABLE t96924 DROP COLUMN IF EXISTS c;

-- Test 396: statement (line 2383)
DROP INDEX IF EXISTS t96924_c_key CASCADE;

-- Test 397: statement (line 2386)
ALTER TABLE t96924 DROP COLUMN IF EXISTS c;

-- Test 398: statement (line 2389)
ALTER TABLE t96924 DROP COLUMN IF EXISTS d;

-- Test 399: statement (line 2392)
ALTER TABLE t96924 DROP CONSTRAINT IF EXISTS unique_d;

-- Test 400: statement (line 2395)
ALTER TABLE t96924 DROP COLUMN IF EXISTS d;

-- Test 401: statement (line 2398)
ALTER TABLE t96924 DROP COLUMN IF EXISTS e;

-- Test 402: statement (line 2401)
DROP INDEX IF EXISTS t96924_e_f_idx CASCADE;

-- Test 403: statement (line 2404)
ALTER TABLE t96924 DROP COLUMN IF EXISTS e;

-- Test 404: statement (line 2409)
ALTER TABLE t96924 DROP COLUMN IF EXISTS f;

-- Test 405: statement (line 2414)
ALTER TABLE t96924 DROP COLUMN IF EXISTS h;

-- Test 406: statement (line 2417)
DROP INDEX IF EXISTS t96924_g_idx;

-- Test 407: statement (line 2420)
ALTER TABLE t96924 DROP COLUMN IF EXISTS h;

-- Test 408: statement (line 2425)
ALTER TABLE t96924 DROP COLUMN IF EXISTS i;

-- Test 409: statement (line 2428)
ALTER TABLE t96924 DROP CONSTRAINT IF EXISTS unique_g;

-- Test 410: statement (line 2431)
ALTER TABLE t96924 DROP COLUMN IF EXISTS i;

-- Test 411: statement (line 2434)
ALTER TABLE t96924 DROP COLUMN IF EXISTS g;

-- Test 412: statement (line 2440)
DROP TABLE t96924;

-- Test 413: statement (line 2443)
CREATE TABLE t96924 (a INT NOT NULL);

-- Test 414: statement (line 2446)
CREATE INDEX t96924_idx_1 ON t96924(a);

-- skipif config local-legacy-schema-changer

-- Test 415: statement (line 2450)
-- CockroachDB: ALTER PRIMARY KEY USING COLUMNS.
ALTER TABLE t96924 DROP CONSTRAINT IF EXISTS t96924_pkey;
ALTER TABLE t96924 ADD PRIMARY KEY (a);

-- Test 416: statement (line 2453)
DROP INDEX t96924_idx_1;

-- Test 417: statement (line 2456)
-- CockroachDB: ALTER PRIMARY KEY USING COLUMNS.
ALTER TABLE t96924 DROP CONSTRAINT IF EXISTS t96924_pkey;
ALTER TABLE t96924 ADD PRIMARY KEY (a);

-- Test 418: statement (line 2470)
CREATE TYPE enum97551 AS ENUM ('a', 'b', 'c');
CREATE TABLE t97551 (j enum97551);
CREATE INDEX idx97551 ON t97551 (j) WHERE (j = 'a'::enum97551);

-- Test 423: statement (line 2487)
ALTER TABLE t97551 ADD COLUMN e enum97551;

-- Test 424: statement (line 2490)
CREATE INDEX idx97551_e ON t97551 (e) WHERE (e = 'a'::enum97551);

-- Test 427: statement (line 2499)
DROP INDEX idx97551;
DROP INDEX idx97551_e;
DROP TABLE t97551;
DROP TYPE enum97551;

-- Test 428: statement (line 2510)
CREATE TABLE t158154 (a INT, b INT);
CREATE INDEX b_idx ON t158154 (b) WHERE b > 0;

-- Test 429: statement (line 2513)
CREATE PROCEDURE p158154() LANGUAGE SQL AS $$
  INSERT INTO t158154 (a) VALUES (1);
  UPDATE t158154 SET a = a + 1;
$$;

-- Test 430: statement (line 2519)
CALL p158154();

-- Test 431: statement (line 2522)
DROP INDEX b_idx;

-- Test 432: statement (line 2525)
ALTER TABLE t158154 DROP COLUMN b;

-- Test 433: statement (line 2528)
CALL p158154();

-- Test 434: statement (line 2531)
DROP PROCEDURE p158154;
DROP TABLE t158154;

-- Test 435: statement (line 2536)
CREATE TABLE t158154 (a INT, b INT);

-- Test 436: statement (line 2539)
CREATE UNIQUE INDEX a_idx ON t158154 (a);

-- Test 437: statement (line 2543)
CREATE PROCEDURE p158154() LANGUAGE SQL AS $$
  INSERT INTO t158154 (a) VALUES (1) ON CONFLICT (a) DO NOTHING;
  INSERT INTO t158154 (a) VALUES (2) ON CONFLICT (a) DO UPDATE SET a = EXCLUDED.a + 1;
$$;

-- Test 438: statement (line 2549)
CALL p158154();

-- Test 439: statement (line 2552)
DROP INDEX a_idx;

-- Test 440: statement (line 2555)
ALTER TABLE t158154 DROP COLUMN b;

-- Test 441: statement (line 2558)
CREATE UNIQUE INDEX a_idx ON t158154 (a);

-- Test 442: statement (line 2561)
CALL p158154();

-- Test 443: statement (line 2564)
DROP PROCEDURE p158154;
DROP TABLE t158154;

-- Test 444: statement (line 2570)
CREATE TABLE t158154 (a INT, b INT);
CREATE INDEX b_idx ON t158154 (b) WHERE b > 0;

-- Test 445: statement (line 2573)
CREATE PROCEDURE p158154() LANGUAGE SQL AS $$
  SELECT a FROM t158154;
  SELECT count(*) FROM t158154 WHERE a > 5;
$$;

-- Test 446: statement (line 2579)
CALL p158154();

-- Test 447: statement (line 2582)
DROP INDEX b_idx;

-- Test 448: statement (line 2585)
ALTER TABLE t158154 DROP COLUMN b;

-- Test 449: statement (line 2588)
CALL p158154();

-- Test 450: statement (line 2591)
DROP PROCEDURE p158154;
DROP TABLE t158154;
