-- PostgreSQL compatible tests from inverted_filter_geospatial_dist
--
-- CockroachDB uses inverted geospatial indexes and @index hints; PostgreSQL uses
-- PostGIS + GiST indexes.

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS postgis;

DROP TABLE IF EXISTS geo_table_dist;

CREATE TABLE geo_table_dist (
  k INT PRIMARY KEY,
  s TEXT,
  geom geometry
);

CREATE INDEX geo_table_dist_geom_gist ON geo_table_dist USING GIST (geom);
CREATE INDEX geo_table_dist_s_idx ON geo_table_dist (s);

INSERT INTO geo_table_dist VALUES
  (1, 'foo', ST_GeomFromText('POINT(1 1)')),
  (2, 'foo', ST_GeomFromText('LINESTRING(1 1, 2 2)')),
  (3, 'foo', ST_GeomFromText('POINT(3 3)')),
  (4, 'bar', ST_GeomFromText('LINESTRING(4 4, 5 5)')),
  (5, 'bar', ST_GeomFromText('LINESTRING(40 40, 41 41)')),
  (6, 'bar', ST_GeomFromText('POLYGON((1 1, 5 1, 5 5, 1 5, 1 1))')),
  (7, 'foo', ST_GeomFromText('LINESTRING(1 1, 3 3)'));

SELECT k
FROM geo_table_dist
WHERE ST_Intersects(ST_GeomFromText('MULTIPOINT((2.2 2.2), (3.0 3.0))'), geom)
ORDER BY k;

SELECT k
FROM geo_table_dist
WHERE ST_CoveredBy(ST_GeomFromText('MULTIPOINT((2.2 2.2), (3.0 3.0))'), geom)
ORDER BY k;

SELECT k
FROM geo_table_dist
WHERE s = 'foo'
  AND ST_Intersects(ST_GeomFromText('MULTIPOINT((2.2 2.2), (3.0 3.0))'), geom)
ORDER BY k;

SELECT k
FROM geo_table_dist
WHERE s = 'foo'
  AND ST_CoveredBy(ST_GeomFromText('MULTIPOINT((2.2 2.2), (3.0 3.0))'), geom)
ORDER BY k;

DROP TABLE geo_table_dist;

RESET client_min_messages;
