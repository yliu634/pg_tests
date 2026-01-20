-- PostgreSQL compatible tests from redact_descriptor
--
-- CockroachDB's descriptor redaction (`redacted_descriptors`, `FAMILY`, etc.)
-- has no direct equivalent in PostgreSQL. This reduced version inspects table
-- metadata via pg_catalog for a table with defaults, a generated column, and a
-- partial index.

SET client_min_messages = warning;

DROP TABLE IF EXISTS foo;

CREATE TABLE foo (
  i BIGINT PRIMARY KEY DEFAULT 42,
  j BIGINT GENERATED ALWAYS AS (44) STORED
);

CREATE INDEX foo_j_idx ON foo (j) WHERE i = 41;

SELECT a.attname, pg_get_expr(d.adbin, d.adrelid) AS expr
  FROM pg_attribute a
  JOIN pg_attrdef d ON d.adrelid = a.attrelid AND d.adnum = a.attnum
 WHERE a.attrelid = 'foo'::regclass
   AND a.attname IN ('i', 'j')
 ORDER BY a.attname;

SELECT indexname, indexdef
  FROM pg_indexes
 WHERE schemaname = 'public'
   AND tablename = 'foo'
 ORDER BY indexname;

DROP TABLE foo;

RESET client_min_messages;
