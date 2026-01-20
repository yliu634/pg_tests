-- PostgreSQL compatible tests from grant_role
--
-- CockroachDB uses SHOW GRANTS and special built-in roles; PostgreSQL exposes
-- role membership via pg_auth_members.

SET client_min_messages = warning;

DROP ROLE IF EXISTS gr_role_developer;
DROP ROLE IF EXISTS gr_role_roach;
DROP ROLE IF EXISTS gr_role_testuser;
DROP ROLE IF EXISTS gr_role_everyone;
DROP ROLE IF EXISTS gr_role_grantor;
DROP ROLE IF EXISTS gr_role_admin;
DROP ROLE IF EXISTS gr_role_transitiveadmin;
DROP ROLE IF EXISTS gr_role_parent1;
DROP ROLE IF EXISTS gr_role_child1;
DROP ROLE IF EXISTS gr_role_parent2;
DROP ROLE IF EXISTS gr_role_child2;
DROP ROLE IF EXISTS gr_role_parent3;
DROP ROLE IF EXISTS gr_role_child3;

CREATE ROLE gr_role_developer CREATEDB LOGIN;
CREATE ROLE gr_role_roach LOGIN;

-- Membership and admin option.
GRANT gr_role_developer TO gr_role_roach;
GRANT gr_role_developer TO gr_role_roach WITH ADMIN OPTION;

CREATE ROLE gr_role_testuser;
CREATE ROLE gr_role_everyone;
GRANT gr_role_testuser TO gr_role_everyone;
REVOKE gr_role_testuser FROM gr_role_everyone;

-- A simple transitive membership chain.
CREATE ROLE gr_role_admin;
CREATE ROLE gr_role_transitiveadmin;
GRANT gr_role_admin TO gr_role_transitiveadmin;

CREATE ROLE gr_role_grantor CREATEROLE;
GRANT gr_role_transitiveadmin TO gr_role_grantor;

CREATE ROLE gr_role_parent1;
CREATE ROLE gr_role_child1;
GRANT gr_role_parent1 TO gr_role_child1;

CREATE ROLE gr_role_parent2;
CREATE ROLE gr_role_child2;
GRANT gr_role_parent2 TO gr_role_child2 WITH ADMIN OPTION;

CREATE ROLE gr_role_parent3;
CREATE ROLE gr_role_child3;
GRANT gr_role_parent3 TO gr_role_child3;

-- Show the direct membership edges created above.
SELECT
  mbr.rolname AS member,
  rol.rolname AS role_name,
  CASE am.admin_option WHEN true THEN 'YES' ELSE 'NO' END AS admin_option
FROM pg_auth_members am
JOIN pg_roles rol ON rol.oid = am.roleid
JOIN pg_roles mbr ON mbr.oid = am.member
WHERE (mbr.rolname, rol.rolname) IN (
  ('gr_role_roach', 'gr_role_developer'),
  ('gr_role_transitiveadmin', 'gr_role_admin'),
  ('gr_role_grantor', 'gr_role_transitiveadmin'),
  ('gr_role_child1', 'gr_role_parent1'),
  ('gr_role_child2', 'gr_role_parent2'),
  ('gr_role_child3', 'gr_role_parent3')
)
ORDER BY 1, 2;

-- Cleanup.
DROP OWNED BY gr_role_developer, gr_role_roach, gr_role_testuser, gr_role_everyone,
  gr_role_grantor, gr_role_admin, gr_role_transitiveadmin, gr_role_parent1, gr_role_child1,
  gr_role_parent2, gr_role_child2, gr_role_parent3, gr_role_child3;
DROP ROLE gr_role_developer;
DROP ROLE gr_role_roach;
DROP ROLE gr_role_testuser;
DROP ROLE gr_role_everyone;
DROP ROLE gr_role_grantor;
DROP ROLE gr_role_admin;
DROP ROLE gr_role_transitiveadmin;
DROP ROLE gr_role_parent1;
DROP ROLE gr_role_child1;
DROP ROLE gr_role_parent2;
DROP ROLE gr_role_child2;
DROP ROLE gr_role_parent3;
DROP ROLE gr_role_child3;

RESET client_min_messages;
