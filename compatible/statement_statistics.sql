-- PostgreSQL compatible tests from statement_statistics
-- 70 tests

-- Test 1: statement (line 5)
SET CLUSTER SETTING sql.stats.flush.enabled = false;

-- Test 2: statement (line 10)
SET application_name = hello

-- Test 3: statement (line 13)
SELECT 1

-- Test 4: statement (line 16)
SET application_name = world

-- Test 5: statement (line 19)
SELECT 2

-- Test 6: statement (line 22)
RESET application_name

-- Test 7: query (line 25)
SELECT count > 0 FROM crdb_internal.node_statement_statistics WHERE application_name IN ('hello', 'world')

-- Test 8: statement (line 35)
SET application_name = hello;

-- Test 9: statement (line 38)
SELECT 1

-- Test 10: statement (line 41)
SELECT 1,2

-- Test 11: statement (line 44)
SELECT 1

-- Test 12: statement (line 48)
SET application_name = ''

-- Test 13: query (line 51)
SELECT key, count >= 1 FROM crdb_internal.node_statement_statistics WHERE application_name = 'hello' AND key LIKE 'SELECT%' ORDER BY key

-- Test 14: statement (line 59)
SET application_name = multi_stmts_test;

-- Test 15: statement (line 62)
select 1, 2; select 1, 2, 3; select 'ok'

-- Test 16: statement (line 65)
SET application_name = ''

-- Test 17: query (line 68)
SELECT statement_id, txn_fingerprint_id, key, implicit_txn FROM crdb_internal.node_statement_statistics WHERE application_name = 'multi_stmts_test' ORDER BY key, txn_fingerprint_id

-- Test 18: statement (line 76)
CREATE TABLE test(x INT, y INT, z INT); INSERT INTO test(x, y, z) VALUES (0,0,0);

-- Test 19: statement (line 80)
SET distsql = off

-- Test 20: statement (line 83)
SET application_name = 'valuetest'

-- Test 21: statement (line 88)
SELECT sin(1.23)

-- Test 22: statement (line 92)
SELECT sqrt(-1.0)

-- Test 23: statement (line 97)
SELECT key FROM test.crdb_internal.node_statement_statistics

-- Test 24: statement (line 102)
SELECT x FROM (VALUES (1,2,3), (4,5,6)) AS t(x)

-- Test 25: statement (line 105)
INSERT INTO test VALUES (1, 2, 3), (4, 5, 6)

-- Test 26: statement (line 110)
SELECT x FROM test WHERE y IN (4, 5, 6, 7, 8)

-- Test 27: statement (line 113)
SELECT x FROM test WHERE y NOT IN (4, 5, 6, 7, 8)

-- Test 28: statement (line 118)
SELECT x FROM test WHERE y IN (4, 5, 6+x, 7, 8)

-- Test 29: statement (line 123)
SELECT ROW(1,2,3,4,5) FROM test WHERE FALSE

-- Test 30: statement (line 129)
set distsql = on

-- Test 31: statement (line 132)
SELECT x FROM test WHERE y IN (4, 5, 6, 7, 8)

-- Test 32: statement (line 135)
SELECT x FROM test WHERE y = 1/z

-- Test 33: statement (line 140)
SET CLUSTER SETTING debug.panic_on_failed_assertions.enabled = true;

-- Test 34: statement (line 143)
RESET CLUSTER SETTING debug.panic_on_failed_assertions.enabled

-- Test 35: statement (line 146)
SHOW application_name

-- Test 36: statement (line 149)
SHOW CLUSTER SETTING debug.panic_on_failed_assertions.enabled

-- Test 37: statement (line 152)
SET application_name = '';

-- Test 38: statement (line 155)
RESET distsql

-- Test 39: query (line 158)
SELECT key,flags
FROM test.crdb_internal.node_statement_statistics
WHERE application_name = 'valuetest' ORDER BY key, flags

-- Test 40: query (line 190)
SELECT key,
       service_lat_avg > 0 and service_lat_avg < 10 as svc_ok,
       parse_lat_avg > 0   and parse_lat_avg < 11   as parse_ok,
       plan_lat_avg > 0    and plan_lat_avg < 10    as plan_ok,
       run_lat_avg > 0     and run_lat_avg < 10     as run_ok,
                           overhead_lat_avg < 10    as ovh_ok
  FROM crdb_internal.node_statement_statistics
 WHERE key = 'SELECT _'

-- Test 41: statement (line 208)
SET application_name = 'implicit_txn_test'

-- Test 42: statement (line 211)
BEGIN; SELECT x FROM test where y=1; COMMIT;

-- Test 43: statement (line 215)
select 1; BEGIN; select 1; select 1; COMMIT

-- Test 44: statement (line 218)
BEGIN;
SELECT x, z FROM test;
SELECT x FROM test where y=1;
COMMIT;

-- Test 45: statement (line 224)
SELECT z FROM test where y=2;

-- Test 46: statement (line 227)
SELECT x FROM test where y=1;

-- Test 47: statement (line 230)
RESET application_name

-- Test 48: query (line 233)
SELECT statement_id, txn_fingerprint_id, key, implicit_txn
  FROM crdb_internal.node_statement_statistics
 WHERE application_name = 'implicit_txn_test'
ORDER BY statement_id, key, implicit_txn;

-- Test 49: statement (line 252)
CREATE VIEW txn_fingerprint_view
AS SELECT
  key, statement_ids, count
FROM
  crdb_internal.node_transaction_statistics
WHERE application_name = 'throttle_test'
  AND statement_ids[1] in (
    SELECT
      statement_id
    FROM
      crdb_internal.node_statement_statistics
    WHERE
      key LIKE 'SELECT%'
  )

-- Test 50: statement (line 268)
CREATE VIEW app_stmts_view
AS SELECT statement_id, key, count
FROM crdb_internal.node_statement_statistics
WHERE application_name = 'throttle_test'

-- Test 51: statement (line 274)
SET application_name = throttle_test

-- Test 52: statement (line 278)
BEGIN; SELECT 1; SELECT 1, 2; SELECT 1, 2, 3; COMMIT

-- Test 53: statement (line 282)
RESET application_name

-- Test 54: query (line 286)
SELECT key, count FROM crdb_internal.node_statement_statistics
WHERE application_name = 'throttle_test' AND key LIKE 'SELECT%' ORDER BY key

-- Test 55: statement (line 294)
SET application_name = throttle_test

-- Test 56: statement (line 298)
SET CLUSTER SETTING sql.metrics.max_mem_stmt_fingerprints = 0

-- Test 57: statement (line 301)
SET CLUSTER SETTING sql.metrics.max_mem_txn_fingerprints = 0

-- Test 58: statement (line 309)
BEGIN; SELECT 1; SELECT 1, 3; SELECT 1, 2, 3, 4; COMMIT

-- Test 59: statement (line 314)
BEGIN; SELECT 1; SELECT 1, 3; SELECT 1, 2, 3; COMMIT

-- Test 60: statement (line 317)
RESET application_name

-- Test 61: query (line 320)
SELECT key, count FROM crdb_internal.node_statement_statistics
WHERE application_name = 'throttle_test' AND key LIKE 'SELECT%' ORDER BY key

-- Test 62: statement (line 328)
SET application_name = throttle_test

-- Test 63: statement (line 333)
RESET CLUSTER SETTING sql.metrics.max_mem_stmt_fingerprints

-- Test 64: statement (line 336)
RESET CLUSTER SETTING sql.metrics.max_mem_txn_fingerprints

-- Test 65: statement (line 339)
BEGIN; SELECT 1; SELECT 1, 3; SELECT 1, 2, 3, 4; COMMIT

-- Test 66: statement (line 343)
BEGIN; SELECT count(1) AS wombat1; COMMIT

-- Test 67: statement (line 346)
BEGIN; SELECT count(1) AS wombat2; COMMIT

-- Test 68: statement (line 350)
RESET application_name

-- Test 69: query (line 353)
SELECT * FROM app_stmts_view ORDER BY 2

-- Test 70: query (line 368)
SELECT * FROM txn_fingerprint_view ORDER BY 1

