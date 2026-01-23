-- PostgreSQL compatible tests from show_tables
-- 13 tests

SET client_min_messages = warning;

-- CockroachDB `SHOW TABLES` and `SET DATABASE` don't exist in PostgreSQL.
-- Emulate databases using per-"database" schemas inside this test database.
DROP SCHEMA IF EXISTS test CASCADE;
DROP SCHEMA IF EXISTS other CASCADE;
DROP SCHEMA IF EXISTS "Do you like this for a database name?" CASCADE;
DROP SCHEMA IF EXISTS sc CASCADE;

CREATE SCHEMA test;
SET search_path TO test;

-- Test 1: statement (line 3)
CREATE TABLE show_this_table();

-- Test 2: query (line 6)
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  CASE c.relkind
    WHEN 'r' THEN 'table'
    WHEN 'p' THEN 'partitioned table'
    WHEN 'v' THEN 'view'
    WHEN 'm' THEN 'materialized view'
    WHEN 'S' THEN 'sequence'
    ELSE c.relkind::TEXT
  END AS type,
  pg_get_userbyid(c.relowner) AS owner,
  NULL::BIGINT AS estimated_row_count
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = current_schema()
  AND c.relkind IN ('r', 'p', 'v', 'm', 'S')
ORDER BY schema_name, table_name;

-- Test 3: statement (line 11)
CREATE SCHEMA other;
SET search_path TO other;

-- Test 4: query (line 15)
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  CASE c.relkind
    WHEN 'r' THEN 'table'
    WHEN 'p' THEN 'partitioned table'
    WHEN 'v' THEN 'view'
    WHEN 'm' THEN 'materialized view'
    WHEN 'S' THEN 'sequence'
    ELSE c.relkind::TEXT
  END AS type,
  pg_get_userbyid(c.relowner) AS owner,
  NULL::BIGINT AS estimated_row_count
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = 'test'
  AND c.relkind IN ('r', 'p', 'v', 'm', 'S')
ORDER BY schema_name, table_name;

-- Test 5: statement (line 20)
SET search_path TO test;

-- Test 6: statement (line 23)
-- CockroachDB-only: SET CLUSTER SETTING sql.show_tables.estimated_row_count.enabled = false;

-- Test 7: query (line 26)
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  CASE c.relkind
    WHEN 'r' THEN 'table'
    WHEN 'p' THEN 'partitioned table'
    WHEN 'v' THEN 'view'
    WHEN 'm' THEN 'materialized view'
    WHEN 'S' THEN 'sequence'
    ELSE c.relkind::TEXT
  END AS type,
  pg_get_userbyid(c.relowner) AS owner,
  NULL::BIGINT AS estimated_row_count
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = current_schema()
  AND c.relkind IN ('r', 'p', 'v', 'm', 'S')
ORDER BY schema_name, table_name;

-- Test 8: query (line 31)
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  CASE c.relkind
    WHEN 'r' THEN 'table'
    WHEN 'p' THEN 'partitioned table'
    WHEN 'v' THEN 'view'
    WHEN 'm' THEN 'materialized view'
    WHEN 'S' THEN 'sequence'
    ELSE c.relkind::TEXT
  END AS type,
  pg_get_userbyid(c.relowner) AS owner,
  NULL::BIGINT AS estimated_row_count,
  obj_description(c.oid, 'pg_class') AS comment
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = current_schema()
  AND c.relkind IN ('r', 'p', 'v', 'm', 'S')
ORDER BY schema_name, table_name;

-- Test 9: statement (line 36)
-- CockroachDB-only: SET CLUSTER SETTING sql.show_tables.estimated_row_count.enabled = default;

-- Test 10: statement (line 39)
CREATE SCHEMA "Do you like this for a database name?";
SET search_path TO "Do you like this for a database name?";
CREATE SCHEMA sc;
CREATE TABLE sc.foo (i INT8);
CREATE TABLE foo (i INT8);

-- Test 11: query (line 46)
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  CASE c.relkind
    WHEN 'r' THEN 'table'
    WHEN 'p' THEN 'partitioned table'
    WHEN 'v' THEN 'view'
    WHEN 'm' THEN 'materialized view'
    WHEN 'S' THEN 'sequence'
    ELSE c.relkind::TEXT
  END AS type,
  pg_get_userbyid(c.relowner) AS owner,
  NULL::BIGINT AS estimated_row_count
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = current_schema()
  AND c.relkind IN ('r', 'p', 'v', 'm', 'S')
ORDER BY schema_name, table_name;

-- Test 12: statement (line 53)
SET search_path TO other;

-- Test 13: query (line 56)
SELECT
  n.nspname AS schema_name,
  c.relname AS table_name,
  CASE c.relkind
    WHEN 'r' THEN 'table'
    WHEN 'p' THEN 'partitioned table'
    WHEN 'v' THEN 'view'
    WHEN 'm' THEN 'materialized view'
    WHEN 'S' THEN 'sequence'
    ELSE c.relkind::TEXT
  END AS type,
  pg_get_userbyid(c.relowner) AS owner,
  NULL::BIGINT AS estimated_row_count
FROM pg_class AS c
JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE n.nspname = 'sc'
  AND c.relkind IN ('r', 'p', 'v', 'm', 'S')
ORDER BY schema_name, table_name;

RESET client_min_messages;
