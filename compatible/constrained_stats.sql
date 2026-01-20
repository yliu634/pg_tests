-- PostgreSQL compatible tests from constrained_stats
-- 59 tests

SET client_min_messages = warning;

-- Setup: emulate CockroachDB "constrained statistics" using a simple table of
-- computed counts. PostgreSQL does not support `CREATE STATISTICS ... WHERE ...`.
CREATE SCHEMA IF NOT EXISTS crdb_internal;
CREATE OR REPLACE FUNCTION crdb_internal.clear_table_stats_cache()
RETURNS INT
LANGUAGE SQL
AS $$ SELECT 0 $$;

CREATE TABLE products (
  id INT PRIMARY KEY,
  category_id INT,
  price NUMERIC(10, 2),
  status TEXT,
  created_at DATE
);

CREATE TABLE pg_constrained_stats (
  table_name TEXT NOT NULL,
  statistics_name TEXT NOT NULL,
  column_names TEXT[] NOT NULL,
  row_count BIGINT NOT NULL,
  distinct_count BIGINT NOT NULL,
  null_count BIGINT NOT NULL,
  partial_predicate TEXT NOT NULL,
  PRIMARY KEY (table_name, statistics_name)
);

-- Test 1: statement (line 4)
-- CockroachDB-only cluster setting (no PostgreSQL equivalent).
-- SET CLUSTER SETTING jobs.registry.interval.adopt = '10ms';

-- Test 2: statement (line 22)
INSERT INTO products VALUES
  (1, 1, 10.00, 'active', '2025-01-01'),
  (2, 1, 15.00, 'active', '2025-01-02'),
  (3, 2, 20.00, 'inactive', '2025-01-03'),
  (4, 2, 25.00, 'active', '2025-01-04'),
  (5, 3, 30.00, 'inactive', '2025-01-05'),
  (6, 1, 35.00, 'active', '2025-01-06'),
  (7, 2, 40.00, 'active', '2025-01-07'),
  (8, 3, 45.00, 'inactive', '2025-01-08'),
  (9, 1, 50.00, 'active', '2025-01-09'),
  (10, 2, 55.00, 'active', '2025-01-10');

-- Test 3: statement (line 35)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'full_stat';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'full_stat',
  ARRAY[]::TEXT[],
  COUNT(*),
  0,
  0,
  ''
FROM products;

-- Test 4: statement (line 40)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 5: statement (line 44)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_expensive_products';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_expensive_products',
  ARRAY['price'],
  COUNT(*),
  COUNT(DISTINCT price),
  COUNT(*) FILTER (WHERE price IS NULL),
  'price > 30.00'
FROM products
WHERE price > 30.00;

-- Test 6: query (line 47)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'products'
  AND statistics_name = 'stat_expensive_products';

-- Test 7: query (line 58)
-- Approximation of `SHOW HISTOGRAM` for the constrained set.
SELECT price, COUNT(*) AS freq
FROM products
WHERE price > 30.00
GROUP BY price
ORDER BY price;

-- Test 8: statement (line 68)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_active_products';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_active_products',
  ARRAY['status'],
  COUNT(*),
  COUNT(DISTINCT status),
  COUNT(*) FILTER (WHERE status IS NULL),
  $$status = 'active'$$
FROM products
WHERE status = 'active';

-- Test 9: query (line 71)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'products'
  AND statistics_name = 'stat_active_products';

-- Test 10: statement (line 79)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_mid_range_products';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_mid_range_products',
  ARRAY['category_id'],
  COUNT(*),
  COUNT(DISTINCT category_id),
  COUNT(*) FILTER (WHERE category_id IS NULL),
  'category_id BETWEEN 1 AND 2'
FROM products
WHERE category_id BETWEEN 1 AND 2;

-- Test 11: query (line 82)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'products'
  AND statistics_name = 'stat_mid_range_products';

-- Test 12: statement (line 91)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_multi_col';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_multi_col',
  ARRAY['category_id', 'price'],
  COUNT(*),
  COUNT(DISTINCT (category_id, price)),
  COUNT(*) FILTER (WHERE category_id IS NULL OR price IS NULL),
  $$status = 'active'$$
FROM products
WHERE status = 'active';

-- Test 13: statement (line 94)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_multi_outer_col';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_multi_outer_col',
  ARRAY['price'],
  COUNT(*),
  COUNT(DISTINCT price),
  COUNT(*) FILTER (WHERE price IS NULL),
  $$status = 'active' AND price > 20.00$$
FROM products
WHERE status = 'active' AND price > 20.00;

-- Test 14: statement (line 97)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_wrong_col';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_wrong_col',
  ARRAY['price'],
  COUNT(*),
  COUNT(DISTINCT price),
  COUNT(*) FILTER (WHERE price IS NULL),
  'category_id = 1'
FROM products
WHERE category_id = 1;

-- Test 15: statement (line 100)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_contradiction';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_contradiction',
  ARRAY['price'],
  COUNT(*),
  COUNT(DISTINCT price),
  COUNT(*) FILTER (WHERE price IS NULL),
  'price < 10 AND price > 10'
FROM products
WHERE price < 10 AND price > 10;

-- Test 16: statement (line 103)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_created_at';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_created_at',
  ARRAY['created_at'],
  COUNT(*),
  COUNT(DISTINCT created_at),
  COUNT(*) FILTER (WHERE created_at IS NULL),
  $$created_at > '2025-01-05'$$
FROM products
WHERE created_at > '2025-01-05';

-- Test 17: statement (line 106)
-- Expected ERROR (column does not exist):
\set ON_ERROR_STOP 0
SELECT count(*) FROM products WHERE nonexistent > 10;
\set ON_ERROR_STOP 1

-- Test 18: statement (line 109)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_subquery';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_subquery',
  ARRAY['category_id'],
  COUNT(*),
  COUNT(DISTINCT category_id),
  COUNT(*) FILTER (WHERE category_id IS NULL),
  'category_id IN (SELECT id FROM products ORDER BY id LIMIT 1)'
FROM products
WHERE category_id IN (SELECT id FROM products ORDER BY id LIMIT 1);

-- Test 19: statement (line 112)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_func';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_func',
  ARRAY['status'],
  COUNT(*),
  COUNT(DISTINCT status),
  COUNT(*) FILTER (WHERE status IS NULL),
  'length(status) > 6'
FROM products
WHERE length(status) > 6;

-- Test 20: statement (line 115)
-- Re-create with the same name (emulated as a replace).
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_func';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_func',
  ARRAY['price'],
  COUNT(*),
  COUNT(DISTINCT price),
  COUNT(*) FILTER (WHERE price IS NULL),
  'price < 20.00 OR price > 30.00'
FROM products
WHERE price < 20.00 OR price > 30.00;

-- Test 21: statement (line 118)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_specific_categories';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_specific_categories',
  ARRAY['category_id'],
  COUNT(*),
  COUNT(DISTINCT category_id),
  COUNT(*) FILTER (WHERE category_id IS NULL),
  'category_id IN (1, 3)'
FROM products
WHERE category_id IN (1, 3);

-- Test 22: statement (line 121)
-- Expected ERROR (syntax error):
\set ON_ERROR_STOP 0
SELECT * FROM products WHERE price >;
\set ON_ERROR_STOP 1

-- Test 23: statement (line 124)
-- Expected ERROR (invalid numeric literal):
\set ON_ERROR_STOP 0
SELECT * FROM products WHERE price = 'invalid_number';
\set ON_ERROR_STOP 1

-- Test 24: statement (line 128)
INSERT INTO products VALUES (11, NULL, 60.00, 'active', '2025-01-11');

-- Test 25: statement (line 131)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_null_category';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_null_category',
  ARRAY['category_id'],
  COUNT(*),
  COUNT(DISTINCT category_id),
  COUNT(*) FILTER (WHERE category_id IS NULL),
  'category_id IS NULL'
FROM products
WHERE category_id IS NULL;

-- Test 26: query (line 134)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'products'
  AND statistics_name = 'stat_null_category';

-- Test 27: statement (line 142)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_not_null_category';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_not_null_category',
  ARRAY['category_id'],
  COUNT(*),
  COUNT(DISTINCT category_id),
  COUNT(*) FILTER (WHERE category_id IS NULL),
  'category_id IS NOT NULL'
FROM products
WHERE category_id IS NOT NULL;

-- Test 28: query (line 145)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'products'
  AND statistics_name = 'stat_not_null_category';

-- Test 29: statement (line 154)
ALTER TABLE products
  ADD COLUMN discount_price INT GENERATED ALWAYS AS (price::INT - 10) STORED;

-- Test 30: statement (line 157)
CREATE INDEX discount_idx ON products(discount_price DESC);

-- Test 31: statement (line 160)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'products_full';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'products_full',
  ARRAY[]::TEXT[],
  COUNT(*),
  0,
  0,
  ''
FROM products;

-- Test 32: statement (line 165)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 33: statement (line 168)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_discount';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_discount',
  ARRAY['discount_price'],
  COUNT(*),
  COUNT(DISTINCT discount_price),
  COUNT(*) FILTER (WHERE discount_price IS NULL),
  'discount_price > 30'
FROM products
WHERE discount_price > 30;

-- Test 34: query (line 171)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'products'
  AND statistics_name = 'stat_discount';

-- Test 35: statement (line 180)
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stat_empty';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stat_empty',
  ARRAY['price'],
  COUNT(*),
  COUNT(DISTINCT price),
  COUNT(*) FILTER (WHERE price IS NULL),
  'price > 1000.00'
FROM products
WHERE price > 1000.00;

-- Test 36: query (line 183)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'products'
  AND statistics_name = 'stat_empty';

-- Test 37: statement (line 194)
-- `[$products_t_id]` is a CockroachDB table-ID placeholder; use `products` in PG.
DELETE FROM pg_constrained_stats
WHERE table_name = 'products' AND statistics_name = 'stats_from_table_id';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'products',
  'stats_from_table_id',
  ARRAY['price'],
  COUNT(*),
  COUNT(DISTINCT price),
  COUNT(*) FILTER (WHERE price IS NULL),
  'price > 10'
FROM products
WHERE price > 10;

-- Test 38: query (line 197)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'products'
  AND statistics_name = 'stats_from_table_id';

-- Test 39: statement (line 206)
CREATE TABLE infer (
  x INT NOT NULL,
  y INT GENERATED ALWAYS AS (x % 5) STORED,
  PRIMARY KEY (y, x)
);

-- Test 40: statement (line 209)
DELETE FROM pg_constrained_stats
WHERE table_name = 'infer' AND statistics_name = 'inferred_stat';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'infer',
  'inferred_stat',
  ARRAY['x'],
  COUNT(*),
  COUNT(DISTINCT x),
  COUNT(*) FILTER (WHERE x IS NULL),
  'x = 100'
FROM infer
WHERE x = 100;

-- Test 41: statement (line 213)
CREATE TABLE partial_indexes (
  a INT,
  b INT
);
CREATE INDEX idx_partial ON partial_indexes (a) WHERE a > 5;

-- Test 42: statement (line 220)
INSERT INTO partial_indexes SELECT g, g FROM generate_series(1, 10) AS g;

-- Test 43: statement (line 223)
DELETE FROM pg_constrained_stats
WHERE table_name = 'partial_indexes' AND statistics_name = 'fullstat';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'partial_indexes',
  'fullstat',
  ARRAY[]::TEXT[],
  COUNT(*),
  0,
  0,
  ''
FROM partial_indexes;

-- Test 44: statement (line 228)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 45: statement (line 232)
DELETE FROM pg_constrained_stats
WHERE table_name = 'partial_indexes' AND statistics_name = 'partial_stat_implied';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'partial_indexes',
  'partial_stat_implied',
  ARRAY['a'],
  COUNT(*),
  COUNT(DISTINCT a),
  COUNT(*) FILTER (WHERE a IS NULL),
  'a > 7'
FROM partial_indexes
WHERE a > 7;

-- Test 46: query (line 235)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'partial_indexes'
  AND statistics_name = 'partial_stat_implied';

-- Test 47: statement (line 244)
DELETE FROM pg_constrained_stats
WHERE table_name = 'partial_indexes' AND statistics_name = 'partial_stat_exact';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'partial_indexes',
  'partial_stat_exact',
  ARRAY['a'],
  COUNT(*),
  COUNT(DISTINCT a),
  COUNT(*) FILTER (WHERE a IS NULL),
  'a > 5'
FROM partial_indexes
WHERE a > 5;

-- Test 48: query (line 247)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'partial_indexes'
  AND statistics_name = 'partial_stat_exact';

-- Test 49: statement (line 256)
DELETE FROM pg_constrained_stats
WHERE table_name = 'partial_indexes' AND statistics_name = 'partial_stat_not_implied';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'partial_indexes',
  'partial_stat_not_implied',
  ARRAY['a'],
  COUNT(*),
  COUNT(DISTINCT a),
  COUNT(*) FILTER (WHERE a IS NULL),
  'a > 3'
FROM partial_indexes
WHERE a > 3;

-- Test 50: statement (line 260)
CREATE INDEX idx_a ON partial_indexes (a);

-- Test 51: statement (line 263)
DELETE FROM pg_constrained_stats
WHERE table_name = 'partial_indexes' AND statistics_name = 'partial_stat_not_implied';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'partial_indexes',
  'partial_stat_not_implied',
  ARRAY['a'],
  COUNT(*),
  COUNT(DISTINCT a),
  COUNT(*) FILTER (WHERE a IS NULL),
  'a > 3'
FROM partial_indexes
WHERE a > 3;

-- Test 52: query (line 266)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM pg_constrained_stats
WHERE table_name = 'partial_indexes'
  AND statistics_name = 'partial_stat_not_implied';

-- Test 53: statement (line 275)
DROP INDEX idx_partial;

-- Test 54: statement (line 278)
DROP INDEX idx_a;

-- Test 55: statement (line 281)
CREATE INDEX idx_b ON partial_indexes (b) WHERE a > 5;

-- Test 56: statement (line 284)
DELETE FROM pg_constrained_stats
WHERE table_name = 'partial_indexes' AND statistics_name = 'partial_stat_implied';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'partial_indexes',
  'partial_stat_implied',
  ARRAY['a'],
  COUNT(*),
  COUNT(DISTINCT a),
  COUNT(*) FILTER (WHERE a IS NULL),
  'a > 7'
FROM partial_indexes
WHERE a > 7;

-- Test 57: statement (line 287)
DROP INDEX idx_b;

-- Test 58: statement (line 292)
CREATE INDEX idx_b ON partial_indexes (b) WHERE b > 1 AND b % 2 = 0;

-- Test 59: statement (line 295)
DELETE FROM pg_constrained_stats
WHERE table_name = 'partial_indexes' AND statistics_name = 'partial_stat_implied';
INSERT INTO pg_constrained_stats (
  table_name, statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
)
SELECT
  'partial_indexes',
  'partial_stat_implied',
  ARRAY['b'],
  COUNT(*),
  COUNT(DISTINCT b),
  COUNT(*) FILTER (WHERE b IS NULL),
  'b > 1 AND b % 2 = 0'
FROM partial_indexes
WHERE b > 1 AND b % 2 = 0;

RESET client_min_messages;
