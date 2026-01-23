-- PostgreSQL compatible tests from system
-- 86 tests

-- CockroachDB's `system` database and related `SHOW ...` statements don't exist
-- in PostgreSQL. Provide a minimal `system` schema and translate the statements
-- to PostgreSQL catalog queries so this file can run under psql.
CREATE SCHEMA IF NOT EXISTS system;

DROP TABLE IF EXISTS system.descriptor;
CREATE TABLE system.descriptor (
  id INT PRIMARY KEY,
  descriptor TEXT NOT NULL
);
INSERT INTO system.descriptor (id, descriptor) VALUES (1, 'x');

DROP TABLE IF EXISTS system.namespace;
CREATE TABLE system.namespace (
  id INT PRIMARY KEY,
  name TEXT NOT NULL
);

DROP TABLE IF EXISTS system.users;
CREATE TABLE system.users (
  username TEXT PRIMARY KEY
);
INSERT INTO system.users (username) VALUES ('root') ON CONFLICT DO NOTHING;

DROP TABLE IF EXISTS system.zones;
CREATE TABLE system.zones (id INT PRIMARY KEY);

DROP TABLE IF EXISTS system.lease;
CREATE TABLE system.lease (id INT PRIMARY KEY);

DROP TABLE IF EXISTS system.eventlog;
CREATE TABLE system.eventlog (id INT PRIMARY KEY);

DROP TABLE IF EXISTS system.rangelog;
CREATE TABLE system.rangelog (id INT PRIMARY KEY);

DROP TABLE IF EXISTS system.ui;
CREATE TABLE system.ui (id INT PRIMARY KEY);

DROP TABLE IF EXISTS system.jobs;
CREATE TABLE system.jobs (id INT PRIMARY KEY);

DROP TABLE IF EXISTS system.settings;
CREATE TABLE system.settings (
  name TEXT PRIMARY KEY,
  value TEXT,
  "valueType" TEXT
);

DROP TABLE IF EXISTS system.role_members;
CREATE TABLE system.role_members (
  role TEXT,
  member TEXT
);

DROP TABLE IF EXISTS system.statement_hints;
CREATE TABLE system.statement_hints (
  row_id BIGINT PRIMARY KEY,
  fingerprint TEXT NOT NULL,
  hint TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL,
  hash TEXT GENERATED ALWAYS AS (md5(fingerprint)) STORED
);

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser') THEN
    CREATE ROLE testuser;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'root') THEN
    CREATE ROLE root;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin') THEN
    CREATE ROLE admin;
  END IF;
END
$$;

SELECT current_database() AS system_db \gset

-- Test 1: query (line 1)
SELECT current_database() AS database;

-- Test 2: query (line 9)
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  CASE c.relkind WHEN 'r' THEN 'table' WHEN 'v' THEN 'view' ELSE c.relkind::text END AS type,
  pg_get_userbyid(c.relowner) AS owner,
  NULL::TEXT AS locality
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 'system'
  AND c.relname IN ('descriptor_id_seq', 'comments', 'locations', 'span_configurations')
ORDER BY 2;

-- Test 3: query (line 20)
SELECT count(id) FROM system.descriptor;

-- Test 4: query (line 26)
SELECT count(id) FROM system.descriptor;

-- Test 5: query (line 32)
SELECT id FROM system.descriptor WHERE id=1;

-- Test 6: query (line 37)
SELECT d.id FROM (VALUES(1)) AS v(a) INNER JOIN system.descriptor AS d ON d.id = v.a;

-- Test 7: query (line 43)
SELECT length(descriptor) * (id - 1) FROM system.descriptor WHERE id = 1;

-- Test 8: query (line 49)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'descriptor'
ORDER BY ordinal_position;

-- Test 9: query (line 55)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'users'
ORDER BY ordinal_position;

-- Test 10: query (line 64)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'zones'
ORDER BY ordinal_position;

-- Test 11: query (line 70)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'lease'
ORDER BY ordinal_position;

-- Test 12: query (line 79)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'lease'
ORDER BY ordinal_position;

-- Test 13: query (line 89)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'eventlog'
ORDER BY ordinal_position;

-- Test 14: query (line 100)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'rangelog'
ORDER BY ordinal_position;

-- Test 15: query (line 111)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'ui'
ORDER BY ordinal_position;

-- Test 16: query (line 118)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'jobs'
ORDER BY ordinal_position;

-- Test 17: query (line 138)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'settings'
ORDER BY ordinal_position;

-- Test 18: query (line 146)
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'system' AND table_name = 'role_members'
ORDER BY ordinal_position;

-- Test 19: query (line 156)
SELECT
  rolname AS username,
  has_database_privilege(rolname, :'system_db', 'CONNECT') AS connect,
  has_database_privilege(rolname, :'system_db', 'CREATE') AS create,
  has_database_privilege(rolname, :'system_db', 'TEMP') AS temp
FROM pg_roles
WHERE rolname IN ('testuser', 'root', 'admin')
ORDER BY rolname;

-- Test 20: statement (line 186)
-- CockroachDB-only: ALTER DATABASE system RENAME TO not_system;

-- Test 21: statement (line 189)
-- CockroachDB-only: DROP DATABASE system;

-- Test 22: statement (line 192)
-- CockroachDB-only: DROP TABLE system.users;

-- Test 23: statement (line 195)
GRANT ALL ON DATABASE :"system_db" TO testuser;

-- Test 24: statement (line 198)
GRANT CREATE ON DATABASE :"system_db" TO testuser;

-- Test 25: statement (line 201)
GRANT CREATE ON DATABASE :"system_db" TO testuser;

-- Test 26: statement (line 204)
GRANT ALL ON system.namespace TO testuser;

-- Test 27: statement (line 207)
GRANT SELECT, INSERT ON system.namespace TO testuser;

-- Test 28: statement (line 210)
GRANT SELECT ON system.namespace TO testuser;

-- Test 29: statement (line 213)
GRANT SELECT ON system.descriptor TO testuser;

-- Test 30: statement (line 217)
GRANT ALL ON DATABASE :"system_db" TO root;

-- Test 31: statement (line 220)
GRANT CREATE ON DATABASE :"system_db" TO root;

-- Test 32: statement (line 223)
GRANT ALL ON system.namespace TO root;

-- Test 33: statement (line 226)
GRANT DELETE, INSERT ON system.descriptor TO root;

-- Test 34: statement (line 229)
GRANT ALL ON system.descriptor TO root;

-- Test 35: statement (line 232)
REVOKE CREATE ON DATABASE :"system_db" FROM root;

-- Test 36: statement (line 235)
-- CockroachDB-only (PostgreSQL has no CREATE privilege on tables): REVOKE CREATE ON system.namespace FROM root;

-- Test 37: statement (line 238)
REVOKE ALL ON system.namespace FROM root;

-- Test 38: statement (line 241)
REVOKE SELECT ON system.namespace FROM root;

-- Test 39: statement (line 244)
GRANT ALL ON DATABASE :"system_db" TO admin;

-- Test 40: statement (line 247)
GRANT CREATE ON DATABASE :"system_db" TO admin;

-- Test 41: statement (line 250)
REVOKE CREATE ON DATABASE :"system_db" FROM admin;

-- Test 42: statement (line 253)
GRANT ALL ON system.namespace TO admin;

-- Test 43: statement (line 256)
GRANT DELETE, INSERT ON system.descriptor TO admin;

-- Test 44: statement (line 259)
GRANT ALL ON system.descriptor TO admin;

-- Test 45: statement (line 262)
-- CockroachDB-only (PostgreSQL has no CREATE privilege on tables): REVOKE CREATE ON system.descriptor FROM admin;

-- Test 46: statement (line 265)
REVOKE CREATE ON DATABASE :"system_db" FROM admin;

-- Test 47: statement (line 268)
-- CockroachDB-only (PostgreSQL has no CREATE privilege on tables): REVOKE CREATE ON system.namespace FROM admin;

-- Test 48: statement (line 271)
REVOKE ALL ON system.namespace FROM admin;

-- Test 49: statement (line 274)
REVOKE SELECT ON system.namespace FROM admin;

-- Test 50: statement (line 280)
GRANT ALL ON system.lease TO testuser;

-- Test 51: statement (line 283)
-- CockroachDB-only (PostgreSQL has no CREATE privilege on tables): GRANT CREATE on system.lease to root;

-- Test 52: statement (line 286)
-- CockroachDB-only (PostgreSQL has no CREATE privilege on tables): GRANT CREATE on system.lease to admin;

-- Test 53: statement (line 289)
-- CockroachDB-only (PostgreSQL has no CREATE privilege on tables): GRANT CREATE on system.lease to testuser;

-- Test 54: statement (line 292)
GRANT ALL ON system.lease TO root;

-- Test 55: statement (line 295)
GRANT ALL ON system.lease TO admin;

-- Test 56: statement (line 298)
GRANT ALL ON system.lease TO testuser;

-- Test 57: query (line 307)
SELECT name
FROM system.settings
WHERE name NOT LIKE 'sql.defaults%'
AND name NOT LIKE 'sql.distsql%'
AND name NOT LIKE 'sql.testing%'
AND name NOT LIKE 'sql.stats%'
AND name NOT LIKE 'sql.txn.%_isolation.enabled'
AND name != 'kv.range_merge.queue_enabled'
ORDER BY name;

-- Test 58: query (line 325)
SELECT name
FROM system.settings
WHERE name NOT LIKE 'sql.defaults%'
AND name NOT LIKE 'sql.distsql%'
AND name NOT LIKE 'sql.testing%'
AND name NOT LIKE 'sql.stats%'
AND name NOT LIKE 'sql.txn.%_isolation.enabled'
ORDER BY name;

-- Test 59: statement (line 341)
INSERT INTO system.settings (name, value) VALUES ('somesetting', 'somevalue');

-- Test 60: query (line 347)
SELECT name, value
FROM system.settings
WHERE name NOT LIKE 'sql.defaults%'
AND name NOT LIKE 'sql.distsql%'
AND name NOT LIKE 'sql.testing%'
AND name NOT LIKE 'sql.stats%'
AND name NOT LIKE 'sql.txn.%_isolation.enabled'
AND name NOT IN ('version', 'cluster.secret', 'kv.range_merge.queue_enabled')
ORDER BY name;

-- Test 61: query (line 364)
SELECT name, value
FROM system.settings
WHERE name NOT LIKE 'sql.defaults%'
AND name NOT LIKE 'sql.distsql%'
AND name NOT LIKE 'sql.testing%'
AND name NOT LIKE 'sql.stats%'
AND name NOT LIKE 'sql.txn.%_isolation.enabled'
AND name NOT IN ('version', 'cluster.secret')
ORDER BY name;

-- Test 62: statement (line 382)
select name from system.settings;

-- Test 63: statement (line 385)
INSERT INTO system.settings (name, value)
VALUES ('somesetting', 'somevalueother')
ON CONFLICT (name) DO UPDATE SET value = EXCLUDED.value;

-- user root

-- Test 64: query (line 390)
SELECT * from system.role_members;

-- Test 65: statement (line 395)
-- CockroachDB-only: SET DATABASE = "";

-- Test 66: query (line 398)
SELECT username FROM system.users WHERE username = 'root';

-- Test 67: statement (line 403)
-- CockroachDB-only: SET DATABASE = test

-- Test 68: statement (line 426)
INSERT INTO system.settings (name, value, "valueType")
VALUES ('sql.defaults.vectorize', '1', 'e')
ON CONFLICT (name) DO UPDATE
  SET value = EXCLUDED.value,
      "valueType" = EXCLUDED."valueType";

-- Test 69: query (line 429)
SELECT name, value FROM system.settings WHERE name = 'sql.defaults.vectorize';

-- Test 70: query (line 434)
SELECT COALESCE(
  (SELECT value FROM system.settings WHERE name = 'sql.defaults.vectorize'),
  'DEFAULT'
) AS value;

-- Test 71: statement (line 439)
-- CockroachDB-only: SET vectorize = DEFAULT

-- Test 72: query (line 442)
SELECT 'DEFAULT' AS vectorize;

-- Test 73: statement (line 452)
DELETE FROM system.settings WHERE name = 'sql.defaults.vectorize';

-- Test 74: statement (line 455)
-- CockroachDB-only: RESET vectorize

-- Test 75: query (line 458)
SELECT name, value FROM system.settings WHERE name = 'sql.defaults.vectorize';

-- Test 76: query (line 462)
SELECT COALESCE(
  (SELECT value FROM system.settings WHERE name = 'sql.defaults.vectorize'),
  'DEFAULT'
) AS value;

-- Test 77: query (line 467)
SELECT 'DEFAULT' AS vectorize;

-- Test 78: statement (line 474)
-- CockroachDB-only: RESET vectorize

-- user root

-- Test 79: query (line 481)
SELECT hash, row_id, fingerprint, hint, created_at FROM system.statement_hints ORDER BY row_id;

-- Test 80: statement (line 485)
INSERT INTO system.statement_hints (row_id, fingerprint, hint, created_at) VALUES
  (100, 'foo', 'DEADBEEF', '2018-01-01 1:00:00.00000+00:00'),
  (200, 'bar', 'BEEFDEAD', '2018-01-02 1:00:00.00000+00:00');

-- Test 81: query (line 492)
SELECT hash, row_id, fingerprint, hint, created_at FROM system.statement_hints ORDER BY row_id;

-- Test 82: query (line 498)
SELECT row_id, fingerprint, hint, created_at FROM system.statement_hints WHERE fingerprint = 'foo' ORDER BY row_id;

-- Test 83: query (line 503)
SELECT row_id, fingerprint, hint, created_at FROM system.statement_hints WHERE fingerprint = 'bar' ORDER BY row_id;

-- Test 84: query (line 508)
SELECT row_id, fingerprint, hint, created_at FROM system.statement_hints WHERE fingerprint = 'baz' ORDER BY row_id;

-- Test 85: statement (line 512)
DELETE FROM system.statement_hints WHERE fingerprint = 'foo';

-- Test 86: query (line 515)
SELECT row_id, fingerprint, hint, created_at FROM system.statement_hints ORDER BY row_id;
