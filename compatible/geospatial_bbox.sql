-- PostgreSQL compatible tests from geospatial_bbox
--
-- CockroachDB's test uses column families and Cockroach-only casts. This
-- adapted version exercises PostGIS's `box2d` type and a few related helpers.

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS postgis;
DROP TABLE IF EXISTS box2d_encoding_test_pg;
RESET client_min_messages;

CREATE TABLE box2d_encoding_test_pg(
  id int PRIMARY KEY,
  box_a box2d,
  orphan box2d,
  arr box2d[]
);

INSERT INTO box2d_encoding_test_pg VALUES
  (1, 'BOX(1 2,3 4)', 'BOX(3 4,5 6)', ARRAY['BOX(-1 -2,-3 -4)'::box2d]),
  (2, 'BOX(10.1 20.1,30.5 40.6)', 'BOX(30 40,50 60)',
     ARRAY['BOX(-1 -2,-3 -4)'::box2d, 'BOX(3 -4,5 -6)'::box2d]);

SELECT id, box_a, orphan, arr FROM box2d_encoding_test_pg ORDER BY id;

SELECT ST_MakeBox2D(ST_Point(0, 0), ST_Point(1, 1)) AS unit_box;
SELECT 'box(0 0,1 1)'::box2d && 'box(1 1,2 2)'::box2d AS overlaps_on_edge;

SELECT ST_CombineBBox('box(-1 -1, 1 1)'::box2d, ST_Point(4, -5)) AS combined;
SELECT ST_Expand('box(-1 -1, 1 1)'::box2d, 10) AS expanded;
SELECT Box2D(ST_GeomFromText('LINESTRING(4 5, 9 10)')) AS line_bbox;

SELECT ST_Box2DFromGeoHash('s000000000000000') IS NOT NULL AS geohash_box_nonnull;

DROP TABLE box2d_encoding_test_pg;

