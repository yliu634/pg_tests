-- PostgreSQL compatible tests from rename_database
--
-- CockroachDB supports cross-database object references and has many cluster
-- settings in the upstream logic-test file. PostgreSQL database DDL is more
-- restricted (e.g. cannot run inside a transaction). This reduced version
-- exercises renaming a database and verifying via pg_database.

SET client_min_messages = warning;

DROP DATABASE IF EXISTS db_rename_dst;
DROP DATABASE IF EXISTS db_rename_src;

CREATE DATABASE db_rename_src;

SELECT datname
  FROM pg_database
 WHERE datname IN ('db_rename_src', 'db_rename_dst')
 ORDER BY datname;

ALTER DATABASE db_rename_src RENAME TO db_rename_dst;

SELECT datname
  FROM pg_database
 WHERE datname IN ('db_rename_src', 'db_rename_dst')
 ORDER BY datname;

DROP DATABASE db_rename_dst;

RESET client_min_messages;
