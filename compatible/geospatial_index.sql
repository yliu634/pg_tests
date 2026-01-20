-- PostgreSQL compatible tests from geospatial_index
--
-- CockroachDB index options (S2 parameters, inverted indexes, column families)
-- are not available in PostgreSQL. This adapted test verifies that PostGIS
-- GiST indexes can be created on geometry and geography columns.

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS postgis;
DROP TABLE IF EXISTS geo_index_pg;
RESET client_min_messages;

CREATE TABLE geo_index_pg (
  id int PRIMARY KEY,
  geog geography(Point, 4326),
  geom geometry(Point, 3857)
);

CREATE INDEX geo_index_pg_geog_gist ON geo_index_pg USING gist (geog);
CREATE INDEX geo_index_pg_geom_gist ON geo_index_pg USING gist (geom);

SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'geo_index_pg'
ORDER BY indexname;

DROP TABLE geo_index_pg;

