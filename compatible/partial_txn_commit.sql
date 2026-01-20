SET client_min_messages = warning;

-- PostgreSQL compatible tests from partial_txn_commit
-- 12 tests

-- Test 1: statement (line 7)
-- COMMENTED: CockroachDB-specific setting
-- SET create_table_with_schema_locked=false;

-- Test 2: statement (line 10)
-- COMMENTED: CockroachDB-specific setting: SET autocommit_before_ddl = false

-- Test 3: statement (line 13)
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (x INT);

-- Test 4: statement (line 16)
INSERT INTO t (x) VALUES (0);

-- Test 5: statement (line 19)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 6: statement (line 22)
ALTER TABLE t ADD COLUMN z INT DEFAULT 123;

-- Test 7: statement (line 25)
INSERT INTO t (x) VALUES (1);

-- Test 8: statement (line 28)
ALTER TABLE t ADD COLUMN y FLOAT GENERATED ALWAYS AS (1::FLOAT / NULLIF(x, 0)) STORED;

-- Test 9: statement (line 31)
COMMIT;

-- Test 10: query (line 35)
SELECT * FROM t;

-- Test 11: query (line 42)
-- COMMENTED: CockroachDB-only SHOW CREATE.
-- SHOW CREATE t;
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 't'
ORDER BY ordinal_position;

-- Test 12: statement (line 51)
-- COMMENTED: CockroachDB-specific setting: RESET autocommit_before_ddl



RESET client_min_messages;
