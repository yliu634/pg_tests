-- PostgreSQL compatible tests from crdb_internal
-- 217 tests

-- Test 1: query (line 5)
ALTER DATABASE crdb_internal RENAME TO not_crdb_internal

statement error schema cannot be modified: "crdb_internal"
CREATE TABLE crdb_internal.t (x INT)

query error database "crdb_internal" does not exist
DROP DATABASE crdb_internal

# Choose a few handful of tables / views from internal to check for; do not
# enumerate the entire set of iternals or the test will become overly broad and
# brittle.
query TTTTIT rowsort
WITH tables AS (SHOW TABLES FROM crdb_internal) SELECT * FROM tables
  WHERE table_name IN ('node_build_info', 'ranges', 'ranges_no_leases')

-- Test 2: statement (line 25)
CREATE DATABASE testdb; CREATE TABLE testdb.foo(x INT)

let $testdb_id
SELECT id FROM system.namespace WHERE name = 'testdb'

let $testdb_foo_id
SELECT 'testdb.foo'::regclass::int

-- Test 3: query (line 34)
SELECT t.name, t.version, t.state FROM crdb_internal.tables AS t JOIN system.namespace AS n ON (n.id = t.parent_id and n.name = 'testdb');

-- Test 4: query (line 40)
SELECT * FROM testdb.foo

-- Test 5: query (line 45)
SELECT l.name FROM crdb_internal.leases AS l JOIN system.namespace AS n ON (n.id = l.table_id and n.name = 'foo');

-- Test 6: query (line 51)
SELECT * FROM crdb_internal.schema_changes

-- Test 7: query (line 57)
SELECT
  table_id,
  parent_id,
  name,
  database_name,
  version,
  format_version,
  state,
  sc_lease_node_id,
  sc_lease_expiration_time,
  drop_time,
  audit_mode,
  schema_name,
  parent_schema_id
FROM crdb_internal.tables WHERE NAME = 'descriptor'

-- Test 8: query (line 77)
SELECT * FROM crdb_internal.pg_catalog_table_is_implemented

-- Test 9: statement (line 213)
CREATE TABLE testdb." ""\'" (i int)

-- Test 10: query (line 216)
SELECT NAME from crdb_internal.tables WHERE DATABASE_NAME = 'testdb'

-- Test 11: query (line 222)
SELECT field, value FROM crdb_internal.node_build_info WHERE field ILIKE 'name'

-- Test 12: query (line 228)
SELECT field FROM crdb_internal.node_build_info

-- Test 13: query (line 239)
SELECT * FROM crdb_internal.schema_changes WHERE table_id < 0

-- Test 14: query (line 244)
SELECT * FROM crdb_internal.leases WHERE node_id < 0

-- Test 15: query (line 249)
SELECT * FROM crdb_internal.node_statement_statistics WHERE node_id < 0

-- Test 16: query (line 254)
SELECT * FROM crdb_internal.node_transaction_statistics WHERE node_id < 0

-- Test 17: query (line 259)
SELECT * FROM crdb_internal.session_trace WHERE span_idx < 0

-- Test 18: query (line 264)
SELECT * FROM crdb_internal.cluster_settings WHERE variable = ''

-- Test 19: query (line 269)
SELECT * FROM crdb_internal.feature_usage WHERE feature_name = ''

-- Test 20: query (line 274)
SELECT * FROM crdb_internal.session_variables WHERE variable = ''

-- Test 21: query (line 279)
SELECT * FROM crdb_internal.node_queries WHERE node_id < 0

-- Test 22: query (line 284)
SELECT * FROM crdb_internal.cluster_queries WHERE node_id < 0

-- Test 23: query (line 289)
SELECT  * FROM crdb_internal.node_transactions WHERE node_id < 0

-- Test 24: query (line 294)
SELECT  * FROM crdb_internal.cluster_transactions WHERE node_id < 0

-- Test 25: statement (line 302)
SELECT  * FROM crdb_internal.node_transactions WHERE node_id < 0

-- Test 26: statement (line 305)
SELECT  * FROM crdb_internal.cluster_transactions WHERE node_id < 0

user root

-- Test 27: statement (line 310)
GRANT SYSTEM VIEWACTIVITY TO testuser

-- Test 28: query (line 316)
SELECT  * FROM crdb_internal.node_transactions WHERE node_id < 0

-- Test 29: query (line 321)
SELECT  * FROM crdb_internal.cluster_transactions WHERE node_id < 0

-- Test 30: statement (line 328)
REVOKE SYSTEM VIEWACTIVITY FROM testuser

-- Test 31: statement (line 331)
GRANT SYSTEM VIEWACTIVITYREDACTED TO testuser

-- Test 32: query (line 337)
SELECT  * FROM crdb_internal.node_transactions WHERE node_id < 0

-- Test 33: query (line 342)
SELECT  * FROM crdb_internal.cluster_transactions WHERE node_id < 0

-- Test 34: statement (line 349)
REVOKE SYSTEM VIEWACTIVITYREDACTED FROM testuser

-- Test 35: query (line 352)
SELECT * FROM crdb_internal.node_sessions WHERE node_id < 0

-- Test 36: query (line 357)
SELECT * FROM crdb_internal.cluster_sessions WHERE node_id < 0

-- Test 37: query (line 362)
SELECT * FROM crdb_internal.node_contention_events WHERE table_id < 0

-- Test 38: query (line 367)
SELECT * FROM crdb_internal.cluster_contention_events WHERE table_id < 0

-- Test 39: query (line 372)
SELECT * FROM crdb_internal.builtin_functions WHERE function = ''

-- Test 40: query (line 377)
SELECT * FROM crdb_internal.create_statements WHERE database_name = ''

-- Test 41: query (line 382)
SELECT * FROM crdb_internal.table_columns WHERE descriptor_name = ''

-- Test 42: query (line 387)
SELECT * FROM crdb_internal.table_indexes WHERE descriptor_name = ''

-- Test 43: query (line 392)
SELECT * FROM crdb_internal.index_columns WHERE descriptor_name = ''

-- Test 44: query (line 397)
SELECT * FROM crdb_internal.backward_dependencies WHERE descriptor_name = ''

-- Test 45: query (line 402)
SELECT * FROM crdb_internal.forward_dependencies WHERE descriptor_name = ''

-- Test 46: query (line 407)
SELECT * FROM crdb_internal.zones WHERE false

-- Test 47: query (line 414)
SELECT * FROM crdb_internal.cluster_inflight_traces WHERE trace_id=123

-- Test 48: statement (line 419)
SELECT * FROM crdb_internal.cluster_inflight_traces

-- Test 49: query (line 422)
SELECT * FROM crdb_internal.node_inflight_trace_spans WHERE span_id < 0

-- Test 50: query (line 427)
SELECT * FROM crdb_internal.ranges WHERE range_id < 0

-- Test 51: query (line 432)
SELECT * FROM crdb_internal.ranges_no_leases WHERE range_id < 0

-- Test 52: query (line 437)
SELECT * FROM crdb_internal.cluster_execution_insights WHERE query = ''

-- Test 53: query (line 442)
SELECT * FROM crdb_internal.node_execution_insights WHERE query = ''

-- Test 54: query (line 447)
SELECT * FROM crdb_internal.cluster_txn_execution_insights WHERE query = ''

-- Test 55: query (line 453)
SELECT * FROM crdb_internal.node_txn_execution_insights WHERE query = ''

-- Test 56: statement (line 459)
CREATE SCHEMA schema; CREATE TABLE schema.bar (y INT PRIMARY KEY)

let $schema_bar_id
SELECT 'schema.bar'::regclass::int

-- Test 57: statement (line 465)
INSERT INTO system.zones (id, config) VALUES
  ($testdb_id, (SELECT raw_config_protobuf FROM crdb_internal.zones WHERE zone_id = 0)),
  ($testdb_foo_id, (SELECT raw_config_protobuf FROM crdb_internal.zones WHERE zone_id = 0)),
  ($schema_bar_id, (SELECT raw_config_protobuf FROM crdb_internal.zones WHERE zone_id = 0))

-- Test 58: query (line 471)
SELECT zone_id, target FROM crdb_internal.zones ORDER BY 1

-- Test 59: query (line 493)
SELECT quote_literal(raw_config_yaml) FROM crdb_internal.zones WHERE zone_id = 0

-- Test 60: query (line 498)
SELECT raw_config_sql FROM crdb_internal.zones WHERE zone_id = 0

-- Test 61: statement (line 511)
CREATE TABLE empty ()

-- Test 62: statement (line 514)
CREATE DATABASE a

-- Test 63: statement (line 517)
ALTER DATABASE a CONFIGURE ZONE USING gc.ttlseconds = 1000

let $a_id
SELECT id FROM system.namespace WHERE name = 'a' AND "parentID" = 0

-- Test 64: statement (line 523)
WITH to_update AS (
	SELECT id, crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor.descriptor) as descriptor
	FROM system.descriptor
	WHERE id = $a_id
), updated AS (
	SELECT id, json_set(descriptor, ARRAY['database', 'state'], '"OFFLINE"'::JSONB) as descriptor FROM to_update
), encoded AS (
	SELECT id, crdb_internal.json_to_pb('cockroach.sql.sqlbase.Descriptor', descriptor) as descriptor FROM updated
)
SELECT crdb_internal.unsafe_upsert_descriptor(id, descriptor, true) FROM encoded

-- Test 65: query (line 538)
SHOW CREATE empty

-- Test 66: query (line 547)
SHOW CREATE empty

-- Test 67: query (line 555)
SELECT raw_config_sql FROM crdb_internal.zones WHERE zone_id = $a_id

-- Test 68: query (line 563)
SELECT crdb_internal.force_error('', 'foo')

query error pgcode FOOYAA pq: foo
SELECT crdb_internal.force_error('FOOYAA', 'foo')

query I
select crdb_internal.force_retry(interval '0s')

-- Test 69: query (line 574)
select crdb_internal.set_vmodule('not anything reasonable')

query I
select crdb_internal.set_vmodule('doesntexist=2,butitsok=4')

-- Test 70: query (line 582)
select crdb_internal.get_vmodule()

-- Test 71: query (line 587)
select crdb_internal.set_vmodule('')

-- Test 72: query (line 592)
select crdb_internal.get_vmodule()

-- Test 73: query (line 597)
SELECT crdb_internal.release_series(crdb_internal.node_executable_version())

-- Test 74: query (line 602)
SELECT crdb_internal.release_series('1.0')

query error version '2000000.0' not supported
SELECT crdb_internal.release_series('2000000.0')

query ITTT colnames,rowsort
select node_id, component, field, regexp_replace(regexp_replace(value, '^\d+$', '<port>'), e':\\d+', ':<port>') as value from crdb_internal.node_runtime_info

-- Test 75: query (line 625)
SELECT node_id, network, regexp_replace(address, '\d+$', '<port>') as address, attrs, locality, regexp_replace(server_version, '^\d+\.\d+(-upgrading-to-\d+\.\d+-step-\d+)?$', '<server_version>') as server_version FROM crdb_internal.gossip_nodes WHERE node_id = 1

-- Test 76: query (line 637)
SELECT node_id, network, regexp_replace(address, '\d+$', '<port>') as address, attrs, locality, regexp_replace(server_version, '^\d+\.\d+(-upgrading-to-\d+\.\d+-step-\d+)?$', '<server_version>') as server_version, regexp_replace(go_version, '^go.+$', '<go_version>') as go_version
FROM crdb_internal.kv_node_status WHERE node_id = 1

-- Test 77: query (line 644)
SELECT node_id, store_id, attrs, used
FROM crdb_internal.kv_store_status WHERE node_id = 1

-- Test 78: statement (line 651)
CREATE TABLE foo (a INT PRIMARY KEY, INDEX idx(a)); INSERT INTO foo VALUES(1)

-- Test 79: query (line 657)
SELECT start_pretty, end_pretty, split_enforced_until FROM crdb_internal.ranges WHERE split_enforced_until IS NOT NULL

-- Test 80: statement (line 689)
ALTER TABLE foo UNSPLIT ALL

-- Test 81: query (line 692)
SELECT start_pretty, end_pretty FROM crdb_internal.ranges WHERE split_enforced_until IS NOT NULL

-- Test 82: query (line 697)
SELECT start_pretty, end_pretty FROM crdb_internal.ranges_no_leases WHERE split_enforced_until IS NOT NULL

-- Test 83: query (line 703)
select crdb_internal.cluster_id() != '00000000-0000-0000-0000-000000000000' FROM foo

-- Test 84: query (line 768)
SELECT crdb_internal.pretty_key(e'\\xa82a00918ed9':::BYTES, (-5096189069466142898):::INT8);

-- Test 85: statement (line 776)
SET application_name = 'test_max_retry'

-- Test 86: statement (line 781)
CREATE SEQUENCE s;

-- Test 87: statement (line 784)
SELECT IF(nextval('s')<3, crdb_internal.force_retry('1h'::INTERVAL), 0);

-- Test 88: statement (line 787)
DROP SEQUENCE s

-- Test 89: statement (line 790)
RESET application_name

-- Test 90: query (line 811)
SELECT key, max_retries, failure_count
  FROM crdb_internal.node_statement_statistics
 WHERE application_name = 'test_max_retry'
ORDER BY key

-- Test 91: query (line 823)
SELECT database_name FROM crdb_internal.node_statement_statistics limit 1

-- Test 92: query (line 835)
SELECT start_pretty, end_pretty FROM crdb_internal.ranges WHERE split_enforced_until IS NOT NULL

-- Test 93: statement (line 848)
SET CLUSTER SETTING jobs.registry.interval.adopt = '1s'

-- Test 94: statement (line 852)
ALTER TABLE foo SET (schema_locked=false)

-- Test 95: statement (line 855)
TRUNCATE TABLE foo

-- Test 96: statement (line 858)
ALTER TABLE foo RESET (schema_locked)

-- Test 97: query (line 864)
SELECT start_pretty, end_pretty FROM crdb_internal.ranges
WHERE split_enforced_until IS NOT NULL
AND (start_pretty LIKE '/Table/112/1%' OR start_pretty LIKE '/Table/112/2%')

-- Test 98: query (line 876)
SELECT start_pretty, end_pretty FROM crdb_internal.ranges WHERE split_enforced_until IS NOT NULL

-- Test 99: statement (line 887)
DROP TABLE foo

-- Test 100: query (line 890)
SELECT start_pretty, end_pretty FROM crdb_internal.ranges WHERE split_enforced_until IS NOT NULL

-- Test 101: statement (line 895)
CREATE TABLE foo (a INT PRIMARY KEY, INDEX idx(a)); INSERT INTO foo VALUES(1)

-- Test 102: query (line 904)
SELECT start_pretty, end_pretty FROM crdb_internal.ranges WHERE split_enforced_until IS NOT NULL

-- Test 103: statement (line 915)
DROP INDEX foo@idx

-- Test 104: query (line 920)
SELECT start_pretty FROM crdb_internal.ranges WHERE split_enforced_until IS NOT NULL

-- Test 105: query (line 928)
SELECT length(crdb_internal.cluster_name()) > 0

-- Test 106: statement (line 934)
CREATE TABLE table41834 ();
SELECT
	crdb_internal.encode_key(
		-8912529861854991652,
		0,
		CASE
		WHEN false THEN (NULL,)
		ELSE (NULL,)
		END
	)
FROM
	table41834;

-- Test 107: query (line 949)
SELECT node_id, store_id FROM crdb_internal.kv_store_status ORDER BY (node_id, store_id) LIMIT 1

-- Test 108: query (line 965)
SELECT crdb_internal.compact_engine_span(153, 1, decode('c08989', 'hex'), decode('c0898a', 'hex'))

# Failed compaction due to unknown store.
query error store 23 was not found
SELECT crdb_internal.compact_engine_span(1, 23, decode('c08989', 'hex'), decode('c0898a', 'hex'))

# Failed compaction due to invalid range.
query error is not less than end
SELECT crdb_internal.compact_engine_span(1, 1, decode('c0898a', 'hex'), decode('c08989', 'hex'))

user testuser
query error user testuser does not have REPAIRCLUSTER system privilege
SELECT crdb_internal.compact_engine_span(1, 1, decode('c08989', 'hex'), decode('c0898a', 'hex'))

user root

# Test the crdb_internal.create_type_statements table.
statement ok
CREATE TYPE enum1 AS ENUM ('hello', 'hi');
CREATE TYPE enum2 AS ENUM ()

query ITTITTT
SELECT * FROM crdb_internal.create_type_statements ORDER BY descriptor_id

-- Test 109: query (line 995)
SELECT * FROM crdb_internal.create_type_statements WHERE descriptor_id = (('enum1'::regtype::oid::int) - 100000)::oid

-- Test 110: query (line 1000)
SELECT * FROM crdb_internal.create_type_statements WHERE descriptor_id = 'foo'::regclass::oid

-- Test 111: statement (line 1004)
SET application_name = "test_txn_statistics"

-- Test 112: statement (line 1007)
CREATE TABLE t_53504()

-- Test 113: statement (line 1010)
BEGIN; SELECT * FROM t_53504; SELECT * FROM t_53504; SELECT * FROM t_53504; COMMIT;

-- Test 114: statement (line 1013)
BEGIN; SELECT * FROM t_53504; SELECT * FROM t_53504; COMMIT;

-- Test 115: statement (line 1016)
BEGIN; SELECT * FROM t_53504; SELECT * FROM t_53504; COMMIT;

-- Test 116: statement (line 1019)
BEGIN; SELECT * FROM t_53504; COMMIT;

-- Test 117: statement (line 1022)
SELECT * FROM t_53504

-- Test 118: statement (line 1025)
RESET application_name

-- Test 119: query (line 1028)
SELECT node_id, application_name, key, statement_ids, count FROM crdb_internal.node_transaction_statistics where application_name = 'test_txn_statistics' ORDER BY key

-- Test 120: statement (line 1042)
CREATE DATABASE other_db; SET DATABASE = other_db

-- Test 121: query (line 1045)
SELECT * FROM crdb_internal.cluster_database_privileges

-- Test 122: statement (line 1053)
GRANT CONNECT ON DATABASE other_db TO testuser;
GRANT DROP ON DATABASE other_db TO testuser

-- Test 123: query (line 1057)
SELECT * FROM crdb_internal.cluster_database_privileges

-- Test 124: statement (line 1067)
SET DATABASE = test

-- Test 125: query (line 1073)
SELECT * FROM crdb_internal.invalid_objects

-- Test 126: statement (line 1079)
SELECT crdb_internal.unsafe_upsert_namespace_entry(0, 0, 'baddb', 500, true);
SELECT crdb_internal.unsafe_upsert_namespace_entry(1, 0, 'badschema', 501, true);
SELECT crdb_internal.unsafe_upsert_namespace_entry(1, 29, 'badobj', 502, true);
SELECT crdb_internal.unsafe_upsert_namespace_entry(1, 404, 'badobj', 503, true);

-- Test 127: query (line 1085)
SELECT * FROM "".crdb_internal.invalid_objects ORDER BY id

-- Test 128: statement (line 1094)
SELECT crdb_internal.unsafe_delete_namespace_entry(0, 0, 'baddb', 500, true);
SELECT crdb_internal.unsafe_delete_namespace_entry(1, 0, 'badschema', 501, true);
SELECT crdb_internal.unsafe_delete_namespace_entry(1, 29, 'badobj', 502, true);
SELECT crdb_internal.unsafe_delete_namespace_entry(1, 404, 'badobj', 503, true);

-- Test 129: query (line 1100)
SELECT * FROM crdb_internal.invalid_objects

-- Test 130: query (line 1109)
SELECT * FROM "".crdb_internal.cluster_database_privileges ORDER BY 1,2,3

-- Test 131: statement (line 1133)
SET DATABASE = "";

-- Test 132: query (line 1136)
SELECT * FROM crdb_internal.cluster_database_privileges ORDER BY 1,2,3

-- Test 133: statement (line 1160)
SET DATABASE = test

-- Test 134: statement (line 1165)
CREATE TABLE normal_table()

-- Test 135: query (line 1168)
SELECT is_virtual FROM crdb_internal.create_statements WHERE descriptor_name = 'normal_table'

-- Test 136: query (line 1173)
SELECT is_virtual FROM crdb_internal.create_statements WHERE descriptor_name = 'pg_views'

-- Test 137: query (line 1178)
SELECT is_temporary FROM crdb_internal.create_statements WHERE descriptor_name = 'normal_table'

-- Test 138: statement (line 1186)
CREATE TEMPORARY TABLE temp()

-- Test 139: query (line 1189)
SELECT is_temporary FROM crdb_internal.create_statements WHERE descriptor_name = 'temp'

-- Test 140: statement (line 1194)
CREATE TABLE defaultdb.public.in_other_db (x INT PRIMARY KEY);
CREATE TABLE public.in_this_db (x INT PRIMARY KEY);

-- Test 141: query (line 1199)
SELECT database_name, schema_name, descriptor_name
FROM "".crdb_internal.create_statements
WHERE descriptor_name IN ('in_other_db', 'in_this_db')
ORDER BY 1,2,3

-- Test 142: query (line 1210)
SELECT database_name, schema_name, descriptor_name
FROM "".crdb_internal.create_statements
WHERE descriptor_id = 'defaultdb.public.in_other_db'::regclass::int

-- Test 143: query (line 1218)
SELECT * FROM crdb_internal.regions ORDER BY 1

-- Test 144: statement (line 1225)
CREATE TABLE t69684(a NAME);
INSERT INTO t69684 VALUES ('foo');
SELECT * FROM t69684 WHERE crdb_internal.increment_feature_counter(a)

-- Test 145: statement (line 1232)
SELECT crdb_internal.probe_ranges(INTERVAL '1000ms', 'write')

-- Test 146: query (line 1242)
SELECT crdb_internal.num_inverted_index_entries(NULL::TSVECTOR, NULL::INT8)

-- Test 147: query (line 1248)
SELECT crdb_internal.unsafe_clear_gossip_info('unknown key')

-- Test 148: statement (line 1258)
GRANT SYSTEM VIEWCLUSTERSETTING TO testuser

user testuser

-- Test 149: query (line 1263)
SELECT value FROM crdb_internal.cluster_settings WHERE variable IN ('diagnostics.reporting.enabled')

-- Test 150: statement (line 1272)
GRANT SYSTEM MODIFYSQLCLUSTERSETTING TO testuser

user testuser

-- Test 151: query (line 1277)
SELECT value FROM crdb_internal.cluster_settings WHERE variable IN ('diagnostics.reporting.enabled')

-- Test 152: statement (line 1284)
REVOKE SYSTEM VIEWCLUSTERSETTING FROM testuser

-- Test 153: statement (line 1287)
REVOKE SYSTEM MODIFYSQLCLUSTERSETTING FROM testuser

-- Test 154: statement (line 1290)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser

user testuser

-- Test 155: query (line 1295)
SELECT value FROM crdb_internal.cluster_settings WHERE variable IN ('diagnostics.reporting.enabled')

-- Test 156: statement (line 1302)
REVOKE SYSTEM MODIFYCLUSTERSETTING FROM testuser

-- Test 157: query (line 1305)
SELECT crdb_internal.humanize_bytes(NULL), crdb_internal.humanize_bytes(102400)

-- Test 158: query (line 1312)
SELECT used > 0, reserved_used > 0, used < reserved_used, stopped FROM crdb_internal.node_memory_monitors WHERE name = 'root'

-- Test 159: query (line 1317)
SELECT used > 0, stopped FROM crdb_internal.node_memory_monitors WHERE name = 'sql'

-- Test 160: statement (line 1325)
SELECT pg_sleep(3)

user root

-- Test 161: query (line 1330)
SELECT count(*) > 0 FROM crdb_internal.node_memory_monitors WHERE name LIKE '%flow%'

-- Test 162: statement (line 1341)
GRANT SYSTEM MODIFYSQLCLUSTERSETTING TO testuser

user testuser

-- Test 163: query (line 1346)
SELECT value FROM crdb_internal.cluster_settings WHERE variable IN ('sql.defaults.zigzag_join.enabled')

-- Test 164: query (line 1351)
SELECT value FROM crdb_internal.cluster_settings WHERE variable IN ('diagnostics.reporting.enabled')

-- Test 165: statement (line 1358)
REVOKE SYSTEM MODIFYSQLCLUSTERSETTING FROM testuser

-- Test 166: query (line 1363)
SELECT crdb_internal.pretty_value('\x170995790a3609616d7374657264616d1cc28f5c28f5c2400080000000000000261cbbbbbbbbbbbb4800800000000000000b161b32313030312053636f747420537175617265205375697465203337161b313537333120477265676f7279205669657773204170742e20373818cabca3c10b0018ea97a9c10b001504348a2260')

-- Test 167: statement (line 1371)
SELECT * FROM crdb_internal.node_contention_events

-- Test 168: statement (line 1374)
SELECT * FROM crdb_internal.transaction_contention_events

-- Test 169: statement (line 1377)
SELECT * FROM crdb_internal.cluster_locks

user root

-- Test 170: statement (line 1382)
GRANT SYSTEM VIEWACTIVITYREDACTED TO testuser

user testuser

-- Test 171: statement (line 1387)
SELECT * FROM crdb_internal.node_contention_events

-- Test 172: statement (line 1390)
SELECT * FROM crdb_internal.transaction_contention_events

-- Test 173: statement (line 1393)
SELECT * FROM crdb_internal.cluster_locks

user root

-- Test 174: statement (line 1398)
REVOKE SYSTEM VIEWACTIVITYREDACTED FROM testuser

-- Test 175: statement (line 1401)
GRANT SYSTEM VIEWACTIVITY TO testuser

user testuser

-- Test 176: statement (line 1406)
SELECT * FROM crdb_internal.node_contention_events

-- Test 177: statement (line 1409)
SELECT * FROM crdb_internal.transaction_contention_events

-- Test 178: statement (line 1412)
SELECT * FROM crdb_internal.cluster_locks

user root

-- Test 179: statement (line 1417)
REVOKE SYSTEM VIEWACTIVITY FROM testuser

-- Test 180: statement (line 1421)
CREATE TABLE t76710_1 AS SELECT * FROM crdb_internal.statement_statistics;

-- Test 181: statement (line 1424)
CREATE MATERIALIZED VIEW t76710_2 AS SELECT fingerprint_id FROM crdb_internal.cluster_statement_statistics;

-- Test 182: statement (line 1432)
CREATE FUNCTION f(INT) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 183: statement (line 1440)
CREATE PROCEDURE f(BOOL) LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 184: query (line 1449)
SELECT database_name, schema_name, function_name, create_statement
FROM crdb_internal.create_function_statements
WHERE function_name IN ('f', 'f2')
ORDER BY function_id;

-- Test 185: statement (line 1486)
CREATE DATABASE test_cross_db;
USE test_cross_db;
CREATE FUNCTION f_cross_db() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
USE test;

-- Test 186: query (line 1492)
SELECT database_name, schema_name, function_name, create_statement
FROM "".crdb_internal.create_function_statements
WHERE function_name IN ('f', 'f2', 'f_cross_db')
ORDER BY function_id;

-- Test 187: statement (line 1539)
DROP PROCEDURE f(BOOL);

-- Test 188: statement (line 1557)
CREATE PROCEDURE p(INT) LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 189: statement (line 1565)
CREATE FUNCTION p(BOOL) RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 190: query (line 1574)
SELECT database_id, database_name, schema_id, schema_name, procedure_id, procedure_name, create_statement
FROM crdb_internal.create_procedure_statements
WHERE procedure_name IN ('p', 'p2')
ORDER BY procedure_id;

-- Test 191: statement (line 1599)
CREATE DATABASE test_cross_db;
USE test_cross_db;
CREATE PROCEDURE p_cross_db() LANGUAGE SQL AS $$ SELECT 1 $$;
USE test;

-- Test 192: query (line 1605)
SELECT database_id, database_name, schema_id, schema_name, procedure_id, procedure_name, create_statement
FROM "".crdb_internal.create_procedure_statements
WHERE procedure_name IN ('p', 'p2', 'p_cross_db')
ORDER BY procedure_id;

-- Test 193: statement (line 1657)
GRANT SYSTEM VIEWCLUSTERMETADATA TO testuser

user testuser

-- Test 194: statement (line 1662)
set allow_role_memberships_to_change_during_transaction=true

-- Test 195: statement (line 1665)
SELECT  * FROM crdb_internal.leases;

user root

-- Test 196: statement (line 1670)
REVOKE SYSTEM VIEWCLUSTERMETADATA FROM testuser

-- Test 197: statement (line 1677)
CREATE DATABASE test_table_spans;
USE test_table_spans;

-- Test 198: statement (line 1681)
CREATE TABLE foo (a INT PRIMARY KEY, INDEX idx(a)); INSERT INTO foo VALUES(1);

-- Test 199: statement (line 1684)
CREATE SCHEMA droptest;

-- Test 200: statement (line 1687)
CREATE TABLE droptest.bar (a INT PRIMARY KEY, INDEX idx(a));

-- Test 201: query (line 1690)
SELECT name, dropped
FROM "".crdb_internal.table_spans s JOIN "".crdb_internal.tables t ON s.descriptor_id = t.table_id
WHERE t.database_name = 'test_table_spans';

-- Test 202: statement (line 1698)
DROP SCHEMA droptest CASCADE

-- Test 203: query (line 1701)
SELECT name, dropped
FROM "".crdb_internal.table_spans s JOIN "".crdb_internal.tables t ON s.descriptor_id = t.table_id
WHERE t.database_name = 'test_table_spans';

-- Test 204: statement (line 1717)
CREATE USER real_user;
GRANT admin TO real_user;

-- Test 205: query (line 1721)
SELECT role, inheriting_member, member_is_explicit, member_is_admin
FROM crdb_internal.kv_inherited_role_members
ORDER BY role, inheriting_member

-- Test 206: statement (line 1729)
INSERT INTO system.users (username, user_id) VALUES ('non_cached_user', 12345);
INSERT INTO system.role_members (role, member, role_id, member_id, "isAdmin") VALUES ('admin', 'non_cached_user', 2, 12345, true);

-- Test 207: query (line 1733)
SELECT role, inheriting_member, member_is_explicit, member_is_admin
FROM crdb_internal.kv_inherited_role_members
ORDER BY role, inheriting_member

-- Test 208: statement (line 1741)
DELETE FROM system.users WHERE username = 'non_cached_user';

-- Test 209: statement (line 1744)
DELETE FROM system.role_members WHERE member = 'non_cached_user';

-- Test 210: statement (line 1747)
DROP USER real_user;

-- Test 211: statement (line 1752)
CREATE TYPE other_db.public.enum1 AS ENUM ('yo');

-- Test 212: query (line 1756)
SELECT * FROM "".crdb_internal.create_type_statements WHERE descriptor_name = 'enum1' and database_name = 'other_db'

-- Test 213: query (line 1762)
SELECT * FROM "".crdb_internal.create_type_statements WHERE descriptor_id = (('other_db.public.enum1'::regtype::int) - 100000)

-- Test 214: query (line 1769)
SELECT * FROM crdb_internal.create_type_statements WHERE descriptor_name = 'enum1'

-- Test 215: query (line 1774)
SELECT * FROM crdb_internal.create_type_statements WHERE descriptor_id = (('other_db.public.enum1'::regtype::int) - 100000)

-- Test 216: query (line 1782)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'crdb_internal' AND table_name = 'cluster_inspect_errors'
ORDER BY ordinal_position

-- Test 217: statement (line 1800)
SELECT count(*) FROM crdb_internal.cluster_inspect_errors

