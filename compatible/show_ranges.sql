-- PostgreSQL compatible tests from show_ranges
-- 27 tests

-- Test 1: query (line 32)
SELECT * FROM [SHOW CLUSTER RANGES] LIMIT 0

-- Test 2: query (line 38)
SELECT start_key, end_key, range_id FROM [SHOW CLUSTER RANGES]
ORDER BY range_id LIMIT 10

-- Test 3: query (line 55)
SELECT * FROM [SHOW CLUSTER RANGES WITH DETAILS] LIMIT 0

-- Test 4: query (line 61)
SELECT * FROM [SHOW CLUSTER RANGES WITH KEYS] LIMIT 0

-- Test 5: query (line 67)
SELECT * FROM [SHOW CLUSTER RANGES WITH DETAILS, KEYS] LIMIT 0

-- Test 6: query (line 72)
SELECT start_key, to_hex(raw_start_key), end_key, to_hex(raw_end_key), range_id, lease_holder FROM [SHOW CLUSTER RANGES WITH DETAILS, KEYS]
ORDER BY range_id LIMIT 10

-- Test 7: query (line 92)
SELECT * FROM [SHOW CLUSTER RANGES WITH TABLES] LIMIT 0

-- Test 8: query (line 97)
SELECT * FROM [SHOW CLUSTER RANGES WITH DETAILS, TABLES] LIMIT 0

-- Test 9: query (line 102)
SELECT * FROM [SHOW CLUSTER RANGES WITH KEYS, TABLES] LIMIT 0

-- Test 10: query (line 109)
SELECT start_key, end_key, range_id, database_name, schema_name, table_name, table_id, table_start_key, to_hex(raw_table_start_key), table_end_key, to_hex(raw_table_end_key)
FROM [SHOW CLUSTER RANGES WITH TABLES, KEYS]
WHERE table_name LIKE 'repl%'
   OR start_key LIKE '/System%'
ORDER BY range_id

-- Test 11: query (line 128)
SELECT * FROM [SHOW CLUSTER RANGES WITH INDEXES] LIMIT 0

-- Test 12: query (line 133)
SELECT * FROM [SHOW CLUSTER RANGES WITH DETAILS, INDEXES] LIMIT 0

-- Test 13: query (line 138)
SELECT * FROM [SHOW CLUSTER RANGES WITH KEYS, INDEXES] LIMIT 0

-- Test 14: query (line 143)
SELECT * FROM [SHOW CLUSTER RANGES WITH DETAILS, KEYS, INDEXES] LIMIT 0

-- Test 15: query (line 150)
SELECT start_key, end_key, range_id, database_name, schema_name, table_name, table_id, index_name, index_id, index_start_key, to_hex(raw_index_start_key), index_end_key, to_hex(raw_index_end_key)
FROM [SHOW CLUSTER RANGES WITH INDEXES, KEYS]
WHERE table_name LIKE 'repl%'
   OR start_key LIKE '/System%'
ORDER BY range_id

-- Test 16: statement (line 188)
SET autocommit_before_ddl = false

-- Test 17: statement (line 196)
RESET autocommit_before_ddl

-- Test 18: query (line 224)
SELECT start_key, end_key, range_id, database_name, schema_name, table_name, table_id, index_name, index_id, index_start_key, index_end_key
FROM [SHOW CLUSTER RANGES WITH INDEXES]
WHERE (database_name = 'system' AND table_name LIKE 'repl%')
   OR (database_name = 'test')
ORDER BY range_id, table_id, index_id

-- Test 19: statement (line 451)
CREATE TABLE v0 (c1 BIT PRIMARY KEY );

-- Test 20: statement (line 454)
SHOW RANGE FROM TABLE v0 FOR ROW ( b'\x68')

-- Test 21: statement (line 474)
SELECT database_name FROM crdb_internal.ranges

-- Test 22: statement (line 477)
SELECT database_name FROM CRDB_INTERNAL."ranges"

-- Test 23: statement (line 480)
SELECT database_name FROM crdb_internal.ranges_no_leases

-- Test 24: statement (line 483)
SELECT table_name FROM crdb_internal.ranges

-- Test 25: statement (line 486)
SELECT table_id FROM crdb_internal.ranges

-- Test 26: statement (line 489)
SELECT schema_name FROM crdb_internal.ranges

-- Test 27: statement (line 492)
SELECT index_name FROM crdb_internal.ranges

