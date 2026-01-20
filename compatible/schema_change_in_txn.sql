-- PostgreSQL compatible tests from schema_change_in_txn
--
-- CockroachDB has many schema changer behaviors and directives in the upstream
-- file. This reduced version demonstrates transactional DDL in PostgreSQL.

SET client_min_messages = warning;

DROP TABLE IF EXISTS tx_test;

BEGIN;
CREATE TABLE tx_test (i INT);
ROLLBACK;

SELECT to_regclass('tx_test') IS NOT NULL AS tx_test_exists_after_rollback;

BEGIN;
CREATE TABLE tx_test (i INT);
COMMIT;

SELECT to_regclass('tx_test') IS NOT NULL AS tx_test_exists_after_commit;

DROP TABLE tx_test;

RESET client_min_messages;
