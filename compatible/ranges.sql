-- PostgreSQL compatible tests from ranges
-- 50 tests

-- CockroachDB range introspection (crdb_internal.* and SHOW RANGE) is not
-- available in PostgreSQL. This file keeps the overall setup structure but
-- replaces CRDB-only parts with minimal, stable placeholders.

SET client_min_messages = warning;

-- Minimal stubs for CRDB virtual/internal objects referenced below.
DROP SCHEMA IF EXISTS crdb_internal CASCADE;
CREATE SCHEMA crdb_internal;

CREATE TABLE crdb_internal.ranges_no_leases (
  start_key BYTEA,
  start_pretty TEXT,
  end_key BYTEA,
  end_pretty TEXT,
  replicas TEXT
);

CREATE TABLE crdb_internal.ranges (
  start_key BYTEA,
  start_pretty TEXT,
  end_key BYTEA,
  end_pretty TEXT,
  replicas TEXT,
  lease_holder TEXT
);

CREATE FUNCTION crdb_internal.lease_holder(start_key BYTEA)
RETURNS TEXT
LANGUAGE sql
AS $$SELECT NULL::TEXT$$;

CREATE TABLE crdb_internal.feature_usage (
  feature_name TEXT,
  usage_count INT
);

INSERT INTO crdb_internal.feature_usage(feature_name, usage_count)
VALUES ('sql.show.ranges', 0);

-- Test 1: statement (line 3)
CREATE TABLE t (
  k1 INT,
  k2 INT DEFAULT 999,
  v INT DEFAULT 999,
  w INT DEFAULT 999,
  PRIMARY KEY (k1, k2)
);

-- Test 2: statement (line 87)
CREATE INDEX idx ON t(v, w);

-- Test 3: statement (line 136)
CREATE SCHEMA d;

-- Test 4: statement (line 139)
CREATE TABLE d.a ();

-- Test 5: statement (line 142)
CREATE SCHEMA e;

-- Test 6: statement (line 145)
CREATE TABLE e.b (i INT);

-- Test 7: statement (line 151)
CREATE TABLE d.c (i INT);

-- Test 8: statement (line 154)
DROP SCHEMA e CASCADE;

-- Test 9: statement (line 157)
CREATE INDEX ON d.c (i);

-- Test 10: query (line 168)
SELECT encode(start_key, 'hex'), start_pretty, encode(end_key, 'hex'), end_pretty, replicas,
       crdb_internal.lease_holder(start_key)
FROM crdb_internal.ranges_no_leases;

-- Test 11: query (line 269)
SELECT encode(start_key, 'hex'), start_pretty, encode(end_key, 'hex'), end_pretty, replicas, lease_holder
FROM crdb_internal.ranges;

-- Test 12: statement (line 394)
-- The identifier """"" names a schema whose name is a single double quote (").
CREATE SCHEMA """";

-- Test 13: statement (line 397)
CREATE TABLE """".t (x INT PRIMARY KEY);

-- Test 14: query (line 413)
SELECT feature_name
FROM crdb_internal.feature_usage
WHERE feature_name='sql.show.ranges' AND usage_count > 0;

-- Test 15: statement (line 420)
CREATE TABLE simple_range_for_row(x INT PRIMARY KEY);

-- Test 16: query (line 427)
-- SHOW RANGE is CockroachDB-specific.
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 17: query (line 433)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 18: query (line 439)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 19: statement (line 444)
CREATE TABLE range_for_row(
  x INT,
  y INT,
  z INT,
  w INT,
  PRIMARY KEY (x, y)
);
CREATE INDEX i_range_for_row ON range_for_row (z, w);

-- Test 20: query (line 453)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 21: query (line 458)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 22: query (line 463)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 23: query (line 468)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 24: query (line 473)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 25: query (line 478)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 26: query (line 489)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 27: statement (line 494)
CREATE TABLE range_for_row_decimal(x DECIMAL PRIMARY KEY);

-- Test 28: query (line 500)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 29: statement (line 505)
CREATE TABLE range_for_row_nulls(x INT PRIMARY KEY, y INT);
CREATE INDEX i_range_for_row_nulls ON range_for_row_nulls (y);

-- Test 30: query (line 511)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 31: statement (line 519)
CREATE TABLE t42456 (x INT PRIMARY KEY);

-- Test 32: statement (line 522)
CREATE INDEX i1 ON t42456 (x);

-- Test 33: statement (line 525)
CREATE INDEX i2 ON t42456 (x);

-- Test 34: statement (line 528)
DROP INDEX i1;

-- Test 35: statement (line 531)
DROP INDEX i2;

-- Test 36: statement (line 534)
CREATE INDEX i3 ON t42456 (x);

-- Test 37: query (line 544)
-- CRDB descriptor inspection is not available in PostgreSQL.
SELECT NULL::JSONB AS idx WHERE FALSE;

-- Test 38: query (line 552)
SELECT NULL::TEXT AS pretty_key WHERE FALSE;

-- Test 39: query (line 606)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 40-45: statements (line 615)
-- CockroachDB permission / zoneconfig / viewactivity tests are not available in PostgreSQL.

-- Test 46: statement (line 693)
-- Range stats are CockroachDB-specific.
SELECT NULL::TEXT AS range_stats WHERE FALSE;

-- Test 47: statement (line 708)
CREATE TABLE tbl_for_row(i INT PRIMARY KEY);

-- Test 48: query (line 712)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

-- Test 49: statement (line 723)
CREATE TABLE tbl_with_idx_for_row(i INT);
CREATE INDEX tbl_with_idx_for_row_idx ON tbl_with_idx_for_row(i);

-- Test 50: query (line 726)
SELECT NULL::TEXT AS start_key, NULL::TEXT AS end_key WHERE FALSE;

RESET client_min_messages;
