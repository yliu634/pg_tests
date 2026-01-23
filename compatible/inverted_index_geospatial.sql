-- PostgreSQL compatible tests from inverted_index_geospatial
-- 9 tests

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS postgis;

-- Test 1: statement (line 4)
DROP TABLE IF EXISTS geo_table;
CREATE TABLE geo_table(
  k INT PRIMARY KEY,
  geom geometry
);
-- CockroachDB uses INVERTED INDEX for geo types; PostGIS uses GiST.
CREATE INDEX geom_index ON geo_table USING GIST (geom);

-- Test 2: statement (line 12)
-- CockroachDB-specific opclass; keep a valid PostGIS index instead.
CREATE INDEX geo_table_geom_gist_2 ON geo_table USING GIST (geom);

-- Test 3: statement (line 16)
-- Same as above (valid in Postgres/PostGIS).
CREATE INDEX geo_table_geom_gist_3 ON geo_table USING GIST (geom);

-- Test 4: statement (line 21)
INSERT INTO geo_table VALUES
  (1, 'SRID=26918;POINT(400001 4000001)'::geometry),
  (2, 'SRID=26918;LINESTRING(400001 4000001, 400002 4000002)'::geometry),
  (3, 'SRID=26918;POINT(400003 4000003)'::geometry),
  (4, 'SRID=26918;LINESTRING(400004 4000004, 400005 4000005)'::geometry),
  (5, 'SRID=26918;LINESTRING(400040 4000040, 400041 4000041)'::geometry),
  (6, 'SRID=26918;POLYGON((400001 4000001, 400005 4000001, 400005 4000005, 400001 4000005, 400001 4000001))'::geometry);

-- Test 5: query (line 30)
SELECT k FROM geo_table WHERE ST_Intersects('SRID=26918;POINT(400003 4000003)'::geometry, geom) ORDER BY k;

-- Test 6: statement (line 36)
DROP TABLE geo_table;

-- Test 7: statement (line 40)
DROP TABLE IF EXISTS geo_table;
CREATE TABLE geo_table(
  k INT PRIMARY KEY,
  geom geometry(Geometry, 26918)
);
CREATE INDEX geom_index ON geo_table USING GIST (geom);

-- Test 8: statement (line 48)
INSERT INTO geo_table VALUES
  (1, 'SRID=26918;POINT(400001 4000001)'::geometry),
  (2, 'SRID=26918;LINESTRING(400001 4000001, 400002 4000002)'::geometry),
  (3, 'SRID=26918;POINT(400003 4000003)'::geometry),
  (4, 'SRID=26918;LINESTRING(400004 4000004, 400005 4000005)'::geometry),
  (5, 'SRID=26918;LINESTRING(400040 4000040, 400041 4000041)'::geometry),
  (6, 'SRID=26918;POLYGON((400001 4000001, 400005 4000001, 400005 4000005, 400001 4000005, 400001 4000001))'::geometry);

-- Test 9: query (line 58)
SELECT k FROM geo_table WHERE ST_Intersects('SRID=26918;POINT(400003 4000003)'::geometry, geom) ORDER BY k;
