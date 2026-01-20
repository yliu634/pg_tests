-- PostgreSQL compatible tests from inverted_join_geospatial_dist
--
-- CockroachDB used inverted geospatial indexes for join acceleration; PostgreSQL
-- uses PostGIS predicates with GiST indexes.

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS postgis;

DROP TABLE IF EXISTS ltable;
DROP TABLE IF EXISTS rtable;

CREATE TABLE ltable(
  lk INT PRIMARY KEY,
  geom1 geometry,
  geom2 geometry
);

INSERT INTO ltable VALUES
  (1, ST_GeomFromText('POINT(3 3)'), ST_GeomFromText('POINT(3 3)')),
  (2, ST_GeomFromText('POINT(4.5 4.5)'), ST_GeomFromText('POINT(3 3)')),
  (3, ST_GeomFromText('POINT(1.5 1.5)'), ST_GeomFromText('POINT(3 3)'));

CREATE TABLE rtable(
  rk INT PRIMARY KEY,
  geom geometry
);
CREATE INDEX rtable_geom_gist ON rtable USING GIST (geom);

INSERT INTO rtable VALUES
  (11, ST_GeomFromText('POINT(1 1)')),
  (12, ST_GeomFromText('LINESTRING(1 1, 2 2)')),
  (13, ST_GeomFromText('POINT(3 3)')),
  (14, ST_GeomFromText('LINESTRING(4 4, 5 5)')),
  (15, ST_GeomFromText('LINESTRING(40 40, 41 41)')),
  (16, ST_GeomFromText('POLYGON((1 1, 5 1, 5 5, 1 5, 1 1))'));

SELECT lk, rk
FROM ltable
JOIN rtable ON ST_Intersects(ltable.geom1, rtable.geom)
ORDER BY lk, rk;

DROP TABLE ltable;
DROP TABLE rtable;

RESET client_min_messages;
