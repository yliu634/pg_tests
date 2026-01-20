-- PostgreSQL compatible tests from geospatial_zm
--
-- CockroachDB uses additional geometry type aliases (geometrym/geometryz/etc).
-- In PostgreSQL we rely on PostGIS's EWKT input forms to exercise Z/M support.

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS postgis;
DROP TABLE IF EXISTS geom_zm_pg;
RESET client_min_messages;

CREATE TABLE geom_zm_pg (
  id int PRIMARY KEY,
  geom geometry
);

INSERT INTO geom_zm_pg VALUES
  (1, 'POINT(1 2)'::geometry),
  (2, 'POINT Z (1 2 3)'::geometry),
  (3, 'POINT M (1 2 3)'::geometry),
  (4, 'POINT ZM (1 2 3 4)'::geometry);

SELECT
  id,
  ST_AsEWKT(geom) AS ewkt,
  ST_ZMFlag(geom) AS zmflag,
  ST_Z(geom) AS z,
  ST_M(geom) AS m
FROM geom_zm_pg
ORDER BY id;

SELECT ST_AsEWKT(ST_Force2D('POINT ZM (1 2 3 4)'::geometry)) AS force2d;
SELECT ST_AsEWKT(ST_Force3D('POINT(1 2)'::geometry)) AS force3d;
SELECT ST_AsEWKT(ST_Force4D('POINT(1 2)'::geometry)) AS force4d;

DROP TABLE geom_zm_pg;

