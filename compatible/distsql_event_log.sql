-- PostgreSQL compatible tests from distsql_event_log
-- 7 tests

-- Test 1: statement (line 8)
SET CLUSTER SETTING sql.stats.system_tables_autostats.enabled = FALSE

-- Test 2: statement (line 12)
SET CLUSTER SETTING sql.stats.post_events.enabled = TRUE

-- Test 3: statement (line 15)
CREATE TABLE a (id INT PRIMARY KEY, x INT, y INT, INDEX x_idx (x, y))

-- Test 4: statement (line 18)
CREATE STATISTICS s1 ON id FROM a

retry

-- Test 5: statement (line 22)
CREATE STATISTICS __auto__ FROM a

-- Test 6: query (line 27)
SELECT "reportingID", "info"::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'ApplicationName'
FROM system.eventlog
WHERE "eventType" = 'create_statistics' AND ("info"::JSONB ->> 'DescriptorID')::INT = 106
ORDER BY "timestamp", info

-- Test 7: statement (line 36)
DROP TABLE a

