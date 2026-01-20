SET client_min_messages = warning;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS privs CASCADE;
DROP VIEW IF EXISTS v CASCADE;
RESET client_min_messages;

-- PostgreSQL compatible tests from create_index;
-- 116 tests;

-- Test 1: statement (line 2);
CREATE TABLE t (;
  a INT PRIMARY KEY,;
  b INT,;
  ,;
  ;
);

-- Test 2: statement (line 10);
INSERT INTO t VALUES (1,1);

-- user root;

-- Test 3: statement (line 15);
CREATE INDEX foo ON t (b);

-- Test 4: statement (line 18);
CREATE INDEX foo ON t (a);

-- Test 5: statement (line 21);
CREATE INDEX bar ON t (c);

-- Test 6: statement (line 24);
CREATE INDEX bar ON t (b, b);

-- Test 7: query (line 27);
SHOW INDEXES FROM t;

-- Test 8: statement (line 36);
INSERT INTO t VALUES (2,1);

-- Test 9: statement (line 39);
CREATE UNIQUE INDEX bar ON t (b);

-- Test 10: query (line 42);
SHOW INDEXES FROM t;

-- Test 11: statement (line 53);
DROP TABLE t;

-- Test 12: statement (line 56);
CREATE TABLE t (;
  a INT PRIMARY KEY,;
  b INT,;
  c INT;
);

-- Test 13: statement (line 63);
INSERT INTO t VALUES (1,1,1), (2,2,2);

-- Test 14: statement (line 66);
CREATE INDEX b_desc ON t (b DESC);

-- Test 15: statement (line 69);
CREATE INDEX b_asc ON t (b ASC, c DESC);

-- Test 16: query (line 72);
SHOW INDEXES FROM t;

-- Test 17: statement (line 85);
CREATE INDEX fail ON foo (b DESC);

-- Test 18: statement (line 88);
CREATE VIEW v AS SELECT a,b FROM t;

-- Test 19: statement (line 91);
CREATE INDEX failview ON v (b DESC);

-- Test 20: statement (line 94);
CREATE TABLE privs (a INT PRIMARY KEY, b INT);

-- user testuser;

-- skipif config local-legacy-schema-changer;

-- Test 21: statement (line 100);
CREATE INDEX foo ON privs (b);

-- onlyif config local-legacy-schema-changer;

-- Test 22: statement (line 104);
CREATE INDEX foo ON privs (b);


-- user root;

-- Test 23: query (line 110);
SHOW INDEXES FROM privs;

-- Test 24: statement (line 117);
GRANT CREATE ON privs TO testuser;

-- user testuser;

-- Test 25: statement (line 122);
CREATE INDEX foo ON privs (b);

-- Test 26: query (line 125);
SHOW INDEXES FROM privs;

-- Test 27: statement (line 137);
CREATE TABLE telemetry (;
  x INT PRIMARY KEY,;
  y INT,;
  z JSONB,;
  v VECTOR(3);
);

-- Test 28: statement (line 145);
CREATE INVERTED INDEX ON telemetry (z);
CREATE VECTOR INDEX ON telemetry (v);
CREATE INDEX ON telemetry (y) USING HASH WITH (bucket_count=4);

-- Test 29: query (line 150);
SELECT feature_name FROM crdb_internal.feature_usage;
WHERE feature_name IN (;
  'sql.schema.inverted_index',;
  'sql.schema.vector_index',;
  'sql.schema.hash_sharded_index';
);

-- Test 30: statement (line 164);
CREATE TABLE create_index_concurrently_tbl (a int);

-- onlyif config weak-iso-level-configs;

-- Test 31: statement (line 168);
CREATE INDEX CONCURRENTLY create_index_concurrently_idx ON create_index_concurrently_tbl(a);

-- Test 32: query (line 173);
CREATE INDEX CONCURRENTLY create_index_concurrently_idx ON create_index_concurrently_tbl(a);

-- Test 33: query (line 180);
CREATE INDEX CONCURRENTLY IF NOT EXISTS create_index_concurrently_idx ON create_index_concurrently_tbl(a);

-- Test 34: query (line 185);
SHOW CREATE TABLE create_index_concurrently_tbl;

-- Test 35: query (line 196);
SHOW CREATE TABLE create_index_concurrently_tbl;

-- Test 36: query (line 208);
DROP INDEX CONCURRENTLY create_index_concurrently_idx;

-- Test 37: query (line 217);
DROP INDEX CONCURRENTLY IF EXISTS create_index_concurrently_idx;

-- Test 38: statement (line 223);
DROP INDEX CONCURRENTLY create_index_concurrently_idx;

-- onlyif config schema-locked-disabled;

-- Test 39: query (line 227);
SHOW CREATE TABLE create_index_concurrently_tbl;

-- Test 40: query (line 237);
SHOW CREATE TABLE create_index_concurrently_tbl;

-- Test 41: statement (line 246);
DROP TABLE create_index_concurrently_tbl;

-- Test 42: statement (line 253);
CREATE TABLE create_idx_drop_column (c0 INT PRIMARY KEY, c1 INT);

-- Test 43: statement (line 256);
begin; ALTER TABLE create_idx_drop_column DROP COLUMN c1;

-- Test 44: statement (line 259);
CREATE INDEX idx_create_idx_drop_column ON create_idx_drop_column (c1);

-- Test 45: statement (line 262);
ROLLBACK;

-- Test 46: statement (line 265);
DROP TABLE create_idx_drop_column;

-- Test 47: statement (line 272);
CREATE TABLE "'t1-esc'"(name int);

-- Test 48: statement (line 275);
CREATE INDEX "'t1-esc-index'" ON "'t1-esc'"(name);

-- Test 49: statement (line 278);
CREATE INDEX "'t1-esc-index'" ON "'t1-esc'"(name);

-- Test 50: statement (line 288);
SET use_declarative_schema_changer = 'off';

-- Test 51: statement (line 291);
SET create_table_with_schema_locked=false;

-- Test 52: statement (line 294);
SET CLUSTER SETTING jobs.registry.interval.adopt = '50ms';

-- Test 53: statement (line 298);
SET CLUSTER SETTING jobs.registry.interval.cancel = '50ms';

-- Test 54: statement (line 301);
SET CLUSTER SETTING jobs.debug.pausepoints = 'indexbackfill.before_flow';

-- Test 55: statement (line 304);
CREATE TABLE tbl (i INT PRIMARY KEY, j INT NOT NULL);

-- Test 56: statement (line 307);
INSERT INTO tbl VALUES (1, 100), (2, 200), (3, 300);

-- Test 57: statement (line 310);
CREATE INDEX pauseidx ON tbl(j);

-- Test 58: statement (line 314);
RESET CLUSTER SETTING jobs.debug.pausepoints;

let $tab_id;
SELECT 'tbl'::regclass::int;

-- Test 59: statement (line 374);
UPDATE system.job_info;
  SET value = crdb_internal.json_to_pb(;
    'cockroach.sql.jobs.jobspb.Payload',;
      json_set(;
        crdb_internal.pb_to_json('cockroach.sql.jobs.jobspb.Payload', value),;
        ARRAY['schemaChange', 'resumeSpanList', '0'],;
        '{"resumeSpans": $spans}'::jsonb;
      );
    );
WHERE info_key = 'legacy_payload' AND crdb_internal.pb_to_json('cockroach.sql.jobs.jobspb.Payload', value)->>'description' LIKE 'CREATE INDEX pauseidx%';

-- Test 60: query (line 388);
SELECT;
  crdb_internal.pretty_key(decode(j->'schemaChange'->'resumeSpanList'->0->'resumeSpans'->0->>'key', 'base64'), 0),;
  crdb_internal.pretty_key(decode(j->'schemaChange'->'resumeSpanList'->0->'resumeSpans'->0->>'endKey', 'base64'), 0),;
  crdb_internal.pretty_key(decode(j->'schemaChange'->'resumeSpanList'->0->'resumeSpans'->1->>'key', 'base64'), 0),;
  crdb_internal.pretty_key(decode(j->'schemaChange'->'resumeSpanList'->0->'resumeSpans'->1->>'endKey', 'base64'), 0);
FROM (;
  SELECT crdb_internal.pb_to_json('cockroach.sql.jobs.jobspb.Payload', payload) j FROM crdb_internal.system_jobs;
) WHERE j->>'description' LIKE 'CREATE INDEX pauseidx%';

-- Test 61: statement (line 401);
RESUME JOB (SELECT job_id FROM crdb_internal.jobs WHERE description LIKE 'CREATE INDEX pauseidx%');

-- Test 62: query (line 404);
SELECT status FROM [SHOW JOB WHEN COMPLETE (SELECT job_id FROM crdb_internal.jobs WHERE description LIKE 'CREATE INDEX pauseidx%')];

-- Test 63: statement (line 409);
SET CLUSTER SETTING jobs.registry.interval.cancel = DEFAULT;

-- Test 64: statement (line 413);
SET use_declarative_schema_changer = $schema_changer_state;

-- Test 65: statement (line 416);
RESET create_table_with_schema_locked;

-- Test 66: statement (line 421);
CREATE TABLE t_hash (;
  pk INT PRIMARY KEY,;
  a INT,;
  b INT,;
  FAMILY fam_0_pk_a_b (pk, a, b);
);

-- Test 67: statement (line 429);
CREATE INDEX idx_t_hash_a ON t_hash (a) USING HASH WITH BUCKET_COUNT = 5;

-- Test 68: statement (line 432);
CREATE UNIQUE INDEX idx_t_hash_b ON t_hash (b) USING HASH WITH BUCKET_COUNT = 5;

-- onlyif config schema-locked-disabled;

-- Test 69: query (line 436);
SELECT create_statement FROM [SHOW CREATE TABLE t_hash];

-- Test 70: query (line 452);
SELECT create_statement FROM [SHOW CREATE TABLE t_hash];

-- Test 71: statement (line 467);
CREATE TABLE opclasses (a INT PRIMARY KEY, b TEXT, c JSON);

-- Test 72: statement (line 472);
CREATE INDEX ON opclasses(b blah_ops);

-- Test 73: statement (line 477);
CREATE INDEX ON opclasses(c blah_ops);

-- Test 74: statement (line 481);
CREATE INVERTED INDEX ON opclasses(c blah_ops);

-- Test 75: statement (line 486);
CREATE INVERTED INDEX ON opclasses(c DESC);

-- Test 76: statement (line 491);
CREATE INVERTED INDEX ON opclasses(a DESC, c);

-- Test 77: statement (line 500);
SET CLUSTER SETTING sql.defaults.disallow_full_table_scans.enabled = true;

-- Test 78: statement (line 503);
CREATE TABLE t_disable_full_ts (id UUID PRIMARY KEY);

-- Test 79: statement (line 506);
CREATE INDEX ON t_disable_full_ts (id);

-- Test 80: statement (line 509);
SET CLUSTER SETTING sql.defaults.disallow_full_table_scans.enabled = $disallow_full_table_scans;

-- Test 81: statement (line 512);
DROP TABLE t_disable_full_ts;

-- Test 82: statement (line 517);
DROP TABLE t CASCADE;
CREATE TABLE t (a INT PRIMARY KEY);
INSERT INTO t SELECT generate_series(0, 9);

-- Test 83: statement (line 522);
CREATE MATERIALIZED VIEW v (b) AS SELECT a * 2 FROM t WITH DATA;

-- Test 84: statement (line 525);
CREATE INDEX ON v (b);

-- Test 85: statement (line 531);
CREATE INDEX ON v ((b>0));

-- Test 86: statement (line 548);
CREATE INDEX tab_w0_7_i1 on tab_w0_7 (c2) STORING ("col\u000b7ͪ%q_w0_10");

-- Test 87: statement (line 551);
CREATE INDEX tab_w0_7_i1 on tab_w0_7 ("col\u000b7ͪ%q_w0_10") STORING ("col\u000b7ͪ%q_w0_10");

-- Test 88: statement (line 554);
CREATE INDEX tab_w0_7_i1 on tab_w0_7 (c2) STORING ("MixedCase");

-- Test 89: statement (line 557);
DROP TABLE tab_w0_7;

-- Test 90: statement (line 572);
CREATE INDEX tab1_i1 ON tab1 (c3) STORING (c2);

-- Test 91: statement (line 575);
DROP TABLE tab1;

-- Test 92: statement (line 581);
CREATE TABLE tbl_ifne (a INT PRIMARY KEY, b INT);

-- Test 93: statement (line 584);
CREATE INDEX idx ON tbl_ifne (b);

-- Test 94: statement (line 587);
CREATE INDEX invalid_idx ON tbl_ifne (b) STORING (a);

-- Test 95: statement (line 591);
CREATE INDEX IF NOT EXISTS idx ON tbl_ifne (b) STORING (a);

-- Test 96: statement (line 594);
DROP TABLE tbl_ifne CASCADE;

-- Test 97: statement (line 602);
SET CLUSTER SETTING sql.defaults.disallow_full_table_scans.enabled = true;

-- Test 98: statement (line 605);
CREATE TABLE t_disable_full_ts (id UUID PRIMARY KEY);

-- Test 99: statement (line 608);
CREATE INDEX ON t_disable_full_ts (id);

-- Test 100: statement (line 611);
SET CLUSTER SETTING sql.defaults.disallow_full_table_scans.enabled = $disallow_full_table_scans;

-- Test 101: statement (line 614);
DROP TABLE t_disable_full_ts;

-- Test 102: statement (line 621);
CREATE TABLE create_index_duplicate_storage_params_a (;
  a INT PRIMARY KEY,;
  b INT;
);

-- Test 103: statement (line 627);
CREATE INDEX idx_a ON create_index_duplicate_storage_params_a (b) WITH (fillfactor=10, fillfactor=20);

-- Test 104: statement (line 630);
CREATE INDEX IF NOT EXISTS idx_b ON create_index_duplicate_storage_params_a (b) WITH (fillfactor=10, fillfactor=20);

-- Test 105: statement (line 633);
CREATE INDEX ON create_index_duplicate_storage_params_a (b) USING HASH WITH (bucket_count=10, bucket_count=12);

-- Test 106: statement (line 640);
CREATE TABLE create_inverted_index_duplicate_storage_params_a (;
  a INT PRIMARY KEY,;
  b JSONB;
);

-- Test 107: statement (line 646);
CREATE INVERTED INDEX idx_a ON create_inverted_index_duplicate_storage_params_a (b) WITH (fillfactor=10, fillfactor=20);

-- Test 108: statement (line 649);
CREATE INVERTED INDEX IF NOT EXISTS idx_b ON create_inverted_index_duplicate_storage_params_a (b) WITH (fillfactor=10, fillfactor=20);

-- Test 109: statement (line 657);
CREATE TABLE tbl_with_collate (c1 int);

-- Test 110: statement (line 660);
CREATE UNIQUE INDEX tbl_with_collate_expr ON tbl_with_collate ((c1::text COLLATE "C"));

-- Test 111: statement (line 663);
CREATE UNIQUE INDEX tbl_with_collate_expr2 ON tbl_with_collate ((c1::text COLLATE "POSIX"));

-- Test 112: statement (line 666);
CREATE UNIQUE INDEX tbl_with_collate_expr3 ON tbl_with_collate ((c1::text COLLATE "en-us"));


-- onlyif config schema-locked-disabled;

-- Test 113: query (line 671);
SHOW CREATE TABLE tbl_with_collate;

-- Test 114: query (line 684);
SHOW CREATE TABLE tbl_with_collate;

-- Test 115: statement (line 701);
CREATE TABLE t_index_name_conflicts_with_primary_key (a INT PRIMARY KEY, b INT);

-- Test 116: statement (line 704);
CREATE INDEX t_index_name_conflicts_with_primary_key_pkey ON t_index_name_conflicts_with_primary_key (a);

