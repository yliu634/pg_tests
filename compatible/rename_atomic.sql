-- PostgreSQL compatible tests from rename_atomic
--
-- CockroachDB tests in this area exercise atomic renames across databases and
-- schemas. PostgreSQL cannot run CREATE/ALTER DATABASE inside transactions, so
-- this reduced version focuses on transactional schema/view renames.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS sc_old CASCADE;
DROP SCHEMA IF EXISTS sc_new CASCADE;
DROP SCHEMA IF EXISTS sc CASCADE;

CREATE SCHEMA sc;
CREATE SCHEMA sc_new;

BEGIN;
ALTER SCHEMA sc RENAME TO sc_old;
ALTER SCHEMA sc_new RENAME TO sc;
ROLLBACK;

SELECT nspname
  FROM pg_namespace
 WHERE nspname IN ('sc', 'sc_new', 'sc_old')
 ORDER BY nspname;

BEGIN;
ALTER SCHEMA sc RENAME TO sc_old;
ALTER SCHEMA sc_new RENAME TO sc;
CREATE VIEW sc.v AS SELECT 1 AS v;
COMMIT;

SELECT * FROM sc.v;

DROP VIEW IF EXISTS v_old;
DROP VIEW IF EXISTS v_new;
DROP VIEW IF EXISTS v;

CREATE VIEW v AS SELECT 1 AS v;
CREATE VIEW v_new AS SELECT 2 AS v;

BEGIN;
ALTER VIEW v RENAME TO v_old;
ALTER VIEW v_new RENAME TO v;
COMMIT;

SELECT * FROM v;

DROP VIEW v;
DROP VIEW v_old;
DROP SCHEMA sc_old CASCADE;
DROP SCHEMA sc CASCADE;

RESET client_min_messages;
