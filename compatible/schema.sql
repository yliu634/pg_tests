-- PostgreSQL compatible tests from schema
--
-- The upstream CockroachDB logic-test file includes Cockroach-only SHOW
-- commands, variable directives, and negative cases. This reduced version
-- exercises basic PostgreSQL schema creation, search_path, and renaming.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS myschema2 CASCADE;
DROP SCHEMA IF EXISTS myschema CASCADE;

CREATE SCHEMA myschema;
CREATE TABLE myschema.tb (x INT);
INSERT INTO myschema.tb VALUES (1);

SET search_path TO myschema, public;
SELECT * FROM tb;
RESET search_path;

ALTER SCHEMA myschema RENAME TO myschema2;

SELECT schema_name
  FROM information_schema.schemata
 WHERE schema_name IN ('myschema', 'myschema2')
 ORDER BY schema_name;

DROP SCHEMA myschema2 CASCADE;

RESET client_min_messages;
