-- PostgreSQL compatible tests from grant_table
--
-- CockroachDB logic tests relied on SHOW GRANTS and database switching.
-- PostgreSQL exposes grants via information_schema.table_privileges.

SET client_min_messages = warning;

DROP VIEW IF EXISTS gt_v;
DROP TABLE IF EXISTS gt_t;
DROP ROLE IF EXISTS gt_readwrite;
DROP ROLE IF EXISTS "gt_test-user";

CREATE ROLE gt_readwrite;
CREATE ROLE "gt_test-user";

CREATE TABLE gt_t (id INT PRIMARY KEY);
CREATE VIEW gt_v AS SELECT id FROM gt_t;

GRANT ALL PRIVILEGES ON TABLE gt_t TO gt_readwrite, "gt_test-user";
GRANT SELECT ON TABLE gt_v TO gt_readwrite, "gt_test-user";

SELECT grantor, grantee, table_name, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'public'
  AND table_name IN ('gt_t', 'gt_v')
  AND grantee IN ('gt_readwrite', 'gt_test-user')
ORDER BY table_name, grantee, privilege_type;

REVOKE INSERT, DELETE ON TABLE gt_t FROM gt_readwrite, "gt_test-user";
REVOKE SELECT ON TABLE gt_v FROM "gt_test-user";

SELECT grantor, grantee, table_name, privilege_type, is_grantable
FROM information_schema.table_privileges
WHERE table_schema = 'public'
  AND table_name IN ('gt_t', 'gt_v')
  AND grantee IN ('gt_readwrite', 'gt_test-user')
ORDER BY table_name, grantee, privilege_type;

-- Cleanup.
DROP VIEW gt_v;
DROP TABLE gt_t;
DROP OWNED BY gt_readwrite, "gt_test-user";
DROP ROLE gt_readwrite;
DROP ROLE "gt_test-user";

RESET client_min_messages;
