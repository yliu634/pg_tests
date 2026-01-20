-- PostgreSQL compatible tests from exclude_data_from_backup
--
-- CockroachDB's system.namespace and SHOW CREATE TABLE are not available in
-- PostgreSQL. This file validates table/constraint structure using standard
-- catalogs.

SET client_min_messages = warning;
DROP TABLE IF EXISTS exclude_backup_t2;
DROP TABLE IF EXISTS exclude_backup_t;
RESET client_min_messages;

CREATE TABLE exclude_backup_t(x INT PRIMARY KEY);

SELECT to_regclass('exclude_backup_t') AS t_regclass;

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'exclude_backup_t'
ORDER BY ordinal_position;

-- Temporary tables are session-scoped and are not included in backups by
-- default. This statement validates TEMP table syntax under psql.
CREATE TEMPORARY TABLE exclude_backup_temp1();

CREATE TABLE exclude_backup_t2(x INT REFERENCES exclude_backup_t(x) ON DELETE CASCADE);

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'exclude_backup_t2'
ORDER BY ordinal_position;

SELECT conname, pg_get_constraintdef(oid) AS condef
FROM pg_constraint
WHERE conrelid = 'exclude_backup_t2'::regclass
ORDER BY conname;
