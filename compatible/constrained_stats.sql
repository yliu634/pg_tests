-- PostgreSQL compatible tests from constrained_stats
-- 59 tests (mostly Cockroach-specific constrained statistics)
-- PostgreSQL has extended statistics but not constrained statistics with WHERE clauses

SET client_min_messages = warning;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS infer CASCADE;
DROP TABLE IF EXISTS partial_indexes CASCADE;
RESET client_min_messages;

-- Test 1: statement (line 4)
-- SET CLUSTER SETTING jobs.registry.interval.adopt = '10ms'; - Cockroach-specific

-- Create products table
CREATE TABLE products (
    id INT PRIMARY KEY,
    category_id INT,
    price DECIMAL(10,2),
    status TEXT,
    created_at DATE
);

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
-- CREATE STATISTICS full_stat FROM products; - Cockroach syntax
-- PostgreSQL equivalent:
ANALYZE products;

-- Test 4: statement (line 40)
-- SELECT crdb_internal.clear_table_stats_cache(); - Cockroach-specific

-- Tests 5-38: CREATE STATISTICS with WHERE clauses are Cockroach-specific
-- PostgreSQL supports CREATE STATISTICS but not with WHERE predicates
-- Examples commented out:
-- CREATE STATISTICS stat_expensive_products ON price FROM products WHERE price > 30.00;
-- CREATE STATISTICS stat_active_products ON status FROM products WHERE status = 'active';

-- PostgreSQL does support extended statistics for correlation/dependencies:
CREATE STATISTICS products_multi_col ON category_id, price FROM products;

-- Test 24: statement (line 128)
INSERT INTO products VALUES (11, NULL, 60.00, 'active', '2025-01-11');

-- Test 29: statement (line 154)
ALTER TABLE products ADD COLUMN discount_price INT GENERATED ALWAYS AS (price::INT - 10) STORED;

-- Test 30: statement (line 157)
CREATE INDEX discount_idx ON products(discount_price DESC);

-- Test 31: statement (line 160)
-- Re-analyze after schema change
ANALYZE products;

-- Test 39: statement (line 206)
CREATE TABLE infer (x INT NOT NULL, y INT NOT NULL GENERATED ALWAYS AS (x % 5) STORED, PRIMARY KEY (y, x));

-- Test 40: statement (line 209)
-- CREATE STATISTICS inferred_stat ON x FROM infer WHERE x = 100; - Cockroach-specific

-- Test 41: statement (line 213)
CREATE TABLE partial_indexes (
    a INT,
    b INT
);

CREATE INDEX idx_partial ON partial_indexes (a) WHERE a > 5;

-- Test 42: statement (line 220)
INSERT INTO partial_indexes SELECT g, g FROM generate_series(1, 10) AS g;

-- Test 43: statement (line 223)
ANALYZE partial_indexes;

-- Tests 44-59: More constrained statistics tests - Cockroach-specific

-- Test 50: statement (line 260)
CREATE INDEX idx_a ON partial_indexes (a);

-- Test 53: statement (line 275)
DROP INDEX idx_partial;

-- Test 54: statement (line 278)
DROP INDEX idx_a;

-- Test 55: statement (line 281)
CREATE INDEX idx_b ON partial_indexes (b) WHERE a > 5;

-- Test 57: statement (line 287)
DROP INDEX idx_b;

-- Test 58: statement (line 292)
CREATE INDEX idx_b ON partial_indexes (b) WHERE b > 1 AND b % 2 = 0;

-- Summary: Most constrained statistics features are CockroachDB-specific.
-- PostgreSQL supports ANALYZE for statistics and CREATE STATISTICS for
-- extended statistics (correlation, dependencies, etc.) but not constrained
-- statistics with WHERE predicates.
