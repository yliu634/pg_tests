-- PostgreSQL compatible tests from gc_job_mixed
--
-- CockroachDB has GC jobs and crdb_internal catalogs that don't exist in PG.
-- This file keeps a minimal DDL flow that runs cleanly under PostgreSQL.

SET client_min_messages = warning;
DROP TABLE IF EXISTS gc_kv;
RESET client_min_messages;

CREATE TABLE gc_kv (k INT PRIMARY KEY, v INT);
INSERT INTO gc_kv VALUES (1, 1);
DROP TABLE gc_kv;

SELECT to_regclass('gc_kv') AS kv_exists_after_drop;

