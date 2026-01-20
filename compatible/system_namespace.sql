-- PostgreSQL compatible tests from system_namespace
-- Reduced subset: CockroachDB system.namespace is not present in PostgreSQL.

-- Test 1: query
SELECT oid, nspname
FROM pg_namespace
WHERE oid >= 100 OR nspname IN ('pg_catalog', 'public')
ORDER BY oid
LIMIT 20;

-- Test 2: SHOW COLUMNS equivalent
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'pg_catalog' AND table_name = 'pg_namespace'
ORDER BY ordinal_position;
