-- PostgreSQL compatible tests from database
-- NOTE: CockroachDB database tests often rely on logic-test directives and cluster features.
-- This file is rewritten as a focused PostgreSQL database/role smoke test.

SET client_min_messages = warning;

-- Role + database setup.
SELECT 'DROP OWNED BY dbuser;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dbuser')
\gexec
SELECT 'DROP ROLE dbuser;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dbuser')
\gexec

CREATE ROLE dbuser;

\connect postgres
DROP DATABASE IF EXISTS db_smoke WITH (FORCE);
CREATE DATABASE db_smoke;
GRANT CONNECT ON DATABASE db_smoke TO dbuser;
COMMENT ON DATABASE db_smoke IS 'db smoke';

SELECT datname, shobj_description(oid, 'pg_database') AS comment
FROM pg_database
WHERE datname IN ('db_smoke', current_database())
ORDER BY datname;

\connect db_smoke
CREATE SCHEMA s;
CREATE TABLE s.t (id INT PRIMARY KEY);
INSERT INTO s.t (id) VALUES (1), (2);
SELECT * FROM s.t ORDER BY id;

\connect postgres
DROP DATABASE IF EXISTS db_smoke WITH (FORCE);

-- Cleanup role.
SELECT 'DROP OWNED BY dbuser;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dbuser')
\gexec
SELECT 'DROP ROLE dbuser;'
WHERE EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'dbuser')
\gexec

RESET client_min_messages;
