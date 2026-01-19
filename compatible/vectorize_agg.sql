-- PostgreSQL compatible tests from vectorize_agg
-- 14 tests

-- Test 1: statement (line 1)
CREATE TABLE bools (a INT, b BOOL)

-- Test 2: query (line 4)
SELECT bool_and(b), bool_or(b) FROM bools

-- Test 3: query (line 9)
SELECT bool_and(b), bool_or(b) FROM bools GROUP BY a

-- Test 4: statement (line 13)
INSERT INTO bools VALUES
(0, NULL),
(1, true),  (1, true),
(2, false), (2, false),
(3, false), (3, true), (3, true),
(4, NULL),  (4, true),
(5, false), (5, NULL)

-- Test 5: query (line 22)
SELECT bool_and(b), bool_or(b) FROM bools GROUP BY a;

-- Test 6: query (line 35)
SELECT concat_agg(_bytes), concat_agg(_string) FROM bytes_string

-- Test 7: query (line 40)
SELECT concat_agg(_bytes), concat_agg(_string) FROM bytes_string GROUP BY _group

-- Test 8: statement (line 44)
INSERT INTO bytes_string VALUES
(0, NULL, NULL),
(1, b'1', '1'),
(2, b'2', '2'), (2, b'2', '2'),
(3, b'3', '3'), (3, NULL, NULL), (3, b'3', '3')

-- Test 9: query (line 51)
SELECT concat_agg(_bytes), concat_agg(_string) FROM bytes_string GROUP BY _group ORDER BY _group

-- Test 10: statement (line 61)
CREATE TABLE t87619 (b) AS SELECT true;
SET testing_optimizer_random_seed = 3164997759865821235;
SET testing_optimizer_disable_rule_probability = 0.500000;

-- Test 11: query (line 66)
SELECT true FROM t87619 GROUP BY b HAVING b

-- Test 12: statement (line 71)
RESET testing_optimizer_random_seed;
RESET testing_optimizer_disable_rule_probability;

-- Test 13: statement (line 77)
CREATE TABLE t97603 (id PRIMARY KEY) AS SELECT generate_series(1, 50000);

-- Test 14: statement (line 83)
SELECT
     var_pop(crdb_internal_mvcc_timestamp::DECIMAL),
     1:::OID
FROM t97603 GROUP BY id HAVING bool_or(true)

