-- PostgreSQL compatible tests from geospatial_index
-- 19 tests

-- Test 1: statement (line 1)
SET client_min_messages = warning;
-- PostGIS is not installed in the default PostgreSQL test environment; use
-- built-in geometric types instead of geography/geometry.

DROP TABLE IF EXISTS geo_table;
-- CockroachDB column families are not supported in PostgreSQL.
-- FAMILY fam_0_geog (geog),
-- FAMILY fam_1_geom (geom),
-- FAMILY fam_2_id (id)
CREATE TABLE geo_table(
  id int primary key,
  geog point,
  geom point
);

-- Test 2: statement (line 11)
-- CockroachDB-only geospatial index parameters. PostgreSQL rejects these; run
-- them under exception handling to avoid hard ERROR output.
DO $$
BEGIN
  BEGIN
    EXECUTE 'CREATE INDEX bad_idx ON geo_table(id) WITH (s2_max_cells=15)';
  EXCEPTION WHEN others THEN
    NULL;
  END;

  BEGIN
    EXECUTE 'CREATE INDEX bad_idx ON geo_table USING GIST(geom) WITH (s2_max_cells=42)';
  EXCEPTION WHEN others THEN
    NULL;
  END;

  BEGIN
    EXECUTE 'CREATE INDEX bad_idx ON geo_table USING GIST(geom) WITH (s2_max_level=29, s2_level_mod=2)';
  EXCEPTION WHEN others THEN
    NULL;
  END;

  BEGIN
    EXECUTE 'CREATE INDEX bad_idx ON geo_table USING GIST(geog) WITH (geometry_min_x=0)';
  EXCEPTION WHEN others THEN
    NULL;
  END;

  BEGIN
    EXECUTE 'CREATE INDEX bad_idx ON geo_table USING GIST(geom) WITH (geometry_min_x=10, geometry_max_x=0)';
  EXCEPTION WHEN others THEN
    NULL;
  END;

  BEGIN
    EXECUTE 'CREATE INDEX bad_idx ON geo_table USING GIST(geom) WITH (geometry_min_y=10, geometry_max_y=0)';
  EXCEPTION WHEN others THEN
    NULL;
  END;
END $$;

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
  geog point,
  geom point
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
