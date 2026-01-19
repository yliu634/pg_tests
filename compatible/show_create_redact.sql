-- PostgreSQL compatible tests from show_create_redact
-- 38 tests

-- Test 1: statement (line 3)
SET create_table_with_schema_locked=false

-- Test 2: query (line 9)
SHOW CREATE TABLE a WITH REDACT

-- Test 3: statement (line 18)
CREATE TABLE b (b BOOLEAN DEFAULT false)

-- Test 4: query (line 21)
SHOW CREATE TABLE b WITH REDACT

-- Test 5: statement (line 30)
CREATE TABLE c (c CHAR DEFAULT 'c')

-- Test 6: query (line 33)
SHOW CREATE TABLE c WITH REDACT

-- Test 7: statement (line 42)
CREATE TABLE d (d DATE DEFAULT '1999-12-31')

-- Test 8: query (line 45)
SHOW CREATE TABLE d WITH REDACT

-- Test 9: statement (line 54)
CREATE TABLE i (i INT DEFAULT 0)

-- Test 10: query (line 57)
SHOW CREATE TABLE i WITH REDACT

-- Test 11: statement (line 66)
CREATE TABLE j (j JSON DEFAULT '{}')

-- Test 12: query (line 69)
SHOW CREATE j WITH REDACT

-- Test 13: statement (line 78)
CREATE TABLE n (n INT DEFAULT NULL)

-- Test 14: query (line 81)
SHOW CREATE TABLE n WITH REDACT

-- Test 15: statement (line 92)
CREATE TABLE ef (e INT, f INT AS (e + 1) VIRTUAL)

-- Test 16: query (line 95)
SHOW CREATE TABLE ef WITH REDACT

-- Test 17: statement (line 105)
CREATE TABLE g (g GEOMETRY AS ('POINT (0 0)') VIRTUAL)

-- Test 18: query (line 108)
SHOW CREATE TABLE g WITH REDACT

-- Test 19: statement (line 117)
CREATE TABLE hi (h INTERVAL PRIMARY KEY, i INTERVAL AS (h - '12:00:00') STORED, FAMILY (h, i))

-- Test 20: query (line 120)
SHOW CREATE TABLE hi WITH REDACT

-- Test 21: query (line 133)
SHOW CREATE TABLE jk WITH REDACT

-- Test 22: statement (line 147)
CREATE TABLE k (k INT PRIMARY KEY, CHECK (k > 0), CHECK (true))

-- Test 23: query (line 150)
SHOW CREATE k WITH REDACT

-- Test 24: statement (line 160)
CREATE TABLE dl (d DECIMAL PRIMARY KEY, l DECIMAL, CHECK (d != l + 2.0), FAMILY (d, l))

-- Test 25: query (line 163)
SHOW CREATE TABLE dl WITH REDACT

-- Test 26: query (line 179)
SHOW CREATE TABLE m WITH REDACT

-- Test 27: statement (line 189)
CREATE TABLE no (n NUMERIC PRIMARY KEY, o FLOAT, UNIQUE INDEX ((o / 1.1e7)), FAMILY (n, o))

-- Test 28: query (line 192)
SHOW CREATE TABLE no WITH REDACT

-- Test 29: statement (line 205)
CREATE TABLE p (p UUID PRIMARY KEY, INDEX (p) WHERE p != 'acde070d-8c4c-4f0d-9d8a-162843c10333')

-- Test 30: query (line 208)
SHOW CREATE TABLE p WITH REDACT

-- Test 31: statement (line 219)
CREATE VIEW q (q) AS SELECT 0

-- Test 32: query (line 222)
SHOW CREATE VIEW q WITH REDACT

-- Test 33: statement (line 229)
CREATE VIEW r (r) AS SELECT TIMESTAMP '1999-12-31 23:59:59' + i FROM hi WHERE h != '00:00:01'

-- Test 34: query (line 232)
SHOW CREATE VIEW r WITH REDACT

-- Test 35: statement (line 239)
CREATE VIEW s (s) AS SELECT IF(b, 'abc', 'def') FROM b ORDER BY b AND NOT false LIMIT 10

-- Test 36: query (line 242)
SHOW CREATE VIEW s WITH REDACT

-- Test 37: statement (line 256)
CREATE VIEW t (t, u) AS SELECT jk || '[null]', j->a FROM a JOIN jk ON a = k || 'u' ORDER BY concat(a, 'ut')

-- Test 38: query (line 259)
SHOW CREATE VIEW t WITH REDACT

