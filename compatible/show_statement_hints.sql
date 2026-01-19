-- PostgreSQL compatible tests from show_statement_hints
-- 45 tests

-- Test 1: statement (line 4)
CREATE TABLE xy (x INT PRIMARY KEY, y INT, INDEX (y));

-- Test 2: statement (line 7)
CREATE TABLE ab (a INT PRIMARY KEY, b INT, INDEX (b));

-- Test 3: statement (line 11)
CREATE USER testuser2

-- Test 4: statement (line 17)
SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10'

-- Test 5: statement (line 20)
SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10' WITH DETAILS

user root

-- Test 6: statement (line 25)
GRANT SYSTEM VIEWCLUSTERMETADATA TO testuser2

-- Test 7: query (line 31)
SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10';

-- Test 8: query (line 36)
SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10' WITH DETAILS;

-- Test 9: query (line 44)
SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10';

-- Test 10: query (line 49)
SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10' WITH DETAILS;

-- Test 11: statement (line 54)
SELECT crdb_internal.inject_hint(
  'SELECT * FROM xy WHERE y = _',
  'SELECT * FROM xy@xy_y_idx WHERE y = _'
);

-- Test 12: query (line 62)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10'];

-- Test 13: query (line 70)
SELECT fingerprint, hint_type, details
FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10' WITH DETAILS];

-- Test 14: query (line 78)
SELECT fingerprint, hint_type, details
FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = $1' WITH DETAILS];

-- Test 15: statement (line 85)
SELECT crdb_internal.inject_hint(
  'WITH cte AS (SELECT * FROM xy WHERE y = _) SELECT * FROM cte',
  'WITH cte AS (SELECT * FROM xy@xy_y_idx WHERE y = _) SELECT * FROM cte'
);

-- Test 16: query (line 91)
SELECT fingerprint, hint_type, details
FROM [SHOW STATEMENT HINTS FOR 'WITH cte AS (SELECT * FROM xy WHERE y = 10) SELECT * FROM cte' WITH DETAILS]
ORDER BY created_at DESC, row_id DESC;

-- Test 17: query (line 100)
SHOW STATEMENT HINTS FOR 'SELECT * FROM nonexistent WHERE x = 1';

-- Test 18: statement (line 105)
SELECT crdb_internal.inject_hint(
  'SELECT * FROM xy WHERE y = _',
  'SELECT * FROM xy@primary WHERE y = _'
);

-- Test 19: query (line 111)
SELECT count(*) FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10'];

-- Test 20: query (line 116)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10']
ORDER BY created_at DESC, row_id DESC;

-- Test 21: query (line 124)
SELECT fingerprint, hint_type, details
FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10' WITH DETAILS]
ORDER BY created_at DESC, row_id DESC;

-- Test 22: query (line 134)
SELECT (SELECT count(*) FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM xy WHERE y = 10']);

-- Test 23: query (line 140)
SHOW STATEMENT HINTS FOR 'EXPLAIN SELECT * FROM xy WHERE y = 10'

-- Test 24: query (line 145)
SHOW STATEMENT HINTS FOR 'EXPLAIN ANALYZE SELECT * FROM xy WHERE y = 10'

-- Test 25: query (line 150)
SHOW STATEMENT HINTS FOR 'COPY (SELECT * FROM xy WHERE y = 10) TO STDOUT CSV'

-- Test 26: query (line 155)
SHOW STATEMENT HINTS FOR 'PREPARE p AS SELECT * FROM xy WHERE y = $1'

-- Test 27: statement (line 160)
PREPARE p AS SELECT * FROM xy WHERE y = $1;

-- Test 28: query (line 164)
SHOW STATEMENT HINTS FOR 'EXECUTE p'

-- Test 29: statement (line 171)
SELECT crdb_internal.inject_hint(
  'CREATE INDEX ON xy (y)',
  'CREATE INDEX ON xy (y)'
);

-- Test 30: query (line 177)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR 'CREATE INDEX ON xy (y)']
ORDER BY created_at DESC, row_id DESC;

-- Test 31: statement (line 186)
SELECT crdb_internal.inject_hint(
  'SELECT * FROM ab WHERE a = _',
  'SELECT * FROM ab@primary WHERE a = _'
);

-- Test 32: query (line 192)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM ab WHERE a = 1;']
ORDER BY created_at DESC, row_id DESC;

-- Test 33: query (line 201)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR $$ SELECT * FROM ab WHERE a = 1; $$]
ORDER BY created_at DESC, row_id DESC;

-- Test 34: statement (line 210)
PREPARE show_hints_stmt AS
SELECT fingerprint, hint_type FROM [SHOW STATEMENT HINTS FOR $1] ORDER BY created_at DESC, row_id DESC

-- Test 35: query (line 214)
EXECUTE show_hints_stmt('SELECT * FROM ab WHERE a = 1')

-- Test 36: query (line 221)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR 'select * from ab where a = 1']
ORDER BY created_at DESC, row_id DESC;

-- Test 37: query (line 230)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR 'SeLeCt * FrOm ab WhErE a = 1']
ORDER BY created_at DESC, row_id DESC;

-- Test 38: query (line 239)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR '  SELECT   *   FROM   ab   WHERE   a   =   1  ']
ORDER BY created_at DESC, row_id DESC;

-- Test 39: statement (line 248)
SELECT crdb_internal.inject_hint(
  'SELECT * FROM ab AS t WHERE t.a = _',
  'SELECT * FROM ab@primary t WHERE t.a = _'
);

-- Test 40: query (line 255)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM ab AS t WHERE t.a = 1']
ORDER BY created_at DESC, row_id DESC;

-- Test 41: query (line 264)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM ab t WHERE t.a = 1']
ORDER BY created_at DESC, row_id DESC;

-- Test 42: statement (line 277)
SELECT fingerprint, hint_type
FROM queries, LATERAL (SELECT * FROM [SHOW STATEMENT HINTS FOR q]) AS hints
ORDER BY created_at DESC, row_id DESC;

-- Test 43: statement (line 283)
SELECT fingerprint, hint_type
FROM queries, LATERAL (WITH foo AS MATERIALIZED (SHOW STATEMENT HINTS FOR q) SELECT * FROM foo) AS hints
ORDER BY created_at DESC, row_id DESC;

-- Test 44: statement (line 289)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR upper('select * from ab where a = 1')]
ORDER BY created_at DESC, row_id DESC;

-- Test 45: statement (line 295)
SELECT fingerprint, hint_type
FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM ' || 'ab WHERE a = 1']
ORDER BY created_at DESC, row_id DESC;

