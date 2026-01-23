-- PostgreSQL compatible tests adapted from CockroachDB's hash_sharded_index logic tests.
--
-- CockroachDB hash-sharded indexes ("USING HASH WITH (bucket_count=...)"), SHOW CREATE TABLE,
-- and cluster settings are not supported in PostgreSQL. The closest analogue in PostgreSQL is a
-- hash index (CREATE INDEX ... USING hash (...)).

SET client_min_messages = warning;

DROP TABLE IF EXISTS sharded_secondary;
DROP TABLE IF EXISTS sharded_primary;

-- Primary table.
CREATE TABLE sharded_primary (
  a INT PRIMARY KEY,
  b TEXT
);

-- Secondary table.
CREATE TABLE sharded_secondary (
  a INT NOT NULL,
  b INT NOT NULL,
  c TEXT
);

INSERT INTO sharded_primary(a, b) VALUES
  (1, 'one'),
  (2, 'two'),
  (3, 'three');

INSERT INTO sharded_secondary(a, b, c) VALUES
  (1, 10, 'x'),
  (1, 11, 'y'),
  (2, 20, 'z');

-- Create hash indexes (closest PostgreSQL equivalent).
CREATE INDEX sharded_primary_a_hash_idx ON sharded_primary USING hash (a);
CREATE INDEX sharded_secondary_a_hash_idx ON sharded_secondary USING hash (a);
CREATE INDEX sharded_secondary_b_hash_idx ON sharded_secondary USING hash (b);

-- Introspect index definitions.
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename IN ('sharded_primary', 'sharded_secondary')
ORDER BY tablename, indexname;

-- Basic sanity queries.
SELECT count(*) FROM sharded_secondary;
SELECT * FROM sharded_primary WHERE a IN (1, 3) ORDER BY a;
SELECT * FROM sharded_secondary WHERE a = 1 ORDER BY b;

-- Drop/recreate index to exercise DDL.
DROP INDEX sharded_secondary_b_hash_idx;
CREATE INDEX sharded_secondary_b_hash_idx ON sharded_secondary USING hash (b);

SELECT tablename, indexname
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename = 'sharded_secondary'
ORDER BY indexname;
