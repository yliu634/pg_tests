-- PostgreSQL compatible tests from inverted_join_geospatial_dist
-- 5 tests

-- Test 1: statement (line 3)
CREATE TABLE ltable(
  lk int primary key,
  geom1 geometry,
  geom2 geometry
)

-- Test 2: statement (line 10)
INSERT INTO ltable VALUES
  (1, 'POINT(3.0 3.0)', 'POINT(3.0 3.0)'),
  (2, 'POINT(4.5 4.5)', 'POINT(3.0 3.0)'),
  (3, 'POINT(1.5 1.5)', 'POINT(3.0 3.0)')

-- Test 3: statement (line 16)
CREATE TABLE rtable(
  rk int primary key,
  geom geometry,
  INVERTED INDEX geom_index(geom)
)

-- Test 4: statement (line 23)
INSERT INTO rtable VALUES
  (11, 'POINT(1.0 1.0)'),
  (12, 'LINESTRING(1.0 1.0, 2.0 2.0)'),
  (13, 'POINT(3.0 3.0)'),
  (14, 'LINESTRING(4.0 4.0, 5.0 5.0)'),
  (15, 'LINESTRING(40.0 40.0, 41.0 41.0)'),
  (16, 'POLYGON((1.0 1.0, 5.0 1.0, 5.0 5.0, 1.0 5.0, 1.0 1.0))')

-- Test 5: query (line 47)
SELECT lk, rk FROM ltable JOIN rtable@geom_index ON ST_Intersects(ltable.geom1, rtable.geom) ORDER BY (lk, rk)

