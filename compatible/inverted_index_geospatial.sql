-- PostgreSQL compatible tests from inverted_index_geospatial
-- 9 tests

-- Test 1: statement (line 4)
CREATE TABLE geo_table(
  k int primary key,
  geom geometry,
  INVERTED INDEX geom_index(geom)
)

-- Test 2: statement (line 12)
CREATE INVERTED INDEX ON geo_table(geom blah_ops)

-- Test 3: statement (line 16)
CREATE INDEX ON geo_table USING GIST(geom blah_ops)

-- Test 4: statement (line 21)
INSERT INTO geo_table VALUES
  (1, 'SRID=26918;POINT(400001 4000001)'),
  (2, 'SRID=26918;LINESTRING(400001 4000001, 400002 4000002)'),
  (3, 'SRID=26918;POINT(400003 4000003)'),
  (4, 'SRID=26918;LINESTRING(400004 4000004, 400005 4000005)'),
  (5, 'SRID=26918;LINESTRING(400040 4000040, 400041 4000041)'),
  (6, 'SRID=26918;POLYGON((400001 4000001, 400005 4000001, 400005 4000005, 400001 4000005, 400001 4000001))')

-- Test 5: query (line 30)
SELECT k FROM geo_table WHERE ST_Intersects('SRID=26918;POINT(400003 4000003)'::geometry, geom) ORDER BY k

-- Test 6: statement (line 36)
DROP TABLE geo_table

-- Test 7: statement (line 40)
CREATE TABLE geo_table(
  k int primary key,
  geom geometry(geometry, 26918),
  INVERTED INDEX geom_index(geom)
)

-- Test 8: statement (line 48)
INSERT INTO geo_table VALUES
  (1, 'SRID=26918;POINT(400001 4000001)'),
  (2, 'SRID=26918;LINESTRING(400001 4000001, 400002 4000002)'),
  (3, 'SRID=26918;POINT(400003 4000003)'),
  (4, 'SRID=26918;LINESTRING(400004 4000004, 400005 4000005)'),
  (5, 'SRID=26918;LINESTRING(400040 4000040, 400041 4000041)'),
  (6, 'SRID=26918;POLYGON((400001 4000001, 400005 4000001, 400005 4000005, 400001 4000005, 400001 4000001))')

-- Test 9: query (line 58)
SELECT k FROM geo_table WHERE ST_Intersects('SRID=26918;POINT(400003 4000003)'::geometry, geom) ORDER BY k

