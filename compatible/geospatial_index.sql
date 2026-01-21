-- PostgreSQL compatible tests from geospatial_index
-- 19 tests

-- Test 1: statement (line 1)
SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS postgis;

DROP TABLE IF EXISTS geo_table;
-- CockroachDB column families are not supported in PostgreSQL.
-- FAMILY fam_0_geog (geog),
-- FAMILY fam_1_geom (geom),
-- FAMILY fam_2_id (id)
CREATE TABLE geo_table(
  id int primary key,
  geog geography(geometry, 4326),
  geom geometry(geometry, 3857)
);

-- Test 2: statement (line 11)
-- CockroachDB-only geospatial index parameters. PostgreSQL rejects these
-- storage parameters; keep them as expected-error statements.
\set ON_ERROR_STOP off
CREATE INDEX bad_idx ON geo_table(id) WITH (s2_max_cells=15);

-- Test 3: statement (line 14)
CREATE INDEX bad_idx ON geo_table USING GIST(geom) WITH (s2_max_cells=42);

-- Test 4: statement (line 17)
CREATE INDEX bad_idx ON geo_table USING GIST(geom) WITH (s2_max_level=29, s2_level_mod=2);

-- Test 5: statement (line 20)
CREATE INDEX bad_idx ON geo_table USING GIST(geog) WITH (geometry_min_x=0);

-- Test 6: statement (line 23)
CREATE INDEX bad_idx ON geo_table USING GIST(geom) WITH (geometry_min_x=10, geometry_max_x=0);

-- Test 7: statement (line 26)
CREATE INDEX bad_idx ON geo_table USING GIST(geom) WITH (geometry_min_y=10, geometry_max_y=0);
\set ON_ERROR_STOP on

-- Test 8: statement (line 29)
-- PostgreSQL does not support CockroachDB's geospatial index parameters in WITH (...).
CREATE INDEX geom_idx_1 ON geo_table USING GIST(geom);

-- Test 9: statement (line 32)
CREATE INDEX geom_idx_2 ON geo_table USING GIST(geom);

-- Test 10: statement (line 35)
CREATE INDEX geom_idx_3 ON geo_table USING GIST(geom);

-- Test 11: statement (line 38)
CREATE INDEX geom_idx_4 ON geo_table USING GIST(geom);

-- Test 12: statement (line 41)
CREATE INDEX geog_idx_1 ON geo_table USING GIST(geog);

-- Test 13: statement (line 44)
CREATE INDEX geog_idx_2 ON geo_table USING GIST(geog);

-- onlyif config schema-locked-disabled

-- Test 14: query (line 48)
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'geo_table'
ORDER BY indexname;

-- Test 15: query (line 68)
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'geo_table'
ORDER BY indexname;

-- Test 16: statement (line 90)
DROP TABLE geo_table;

-- Test 17: statement (line 93)
CREATE TABLE geo_table(
  id int primary key,
  geog geography(geometry, 4326),
  geom geometry(geometry, 3857)
);
CREATE INDEX geom_idx_1 ON geo_table USING GIST(geom);
CREATE INDEX geom_idx_2 ON geo_table USING GIST(geom);
CREATE INDEX geom_idx_3 ON geo_table USING GIST(geom);
CREATE INDEX geom_idx_4 ON geo_table USING GIST(geom);
CREATE INDEX geog_idx_1 ON geo_table USING GIST(geog);
CREATE INDEX geog_idx_2 ON geo_table USING GIST(geog);

-- onlyif config schema-locked-disabled

-- Test 18: query (line 97)
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'geo_table'
ORDER BY indexname;

-- Test 19: query (line 117)
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'geo_table'
ORDER BY indexname;

RESET client_min_messages;
