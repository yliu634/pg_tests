-- PostgreSQL compatible tests from vector_index
-- 188 tests

-- Test 1: statement (line 12)
CREATE TABLE simple (
  a INT PRIMARY KEY,
  b INT NOT NULL,
  vec1 VECTOR(3),
  VECTOR INDEX (vec1),
  FAMILY (a, vec1)
)

-- Test 2: statement (line 21)
CREATE VECTOR INDEX ON simple (vec1)

-- Test 3: statement (line 24)
ALTER TABLE simple ALTER PRIMARY KEY USING COLUMNS (b)

-- Test 4: statement (line 28)
CREATE INDEX ON simple USING cspann (vec1);

-- Test 5: statement (line 32)
CREATE INDEX ON simple USING hnsw (vec1);

onlyif config schema-locked-disabled

-- Test 6: query (line 36)
SHOW CREATE TABLE simple

-- Test 7: query (line 53)
SHOW CREATE TABLE simple

-- Test 8: statement (line 69)
SHOW INDEX FROM simple

-- Test 9: statement (line 72)
DROP INDEX simple@simple_vec1_idx

-- Test 10: statement (line 75)
DROP INDEX simple_vec1_idx2

-- Test 11: statement (line 78)
DROP TABLE simple

-- Test 12: statement (line 82)
CREATE TABLE alt_syntax (
  a INT PRIMARY KEY,
  vec1 VECTOR(3),
  VECTOR INDEX vec_idx (vec1),
  FAMILY (a, vec1)
)

-- Test 13: statement (line 90)
CREATE VECTOR INDEX another_index ON alt_syntax (vec1)

onlyif config schema-locked-disabled

-- Test 14: query (line 94)
SHOW CREATE TABLE alt_syntax

-- Test 15: query (line 108)
SHOW CREATE TABLE alt_syntax

-- Test 16: statement (line 120)
DROP TABLE alt_syntax

-- Test 17: statement (line 124)
CREATE TABLE multiple_indexes (
  a INT PRIMARY KEY,
  vec1 VECTOR(3),
  vec2 VECTOR(1000),
  VECTOR INDEX (vec1),
  VECTOR INDEX (vec2),
  FAMILY (a, vec1, vec2)
)

onlyif config schema-locked-disabled

-- Test 18: query (line 135)
SHOW CREATE TABLE multiple_indexes

-- Test 19: query (line 149)
SHOW CREATE TABLE multiple_indexes

-- Test 20: statement (line 162)
DROP INDEX multiple_indexes_vec1_idx;

-- Test 21: statement (line 165)
DROP INDEX multiple_indexes_vec2_idx;

-- Test 22: statement (line 168)
DROP TABLE multiple_indexes

-- Test 23: statement (line 172)
CREATE TABLE prefix_cols (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  vec1 VECTOR(3),
  VECTOR INDEX (c, b, vec1),
  FAMILY (a, b, c, vec1)
)

-- Test 24: statement (line 182)
CREATE VECTOR INDEX another_index ON prefix_cols (b, c, vec1)

onlyif config schema-locked-disabled

-- Test 25: query (line 186)
SHOW CREATE TABLE prefix_cols

-- Test 26: query (line 201)
SHOW CREATE TABLE prefix_cols

-- Test 27: statement (line 215)
DROP TABLE prefix_cols

-- Test 28: statement (line 219)
CREATE TABLE mixed_case (
  a INT PRIMARY KEY,
  qUuX VECTOR(3),
  VECTOR INDEX (qUuX)
)

-- Test 29: statement (line 226)
CREATE VECTOR INDEX ON mixed_case (qUuX)

-- Test 30: statement (line 229)
DROP TABLE mixed_case

-- Test 31: statement (line 233)
CREATE TABLE storage_params (
  a INT PRIMARY KEY,
  v VECTOR(3),
  VECTOR INDEX (v) WITH (build_beam_size = 16),
  FAMILY (a, v)
)

-- Test 32: statement (line 241)
CREATE VECTOR INDEX ON storage_params (v) WITH (min_partition_size = 8, max_partition_size = 64)

onlyif config schema-locked-disabled

-- Test 33: query (line 245)
SHOW CREATE TABLE storage_params

-- Test 34: query (line 258)
SHOW CREATE TABLE storage_params

-- Test 35: statement (line 270)
DROP TABLE storage_params

-- Test 36: statement (line 274)
CREATE TABLE operator_class (
  a INT PRIMARY KEY,
  b INT,
  vec1 VECTOR(3),
  VECTOR INDEX (vec1 vector_l2_ops),
  VECTOR INDEX (b, vec1 vector_cosine_ops),
  VECTOR INDEX (vec1 vector_ip_ops),
  FAMILY (a, b, vec1)
)

-- Test 37: statement (line 285)
CREATE INDEX ON operator_class USING cspann (b, vec1 vector_l2_ops)

-- Test 38: statement (line 288)
CREATE INDEX ON operator_class USING cspann (vec1 vector_cosine_ops)

-- Test 39: statement (line 291)
CREATE INDEX ON operator_class USING cspann (b, vec1 vector_ip_ops)

skipif config schema-locked-disabled

-- Test 40: query (line 295)
SHOW CREATE TABLE operator_class

-- Test 41: query (line 313)
SHOW CREATE TABLE operator_class

-- Test 42: statement (line 330)
DROP TABLE operator_class

-- Test 43: statement (line 339)
CREATE TABLE t (a VECTOR(3), PRIMARY KEY (a))

-- Test 44: statement (line 342)
CREATE TABLE t (a INT PRIMARY KEY, b INT, VECTOR INDEX (b))

-- Test 45: statement (line 345)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (c, b))

-- Test 46: statement (line 349)
CREATE TABLE t (a INT PRIMARY KEY, b TSVECTOR, c VECTOR(3), VECTOR INDEX (b, c))

-- Test 47: statement (line 352)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (b ASC, c))

-- Test 48: statement (line 355)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (b DESC, c))

-- Test 49: statement (line 358)
CREATE TABLE t (a INT PRIMARY KEY, b VECTOR, VECTOR INDEX (b))

-- Test 50: statement (line 362)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), INDEX (b, c))

-- Test 51: statement (line 366)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (b, c) WITH (build_beam_size = 0))

-- Test 52: statement (line 369)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (b, c) WITH (build_beam_size = 513))

-- Test 53: statement (line 372)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (b, c) WITH (min_partition_size = 0))

-- Test 54: statement (line 375)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (b, c) WITH (min_partition_size = 1025))

-- Test 55: statement (line 378)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (b, c) WITH (max_partition_size = 3))

-- Test 56: statement (line 381)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (b, c) WITH (max_partition_size = 4097))

-- Test 57: statement (line 384)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c VECTOR(3), VECTOR INDEX (b, c) WITH (min_partition_size = 2, max_partition_size = 7))

-- Test 58: statement (line 392)
CREATE TABLE vec_errors (
  a INT PRIMARY KEY,
  b INT,
  c TSVECTOR,
  d VECTOR,
  vec1 VECTOR(3),
  FAMILY (a, b, vec1)
)

-- Test 59: statement (line 402)
CREATE VECTOR INDEX ON vec_errors (a, b)

-- Test 60: statement (line 405)
CREATE VECTOR INDEX ON vec_errors (vec1, b)

-- Test 61: statement (line 409)
CREATE VECTOR INDEX ON vec_errors (c, vec1)

-- Test 62: statement (line 412)
CREATE VECTOR INDEX ON vec_errors (b, vec1 DESC)

-- Test 63: statement (line 415)
CREATE VECTOR INDEX ON vec_errors (d)

-- Test 64: statement (line 419)
CREATE INDEX ON vec_errors (b, vec1)

-- Test 65: statement (line 422)
CREATE UNIQUE VECTOR INDEX ON vec_errors (vec1)

-- Test 66: statement (line 425)
CREATE INDEX on vec_errors USING cspann (vec1) STORING (b);

-- Test 67: statement (line 428)
CREATE VECTOR INDEX on vec_errors (vec1) STORING (b);

-- Test 68: statement (line 432)
CREATE INDEX ON vec_errors USING ivfflat (vec1)

-- Test 69: statement (line 436)
CREATE INDEX ON vec_errors USING cspann (vec1 vector_l1_ops)

-- Test 70: statement (line 439)
CREATE INDEX ON vec_errors USING cspann (vec1 nonexistent_op_type)

-- Test 71: statement (line 443)
CREATE VECTOR INDEX ON vec_errors (vec1) WITH (build_beam_size = 0)

-- Test 72: statement (line 446)
DROP TABLE vec_errors

-- Test 73: statement (line 458)
CREATE TABLE alter_test (
  a INT PRIMARY KEY,
  b INT NOT NULL,
  vec1 VECTOR(3),
  VECTOR INDEX (vec1),
  FAMILY (a, b, vec1)
)

-- Test 74: statement (line 467)
ALTER TABLE alter_test ALTER PRIMARY KEY USING COLUMNS (b)

onlyif config schema-locked-disabled

-- Test 75: query (line 471)
SHOW CREATE TABLE alter_test

-- Test 76: query (line 485)
SHOW CREATE TABLE alter_test

-- Test 77: statement (line 498)
DROP TABLE alter_test

-- Test 78: statement (line 510)
CREATE TABLE exec_test (
  a INT PRIMARY KEY,
  b INT,
  vec1 VECTOR(3),
  VECTOR INDEX idx1 (vec1) WITH (min_partition_size=1, max_partition_size=4),
  VECTOR INDEX idx2 (b, vec1) WITH (min_partition_size=1, max_partition_size=4),
  FAMILY (a, b, vec1)
)

-- Test 79: query (line 579)
SELECT a, vec1 FROM exec_test@idx1 ORDER BY vec1 <-> '[1, 1, 2]' LIMIT 3;

-- Test 80: query (line 587)
SELECT a, vec1 FROM exec_test@idx2 WHERE b = 1 ORDER BY vec1 <-> '[1, 1, 2]' LIMIT 1;

-- Test 81: query (line 593)
SELECT a, vec1 FROM exec_test@idx2 WHERE b = 2 ORDER BY vec1 <-> '[15, 15, 15]' LIMIT 2;

-- Test 82: query (line 600)
SELECT a, vec1 FROM exec_test WHERE b IS NULL ORDER BY vec1 <-> '[1, 1, 2]' LIMIT 3;

-- Test 83: query (line 607)
SELECT a, b, vec1 FROM exec_test WHERE b IN (1, 2) ORDER BY vec1 <-> '[1, 1, 2]' LIMIT 4;

-- Test 84: query (line 616)
SELECT a, vec1 FROM exec_test@idx1 ORDER BY vec1 <-> '[5, 5, 5]' LIMIT 10;

-- Test 85: query (line 628)
SELECT a, vec1 FROM exec_test@idx1 ORDER BY vec1 <-> '[5, 5, 5]' LIMIT 3;

-- Test 86: statement (line 635)
DROP TABLE exec_test

-- Test 87: statement (line 659)
INSERT INTO backfill_test VALUES
  (1, 'jack', 10, '[1.0, 2.0, 3.0]', '[3.0, 2.0, 1.0]'),
  (2, 'jill', 20, '[4.0, 5.0, 6.0]', '[6.0, 5.0, 4.0]'),
  (3, 'ash',  30, '[7.0, 8.0, 9.0]', '[9.0, 8.0, 7.0]');

-- Test 88: statement (line 665)
CREATE VECTOR INDEX ON backfill_test (enc)

-- Test 89: query (line 668)
SELECT * FROM backfill_test@backfill_test_enc_idx ORDER BY enc <-> '[1.0, 2.0, 3.0]' LIMIT 3

-- Test 90: statement (line 675)
INSERT INTO backfill_test VALUES
  (4, 'jill', 40, '[1.0, 2.0, 3.5]', '[3.5, 2.0, 1.0]'),
  (5, 'jack', 50, '[4.0, 5.5, 6.0]', '[6.0, 5.5, 4.0]'),
  (6, 'ash',  60, '[7.5, 8.0, 9.0]', '[9.0, 8.0, 7.5]');

-- Test 91: query (line 681)
SELECT * FROM backfill_test@backfill_test_enc_idx ORDER BY enc <-> '[4.0, 5.0, 6.5]' LIMIT 6

-- Test 92: statement (line 691)
UPDATE backfill_test SET data = data + 1 WHERE id IN (SELECT id FROM backfill_test@backfill_test_enc_idx ORDER BY enc <-> '[1.0, 2.0, 3.0]' LIMIT 2)

-- Test 93: query (line 694)
SELECT * FROM backfill_test@backfill_test_enc_idx ORDER BY enc <-> '[1.0, 2.0, 3.0]' LIMIT 6

-- Test 94: statement (line 704)
UPDATE backfill_test SET enc = '[3.0, 2.0, 1.0]' WHERE id = 1

-- Test 95: query (line 707)
SELECT * FROM backfill_test@backfill_test_enc_idx ORDER BY enc <-> '[1.0, 2.0, 3.0]' LIMIT 6

-- Test 96: statement (line 717)
CREATE VECTOR INDEX ON backfill_test (username, prefix_enc)

-- Test 97: query (line 720)
SELECT * FROM backfill_test@backfill_test_username_prefix_enc_idx WHERE username = 'ash' ORDER BY prefix_enc <-> '[3.0, 2.0, 1.0]' LIMIT 2

-- Test 98: statement (line 726)
INSERT INTO backfill_test VALUES
  (7, 'ash',  70, '[3.0, 2.0, 1.0]', '[1.0, 2.0, 3.0]'),
  (8, 'jack', 80, '[4.0, 5.0, 6.0]', '[6.0, 5.0, 4.0]'),
  (9, 'jill', 90, '[7.0, 8.0, 9.0]', '[9.0, 8.0, 7.0]');

-- Test 99: query (line 732)
SELECT * FROM backfill_test@backfill_test_username_prefix_enc_idx WHERE username = 'ash' ORDER BY username, prefix_enc <-> '[3.0, 2.0, 1.0]' LIMIT 3

-- Test 100: statement (line 739)
UPDATE backfill_test SET data = data - 1 WHERE id IN (SELECT id FROM backfill_test@backfill_test_username_prefix_enc_idx WHERE username = 'ash' ORDER BY username, prefix_enc <-> '[3.0, 2.0, 1.0]' LIMIT 1)

-- Test 101: query (line 742)
SELECT * FROM backfill_test@backfill_test_username_prefix_enc_idx WHERE username = 'ash' ORDER BY username, prefix_enc <-> '[3.0, 2.0, 1.0]' LIMIT 3

-- Test 102: statement (line 749)
UPDATE backfill_test SET prefix_enc = '[3.0, 2.0, 1.0]' WHERE id = 7

-- Test 103: query (line 752)
SELECT * FROM backfill_test@backfill_test_username_prefix_enc_idx WHERE username = 'ash' ORDER BY username, prefix_enc <-> '[3.0, 2.0, 1.0]' LIMIT 3

-- Test 104: statement (line 759)
DROP TABLE backfill_test

-- Test 105: statement (line 763)
CREATE TABLE distance_metrics (
  a INT PRIMARY KEY,
  v VECTOR(2),
  VECTOR INDEX idx1 (v vector_l2_ops) WITH (min_partition_size=1, max_partition_size=4),
  VECTOR INDEX idx2 (v vector_cosine_ops) WITH (min_partition_size=1, max_partition_size=4),
  FAMILY (a, v)
)

-- Test 106: statement (line 772)
CREATE VECTOR INDEX idx3 ON distance_metrics (v vector_ip_ops) WITH (min_partition_size=1, max_partition_size=4)

-- Test 107: statement (line 775)
INSERT INTO distance_metrics (a, v) VALUES
  (1, '[0, 0]'),
  (2, '[-2, -2]'),
  (3, '[2, 2]'),
  (4, '[4, 4]');

-- Test 108: statement (line 782)
INSERT INTO distance_metrics (a, v) VALUES
  (5, '[-2, 2]');

-- Test 109: statement (line 787)
CALL process_vector_index_fixups_for('distance_metrics', 'idx1');

-- Test 110: statement (line 790)
CALL process_vector_index_fixups_for('distance_metrics', 'idx2');

-- Test 111: statement (line 793)
CALL process_vector_index_fixups_for('distance_metrics', 'idx3');

-- Test 112: query (line 797)
SELECT a, v, round(v <-> '[2, 2]', 2) dist FROM distance_metrics ORDER BY v <-> '[2, 2]' LIMIT 5;

-- Test 113: query (line 807)
SELECT a, v, round(v <=> '[2, 2]', 2) dist FROM distance_metrics ORDER BY v <=> '[2, 2]' LIMIT 5;

-- Test 114: query (line 817)
SELECT a, v, round(v <#> '[2, 2]', 2) dist FROM distance_metrics@idx3 ORDER BY v <#> '[2, 2]' LIMIT 5;

-- Test 115: statement (line 827)
SELECT a, v, round(v <=> '[2, 2]', 2) dist FROM distance_metrics@idx1 ORDER BY v <=> '[2, 2]' LIMIT 5;

-- Test 116: statement (line 839)
SET CLUSTER SETTING feature.vector_index.enabled = false

-- Test 117: statement (line 842)
CREATE TABLE not_enabled (a INT PRIMARY KEY, v VECTOR(3), VECTOR INDEX (v))

-- Test 118: statement (line 845)
CREATE TABLE enabled (a INT PRIMARY KEY, v VECTOR(3))

-- Test 119: statement (line 848)
CREATE VECTOR INDEX not_enabled_idx ON enabled (v)

-- Test 120: statement (line 851)
DROP TABLE enabled

-- Test 121: statement (line 854)
SET CLUSTER SETTING feature.vector_index.enabled = true

-- Test 122: query (line 858)
SHOW vector_search_beam_size;

-- Test 123: statement (line 863)
SET vector_search_beam_size=8

-- Test 124: query (line 866)
SHOW vector_search_beam_size;

-- Test 125: statement (line 871)
SET vector_search_beam_size=0

-- Test 126: statement (line 874)
SET vector_search_beam_size=2049

-- Test 127: query (line 878)
SHOW vector_search_rerank_multiplier;

-- Test 128: statement (line 883)
SET vector_search_rerank_multiplier=100

-- Test 129: query (line 886)
SHOW vector_search_rerank_multiplier;

-- Test 130: statement (line 891)
SET vector_search_rerank_multiplier=-1

-- Test 131: statement (line 894)
SET vector_search_rerank_multiplier=101

-- Test 132: statement (line 901)
CREATE TABLE test_144621 (a INT PRIMARY KEY, v VECTOR(3))

-- Test 133: statement (line 904)
CREATE VECTOR INDEX vec_idx ON test_144621 (v)

-- Test 134: statement (line 907)
INSERT INTO test_144621 VALUES (1, NULL)

-- Test 135: query (line 910)
SELECT a FROM test_144621;

-- Test 136: query (line 915)
SELECT a FROM test_144621@vec_idx ORDER BY v <-> '[1, 2, 3]' LIMIT 1;

-- Test 137: statement (line 923)
CREATE TABLE import_test (a INT PRIMARY KEY, v VECTOR(3)) WITH (schema_locked=false)

-- Test 138: statement (line 926)
INSERT INTO import_test VALUES (1, '[1, 2, 3]')

let $exp_file
WITH cte AS (EXPORT INTO CSV 'nodelocal://1/vector_import_test' FROM SELECT * FROM import_test) SELECT filename FROM cte;

-- Test 139: statement (line 932)
TRUNCATE TABLE import_test

-- Test 140: statement (line 935)
CREATE VECTOR INDEX vec_idx ON import_test (v)

-- Test 141: statement (line 938)
IMPORT INTO import_test (a, v) CSV DATA ('nodelocal://1/vector_import_test/$exp_file')

-- Test 142: statement (line 941)
DROP TABLE import_test

-- Test 143: statement (line 948)
CREATE TABLE test_145973 (a INT PRIMARY KEY, v VECTOR(3))

-- Test 144: statement (line 951)
INSERT INTO test_145973 VALUES (1)

-- Test 145: statement (line 954)
CREATE VECTOR INDEX vec_idx ON test_145973 (v)

-- Test 146: statement (line 961)
CREATE TABLE test_146046 (
  a INT PRIMARY KEY,
  b INT,
  vec1 VECTOR(3),
  VECTOR INDEX idx1 (vec1) WITH (min_partition_size=1, max_partition_size=4),
  VECTOR INDEX idx2 (b, vec1) WITH (min_partition_size=1, max_partition_size=4),
  FAMILY (a), FAMILY (b), FAMILY (vec1)
)

-- Test 147: statement (line 971)
INSERT INTO test_146046 (a, b, vec1) VALUES
  (1, 1, '[1, 2, 3]'),
  (2, 1, '[4, 5, 6]'),
  (3, 2, '[7, 8, 9]'),
  (4, 2, '[10, 11, 12]'),
  (5, 2, '[13, 14, 15]'),
  (6, NULL, '[16, 17, 18]'),
  (7, NULL, '[1, 1, 1]'),
  (8, NULL, NULL),
  (9, 3, NULL);

-- Test 148: query (line 983)
SELECT a, vec1 FROM test_146046@idx1 ORDER BY vec1 <-> '[5, 5, 5]' LIMIT 1;

-- Test 149: query (line 988)
SELECT a, vec1 FROM test_146046@idx1 ORDER BY vec1 <-> '[5, 5, 5]' LIMIT 10;

-- Test 150: query (line 999)
SELECT a, vec1 FROM test_146046@idx1 ORDER BY vec1 <-> '[5, 5, 5]' LIMIT 3;

-- Test 151: statement (line 1006)
DROP TABLE test_146046

-- Test 152: statement (line 1013)
CREATE TABLE compound_pk (
  cust_id INT NOT NULL,
  dept_id INT NOT NULL,
  embedding VECTOR(3),
  PRIMARY KEY (cust_id, dept_id)
)

-- Test 153: statement (line 1021)
CREATE VECTOR INDEX idx ON compound_pk (cust_id, embedding) WITH (min_partition_size=1, max_partition_size=4)

-- Test 154: statement (line 1024)
INSERT INTO compound_pk VALUES (1, 1, '[1, 2, 3]')

-- Test 155: statement (line 1027)
INSERT INTO compound_pk VALUES (1, 2, '[4, 5, 6]')

-- Test 156: statement (line 1030)
INSERT INTO compound_pk VALUES (2, 1, '[7, 8, 9]')

-- Test 157: statement (line 1033)
INSERT INTO compound_pk VALUES (2, 2, '[10, 11, 12]')

-- Test 158: statement (line 1036)
INSERT INTO compound_pk VALUES (3, 1, '[13, 14, 15]')

-- Test 159: statement (line 1039)
INSERT INTO compound_pk VALUES (3, 2, '[16, 17, 18]')

-- Test 160: statement (line 1042)
INSERT INTO compound_pk VALUES (4, 1, '[19, 20, 21]')

-- Test 161: statement (line 1045)
INSERT INTO compound_pk VALUES (4, 2, '[22, 23, 24]')

-- Test 162: query (line 1048)
SELECT * FROM compound_pk@idx WHERE cust_id = 1 ORDER BY embedding <-> '[1, 2, 3]' LIMIT 2;

-- Test 163: statement (line 1054)
DROP TABLE compound_pk

-- Test 164: statement (line 1061)
CREATE TABLE composite_pk (
  cust_name VARCHAR(10) COLLATE de NOT NULL,
  cust_id INT NOT NULL,
  embedding VECTOR(3),
  PRIMARY KEY (cust_name DESC, cust_id),
  FAMILY fam_0_cust_name_cust_id_embedding (cust_name, cust_id, embedding)
)

-- Test 165: statement (line 1070)
CREATE VECTOR INDEX idx ON composite_pk (embedding) WITH (min_partition_size=1, max_partition_size=4)

-- Test 166: statement (line 1073)
INSERT INTO composite_pk VALUES ('Bär', 1, '[1, 2, 3]')

-- Test 167: statement (line 1076)
INSERT INTO composite_pk VALUES ('Bär', 2, '[4, 5, 6]')

-- Test 168: statement (line 1079)
INSERT INTO composite_pk VALUES ('Bäz', 3, '[7, 8, 9]')

-- Test 169: statement (line 1082)
INSERT INTO composite_pk VALUES ('Bäz', 4, '[10, 11, 12]')

-- Test 170: statement (line 1085)
INSERT INTO composite_pk VALUES ('Bäaz', 5, '[13, 14, 15]')

-- Test 171: statement (line 1088)
INSERT INTO composite_pk VALUES ('Bäaz', 6, '[19, 20, 21]')

-- Test 172: statement (line 1091)
INSERT INTO composite_pk VALUES ('aBäz', 7, '[22, 23, 24]')

-- Test 173: statement (line 1094)
INSERT INTO composite_pk VALUES ('aBäz', 8, '[22, 23, 24]')

-- Test 174: query (line 1097)
SELECT * FROM composite_pk@idx ORDER BY embedding <-> '[1, 2, 3]' LIMIT 2;

-- Test 175: statement (line 1103)
CREATE VECTOR INDEX idx2 ON composite_pk (cust_name, embedding) WITH (min_partition_size=1, max_partition_size=4)

onlyif config schema-locked-disabled

-- Test 176: query (line 1107)
SHOW CREATE TABLE composite_pk;

-- Test 177: query (line 1120)
SELECT * FROM composite_pk@idx2 WHERE cust_name = 'Bäz' ORDER BY embedding <-> '[10, 11, 12]' LIMIT 2;

-- Test 178: statement (line 1126)
ALTER TABLE composite_pk ALTER PRIMARY KEY USING COLUMNS (cust_id)

onlyif config schema-locked-disabled

-- Test 179: query (line 1130)
SHOW CREATE TABLE composite_pk;

-- Test 180: query (line 1144)
SELECT * FROM composite_pk@idx2 WHERE cust_name = 'Bäz' ORDER BY embedding <-> '[10, 11, 12]' LIMIT 2;

-- Test 181: query (line 1151)
SHOW CREATE TABLE composite_pk;

-- Test 182: statement (line 1165)
DROP TABLE composite_pk

-- Test 183: statement (line 1172)
set autocommit_before_ddl=off;

-- Test 184: statement (line 1175)
BEGIN;

-- Test 185: statement (line 1178)
CREATE TABLE test_backfill_149236 (a INT PRIMARY KEY, b INT, vec1 VECTOR(3));

-- Test 186: statement (line 1181)
CREATE VECTOR INDEX idx ON test_backfill_149236 (vec1);

-- Test 187: statement (line 1184)
COMMIT;

-- Test 188: statement (line 1187)
SET autocommit_before_ddl=on;

