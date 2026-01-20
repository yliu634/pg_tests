SET client_min_messages = warning;

-- PostgreSQL compatible tests from on_update
-- 98 tests
--
-- CockroachDB supports per-column "ON UPDATE" expressions. PostgreSQL does not
-- have that feature, but similar behavior can be implemented with triggers.
-- This file exercises trigger-based equivalents for updates and upserts.

-- Test 1: statement (line 7)
DROP TABLE IF EXISTS test_simple CASCADE;
CREATE TABLE test_simple (
  p TEXT PRIMARY KEY,
  k TEXT
);

CREATE OR REPLACE FUNCTION _set_k_on_update() RETURNS trigger AS $$
BEGIN
  NEW.k := 'regress';
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER test_simple_on_update
BEFORE UPDATE ON test_simple
FOR EACH ROW EXECUTE FUNCTION _set_k_on_update();

-- Test 2: statement (line 10)
INSERT INTO test_simple VALUES ('pk1', 'to_be_changed');

-- Test 3: query (line 18)
SELECT p, k FROM test_simple ORDER BY p;

-- Test 4: statement (line 26)
UPDATE test_simple SET p = 'pk2' WHERE p = 'pk1';

-- Test 5: query (line 29)
SELECT p, k FROM test_simple ORDER BY p;

-- Test 6: statement (line 48)
DROP TABLE IF EXISTS test_upsert CASCADE;
CREATE TABLE test_upsert (
  p TEXT PRIMARY KEY,
  j TEXT,
  k TEXT
);
CREATE TRIGGER test_upsert_on_update
BEFORE UPDATE ON test_upsert
FOR EACH ROW EXECUTE FUNCTION _set_k_on_update();

INSERT INTO test_upsert VALUES ('pk1', 'val1', 'whatevs');

-- Test 7: query (line 51)
SELECT p, j, k FROM test_upsert ORDER BY p;

-- Test 8: statement (line 56)
INSERT INTO test_upsert (p, j) VALUES ('pk1', 'val2'), ('pk2', 'val3')
ON CONFLICT (p) DO UPDATE SET j = EXCLUDED.j;

-- Test 9: query (line 59)
SELECT p, j, k FROM test_upsert ORDER BY p;

-- Test 10: statement (line 134)
DROP TABLE IF EXISTS test_fk_ref CASCADE;
DROP TABLE IF EXISTS test_fk_base CASCADE;
CREATE TABLE test_fk_base (
  p TEXT PRIMARY KEY,
  j TEXT UNIQUE
);
CREATE TABLE test_fk_ref (
  p TEXT PRIMARY KEY,
  j TEXT REFERENCES test_fk_base (j) ON UPDATE CASCADE
);

INSERT INTO test_fk_base VALUES ('pk1', 'val1'), ('pk2', 'val2');
INSERT INTO test_fk_ref VALUES ('pk1', 'val1'), ('pk2', 'val2');

UPDATE test_fk_base SET j = 'arbitrary' WHERE p = 'pk1';

-- Test 11: query (line 143)
SELECT p, j FROM test_fk_base ORDER BY p;

-- Test 12: query (line 149)
SELECT p, j FROM test_fk_ref ORDER BY p;

RESET client_min_messages;

