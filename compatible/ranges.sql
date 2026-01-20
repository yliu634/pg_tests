-- PostgreSQL compatible tests from ranges
--
-- CockroachDB exposes KV range metadata via `SHOW RANGES` and `crdb_internal.*`
-- tables. PostgreSQL has no equivalent feature. This reduced version instead
-- exercises PostgreSQL's built-in *range types* (unrelated to KV ranges).

SET client_min_messages = warning;

SELECT int4range(1, 10, '[)') AS r;
SELECT lower(int4range(1, 10, '[)')) AS lower, upper(int4range(1, 10, '[)')) AS upper;
SELECT int4range(1, 10, '[)') @> 5 AS contains_5;
SELECT int4range(1, 10, '[)') && int4range(5, 15, '[)') AS overlaps;

RESET client_min_messages;
