-- PostgreSQL compatible tests from show_ranges
-- 27 tests

\set ON_ERROR_STOP 1
SET client_min_messages = warning;

-- Cockroach's SHOW CLUSTER RANGES / crdb_internal.ranges are KV-layer concepts.
-- PostgreSQL doesn't expose an equivalent, so we provide a small deterministic
-- stub schema that exercises similar querying patterns.
DROP SCHEMA IF EXISTS crdb_internal CASCADE;
CREATE SCHEMA crdb_internal;

CREATE TABLE crdb_internal.cluster_ranges_seed (
  range_id BIGINT PRIMARY KEY,
  start_key TEXT NOT NULL,
  end_key TEXT NOT NULL,
  raw_start_key BYTEA NOT NULL,
  raw_end_key BYTEA NOT NULL,
  lease_holder TEXT NOT NULL,

  database_name TEXT NOT NULL,
  schema_name TEXT NOT NULL,

  table_name TEXT NOT NULL,
  table_id INT NOT NULL,
  table_start_key TEXT NOT NULL,
  raw_table_start_key BYTEA NOT NULL,
  table_end_key TEXT NOT NULL,
  raw_table_end_key BYTEA NOT NULL,

  index_name TEXT NOT NULL,
  index_id INT NOT NULL,
  index_start_key TEXT NOT NULL,
  raw_index_start_key BYTEA NOT NULL,
  index_end_key TEXT NOT NULL,
  raw_index_end_key BYTEA NOT NULL
);

INSERT INTO crdb_internal.cluster_ranges_seed VALUES
  (1, '/System/0', '/System/1', decode('00','hex'), decode('01','hex'), 'n1',
      'system', 'public',
      'repl_meta', 1, '/Table/1', decode('10','hex'), '/Table/2', decode('20','hex'),
      'primary', 1, '/Index/1', decode('11','hex'), '/Index/2', decode('21','hex')),
  (2, '/Table/50', '/Table/51', decode('32','hex'), decode('33','hex'), 'n1',
      'test', 'public',
      'repl_user', 50, '/Table/50', decode('32','hex'), '/Table/51', decode('33','hex'),
      'idx', 2, '/Index/50', decode('34','hex'), '/Index/51', decode('35','hex'));

-- Views that mirror the different "WITH ..." variants.
CREATE VIEW crdb_internal.show_cluster_ranges AS
  SELECT start_key, end_key, range_id
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_details AS
  SELECT start_key, end_key, range_id, lease_holder
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_keys AS
  SELECT start_key, raw_start_key, end_key, raw_end_key, range_id
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_details_keys AS
  SELECT start_key, raw_start_key, end_key, raw_end_key, range_id, lease_holder
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_tables AS
  SELECT start_key, end_key, range_id, database_name, schema_name, table_name, table_id,
         table_start_key, table_end_key
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_details_tables AS
  SELECT start_key, end_key, range_id, lease_holder,
         database_name, schema_name, table_name, table_id,
         table_start_key, table_end_key
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_keys_tables AS
  SELECT start_key, raw_start_key, end_key, raw_end_key, range_id,
         database_name, schema_name, table_name, table_id,
         table_start_key, raw_table_start_key, table_end_key, raw_table_end_key
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_tables_keys AS
  SELECT start_key, end_key, range_id,
         database_name, schema_name, table_name, table_id,
         table_start_key, raw_table_start_key, table_end_key, raw_table_end_key
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_indexes AS
  SELECT start_key, end_key, range_id,
         database_name, schema_name, table_name, table_id,
         index_name, index_id, index_start_key, index_end_key
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_details_indexes AS
  SELECT start_key, end_key, range_id, lease_holder,
         database_name, schema_name, table_name, table_id,
         index_name, index_id, index_start_key, index_end_key
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_keys_indexes AS
  SELECT start_key, raw_start_key, end_key, raw_end_key, range_id,
         database_name, schema_name, table_name, table_id,
         index_name, index_id, index_start_key, raw_index_start_key, index_end_key, raw_index_end_key
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.show_cluster_ranges_with_details_keys_indexes AS
  SELECT start_key, raw_start_key, end_key, raw_end_key, range_id, lease_holder,
         database_name, schema_name, table_name, table_id,
         index_name, index_id, index_start_key, raw_index_start_key, index_end_key, raw_index_end_key
  FROM crdb_internal.cluster_ranges_seed;

-- Minimal helpers for "SHOW RANGE FROM TABLE ... FOR ROW (...)" style queries.
CREATE OR REPLACE FUNCTION crdb_internal.show_range_from_table(tab_name text, row_key bytea)
RETURNS TABLE(start_key text, end_key text, range_id bigint)
LANGUAGE sql
AS $$
  SELECT
    '/Table/' || tab_name || '/' || encode(row_key, 'hex') AS start_key,
    '/Table/' || tab_name || '/' || encode(row_key, 'hex') || '/end' AS end_key,
    1::bigint AS range_id;
$$;

-- crdb_internal.ranges and crdb_internal.ranges_no_leases are referenced by other
-- tests; provide minimal projections here.
CREATE VIEW crdb_internal.ranges AS
  SELECT database_name, schema_name, table_name, table_id, index_name, range_id
  FROM crdb_internal.cluster_ranges_seed;

CREATE VIEW crdb_internal.ranges_no_leases AS
  SELECT database_name, schema_name, table_name, table_id, index_name, range_id
  FROM crdb_internal.cluster_ranges_seed;

-- Test 1: query (line 32)
SELECT * FROM crdb_internal.show_cluster_ranges LIMIT 0;

-- Test 2: query (line 38)
SELECT start_key, end_key, range_id
FROM crdb_internal.show_cluster_ranges
ORDER BY range_id LIMIT 10;

-- Test 3: query (line 55)
SELECT * FROM crdb_internal.show_cluster_ranges_with_details LIMIT 0;

-- Test 4: query (line 61)
SELECT * FROM crdb_internal.show_cluster_ranges_with_keys LIMIT 0;

-- Test 5: query (line 67)
SELECT * FROM crdb_internal.show_cluster_ranges_with_details_keys LIMIT 0;

-- Test 6: query (line 72)
SELECT start_key, encode(raw_start_key, 'hex') AS raw_start_key_hex,
       end_key, encode(raw_end_key, 'hex') AS raw_end_key_hex,
       range_id, lease_holder
FROM crdb_internal.show_cluster_ranges_with_details_keys
ORDER BY range_id LIMIT 10;

-- Test 7: query (line 92)
SELECT * FROM crdb_internal.show_cluster_ranges_with_tables LIMIT 0;

-- Test 8: query (line 97)
SELECT * FROM crdb_internal.show_cluster_ranges_with_details_tables LIMIT 0;

-- Test 9: query (line 102)
SELECT * FROM crdb_internal.show_cluster_ranges_with_keys_tables LIMIT 0;

-- Test 10: query (line 109)
SELECT start_key, end_key, range_id, database_name, schema_name, table_name, table_id,
       table_start_key, encode(raw_table_start_key, 'hex') AS raw_table_start_key_hex,
       table_end_key, encode(raw_table_end_key, 'hex') AS raw_table_end_key_hex
FROM crdb_internal.show_cluster_ranges_with_tables_keys
WHERE table_name LIKE 'repl%'
   OR start_key LIKE '/System%'
ORDER BY range_id;

-- Test 11: query (line 128)
SELECT * FROM crdb_internal.show_cluster_ranges_with_indexes LIMIT 0;

-- Test 12: query (line 133)
SELECT * FROM crdb_internal.show_cluster_ranges_with_details_indexes LIMIT 0;

-- Test 13: query (line 138)
SELECT * FROM crdb_internal.show_cluster_ranges_with_keys_indexes LIMIT 0;

-- Test 14: query (line 143)
SELECT * FROM crdb_internal.show_cluster_ranges_with_details_keys_indexes LIMIT 0;

-- Test 15: query (line 150)
SELECT start_key, end_key, range_id, database_name, schema_name, table_name, table_id,
       index_name, index_id,
       index_start_key, encode(raw_index_start_key, 'hex') AS raw_index_start_key_hex,
       index_end_key, encode(raw_index_end_key, 'hex') AS raw_index_end_key_hex
FROM crdb_internal.show_cluster_ranges_with_keys_indexes
WHERE table_name LIKE 'repl%'
   OR start_key LIKE '/System%'
ORDER BY range_id;

-- Test 16: statement (line 188)
-- CockroachDB-specific session setting; no PostgreSQL equivalent.
-- SET autocommit_before_ddl = false;

-- Test 17: statement (line 196)
-- RESET autocommit_before_ddl;

-- Test 18: query (line 224)
SELECT start_key, end_key, range_id, database_name, schema_name, table_name, table_id,
       index_name, index_id, index_start_key, index_end_key
FROM crdb_internal.show_cluster_ranges_with_indexes
WHERE (database_name = 'system' AND table_name LIKE 'repl%')
   OR (database_name = 'test')
ORDER BY range_id, table_id, index_id;

-- Test 19: statement (line 451)
CREATE TABLE v0 (c1 BIT PRIMARY KEY);

-- Test 20: statement (line 454)
SELECT * FROM crdb_internal.show_range_from_table('v0', decode('68', 'hex'));

-- Test 21: statement (line 474)
SELECT database_name FROM crdb_internal.ranges ORDER BY range_id;

-- Test 22: statement (line 477)
SELECT database_name FROM CRDB_INTERNAL."ranges" ORDER BY range_id;

-- Test 23: statement (line 480)
SELECT database_name FROM crdb_internal.ranges_no_leases ORDER BY range_id;

-- Test 24: statement (line 483)
SELECT table_name FROM crdb_internal.ranges ORDER BY range_id;

-- Test 25: statement (line 486)
SELECT table_id FROM crdb_internal.ranges ORDER BY range_id;

-- Test 26: statement (line 489)
SELECT schema_name FROM crdb_internal.ranges ORDER BY range_id;

-- Test 27: statement (line 492)
SELECT index_name FROM crdb_internal.ranges ORDER BY range_id;

-- Cleanup.
DROP SCHEMA crdb_internal CASCADE;
RESET client_min_messages;
