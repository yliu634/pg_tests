-- PostgreSQL compatible tests from grant_inherited
-- CockroachDB has SHOW GRANTS and "system" privileges; PostgreSQL uses catalog
-- tables and has_*_privilege() helpers instead.

SET client_min_messages = warning;

DROP FUNCTION IF EXISTS fn(int);
DROP TABLE IF EXISTS tbl;
DROP SEQUENCE IF EXISTS sq;
DROP TYPE IF EXISTS typ;
DROP SCHEMA IF EXISTS sc CASCADE;
DROP SCHEMA IF EXISTS test_schema CASCADE;

DROP ROLE IF EXISTS alice;
DROP ROLE IF EXISTS bob;
DROP ROLE IF EXISTS chuck;
DROP ROLE IF EXISTS dave;
DROP ROLE IF EXISTS meeter;
DROP ROLE IF EXISTS greeter;
DROP ROLE IF EXISTS granter;
DROP ROLE IF EXISTS parent;
DROP ROLE IF EXISTS child;

CREATE ROLE alice LOGIN;
CREATE ROLE bob LOGIN;
CREATE ROLE chuck LOGIN;
CREATE ROLE dave LOGIN;
CREATE ROLE meeter;
CREATE ROLE greeter;
CREATE ROLE granter;

GRANT granter TO alice, bob, chuck, dave;
GRANT meeter TO granter;
GRANT greeter TO alice WITH ADMIN OPTION;

-- Role membership (including admin option).
SELECT
  mbr.rolname AS grantee,
  rol.rolname AS role_name,
  CASE am.admin_option WHEN true THEN 'YES' ELSE 'NO' END AS is_grantable
FROM pg_auth_members am
JOIN pg_roles rol ON rol.oid = am.roleid
JOIN pg_roles mbr ON mbr.oid = am.member
WHERE mbr.rolname IN ('alice', 'bob', 'chuck', 'dave', 'granter')
  OR rol.rolname IN ('meeter', 'greeter', 'granter')
ORDER BY 1, 2, 3;

-- Database privileges are checked via has_database_privilege() (includes inherited).
GRANT ALL PRIVILEGES ON DATABASE pg_tests TO meeter WITH GRANT OPTION;
SELECT
  p AS privilege,
  has_database_privilege('alice', 'pg_tests', p) AS has_priv
FROM (VALUES ('CONNECT'), ('CREATE'), ('TEMPORARY')) AS v(p)
ORDER BY 1;

CREATE SCHEMA sc;
GRANT ALL ON SCHEMA sc TO meeter WITH GRANT OPTION;
SELECT
  p AS privilege,
  has_schema_privilege('alice', 'sc', p) AS has_priv
FROM (VALUES ('USAGE'), ('CREATE')) AS v(p)
ORDER BY 1;

CREATE SEQUENCE sq;
GRANT ALL ON SEQUENCE sq TO meeter WITH GRANT OPTION;
SELECT
  p AS privilege,
  has_sequence_privilege('alice', 'sq', p) AS has_priv
FROM (VALUES ('USAGE'), ('SELECT'), ('UPDATE')) AS v(p)
ORDER BY 1;

CREATE TABLE tbl (i INT PRIMARY KEY);
GRANT ALL ON TABLE tbl TO meeter WITH GRANT OPTION;
SELECT
  p AS privilege,
  has_table_privilege('alice', 'tbl', p) AS has_priv
FROM (VALUES ('SELECT'), ('INSERT'), ('UPDATE'), ('DELETE')) AS v(p)
ORDER BY 1;

CREATE TYPE typ AS ENUM ('a', 'b');
GRANT USAGE ON TYPE typ TO meeter WITH GRANT OPTION;
SELECT has_type_privilege('alice', 'typ', 'USAGE') AS has_usage;

CREATE FUNCTION fn(IN x INT)
RETURNS INT
STABLE
LANGUAGE SQL
AS $$
  SELECT x + 1;
$$;
GRANT EXECUTE ON FUNCTION fn(int) TO meeter WITH GRANT OPTION;
SELECT has_function_privilege('alice', 'fn(int)'::regprocedure, 'EXECUTE') AS has_execute;

CREATE ROLE parent;
CREATE ROLE child;
GRANT parent TO child;
CREATE SCHEMA test_schema;
GRANT USAGE ON SCHEMA test_schema TO PUBLIC;
GRANT CREATE ON SCHEMA test_schema TO parent;

SELECT
  mbr.rolname AS grantee,
  rol.rolname AS role_name,
  CASE am.admin_option WHEN true THEN 'YES' ELSE 'NO' END AS is_grantable
FROM pg_auth_members am
JOIN pg_roles rol ON rol.oid = am.roleid
JOIN pg_roles mbr ON mbr.oid = am.member
WHERE mbr.rolname IN ('child')
ORDER BY 1, 2, 3;

-- Cleanup to keep the database reusable across files.
DROP FUNCTION fn(int);
DROP TABLE tbl;
DROP SEQUENCE sq;
DROP TYPE typ;
DROP SCHEMA sc CASCADE;
DROP SCHEMA test_schema CASCADE;
DROP OWNED BY alice, bob, chuck, dave, meeter, greeter, granter, parent, child;
DROP ROLE alice;
DROP ROLE bob;
DROP ROLE chuck;
DROP ROLE dave;
DROP ROLE meeter;
DROP ROLE greeter;
DROP ROLE granter;
DROP ROLE parent;
DROP ROLE child;

RESET client_min_messages;
