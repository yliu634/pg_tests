-- PostgreSQL compatible tests from trigram_indexes
-- 69 tests

-- Test 1: statement (line 2)
CREATE TABLE a (a INT PRIMARY KEY, t TEXT)

-- Test 2: statement (line 5)
CREATE INVERTED INDEX ON a(t)

-- Test 3: statement (line 8)
CREATE INDEX ON a USING GIN(t)

-- Test 4: statement (line 11)
CREATE INDEX ON a (t gin_trgm_ops)

-- Test 5: statement (line 14)
CREATE INVERTED INDEX ON a (a gin_trgm_ops, t gin_trgm_ops)

-- Test 6: statement (line 17)
CREATE INVERTED INDEX ON a(t blah_ops)

-- Test 7: statement (line 20)
CREATE INVERTED INDEX ON a(t gin_trgm_ops)

-- Test 8: statement (line 23)
CREATE INDEX ON a USING GIN(t gin_trgm_ops)

-- Test 9: statement (line 27)
CREATE INDEX ON a USING GIST(t gist_trgm_ops)

-- Test 10: statement (line 30)
INSERT INTO a VALUES (1, 'foozoopa'),
                     (2, 'Foo'),
                     (3, 'blah'),
                     (4, 'Приветhi')

-- Test 11: query (line 36)
SELECT * FROM a@a_t_idx WHERE t ILIKE '%Foo%'

-- Test 12: query (line 42)
SELECT * FROM a@a_t_idx WHERE t LIKE '%Foo%'

-- Test 13: query (line 47)
SELECT * FROM a@a_t_idx WHERE t LIKE 'Foo%'

-- Test 14: query (line 52)
SELECT * FROM a@a_t_idx WHERE t LIKE '%Foo'

-- Test 15: query (line 57)
SELECT * FROM a@a_t_idx WHERE t LIKE '%foo%oop%'

-- Test 16: query (line 62)
SELECT * FROM a@a_t_idx WHERE t LIKE '%fooz%'

-- Test 17: query (line 67)
SELECT * FROM a@a_t_idx WHERE t LIKE '%foo%oop'

-- Test 18: query (line 71)
SELECT * FROM a@a_t_idx WHERE t LIKE 'zoo'

-- Test 19: query (line 75)
SELECT * FROM a@a_t_idx WHERE t LIKE '%foo%oop%' OR t ILIKE 'blah' ORDER BY a

-- Test 20: query (line 81)
SELECT * FROM a@a_t_idx WHERE t LIKE 'blahf'

-- Test 21: query (line 85)
SELECT * FROM a@a_t_idx WHERE t LIKE 'fblah'

-- Test 22: query (line 89)
SELECT * FROM a@a_t_idx WHERE t LIKE 'Приветhi'

-- Test 23: query (line 94)
SELECT * FROM a@a_t_idx WHERE t LIKE 'Привет%'

-- Test 24: query (line 99)
SELECT * FROM a@a_t_idx WHERE t LIKE 'Приве%'

-- Test 25: query (line 104)
SELECT * FROM a@a_t_idx WHERE t LIKE '%иве%'

-- Test 26: query (line 109)
SELECT * FROM a@a_t_idx WHERE t LIKE '%тhi%'

-- Test 27: query (line 116)
SELECT similarity(t, 'blar'), * FROM a@a_t_idx WHERE t % 'blar'

-- Test 28: query (line 121)
SELECT similarity(t, 'byar'), * FROM a@a_t_idx WHERE t % 'byar'

-- Test 29: query (line 125)
SELECT similarity(t, 'fooz'), * FROM a@a_t_idx WHERE t % 'fooz' ORDER BY a

-- Test 30: query (line 131)
SELECT similarity(t, 'fo'), * FROM a@a_t_idx WHERE t % 'fo' ORDER BY a

-- Test 31: statement (line 136)
SET pg_trgm.similarity_threshold=.45

-- Test 32: query (line 139)
SELECT similarity(t, 'fooz'), * FROM a@a_t_idx WHERE t % 'fooz'

-- Test 33: statement (line 144)
SET pg_trgm.similarity_threshold=0.1

-- Test 34: query (line 147)
SELECT similarity(t, 'f'), * FROM a@a_t_idx WHERE t % 'f' ORDER BY a

-- Test 35: query (line 154)
SELECT * FROM a@a_t_idx WHERE t = 'Foo'

-- Test 36: query (line 159)
SELECT * FROM a@a_t_idx WHERE t = 'foo'

-- Test 37: query (line 163)
SELECT * FROM a@a_t_idx WHERE t = 'foozoopa'

-- Test 38: query (line 168)
SELECT * FROM a@a_t_idx WHERE t = 'foozoopa' OR t = 'Foo' ORDER BY a

-- Test 39: statement (line 177)
CREATE TABLE pkt (a TEXT PRIMARY KEY); INSERT INTO pkt VALUES ('abcd'), ('bcde')

-- Test 40: statement (line 180)
CREATE INVERTED INDEX ON pkt(a gin_trgm_ops)

-- Test 41: statement (line 186)
DROP TABLE pkt;
CREATE TABLE pkt (a INT PRIMARY KEY, b TEXT NOT NULL, INVERTED INDEX(b gin_trgm_ops));
INSERT INTO pkt VALUES (1, 'abcd'), (2, 'bcde')

-- Test 42: statement (line 191)
ALTER TABLE pkt ALTER PRIMARY KEY USING COLUMNS (b)

-- Test 43: statement (line 198)
CREATE TABLE b (a) AS SELECT encode(set_byte('foobar ',1,g), 'escape') || g::text FROM generate_series(1,1000) g(g)

-- Test 44: statement (line 201)
ANALYZE b

-- Test 45: statement (line 204)
CREATE INVERTED INDEX ON b(a gin_trgm_ops)

-- Test 46: query (line 207)
SELECT * FROM b WHERE a LIKE '%foo%'

-- Test 47: statement (line 217)
ANALYZE b

-- Test 48: query (line 220)
SELECT * FROM b WHERE a LIKE '%foo%'

-- Test 49: statement (line 228)
CREATE INDEX on b(a);
ANALYZE b

-- Test 50: query (line 232)
SELECT * FROM b WHERE a LIKE '%foo%'

-- Test 51: query (line 240)
SELECT * FROM b WHERE a = 'foobar 367'

-- Test 52: statement (line 248)
create table err (a int, index (a jsonb_ops));

-- Test 53: statement (line 251)
create table err (a int, index (a gin_trgm_ops));

-- Test 54: statement (line 254)
create table err (a int, index (a gist_trgm_ops));

-- Test 55: statement (line 257)
create table err (a int, b int, index (a gin_trgm_ops, b));

-- Test 56: statement (line 260)
create table err (a int, j json, inverted index (a gin_trgm_ops, j));

-- Test 57: query (line 270)
SELECT create_statement FROM [SHOW CREATE TABLE t86614]

-- Test 58: query (line 283)
SELECT create_statement FROM [SHOW CREATE TABLE t86614]

-- Test 59: statement (line 297)
CREATE TABLE t88558 (
  a INT PRIMARY KEY,
  b TEXT,
  INVERTED INDEX (b gin_trgm_ops)
);
INSERT INTO t88558 VALUES (1, '%');

-- Test 60: statement (line 312)
CREATE TABLE t89609 (
  t TEXT,
  INVERTED INDEX idx (t gin_trgm_ops)
);
INSERT INTO t89609 VALUES ('aaaaaa');
SET pg_trgm.similarity_threshold=.3

-- Test 61: statement (line 338)
CREATE INVERTED INDEX ON t_112713 (t gin_trgm_ops);

onlyif config schema-locked-disabled

-- Test 62: query (line 342)
SELECT create_statement FROM [SHOW CREATE TABLE t_112713];

-- Test 63: query (line 354)
SELECT create_statement FROM [SHOW CREATE TABLE t_112713];

-- Test 64: statement (line 368)
CREATE TABLE t117758 (
  col1 VARCHAR NOT NULL,
  col2 NAME NOT NULL,
  INVERTED INDEX (col2 gin_trgm_ops)
);
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

-- Test 66: statement (line 402)
SET optimizer_use_trigram_similarity_optimization = false;

-- Test 67: statement (line 405)
SELECT * FROM trigram_similarity_zero_threshold_inverted_index_a@c WHERE b % 'foo';

-- Test 68: statement (line 408)
SET optimizer_use_trigram_similarity_optimization = true;

-- Test 69: statement (line 411)
SELECT * FROM trigram_similarity_zero_threshold_inverted_index_a@c WHERE b % 'foo';

