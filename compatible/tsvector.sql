-- PostgreSQL compatible tests from tsvector
-- 89 tests

-- Test 1: query (line 2)
SELECT 'foo:1,2 bar:3'::tsvector @@ 'foo <-> bar'::tsquery, 'foo <-> bar'::tsquery @@ 'foo:1,2 bar:3'::tsvector

-- Test 2: statement (line 7)
CREATE TABLE a (v tsvector, q tsquery)

-- Test 3: statement (line 10)
INSERT INTO a VALUES('foo:1,2 bar:4B'::tsvector, 'foo <2> bar'::tsquery)

-- Test 4: query (line 13)
SELECT * FROM a

-- Test 5: query (line 18)
SELECT 'foo:1,2 bar:4B'::tsvector @@ 'foo <2> bar'::tsquery, 'foo:1,2 bar:4B' @@ 'foo <-> bar'::tsquery

-- Test 6: query (line 23)
SELECT v @@ 'foo <2> bar'::tsquery, v @@ 'foo <-> bar'::tsquery FROM a

-- Test 7: query (line 28)
SELECT v @@ q FROM a

-- Test 8: statement (line 35)
CREATE TABLE b (a INT PRIMARY KEY DEFAULT 1, v tsvector DEFAULT 'foo:1' ON UPDATE 'bar:2', v2 tsvector AS (v) STORED, v3 tsvector AS (v) VIRTUAL)

-- Test 9: statement (line 38)
CREATE TABLE c (a INT PRIMARY KEY DEFAULT 1, q tsquery DEFAULT 'foo' ON UPDATE 'bar', q2 tsquery AS (q) STORED, q3 tsquery AS (q) VIRTUAL)

-- Test 10: statement (line 41)
INSERT INTO b DEFAULT VALUES

-- Test 11: statement (line 44)
INSERT INTO c DEFAULT VALUES

-- Test 12: query (line 47)
SELECT * FROM b

-- Test 13: query (line 52)
SELECT * FROM c

-- Test 14: statement (line 57)
UPDATE b SET a = 2 WHERE a = 1

-- Test 15: statement (line 60)
UPDATE c SET a = 2 WHERE a = 1

-- Test 16: query (line 63)
SELECT * FROM b

-- Test 17: query (line 68)
SELECT * FROM c

-- Test 18: statement (line 73)
INSERT INTO b VALUES (3, 'foo:1,5 zoop:3')

-- Test 19: statement (line 76)
SELECT * FROM b ORDER BY v

-- Test 20: statement (line 79)
SELECT * FROM c ORDER BY q

-- Test 21: statement (line 82)
CREATE TABLE tsarray(a tsvector[])

-- Test 22: statement (line 85)
CREATE TABLE tsarray(a tsquery[])

-- Test 23: statement (line 88)
SELECT a, v FROM b WHERE v > 'bar:2'::tsvector

-- Test 24: statement (line 91)
SELECT a, q FROM c WHERE q > 'abc'::tsquery

-- Test 25: query (line 94)
SELECT a, v FROM b WHERE v = 'bar:2'::tsvector

-- Test 26: query (line 99)
SELECT a, q FROM c WHERE q = 'bar'::tsquery

-- Test 27: query (line 105)
SELECT ('foo:' || string_agg(g::TEXT,','))::tsvector from generate_series(1,280) g(g);

-- Test 28: query (line 111)
SELECT 'foo:293847298347'::tsvector

-- Test 29: query (line 139)
VALUES ( json_build_array($$'cat' & 'rat'$$:::TSQUERY)::JSONB)

-- Test 30: statement (line 145)
DROP TABLE a;
CREATE TABLE a (
  a TSVECTOR,
  b TSQUERY,
  INVERTED INDEX(a)
);
INSERT INTO a VALUES('foo:3 bar:4,5'), ('baz:1'), ('foo:3'), ('bar:2')

-- Test 31: query (line 154)
SELECT a FROM a@a_a_idx WHERE a @@ 'foo'

-- Test 32: statement (line 160)
SELECT a FROM a@a_a_idx WHERE a @@ '!foo'

-- Test 33: query (line 163)
SELECT a FROM a@a_a_idx WHERE a @@ 'foo' OR a @@ 'bar'

-- Test 34: query (line 170)
SELECT a FROM a@a_a_idx WHERE a @@ 'foo | bar'

-- Test 35: query (line 177)
SELECT a FROM a@a_a_idx WHERE a @@ 'foo | bar' OR a @@ 'baz'

-- Test 36: query (line 185)
SELECT a FROM a@a_a_idx WHERE a @@ 'foo & bar'

-- Test 37: query (line 190)
SELECT a FROM a@a_a_idx WHERE a @@ 'foo <-> bar'

-- Test 38: query (line 195)
SELECT a FROM a@a_a_idx WHERE a @@ 'bar <-> foo'

-- Test 39: query (line 199)
SELECT a FROM a@a_a_idx WHERE a @@ 'foo <-> !bar'

-- Test 40: query (line 204)
SELECT a FROM a@a_a_idx WHERE a @@ '!baz <-> bar'

-- Test 41: query (line 210)
SELECT a FROM a@a_a_idx WHERE a @@ 'foo & !bar'

-- Test 42: query (line 215)
SELECT a FROM a@a_a_idx WHERE a @@ 'ba:*'

-- Test 43: query (line 222)
SELECT a FROM a@a_a_idx WHERE a @@ 'ba:* | foo'

-- Test 44: query (line 230)
SELECT a FROM a@a_a_idx WHERE a @@ 'ba:* & foo'

-- Test 45: statement (line 237)
EXPLAIN SELECT * FROM a@a_a_idx WHERE a @@ b

-- Test 46: statement (line 241)
CREATE TABLE t95680 (c1 FLOAT NOT NULL, c2 TSVECTOR NOT NULL, INVERTED INDEX (c1 ASC, c2 ASC));
INSERT INTO t95680 VALUES (1.0::FLOAT, e'\'kCrLZNl\' \'sVDj\' \'yO\' \'z\':54C,440B,519C,794B':::TSVECTOR);

-- Test 47: query (line 246)
SELECT * FROM ts_parse('default', 'Hello this is a parsi-ng t.est 1.234 4 case324')

-- Test 48: query (line 262)
SELECT * FROM to_tsvector('simple', 'Hello this is a parsi-ng t.est 1.234 4 case324')

-- Test 49: query (line 267)
SELECT * FROM phraseto_tsquery('simple', 'Hello this is a parsi-ng t.est 1.234 4 case324')

-- Test 50: query (line 273)
SELECT phraseto_tsquery('No hardcoded configuration')

-- Test 51: query (line 278)
SELECT plainto_tsquery('No hardcoded configuration')

-- Test 52: query (line 283)
SELECT to_tsquery('No | hardcoded | configuration')

-- Test 53: query (line 288)
SELECT * FROM to_tsquery('simple', 'a | b & c <-> d')

-- Test 54: query (line 293)
SELECT * FROM to_tsquery('simple', 'Hello this is a parsi-ng t.est 1.234 4 case324')

# Test default variants of the to_ts* functions.

query T
SHOW default_text_search_config

-- Test 55: query (line 303)
SELECT to_tsvector('Hello I am a potato')

-- Test 56: statement (line 308)
SET default_text_search_config = 'blah'

-- Test 57: statement (line 311)
SET default_text_search_config = 'spanish'

-- Test 58: query (line 314)
SELECT to_tsvector('Hello I am a potato')

-- Test 59: query (line 319)
SELECT to_tsvector('english', ''), to_tsvector('english', 'and the')

-- Test 60: statement (line 324)
SELECT to_tsquery('english', 'the')

-- Test 61: statement (line 327)
CREATE TABLE sentences (sentence text, v TSVECTOR AS (to_tsvector('english', sentence)) STORED, INVERTED INDEX (v));
INSERT INTO sentences VALUES
  ('Future users of large data banks must be protected from having to know how the data is organized in the machine (the internal representation).'),
  ('A prompting service which supplies such information is not a satisfactory solution.'),
  ('Activities of users at terminals and most application programs should remain unaffected when the internal representation of data is changed and even when some aspects of the external representation
  are changed.'),
  ('Changes in data representation will often be needed as a result of changes in query, update, and report traffic and natural growth in the types of stored information.'),
  ('Existing noninferential, formatted data systems provide users with tree-structured files or slightly more general network models of the data.'),
  ('In Section 1, inadequacies of these models are discussed.'),
  ('A model based on n-ary relations, a normal form for data base relations, and the concept of a universal data sublanguage are introduced.'),
  ('In Section 2, certain operations on relations (other than logical inference) are discussed and applied to the problems of redundancy and consistency in the user’s model.')

-- Test 62: query (line 340)
SELECT
ts_rank(v, query) AS rank,
ts_rank(ARRAY[0.2, 0.3, 0.5, 0.9]:::FLOAT[], v, query) AS wrank,
ts_rank(v, query, 2|8) AS nrank,
ts_rank(ARRAY[0.3, 0.4, 0.6, 0.95]:::FLOAT[], v, query, 1|2|4|8|16|32) AS wnrank,
v
FROM sentences, to_tsquery('english', 'relation') query
WHERE query @@ v
ORDER BY rank DESC
LIMIT 10

-- Test 63: query (line 357)
SELECT
	ts_rank(ARRAY[1.0039,2.37098,-0.022,0.4277,0.00387]::FLOAT8[], '''AoS'' ''HXfAX'' ''HeWdr'' ''MIHLoJM'' ''UfIQOM'' ''bw'' ''o'''::TSVECTOR, '''QqJVCgwp'''::TSQUERY)
LIMIT
	2

-- Test 64: statement (line 367)
RESET default_text_search_config

-- Test 65: statement (line 370)
CREATE TABLE ab (a TEXT, b TEXT)

-- Test 66: statement (line 373)
INSERT INTO ab VALUES('fat rats', 'fat cats chased fat, out of shape rats');

-- Test 67: query (line 376)
SELECT a @@ b FROM ab

-- Test 68: query (line 381)
SELECT b @@ a FROM ab

-- Test 69: query (line 386)
SELECT 'fat rats' @@ b FROM ab

-- Test 70: query (line 391)
SELECT b @@ 'fat rats' FROM ab

-- Test 71: query (line 396)
SELECT a @@ 'fat cats ate fat bats' FROM ab

-- Test 72: query (line 401)
SELECT 'fat cats ate fat bats' @@ a FROM ab

-- Test 73: statement (line 406)
SELECT b @@ a::tsvector FROM ab

-- Test 74: statement (line 409)
SELECT a::tsvector @@ b FROM ab

-- Test 75: query (line 412)
SELECT 'fat bat cat' @@ 'bats fats'

-- Test 76: query (line 417)
SELECT 'bats fats' @@ 'fat bat cat'

-- Test 77: query (line 422)
SELECT 'fat' @@ 'fat rats'::tsvector

-- Test 78: statement (line 428)
SELECT 'fat cats chased fat, out of shape rats' @@ 'fat rats'::tsvector

-- Test 79: query (line 431)
SELECT 'fat rats'::tsvector @@ 'fat'

-- Test 80: statement (line 437)
SELECT 'fat rats'::tsvector @@ 'fat cats chased fat, out of shape rats'

-- Test 81: query (line 442)
WITH cte1 AS (SELECT * FROM (VALUES
  (('1':::TSQUERY, 1)),
  (('2':::TSQUERY, 2))
) AS tab (col1))
SELECT * FROM cte1 GROUP BY cte1.col1;

-- Test 82: query (line 452)
WITH cte1 AS (SELECT * FROM (VALUES
  (('':::TSVECTOR, 1)),
  (('':::TSVECTOR, 2))
) AS tab (col1))
SELECT * FROM cte1 GROUP BY cte1.col1;

-- Test 83: statement (line 483)
SET distsql_workmem = '2B';
SET vectorize = off;

-- Test 84: statement (line 487)
WITH cte (col) AS (VALUES ('foo':::TSQUERY), ('bar':::TSQUERY))
SELECT count(*) FROM cte AS cte1 JOIN cte AS cte2 ON cte1.col = cte2.col;

-- Test 85: statement (line 491)
RESET vectorize;
RESET distsql_workmem;

-- Test 86: statement (line 497)
CREATE TABLE t126773 (pk INT PRIMARY KEY, v TSVECTOR);

-- Test 87: statement (line 500)
INSERT INTO t126773 (pk, v) values (1, tsvector('splendid water fowl'));

-- Test 88: statement (line 503)
SELECT t126773::t126773 FROM t126773;

-- Test 89: query (line 508)
WITH cte(s) AS (SELECT NULL::TSQUERY) SELECT a FROM a, cte WHERE a @@ s;

