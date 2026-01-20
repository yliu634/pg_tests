-- PostgreSQL compatible tests from show_source
-- 62 tests

-- Test 1: query (line 3)
SELECT * FROM [SHOW client_encoding]

-- Test 2: query (line 9)
SELECT c.x FROM [SHOW client_encoding] AS c(x)

-- Test 3: query (line 15)
SELECT * FROM [SHOW client_encoding] WITH ORDINALITY

-- Test 4: query (line 23)
SELECT *
FROM [SHOW ALL]
WHERE
  variable NOT IN (
    'optimizer',
    'crdb_version',
    'session_id',
    'distsql_workmem',
    'copy_fast_path_enabled',
    'direct_columnar_scans_enabled',
    'multiple_active_portals_enabled',
    'kv_transaction_buffered_writes_enabled'
  )
ORDER BY variable

-- Test 5: query (line 272)
SELECT * FROM [SHOW CLUSTER SETTING sql.defaults.distsql]

-- Test 6: query (line 278)
SELECT * FROM [SHOW ALL CLUSTER SETTINGS] WHERE variable LIKE 'cluster%label'

-- Test 7: query (line 284)
SELECT * FROM [SHOW CLUSTER SETTINGS] WHERE variable LIKE 'cluster%label'

-- Test 8: query (line 289)
SELECT * FROM [SHOW PUBLIC CLUSTER SETTINGS] WHERE variable LIKE 'cluster%label'

-- Test 9: query (line 294)
SELECT * FROM [SHOW SESSION_USER]

-- Test 10: query (line 300)
SELECT * FROM [SHOW DATABASE]

-- Test 11: query (line 316)
SHOW DATABASES

-- Test 12: query (line 325)
SELECT * FROM [SHOW GRANTS ON system.descriptor]

-- Test 13: query (line 332)
SELECT * FROM [SHOW INDEX FROM system.descriptor]

-- Test 14: query (line 339)
SELECT * FROM [SHOW CONSTRAINT FROM system.descriptor]

-- Test 15: query (line 345)
SELECT * FROM [SHOW KEYS FROM system.descriptor]

-- Test 16: query (line 352)
SELECT * FROM [SHOW SCHEMAS FROM system]

-- Test 17: query (line 362)
SELECT * FROM [SHOW SEQUENCES FROM system]

-- Test 18: query (line 370)
SELECT schema_name, table_name, type, owner, locality FROM [SHOW TABLES FROM system]
WHERE table_name IN ('descriptor_id_seq', 'comments', 'locations')
ORDER BY schema_name, table_name

-- Test 19: query (line 380)
SELECT schema_name, table_name, type, owner, locality, comment FROM [SHOW TABLES FROM system WITH COMMENT]
WHERE table_name IN ('comments', 'locations', 'descriptor_id_seq')
ORDER BY schema_name, table_name

-- Test 20: query (line 390)
SELECT node_id, user_name, application_name, active_queries
  FROM [SHOW SESSIONS]
 WHERE active_queries != ''

-- Test 21: query (line 401)
SELECT trace_id > 0 AS has_trace_id FROM [SHOW SESSIONS] WHERE active_queries != ''

-- Test 22: query (line 410)
SELECT trace_id > 0 AS has_trace_id FROM [SHOW SESSIONS] WHERE active_queries != ''

-- Test 23: query (line 419)
SELECT goroutine_id > 0 AS has_goroutine_id FROM [SHOW SESSIONS] WHERE active_queries != ''

-- Test 24: query (line 425)
SELECT node_id, user_name, query FROM [SHOW QUERIES]

-- Test 25: query (line 431)
SELECT node_id, user_name, query FROM [SHOW STATEMENTS]

-- Test 26: query (line 437)
SELECT * FROM [SHOW SCHEMAS]

-- Test 27: query (line 447)
CREATE TABLE foo(x INT); SELECT * FROM [SHOW TABLES]

-- Test 28: query (line 454)
SELECT * FROM [SHOW TIMEZONE]

-- Test 29: query (line 461)
SELECT * FROM [SHOW TIME ZONE]

-- Test 30: query (line 468)
SELECT * FROM [SHOW TRANSACTION ISOLATION LEVEL]

-- Test 31: query (line 475)
SELECT * FROM [SHOW TRANSACTION PRIORITY]

-- Test 32: query (line 481)
SELECT * FROM [SHOW TRANSACTION STATUS]

-- Test 33: query (line 488)
SELECT * FROM [SHOW CREATE TABLE system.descriptor]

-- Test 34: query (line 500)
CREATE VIEW v AS SELECT id FROM system.descriptor; SELECT * FROM [SHOW CREATE VIEW v]

-- Test 35: query (line 509)
SELECT username,options,member_of FROM [SHOW USERS] ORDER BY 1

-- Test 36: statement (line 530)
CREATE INDEX ix ON foo(x)

-- Test 37: query (line 544)
SELECT * FROM [SHOW COMPACT TRACE FOR SESSION] LIMIT 0

-- Test 38: query (line 554)
SELECT * FROM [SHOW SYNTAX 'select 1; select 2']
ORDER BY message

-- Test 39: query (line 564)
SELECT field, replace(message, e'\n', ' ') AS message FROM [SHOW SYNTAX 'foo']
WHERE field != 'line'
ORDER BY field

-- Test 40: statement (line 577)
SELECT * FROM [SHOW TRANSFER STATE]

-- Test 41: statement (line 580)
SELECT * FROM [SHOW TRANSFER STATE WITH 'foo-bar']

-- Test 42: statement (line 584)
CREATE DATABASE showdbindexestest;

-- Test 43: statement (line 587)
CREATE TABLE showdbindexestest.table1 (key1 INT PRIMARY KEY);

-- Test 44: statement (line 590)
CREATE TABLE showdbindexestest.table2 (key2 INT PRIMARY KEY);

-- Test 45: query (line 593)
SHOW INDEXES FROM DATABASE showdbindexestest;

-- Test 46: statement (line 599)
CREATE DATABASE "$peci@l";

-- Test 47: statement (line 602)
CREATE TABLE "$peci@l".table1 (key1 INT PRIMARY KEY);

-- Test 48: statement (line 605)
CREATE TABLE "$peci@l".table2 (key2 INT PRIMARY KEY);

-- Test 49: query (line 608)
SHOW INDEXES FROM DATABASE "$peci@l";

-- Test 50: query (line 620)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name='sql.show.locality' AND usage_count > 0

-- Test 51: statement (line 626)
CREATE TABLE show_test (x INT PRIMARY KEY);
SHOW INDEXES FROM show_test

-- Test 52: query (line 630)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name='sql.show.indexes' AND usage_count > 0

-- Test 53: statement (line 636)
SHOW CONSTRAINTS FROM show_test

-- Test 54: query (line 639)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name='sql.show.constraints' AND usage_count > 0

-- Test 55: statement (line 645)
SHOW QUERIES

-- Test 56: query (line 648)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name='sql.show.queries' AND usage_count > 0

-- Test 57: query (line 657)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name='sql.show.jobs' AND usage_count > 0

-- Test 58: statement (line 665)
CREATE TABLE t (
  x INT,
  y INT,
  z INT,
  INDEX i1 (x),
  INDEX i2 (y),
  INDEX i3 (z)
); CREATE TABLE t2 (
  x INT,
  y INT,
  z INT,
  INDEX i1 (x),
  INDEX i2 (y),
  INDEX i3 (z)
); COMMENT ON COLUMN t.x IS 'comment1';
COMMENT ON COLUMN t.z IS 'comm"en"t2';
COMMENT ON INDEX t@i2 IS 'comm''ent3'

-- Test 59: query (line 684)
SHOW INDEXES FROM t WITH COMMENT

-- Test 60: query (line 698)
SHOW INDEXES FROM t2 WITH COMMENT

-- Test 61: statement (line 714)
SET TIME ZONE 'EST'

-- Test 62: statement (line 727)
RESET TIME ZONE

