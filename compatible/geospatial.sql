-- PostgreSQL compatible tests from geospatial
--
-- CockroachDB's geospatial test corpus relies on Cockroach-specific DDL (e.g.
-- column families, inverted indexes, SHOW commands) and intentionally-invalid
-- cases. This adapted test focuses on a small set of PostGIS-backed geometry /
-- geography behaviors that run cleanly under PostgreSQL.

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS postgis;
DROP TABLE IF EXISTS geo_table_pg;
RESET client_min_messages;

CREATE TABLE geo_table_pg (
  id int PRIMARY KEY,
  geog geography(Point, 4326),
  geom geometry(Point, 3857)
);

INSERT INTO geo_table_pg VALUES
  (1, ST_GeogFromText('POINT(1 1)'), ST_SetSRID(ST_Point(2, 2), 3857)),
  (2, ST_GeogFromText('POINT(0 0)'), ST_SetSRID(ST_Point(-1, -1), 3857));

CREATE INDEX geo_table_pg_geog_gist ON geo_table_pg USING gist (geog);
CREATE INDEX geo_table_pg_geom_gist ON geo_table_pg USING gist (geom);

SELECT
  id,
  ST_AsText(geog::geometry) AS geog_wkt,
  ST_AsText(geom) AS geom_wkt,
  ST_SRID(geog::geometry) AS geog_srid,
  ST_SRID(geom) AS geom_srid
FROM geo_table_pg
ORDER BY id;

-- Boolean predicates keep output deterministic (avoid float distances).
SELECT
  id,
  ST_DWithin(geog, ST_GeogFromText('POINT(1 1)'), 1.0) AS within_1m
FROM geo_table_pg
ORDER BY id;

SELECT
  id,
  ST_Intersects(geom, ST_SetSRID(ST_MakeEnvelope(-2, -2, 3, 3), 3857)) AS intersects_box
FROM geo_table_pg
ORDER BY id;

SELECT id, ST_AsGeoJSON(geom, 6) AS geom_geojson
FROM geo_table_pg
ORDER BY id;

DROP TABLE geo_table_pg;

