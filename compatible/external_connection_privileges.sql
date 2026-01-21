-- PostgreSQL compatible tests from external_connection_privileges
-- PostgreSQL does not support CRDB EXTERNAL CONNECTION objects; this file exercises
-- analogous GRANT/REVOKE behavior using SEQUENCE privileges.

-- Clean up any leftovers from a previous run (roles are cluster-global).
-- Drop the sequence first to remove any privilege dependencies, then drop roles.
DROP SEQUENCE IF EXISTS extconn_priv_seq;

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'extconn_priv_testuser') THEN
    -- If present, remove the membership added below so DROP ROLE succeeds.
    BEGIN
      EXECUTE 'REVOKE extconn_priv_testuser FROM pan';
    EXCEPTION WHEN OTHERS THEN
      NULL;
    END;
    EXECUTE 'DROP ROLE extconn_priv_testuser';
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'extconn_priv_bar') THEN
    EXECUTE 'DROP ROLE extconn_priv_bar';
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'extconn_priv_testuser2') THEN
    EXECUTE 'DROP ROLE extconn_priv_testuser2';
  END IF;
END $$;

CREATE ROLE extconn_priv_testuser;
CREATE ROLE extconn_priv_bar;
CREATE ROLE extconn_priv_testuser2;

-- Allow SET ROLE in this script.
GRANT extconn_priv_testuser TO pan;

CREATE SEQUENCE extconn_priv_seq;

-- Inspect privileges via pg_class ACLs.
SELECT grantee::regrole AS grantee, privilege_type, is_grantable
FROM pg_class c, LATERAL aclexplode(c.relacl) a
WHERE c.relkind = 'S' AND c.relname = 'extconn_priv_seq'
ORDER BY grantee::regrole::text, privilege_type;

GRANT USAGE ON SEQUENCE extconn_priv_seq TO extconn_priv_testuser;
GRANT SELECT ON SEQUENCE extconn_priv_seq TO extconn_priv_testuser;
GRANT UPDATE ON SEQUENCE extconn_priv_seq TO extconn_priv_testuser;

SELECT grantee::regrole AS grantee, privilege_type, is_grantable
FROM pg_class c, LATERAL aclexplode(c.relacl) a
WHERE c.relkind = 'S' AND c.relname = 'extconn_priv_seq'
ORDER BY grantee::regrole::text, privilege_type;

REVOKE USAGE, SELECT, UPDATE ON SEQUENCE extconn_priv_seq FROM extconn_priv_testuser;

SELECT grantee::regrole AS grantee, privilege_type, is_grantable
FROM pg_class c, LATERAL aclexplode(c.relacl) a
WHERE c.relkind = 'S' AND c.relname = 'extconn_priv_seq'
ORDER BY grantee::regrole::text, privilege_type;

GRANT USAGE, SELECT, UPDATE ON SEQUENCE extconn_priv_seq TO extconn_priv_testuser;
GRANT USAGE, SELECT, UPDATE ON SEQUENCE extconn_priv_seq TO extconn_priv_bar;

-- Grant option propagation.
GRANT USAGE, SELECT, UPDATE ON SEQUENCE extconn_priv_seq TO extconn_priv_testuser WITH GRANT OPTION;

SET ROLE extconn_priv_testuser;
GRANT USAGE, UPDATE ON SEQUENCE extconn_priv_seq TO extconn_priv_bar;
RESET ROLE;

SELECT grantee::regrole AS grantee, privilege_type, is_grantable
FROM pg_class c, LATERAL aclexplode(c.relacl) a
WHERE c.relkind = 'S' AND c.relname = 'extconn_priv_seq'
ORDER BY grantee::regrole::text, privilege_type;

GRANT USAGE, SELECT, UPDATE ON SEQUENCE extconn_priv_seq TO extconn_priv_testuser2 WITH GRANT OPTION;

-- "SHOW GRANTS" equivalent.
SELECT grantee::regrole AS grantee, privilege_type, is_grantable
FROM pg_class c, LATERAL aclexplode(c.relacl) a
WHERE c.relkind = 'S'
  AND c.relname = 'extconn_priv_seq'
  AND grantee::regrole::text IN ('extconn_priv_testuser', 'extconn_priv_testuser2')
ORDER BY grantee::regrole::text, privilege_type;

-- Final cleanup.
DROP SEQUENCE extconn_priv_seq;

-- Memberships can block DROP ROLE, so remove the one we added above.
REVOKE extconn_priv_testuser FROM pan;

DROP ROLE extconn_priv_bar;
DROP ROLE extconn_priv_testuser2;
DROP ROLE extconn_priv_testuser;
