-- PostgreSQL compatible tests from inverted_filter_geospatial
--
-- CockroachDB uses INVERTED INDEX for geospatial; PostgreSQL/PostGIS uses GiST
-- indexes and spatial predicates (ST_Intersects, ST_DWithin, etc).

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS postgis;

DROP TABLE IF EXISTS geo_table;
DROP TABLE IF EXISTS geo_table2;

CREATE TABLE geo_table(
  k INT PRIMARY KEY,
  geom geometry
);
CREATE INDEX geo_table_geom_gist ON geo_table USING GIST (geom);

INSERT INTO geo_table VALUES
  (1, ST_GeomFromText('POINT(1 1)')),
  (2, ST_GeomFromText('LINESTRING(1 1, 2 2)')),
  (3, ST_GeomFromText('POINT(3 3)')),
  (4, ST_GeomFromText('LINESTRING(4 4, 5 5)')),
  (5, ST_GeomFromText('LINESTRING(40 40, 41 41)')),
  (6, ST_GeomFromText('POLYGON((1 1, 5 1, 5 5, 1 5, 1 1))'));

SELECT k
FROM geo_table
WHERE ST_Intersects(ST_GeomFromText('POINT(3 3)'), geom)
ORDER BY k;

SELECT k
FROM geo_table
WHERE ST_Intersects(ST_GeomFromText('POINT(4.5 4.5)'), geom)
ORDER BY k;

SELECT k
FROM geo_table
WHERE ST_CoveredBy(ST_GeomFromText('POINT(4 4.5)'), geom)
ORDER BY k;

SELECT k
FROM geo_table
WHERE ST_DWithin(ST_GeomFromText('POINT(2.5 2.5)'), geom, 1)
ORDER BY k;

-- Bounding-box operator (uses the GiST index).
SELECT k
FROM geo_table
WHERE ST_GeomFromText('POINT(3 3)') && geom
ORDER BY k;

CREATE TABLE geo_table2(
  k INT,
  geom geometry,
  k_plus_one INT,
  PRIMARY KEY (k, k_plus_one)
);
CREATE INDEX geo_table2_geom_gist ON geo_table2 USING GIST (geom);

INSERT INTO geo_table2 VALUES
  (1, ST_GeomFromText('LINESTRING(1 1, 2 2)'), 2),
  (2, ST_GeomFromText('POLYGON((1 1, 5 1, 5 5, 1 5, 1 1))'), 3);

SELECT k, k_plus_one
FROM geo_table2
WHERE ST_Intersects(ST_GeomFromText('POINT(3 3)'), geom)
ORDER BY 1, 2;

-- Cleanup.
DROP TABLE geo_table2;
DROP TABLE geo_table;

RESET client_min_messages;
