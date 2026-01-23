-- PostgreSQL compatible tests from trigram_indexes
-- 69 tests

CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Test 1: statement (line 2)
CREATE TABLE a (a INT PRIMARY KEY, t TEXT);

-- Test 2: statement (line 5)
CREATE INDEX a_t_idx ON a USING GIN (t gin_trgm_ops);

-- Test 3: statement (line 8)
CREATE INDEX a_t_gin_trgm_idx2 ON a USING GIN (t gin_trgm_ops);

-- Test 4: statement (line 11)
CREATE INDEX a_t_gin_trgm_idx3 ON a USING GIN (t gin_trgm_ops);

-- Test 5: statement (line 14)
CREATE INDEX a_a_t_trgm_idx ON a USING GIN ((a::text) gin_trgm_ops, t gin_trgm_ops);

-- Test 6: statement (line 17)
CREATE INDEX a_t_gin_trgm_idx4 ON a USING GIN (t gin_trgm_ops);

-- Test 7: statement (line 20)
CREATE INDEX a_t_gin_trgm_idx5 ON a USING GIN (t gin_trgm_ops);

-- Test 8: statement (line 23)
CREATE INDEX a_t_gin_trgm_idx6 ON a USING GIN (t gin_trgm_ops);

-- Test 9: statement (line 27)
CREATE INDEX a_t_gist_trgm_idx ON a USING GIST (t gist_trgm_ops);

-- Test 10: statement (line 30)
INSERT INTO a VALUES (1, 'foozoopa'),
                     (2, 'Foo'),
                     (3, 'blah'),
                     (4, 'Приветhi');

-- Test 11: query (line 36)
SELECT * FROM a WHERE t ILIKE '%Foo%' ORDER BY a;

-- Test 12: query (line 42)
SELECT * FROM a WHERE t LIKE '%Foo%' ORDER BY a;

-- Test 13: query (line 47)
SELECT * FROM a WHERE t LIKE 'Foo%' ORDER BY a;

-- Test 14: query (line 52)
SELECT * FROM a WHERE t LIKE '%Foo' ORDER BY a;

-- Test 15: query (line 57)
SELECT * FROM a WHERE t LIKE '%foo%oop%' ORDER BY a;

-- Test 16: query (line 62)
SELECT * FROM a WHERE t LIKE '%fooz%' ORDER BY a;

-- Test 17: query (line 67)
SELECT * FROM a WHERE t LIKE '%foo%oop' ORDER BY a;

-- Test 18: query (line 71)
SELECT * FROM a WHERE t LIKE 'zoo' ORDER BY a;

-- Test 19: query (line 75)
SELECT * FROM a WHERE t LIKE '%foo%oop%' OR t ILIKE 'blah' ORDER BY a;

-- Test 20: query (line 81)
SELECT * FROM a WHERE t LIKE 'blahf' ORDER BY a;

-- Test 21: query (line 85)
SELECT * FROM a WHERE t LIKE 'fblah' ORDER BY a;

-- Test 22: query (line 89)
SELECT * FROM a WHERE t LIKE 'Приветhi' ORDER BY a;

-- Test 23: query (line 94)
SELECT * FROM a WHERE t LIKE 'Привет%' ORDER BY a;

-- Test 24: query (line 99)
SELECT * FROM a WHERE t LIKE 'Приве%' ORDER BY a;

-- Test 25: query (line 104)
SELECT * FROM a WHERE t LIKE '%иве%' ORDER BY a;

-- Test 26: query (line 109)
SELECT * FROM a WHERE t LIKE '%тhi%' ORDER BY a;

-- Test 27: query (line 116)
SELECT similarity(t, 'blar'), * FROM a WHERE t % 'blar' ORDER BY a;

-- Test 28: query (line 121)
SELECT similarity(t, 'byar'), * FROM a WHERE t % 'byar' ORDER BY a;

-- Test 29: query (line 125)
SELECT similarity(t, 'fooz'), * FROM a WHERE t % 'fooz' ORDER BY a;

-- Test 30: query (line 131)
SELECT similarity(t, 'fo'), * FROM a WHERE t % 'fo' ORDER BY a;

-- Test 31: statement (line 136)
SET pg_trgm.similarity_threshold=.45;

-- Test 32: query (line 139)
SELECT similarity(t, 'fooz'), * FROM a WHERE t % 'fooz' ORDER BY a;

-- Test 33: statement (line 144)
SET pg_trgm.similarity_threshold=0.1;

-- Test 34: query (line 147)
SELECT similarity(t, 'f'), * FROM a WHERE t % 'f' ORDER BY a;

-- Test 35: query (line 154)
SELECT * FROM a WHERE t = 'Foo' ORDER BY a;

-- Test 36: query (line 159)
SELECT * FROM a WHERE t = 'foo' ORDER BY a;

-- Test 37: query (line 163)
SELECT * FROM a WHERE t = 'foozoopa' ORDER BY a;

-- Test 38: query (line 168)
SELECT * FROM a WHERE t = 'foozoopa' OR t = 'Foo' ORDER BY a;

-- Test 39: statement (line 177)
CREATE TABLE pkt (a TEXT PRIMARY KEY);
INSERT INTO pkt VALUES ('abcd'), ('bcde');

-- Test 40: statement (line 180)
CREATE INDEX pkt_a_trgm_idx ON pkt USING GIN (a gin_trgm_ops);

-- Test 41: statement (line 186)
DROP TABLE pkt;
CREATE TABLE pkt (a INT PRIMARY KEY, b TEXT NOT NULL);
CREATE INDEX pkt_b_trgm_idx ON pkt USING GIN (b gin_trgm_ops);
INSERT INTO pkt VALUES (1, 'abcd'), (2, 'bcde');

-- Test 42: statement (line 191)
ALTER TABLE pkt DROP CONSTRAINT pkt_pkey;
ALTER TABLE pkt ADD PRIMARY KEY (b);

-- Test 43: statement (line 198)
CREATE TABLE b AS
  SELECT encode(set_byte('foobar '::bytea, 1, (g % 256)), 'escape') || g::text AS a
  FROM generate_series(1,1000) g(g);

-- Test 44: statement (line 201)
ANALYZE b;

-- Test 45: statement (line 204)
CREATE INDEX b_a_trgm_idx ON b USING GIN (a gin_trgm_ops);

-- Test 46: query (line 207)
SELECT * FROM b WHERE a LIKE '%foo%' ORDER BY a;

-- Test 47: statement (line 217)
ANALYZE b;

-- Test 48: query (line 220)
SELECT * FROM b WHERE a LIKE '%foo%' ORDER BY a;

-- Test 49: statement (line 228)
CREATE INDEX b_a_btree_idx ON b(a);
ANALYZE b;

-- Test 50: query (line 232)
SELECT * FROM b WHERE a LIKE '%foo%' ORDER BY a;

-- Test 51: query (line 240)
SELECT * FROM b WHERE a = 'foobar 367';

-- Test 52: statement (line 248)
CREATE TABLE err (a int, b int, j jsonb);

-- Test 53: statement (line 251)
CREATE INDEX err_j_jsonb_idx ON err USING GIN (j jsonb_ops);

-- Test 54: statement (line 254)
CREATE INDEX err_a_gin_trgm_idx ON err USING GIN ((a::text) gin_trgm_ops);

-- Test 55: statement (line 257)
CREATE INDEX err_a_gist_trgm_idx ON err USING GIST ((a::text) gist_trgm_ops);

-- Test 56: statement (line 260)
CREATE INDEX err_a_j_trgm_idx ON err USING GIN ((a::text) gin_trgm_ops, (j::text) gin_trgm_ops);

-- Setup for SHOW CREATE TABLE equivalents.
CREATE TABLE t86614 (a text);
CREATE INDEX t86614_a_trgm_idx ON t86614 USING GIN (a gin_trgm_ops);

-- Test 57: query (line 270)
SELECT pg_get_indexdef(i.indexrelid) AS create_statement
FROM pg_index i
JOIN pg_class t ON t.oid = i.indrelid
WHERE t.relname = 't86614'
ORDER BY create_statement;

-- Test 58: query (line 283)
SELECT pg_get_indexdef(i.indexrelid) AS create_statement
FROM pg_index i
JOIN pg_class t ON t.oid = i.indrelid
WHERE t.relname = 't86614'
ORDER BY create_statement;

-- Test 59: statement (line 297)
CREATE TABLE t88558 (
  a INT PRIMARY KEY,
  b TEXT
);
CREATE INDEX t88558_b_trgm_idx ON t88558 USING GIN (b gin_trgm_ops);
INSERT INTO t88558 VALUES (1, '%');

-- Test 60: statement (line 312)
CREATE TABLE t89609 (
  t TEXT
);
CREATE INDEX t89609_idx ON t89609 USING GIN (t gin_trgm_ops);
INSERT INTO t89609 VALUES ('aaaaaa');
SET pg_trgm.similarity_threshold=.3;

-- Test 61: statement (line 338)
CREATE TABLE t_112713 (t text);
CREATE INDEX t_112713_t_trgm_idx ON t_112713 USING GIN (t gin_trgm_ops);

-- onlyif config schema-locked-disabled

-- Test 62: query (line 342)
SELECT pg_get_indexdef(i.indexrelid) AS create_statement
FROM pg_index i
JOIN pg_class t ON t.oid = i.indrelid
WHERE t.relname = 't_112713'
ORDER BY create_statement;

-- Test 63: query (line 354)
SELECT pg_get_indexdef(i.indexrelid) AS create_statement
FROM pg_index i
JOIN pg_class t ON t.oid = i.indrelid
WHERE t.relname = 't_112713'
ORDER BY create_statement;

-- Test 64: statement (line 368)
CREATE TABLE t117758 (
  col1 VARCHAR NOT NULL,
  col2 NAME NOT NULL
);
CREATE INDEX t117758_col2_trgm_idx ON t117758 USING GIN ((col2::text) gin_trgm_ops);
SELECT
    tab.col1_1
FROM
    t117758 AS tab2
    JOIN (
            SELECT
                'foo'::NAME, 'bar'::NAME
            FROM
                t117758 AS tab3
                JOIN t117758 AS tab4 ON
                        (tab3.col2) = (tab4.col2)
        )
            AS tab (col1_1, col1_2) ON
            (tab2.col1) = (tab.col1_1)
            AND (tab2.col2) = (tab.col1_2);

-- Test 65: statement (line 392)
SET pg_trgm.similarity_threshold =  0;

-- Setup for similarity threshold 0.
CREATE TABLE trigram_similarity_zero_threshold_inverted_index_a (a INT PRIMARY KEY, b TEXT);
CREATE INDEX c ON trigram_similarity_zero_threshold_inverted_index_a USING GIN (b gin_trgm_ops);
INSERT INTO trigram_similarity_zero_threshold_inverted_index_a VALUES (1, 'foo'), (2, 'bar'), (3, '');

-- Test 67: statement (line 405)
SET enable_seqscan = on;
SELECT * FROM trigram_similarity_zero_threshold_inverted_index_a WHERE b % 'foo' ORDER BY a;

-- Test 68: statement (line 408)
SET enable_seqscan = off;

-- Test 69: statement (line 411)
SELECT * FROM trigram_similarity_zero_threshold_inverted_index_a WHERE b % 'foo' ORDER BY a;
