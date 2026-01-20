-- PostgreSQL compatible tests from zone_config_system_tenant
-- 27 tests

SET client_min_messages = warning;

-- CockroachDB zone configs are not supported in PostgreSQL. Skip CRDB-only
-- statements and keep the DDL so this file can run under psql.
DROP SCHEMA IF EXISTS db2 CASCADE;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS a CASCADE;

-- Test 1: statement (line 13)
CREATE TABLE t();

-- Test 2: statement (line 16)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE t CONFIGURE ZONE USING num_replicas = 5;

-- Test 3: statement (line 20)
-- CRDB-only: cluster setting
-- SET CLUSTER SETTING sql.virtual_cluster.feature_access.zone_configs.enabled = false;

-- Test 4: statement (line 23)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE t CONFIGURE ZONE USING num_replicas = 3;

-- Test 5: statement (line 26)
CREATE TABLE a(id INT PRIMARY KEY);

-- Test 6: statement (line 31)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING global_reads = true;

-- Test 7: query (line 34)
-- CRDB-only: crdb_internal.zones
-- SELECT zone_id, target FROM crdb_internal.zones ORDER BY 1;

-- Test 8: statement (line 59)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE liveness CONFIGURE ZONE USING num_replicas=3;

-- Test 9: statement (line 62)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE liveness CONFIGURE ZONE DISCARD;

-- Test 10: statement (line 65)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE meta CONFIGURE ZONE USING num_replicas=3;

-- Test 11: statement (line 68)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE meta CONFIGURE ZONE DISCARD;

-- Test 12: statement (line 71)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE timeseries CONFIGURE ZONE USING num_replicas=3;

-- Test 13: statement (line 74)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE timeseries CONFIGURE ZONE DISCARD;

-- Test 14: statement (line 77)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE system CONFIGURE ZONE USING num_replicas=3;

-- Test 15: statement (line 80)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE system CONFIGURE ZONE DISCARD;

-- Test 16: statement (line 89)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE default CONFIGURE ZONE USING num_replicas=3;

-- Test 17: statement (line 93)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE default CONFIGURE ZONE DISCARD;

-- Test 18: statement (line 101)
-- CRDB allows cross-database object references; PG does not. Use a schema.
CREATE SCHEMA db2;
CREATE TABLE db2.t (i INT PRIMARY KEY);

-- let $t_id
-- SELECT 'db2.t'::REGCLASS::INT

-- Test 19: statement (line 112)
BEGIN;
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE db2.t CONFIGURE ZONE USING range_max_bytes = 64<<20, range_min_bytes = 1<<20;
DROP TABLE db2.t;
COMMIT;

-- Test 20: query (line 119)
-- CRDB-only: system tables and crdb_internal.*
-- SELECT crdb_internal.pb_to_json('cockroach.roachpb.SpanConfig', config)
-- FROM system.span_configurations
-- WHERE end_key > (SELECT crdb_internal.table_span($t_id)[1]);

-- Test 21: statement (line 128)
-- CRDB-only: system tables and crdb_internal.*
-- SELECT crdb_internal.pb_to_json('cockroach.roachpb.SpanConfig', config)
-- FROM system.span_configurations
-- WHERE end_key > (SELECT crdb_internal.table_span($t_id)[1]);

-- Test 22: statement (line 133)
CREATE TABLE db2.t2 (i INT PRIMARY KEY);

-- Test 23: statement (line 136)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE db2.t2 CONFIGURE ZONE USING range_max_bytes = 1<<30, range_min_bytes = 1<<26;

-- Test 24: statement (line 139)
-- CRDB-only: ALTER DATABASE ... CONFIGURE ZONE
-- ALTER DATABASE db2 CONFIGURE ZONE USING gc.ttlseconds = 90001;

-- Test 25: query (line 144)
-- CRDB-only: system tables and crdb_internal.*
-- SELECT
--   crdb_internal.pretty_key(start_key, -1),
--   crdb_internal.pb_to_json('cockroach.roachpb.SpanConfig', config)
-- FROM system.span_configurations
-- WHERE end_key > (SELECT crdb_internal.table_span($t_id)[1])
-- ORDER BY start_key;

-- Test 26: statement (line 157)
-- CRDB-only: system tables and crdb_internal.*
-- SELECT
--   crdb_internal.pretty_key(start_key, -1),
--   crdb_internal.pb_to_json('cockroach.roachpb.SpanConfig', config)
-- FROM system.span_configurations
-- WHERE end_key > (SELECT crdb_internal.table_span($t_id)[1])
-- ORDER BY start_key;

-- Test 27: statement (line 167)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE meta CONFIGURE ZONE DISCARD;
-- ALTER RANGE meta CONFIGURE ZONE DISCARD;

RESET client_min_messages;
