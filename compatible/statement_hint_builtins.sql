-- PostgreSQL compatible tests from statement_hint_builtins
-- 180 tests


SET client_min_messages = warning;

-- PostgreSQL setup: stub out CockroachDB system schemas/functions referenced in this test.
CREATE SCHEMA IF NOT EXISTS system;
CREATE SCHEMA IF NOT EXISTS crdb_internal;

CREATE TABLE IF NOT EXISTS system.statement_hints (
  row_id INT PRIMARY KEY,
  fingerprint TEXT
);

CREATE TABLE IF NOT EXISTS system.eventlog (
  "eventType" TEXT,
  "reportingID" INT,
  info JSONB,
  "timestamp" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS crdb_internal.feature_usage (
  feature_name TEXT PRIMARY KEY,
  usage_count INT
);

INSERT INTO crdb_internal.feature_usage(feature_name, usage_count)
VALUES ('sql.session.statement-hints', 0)
ON CONFLICT (feature_name) DO NOTHING;

CREATE TABLE IF NOT EXISTS crdb_internal.node_metrics (
  name TEXT PRIMARY KEY,
  value INT
);

INSERT INTO crdb_internal.node_metrics(name, value)
VALUES ('sql.query.with_statement_hints.count', 0)
ON CONFLICT (name) DO NOTHING;

CREATE OR REPLACE FUNCTION information_schema.crdb_rewrite_inline_hints(original_sql TEXT, hinted_sql TEXT)
  RETURNS INT
  LANGUAGE SQL
  IMMUTABLE
AS $$
  SELECT 0;
$$;

CREATE OR REPLACE FUNCTION crdb_internal.await_statement_hints_cache()
  RETURNS BOOL
  LANGUAGE SQL
  IMMUTABLE
AS $$
  SELECT true;
$$;

CREATE OR REPLACE FUNCTION crdb_internal.clear_statement_hints_cache()
  RETURNS BOOL
  LANGUAGE SQL
  IMMUTABLE
AS $$
  SELECT true;
$$;

CREATE OR REPLACE FUNCTION crdb_internal.inject_hint(original_sql TEXT, hinted_sql TEXT)
  RETURNS BOOL
  LANGUAGE SQL
  IMMUTABLE
AS $$
  SELECT true;
$$;
-- Test 1: statement (line 10)
-- CockroachDB-only: SET CLUSTER SETTING kv.closed_timestamp.target_duration = '50ms';

-- Test 2: statement (line 13)
-- CockroachDB-only: SET CLUSTER SETTING kv.closed_timestamp.side_transport_interval = '50ms';

-- Test 3: statement (line 16)
-- CockroachDB-only: SET CLUSTER SETTING kv.rangefeed.closed_timestamp_refresh_interval = '50ms';

-- user root

-- Test 4: statement (line 21)
CREATE TABLE xy (x INT PRIMARY KEY, y INT);
CREATE INDEX xy_y_idx ON xy (y);

-- Test 5: statement (line 24)
CREATE TABLE ab (a INT PRIMARY KEY, b INT);
CREATE INDEX ab_b_idx ON ab (b);

-- Test 6: statement (line 27)
INSERT INTO xy VALUES (10, 10);

-- Test 7: statement (line 30)
INSERT INTO ab VALUES (10, 10);

-- Test 8: query (line 33)
SELECT count(*) FROM system.statement_hints;

-- Test 9: query (line 45)
SELECT fingerprint FROM system.statement_hints WHERE row_id = 0;

-- Test 10: query (line 57)
SELECT fingerprint FROM system.statement_hints WHERE row_id = 0;

-- Test 11: query (line 69)
SELECT fingerprint FROM system.statement_hints WHERE row_id = 0;

-- Test 12: query (line 74)
SELECT count(*) FROM system.statement_hints;

-- Test 13: query (line 79)
SELECT count(*) FROM system.statement_hints WHERE fingerprint = 'SELECT * FROM xy WHERE y = _';

-- Test 14: query (line 84)
SELECT count(*) FROM system.statement_hints WHERE fingerprint = 'SELECT * FROM xy INNER JOIN ab ON xy.x = ab.b';

-- Test 15: query (line 91)
SELECT count(*) FROM system.eventlog WHERE "eventType" = 'rewrite_inline_hints';

-- Test 16: query (line 96)
SELECT "reportingID",
       info::JSONB->>'StatementFingerprint',
       info::JSONB->>'DonorSQL'
FROM system.eventlog
WHERE "eventType" = 'rewrite_inline_hints'
ORDER BY "timestamp";

-- Test 17: query (line 109)
SELECT (info::JSONB->>'HintID')::INT = 0
FROM system.eventlog
WHERE "eventType" = 'rewrite_inline_hints'
  AND info::JSONB->>'StatementFingerprint' = 'SELECT * FROM xy WHERE y = _'
ORDER BY "timestamp"
LIMIT 1;

-- Test 18: query (line 120)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'TxnReadTimestamp' - 'HintID'
FROM system.eventlog
WHERE "eventType" = 'rewrite_inline_hints'
  AND info::JSONB->>'StatementFingerprint' = 'SELECT * FROM xy INNER JOIN ab ON xy.x = ab.b';

-- Test 19: statement (line 128)
DELETE FROM system.statement_hints WHERE true;

-- Test 20: query (line 131)
SELECT count(*) FROM system.statement_hints;

-- Test 21: statement (line 137)
BEGIN;

-- let $hint4
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT * FROM xy WHERE y = 10',
  'SELECT * FROM xy@{NO_FULL_SCAN} WHERE y = 10'
);

-- Test 22: query (line 146)
SELECT fingerprint FROM system.statement_hints WHERE row_id = 0;

-- Test 23: query (line 152)
SELECT count(*) FROM system.eventlog
WHERE "eventType" = 'rewrite_inline_hints'
  AND (info::JSONB->>'HintID')::INT = 0;

-- Test 24: statement (line 159)
ROLLBACK;

-- Test 25: query (line 162)
SELECT count(*) FROM system.statement_hints;

-- Test 26: query (line 168)
SELECT count(*) FROM system.eventlog
WHERE "eventType" = 'rewrite_inline_hints'
  AND (info::JSONB->>'HintID')::INT = 0;

-- Test 27: statement (line 177)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT * FROM xy WHERE x > y',
  'SELECT * FROM xy WHERE x > y'
);

-- Test 28: statement (line 183)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 29: statement (line 186)
SELECT * FROM xy WHERE x > y;

-- Test 30: query (line 189)
SELECT usage_count
FROM crdb_internal.feature_usage
WHERE feature_name = 'sql.session.statement-hints';

-- Test 31: statement (line 196)
EXPLAIN SELECT * FROM xy WHERE x > y;

-- Test 32: query (line 199)
SELECT usage_count
FROM crdb_internal.feature_usage
WHERE feature_name = 'sql.session.statement-hints';

-- Test 33: statement (line 206)
EXPLAIN ANALYZE SELECT * FROM xy WHERE x > y;

-- Test 34: query (line 209)
SELECT usage_count
FROM crdb_internal.feature_usage
WHERE feature_name = 'sql.session.statement-hints';

-- Test 35: statement (line 216)
PREPARE p AS SELECT * FROM xy WHERE x > y;

-- Test 36: statement (line 219)
EXECUTE p;

-- Test 37: query (line 222)
SELECT usage_count
FROM crdb_internal.feature_usage
WHERE feature_name = 'sql.session.statement-hints';

-- Test 38: statement (line 229)
SELECT crdb_internal.clear_statement_hints_cache();

-- Test 39: statement (line 232)
SELECT * FROM xy WHERE x > y;

-- Test 40: query (line 235)
SELECT usage_count
FROM crdb_internal.feature_usage
WHERE feature_name = 'sql.session.statement-hints';

-- Test 41: statement (line 242)
DELETE FROM system.statement_hints WHERE true;

-- Test 42: statement (line 245)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 43: statement (line 248)
SELECT * FROM xy WHERE x > y;

-- Test 44: statement (line 251)
EXECUTE p;

-- Test 45: query (line 254)
SELECT usage_count
FROM crdb_internal.feature_usage
WHERE feature_name = 'sql.session.statement-hints';

-- Test 46: statement (line 261)
DEALLOCATE ALL;

-- Test 47: statement (line 266)
CREATE TABLE abc (a INT PRIMARY KEY, b INT, c INT);
CREATE INDEX abc_b_idx ON abc (b);

-- Test 48: query (line 272)
EXPLAIN SELECT a FROM abc WHERE a = 10;

-- Test 49: statement (line 282)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a FROM abc WHERE a = _',
  'SELECT a FROM abc@abc_b_idx WHERE a = _'
);

-- Test 50: statement (line 288)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 51: statement (line 294)
SELECT a FROM abc WHERE a = 5;

-- Test 52: query (line 309)
EXPLAIN SELECT a FROM abc WHERE a = 10;

-- Test 53: statement (line 313)
-- ·
-- • filter
-- │ filter: a = 10
-- │
-- └── • scan
-- missing stats
-- table: abc@abc_b_idx
-- spans: FULL SCAN

-- onlyif config local

-- Test 54: query (line 324)
EXPLAIN ANALYZE SELECT a FROM abc WHERE a = 10;

-- Test 55: statement (line 331)
-- regions: <hidden>
-- ·
-- • filter
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ filter: a = 10
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_b_idx
-- spans: FULL SCAN

-- Test 56: query (line 355)
EXPLAIN SELECT a, x FROM abc JOIN xy ON y = b WHERE a = 10;

-- Test 57: statement (line 369)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a, x FROM abc JOIN xy ON y = b WHERE a = _',
  'SELECT a, x FROM abc INNER HASH JOIN xy ON y = b WHERE a = _'
);

-- Test 58: statement (line 375)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 59: statement (line 381)
SELECT a, x FROM abc JOIN xy ON y = b WHERE a = 5;

-- Test 60: query (line 396)
EXPLAIN SELECT a, x FROM abc JOIN xy ON y = b WHERE a = 10;

-- Test 61: statement (line 400)
-- ·
-- • hash join
-- │ equality: (b) = (y)
-- │ left cols are key
-- │
-- ├── • scan
-- │     missing stats
-- │     table: abc@abc_pkey
-- │     spans: [/10 - /10]
-- │
-- └── • scan
-- missing stats
-- table: xy@xy_pkey
-- spans: FULL SCAN

-- onlyif config local

-- Test 62: query (line 417)
EXPLAIN ANALYZE SELECT a, x FROM abc JOIN xy ON y = b WHERE a = 10;

-- Test 63: statement (line 424)
-- rows decoded from KV: 1 (8 B, 2 KVs, 1 gRPC calls);
-- regions: <hidden>
-- ·
-- • hash join
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ equality: (b) = (y)
-- │ left cols are key
-- │
-- ├── • scan
-- │     sql nodes: <hidden>
-- │     kv nodes: <hidden>
-- │     regions: <hidden>
-- │     KV time: 0µs
-- │     KV rows decoded: 0
-- │     actual row count: 0
-- │     missing stats
-- │     table: abc@abc_pkey
-- │     spans: [/10 - /10]
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 1
-- actual row count: 1
-- missing stats
-- table: xy@xy_pkey
-- spans: FULL SCAN

-- Test 64: statement (line 460)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a FROM abc@abc_pkey WHERE b = _',
  'SELECT a FROM abc WHERE b = _'
);

-- Test 65: statement (line 466)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 66: statement (line 472)
SELECT a FROM abc WHERE b = 5;

-- Test 67: query (line 487)
EXPLAIN SELECT a FROM abc WHERE b = 10;

-- Test 68: statement (line 491)
-- ·
-- • scan
-- missing stats
-- table: abc@abc_b_idx
-- spans: [/10 - /10]

-- onlyif config local

-- Test 69: query (line 499)
EXPLAIN ANALYZE SELECT a FROM abc WHERE b = 10;

-- Test 70: statement (line 506)
-- regions: <hidden>
-- ·
-- • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_b_idx
-- spans: [/10 - /10]

-- Test 71: statement (line 522)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a + _ FROM abc WHERE a = _',
  'SELECT a + _ FROM abc@foo WHERE a = _'
);

-- Test 72: statement (line 528)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 73: statement (line 534)
SELECT a + 1 FROM abc WHERE a = 5;

-- Test 74: query (line 551)
EXPLAIN SELECT a + 1 FROM abc WHERE a = 10;

-- Test 75: statement (line 555)
-- ·
-- • render
-- │
-- └── • scan
-- missing stats
-- table: abc@abc_pkey
-- spans: [/10 - /10]

-- onlyif config local

-- Test 76: query (line 565)
EXPLAIN ANALYZE SELECT a + 1 FROM abc WHERE a = 10;

-- Test 77: statement (line 572)
-- regions: <hidden>
-- ·
-- • render
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_pkey
-- spans: [/10 - /10]

-- Test 78: statement (line 590)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT c FROM xy JOIN abc ON c = y WHERE x = _',
  'SELECT c FROM xy INNER LOOKUP JOIN abc ON c = y WHERE x = _'
);

-- Test 79: statement (line 596)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 80: statement (line 602)
SELECT c FROM xy JOIN abc ON c = y WHERE x = 5;

-- Test 81: query (line 619)
EXPLAIN SELECT c FROM xy JOIN abc ON c = y WHERE x = 10;

-- Test 82: statement (line 623)
-- ·
-- • hash join
-- │ equality: (c) = (y)
-- │ right cols are key
-- │
-- ├── • scan
-- │     missing stats
-- │     table: abc@abc_pkey
-- │     spans: FULL SCAN
-- │
-- └── • scan
-- missing stats
-- table: xy@xy_pkey
-- spans: [/10 - /10]

-- onlyif config local

-- Test 83: query (line 640)
EXPLAIN ANALYZE SELECT c FROM xy JOIN abc ON c = y WHERE x = 10;

-- Test 84: statement (line 647)
-- rows decoded from KV: 1 (8 B, 2 KVs, 1 gRPC calls);
-- regions: <hidden>
-- ·
-- • hash join
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ equality: (c) = (y)
-- │ right cols are key
-- │
-- ├── • scan
-- │     sql nodes: <hidden>
-- │     kv nodes: <hidden>
-- │     regions: <hidden>
-- │     KV time: 0µs
-- │     KV rows decoded: 0
-- │     actual row count: 0
-- │     missing stats
-- │     table: abc@abc_pkey
-- │     spans: FULL SCAN
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 1
-- actual row count: 1
-- missing stats
-- table: xy@xy_pkey
-- spans: [/10 - /10]

-- Test 85: statement (line 689)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 86: statement (line 695)
PREPARE p1 AS SELECT c FROM abc WHERE b > $1;

-- Test 87: statement (line 698)
EXECUTE p1 (5);

-- Test 88: query (line 715)
EXPLAIN ANALYZE EXECUTE p1 (5);

-- Test 89: statement (line 722)
-- regions: <hidden>
-- ·
-- • filter
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ filter: b > 5
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_pkey
-- spans: FULL SCAN

-- Test 90: statement (line 748)
PREPARE p2 AS SELECT c + 1 FROM abc WHERE b > $1;

-- Test 91: query (line 786)
EXPLAIN ANALYZE EXECUTE p2 (5);

-- Test 92: statement (line 793)
-- regions: <hidden>
-- ·
-- • render
-- │
-- └── • filter
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ filter: b > 5
-- │
-- └── • revscan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_pkey
-- spans: FULL SCAN

-- Test 93: statement (line 819)
DELETE FROM system.statement_hints WHERE row_id = 0;

-- Test 94: statement (line 822)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 95: statement (line 828)
EXECUTE p1 (6);

-- Test 96: statement (line 870)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT sum(a) FROM abc WHERE c = _',
  'SELECT sum(a) FROM abc@abc_foo WHERE c = _'
);

-- Test 97: statement (line 876)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 98: statement (line 882)
PREPARE p3 AS SELECT sum(a) FROM abc WHERE c = $1;

-- Test 99: statement (line 885)
EXECUTE p3 (5);

-- Test 100: query (line 906)
EXPLAIN ANALYZE EXECUTE p3 (5);

-- Test 101: statement (line 913)
-- regions: <hidden>
-- ·
-- • group (scalar)
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 1
-- │
-- └── • filter
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ filter: c = 5
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_pkey
-- spans: FULL SCAN

-- Test 102: statement (line 943)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT max(a) FROM abc WHERE (b = _) AND (c = _)',
  'SELECT max(a) FROM abc@{FORCE_ZIGZAG} WHERE (b = _) AND (c = _)'
);

-- Test 103: statement (line 949)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 104: statement (line 955)
PREPARE p4 AS SELECT max(a) FROM abc WHERE b = $1 AND c = $2;

-- Test 105: statement (line 958)
EXECUTE p4 (5, 6);

-- Test 106: query (line 977)
EXPLAIN ANALYZE EXECUTE p4 (5, 6);

-- Test 107: statement (line 984)
-- regions: <hidden>
-- ·
-- • group (scalar)
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 1
-- │
-- └── • filter
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ filter: c = 6
-- │
-- └── • index join (streamer)
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ KV time: 0µs
-- │ KV rows decoded: 0
-- │ actual row count: 0
-- │ table: abc@abc_pkey
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_b_idx
-- spans: [/5 - /5]

-- Test 108: statement (line 1021)
SET plan_cache_mode = force_generic_plan;

-- Test 109: statement (line 1024)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a * _ FROM abc WHERE b > _',
  'SELECT a * _ FROM abc@abc_pkey WHERE b > _'
);

-- Test 110: statement (line 1030)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 111: statement (line 1036)
PREPARE p5 AS SELECT a * 2 FROM abc WHERE b > $1;

-- Test 112: statement (line 1039)
EXECUTE p5 (5);

-- Test 113: statement (line 1042)
EXECUTE p5 (6);

-- Test 114: query (line 1061)
EXPLAIN ANALYZE EXECUTE p5 (6);

-- Test 115: statement (line 1068)
-- regions: <hidden>
-- ·
-- • render
-- │
-- └── • filter
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ filter: b > 6
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_pkey
-- spans: FULL SCAN

-- Test 116: statement (line 1093)
SET plan_cache_mode = auto;

-- Test 117: statement (line 1096)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a - b FROM abc WHERE b = _',
  'SELECT a - b FROM abc@abc_pkey WHERE b = _'
);

-- Test 118: statement (line 1102)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 119: statement (line 1108)
PREPARE p6 AS SELECT a - b FROM abc WHERE b = $1;

-- Test 120: statement (line 1111)
EXECUTE p6 (5);

-- Test 121: statement (line 1114)
EXECUTE p6 (6);

-- Test 122: statement (line 1117)
EXECUTE p6 (7);

-- Test 123: statement (line 1120)
EXECUTE p6 (8);

-- Test 124: statement (line 1123)
EXECUTE p6 (9);

-- Test 125: statement (line 1126)
EXECUTE p6 (10);

-- Test 126: statement (line 1129)
EXECUTE p6 (11);

-- Test 127: query (line 1153)
EXPLAIN ANALYZE EXECUTE p6 (11);

-- Test 128: statement (line 1160)
-- regions: <hidden>
-- ·
-- • render
-- │
-- └── • filter
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ filter: b = 11
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_pkey
-- spans: FULL SCAN

-- Test 129: statement (line 1183)
RESET plan_cache_mode;

-- Test 130: statement (line 1186)
DEALLOCATE ALL;

-- Test 131: statement (line 1191)
SELECT information_schema.crdb_rewrite_inline_hints(
  'foo',
  'SELECT a FROM ab'
);

-- Test 132: statement (line 1197)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a FROM ab',
  'foo'
);

-- Test 133: statement (line 1203)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a FROM ab',
  'SELECT b FROM ab'
);

-- Test 134: statement (line 1209)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a FROM ab WHERE b = 5',
  'SELECT a FROM ab WHERE b = $1'
);

-- Test 135: statement (line 1215)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT a FROM ab WHERE b = 5',
  'SELECT a FROM ab WHERE b = _'
);

-- Test 136: statement (line 1221)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT b FROM ab WHERE a = $1',
  'SELECT b FROM ab WHERE a = _'
);

-- Test 137: query (line 1231)
EXPLAIN SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 138: statement (line 1246)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT y FROM abc JOIN xy ON x = b WHERE a = _',
  'SELECT y FROM abc INNER HASH JOIN xy ON x = b WHERE a = _'
);

-- Test 139: statement (line 1252)
SELECT crdb_internal.await_statement_hints_cache();

-- onlyif config local

-- Test 140: query (line 1256)
EXPLAIN SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 141: statement (line 1260)
-- ·
-- • hash join
-- │ equality: (b) = (x)
-- │ left cols are key
-- │ right cols are key
-- │
-- ├── • scan
-- │     missing stats
-- │     table: abc@abc_pkey
-- │     spans: [/10 - /10]
-- │
-- └── • scan
-- missing stats
-- table: xy@xy_pkey
-- spans: FULL SCAN

-- onlyif config local

-- Test 142: query (line 1278)
EXPLAIN ANALYZE SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 143: statement (line 1285)
-- rows decoded from KV: 1 (8 B, 2 KVs, 1 gRPC calls);
-- regions: <hidden>
-- ·
-- • hash join
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ equality: (b) = (x)
-- │ left cols are key
-- │ right cols are key
-- │
-- ├── • scan
-- │     sql nodes: <hidden>
-- │     kv nodes: <hidden>
-- │     regions: <hidden>
-- │     KV time: 0µs
-- │     KV rows decoded: 0
-- │     actual row count: 0
-- │     missing stats
-- │     table: abc@abc_pkey
-- │     spans: [/10 - /10]
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 1
-- actual row count: 1
-- missing stats
-- table: xy@xy_pkey
-- spans: FULL SCAN

-- Test 144: statement (line 1320)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT y FROM abc JOIN xy ON x = b WHERE a = _',
  'SELECT y FROM abc@abc_b_idx JOIN xy ON x = b WHERE a = _'
);

-- Test 145: statement (line 1326)
SELECT crdb_internal.await_statement_hints_cache();

-- onlyif config local

-- Test 146: query (line 1330)
EXPLAIN SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 147: statement (line 1334)
-- ·
-- • lookup join
-- │ table: xy@xy_pkey
-- │ equality: (b) = (x)
-- │ equality cols are key
-- │
-- └── • filter
-- │ filter: a = 10
-- │
-- └── • scan
-- missing stats
-- table: abc@abc_b_idx
-- spans: FULL SCAN

-- onlyif config local

-- Test 148: query (line 1350)
EXPLAIN ANALYZE SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 149: statement (line 1357)
-- regions: <hidden>
-- ·
-- • lookup join (streamer)
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ KV time: 0µs
-- │ KV rows decoded: 0
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ table: xy@xy_pkey
-- │ equality: (b) = (x)
-- │ equality cols are key
-- │
-- └── • filter
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ filter: a = 10
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_b_idx
-- spans: FULL SCAN

-- Test 150: statement (line 1392)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT y FROM abc JOIN xy ON x = b WHERE a = _',
  'SELECT y FROM abc JOIN xy@xy_z_idx ON x = b WHERE a = _'
);

-- Test 151: statement (line 1398)
SELECT crdb_internal.await_statement_hints_cache();

-- Test 152: statement (line 1404)
SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 153: query (line 1421)
EXPLAIN SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 154: statement (line 1425)
-- ·
-- • lookup join
-- │ table: xy@xy_pkey
-- │ equality: (b) = (x)
-- │ equality cols are key
-- │
-- └── • scan
-- missing stats
-- table: abc@abc_pkey
-- spans: [/10 - /10]

-- onlyif config local

-- Test 155: query (line 1438)
EXPLAIN ANALYZE SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 156: statement (line 1445)
-- regions: <hidden>
-- ·
-- • lookup join (streamer)
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ KV time: 0µs
-- │ KV rows decoded: 0
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ table: xy@xy_pkey
-- │ equality: (b) = (x)
-- │ equality cols are key
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 0
-- actual row count: 0
-- missing stats
-- table: abc@abc_pkey
-- spans: [/10 - /10]

-- Test 157: statement (line 1473)
BEGIN;

-- Test 158: statement (line 1476)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT y FROM abc JOIN xy ON x = b WHERE a = _',
  'SELECT y FROM abc JOIN xy@xy_y_idx ON x = b WHERE a = _'
);

-- Test 159: statement (line 1482)
SELECT information_schema.crdb_rewrite_inline_hints(
  'SELECT y FROM abc JOIN xy ON x = b WHERE a = _',
  'SELECT y FROM abc INNER MERGE JOIN xy ON x = b WHERE a = _'
);

-- Test 160: statement (line 1488)
COMMIT;

-- Test 161: statement (line 1491)
SELECT crdb_internal.await_statement_hints_cache();

-- onlyif config local

-- Test 162: query (line 1495)
EXPLAIN SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 163: statement (line 1499)
-- ·
-- • merge join
-- │ equality: (b) = (x)
-- │ left cols are key
-- │ right cols are key
-- │
-- ├── • scan
-- │     missing stats
-- │     table: abc@abc_pkey
-- │     spans: [/10 - /10]
-- │
-- └── • scan
-- missing stats
-- table: xy@xy_pkey
-- spans: FULL SCAN

-- onlyif config local

-- Test 164: query (line 1517)
EXPLAIN ANALYZE SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 165: statement (line 1524)
-- rows decoded from KV: 1 (8 B, 2 KVs, 1 gRPC calls);
-- regions: <hidden>
-- ·
-- • merge join
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ equality: (b) = (x)
-- │ left cols are key
-- │ right cols are key
-- │
-- ├── • scan
-- │     sql nodes: <hidden>
-- │     kv nodes: <hidden>
-- │     regions: <hidden>
-- │     KV time: 0µs
-- │     KV rows decoded: 0
-- │     actual row count: 0
-- │     missing stats
-- │     table: abc@abc_pkey
-- │     spans: [/10 - /10]
-- │
-- └── • scan
-- sql nodes: <hidden>
-- kv nodes: <hidden>
-- regions: <hidden>
-- KV time: 0µs
-- KV rows decoded: 1
-- actual row count: 1
-- missing stats
-- table: xy@xy_pkey
-- spans: FULL SCAN

-- Test 166: statement (line 1561)
SELECT information_schema.crdb_rewrite_inline_hints('', '');

-- Test 167: statement (line 1564)
SELECT information_schema.crdb_rewrite_inline_hints('SELECT 1', 'SELECT 2; SELECT 3');

-- Test 168: statement (line 1571)
SELECT information_schema.crdb_rewrite_inline_hints('SELECT _', 'SELECT _');

-- user root

-- Test 169: statement (line 1576)
-- CockroachDB-only: GRANT SYSTEM REPAIRCLUSTER TO testuser

-- user testuser

-- Test 170: statement (line 1581)
SELECT information_schema.crdb_rewrite_inline_hints('SELECT _', 'SELECT _');

-- user root

-- Test 171: query (line 1588)
SELECT crdb_internal.inject_hint(
  'SELECT * FROM abc JOIN (SELECT i FROM generate_series(_, _) g(i)) ON b = i',
  'SELECT * FROM abc INNER MERGE JOIN (SELECT i FROM generate_series(_, _) g(i)) ON b = i'
);

-- Test 172: query (line 1597)
-- CockroachDB-only: SHOW STATEMENT HINTS FOR ...
-- SELECT fingerprint, hint_type
-- FROM [SHOW STATEMENT HINTS FOR 'SELECT * FROM abc JOIN (SELECT i FROM ROWS FROM (generate_series(_, _)) AS g (i)) ON b = i'];

-- Test 173: statement (line 1603)
SELECT crdb_internal.await_statement_hints_cache();

-- onlyif config local

-- Test 174: query (line 1607)
EXPLAIN
SELECT * FROM abc
JOIN (SELECT i FROM generate_series(1, 1) g(i))
ON b = i;

-- Test 175: statement (line 1614)
-- ·
-- • merge join
-- │ equality: (b) = (generate_series)
-- │
-- ├── • sort
-- │   │ order: +b
-- │   │
-- │   └── • scan
-- │         missing stats
-- │         table: abc@abc_pkey
-- │         spans: FULL SCAN
-- │
-- └── • sort
-- │ estimated row count: 10
-- │ order: +generate_series
-- │
-- └── • project set
-- │ estimated row count: 10
-- │
-- └── • emptyrow

-- onlyif config local

-- Test 176: query (line 1637)
EXPLAIN ANALYZE
SELECT * FROM abc
JOIN (SELECT i FROM generate_series(1, 1) g(i))
ON b = i;

-- Test 177: statement (line 1647)
-- regions: <hidden>
-- ·
-- • merge join
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 0
-- │ equality: (b) = (generate_series)
-- │
-- ├── • sort
-- │   │ sql nodes: <hidden>
-- │   │ regions: <hidden>
-- │   │ execution time: 0µs
-- │   │ actual row count: 0
-- │   │ order: +b
-- │   │
-- │   └── • scan
-- │         sql nodes: <hidden>
-- │         kv nodes: <hidden>
-- │         regions: <hidden>
-- │         KV time: 0µs
-- │         KV rows decoded: 0
-- │         actual row count: 0
-- │         missing stats
-- │         table: abc@abc_pkey
-- │         spans: FULL SCAN
-- │
-- └── • sort
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 1
-- │ estimated row count: 10
-- │ order: +generate_series
-- │
-- └── • project set
-- │ sql nodes: <hidden>
-- │ regions: <hidden>
-- │ execution time: 0µs
-- │ actual row count: 1
-- │ estimated row count: 10
-- │
-- └── • emptyrow
-- sql nodes: <hidden>
-- regions: <hidden>
-- execution time: 0µs
-- actual row count: 1

-- Test 178: query (line 1698)
SELECT value > 0
FROM crdb_internal.node_metrics
WHERE name = 'sql.query.with_statement_hints.count';

-- Test 179: statement (line 1710)
SELECT y FROM abc JOIN xy ON x = b WHERE a = 10;

-- Test 180: query (line 1713)
SELECT value::int > 0
FROM crdb_internal.node_metrics
WHERE name = 'sql.query.with_statement_hints.count';
