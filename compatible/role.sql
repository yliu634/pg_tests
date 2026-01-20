-- PostgreSQL compatible tests from role
--
-- The upstream CockroachDB logic-test file uses Cockroach-only `SHOW ROLES` and
-- system tables. This reduced version exercises PostgreSQL role creation,
-- membership grants, and inspection via pg_auth_members.

SET client_min_messages = warning;

DROP ROLE IF EXISTS role_a;
DROP ROLE IF EXISTS role_b;
DROP ROLE IF EXISTS role_c;

CREATE ROLE role_a;
CREATE ROLE role_b;
CREATE ROLE role_c;

GRANT role_a TO role_b;
GRANT role_b TO role_c WITH ADMIN OPTION;

SELECT
  pg_get_userbyid(roleid)  AS role,
  pg_get_userbyid(member)  AS member,
  admin_option
FROM pg_auth_members
WHERE pg_get_userbyid(roleid) IN ('role_a', 'role_b')
ORDER BY 1, 2;

SET ROLE role_c;
SELECT current_user, session_user;
RESET ROLE;

DROP ROLE role_c;
DROP ROLE role_b;
DROP ROLE role_a;

RESET client_min_messages;
