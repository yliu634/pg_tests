-- PostgreSQL compatible tests from workload_indexrecs
-- 27 tests

SET client_min_messages = warning;

-- PostgreSQL setup: stub out CockroachDB system schemas/functions referenced in this test.
CREATE SCHEMA IF NOT EXISTS system;

CREATE TABLE system.users (
  username TEXT PRIMARY KEY,
  "hashedPassword" TEXT,
  "isRole" BOOL,
  user_id INT
);

CREATE TABLE system.statement_statistics (
  index_recommendations TEXT[],
  aggregated_ts TIMESTAMPTZ,
  fingerprint_id BIGINT,
  transaction_fingerprint_id BIGINT,
  plan_hash TEXT,
  app_name TEXT,
  node_id INT,
  agg_interval INTERVAL,
  metadata TEXT,
  statistics JSONB,
  plan TEXT
);

-- Minimal CockroachDB `workload_index_recs` shim:
-- - Expand index recommendations per statement fingerprint
-- - Group recommendations across fingerprints
-- - Optionally filter by `statistics.statistics.lastExecAt`
CREATE OR REPLACE FUNCTION workload_index_recs(since_ts TIMESTAMPTZ DEFAULT NULL)
RETURNS TABLE(index_rec TEXT, fingerprint_ids BIGINT[])
LANGUAGE SQL
STABLE
AS $$
  WITH filtered AS (
    SELECT
      unnest(index_recommendations) AS index_rec,
      fingerprint_id
    FROM system.statement_statistics
    WHERE $1 IS NULL
       OR COALESCE((statistics->'statistics'->>'lastExecAt')::timestamptz, aggregated_ts) >= $1
  )
  SELECT
    index_rec,
    array_agg(fingerprint_id ORDER BY fingerprint_id) AS fingerprint_ids
  FROM filtered
  GROUP BY index_rec
  ORDER BY index_rec;
$$;

-- Workload table referenced by index DDL below.
CREATE TABLE t1 (k INT, i INT);

-- Test 1: statement (line 4)
INSERT INTO system.users (username, "hashedPassword", "isRole", user_id)
VALUES ('node', NULL, true, 3);

-- Test 2: statement (line 7)
-- CockroachDB-only: GRANT NODE TO root;

-- Test 3: statement (line 15)
INSERT INTO system.statement_statistics (
  index_recommendations,
  aggregated_ts,
  fingerprint_id,
  transaction_fingerprint_id,
  plan_hash,
  app_name,
  node_id,
  agg_interval,
  metadata,
  statistics,
  plan
)
VALUES (
  ARRAY['creation : CREATE INDEX t1_k ON t1(k)'],
  '2023-07-05 15:10:11+00:00',
  x'0000000000000001'::bit(64)::bigint,
  x'0000000000000011'::bit(64)::bigint,
  'ph_1',
  'app_1',
  1,
  '1 hr',
  'null',
  '{"statistics": {"lastExecAt" : "2023-07-05 15:10:10+00:00"}}'::JSONB,
  'null'
);

-- Test 4: query (line 44)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs() order by index_rec;

-- Test 5: query (line 55)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs('2023-07-05 15:10:10+00:00'::TIMESTAMPTZ - '2 weeks'::interval) order by index_rec;

-- Test 6: statement (line 66)
CREATE INDEX t1_i ON t1(i);

-- Test 7: statement (line 69)
INSERT INTO system.statement_statistics (
  index_recommendations,
  aggregated_ts,
  fingerprint_id,
  transaction_fingerprint_id,
  plan_hash,
  app_name,
  node_id,
  agg_interval,
  metadata,
  statistics,
  plan
)
VALUES (
  ARRAY['replacement : CREATE INDEX t1_i2 ON t1(i) storing (k); DROP INDEX t1_i;'],
  '2023-07-05 15:10:12+00:00',
  x'0000000000000002'::bit(64)::bigint,
  x'0000000000000012'::bit(64)::bigint,
  'ph_2',
  'app_2',
  2,
  '1 hr',
  'null',
  '{"statistics": {"lastExecAt" : "2023-06-15 15:10:10+00:00"}}'::JSONB,
  'null'
);

-- Test 8: query (line 98)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs() order by index_rec;

-- Test 9: query (line 112)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs('2023-07-05 15:10:10+00:00'::TIMESTAMPTZ - '2 weeks'::interval) order by index_rec;

-- Test 10: statement (line 123)
INSERT INTO system.statement_statistics (
  index_recommendations,
  aggregated_ts,
  fingerprint_id,
  transaction_fingerprint_id,
  plan_hash,
  app_name,
  node_id,
  agg_interval,
  metadata,
  statistics,
  plan
)
VALUES (
  ARRAY['alteration : ALTER INDEX t1_i NOT VISIBLE'],
  '2023-07-05 15:10:13+00:00',
  x'0000000000000003'::bit(64)::bigint,
  x'0000000000000013'::bit(64)::bigint,
  'ph_3',
  'app_3',
  3,
  '1 hr',
  'null',
  '{"statistics": {"lastExecAt" : "2023-06-29 15:10:10+00:00"}}'::JSONB,
  'null'
);

-- Test 11: query (line 152)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs() order by index_rec;

-- Test 12: query (line 166)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs('2023-07-05 15:10:10+00:00'::TIMESTAMPTZ - '2 weeks'::interval) order by index_rec;

-- Test 13: statement (line 177)
INSERT INTO system.statement_statistics (
  index_recommendations,
  aggregated_ts,
  fingerprint_id,
  transaction_fingerprint_id,
  plan_hash,
  app_name,
  node_id,
  agg_interval,
  metadata,
  statistics,
  plan
)
VALUES (
  ARRAY['creation : CREATE INDEX t1_k_i ON t1(k, i)'],
  '2023-07-05 15:10:14+00:00',
  x'0000000000000004'::bit(64)::bigint,
  x'0000000000000014'::bit(64)::bigint,
  'ph_4',
  'app_4',
  4,
  '1 hr',
  'null',
  '{"statistics": {"lastExecAt" : "2023-07-05 15:10:10+00:00"}}'::JSONB,
  'null'
);

-- Test 14: query (line 206)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs() order by index_rec;

-- Test 15: query (line 220)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs('2023-07-05 15:10:10+00:00'::TIMESTAMPTZ - '2 weeks'::interval) order by index_rec;

-- Test 16: statement (line 231)
INSERT INTO system.statement_statistics (
  index_recommendations,
  aggregated_ts,
  fingerprint_id,
  transaction_fingerprint_id,
  plan_hash,
  app_name,
  node_id,
  agg_interval,
  metadata,
  statistics,
  plan
)
VALUES (
  ARRAY['creation : CREATE INDEX t1_k_i ON t1(i, k)'],
  '2023-07-05 15:10:15+00:00',
  x'0000000000000005'::bit(64)::bigint,
  x'0000000000000015'::bit(64)::bigint,
  'ph_5',
  'app_5',
  5,
  '1 hr',
  'null',
  '{"statistics": {"lastExecAt" : "2023-07-05 15:10:10+00:00"}}'::JSONB,
  'null'
);

-- Test 17: query (line 260)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs() order by index_rec;

-- Test 18: query (line 274)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs('2023-07-05 15:10:10+00:00'::TIMESTAMPTZ - '2 weeks'::interval) order by index_rec;

-- Test 19: statement (line 286)
INSERT INTO system.statement_statistics (
  index_recommendations,
  aggregated_ts,
  fingerprint_id,
  transaction_fingerprint_id,
  plan_hash,
  app_name,
  node_id,
  agg_interval,
  metadata,
  statistics,
  plan
)
VALUES (
  ARRAY['replacement : CREATE INDEX t1_i2 ON t1(i) storing (k); DROP INDEX t1_i;'],
  '2023-07-05 15:10:16+00:00',
  x'0000000000000006'::bit(64)::bigint,
  x'0000000000000016'::bit(64)::bigint,
  'ph_6',
  'app_6',
  6,
  '1 hr',
  'null',
  '{"statistics": {"lastExecAt" : "2023-07-05 15:10:10+00:00"}}'::JSONB,
  'null'
);

-- Test 20: query (line 315)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs() order by index_rec;

-- Test 21: query (line 329)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs('2023-07-05 15:10:10+00:00'::TIMESTAMPTZ - '2 weeks'::interval) order by index_rec;

-- Test 22: statement (line 346)
INSERT INTO system.statement_statistics (
  index_recommendations,
  aggregated_ts,
  fingerprint_id,
  transaction_fingerprint_id,
  plan_hash,
  app_name,
  node_id,
  agg_interval,
  metadata,
  statistics,
  plan
)
VALUES (
  ARRAY['creation : CREATE INDEX t2_k ON t2(k) storing (i, f)', 'creation : CREATE INDEX t2_k_f ON t2(k, f)', 'creation : CREATE INDEX t2_k_i_s ON t2(k, i, s)'],
  '2023-07-05 15:10:17+00:00',
  x'0000000000000007'::bit(64)::bigint,
  x'0000000000000017'::bit(64)::bigint,
  'ph_7',
  'app_7',
  7,
  '1 hr',
  'null',
  '{"statistics": {"lastExecAt" : "2023-07-05 15:10:10+00:00"}}'::JSONB,
  'null'
);

-- Test 23: query (line 375)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs() order by index_rec;

-- Test 24: query (line 391)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs('2023-07-05 15:10:10+00:00'::TIMESTAMPTZ - '2 weeks'::interval) order by index_rec;

-- Test 25: statement (line 410)
INSERT INTO system.statement_statistics (
  index_recommendations,
  aggregated_ts,
  fingerprint_id,
  transaction_fingerprint_id,
  plan_hash,
  app_name,
  node_id,
  agg_interval,
  metadata,
  statistics,
  plan
)
VALUES (
  ARRAY['creation : CREATE INDEX t3_k_i_f ON t3(k, i, f)', 'creation : CREATE INDEX t3_k_i_s ON t3(k, i, s)', 'creation : CREATE INDEX t3_k1 ON t3(k) storing (i, f)'],
  '2023-07-05 15:10:18+00:00',
  x'0000000000000008'::bit(64)::bigint,
  x'0000000000000018'::bit(64)::bigint,
  'ph_8',
  'app_8',
  8,
  '1 hr',
  'null',
  '{"statistics": {"lastExecAt" : "2023-07-05 15:10:10+00:00"}}'::JSONB,
  'null'
);

-- Test 26: query (line 439)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs() order by index_rec;

-- Test 27: query (line 457)
SELECT index_rec, (
    SELECT array_agg(n ORDER BY n)
    FROM unnest(fingerprint_ids) AS n
  ) AS sorted_fp
FROM workload_index_recs('2023-07-05 15:10:10+00:00'::TIMESTAMPTZ - '2 weeks'::interval) order by index_rec;
