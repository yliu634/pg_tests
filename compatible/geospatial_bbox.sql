-- PostgreSQL compatible tests from geospatial_bbox
-- 31 tests

-- Test 1: statement (line 5)
CREATE TABLE box2d_encoding_test(
  id int primary key,
  box_a box2d,
  orphan box2d,
  arr box2d array,
  family f(orphan)
)

-- Test 2: statement (line 14)
INSERT INTO box2d_encoding_test VALUES
  (1, 'BOX(1 2,3 4)', 'BOX(3 4,5 6)', array['BOX(-1 -2,-3 -4)']),
  (2, 'BOX(10.1 20.1,30.5 40.6)', 'BOX(30 40,50 60)', array['BOX(-1 -2,-3 -4)'::box2d, 'BOX(3 -4,5 -6)'::box2d])

-- Test 3: query (line 19)
SELECT * FROM box2d_encoding_test ORDER BY id ASC

-- Test 4: statement (line 27)
SELECT ST_MakeBox2D('LINESTRING(0 0, 1 1)', 'POINT(1 0)')

-- Test 5: statement (line 30)
SELECT ST_MakeBox2D('POINT(1 0)', 'LINESTRING(0 0, 1 1)')

-- Test 6: statement (line 33)
SELECT ST_MakeBox2D('POINT(1 0)', 'POINT EMPTY')

-- Test 7: statement (line 36)
SELECT ST_MakeBox2D('POINT EMPTY', 'POINT (1 0)')

-- Test 8: statement (line 39)
SELECT ST_MakeBox2D('SRID=4326;POINT(1 0)', 'SRID=3857;POINT(1 0)')

-- Test 9: query (line 42)
SELECT ST_MakeBox2D(a::geometry, b::geometry) FROM ( VALUES
  ('POINT (1 0)', 'POINT(5 6)'),
  ('POINT (1 0)', 'POINT(1 0)')
) tbl(a, b)

-- Test 10: statement (line 59)
INSERT INTO geometry_tbl VALUES
  ('NULL', NULL),
  ('empty point', 'POINT EMPTY'),
  ('point 0.5 0.5', 'POINT(0.5 0.5)'),
  ('linestring from origin to 1 1', 'LINESTRING(0 0, 1 1)');

-- Test 11: statement (line 72)
INSERT INTO box2d_tbl VALUES
  ('NULL', NULL),
  ('box at origin', 'box(0 0, 0 0)'),
  ('box from origin to 1 1', 'box(0 0, 1 1)');

-- Test 12: statement (line 78)
SELECT 'box(0 0,1 1)'::box2d && 'box(1 1,2 2)'::box2d

-- Test 13: query (line 84)
SELECT
  a.dsc,
  b.dsc,
  a.g && b.g,
  b.g && a.g,
  a.g ~ b.g,
  b.g ~ a.g
FROM geometry_tbl a
JOIN geometry_tbl b ON (1=1)
ORDER BY a.dsc, b.dsc

-- Test 14: query (line 113)
SELECT
  a.dsc,
  b.dsc,
  a.b && b.b,
  b.b && a.b,
  a.b ~ b.b,
  b.b ~ a.b
FROM box2d_tbl a
JOIN box2d_tbl b ON (1=1)
ORDER BY a.dsc, b.dsc

-- Test 15: query (line 135)
SELECT
  geometry_tbl.dsc,
  box2d_tbl.dsc,
  geometry_tbl.g && box2d_tbl.b,
  box2d_tbl.b && geometry_tbl.g,
  geometry_tbl.g ~ box2d_tbl.b,
  box2d_tbl.b ~ geometry_tbl.g
FROM geometry_tbl
JOIN box2d_tbl ON (1=1)
ORDER BY geometry_tbl.dsc, box2d_tbl.dsc

-- Test 16: query (line 162)
SELECT st_combinebbox(b::box2d, g::geometry) FROM ( VALUES
  (NULL, NULL),
  ('box(-1 -1, 1 1)', NULL),
  (NULL, st_makepoint(4, -5)),
  ('box(-1 -1, 1 1)', st_makepoint(4, -5))
) tbl(b, g)

-- Test 17: query (line 175)
select st_combinebbox(st_expand(NULL::BOX2D, 0.7845514859561931:::FLOAT8::FLOAT8)::BOX2D::BOX2D, '010200000000000000':::GEOMETRY::GEOMETRY)::BOX2D;

-- Test 18: query (line 182)
SELECT
  st_expand(b::box2d, 10),
  st_expand(b::box2d, 10, 20)
FROM ( VALUES
  ('box(-1 -1, 1 1)'),
  ('box(-10 -20, 15 30)'),
  (NULL)
) tbl(b)

-- Test 19: query (line 198)
SELECT
  ST_AsEWKT(b::box2d::geometry)
FROM ( VALUES
  (NULL),
  ('box(-1 -1,-1 -1)'),
  ('box(1 3,20 3)'),
  ('box(5.5 -10, 5.5 60)'),
  ('box(-1 -2, 4 6)')
) tbl(b)

-- Test 20: query (line 215)
SELECT
  g::geometry::box2d
FROM ( VALUES
  ('point empty'),
  (null),
  ('point(5 5)'),
  ('linestring(4 5, 9 10)')
) tbl(g)

-- Test 21: query (line 232)
SELECT
  st_xmin(g::box2d),
  st_ymin(g::box2d),
  st_xmax(g::box2d),
  st_ymax(g::box2d)
FROM ( VALUES
  ('box(-1 -1,-1 -1)'),
  ('box(1 3,20 3)'),
  ('box(5.5 -10, 5.5 60)'),
  ('box(-1 -2, 4 6)')
) tbl(g)

-- Test 22: query (line 252)
SELECT
  g
FROM ( VALUES
  (ST_Box2DFromGeoHash('s000000000000000')),
  (ST_Box2DFromGeoHash('kkqnpkue9ktbpe5')),
  (ST_Box2DFromGeoHash('w000000000000000')),
  (ST_Box2DFromGeoHash('w000000000000000',5))
) tbl(g)

-- Test 23: query (line 267)
SELECT ST_Box2DFromGeoHash('F'::TEXT::TEXT::TEXT, NULL::INT4::INT4)::BOX2D;

-- Test 24: query (line 272)
SELECT ST_Box2DFromGeoHash('kkqnpkue9ktbpe5', NULL)::BOX2D;

-- Test 25: query (line 277)
SELECT ST_Box2DFromGeoHash('KKQNPKUE9KTBPE5', NULL)::BOX2D;

-- Test 26: query (line 282)
SELECT ST_Box2DFromGeoHash('kKqNpKuE9KtBpE5', NULL)::BOX2D;

-- Test 27: query (line 287)
SELECT ST_Box2DFromGeoHash(NULL)::BOX2D;

-- Test 28: query (line 292)
SELECT ST_Box2DFromGeoHash(NULL, NULL)::BOX2D;

-- Test 29: statement (line 299)
CREATE TABLE bbox_units (d INT PRIMARY KEY, f FLOAT4);

-- Test 30: statement (line 302)
INSERT INTO bbox_units VALUES (1, 1.0), (2, 'NaN');

-- Test 31: query (line 305)
SELECT count(*) FROM bbox_units
WHERE 'BOX(-10 -10,10 10)'::BOX2D IN (
  SELECT st_expand('BOX(1 -1, 1 -1)'::BOX2D, t2.f) FROM bbox_units t2
);

