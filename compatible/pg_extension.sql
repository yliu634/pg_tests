SET client_min_messages = warning;

-- PostgreSQL compatible tests from pg_extension
-- 7 tests
--
-- The original CockroachDB test references PostGIS objects. This PG-adapted
-- version exercises the PostgreSQL extension catalogs without assuming PostGIS
-- is installed.

-- Test 1: query
SELECT count(*) > 0 AS has_available_extensions
FROM pg_catalog.pg_available_extensions;

-- Test 2: query
SELECT name, default_version, installed_version
FROM pg_catalog.pg_available_extensions
WHERE name IN ('ltree', 'pgcrypto')
ORDER BY name;

-- Test 3: query
SELECT extname, extversion
FROM pg_catalog.pg_extension
ORDER BY extname;

RESET client_min_messages;

