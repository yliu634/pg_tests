-- PostgreSQL compatible tests from canary_stats
-- 22 tests

SET client_min_messages = warning;

-- Test 1: statement (line 3)
DROP TABLE IF EXISTS canary_table;

-- Test 2: statement (line 7)
-- CRDB-only setting; in PG treat as a custom GUC (no-op).
SET crdb.create_table_with_schema_locked = false;

-- Test 3: statement (line 10)
CREATE TABLE canary_table (x int primary key, y int);
INSERT INTO canary_table VALUES (1, 1);

-- Test 4: query (line 14)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'canary_table'
ORDER BY ordinal_position;

-- Test 5: statement (line 27)
-- CRDB-only table option; use a harmless PG reloption instead.
ALTER TABLE canary_table SET (fillfactor = 100);

-- Test 6: query (line 30)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'canary_table'
ORDER BY ordinal_position;

-- Test 7: statement (line 53)
SET sql.stats.canary_fraction = '0';

-- Test 8: statement (line 59)
SELECT * FROM canary_table ORDER BY x;

-- Test 9: statement (line 109)
SELECT * FROM canary_table ORDER BY x;

-- Test 10: statement (line 122)
SET sql.stats.canary_fraction = '0.0';

-- Test 11: statement (line 128)
SELECT * FROM canary_table ORDER BY x;

-- Test 12: query (line 138)
-- subtest end
-- subtest prepared_statements
SET sql.stats.canary_fraction = '1.0';
PREPARE p1(int) AS SELECT * FROM canary_table WHERE x = $1;
EXECUTE p1(1);

-- Test 13: statement (line 156)
PREPARE p2 AS SELECT * FROM canary_table WHERE x = 1;

-- Test 14: query (line 159)
EXECUTE p2;

-- Test 15: statement (line 164)
SET sql.stats.canary_fraction = '0';

-- Test 16: statement (line 171)
DEALLOCATE ALL;

-- Test 17: statement (line 174)
-- CRDB internal API; closest PG analogue is to discard cached plans.
DISCARD PLANS;

-- Test 18: statement (line 181)
PREPARE p1 AS SELECT * from canary_table;
PREPARE p2 AS SELECT * from canary_table;
PREPARE p3 AS SELECT * from canary_table WHERE x = $1;
PREPARE p4 AS SELECT * from canary_table WHERE x = $1;

-- Test 19: statement (line 226)
SET sql.stats.canary_fraction = '1.0';

-- Test 20: statement (line 236)
PREPARE p5 AS SELECT * from canary_table;
PREPARE p6 AS SELECT * from canary_table WHERE x = $1;
PREPARE p7 AS SELECT * from canary_table WHERE y = $1;
PREPARE p8 AS SELECT * from canary_table WHERE y = $1;

-- Test 21: statement (line 291)
SET sql.stats.canary_fraction = '0';

-- Test 22: statement (line 297)
EXECUTE p7(1);
EXECUTE p7(1);
EXECUTE p8(1);
EXECUTE p8(1);

RESET client_min_messages;
