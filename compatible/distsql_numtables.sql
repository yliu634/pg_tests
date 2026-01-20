-- PostgreSQL compatible tests from distsql_numtables
-- NOTE: CockroachDB DistSQL numtables tests are not applicable to PostgreSQL.

SELECT count(*) AS num_tables
FROM pg_catalog.pg_tables
WHERE schemaname = current_schema();
