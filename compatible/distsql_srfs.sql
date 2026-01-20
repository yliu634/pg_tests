-- PostgreSQL compatible tests from distsql_srfs
-- NOTE: CockroachDB DistSQL SRF tests are not applicable to PostgreSQL.
-- This file exercises PostgreSQL set-returning functions.

SELECT * FROM generate_series(1, 3) AS g(x);
SELECT * FROM unnest(ARRAY[10, 20, 30]) AS u(x);
