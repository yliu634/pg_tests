-- PostgreSQL compatible tests from rename_index
-- 36 tests

-- Test 1: statement (line 1)
CREATE TABLE users (
  id    INT PRIMARY KEY,
  name  VARCHAR NOT NULL,
  title VARCHAR,
  INDEX foo (name),
  UNIQUE INDEX bar (id, name)
)

-- Test 2: statement (line 10)
CREATE TABLE users_dupe (
  id    INT PRIMARY KEY,
  name  VARCHAR NOT NULL,
  title VARCHAR,
  INDEX foo (name),
  UNIQUE INDEX bar (id, name)
)

-- Test 3: statement (line 19)
INSERT INTO users VALUES (1, 'tom', 'cat'),(2, 'jerry', 'rat')

-- Test 4: statement (line 22)
INSERT INTO users_dupe VALUES (1, 'tom', 'cat'),(2, 'jerry', 'rat')

-- Test 5: query (line 25)
SHOW INDEXES FROM users

-- Test 6: query (line 37)
SHOW INDEXES FROM users_dupe

-- Test 7: statement (line 49)
ALTER INDEX users@foo RENAME TO bar

-- Test 8: statement (line 52)
ALTER INDEX users@foo RENAME TO ""

-- Test 9: statement (line 55)
ALTER INDEX users@ffo RENAME TO ufo

-- Test 10: statement (line 58)
ALTER INDEX ffo RENAME TO ufo

-- Test 11: statement (line 61)
ALTER INDEX foo RENAME TO ufo

-- Test 12: statement (line 64)
ALTER INDEX IF EXISTS foo RENAME TO ufo

-- Test 13: statement (line 67)
ALTER INDEX IF EXISTS users@ffo RENAME TO ufo

-- Test 14: statement (line 71)
ALTER INDEX IF EXISTS ffo RENAME TO ufo

-- Test 15: statement (line 74)
ALTER INDEX users@foo RENAME TO ufooo

-- Test 16: statement (line 77)
ALTER INDEX IF EXISTS ufooo RENAME TO ufoo

-- Test 17: statement (line 80)
ALTER INDEX ufoo RENAME TO ufo

-- Test 18: query (line 83)
SHOW INDEXES FROM users

-- Test 19: statement (line 97)
ALTER INDEX users@bar RENAME TO rar

user root

-- Test 20: statement (line 102)
GRANT CREATE ON TABLE users TO testuser

user testuser

-- Test 21: statement (line 107)
ALTER INDEX users@bar RENAME TO rar

-- Test 22: query (line 110)
SHOW INDEXES FROM users

-- Test 23: query (line 124)
SELECT * FROM users

-- Test 24: statement (line 133)
ALTER INDEX users@ufo RENAME TO foo

-- Test 25: statement (line 136)
ALTER INDEX users@rar RENAME TO bar

-- Test 26: statement (line 140)
ALTER INDEX users@users_pkey RENAME TO pk

-- Test 27: query (line 143)
SELECT * FROM users@pk

-- Test 28: statement (line 149)
SET vectorize=on

-- Test 29: query (line 152)
EXPLAIN ALTER INDEX users@bar RENAME TO woo

-- Test 30: statement (line 159)
RESET vectorize

-- Test 31: query (line 163)
SELECT DISTINCT index_name FROM [SHOW INDEXES FROM users]

-- Test 32: statement (line 171)
CREATE TABLE t1(a int);

-- Test 33: statement (line 174)
BEGIN;

-- Test 34: statement (line 177)
CREATE INDEX i1 ON t1(a);

-- Test 35: statement (line 180)
ALTER INDEX i1 RENAME TO i2;

-- Test 36: statement (line 183)
COMMIT;

