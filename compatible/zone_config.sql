-- PostgreSQL compatible tests from zone_config
-- 75 tests

SET client_min_messages = warning;

-- CockroachDB zone configs are not supported in PostgreSQL. Keep the
-- surrounding DDL and skip CRDB-only statements so the file can run under psql.
DROP SCHEMA IF EXISTS test CASCADE;
DROP SCHEMA IF EXISTS alternative_schema CASCADE;
DROP SCHEMA IF EXISTS foo CASCADE;

DROP TABLE IF EXISTS a CASCADE;
DROP TABLE IF EXISTS zc CASCADE;
DROP TABLE IF EXISTS roachie CASCADE;
DROP TABLE IF EXISTS same_table_name CASCADE;
DROP TABLE IF EXISTS baz CASCADE;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS foo CASCADE;

DROP SEQUENCE IF EXISTS seq CASCADE;
DROP SEQUENCE IF EXISTS seq1 CASCADE;

-- Test 1: statement (line 3)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE default CONFIGURE ZONE USING num_replicas = 1;

-- Test 2: statement (line 19)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE default CONFIGURE ZONE USING DEFAULT;

-- Test 3: statement (line 35)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE default CONFIGURE ZONE USING range_min_bytes = 1234567;

-- Test 4: statement (line 38)
CREATE TABLE a (id INT PRIMARY KEY);

-- Test 5: statement (line 57)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING DEFAULT;

-- Test 6: statement (line 72)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING
--   range_min_bytes = 200000 + 1,
--   range_max_bytes = 100000000 + 1,
--   gc.ttlseconds = 3000 + 600,
--   num_replicas = floor(1.2)::int,
--   constraints = '[+region=test]',
--   lease_preferences = '[[+region=test]]';

-- Test 7: query (line 82)
-- CRDB-only: crdb_internal.feature_usage
-- SELECT feature_name FROM crdb_internal.feature_usage
-- WHERE feature_name IN (
--   'sql.schema.zone_config.table.range_min_bytes',
--   'sql.schema.zone_config.table.range_max_bytes',
--   'sql.schema.zone_config.table.gc.ttlseconds',
--   'sql.schema.zone_config.table.num_replicas',
--   'sql.schema.zone_config.table.constraints'
-- ) AND usage_count > 0 ORDER BY feature_name;

-- Test 8: statement (line 110)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING range_max_bytes = 400000000;

-- Test 9: statement (line 127)
CREATE SCHEMA test;

-- Test 10: statement (line 130)
CREATE TABLE test.a (a INT PRIMARY KEY);

-- Test 11: statement (line 133)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE test.a CONFIGURE ZONE USING gc.ttlseconds=1234;

-- Test 12: query (line 162)
-- SHOW CREATE TABLE is not supported on PostgreSQL. Use catalogs instead.
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'a'
ORDER BY ordinal_position;

-- Test 13: query (line 178)
SELECT conname, pg_get_constraintdef(oid) AS constraintdef
FROM pg_constraint
WHERE conrelid = 'a'::regclass
ORDER BY conname;

-- Test 14: statement (line 195)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING DEFAULT;

-- Test 15: statement (line 213)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE DISCARD;

-- Test 16: query (line 223)
-- CRDB-only: crdb_internal.feature_usage
-- SELECT feature_name FROM crdb_internal.feature_usage
-- WHERE feature_name IN ('sql.schema.alter_range.configure_zone', 'sql.schema.alter_table.configure_zone')
-- ORDER BY feature_name;

-- Test 17: statement (line 236)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING voter_constraints = '{"+region=test": 3}';

-- Test 18: statement (line 241)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING num_replicas = 3;

-- Test 19: statement (line 255)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING num_voters = 1;

-- Test 20: statement (line 272)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING voter_constraints = '{"+region=test": 1}';

-- Test 21: statement (line 275)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING num_voters = COPY FROM PARENT;

-- Test 22: statement (line 293)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE a CONFIGURE ZONE USING voter_constraints = '{"+region=shouldFail": 1}';

-- Test 23: statement (line 299)
CREATE TABLE zc (
  a INT PRIMARY KEY,
  b INT
);

-- Test 24: statement (line 306)
INSERT INTO zc VALUES (1,2);

-- Test 25: statement (line 309)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE zc CONFIGURE ZONE USING gc.ttlseconds = 100000;

-- Test 26: statement (line 312)
-- CRDB-only: session setting
-- SET autocommit_before_ddl = false;

-- Test 27: statement (line 315)
CREATE MATERIALIZED VIEW vm (x, y) AS SELECT a, b FROM zc;
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE vm CONFIGURE ZONE USING gc.ttlseconds = 100000;

-- Test 28: statement (line 318)
CREATE VIEW v (x, y) AS SELECT a, b FROM zc;
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE v CONFIGURE ZONE USING gc.ttlseconds = 100000;

-- Test 29: statement (line 321)
-- CRDB-only: session setting
-- RESET autocommit_before_ddl;

-- user root

-- onlyif config local-legacy-schema-changer

-- Test 30: statement (line 327)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE pg_catalog.pg_type CONFIGURE ZONE USING gc.ttlseconds = 100000;

-- onlyif config local-legacy-schema-changer

-- Test 31: statement (line 331)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE information_schema.columns CONFIGURE ZONE USING gc.ttlseconds = 100000;

-- skipif config local-legacy-schema-changer

-- Test 32: statement (line 335)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE pg_catalog.pg_type CONFIGURE ZONE USING gc.ttlseconds = 100000;

-- skipif config local-legacy-schema-changer

-- Test 33: statement (line 339)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE information_schema.columns CONFIGURE ZONE USING gc.ttlseconds = 100000;

-- Test 34: statement (line 342)
CREATE TABLE roachie(i int);

-- user testuser

-- Test 35: statement (line 347)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE roachie CONFIGURE ZONE USING gc.ttlseconds = 1;

-- user root

-- Test 36: statement (line 354)
CREATE TABLE same_table_name();
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE same_table_name CONFIGURE ZONE USING gc.ttlseconds = 500;
CREATE SCHEMA alternative_schema;
CREATE TABLE alternative_schema.same_table_name();
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE alternative_schema.same_table_name CONFIGURE ZONE USING gc.ttlseconds = 600;

-- onlyif config schema-locked-disabled

-- Test 37: query (line 362)
SELECT to_regclass('same_table_name');

-- Test 38: query (line 373)
SELECT to_regclass('same_table_name');

-- Test 39: query (line 384)
SELECT to_regclass('alternative_schema.same_table_name');

-- Test 40: query (line 396)
SELECT to_regclass('alternative_schema.same_table_name');

-- Test 41: statement (line 406)
DROP TABLE IF EXISTS zc CASCADE;

-- Test 42: statement (line 409)
-- CRDB allows cross-database object references; PG does not. Use a schema.
CREATE SCHEMA foo;

-- Test 43: statement (line 412)
-- CRDB-only: ALTER DATABASE ... CONFIGURE ZONE
-- ALTER DATABASE foo CONFIGURE ZONE USING gc.ttlseconds = 12345;

-- Test 44: statement (line 415)
CREATE TABLE foo.bar (x INT PRIMARY KEY);

-- Test 45: statement (line 419)
INSERT INTO foo.bar VALUES (1);

-- Test 46: statement (line 422)
DROP SCHEMA foo CASCADE;

-- Test 47: statement (line 425)
CREATE TABLE baz (x INT PRIMARY KEY);

-- Test 48: statement (line 429)
INSERT INTO baz VALUES (1);

-- Test 49: statement (line 432)
DROP TABLE baz;

-- Test 50: query (line 435)
-- CRDB-only: crdb_internal.kv_dropped_relations
-- SELECT name, ttl FROM crdb_internal.kv_dropped_relations ORDER BY name;

-- Test 51: statement (line 443)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE default CONFIGURE ZONE DISCARD;

-- Test 52: statement (line 450)
-- CRDB-only: multi-database setup
-- CREATE DATABASE foo;

-- Test 53: statement (line 453)
-- CRDB-only: ALTER RANGE ... CONFIGURE ZONE
-- ALTER RANGE default CONFIGURE ZONE USING gc.ttlseconds = 3;
-- ALTER RANGE default CONFIGURE ZONE USING gc.ttlseconds = 4;

-- Test 54: statement (line 456)
-- CRDB-only: ALTER DATABASE ... CONFIGURE ZONE
-- ALTER DATABASE foo CONFIGURE ZONE USING gc.ttlseconds = 3;
-- ALTER DATABASE foo CONFIGURE ZONE USING gc.ttlseconds = 4;

-- Test 55: statement (line 459)
-- CRDB-only: ALTER DATABASE ... CONFIGURE ZONE
-- ALTER DATABASE foo CONFIGURE ZONE DISCARD;
-- ALTER DATABASE foo CONFIGURE ZONE DISCARD;

-- Test 56: statement (line 466)
CREATE SEQUENCE seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

-- Test 57: statement (line 474)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE seq CONFIGURE ZONE USING gc.ttlseconds = 100000;

-- Test 58: query (line 495)
-- CRDB-only: system.zones and crdb_internal.pb_to_json
-- WITH settings AS (
--     SELECT
--       (crdb_internal.pb_to_json('cockroach.config.zonepb.ZoneConfig', config) -> 'numReplicas') AS replicas,
--       ((crdb_internal.pb_to_json('cockroach.config.zonepb.ZoneConfig', config) -> 'gc') ->> 'ttlSeconds')::INT AS ttl
--     FROM system.zones
--     -- 16 is the ID for the meta range
--     WHERE id = 16
-- )
-- SELECT *
-- FROM settings;

-- Test 59: statement (line 510)
-- CRDB-only: session setting
-- RESET use_declarative_schema_changer;

-- Test 60: statement (line 519)
CREATE TABLE t(i INT PRIMARY KEY, j INT NOT NULL);
CREATE INDEX idx ON t (j);

-- skipif config local-legacy-schema-changer

-- Test 61: statement (line 523)
-- CRDB-only: session setting
-- SET use_declarative_schema_changer = unsafe_always;

-- Test 62: statement (line 526)
BEGIN;
ALTER TABLE t DROP CONSTRAINT t_pkey;
ALTER TABLE t ADD PRIMARY KEY (j);
-- CRDB-only: ALTER INDEX ... CONFIGURE ZONE
-- ALTER INDEX t@t_pkey CONFIGURE ZONE USING num_replicas = 11;
COMMIT;

-- Test 63: query (line 532)
-- CRDB-only: system tables
-- WITH subzones AS (
--     SELECT
--         json_array_elements(
--             crdb_internal.pb_to_json('cockroach.config.zonepb.ZoneConfig', config) -> 'subzones'
--         ) AS config
--     FROM system.zones
--     WHERE id = 't'::REGCLASS::OID
-- ),
-- subzone_configs AS (
--     SELECT
--         (config -> 'config' ->> 'numReplicas')::INT AS replicas
--     FROM subzones
-- )
-- SELECT *
-- FROM subzone_configs;

-- Test 64: query (line 555)
-- CRDB-only: system tables
-- WITH subzones AS (
--     SELECT
--         json_array_elements(
--             crdb_internal.pb_to_json('cockroach.config.zonepb.ZoneConfig', config) -> 'subzones'
--         ) AS config
--     FROM system.zones
--     WHERE id = 't'::REGCLASS::OID
-- ),
-- subzone_indexes AS (
--     SELECT
--         (config -> 'indexId')::INT AS indexID
--     FROM subzones
-- ),
-- primary_index AS (
--     SELECT
--         (crdb_internal.pb_to_json(
--             'cockroach.sql.sqlbase.Descriptor',
--             descriptor
--         )->'table'->'primaryIndex'->>'id')::INT AS primaryID
--     FROM system.descriptor
--     WHERE id = 't'::regclass::oid
-- )
-- SELECT
--     (primaryID = indexID) AS match_found
-- FROM primary_index, subzone_indexes;

-- Test 65: statement (line 585)
-- CRDB-only: session setting
-- RESET use_declarative_schema_changer;

-- Test 66: statement (line 594)
CREATE TABLE foo(i int);

-- Test 67: statement (line 597)
-- CRDB-only: ALTER INDEX ... CONFIGURE ZONE
-- ALTER INDEX foo@foo_pkey CONFIGURE ZONE USING gc.ttlseconds=90;

-- Test 68: statement (line 600)
ALTER TABLE foo ADD COLUMN j INT NOT NULL DEFAULT 42;

-- Test 69: statement (line 607)
-- CRDB-only: system tables and force_error
-- WITH subzones AS (
--     SELECT
--         json_array_elements(
--             crdb_internal.pb_to_json('cockroach.config.zonepb.ZoneConfig', config) -> 'subzones'
--         ) AS config
--     FROM system.zones
--     WHERE id = 'foo'::REGCLASS::OID
-- ),
-- subzone_indexes AS (
--     SELECT
--         (config -> 'indexId')::INT AS indexID
--     FROM subzones
-- ),
-- primary_index AS (
--     SELECT
--         (crdb_internal.pb_to_json(
--             'cockroach.sql.sqlbase.Descriptor',
--             descriptor
--         )->'table'->'primaryIndex'->>'id')::INT AS primaryID
--     FROM system.descriptor
--     WHERE id = 'foo'::regclass::oid
-- ),
-- index_ids_match AS (
--   SELECT EXISTS (
--       SELECT 1
--       FROM primary_index, subzone_indexes
--       WHERE primaryID = indexID
--   ) AS match_found
-- )
-- SELECT crdb_internal.force_error('', 'expected IDs to match')
-- FROM index_ids_match WHERE match_found = false;

-- Test 70: query (line 644)
-- CRDB-only: system tables
-- WITH subzones AS (
--     SELECT
--         json_array_elements(
--             crdb_internal.pb_to_json('cockroach.config.zonepb.ZoneConfig', config) -> 'subzones'
--         ) AS config
--     FROM system.zones
--     WHERE id = 'foo'::REGCLASS::OID
-- ),
-- subzone_indexes AS (
--     SELECT
--         (config -> 'indexId')::INT AS indexID
--     FROM subzones
-- )
-- SELECT indexID
-- FROM subzone_indexes
-- ORDER BY indexID;

-- Test 71: query (line 667)
-- CRDB-only: system tables and pretty_key
-- WITH subzone_spans AS (
--     SELECT json_array_elements(crdb_internal.pb_to_json('cockroach.config.zonepb.ZoneConfig', config) -> 'subzoneSpans') ->> 'key' AS key
--     FROM system.zones
--     WHERE id = 'foo'::REGCLASS::OID
-- )
-- SELECT crdb_internal.pretty_key(decode(key, 'base64'), 0)
-- FROM subzone_spans
-- ORDER BY 1;

-- Test 72: statement (line 685)
CREATE SEQUENCE seq1;

-- Test 73: statement (line 688)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE seq1 CONFIGURE ZONE USING num_replicas=7;

-- Test 74: statement (line 706)
-- CRDB-only: ALTER TABLE ... CONFIGURE ZONE
-- ALTER TABLE seq1 CONFIGURE ZONE DISCARD;

-- Test 75: statement (line 724)
DROP SEQUENCE IF EXISTS seq1;

RESET client_min_messages;
