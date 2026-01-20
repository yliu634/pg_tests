-- PostgreSQL compatible tests from create_index
-- NOTE: CockroachDB index features like STORING, INVERTED, vector indexes, and
-- background index jobs are not supported by PostgreSQL.
-- This file is rewritten to cover core PostgreSQL index creation patterns.

SET client_min_messages = warning;

DROP TABLE IF EXISTS idx_tbl;

CREATE TABLE idx_tbl (
  a INT,
  b INT,
  c TEXT
);

INSERT INTO idx_tbl (a, b, c) VALUES
  (1, 10, 'Alpha'),
  (2, 20, 'beta'),
  (3, 30, 'Gamma'),
  (4, NULL, NULL);

DROP INDEX IF EXISTS idx_tbl_a;
CREATE INDEX idx_tbl_a ON idx_tbl (a);

DROP INDEX IF EXISTS idx_tbl_b_unique;
CREATE UNIQUE INDEX idx_tbl_b_unique ON idx_tbl (b) WHERE b IS NOT NULL;

DROP INDEX IF EXISTS idx_tbl_c_partial;
CREATE INDEX idx_tbl_c_partial ON idx_tbl (c) WHERE b > 10;

-- INCLUDE replaces CockroachDB STORING.
DROP INDEX IF EXISTS idx_tbl_a_include;
CREATE INDEX idx_tbl_a_include ON idx_tbl (a) INCLUDE (c);

DROP INDEX IF EXISTS idx_tbl_c_expr;
CREATE INDEX idx_tbl_c_expr ON idx_tbl (lower(c));

-- Show created indexes.
SELECT schemaname, tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = current_schema()
  AND tablename = 'idx_tbl'
ORDER BY indexname;

RESET client_min_messages;
