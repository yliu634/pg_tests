-- PostgreSQL compatible tests from crdb_internal_catalog
-- NOTE: CockroachDB zone configs + crdb_internal catalog tables are not available in PostgreSQL.
-- This file is rewritten to exercise PostgreSQL comments and basic catalog introspection.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS sc CASCADE;
CREATE SCHEMA sc;
SET search_path = sc, public;

DROP MATERIALIZED VIEW IF EXISTS mv;
DROP TABLE IF EXISTS kv;
DROP TYPE IF EXISTS greeting;

CREATE TYPE greeting AS ENUM ('hi', 'hello');

CREATE TABLE kv (
  k INT,
  v TEXT,
  CONSTRAINT kv_pkey PRIMARY KEY (k),
  CONSTRAINT ck CHECK (k > 0)
);

INSERT INTO kv (k, v) VALUES (1, 'a'), (2, 'b');

CREATE MATERIALIZED VIEW mv AS SELECT k, v FROM kv;
CREATE INDEX idx ON mv (v);

COMMENT ON DATABASE pg_tests IS 'this is the pg_tests database';
COMMENT ON SCHEMA sc IS 'this is a schema';
COMMENT ON SCHEMA public IS 'this is the public schema';
COMMENT ON TABLE kv IS 'this is a table';
COMMENT ON INDEX idx IS 'this is an index';
COMMENT ON CONSTRAINT ck ON kv IS 'this is a check constraint';
COMMENT ON CONSTRAINT kv_pkey ON kv IS 'this is a primary key constraint';

-- Verify that comments were recorded.
SELECT datname, shobj_description(oid, 'pg_database') AS comment
FROM pg_database
WHERE datname = current_database();

SELECT nspname, obj_description(oid, 'pg_namespace') AS comment
FROM pg_namespace
WHERE nspname IN ('sc', 'public')
ORDER BY nspname;

SELECT
  c.relname,
  obj_description(c.oid, 'pg_class') AS comment
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = 'sc'
  AND c.relname IN ('kv', 'mv', 'idx')
ORDER BY c.relname;

SELECT conname, obj_description(oid, 'pg_constraint') AS comment
FROM pg_constraint
WHERE conrelid = 'sc.kv'::regclass
ORDER BY conname;

RESET search_path;
RESET client_min_messages;
