-- PostgreSQL compatible tests from alter_external_connection
-- 11 tests

SET client_min_messages = warning;

-- PostgreSQL does not have CockroachDB external connections.
-- Model them with a simple table and exercise similar privilege patterns.

-- Setup / cleanup to make the script re-runnable.
DROP TABLE IF EXISTS external_connections;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

CREATE ROLE root SUPERUSER;
CREATE ROLE testuser;

SET ROLE root;

CREATE TABLE external_connections (
  name TEXT PRIMARY KEY,
  uri  TEXT NOT NULL
);

-- Test 1: statement (line 3)
INSERT INTO external_connections (name, uri)
VALUES ('conn_1', 'nodelocal://1/conn_1');
INSERT INTO external_connections (name, uri)
VALUES ('conn_2', 'nodelocal://1/conn_2');

-- Test 2: query (line 7)
SELECT name, uri FROM external_connections ORDER BY name;

-- Test 3: statement (line 17)
UPDATE external_connections
SET uri = 'nodelocal://1/conn_update'
WHERE name = 'conn_1';

-- user root

-- Test 4: statement (line 22)
-- Map CockroachDB's UPDATE/USAGE privileges to UPDATE/SELECT on the table.
GRANT UPDATE, SELECT ON TABLE external_connections TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 5: statement (line 28)
UPDATE external_connections
SET uri = 'nodelocal://1/conn_update_with_privilege'
WHERE name = 'conn_1';

-- Test 6: query (line 31)
SELECT name, uri FROM external_connections WHERE name = 'conn_1' ORDER BY name;

-- Test 7: statement (line 39)
RESET ROLE;
SET ROLE root;
UPDATE external_connections
SET uri = 'nodelocal://1/conn_update'
WHERE name = 'conn_2';

-- user root

-- Test 8: statement (line 44)
GRANT UPDATE, SELECT ON TABLE external_connections TO testuser;

-- user testuser
SET ROLE testuser;

-- Test 9: statement (line 50)
-- IF EXISTS: no error if it doesn't exist, just 0 rows updated.
UPDATE external_connections
SET uri = 'nodelocal://1/not_exist'
WHERE name = 'conn_not_exist';

-- Test 10: statement (line 53)
UPDATE external_connections
SET uri = 'nodelocal://1/connection_2_alter'
WHERE name = 'conn_2';

-- Test 11: query (line 56)
SELECT name, uri FROM external_connections WHERE name = 'conn_2' ORDER BY name;

-- Cleanup.
RESET ROLE;
DROP TABLE IF EXISTS external_connections;
DROP OWNED BY testuser;
DROP OWNED BY root;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

RESET client_min_messages;
