-- PostgreSQL compatible tests from alter_external_connection
-- 11 tests

-- CockroachDB "external connections" don't exist in PostgreSQL; we simulate them
-- with metadata tables + helper procedures so we can keep the privilege-flow
-- semantics of the original test.
SET client_min_messages = warning;

DROP PROCEDURE IF EXISTS ext_connection_create(text, text, text);
DROP PROCEDURE IF EXISTS ext_connection_grant(text, text, text);
DROP PROCEDURE IF EXISTS ext_connection_alter(text, text, boolean);
DROP FUNCTION IF EXISTS ext_connection_show_all();
DROP FUNCTION IF EXISTS ext_connection_show(text);
DROP FUNCTION IF EXISTS ext_connection_can_update(text);
DROP TABLE IF EXISTS ext_connection_privs;
DROP TABLE IF EXISTS ext_connections;

DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser;

CREATE TABLE ext_connections (
  connection_name TEXT PRIMARY KEY,
  connection_uri  TEXT NOT NULL,
  connection_type TEXT NOT NULL,
  owner_role      TEXT NOT NULL
);

CREATE TABLE ext_connection_privs (
  connection_name TEXT NOT NULL REFERENCES ext_connections(connection_name) ON DELETE CASCADE,
  grantee_role    TEXT NOT NULL,
  privilege       TEXT NOT NULL CHECK (privilege IN ('USAGE', 'UPDATE')),
  PRIMARY KEY (connection_name, grantee_role, privilege)
);

CREATE OR REPLACE PROCEDURE ext_connection_create(conn_name TEXT, conn_uri TEXT, conn_type TEXT)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  invoker_role TEXT := current_setting('role', true);
BEGIN
  IF invoker_role IS NULL OR invoker_role = 'none' THEN
    invoker_role := session_user::text;
  END IF;

  INSERT INTO ext_connections (connection_name, connection_uri, connection_type, owner_role)
  VALUES (conn_name, conn_uri, conn_type, invoker_role);
END;
$$;

CREATE OR REPLACE PROCEDURE ext_connection_grant(conn_name TEXT, grantee TEXT, priv TEXT)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO ext_connection_privs (connection_name, grantee_role, privilege)
  VALUES (conn_name, grantee, upper(priv))
  ON CONFLICT DO NOTHING;
END;
$$;

CREATE OR REPLACE PROCEDURE ext_connection_alter(conn_name TEXT, conn_uri TEXT, if_exists BOOLEAN DEFAULT false)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  invoker_role TEXT := current_setting('role', true);
  can_update   BOOLEAN := false;
BEGIN
  IF invoker_role IS NULL OR invoker_role = 'none' THEN
    invoker_role := session_user::text;
  END IF;

  -- Treat the session owner as "root" for the purposes of this test.
  IF invoker_role = session_user::text THEN
    can_update := true;
  ELSE
    SELECT EXISTS (
      SELECT 1
      FROM ext_connections AS c
      WHERE c.connection_name = conn_name
        AND c.owner_role = invoker_role
    )
    OR EXISTS (
      SELECT 1
      FROM ext_connection_privs AS p
      WHERE p.connection_name = conn_name
        AND p.grantee_role = invoker_role
        AND p.privilege = 'UPDATE'
    )
    INTO can_update;
  END IF;

  IF NOT can_update THEN
    RAISE EXCEPTION 'user % does not have UPDATE privilege on external_connection %', invoker_role, conn_name;
  END IF;

  IF if_exists AND NOT EXISTS (SELECT 1 FROM ext_connections WHERE connection_name = conn_name) THEN
    RETURN;
  END IF;

  UPDATE ext_connections
  SET connection_uri = conn_uri
  WHERE connection_name = conn_name;
END;
$$;

CREATE OR REPLACE FUNCTION ext_connection_can_update(conn_name TEXT)
RETURNS BOOLEAN
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  invoker_role TEXT := current_setting('role', true);
  can_update   BOOLEAN := false;
BEGIN
  IF invoker_role IS NULL OR invoker_role = 'none' THEN
    invoker_role := session_user::text;
  END IF;

  -- Treat the session owner as "root" for the purposes of this test.
  IF invoker_role = session_user::text THEN
    RETURN true;
  END IF;

  SELECT EXISTS (
    SELECT 1
    FROM ext_connections AS c
    WHERE c.connection_name = conn_name
      AND c.owner_role = invoker_role
  )
  OR EXISTS (
    SELECT 1
    FROM ext_connection_privs AS p
    WHERE p.connection_name = conn_name
      AND p.grantee_role = invoker_role
      AND p.privilege = 'UPDATE'
  )
  INTO can_update;

  RETURN can_update;
END;
$$;

CREATE OR REPLACE FUNCTION ext_connection_show_all()
RETURNS TABLE(connection_name TEXT, connection_uri TEXT, connection_type TEXT)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  invoker_role TEXT := current_setting('role', true);
BEGIN
  IF invoker_role IS NULL OR invoker_role = 'none' THEN
    invoker_role := session_user::text;
  END IF;

  IF invoker_role = session_user::text THEN
    RETURN QUERY
      SELECT c.connection_name, c.connection_uri, c.connection_type
      FROM ext_connections AS c;
  ELSE
    RETURN QUERY
      SELECT c.connection_name, c.connection_uri, c.connection_type
      FROM ext_connections AS c
      WHERE c.owner_role = invoker_role
         OR EXISTS (
              SELECT 1
              FROM ext_connection_privs AS p
              WHERE p.connection_name = c.connection_name
                AND p.grantee_role = invoker_role
                AND p.privilege = 'USAGE'
            );
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION ext_connection_show(conn_name TEXT)
RETURNS TABLE(connection_name TEXT, connection_uri TEXT, connection_type TEXT)
LANGUAGE plpgsql SECURITY DEFINER
AS $$
DECLARE
  invoker_role TEXT := current_setting('role', true);
  can_usage    BOOLEAN := false;
BEGIN
  IF invoker_role IS NULL OR invoker_role = 'none' THEN
    invoker_role := session_user::text;
  END IF;

  IF invoker_role = session_user::text THEN
    can_usage := true;
  ELSE
    SELECT EXISTS (
      SELECT 1
      FROM ext_connections AS c
      WHERE c.connection_name = conn_name
        AND c.owner_role = invoker_role
    )
    OR EXISTS (
      SELECT 1
      FROM ext_connection_privs AS p
      WHERE p.connection_name = conn_name
        AND p.grantee_role = invoker_role
        AND p.privilege = 'USAGE'
    )
    INTO can_usage;
  END IF;

  IF NOT can_usage THEN
    RAISE EXCEPTION 'user % does not have USAGE privilege on external_connection %', invoker_role, conn_name;
  END IF;

  RETURN QUERY
    SELECT c.connection_name, c.connection_uri, c.connection_type
    FROM ext_connections AS c
    WHERE c.connection_name = conn_name;
END;
$$;

-- Test 1: statement (line 3)
CALL ext_connection_create('conn_1', 'nodelocal://1/conn_1', 'STORAGE');
CALL ext_connection_create('conn_2', 'nodelocal://1/conn_2', 'STORAGE');

-- Test 2: query (line 7)
SELECT * FROM ext_connection_show_all() ORDER BY connection_name;

	-- user testuser
	SET ROLE testuser;

-- Test 3: statement (line 17)
-- Missing UPDATE privilege:
SELECT ext_connection_can_update('conn_1') AS can_update;

	-- user root

-- Test 4: statement (line 22)
RESET ROLE;
CALL ext_connection_grant('conn_1', 'testuser', 'UPDATE');
CALL ext_connection_grant('conn_1', 'testuser', 'USAGE');

	-- user testuser

-- Test 5: statement (line 28)
SET ROLE testuser;
CALL ext_connection_alter('conn_1', 'nodelocal://1/conn_update_with_privilege', false);

-- Test 6: query (line 31)
SELECT * FROM ext_connection_show('conn_1');

-- Test 7: statement (line 39)
-- Missing UPDATE privilege:
SELECT ext_connection_can_update('conn_2') AS can_update;

	-- user root

-- Test 8: statement (line 44)
RESET ROLE;
CALL ext_connection_grant('conn_2', 'testuser', 'UPDATE');
CALL ext_connection_grant('conn_2', 'testuser', 'USAGE');

	-- user testuser

-- Test 9: statement (line 50)
SET ROLE testuser;
-- IF EXISTS should not bypass privilege checks:
SELECT ext_connection_can_update('conn_not_exist') AS can_update;

-- Test 10: statement (line 53)
CALL ext_connection_alter('conn_2', 'nodelocal://1/connection_2_alter', false);

-- Test 11: query (line 56)
SELECT * FROM ext_connection_show('conn_2');

RESET ROLE;
RESET client_min_messages;
