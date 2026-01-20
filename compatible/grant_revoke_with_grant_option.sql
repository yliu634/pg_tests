-- PostgreSQL compatible tests from grant_revoke_with_grant_option
--
-- CockroachDB logic tests used user switching directives and SHOW GRANTS.
-- PostgreSQL validates GRANT OPTION semantics via information_schema.table_privileges.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS target;

CREATE ROLE testuser;
CREATE ROLE testuser2;
CREATE ROLE target;

CREATE TABLE t (row INT);

-- Give testuser full privileges and the ability to re-grant.
GRANT ALL PRIVILEGES ON TABLE t TO testuser WITH GRANT OPTION;

-- Act as testuser to grant downstream privileges.
SET ROLE testuser;
GRANT SELECT ON TABLE t TO target;
GRANT INSERT ON TABLE t TO testuser2;
RESET ROLE;

-- Inspect direct grants (stable ordering).
SELECT grantor, grantee, table_name, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'public'
  AND table_name = 't'
  AND grantee IN ('testuser', 'testuser2', 'target')
ORDER BY grantee, privilege_type;

-- Remove only the grant option for SELECT from testuser. PostgreSQL requires
-- CASCADE if that grant option was used to grant SELECT onward.
REVOKE GRANT OPTION FOR SELECT ON TABLE t FROM testuser CASCADE;

SELECT grantor, grantee, table_name, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'public'
  AND table_name = 't'
  AND grantee IN ('testuser', 'testuser2', 'target')
ORDER BY grantee, privilege_type;

-- Cleanup.
DROP TABLE t;
DROP OWNED BY testuser, testuser2, target;
DROP ROLE testuser;
DROP ROLE testuser2;
DROP ROLE target;

RESET client_min_messages;
