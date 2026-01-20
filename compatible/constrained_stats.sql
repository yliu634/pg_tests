-- PostgreSQL compatible tests from constrained_stats
-- 59 tests

-- Test 1: statement (line 4)
SET CLUSTER SETTING jobs.registry.interval.adopt = '10ms'

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
(10, 2, 55.00, 'active', '2025-01-10')

-- Test 3: statement (line 35)
CREATE STATISTICS full_stat FROM products;

-- Test 4: statement (line 40)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 5: statement (line 44)
CREATE STATISTICS stat_expensive_products ON price FROM products WHERE price > 30.00

-- Test 6: query (line 47)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE products]
WHERE statistics_name = 'stat_expensive_products'

-- Test 7: query (line 58)
SHOW HISTOGRAM $hist_stat_expensive_products

-- Test 8: statement (line 68)
CREATE STATISTICS stat_active_products ON status FROM products WHERE status = 'active'

-- Test 9: query (line 71)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE products]
WHERE statistics_name = 'stat_active_products'

-- Test 10: statement (line 79)
CREATE STATISTICS stat_mid_range_products ON category_id FROM products WHERE category_id BETWEEN 1 AND 2

-- Test 11: query (line 82)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE products]
WHERE statistics_name = 'stat_mid_range_products'

-- Test 12: statement (line 91)
CREATE STATISTICS stat_multi_col ON category_id, price FROM products WHERE status = 'active'

-- Test 13: statement (line 94)
CREATE STATISTICS stat_multi_outer_col ON price FROM products WHERE status = 'active' AND price > 20.00

-- Test 14: statement (line 97)
CREATE STATISTICS stat_wrong_col ON price FROM products WHERE category_id = 1

-- Test 15: statement (line 100)
CREATE STATISTICS stat_contradiction ON price FROM products WHERE price < 10 AND price > 10

-- Test 16: statement (line 103)
CREATE STATISTICS stat_created_at ON created_at FROM products WHERE created_at > '2025-01-05'

-- Test 17: statement (line 106)
CREATE STATISTICS stat_nonexistent ON price FROM products WHERE nonexistent > 10

-- Test 18: statement (line 109)
CREATE STATISTICS stat_subquery ON category_id FROM products WHERE category_id IN (SELECT id FROM products LIMIT 1)

-- Test 19: statement (line 112)
CREATE STATISTICS stat_func ON status FROM products WHERE length(status) > 6

-- Test 20: statement (line 115)
CREATE STATISTICS stat_func ON price FROM products WHERE price < 20.00 OR price > 30.00

-- Test 21: statement (line 118)
CREATE STATISTICS stat_specific_categories ON category_id FROM products WHERE category_id IN (1, 3)

-- Test 22: statement (line 121)
CREATE STATISTICS stat_error2 ON price FROM products WHERE price >

-- Test 23: statement (line 124)
CREATE STATISTICS stat_error3 ON price FROM products WHERE price = 'invalid_number'

-- Test 24: statement (line 128)
INSERT INTO products VALUES (11, NULL, 60.00, 'active', '2025-01-11')

-- Test 25: statement (line 131)
CREATE STATISTICS stat_null_category ON category_id FROM products WHERE category_id IS NULL

-- Test 26: query (line 134)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE products]
WHERE statistics_name = 'stat_null_category'

-- Test 27: statement (line 142)
CREATE STATISTICS stat_not_null_category ON category_id FROM products WHERE category_id IS NOT NULL

-- Test 28: query (line 145)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE products]
WHERE statistics_name = 'stat_not_null_category'

-- Test 29: statement (line 154)
ALTER TABLE products ADD COLUMN discount_price INT AS (price::INT - 10) STORED

-- Test 30: statement (line 157)
CREATE INDEX discount_idx ON products(discount_price DESC);

-- Test 31: statement (line 160)
CREATE STATISTICS products_full FROM products;

-- Test 32: statement (line 165)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 33: statement (line 168)
CREATE STATISTICS stat_discount ON discount_price FROM products WHERE discount_price > 30

-- Test 34: query (line 171)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE products]
WHERE statistics_name = 'stat_discount'

-- Test 35: statement (line 180)
CREATE STATISTICS stat_empty ON price FROM products WHERE price > 1000.00

-- Test 36: query (line 183)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE products]
WHERE statistics_name = 'stat_empty'

-- Test 37: statement (line 194)
CREATE STATISTICS stats_from_table_id ON price FROM [$products_t_id] WHERE price > 10

-- Test 38: query (line 197)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE products]
WHERE statistics_name = 'stats_from_table_id'

-- Test 39: statement (line 206)
CREATE TABLE infer (x INT NOT NULL, y INT NOT NULL AS (x % 5) STORED, PRIMARY KEY (y, x));

-- Test 40: statement (line 209)
CREATE STATISTICS inferred_stat ON x FROM infer WHERE x = 100;

-- Test 41: statement (line 213)
CREATE TABLE partial_indexes (
    a INT,
    b INT,
    INDEX idx_partial (a) WHERE a > 5
);

-- Test 42: statement (line 220)
INSERT INTO partial_indexes SELECT g, g FROM generate_series(1, 10) AS g;

-- Test 43: statement (line 223)
CREATE STATISTICS fullstat FROM partial_indexes;

-- Test 44: statement (line 228)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 45: statement (line 232)
CREATE STATISTICS partial_stat_implied ON a FROM partial_indexes WHERE a > 7;

-- Test 46: query (line 235)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE partial_indexes]
WHERE statistics_name = 'partial_stat_implied';

-- Test 47: statement (line 244)
CREATE STATISTICS partial_stat_exact ON a FROM partial_indexes WHERE a > 5;

-- Test 48: query (line 247)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE partial_indexes]
WHERE statistics_name = 'partial_stat_exact';

-- Test 49: statement (line 256)
CREATE STATISTICS partial_stat_not_implied ON a FROM partial_indexes WHERE a > 3;

-- Test 50: statement (line 260)
CREATE INDEX idx_a ON partial_indexes (a);

-- Test 51: statement (line 263)
CREATE STATISTICS partial_stat_not_implied ON a FROM partial_indexes WHERE a > 3;

-- Test 52: query (line 266)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, partial_predicate
FROM [SHOW STATISTICS FOR TABLE partial_indexes]
WHERE statistics_name = 'partial_stat_not_implied';

-- Test 53: statement (line 275)
DROP INDEX partial_indexes@idx_partial;

-- Test 54: statement (line 278)
DROP INDEX partial_indexes@idx_a;

-- Test 55: statement (line 281)
CREATE INDEX idx_b ON partial_indexes (b) WHERE a > 5;

-- Test 56: statement (line 284)
CREATE STATISTICS partial_stat_implied ON a FROM partial_indexes WHERE a > 7;

-- Test 57: statement (line 287)
DROP INDEX partial_indexes@idx_b;

-- Test 58: statement (line 292)
CREATE INDEX idx_b ON partial_indexes (b) WHERE b > 1 AND b % 2 = 0;

-- Test 59: statement (line 295)
CREATE STATISTICS partial_stat_implied ON b FROM partial_indexes WHERE b > 1 AND b % 2 = 0;

