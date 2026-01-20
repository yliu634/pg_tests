-- PostgreSQL compatible tests from geospatial_regression
--
-- CockroachDB-specific inverted indexes and casts are not available in
-- PostgreSQL. This adapted test covers a couple of PostGIS regression-style
-- operations (index creation + a few functions) with deterministic output.

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS postgis;
DROP TABLE IF EXISTS regression_81609_pg;
RESET client_min_messages;

CREATE TABLE regression_81609_pg (
  id int PRIMARY KEY,
  g geometry NOT NULL
);

CREATE INDEX regression_81609_pg_g_gist ON regression_81609_pg USING gist (g);

INSERT INTO regression_81609_pg VALUES
  (1, 'POINT(0 0)'::geometry),
  (2, 'LINESTRING(0 0, 1 1)'::geometry);

SELECT id, ST_AsText(g) AS wkt
FROM regression_81609_pg
ORDER BY id;

-- 3D rotation around the X axis (pi()/2) should be exact here.
SELECT ST_AsEWKT(ST_RotateX('POINT Z (1 2 3)'::geometry, pi() / 2)) AS rotatex;

-- Encoded polyline output is stable for this simple line.
SELECT ST_AsEncodedPolyline(ST_SetSRID('LINESTRING(0 0, 1 1)'::geometry, 4326)) AS encoded_polyline;

DROP TABLE regression_81609_pg;
