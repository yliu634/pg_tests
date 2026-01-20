-- PostgreSQL compatible tests from create_table
-- NOTE: CockroachDB-specific CREATE TABLE features (FAMILY, hash-sharded indexes, STORING,
-- zone configs, crdb_internal introspection, etc.) are not available in PostgreSQL.
-- This file is rewritten as a focused PostgreSQL CREATE TABLE smoke test.

SET client_min_messages = warning;

DROP TABLE IF EXISTS child;
DROP TABLE IF EXISTS parent;

CREATE TABLE parent (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE child (
  id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  parent_id INT NOT NULL REFERENCES parent(id) ON DELETE CASCADE,
  payload BYTEA,
  created_at TIMESTAMPTZ DEFAULT now(),
  CONSTRAINT payload_len CHECK (payload IS NULL OR length(payload) < 10)
);

INSERT INTO parent (name) VALUES ('p1'), ('p2');
INSERT INTO child (parent_id, payload) VALUES
  (1, '\x01'::bytea),
  (1, NULL),
  (2, '\x02'::bytea);

SELECT
  p.id,
  p.name,
  c.id AS child_id,
  encode(c.payload, 'hex') AS payload_hex
FROM parent AS p
LEFT JOIN child AS c ON c.parent_id = p.id
ORDER BY p.id, child_id NULLS LAST;

SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name IN ('parent', 'child')
ORDER BY table_name, ordinal_position;

DROP TABLE IF EXISTS child;
DROP TABLE IF EXISTS parent;

RESET client_min_messages;
