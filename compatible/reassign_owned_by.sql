-- PostgreSQL compatible tests from reassign_owned_by
-- 87 tests

-- CockroachDB's logic-test version of this file relies on CRDB-only harness
-- directives (user/use/SHOW ...) and cross-database behavior.
--
-- This rewrite keeps the semantic focus for PostgreSQL: REASSIGN OWNED changes
-- ownership of all objects in the current database from one role to another.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS reassign_sc CASCADE;
DROP ROLE IF EXISTS reassign_old_role;
DROP ROLE IF EXISTS reassign_new_role;

CREATE ROLE reassign_old_role;
CREATE ROLE reassign_new_role;

-- Own a schema and create representative objects under the old role.
CREATE SCHEMA reassign_sc AUTHORIZATION reassign_old_role;

SET ROLE reassign_old_role;
CREATE TABLE reassign_sc.t(a INT);
CREATE TYPE reassign_sc.typ AS ENUM ('a', 'b');
CREATE FUNCTION reassign_sc.f() RETURNS INT LANGUAGE sql AS $$ SELECT 1 $$;
RESET ROLE;

-- Ownership before REASSIGN OWNED.
SELECT n.nspname AS schema, r.rolname AS owner
FROM pg_namespace n
JOIN pg_roles r ON n.nspowner = r.oid
WHERE n.nspname = 'reassign_sc';

SELECT c.relname, c.relkind, r.rolname AS owner
FROM pg_class c
JOIN pg_roles r ON c.relowner = r.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE n.nspname = 'reassign_sc'
ORDER BY 1, 2, 3;

SELECT t.typname, r.rolname AS owner
FROM pg_type t
JOIN pg_roles r ON t.typowner = r.oid
JOIN pg_namespace n ON t.typnamespace = n.oid
WHERE n.nspname = 'reassign_sc'
ORDER BY 1, 2;

SELECT p.proname, r.rolname AS owner
FROM pg_proc p
JOIN pg_roles r ON p.proowner = r.oid
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'reassign_sc'
ORDER BY 1, 2;

-- Reassign ownership of all objects owned by the old role.
REASSIGN OWNED BY reassign_old_role TO reassign_new_role;

-- Ownership after REASSIGN OWNED.
SELECT n.nspname AS schema, r.rolname AS owner
FROM pg_namespace n
JOIN pg_roles r ON n.nspowner = r.oid
WHERE n.nspname = 'reassign_sc';

SELECT c.relname, c.relkind, r.rolname AS owner
FROM pg_class c
JOIN pg_roles r ON c.relowner = r.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE n.nspname = 'reassign_sc'
ORDER BY 1, 2, 3;

SELECT t.typname, r.rolname AS owner
FROM pg_type t
JOIN pg_roles r ON t.typowner = r.oid
JOIN pg_namespace n ON t.typnamespace = n.oid
WHERE n.nspname = 'reassign_sc'
ORDER BY 1, 2;

SELECT p.proname, r.rolname AS owner
FROM pg_proc p
JOIN pg_roles r ON p.proowner = r.oid
JOIN pg_namespace n ON p.pronamespace = n.oid
WHERE n.nspname = 'reassign_sc'
ORDER BY 1, 2;

-- Cleanup (roles are cluster-global; drop them so reruns stay clean).
DROP SCHEMA reassign_sc CASCADE;
DROP ROLE reassign_old_role;
DROP ROLE reassign_new_role;

RESET client_min_messages;
