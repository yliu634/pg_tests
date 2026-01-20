-- PostgreSQL compatible tests from drop_user
--
-- CockroachDB has SHOW USERS, USE, and system tables not present in PG. In
-- PostgreSQL, "users" are roles. This file exercises CREATE ROLE / DROP ROLE
-- and the need to drop/revoke owned privileges before dropping a role.

SET client_min_messages = warning;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'drop_user_user1') THEN
    EXECUTE 'DROP OWNED BY drop_user_user1';
    EXECUTE 'DROP ROLE drop_user_user1';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'drop_user_user2') THEN
    EXECUTE 'DROP OWNED BY drop_user_user2';
    EXECUTE 'DROP ROLE drop_user_user2';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'drop_user_user3') THEN
    EXECUTE 'DROP OWNED BY drop_user_user3';
    EXECUTE 'DROP ROLE drop_user_user3';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'drop_user_user4') THEN
    EXECUTE 'DROP OWNED BY drop_user_user4';
    EXECUTE 'DROP ROLE drop_user_user4';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'drop_user_default_priv_user') THEN
    EXECUTE 'DROP OWNED BY drop_user_default_priv_user';
    EXECUTE 'DROP ROLE drop_user_default_priv_user';
  END IF;
END
$$;
DROP TABLE IF EXISTS drop_user_tbl;
RESET client_min_messages;

CREATE ROLE drop_user_user1 LOGIN;
CREATE ROLE drop_user_user2 LOGIN;
CREATE ROLE drop_user_user3 LOGIN;
CREATE ROLE drop_user_user4 LOGIN;

SELECT rolname FROM pg_roles WHERE rolname LIKE 'drop_user_%' ORDER BY rolname;

DROP ROLE drop_user_user1;
DROP ROLE IF EXISTS drop_user_user1;

SELECT rolname FROM pg_roles WHERE rolname LIKE 'drop_user_%' ORDER BY rolname;

-- Demonstrate dropping a role with granted privileges using DROP OWNED.
CREATE TABLE drop_user_tbl(x INT);
GRANT SELECT ON drop_user_tbl TO drop_user_user3;
DROP OWNED BY drop_user_user3;
DROP ROLE drop_user_user3;

-- Default privileges can also require cleanup before dropping a role.
CREATE ROLE drop_user_default_priv_user LOGIN;
ALTER DEFAULT PRIVILEGES FOR ROLE drop_user_default_priv_user REVOKE ALL ON TABLES FROM PUBLIC;
DROP OWNED BY drop_user_default_priv_user;
DROP ROLE drop_user_default_priv_user;

DROP TABLE drop_user_tbl;
DROP ROLE drop_user_user2, drop_user_user4;

SELECT rolname FROM pg_roles WHERE rolname LIKE 'drop_user_%' ORDER BY rolname;

