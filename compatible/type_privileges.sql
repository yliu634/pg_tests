-- PostgreSQL compatible tests from type_privileges
-- Reduced subset: CockroachDB type privileges (SELECT/INSERT/ZONECONFIG, etc)
-- do not exist in PostgreSQL. Validate USAGE privileges on a type.

SET client_min_messages = warning;
DROP ROLE IF EXISTS type_testuser;
DROP TYPE IF EXISTS test_enum;
RESET client_min_messages;

CREATE ROLE type_testuser;
CREATE TYPE test_enum AS ENUM ('hello');

REVOKE USAGE ON TYPE test_enum FROM PUBLIC;
SELECT has_type_privilege('type_testuser', 'test_enum', 'USAGE') AS has_usage_before;

GRANT USAGE ON TYPE test_enum TO type_testuser;
SELECT has_type_privilege('type_testuser', 'test_enum', 'USAGE') AS has_usage_after;

CREATE TABLE for_view(x test_enum);
GRANT SELECT ON for_view TO type_testuser;

SELECT table_name, grantee, privilege_type
FROM information_schema.table_privileges
WHERE table_name = 'for_view'
ORDER BY grantee, privilege_type;
