-- PostgreSQL compatible tests from collatedstring_constraint
-- 15 tests

SET client_min_messages = warning;
CREATE COLLATION IF NOT EXISTS en_u_ks_level1 (provider = icu, locale = 'en-u-ks-level1');

DROP TABLE IF EXISTS c1, c2, p;
CREATE TABLE p (a text COLLATE en_u_ks_level1);
CREATE TABLE c1 (a text COLLATE en_u_ks_level1, b text COLLATE en_u_ks_level1);
CREATE TABLE c2 (a text COLLATE en_u_ks_level1, b text COLLATE en_u_ks_level1);

-- Test 1: statement (line 8)
INSERT INTO p VALUES ('a' COLLATE en_u_ks_level1);

-- Test 2: statement (line 11)
INSERT INTO p VALUES ('A' COLLATE en_u_ks_level1);

-- Test 3: statement (line 14)
INSERT INTO p VALUES ('b' COLLATE en_u_ks_level1);

-- Test 4: statement (line 23)
INSERT INTO c1 VALUES ('A' COLLATE en_u_ks_level1, 'apple' COLLATE en_u_ks_level1);

-- Test 5: statement (line 26)
INSERT INTO c1 VALUES ('b' COLLATE en_u_ks_level1, 'banana' COLLATE en_u_ks_level1);

-- Test 6: statement (line 29)
INSERT INTO c1 VALUES ('p' COLLATE en_u_ks_level1, 'pear' COLLATE en_u_ks_level1);

-- Test 7: query (line 32)
SELECT a FROM p ORDER BY a;

-- Test 8: query (line 38)
SELECT a FROM c1 ORDER BY a;

-- Test 9: query (line 45)
SELECT b FROM c1 ORDER BY a;

-- Test 10: statement (line 59)
INSERT INTO c2 VALUES ('A' COLLATE en_u_ks_level1, 'apple' COLLATE en_u_ks_level1);

-- Test 11: statement (line 62)
INSERT INTO c2 VALUES ('b' COLLATE en_u_ks_level1, 'banana' COLLATE en_u_ks_level1);

-- Test 12: statement (line 65)
INSERT INTO c2 VALUES ('p' COLLATE en_u_ks_level1, 'pear' COLLATE en_u_ks_level1);

-- Test 13: query (line 68)
SELECT a FROM p ORDER BY a;

-- Test 14: query (line 74)
SELECT a FROM c2 ORDER BY a;

-- Test 15: query (line 80)
SELECT b FROM c2 ORDER BY a;

RESET client_min_messages;
