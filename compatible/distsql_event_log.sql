-- PostgreSQL compatible tests from distsql_event_log
-- 7 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS a;
RESET client_min_messages;

-- Test 1: statement (line 8)
-- SET CLUSTER SETTING sql.stats.system_tables_autostats.enabled = FALSE; -- Cockroach-only

-- Test 2: statement (line 12)
-- SET CLUSTER SETTING sql.stats.post_events.enabled = TRUE; -- Cockroach-only

-- Test 3: statement (line 15)
CREATE TABLE a (id INT PRIMARY KEY, x INT, y INT);
CREATE INDEX x_idx ON a (x, y);

-- Test 4: statement (line 18)
-- CREATE STATISTICS s1 ON id FROM a; -- CREATE STATISTICS is Cockroach-specific

-- retry -- test directive

-- Test 5: statement (line 22)
-- CREATE STATISTICS __auto__ FROM a; -- CREATE STATISTICS is Cockroach-specific

-- Test 6: query (line 27)
-- SELECT "reportingID", "info"::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'ApplicationName'
-- FROM system.eventlog
-- WHERE "eventType" = 'create_statistics' AND ("info"::JSONB ->> 'DescriptorID')::INT = 106
-- ORDER BY "timestamp", info; -- system.eventlog is Cockroach-only

-- Test 7: statement (line 36)
SET client_min_messages = warning;
DROP TABLE IF EXISTS a;
RESET client_min_messages;
