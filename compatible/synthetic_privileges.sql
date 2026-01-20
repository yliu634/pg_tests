-- PostgreSQL compatible tests from synthetic_privileges
-- Reduced subset: CockroachDB SYSTEM privileges/external connections are not
-- available in PostgreSQL; validate basic GRANT/REVOKE behavior instead.

SET client_min_messages = warning;
DROP TABLE IF EXISTS priv_test CASCADE;
DROP ROLE IF EXISTS sp_testuser;
RESET client_min_messages;

CREATE ROLE sp_testuser;

CREATE TABLE priv_test (id INT);
INSERT INTO priv_test VALUES (1), (2);

GRANT SELECT ON priv_test TO sp_testuser;

SELECT grantee, privilege_type
FROM information_schema.table_privileges
WHERE table_schema = 'public' AND table_name = 'priv_test'
ORDER BY grantee, privilege_type;

REVOKE SELECT ON priv_test FROM sp_testuser;

SELECT grantee, privilege_type
FROM information_schema.table_privileges
WHERE table_schema = 'public' AND table_name = 'priv_test'
ORDER BY grantee, privilege_type;
