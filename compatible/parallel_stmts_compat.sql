SET client_min_messages = warning;

-- PostgreSQL compatible tests from parallel_stmts_compat
-- 93 tests
--
-- CockroachDB includes UPSERT and SHOW TRANSACTION STATUS in this test. In
-- PostgreSQL, use INSERT .. ON CONFLICT for upserts and standard transactions.

-- Test 1: statement (setup)
DROP TABLE IF EXISTS fk CASCADE;
DROP TABLE IF EXISTS kv CASCADE;
CREATE TABLE kv (
  k INT PRIMARY KEY,
  v INT CHECK (v < 100)
);
CREATE TABLE fk (
  f INT REFERENCES kv(k)
);

-- Test 2: statement (basic DML)
INSERT INTO kv VALUES (1, 2);
INSERT INTO kv VALUES (2, 3);

-- Test 3: statement (upsert equivalents)
INSERT INTO kv VALUES (2, 4) ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;
INSERT INTO kv VALUES (3, 5) ON CONFLICT (k) DO UPDATE SET v = EXCLUDED.v;

-- Test 4: statement (foreign key references)
INSERT INTO fk VALUES (2);
DELETE FROM fk;
DELETE FROM kv WHERE k = 2;

-- Test 5: statement (transactional batch)
BEGIN;
INSERT INTO kv VALUES (4, 5);
INSERT INTO kv VALUES (5, 6);
COMMIT;

-- Test 6: query
SELECT k, v FROM kv ORDER BY k;

RESET client_min_messages;

