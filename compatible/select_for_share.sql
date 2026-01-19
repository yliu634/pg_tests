-- PostgreSQL compatible tests from select_for_share
-- 41 tests

-- Test 1: statement (line 3)
CREATE TABLE t(a INT PRIMARY KEY);
INSERT INTO t VALUES(1);
GRANT ALL ON t TO testuser;
CREATE USER testuser2 WITH VIEWACTIVITY;
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser;
GRANT ALL ON t TO testuser2;

user testuser

-- Test 2: statement (line 13)
SET enable_shared_locking_for_serializable = true;

-- Test 3: statement (line 16)
BEGIN

-- Test 4: query (line 19)
SELECT * FROM t WHERE a = 1 FOR SHARE;

-- Test 5: statement (line 29)
SET enable_shared_locking_for_serializable = true;

-- Test 6: statement (line 32)
BEGIN

-- Test 7: query (line 35)
SELECT * FROM t  WHERE a = 1 FOR SHARE;

-- Test 8: statement (line 42)
UPDATE t SET a = 2 WHERE a = 1

skipif config weak-iso-level-configs

-- Test 9: query (line 46)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks

-- Test 10: query (line 55)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, replace(isolation_level, ' ', '_') AS isolation_level, granted, contended FROM crdb_internal.cluster_locks

-- Test 11: query (line 64)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, replace(isolation_level, ' ', '_') AS isolation_level, granted, contended FROM crdb_internal.cluster_locks

-- Test 12: statement (line 76)
COMMIT

user root

-- Test 13: statement (line 81)
ROLLBACK

user testuser2

-- Test 14: query (line 91)
SELECT * FROM t;

-- Test 15: statement (line 103)
SET enable_shared_locking_for_serializable = false

-- Test 16: statement (line 106)
BEGIN ISOLATION LEVEL SERIALIZABLE

-- Test 17: query (line 109)
SELECT * FROM t WHERE a = 2 FOR SHARE

-- Test 18: query (line 116)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks

-- Test 19: statement (line 123)
COMMIT

-- Test 20: statement (line 126)
SET enable_shared_locking_for_serializable = true

-- Test 21: statement (line 129)
BEGIN

-- Test 22: query (line 132)
SELECT * FROM t WHERE a = 2 FOR SHARE

-- Test 23: statement (line 139)
SET enable_shared_locking_for_serializable = true

skipif config weak-iso-level-configs

-- Test 24: query (line 143)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks

-- Test 25: query (line 150)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks

-- Test 26: statement (line 155)
BEGIN

-- Test 27: query (line 158)
SELECT * FROM t FOR SHARE SKIP LOCKED

-- Test 28: query (line 166)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks

-- Test 29: query (line 174)
SELECT database_name, schema_name, table_name, lock_key_pretty, lock_strength, durability, isolation_level, granted, contended FROM crdb_internal.cluster_locks

-- Test 30: statement (line 179)
BEGIN

-- Test 31: query (line 182)
SELECT * FROM t FOR UPDATE SKIP LOCKED

-- Test 32: statement (line 186)
COMMIT

-- Test 33: statement (line 192)
COMMIT

user testuser2

-- Test 34: statement (line 197)
COMMIT

-- Test 35: statement (line 202)
DROP TABLE IF EXISTS t;
CREATE TABLE t(a INT PRIMARY KEY);
INSERT INTO t VALUES(1), (2);
GRANT ALL ON t TO testuser;

user testuser

-- Test 36: statement (line 210)
SET enable_durable_locking_for_serializable = true;

-- Test 37: query (line 213)
BEGIN;
SELECT * FROM t WHERE a = 1 FOR SHARE;

-- Test 38: query (line 225)
BEGIN;
SELECT * FROM t FOR UPDATE SKIP LOCKED

-- Test 39: query (line 237)
BEGIN;
SELECT * FROM t FOR SHARE SKIP LOCKED;
COMMIT;

-- Test 40: statement (line 246)
COMMIT

user testuser

-- Test 41: statement (line 251)
COMMIT

