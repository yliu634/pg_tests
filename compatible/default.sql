-- PostgreSQL compatible tests from default
-- NOTE: CockroachDB default-expression tests may rely on CRDB-specific syntax.
-- This file is rewritten to cover core PostgreSQL DEFAULT behavior.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t_default;

CREATE TABLE t_default (
  a INT DEFAULT 1,
  b TEXT DEFAULT 'x',
  c TIMESTAMPTZ DEFAULT now()
);

INSERT INTO t_default DEFAULT VALUES;
INSERT INTO t_default (a) VALUES (10);

SELECT a, b, c IS NOT NULL AS c_nonnull
FROM t_default
ORDER BY a;

DROP TABLE IF EXISTS t_default;

RESET client_min_messages;
