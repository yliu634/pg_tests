-- PostgreSQL compatible tests from record
-- 40 tests

-- Test 1: statement (line 2)
CREATE TABLE a(a INT PRIMARY KEY, b TEXT);
INSERT INTO a VALUES(1,'2')

-- Test 2: query (line 12)
SELECT t, t.a, t.b, t.* FROM a AS t

-- Test 3: query (line 18)
SELECT (1, 'foo')::a, ((1, 'foo')::a).b

-- Test 4: query (line 37)
SELECT ('blah', 'blah')::a

# You can resolve types with schemas and dbs attached.
query TT
SELECT (1, 'foo')::public.a, (1, 'foo')::test.public.a

-- Test 5: statement (line 47)
CREATE TABLE implicit_col(d INT, e TEXT, INDEX (e) USING HASH WITH (bucket_count=8))

-- Test 6: query (line 50)
SELECT (1, 'foo')::implicit_col

-- Test 7: query (line 56)
SELECT t::implicit_col, (t::implicit_col).d, (t::implicit_col).e, (t::implicit_col).* FROM a AS t

-- Test 8: statement (line 63)
CREATE TABLE fail (a implicit_col)

-- Test 9: query (line 67)
SELECT 'a'::REGTYPE, 'a'::REGTYPE::INT = 'a'::REGCLASS::INT + 100000

-- Test 10: query (line 75)
SELECT $tabletypeid::REGTYPE::TEXT

-- Test 11: query (line 80)
SELECT pg_typeof((1,3)::a)

-- Test 12: query (line 86)
SELECT ARRAY[(1, 3)::a, (1, 2)::a]

-- Test 13: query (line 92)
SELECT pg_typeof(ARRAY[(1, 3)::a, (1, 2)::a])

-- Test 14: query (line 99)
SELECT pg_typeof(ARRAY[(1, 3)::a, (1, 2)::a])::regtype::oid::regtype

-- Test 15: statement (line 105)
DROP TYPE a

-- Test 16: statement (line 109)
CREATE TYPE e AS ENUM ('a', 'b');
CREATE TABLE b (a INT PRIMARY KEY, e e)

-- Test 17: query (line 113)
SELECT (1, 'a')::b

-- Test 18: statement (line 120)
CREATE TABLE fail (b INT DEFAULT (((1,'a')::b).a))

-- Test 19: statement (line 123)
ALTER TABLE b ADD COLUMN b INT DEFAULT (((1,'a')::b).a)

-- Test 20: statement (line 126)
CREATE TABLE fail (b INT AS (((1,'a')::b).a) VIRTUAL)

-- Test 21: statement (line 129)
ALTER TABLE b ADD COLUMN b INT AS (((1,'a')::b).a) VIRTUAL

-- Test 22: statement (line 132)
CREATE TABLE fail (b INT AS (((1,'a')::b).a) STORED)

-- Test 23: statement (line 135)
ALTER TABLE b ADD COLUMN b INT AS (((1,'a')::b).a) STORED

-- Test 24: statement (line 138)
CREATE TABLE fail (b INT, INDEX(b) WHERE b > (((1,'a')::b).a))

-- Test 25: statement (line 141)
CREATE INDEX ON a(a) WHERE a > (((1,'a')::b).a)

-- Test 26: statement (line 144)
CREATE TABLE fail (b INT, INDEX((b + (((1,'a')::b).a))))

-- Test 27: statement (line 147)
CREATE INDEX ON a((a + (((1,'a')::b).a)))

-- Test 28: statement (line 150)
CREATE VIEW v AS SELECT (1,'a')::b

-- Test 29: statement (line 153)
CREATE VIEW v AS SELECT ((1,'a')::b).a

-- Test 30: query (line 158)
SELECT COALESCE(ARRAY[ROW(1, 2)], '{}')

-- Test 31: query (line 163)
SELECT COALESCE(NULL, '{}'::record[]);

-- Test 32: query (line 168)
SELECT '{"(1, 3)", "(1, 2)"}'::a[]

-- Test 33: query (line 173)
SELECT COALESCE(NULL::a[], '{"(1, 3)", "(1, 2)"}');

-- Test 34: statement (line 178)
CREATE TABLE strings(s TEXT);
INSERT INTO strings VALUES('(1,2)'), ('(5,6)')

-- Test 35: query (line 182)
SELECT s, s::a FROM strings ORDER BY 1

-- Test 36: query (line 188)
SELECT '(1 , 2)'::a

-- Test 37: statement (line 193)
SELECT '()'::a

-- Test 38: statement (line 196)
SELECT s, s::record FROM strings ORDER BY 1

-- Test 39: statement (line 199)
SELECT '()'::record

-- Test 40: statement (line 202)
SELECT '(1,4)'::record

