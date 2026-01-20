-- PostgreSQL compatible tests from create_as_non_metamorphic
-- NOTE: CockroachDB cluster settings are not supported by PostgreSQL.
-- This file keeps the core CREATE TABLE AS workload.

SET client_min_messages = warning;

DROP TABLE IF EXISTS source_tbl_huge;

BEGIN;
CREATE TABLE source_tbl_huge AS
SELECT repeat('x', 256)::char(256) AS c
FROM generate_series(1, 5000);
COMMIT;

SELECT count(*) FROM source_tbl_huge;

DROP TABLE IF EXISTS source_tbl_huge;

RESET client_min_messages;
