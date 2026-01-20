-- PostgreSQL compatible tests from distsql_datetime
-- NOTE: CockroachDB DistSQL datetime tests are not applicable to PostgreSQL.

SELECT date_trunc('day', now())::date AS today;
