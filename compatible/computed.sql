-- PostgreSQL compatible tests from computed
-- NOTE: CockroachDB logic-test directives (onlyif/skipif), CREATE TABLE FAMILY clauses,
-- and SHOW CREATE TABLE/SHOW COLUMNS are not supported by PostgreSQL.
-- This file is rewritten to cover core PostgreSQL generated-column behavior.

SET client_min_messages = warning;

DROP TABLE IF EXISTS gen_basic;

CREATE TABLE gen_basic (
  a INT,
  b INT,
  c INT GENERATED ALWAYS AS (a + b) STORED,
  d INT GENERATED ALWAYS AS (a * 2) STORED
);

INSERT INTO gen_basic (a, b) VALUES
  (1, 2),
  (3, 4),
  (NULL, 5);

-- Test generated values on insert.
SELECT a, b, c, d
FROM gen_basic
ORDER BY a NULLS LAST, b;

-- Test recomputation on update.
UPDATE gen_basic SET a = 10 WHERE b = 2;
SELECT a, b, c, d
FROM gen_basic
ORDER BY a NULLS LAST, b;

-- Test ALTER TABLE ADD COLUMN with a generated column.
ALTER TABLE gen_basic
  ADD COLUMN e INT GENERATED ALWAYS AS ((a + b) * 3) STORED;

SELECT a, b, c, d, e
FROM gen_basic
ORDER BY a NULLS LAST, b;

-- Introspect generated columns via information_schema.
SELECT column_name, is_generated, generation_expression
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND table_name = 'gen_basic'
ORDER BY ordinal_position;

RESET client_min_messages;
