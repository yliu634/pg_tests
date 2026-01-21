-- PostgreSQL compatible tests from collatedstring_constraint
-- 15 tests

-- CockroachDB's collated string tests rely on ICU collations.
-- The "en_u_ks_level1" collation is case-insensitive in CockroachDB; in PostgreSQL
-- this requires a non-deterministic ICU collation.
CREATE COLLATION en_u_ks_level1 (provider = icu, locale = 'en-u-ks-level1', deterministic = false);

CREATE TABLE p (
  a TEXT COLLATE en_u_ks_level1 PRIMARY KEY
);

-- Test 2: statement (line 11)
INSERT INTO p VALUES ('a' COLLATE en_u_ks_level1);

-- Test 3: statement (line 14)
-- Expected ERROR (case-insensitive duplicate key).
\set ON_ERROR_STOP 0
INSERT INTO p VALUES ('A' COLLATE en_u_ks_level1);
\set ON_ERROR_STOP 1

-- Test 4: statement (line 23)
INSERT INTO p VALUES ('b' COLLATE en_u_ks_level1);

CREATE TABLE c1 (
  a TEXT COLLATE en_u_ks_level1 PRIMARY KEY,
  b TEXT COLLATE en_u_ks_level1
);

-- Test 5: statement (line 26)
INSERT INTO c1 VALUES ('A' COLLATE en_u_ks_level1, 'apple' COLLATE en_u_ks_level1);

-- Test 6: statement (line 29)
INSERT INTO c1 VALUES ('b' COLLATE en_u_ks_level1, 'banana' COLLATE en_u_ks_level1);

-- Test 7: query (line 32)
INSERT INTO c1 VALUES ('p' COLLATE en_u_ks_level1, 'pear' COLLATE en_u_ks_level1);

-- Test 8: query (line 38)
SELECT a FROM p ORDER BY a;

-- Test 9: query (line 45)
SELECT a FROM c1 ORDER BY a;

-- Test 10: statement (line 59)
SELECT b FROM c1 ORDER BY a;

CREATE TABLE c2 (
  a TEXT COLLATE en_u_ks_level1 PRIMARY KEY,
  b TEXT COLLATE en_u_ks_level1,
  CONSTRAINT fk_p FOREIGN KEY (a) REFERENCES p (a)
);

-- Test 11: statement (line 62)
INSERT INTO c2 VALUES ('A' COLLATE en_u_ks_level1, 'apple' COLLATE en_u_ks_level1);

-- Test 12: statement (line 65)
INSERT INTO c2 VALUES ('b' COLLATE en_u_ks_level1, 'banana' COLLATE en_u_ks_level1);

-- Expected ERROR (foreign key violation).
\set ON_ERROR_STOP 0
INSERT INTO c2 VALUES ('p' COLLATE en_u_ks_level1, 'pear' COLLATE en_u_ks_level1);
\set ON_ERROR_STOP 1

-- Test 13: query (line 68)
SELECT a FROM p ORDER BY a;

-- Test 14: query (line 74)
SELECT a FROM c2 ORDER BY a;

-- Test 15: query (line 80)
SELECT b FROM c2 ORDER BY a;
