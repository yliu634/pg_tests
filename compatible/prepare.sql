-- PostgreSQL compatible tests from prepare
--
-- The upstream CockroachDB logic-test version of this file contains harness
-- directives and Cockroach-only syntax (e.g. `UPSERT`, `:::`, `[EXECUTE ...]`).
-- This reduced version exercises native PostgreSQL PREPARE/EXECUTE behavior.

SET client_min_messages = warning;

DEALLOCATE ALL;

-- Basic prepare/execute/deallocate.
PREPARE a AS SELECT 1 AS one;
EXECUTE a;
DEALLOCATE a;

PREPARE a AS SELECT 1 AS one;
EXECUTE a;
DEALLOCATE ALL;

-- Typed parameters.
PREPARE b(int, int) AS SELECT $1 + $2 AS sum;
EXECUTE b(3, 4);

PREPARE c(text) AS SELECT upper($1) AS up;
EXECUTE c('foo');

-- Prepared DML.
DROP TABLE IF EXISTS t;
CREATE TABLE t (a INT PRIMARY KEY);

PREPARE ins(int) AS
  INSERT INTO t(a) VALUES ($1)
  ON CONFLICT (a) DO UPDATE SET a = EXCLUDED.a
  RETURNING a;

EXECUTE ins(1);
EXECUTE ins(1);

PREPARE sel AS SELECT a FROM t ORDER BY a;
EXECUTE sel;

DEALLOCATE ALL;
DROP TABLE IF EXISTS t;

RESET client_min_messages;
