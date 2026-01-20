-- PostgreSQL compatible tests from trigram_builtins
-- 15 tests

CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Test 1: query (line 1)
SELECT show_trgm(str) FROM (VALUES
    (''),
    ('a'),
    ('ab'),
    ('abc'),
    ('abcd'),
    ('Приветhi'),
    (NULL)
  ) tbl(str);

-- Test 2: query (line 21)
SELECT show_trgm('dcba');

-- Test 3: query (line 27)
SELECT show_trgm('Foo');

-- Test 4: query (line 33)
SELECT show_trgm('aaaa');

-- Test 5: query (line 39)
SELECT show_trgm('a b,c|d_e3 bl  ');

-- Test 6: query (line 45)
SELECT similarity(a, b) FROM (VALUES
    ('', ''),
    ('foo', ''),
    ('', 'foo'),
    ('foo', NULL),
    (NULL, 'foo'),
    (NULL, NULL),
    ('foo', 'bar'),
    ('foo', 'far'),
    ('foo', 'for'),
    ('foo', 'foo')
  ) tbl(a, b);

-- Test 7: query (line 70)
SELECT similarity(a, b) FROM (VALUES
    ('f', 'bfr'),
    ('foo', 'foobar'),
    ('', 'blah'),
    ('blah', '')
  ) tbl(a, b);

-- Test 8: query (line 83)
SELECT similarity(a, b) FROM (VALUES
    ('FOO', 'foo'),
    ('foobar', 'foo'),
    ('foobar', 'barfoo'),
    ('blorp', 'z')
  ) tbl(a, b);

-- Test 9: query (line 97)
SELECT similarity(a, b) FROM (VALUES
    ('foo', 'foobar'),
    ('foobar', 'foo'),
    ('FOO', 'foo'),
    ('foo', 'FOO'),
    ('blorp', 'z'),
    ('z', 'blorp')
  ) tbl(a, b);

-- Test 10: query (line 114)
SHOW pg_trgm.similarity_threshold;

-- Test 11: query (line 122)
SELECT 'FOO' % 'foo', 'foobar' % 'foo', 'foobar' % 'barfoo', 'blorp' % 'z';

-- Test 12: statement (line 128)
SET pg_trgm.similarity_threshold = .1;

-- Test 13: query (line 131)
SELECT 'FOO' % 'foo', 'foobar' % 'foo', 'foobar' % 'barfoo', 'blorp' % 'z';

-- Test 14: statement (line 137)
SET pg_trgm.similarity_threshold = 1;

-- Test 15: query (line 140)
SELECT 'FOO' % 'foo', 'foobar' % 'foo', 'foobar' % 'barfoo', 'blorp' % 'z';
