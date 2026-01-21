-- PostgreSQL compatible tests from bpchar
-- 6 tests

SET client_min_messages = warning;

-- Test 1: query (line 1)
SELECT 'foo'::BPCHAR;

-- Test 2: statement (line 6)
DROP TABLE IF EXISTS t;
CREATE TABLE t (c BPCHAR PRIMARY KEY);

-- Test 3: statement (line 9)
INSERT INTO t VALUES ('foo'), ('ba'), ('c'), ('foobarbaz');

-- Test 4: query (line 12)
SELECT c FROM t ORDER BY c;

-- Test 5: query (line 21)
SELECT column_name, data_type, udt_name, character_maximum_length
FROM information_schema.columns
WHERE table_name = 't'
ORDER BY ordinal_position;

-- Test 6: query (line 31)
SELECT column_name, data_type, udt_name, character_maximum_length
FROM information_schema.columns
WHERE table_name = 't'
ORDER BY ordinal_position;

RESET client_min_messages;
