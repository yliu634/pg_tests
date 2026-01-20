-- PostgreSQL compatible tests from procedure_schema_change
--
-- The upstream CockroachDB logic-test file validates many edge cases (SHOW
-- CREATE PROCEDURE, descriptor IDs, cross-schema moves). This reduced version
-- exercises PostgreSQL procedure schema changes and owner changes.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS sc CASCADE;
DROP ROLE IF EXISTS u;
DROP PROCEDURE IF EXISTS p();
DROP PROCEDURE IF EXISTS p_int(INT);

CREATE SCHEMA sc;
CREATE ROLE u;

CREATE PROCEDURE p() LANGUAGE SQL AS $$ SELECT 1; $$;
CREATE PROCEDURE p_int(IN x INT) LANGUAGE SQL AS $$ SELECT x; $$;

ALTER PROCEDURE p() SET SCHEMA sc;
ALTER PROCEDURE sc.p() RENAME TO p_new;
ALTER PROCEDURE sc.p_new() OWNER TO u;

SELECT n.nspname AS schema, p.proname, r.rolname AS owner
  FROM pg_proc p
  JOIN pg_namespace n ON n.oid = p.pronamespace
  JOIN pg_roles r ON r.oid = p.proowner
 WHERE p.proname IN ('p_new', 'p_int')
 ORDER BY 1, 2;

DROP SCHEMA sc CASCADE;
DROP ROLE u;

RESET client_min_messages;
