-- PostgreSQL compatible tests from inspect
-- 145 tests

-- Test 1: statement (line 13)
CREATE VIEW last_inspect_job AS
SELECT status, jsonb_array_length(
    crdb_internal.pb_to_json('cockroach.sql.jobs.jobspb.Payload', payload)->'inspectDetails'->'checks'
  ) AS num_checks
FROM crdb_internal.system_jobs
WHERE job_type = 'INSPECT'
ORDER BY id DESC
LIMIT 1

-- Test 2: statement (line 24)
SET CLUSTER SETTING jobs.registry.interval.adopt = '500ms';

-- Test 3: statement (line 27)
CREATE TABLE foo (c1 INT, c2 INT, INDEX idx_c1 (c1), INDEX idx_c2 (c2));

let $foo_created_ts
SELECT now()

-- Test 4: statement (line 36)
BEGIN;

-- Test 5: statement (line 39)
INSPECT TABLE foo;

-- Test 6: statement (line 42)
ROLLBACK;

-- Test 7: statement (line 45)
INSPECT TABLE foo WITH OPTIONS DETACHED

-- Test 8: query (line 49)
SELECT status FROM last_inspect_job

-- Test 9: statement (line 55)
BEGIN;

-- Test 10: statement (line 58)
INSPECT TABLE foo WITH OPTIONS DETACHED

-- Test 11: query (line 62)
SELECT status FROM last_inspect_job

-- Test 12: statement (line 67)
COMMIT;

-- Test 13: query (line 71)
SELECT status FROM last_inspect_job

-- Test 14: statement (line 83)
INSPECT TABLE foo WITH OPTIONS DETACHED, DETACHED = FALSE

-- Test 15: statement (line 88)
INSPECT TABLE foo WITH OPTIONS DETACHED = TRUE

-- Test 16: query (line 91)
SELECT * FROM last_inspect_job

-- Test 17: statement (line 96)
INSPECT TABLE foo WITH OPTIONS DETACHED

-- Test 18: query (line 99)
SELECT * FROM last_inspect_job

-- Test 19: statement (line 105)
INSPECT TABLE foo WITH OPTIONS DETACHED = TRUE, INDEX (idx_c1)

-- Test 20: query (line 108)
SELECT * FROM last_inspect_job

-- Test 21: statement (line 115)
INSPECT TABLE foo;

-- Test 22: query (line 118)
SELECT * FROM last_inspect_job;

-- Test 23: statement (line 123)
INSPECT TABLE foo WITH OPTIONS INDEX (idx_c1);

-- Test 24: query (line 126)
SELECT * FROM last_inspect_job;

-- Test 25: statement (line 132)
INSPECT TABLE foo WITH OPTIONS INDEX (idx_c1, foo@idx_c1);

-- Test 26: query (line 135)
SELECT * FROM last_inspect_job;

-- Test 27: query (line 143)
SELECT * FROM last_inspect_job;

-- Test 28: statement (line 148)
INSPECT TABLE foo WITH OPTIONS INDEX (idx_c3);

-- Test 29: statement (line 151)
INSPECT TABLE foo WITH OPTIONS INDEX ALL;

-- Test 30: query (line 154)
SELECT * FROM last_inspect_job;

-- Test 31: statement (line 159)
INSPECT DATABASE test;

-- Test 32: query (line 162)
SELECT * FROM last_inspect_job;

-- Test 33: statement (line 167)
INSPECT DATABASE test WITH OPTIONS INDEX (idx_c1, idx_c3);

-- Test 34: statement (line 170)
CREATE TABLE bar (c1 INT, c3 INT);

-- Test 35: statement (line 173)
INSPECT TABLE bar;

-- Test 36: query (line 176)
SELECT * FROM last_inspect_job;

-- Test 37: statement (line 181)
CREATE INDEX idx_c1 ON bar (c1);
CREATE INDEX idx_c3 ON bar (c3);

-- Test 38: statement (line 185)
INSPECT TABLE foo WITH OPTIONS INDEX (bar@idx_c1);

-- Test 39: statement (line 188)
INSPECT DATABASE test WITH OPTIONS INDEX (dbfake.foo.idx_c1);

-- Test 40: statement (line 191)
INSPECT DATABASE test WITH OPTIONS INDEX (idx_c1, idx_c3);

-- Test 41: statement (line 194)
INSPECT DATABASE test WITH OPTIONS INDEX (foo@idx_c1, test.public.bar@idx_c1, test.idx_c3);

-- Test 42: query (line 197)
SELECT * FROM last_inspect_job;

-- Test 43: statement (line 206)
CREATE USER testuser2;

user testuser2

-- Test 44: statement (line 211)
INSPECT TABLE foo;

-- Test 45: statement (line 214)
INSPECT DATABASE test;

user root

-- Test 46: statement (line 219)
GRANT SYSTEM INSPECT TO testuser2;

user testuser2

-- Test 47: statement (line 224)
INSPECT TABLE foo;

-- Test 48: statement (line 227)
INSPECT DATABASE test;

-- Test 49: statement (line 238)
CREATE TABLE t2 (
    x INT, y INT, z INT,
    j JSONB NULL,
    INDEX hash_idx (x) USING HASH,
    INDEX expr_idx ((y + z)),
    INDEX regular_idx_y (y),
    INDEX regular_idx_z (z),
    VECTOR INDEX vector_idx ((CAST(j->>'v' AS VECTOR(3)))),
    INDEX partial_idx (j) WHERE 1=1,
    INVERTED INDEX inverted_idx (j)
);

-- Test 50: statement (line 251)
INSERT INTO t2 (x, y, z) VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3);

-- Test 51: query (line 259)
SELECT * FROM last_inspect_job;

-- Test 52: statement (line 264)
INSPECT TABLE t2 WITH OPTIONS INDEX (t2@t2_pkey);

-- Test 53: statement (line 267)
INSPECT TABLE t2 WITH OPTIONS INDEX (hash_idx);

-- Test 54: statement (line 270)
INSPECT TABLE t2 WITH OPTIONS INDEX (expr_idx);

-- Test 55: statement (line 273)
INSPECT TABLE t2 WITH OPTIONS INDEX (vector_idx);

-- Test 56: statement (line 276)
INSPECT TABLE t2 WITH OPTIONS INDEX (partial_idx);

-- Test 57: statement (line 279)
INSPECT TABLE t2 WITH OPTIONS INDEX (inverted_idx);

-- Test 58: query (line 283)
SELECT * FROM last_inspect_job;

-- Test 59: statement (line 288)
DROP TABLE t2;

-- Test 60: statement (line 298)
CREATE TABLE t_virtual (
    c1 INT,
    c2 INT AS (c1 + 1) VIRTUAL,
    c3 INT,
    INDEX idx_c2 (c2),
    INDEX idx_c3 (c3)
);

-- Test 61: statement (line 307)
INSERT INTO t_virtual (c1, c3) VALUES (1, 10), (2, 20), (3, 30);

-- Test 62: query (line 315)
SELECT * FROM last_inspect_job;

-- Test 63: statement (line 321)
INSPECT TABLE t_virtual WITH OPTIONS INDEX (idx_c2);

-- Test 64: statement (line 325)
INSPECT TABLE t_virtual WITH OPTIONS INDEX (idx_c3);

-- Test 65: query (line 328)
SELECT * FROM last_inspect_job;

-- Test 66: statement (line 334)
CREATE TABLE t_multi_virtual (
    c1 INT,
    c2 INT AS (c1 + 1) VIRTUAL,
    c3 INT AS (c1 * 2) VIRTUAL,
    c4 INT,
    INDEX idx_virtual_combo (c2, c3),
    INDEX idx_regular (c4)
);

-- Test 67: statement (line 344)
INSERT INTO t_multi_virtual (c1, c4) VALUES (1, 100);

-- Test 68: query (line 351)
SELECT * FROM last_inspect_job;

-- Test 69: statement (line 357)
INSPECT TABLE t_multi_virtual WITH OPTIONS INDEX (idx_virtual_combo);

-- Test 70: statement (line 360)
DROP TABLE t_virtual;

-- Test 71: statement (line 363)
DROP TABLE t_multi_virtual;

-- Test 72: statement (line 370)
CREATE DATABASE dbfoo;
CREATE TABLE dbfoo.public.t2 (c1 INT, INDEX idx_c1 (c1));
CREATE TABLE dbfoo.public.t1 (c1 INT, INDEX idx_c1 (c1));

-- Test 73: statement (line 376)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (t1@idx_c1);

-- Test 74: statement (line 379)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (t2@idx_c1);

-- Test 75: statement (line 382)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (public.t1@idx_c1);

-- Test 76: statement (line 385)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (dbfoo.t1@idx_c1);

-- Test 77: statement (line 388)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (dbfoo.t2@idx_c1);

-- Test 78: statement (line 391)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (dbfoo.public.t1@idx_c1);

-- Test 79: statement (line 394)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (idx_c1);

-- Test 80: statement (line 397)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (public.idx_c1);

-- Test 81: statement (line 400)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (dbfoo.idx_c1);

-- Test 82: statement (line 403)
INSPECT DATABASE dbfoo WITH OPTIONS INDEX (dbfoo.public.idx_c1);

-- Test 83: statement (line 406)
DROP DATABASE dbfoo;

-- Test 84: statement (line 411)
CREATE DATABASE ambiguous;
CREATE SCHEMA ambiguous.ambiguous;
CREATE TABLE ambiguous.ambiguous.t1 (c1 INT, INDEX idx_c1 (c1));

-- Test 85: statement (line 417)
INSPECT DATABASE ambiguous WITH OPTIONS INDEX (ambiguous.idx_c1);

-- Test 86: statement (line 420)
DROP DATABASE ambiguous;

-- Test 87: statement (line 428)
CREATE DATABASE dbfoo;
CREATE DATABASE dbbar;
CREATE SCHEMA dbfoo.s1;
CREATE TABLE dbfoo.public.t1 (c1 INT, INDEX idx_c1 (c1));
CREATE TABLE dbfoo.s1.t1 (c1 INT, c2 INT, INDEX idx_c1 (c1), INDEX idx_c2 (c2));
CREATE TABLE dbbar.public.t1 (c1 INT, c2 INT, INDEX idx_c1 (c1), INDEX idx_c2 (c2));
CREATE TABLE dbbar.public.t2 (c1 INT, c2 INT, INDEX idx_c1 (c1), INDEX idx_c2 (c2));

-- Test 88: statement (line 439)
INSPECT TABLE dbfoo.t1 WITH OPTIONS INDEX (t1@idx_c1);

-- Test 89: statement (line 442)
INSPECT TABLE dbfoo.t1 WITH OPTIONS INDEX (s1.t1@idx_c1);

-- Test 90: statement (line 445)
INSPECT TABLE dbfoo.t1 WITH OPTIONS INDEX (dbfoo.t1@idx_c1);

-- Test 91: statement (line 448)
INSPECT TABLE dbfoo.t1 WITH OPTIONS INDEX (dbfoo.s1.t1@idx_c1);

-- Test 92: statement (line 451)
INSPECT TABLE dbfoo.t1 WITH OPTIONS INDEX (idx_c1);

-- Test 93: statement (line 454)
INSPECT TABLE dbfoo.t1 WITH OPTIONS INDEX (s1.idx_c1);

-- Test 94: statement (line 457)
INSPECT TABLE dbfoo.t1 WITH OPTIONS INDEX (dbfoo.idx_c1);

-- Test 95: statement (line 460)
INSPECT TABLE dbfoo.t1 WITH OPTIONS INDEX (dbfoo.s1.idx_c1);

-- Test 96: statement (line 463)
INSPECT TABLE dbfoo.s1.t1 WITH OPTIONS INDEX (t1@idx_c1);

-- Test 97: statement (line 466)
INSPECT TABLE dbfoo.s1.t1 WITH OPTIONS INDEX (s1.t1@idx_c1);

-- Test 98: statement (line 469)
INSPECT TABLE dbfoo.s1.t1 WITH OPTIONS INDEX (dbfoo.t1@idx_c1);

-- Test 99: statement (line 472)
INSPECT TABLE dbfoo.s1.t1 WITH OPTIONS INDEX (dbfoo.s1.t1@idx_c1);

-- Test 100: statement (line 475)
INSPECT TABLE dbfoo.s1.t1 WITH OPTIONS INDEX (idx_c1);

-- Test 101: statement (line 478)
INSPECT TABLE dbfoo.s1.t1 WITH OPTIONS INDEX (s1.idx_c1);

-- Test 102: statement (line 481)
INSPECT TABLE dbfoo.s1.t1 WITH OPTIONS INDEX (dbfoo.idx_c1);

-- Test 103: statement (line 484)
INSPECT TABLE dbfoo.s1.t1 WITH OPTIONS INDEX (dbfoo.s1.idx_c1);

-- Test 104: statement (line 489)
DROP DATABASE dbfoo;

-- Test 105: statement (line 496)
CREATE TABLE refcursor_tbl (id INT PRIMARY KEY, a INT, c REFCURSOR, d REFCURSOR[]);

-- Test 106: statement (line 499)
INSERT INTO refcursor_tbl VALUES
  (1, 10, 'cursor1', ARRAY['c1a', 'c1b']::REFCURSOR[]),
  (2, 20, 'cursor2', ARRAY['c2a', 'c2b']::REFCURSOR[]);

-- Test 107: statement (line 506)
CREATE INDEX idx_refcursor ON refcursor_tbl (c);

-- Test 108: statement (line 509)
CREATE INDEX idx_a_c ON refcursor_tbl (a) STORING (c);

-- Test 109: statement (line 512)
CREATE INDEX idx_a_d ON refcursor_tbl (a) STORING (d);

-- Test 110: statement (line 515)
INSPECT TABLE refcursor_tbl WITH OPTIONS INDEX ALL;

-- Test 111: query (line 518)
SELECT * FROM last_inspect_job;

-- Test 112: statement (line 524)
SET CLUSTER SETTING sql.inspect.index_consistency_hash.enabled = false;

-- Test 113: statement (line 527)
INSPECT TABLE refcursor_tbl WITH OPTIONS INDEX ALL;

-- Test 114: query (line 530)
SELECT * FROM last_inspect_job;

-- Test 115: statement (line 536)
SET CLUSTER SETTING sql.inspect.index_consistency_hash.enabled = true;

-- Test 116: statement (line 539)
DROP TABLE refcursor_tbl;

-- Test 117: statement (line 549)
CREATE TABLE t_aost (c1 INT, INDEX idx_c1 (c1));

-- Test 118: statement (line 552)
INSERT INTO t_aost VALUES (1), (2), (3);

-- Test 119: statement (line 564)
DROP TABLE t_aost;

-- Test 120: statement (line 571)
CREATE TABLE tsvector_tbl (
  id INT PRIMARY KEY,
  a INT,
  tsv TSVECTOR NOT NULL,
  INDEX idx_a_tsv (a) STORING (tsv)
);

-- Test 121: statement (line 579)
INSERT INTO tsvector_tbl VALUES
  (1, 10, 'hello world'::TSVECTOR),
  (2, 20, 'foo bar'::TSVECTOR);

-- Test 122: statement (line 585)
SELECT crdb_internal.datums_to_bytes(tsv) FROM tsvector_tbl LIMIT 1;

-- Test 123: statement (line 590)
INSPECT TABLE tsvector_tbl WITH OPTIONS INDEX (idx_a_tsv);

-- Test 124: query (line 593)
SELECT * FROM last_inspect_job;

-- Test 125: statement (line 598)
CREATE TABLE tsquery_tbl (
  id INT PRIMARY KEY,
  a INT,
  tsq TSQUERY NOT NULL,
  INDEX idx_a_tsq (a) STORING (tsq)
);

-- Test 126: statement (line 606)
INSERT INTO tsquery_tbl VALUES
  (1, 10, 'search & term'::TSQUERY),
  (2, 20, 'another | query'::TSQUERY);

-- Test 127: statement (line 612)
SELECT crdb_internal.datums_to_bytes(tsq) FROM tsquery_tbl LIMIT 1;

-- Test 128: statement (line 617)
INSPECT TABLE tsquery_tbl WITH OPTIONS INDEX (idx_a_tsq);

-- Test 129: query (line 620)
SELECT * FROM last_inspect_job;

-- Test 130: statement (line 625)
CREATE TABLE pgvector_tbl (
  id INT PRIMARY KEY,
  a INT,
  vec VECTOR(3) NOT NULL,
  INDEX idx_a_vec (a) STORING (vec)
);

-- Test 131: statement (line 633)
INSERT INTO pgvector_tbl VALUES
  (1, 10, '[1.0, 2.0, 3.0]'::VECTOR(3)),
  (2, 20, '[4.0, 5.0, 6.0]'::VECTOR(3));

-- Test 132: statement (line 639)
SELECT crdb_internal.datums_to_bytes(vec) FROM pgvector_tbl LIMIT 1;

-- Test 133: statement (line 644)
INSPECT TABLE pgvector_tbl WITH OPTIONS INDEX (idx_a_vec);

-- Test 134: query (line 647)
SELECT * FROM last_inspect_job;

-- Test 135: statement (line 653)
CREATE TABLE multi_type_tbl (
  id INT PRIMARY KEY,
  a INT,
  tsv TSVECTOR,
  tsq TSQUERY NOT NULL,
  vec VECTOR(2),
  INDEX idx_a_multi (a) STORING (tsv, tsq, vec)
);

-- Test 136: statement (line 663)
INSERT INTO multi_type_tbl VALUES
  (1, 10, 'word1 word2'::TSVECTOR, 'search'::TSQUERY, '[1.0, 2.0]'::VECTOR(2)),
  (2, 20, NULL, 'query'::TSQUERY, NULL);

-- Test 137: statement (line 669)
SELECT crdb_internal.datums_to_bytes('word1 word2'::TSVECTOR);

-- Test 138: statement (line 672)
SELECT crdb_internal.datums_to_bytes('search'::TSQUERY);

-- Test 139: statement (line 675)
SELECT crdb_internal.datums_to_bytes('[1.0, 2.0]'::VECTOR(2));

-- Test 140: statement (line 680)
INSPECT TABLE multi_type_tbl WITH OPTIONS INDEX (idx_a_multi);

-- Test 141: query (line 683)
SELECT * FROM last_inspect_job;

-- Test 142: statement (line 688)
DROP TABLE tsvector_tbl;

-- Test 143: statement (line 691)
DROP TABLE tsquery_tbl;

-- Test 144: statement (line 694)
DROP TABLE pgvector_tbl;

-- Test 145: statement (line 697)
DROP TABLE multi_type_tbl;

