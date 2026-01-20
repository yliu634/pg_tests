-- PostgreSQL compatible tests from retry
--
-- CockroachDB has retry-related helpers like `crdb_internal.force_error`.
-- PostgreSQL has no equivalent mechanism. This reduced version keeps a simple
-- sequence-driven CASE expression without raising errors.

SET client_min_messages = warning;

DROP SEQUENCE IF EXISTS s;
CREATE SEQUENCE s START 1 INCREMENT 1;

SELECT nextval('s');

SELECT
  CASE subq.val
    WHEN 2 THEN 'bad: wrong'
    ELSE 'ok'
  END AS result
FROM (SELECT nextval('s') AS val) subq;

DROP SEQUENCE s;

RESET client_min_messages;
