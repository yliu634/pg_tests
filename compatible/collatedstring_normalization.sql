-- PostgreSQL compatible tests from collatedstring_normalization
-- 5 tests

SET client_min_messages = warning;
CREATE COLLATION IF NOT EXISTS fr (provider = icu, locale = 'fr');

DROP TABLE IF EXISTS t;
CREATE TABLE t (a text COLLATE fr);

-- Test 1: statement (line 8)
INSERT INTO t VALUES (E'Ame\\u0301lie' COLLATE fr);

-- Test 2: query (line 12)
SELECT a FROM t WHERE a = (E'Am\\u00E9lie' COLLATE fr);

-- Test 3: statement (line 17)
DELETE FROM t;

-- Test 4: statement (line 21)
INSERT INTO t VALUES (E'Am\\u00E9lie' COLLATE fr);

-- Test 5: query (line 25)
SELECT a FROM t WHERE a = (E'Ame\\u0301lie' COLLATE fr);

RESET client_min_messages;
