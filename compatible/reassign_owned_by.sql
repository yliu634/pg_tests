-- PostgreSQL compatible tests from reassign_owned_by
--
-- The upstream CockroachDB logic-test file uses Cockroach-only directives
-- (`use`, `user`, `[SHOW ...]`, `SET DATABASE`) and cross-database object
-- syntax. This reduced version exercises PostgreSQL's REASSIGN OWNED command.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS s CASCADE;
DROP ROLE IF EXISTS rold;
DROP ROLE IF EXISTS rnew;

CREATE ROLE rold;
CREATE ROLE rnew;

CREATE SCHEMA s AUTHORIZATION rold;
SET ROLE rold;
CREATE TABLE s.t (i INT);
CREATE TYPE s.e AS ENUM ('a', 'b');
RESET ROLE;

REASSIGN OWNED BY rold TO rnew;

SELECT n.nspname AS schema, r.rolname AS owner
  FROM pg_namespace n
  JOIN pg_roles r ON r.oid = n.nspowner
 WHERE n.nspname = 's';

SELECT c.relname AS rel, r.rolname AS owner
  FROM pg_class c
  JOIN pg_roles r ON r.oid = c.relowner
  JOIN pg_namespace n ON n.oid = c.relnamespace
 WHERE n.nspname = 's' AND c.relname = 't';

SELECT t.typname AS typ, r.rolname AS owner
  FROM pg_type t
  JOIN pg_roles r ON r.oid = t.typowner
  JOIN pg_namespace n ON n.oid = t.typnamespace
 WHERE n.nspname = 's' AND t.typname = 'e';

DROP SCHEMA s CASCADE;
DROP ROLE rold;
DROP ROLE rnew;

RESET client_min_messages;
