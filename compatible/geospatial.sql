-- PostgreSQL compatible tests from geospatial
-- 361 tests

-- Many statements below are expected to error (type/constraint edge cases).
\set ON_ERROR_STOP 0

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS postgis;
RESET client_min_messages;

-- Test 1: statement (line 2)
CREATE TABLE geo_table(
  id int primary key,
  geog geography(geometry, 4326),
  geom geometry(point),
  orphan geography
);

-- Test 2: statement (line 11)
INSERT INTO geo_table VALUES
  (1, 'POINT(1.0 1.0)', 'POINT(2.0 2.0)', 'POINT(3.0 3.0)'),
  (2, 'LINESTRING(1.0 1.0, 2.0 2.0)', 'POINT(1.0 1.0)', 'POINT(3.0 3.0)');

-- Test 3: statement (line 16)
INSERT INTO geo_table (id, geog) VALUES
  (3, 'SRID=4004;POINT(1.0 2.0)');

-- Test 4: statement (line 20)
INSERT INTO geo_table (id, geom) VALUES
  (3, 'SRID=4004;LINESTRING(0.0 0.0, 1.0 2.0)');

-- Test 5: statement (line 24)
SELECT 'SRID=404;POINT(1.0 2.0)'::geometry;

-- Test 6: statement (line 27)
SELECT 'SRID=404;POINT(1.0 2.0)'::geography;

-- Test 7: statement (line 30)
INSERT INTO geo_table (id, geom) VALUES
  (3, 'POINT Z(1 2 3)');

-- Test 8: statement (line 34)
INSERT INTO geo_table (id, geog) VALUES
  (3, 'POINT Z(1 2 3)');

-- Test 9: statement (line 38)
CREATE INDEX geo_table_geom_idx ON geo_table USING GIST(geom);

-- Test 10: statement (line 41)
CREATE INDEX geo_table_geog_idx ON geo_table USING GIST(geog);

-- Test 11: statement (line 44)
CREATE TABLE geom_table_negative_values(
  a geometry(geometry, -1)
);

-- Test 12: statement (line 49)
CREATE TABLE geom_table_public_schema (
  geom public.geometry,
  geog public.geography
);

-- Test 13: statement (line 55)
INSERT INTO geom_table_public_schema VALUES ('POINT(1 0)', 'POINT(3 2)');

-- Test 14: query (line 58)
SELECT ST_AsText(geom), ST_AsText(geog) FROM geom_table_public_schema;

-- Test 15: statement (line 63)
CREATE TYPE geometry AS enum('no');

-- Test 16: statement (line 66)
CREATE TYPE geography AS enum('no');

-- Test 17: statement (line 69)
CREATE TABLE geometry (a geometry);

-- Test 18: statement (line 72)
CREATE TABLE geography (a geography);

-- onlyif config schema-locked-disabled

-- Test 19: query (line 76)
SELECT create_statement FROM [SHOW CREATE TABLE geom_table_negative_values];

-- Test 20: query (line 86)
SELECT create_statement FROM [SHOW CREATE TABLE geom_table_negative_values];

-- Test 21: statement (line 95)
CREATE TABLE geog_table_negative_values(
  a geography(geometry, -1)
);

-- onlyif config schema-locked-disabled

-- Test 22: query (line 101)
SELECT create_statement FROM [SHOW CREATE TABLE geog_table_negative_values];

-- Test 23: query (line 111)
SELECT create_statement FROM [SHOW CREATE TABLE geog_table_negative_values];

-- Test 24: statement (line 120)
SELECT 'SRID=3857;POINT(1.0 2.0)'::geography;

-- Test 25: query (line 123)
SELECT * FROM geo_table;

-- Test 26: query (line 129)
SELECT orphan FROM geo_table;

-- Test 27: query (line 135)
SHOW COLUMNS FROM geo_table;

-- Test 28: statement (line 143)
CREATE TABLE bad_geog_table(bad_pk geography primary key);

-- Test 29: statement (line 146)
CREATE TABLE bad_geom_table(bad_pk geometry primary key);

-- Test 30: statement (line 149)
CREATE INDEX geog_idx ON geo_table(geog);

-- Test 31: statement (line 152)
CREATE INDEX geom_idx ON geo_table(geom);

-- Test 32: statement (line 155)
CREATE INVERTED INDEX geog_idx ON geo_table(geog);

-- Test 33: statement (line 158)
CREATE INVERTED INDEX geom_idx ON geo_table(geom);

-- Test 34: statement (line 161)
INSERT INTO geo_table VALUES
  (3, 'POINT(-1.25 3.375)', 'POINT(2.220 -2.445)', 'POINT(3.0 -3.710)');

-- Test 35: query (line 165)
SELECT * FROM geo_table;

-- Test 36: statement (line 172)
CREATE TABLE geo_array_table(id int, geog geography array, geom geometry array);

-- Test 37: statement (line 175)
INSERT INTO geo_array_table VALUES (
  1,
  array['POINT(1.0 1.0)'::geography, 'LINESTRING(2.0 2.0, 3.0 3.0)'::geography],
  array['POINT(1.0 1.0)'::geometry, 'LINESTRING(2.0 2.0, 3.0 3.0)'::geometry]
);

-- Test 38: query (line 182)
SELECT * FROM geo_array_table;

-- Test 39: query (line 187)
SELECT NULL::geometry, NULL::geography;

-- Test 40: query (line 192)
SELECT ST_AsText(p) FROM (VALUES
  (ST_Point(1, 2)),
  (ST_Point(3, 4))
) tbl(p);

-- Test 41: query (line 201)
SELECT ST_AsText(p) FROM (VALUES
  ('POINT(200 200)'::geography),
  ('POLYGON((200 200, 200 200, 200 200, 200 200))'::geography),
  ('GEOMETRYCOLLECTION(POINT (200 200), POLYGON((200 200, 200 200, 200 200, 200 200, 200 200)))'::geography),
  ('MULTIPOLYGON(((200 200,200 200, 200 200, 200 200)),((200 200,200 200,200 200,200 200)))'::geography)
) tbl(p);

-- Test 42: query (line 214)
SELECT ST_AsText(p) FROM (VALUES
  ('POINT(200 200)'::geometry),
  ('POLYGON((200 200, 200 200, 200 200, 200 200))'::geometry),
  ('GEOMETRYCOLLECTION(POINT (200 200), POLYGON((200 200, 200 200, 200 200, 200 200, 200 200)))'::geometry),
  ('MULTIPOLYGON(((200 200,200 200, 200 200, 200 200)),((200 200,200 200,200 200,200 200)))'::geometry)
) tbl(p);

-- Test 43: query (line 227)
SELECT ST_AsText(ST_Project('POINT(0 0)'::geography, 100000, radians(45.0)));

-- Test 44: statement (line 232)
SELECT ST_Azimuth('POLYGON((0 0, 0 0, 0 0, 0 0))'::geometry, 'POLYGON((0 0, 0 0, 0 0, 0 0))'::geometry);

-- Test 45: query (line 235)
SELECT
	degrees(ST_Azimuth(ST_Point(25, 45), ST_Point(75, 100))) AS degA_B,
	degrees(ST_Azimuth(ST_Point(75, 100), ST_Point(25, 45))) AS degB_A;

-- Test 46: query (line 242)
SELECT ST_Azimuth(ST_Point(0, 0), ST_Point(0, 0));

-- Test 47: query (line 247)
SELECT
	degrees(ST_Angle('POINT (0 0)', 'POINT (0 1)', 'POINT (0 0)', 'POINT (1 0)')),
	degrees(ST_Angle('POINT (0 0)', 'POINT (0 1)', 'POINT (0 0)')),
	degrees(ST_Angle('POINT (0 0)', 'POINT (0 1)', 'POINT (1 1)')),
	degrees(ST_Angle('POINT (0 0)', 'POINT (0 0)', 'POINT (0 0)', 'POINT (0 0)')),
	degrees(ST_Angle('LINESTRING (0 0, 0 1)', 'LINESTRING (0 0, 1 0)')),
	degrees(ST_Angle('LINESTRING (0 0, 0 1)', 'LINESTRING (0 0, 0 1)')),
	degrees(ST_Angle('LINESTRING (0 0, 0 0)', 'LINESTRING (0 0, 0 0)'));

-- Test 48: query (line 262)
SELECT
  to_json(g::geometry) = st_asgeojson(g::geometry)::jsonb,
  to_json(g::geography) = st_asgeojson(g::geography)::jsonb
FROM ( VALUES
  ('POINT (30 10)'),
  ('LINESTRING (30 10, 10 30, 40 40)'),
  ('POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))'),
  ('MULTIPOINT (10 40, 40 30, 20 20, 30 10)'),
  ('MULTILINESTRING ((10 10, 20 20, 10 40), (40 40, 30 30, 40 20, 30 10))'),
  ('MULTIPOLYGON (((40 40, 20 45, 45 30, 40 40)), ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35), (30 20, 20 15, 20 25, 30 20)))'),
  ('GEOMETRYCOLLECTION (POINT (40 10), LINESTRING (10 10, 20 20, 10 40), POLYGON ((40 40, 20 45, 45 30, 40 40)))')
) tbl(g);

-- Test 49: query (line 285)
SELECT
  st_x(g), st_y(g), to_json(g)
FROM ( VALUES
  ('SRID=4326;POINT (-123.45 12.3456)'::GEOMETRY),
  ('SRID=4326;POINT (-123.45678901234 12.3456789012)'::GEOMETRY),
  ('SRID=4326;POINT (-123.4567890123456789 12.34567890123456789)'::GEOMETRY)
) tbl(g);

-- Test 50: query (line 299)
SELECT
  st_asgeojson(tbl.*)::JSONB->'geometry'->'coordinates',
  st_asgeojson(g)::JSONB->'coordinates',
  st_asgeojson(tbl.*, 'g')::JSONB->'geometry'->'coordinates',
  st_asgeojson(tbl.*, 'g', 4)::JSONB->'geometry'->'coordinates'
FROM ( VALUES
  ('SRID=4326;POINT (-123.45 12.3456)'::GEOMETRY),
  ('SRID=4326;POINT (-123.45678901234 12.3456789012)'::GEOMETRY),
  ('SRID=4326;POINT (-123.4567890123456789 12.34567890123456789)'::GEOMETRY)
) tbl(g);

-- Test 51: query (line 317)
SELECT ST_AsEWKT(geom) FROM (VALUES
  ('SRID=4326;POINT(1.0 2.0)'::geometry::geometry(point, 4326)),
  ('SRID=4326;POINT(1.0 2.0)'::geometry::geometry(geometry, 4326)),
  ('SRID=4326;POINT(1.0 2.0)'::geography::geometry)
) t(geom);

-- Test 52: query (line 328)
SELECT ST_AsEWKT(geog) FROM (VALUES
  ('POINT(1.0 2.0)'::geography::geography(point, 4326)),
  ('POINT(1.0 2.0)'::geometry::geography(point, 4326)),
  ('SRID=4004;POINT(1.0 2.0)'::geometry::geography(point, 4004)),
  ('SRID=4004;POINT(1.0 2.0)'::geometry::geography),
  ('SRID=4004;POINT(1.0 2.0)'::geography::geography(point, 4004)),
  ('SRID=4004;POINT(1.0 2.0)'::geography::geography(geometry, 4004)),
  ('POINT(1.0 2.0)'::geometry::geography),
  ('POINT(1.0 2.0)'::geometry::geography(geometry, 4326))
) t(geog);

-- Test 53: statement (line 349)
SELECT 'SRID=4004;POINT(2.0 3.0)'::geometry::geography(point, 4326);

-- Test 54: statement (line 352)
SELECT 'SRID=4326;POINT(2.0 3.0)'::geometry::geography(point, 4004);

-- Test 55: statement (line 355)
SELECT 'SRID=4326;POINT(2.0 3.0)'::geography::geography(point, 4004);

-- Test 56: statement (line 358)
SELECT 'SRID=4004;POINT(2.0 3.0)'::geometry::geometry(point, 4326);

-- Test 57: statement (line 361)
SELECT 'SRID=4004;POINT(2.0 3.0)'::geography::geometry(point, 4326);

-- Test 58: statement (line 364)
SELECT 'POINT(1.0 2.0)'::geometry::geography(geometry, 4004);

-- Test 59: statement (line 367)
SELECT 'SRID=4004;POINT(2.0 3.0)'::geometry::geometry(linestring);

-- Test 60: statement (line 370)
SELECT 'SRID=4004;POINT(2.0 3.0)'::geometry::geography(linestring);

-- Test 61: statement (line 373)
SELECT 'SRID=4004;POINT(2.0 3.0)'::geography::geography(linestring);

-- Test 62: statement (line 376)
SELECT 'SRID=4004;POINT(2.0 3.0)'::geography::geometry(linestring);

-- Test 63: statement (line 381)
CREATE TABLE parse_test (
  id SERIAL PRIMARY KEY,
  geom GEOMETRY,
  geog GEOGRAPHY
);

-- Test 64: query (line 389)
SELECT
  ST_AsEWKT(geom),
  ST_AsEWKT(geog)
FROM ( VALUES
  (ST_GeometryFromText('SRID=4326;POINT(1.0 2.0)', 4004), ST_GeographyFromText('SRID=4326;POINT(1.0 2.0)', 4004)),
  (ST_GeomFromText('SRID=4326;POINT(1.0 2.0)', 4004), ST_GeogFromText('SRID=4326;POINT(1.0 2.0)', 4004)),
  (ST_GeometryFromText('SRID=4326;POINT(1.0 2.0)'), ST_GeographyFromText('POINT(1.0 2.0)', 4004)),
  (ST_GeomFromEWKT('SRID=4004;POINT(1.0 2.0)'), ST_GeogFromEWKT('SRID=4004;POINT(1.0 2.0)')),
  (ST_GeomFromWKB(decode('0101000000000000000000F03F000000000000F03F', 'hex'), 4004), ST_GeogFromWKB(decode('0101000000000000000000F03F000000000000F03F', 'hex'), 4004)),
  (ST_GeomFromWKB(decode('0101000020E6100000000000000000F03F0000000000000040', 'hex'), 4004), ST_GeogFromWKB(decode('0101000020E6100000000000000000F03F0000000000000040', 'hex'), 4004)),
  (ST_GeomFromWKB(decode('0101000020A40F0000000000000000F03F0000000000000040', 'hex')), ST_GeogFromWKB(decode('0101000020A40F0000000000000000F03F0000000000000040', 'hex')))
) t(geom, geog);

-- Test 65: query (line 411)
SELECT ST_AsEWKT(g) FROM ( VALUES
  (GeomFromEWKB(decode('0101000000000000000000F03F000000000000F03F', 'hex'))),
  (GeomFromEWKT('SRID=4004;LINESTRING(-1 -1, 2 2)'))
) t(g);

-- Test 66: statement (line 420)
INSERT INTO parse_test (geom, geog) VALUES
  (ST_GeomFromText('POINT(1.555 -2.0)'), ST_GeogFromText('POINT(1.555 -2.0)')),
  (ST_GeomFromText('SRID=4326;POINT(1.0 2.0)'), ST_GeogFromText('SRID=4326;POINT(1.0 2.0)')),
  (ST_GeometryFromText('SRID=4004;POINT(1.0 2.0)'), ST_GeographyFromText('POINT(1.0 2.0)')),
  (ST_GeomFromGeoJSON('{"type":"Point","coordinates":[1,2]}'), ST_GeogFromGeoJSON('{"type":"Point","coordinates":[1,2]}')),
  (ST_GeomFromGeoJSON('{"type":"Point","coordinates":[1,2]}'::jsonb), ST_GeogFromGeoJSON('{"type":"Point","coordinates":[1,2]}'::jsonb)),
  (ST_GeomFromWKB(decode('0101000000000000000000F03F000000000000F03F', 'hex')), ST_GeogFromWKB(decode('0101000000000000000000F03F000000000000F03F', 'hex'))),
  (ST_GeomFromEWKB(decode('0101000000000000000000F03F000000000000F03F', 'hex')), ST_GeogFromEWKB(decode('0101000000000000000000F03F000000000000F03F', 'hex'))),
  (ST_GeomFromText('POINT EMPTY'), ST_GeogFromText('POINT EMPTY')),
  (ST_GeomFromGeoJSON('null':::jsonb), ST_GeogFromGeoJSON('null':::jsonb));

-- Test 67: query (line 432)
SELECT
  st_geomfromwkb(decode('0101000000000000000000F03F000000000000F03F', 'hex')) = st_wkbtosql(decode('0101000000000000000000F03F000000000000F03F', 'hex')),
  st_geomfromtext('POINT(1.0 2.0)') = st_wkttosql('POINT(1.0 2.0)');

-- Test 68: statement (line 439)
select st_geomfromgeojson(json_typeof('null'));

-- Test 69: statement (line 442)
select st_geogfromgeojson(json_typeof('null'));

-- Test 70: query (line 445)
SELECT
  ST_AsText(geom),
  ST_AsEWKT(geom),
  ST_AsBinary(geom),
  ST_AsBinary(geom, 'ndr'),
  ST_AsBinary(geom, 'xdr'),
  ST_AsEWKB(geom),
  ST_AsKML(geom)
FROM parse_test ORDER BY id ASC;

-- Test 71: query (line 474)
SELECT ST_AsEWKT(g), ST_GeoHash(g), ST_GeoHash(g, 8) FROM ( VALUES
  ('POINT (0 0)'::geometry),
  ('LINESTRING(0 0, 1 0)'::geometry)
) t(g);

-- Test 72: query (line 483)
SELECT
  ST_AsGeoJSON(geom),
  ST_AsGeoJSON(geom, 6, 8),
  ST_AsGeoJSON(geom, 6, 5)
FROM parse_test ORDER BY id ASC;

-- Test 73: statement (line 502)
CREATE TABLE parse_test_geojson AS
  SELECT
    row_number() OVER (ORDER BY id) as id,
    geom,
    geog
  FROM parse_test;

-- Test 74: query (line 510)
SELECT
  ST_AsGeoJSON(t.*)
FROM ( VALUES
  (1),
  (2)
) t(row_id);

-- Test 75: query (line 521)
SELECT
  ST_AsGeoJSON(parse_test_geojson.*),
  ST_AsGeoJSON(parse_test_geojson.*, 'geom'),
  ST_AsGeoJSON(parse_test_geojson.*, 'geog')
FROM parse_test_geojson ORDER BY id ASC;

-- Test 76: query (line 538)
SELECT
  ST_AsGeoJSON(parse_test_geojson.*, 'geog', 3, true)
FROM parse_test_geojson ORDER BY id ASC;

-- Test 77: statement (line 708)
SELECT
  ST_AsGeoJSON(parse_test.*, 'geom_no_exist')
FROM parse_test ORDER BY id asc;

-- Test 78: query (line 750)
SELECT
  ST_AsText(geom, 123123123),
  ST_AsText(geom, -1),
  ST_AsGeoJSON(geom, 123123123),
  ST_AsGeoJSON(geom, -1)
FROM parse_test ORDER BY id ASC;

-- Test 79: query (line 768)
SELECT
  ST_AsHexEWKB(geom),
  ST_AsHexEWKB(geom, 'ndr'),
  ST_AsHexEWKB(geom, 'xdr')
FROM parse_test ORDER BY id ASC;

-- Test 80: query (line 785)
SELECT
  ST_AsText(geog),
  ST_AsEWKT(geog),
  ST_AsBinary(geog),
  ST_AsBinary(geog, 'ndr'),
  ST_AsBinary(geog, 'xdr'),
  ST_AsEWKB(geog),
  ST_AsKML(geog)
FROM parse_test ORDER BY id ASC;

-- Test 81: query (line 814)
SELECT
  ST_AsGeoJSON(geog),
  ST_AsGeoJSON(geog, 6, 8),
  ST_AsGeoJSON(geog, 6, 5)
FROM parse_test ORDER BY id ASC;

-- Test 82: query (line 841)
SELECT ST_AsEWKT(g), ST_GeoHash(g), ST_GeoHash(g, 8) FROM ( VALUES
  ('POINT (0 0)'::geography),
  ('LINESTRING(0 0, 1 0)'::geography)
) t(g);

-- Test 83: query (line 885)
SELECT
  ST_AsHexWKB(geog),
  ST_AsHexEWKB(geog),
  ST_AsHexEWKB(geog, 'ndr'),
  ST_AsHexEWKB(geog, 'xdr')
FROM parse_test ORDER BY id ASC;

-- Test 84: query (line 903)
SELECT
  ST_AsText(g)
FROM ( VALUES
  (ST_PointFromGeoHash('s000000000000000')),
  (ST_PointFromGeoHash('kkqnpkue9ktbpe5')),
  (ST_PointFromGeoHash('w000000000000000')),
  (ST_PointFromGeoHash('w000000000000000',5)),
  (ST_GeomFromGeoHash('s000000000000000')),
  (ST_GeomFromGeoHash('kkqnpkue9ktbpe5')),
  (ST_GeomFromGeoHash('w000000000000000')),
  (ST_GeomFromGeoHash('w000000000000000',5))
) tbl(g);

-- Test 85: statement (line 926)
SELECT ST_AsText(ST_PointFromGeoHash('----'));

-- Test 86: statement (line 929)
SELECT ST_AsText(ST_PointFromGeoHash(''));

-- Test 87: query (line 932)
SELECT
  ST_PointFromText('POINT(1.0 1.0)'),
  ST_PointFromText('POINT(1.0 1.0)', 4326),
  ST_PointFromText('LINESTRING(1.0 1.0, 2.0 2.0)'),
  ST_PointFromText('LINESTRING(1.0 1.0, 2.0 2.0)', 4326),
  ST_PointFromWKB(ST_AsBinary('POINT(1.0 1.0)'::geometry)),
  ST_PointFromWKB(ST_AsBinary('POINT(1.0 1.0)'::geometry), 4326),
  ST_PointFromWKB(ST_AsBinary('LINESTRING(1.0 1.0, 2.0 2.0)'::geometry)),
  ST_PointFromWKB(ST_AsBinary('LINESTRING(1.0 1.0, 2.0 2.0)'::geometry), 4326);

-- Test 88: statement (line 947)
CREATE TABLE geom_operators_test (
  dsc TEXT PRIMARY KEY,
  geom GEOMETRY
);

-- Test 89: statement (line 953)
INSERT INTO geom_operators_test VALUES
  ('NULL', NULL),
  ('Square (left)', 'POLYGON((-1.0 0.0, 0.0 0.0, 0.0 1.0, -1.0 1.0, -1.0 0.0))'),
  ('Point middle of Left Square', 'POINT(-0.5 0.5)'),
  ('Square (right)', 'POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0))'),
  ('Point middle of Right Square', 'POINT(0.5 0.5)'),
  ('Square overlapping left and right square', 'POLYGON((-0.1 0.0, 1.0 0.0, 1.0 1.0, -0.1 1.0, -0.1 0.0))'),
  ('Line going through left and right square', 'LINESTRING(-0.5 0.5, 0.5 0.5)'),
  ('Faraway point', 'POINT(5.0 5.0)'),
  ('Empty LineString', 'LINESTRING EMPTY'),
  ('Empty Point', 'POINT EMPTY'),
  ('Empty GeometryCollection', 'GEOMETRYCOLLECTION EMPTY'),
  ('Nested Geometry Collection', 'GEOMETRYCOLLECTION(GEOMETRYCOLLECTION(POINT(0 0)))'::geometry);
  -- ('Partially Empty GeometryCollection', 'GEOMETRYCOLLECTION ( LINESTRING EMPTY, POINT (0.0 0.0) )') -- some of these cases crash GEOS.

-- Test 90: query (line 970)
SELECT
  a.dsc,
  ST_Area(a.geom)
FROM geom_operators_test a
GROUP BY a.dsc, a.geom
ORDER BY a.dsc;

-- Test 91: query (line 992)
SELECT
  dsc,
  PostGIS_HasBBox(geom),
  ST_AsEWKT(PostGIS_AddBBox(geom)),
  PostGIS_GetBBox(geom),
  ST_AsEWKT(PostGIS_DropBBox(geom))
FROM geom_operators_test
ORDER BY dsc ASC;

-- Test 92: query (line 1016)
SELECT
  dsc,
  ST_IsValid(geom),
  ST_IsValid(geom, 0),
  ST_IsValid(geom, 1),
  ST_IsValidReason(geom),
  ST_IsValidReason(geom, 0),
  ST_IsValidReason(geom, 1),
  ST_AsEWKT(ST_MakeValid(geom))
FROM ( VALUES
  ('valid geom', 'POINT(1.0 2.0)'::geometry),
  ('invalid polygon', 'POLYGON((1.0 1.0, 2.0 2.0, 1.5 1.5, 1.5 -1.5, 1.0 1.0))'::geometry),
  ('self-intersecting polygon', 'POLYGON ((14 20, 8 45, 20 35, 14 20, 16 30, 12 30, 14 20))'::geometry)
) t(dsc, geom);

-- Test 93: query (line 1036)
SELECT
  dsc,
  ST_IsValidTrajectory(geom)
FROM ( VALUES
  ('valid trajectory', 'LINESTRINGM(0 0 1,0 1 2)'::geometry)
) t(dsc, geom);

-- Test 94: query (line 1047)
SELECT
  a.dsc,
  ST_Area(a.geom),
  ST_Area2D(a.geom),
  ST_Length(a.geom),
  ST_Length2D(a.geom),
  ST_Perimeter(a.geom),
  ST_Perimeter2D(a.geom),
  ST_MinimumClearance(a.geom),
  ST_AsText(ST_MinimumClearanceLine(a.geom))
FROM geom_operators_test a
ORDER BY a.dsc;

-- Test 95: query (line 1075)
SELECT
  dsc,
  ST_IsEmpty(geom),
  ST_IsCollection(geom),
  ST_IsClosed(geom),
  ST_IsSimple(geom)
FROM geom_operators_test
ORDER BY dsc;

-- Test 96: query (line 1098)
SELECT
  ST_IsRing(geom),
  ST_IsClosed(geom),
  ST_IsSimple(geom)
FROM ( VALUES
  ('LINESTRING EMPTY'::geometry),
  ('LINESTRING(0 0, 1 1)'::geometry),
  ('LINESTRING(0 0, 1 1, 0 0)'::geometry),
  ('LINESTRING(0 0, 0 1, 1 1, 1 0, 0 0)'::geometry)
) tbl(geom);

-- Test 97: statement (line 1115)
SELECT ST_IsRing('POINT(0 0)');

-- Test 98: query (line 1275)
SELECT
  a.dsc,
  ST_AsEWKT(ST_Centroid(a.geom)),
  ST_AsEWKT(ST_PointOnSurface(a.geom)),
  ST_AsEWKT(ST_ConvexHull(a.geom))
FROM geom_operators_test a
ORDER BY a.dsc;

-- Test 99: query (line 1297)
SELECT
  a.dsc,
  ST_AsEWKT(ST_Boundary(a.geom))
FROM geom_operators_test a
WHERE NOT ST_IsCollection(a.geom)
ORDER BY a.dsc;

-- Test 100: query (line 1315)
SELECT
  a.dsc,
  ST_AsEWKT(ST_Simplify(a.geom, 0.2)),
  ST_AsEWKT(ST_SimplifyPreserveTopology(a.geom, 0.2))
FROM geom_operators_test a
ORDER BY a.dsc;

-- Test 101: query (line 1336)
SELECT
  ST_AsEWKT(ST_Simplify(g, 10)),
  ST_AsEWKT(ST_Simplify(g, 10, false)),
  ST_AsEWKT(ST_Simplify(g, 10, true))
FROM ( VALUES
  ('POLYGON((-1 -1, -1 1, 1 1, 1 -1, -1 -1), (0 0, 100 0, 100 100, 0 100, 0 0))'::geometry),
  ('LINESTRING(-1 -1, -1 1, 1 1, 1 -1, -1 -1)'::geometry)
) t(g);

-- Test 102: query (line 1349)
SELECT
  a.dsc,
  ST_AsEWKT(ST_ClipByBox2D(a.geom, 'box(0 0, 0.5 0.5)'))
FROM geom_operators_test a
ORDER BY a.dsc;

-- Test 103: query (line 1369)
SELECT
 ST_AsEWKT(ST_SymDifference(a.geom, b.geom)),
 ST_AsEWKT(ST_SymmetricDifference(a.geom, b.geom))
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 104: query (line 1523)
SELECT
  dsc,
  ST_IsPolygonCW(geom),
  ST_IsPolygonCCW(geom),
  ST_AsText(ST_ForcePolygonCW(geom)),
  ST_AsText(ST_ForcePolygonCCW(geom))
FROM geom_operators_test
ORDER BY dsc;

-- Test 105: query (line 1547)
SELECT
  dsc,
  ST_AsEWKT(ST_Centroid(ewkt))
FROM [SELECT dsc, ST_AsEWKT(a.geom) ewkt FROM geom_operators_test a]
ORDER BY dsc ASC;

-- Test 106: query (line 1568)
SELECT
  dsc,
  ST_AsText(ST_Multi(geom)),
  ST_AsText(ST_CollectionHomogenize(geom)),
  ST_AsText(ST_ForceCollection(geom))
FROM geom_operators_test
ORDER BY dsc ASC;

-- Test 107: query (line 1590)
SELECT
  dsc,
  ST_AsEWKT(ST_CollectionExtract(geom, 1)),
  ST_AsEWKT(ST_CollectionExtract(geom, 2)),
  ST_AsEWKT(ST_CollectionExtract(geom, 3))
FROM geom_operators_test
ORDER BY dsc ASC;

-- Test 108: statement (line 1612)
SELECT ST_CollectionExtract(geom, 4) FROM geom_operators_test;

-- Test 109: query (line 1616)
SELECT
  a.dsc,
  b.dsc,
  ST_Distance(a.geom, b.geom),
  ST_MaxDistance(a.geom, b.geom)
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 110: query (line 1772)
SELECT
  a.dsc,
  b.dsc,
  ST_DistanceSphere(a.geom, b.geom),
  ST_DistanceSpheroid(a.geom, b.geom)
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 111: statement (line 1928)
SELECT ST_DistanceSpheroid(ST_SnapToGrid('01050000C00400000001020000C0040000000A2B7937D2DDF341CAEF56D6CA94FEC168909A5A5308D5C1600863B65513F9C10E9D7B3828CFF3415D754B6EE344F4C154EB8B48DC37EEC14E5053131963FA41E4B8F8F90180E941B433052AC359E2C1B0F9BD706AE0CA41E47A00106D23E6C1140CDEFC2066E541DC041E43D7E0E541D71DA60DCF5800C2C03C19D64662A94101020000C00400000078A3F3FA171BECC14906026AC73000C2BF39C72B6DC0FCC13CFE89583CADE64120EBED23DDB5C1C1C072A4065C53DCC1B04A51E92098F441A063BD5F67B2E841CCB94727FC86DCC1B8276303051FD84114B61A426749FC417483A4C01A68E341F252B7B34B6EEDC19289514C865EF14148C84B584F87F24114436730C149E04101020000C003000000F8CB40BB7D74FD41407A6D511432D741B0CD41FE895DD4418672254A1EB8014208EACF19E83CD541746AD58CB9170242C0B19FB99AFED94148AE2EF95896FE4178B997637B6BD6C164ABA2111EA8FD410CFDE813927BD7C190265FCF876A014201020000C0060000001065DCD70770F7C10F612AD0CC33F4C111FFA41FB47802C2265299CFB19A01422F77456D88D7F2C1A2EAE8CB9F09F4C150167B5B5309EA415A5DDD2C45E9F1418C125198484AE64153D5D0ED755DFAC1EA0005C2D148F1C1EC3F313A1519E241E2779FD007B7F341CB5DDDC5D00CF0C1C24CC5C279C0FDC188BB78838C7BF341F0942DF0B3FBF041906304A7FFB4D5C1982570D0B8FCDB412059D469B946BF4160C6D4DBF074E841586F81D38E05E641A14870D6117800C23C248B430E0CF9C1':::GEOMETRY::GEOMETRY, col::FLOAT8)::GEOMETRY::GEOMETRY, '010500000002000000010200000003000000000000000000244000000000000024400000000000003440000000000000344000000000000024400000000000004440010200000004000000000000000000444000000000000044400000000000003E400000000000003E40000000000000444000000000000034400000000000003E400000000000002440':::GEOMETRY::GEOMETRY)::FLOAT8
FROM (VALUES (acosh(-0.3771205263403379)), ('+Inf'::FLOAT8)) v(col);

-- Test 112: query (line 1932)
SELECT
  a.dsc,
  b.dsc,
  ST_FrechetDistance(a.geom, b.geom),
  round(ST_FrechetDistance(a.geom, b.geom, 0.2), 12),
  ST_FrechetDistance(a.geom, b.geom, -1)
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 113: query (line 2088)
SELECT
  a.dsc,
  b.dsc,
  ST_HausdorffDistance(a.geom, b.geom),
  round(ST_HausdorffDistance(a.geom, b.geom, 0.4), 5)
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 114: query (line 2244)
SELECT
  a.dsc,
  b.dsc,
  ST_AsText(ST_LongestLine(a.geom, b.geom)),
  ST_AsText(ST_ShortestLine(a.geom, b.geom)),
  ST_AsText(ST_ClosestPoint(a.geom, b.geom))
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 115: query (line 2401)
SELECT
  a.dsc,
  b.dsc,
  ST_AsText(ST_Difference(a.geom, b.geom))
FROM geom_operators_test a, geom_operators_test b
ORDER BY a.dsc, b.dsc;

-- Test 116: query (line 2554)
SELECT
  st_astext(st_shortestline(a, b)),
  st_astext(st_longestline(a, b))
FROM ( VALUES
  (st_scale('multipoint (0 0, 1 1)', 0, 'NaN'::float)::geometry, 'linestring (0 0, 1 1)'::geometry)
) regression_t65422(a, b);

-- Test 117: query (line 2565)
SELECT
  a.dsc,
  b.dsc,
  ST_Covers(a.geom, b.geom),
  ST_CoveredBy(a.geom, b.geom),
  ST_Contains(a.geom, b.geom),
  ST_ContainsProperly(a.geom, b.geom),
  ST_Crosses(a.geom, b.geom),
  ST_Disjoint(a.geom, b.geom),
  ST_Equals(a.geom, b.geom),
  ST_OrderingEquals(a.geom, b.geom),
  ST_Intersects(a.geom, b.geom),
  ST_Overlaps(a.geom, b.geom),
  ST_Touches(a.geom, b.geom),
  ST_Within(a.geom, b.geom)
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 118: query (line 2730)
SELECT
  a.dsc,
  b.dsc,
  _ST_Covers(a.geom, b.geom),
  _ST_CoveredBy(a.geom, b.geom),
  _ST_Contains(a.geom, b.geom),
  _ST_ContainsProperly(a.geom, b.geom),
  _ST_Crosses(a.geom, b.geom),
  _ST_Equals(a.geom, b.geom),
  _ST_Intersects(a.geom, b.geom),
  _ST_Overlaps(a.geom, b.geom),
  _ST_Touches(a.geom, b.geom),
  _ST_Within(a.geom, b.geom)
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 119: query (line 2894)
SELECT
  a.dsc,
  b.dsc,
  ST_DWithin(a.geom, b.geom, 1),
  ST_DFullyWithin(a.geom, b.geom, 1)
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 120: query (line 3049)
SELECT
  a.dsc,
  b.dsc,
  _ST_DWithin(a.geom, b.geom, 1),
  _ST_DFullyWithin(a.geom, b.geom, 1)
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 121: query (line 3205)
SELECT
  a.dsc,
  ST_AsEWKT(ST_Buffer(a.geom, 10), 5),
  ST_AsEWKT(ST_Buffer(a.geom, 10, 2), 5),
  ST_AsEWKT(ST_Buffer(a.geom, 10, 'quad_segs=4 endcap=flat'), 5)
FROM geom_operators_test a
ORDER BY a.dsc;

-- Test 122: query (line 3228)
SELECT ST_NPoints(ST_Buffer('SRID=4326;POINT(0 0)', 10.0));

-- Test 123: query (line 3234)
SELECT
  ST_RelateMatch(m, pattern)
FROM ( VALUES
  ('101202FFF', 'TTTTTTFFF'),
  ('101202FTF', 'TTTTTTFFF')
) tbl(m, pattern);

-- Test 124: query (line 3245)
SELECT
  a.dsc,
  b.dsc,
  ST_Relate(a.geom, b.geom),
  ST_Relate(a.geom, b.geom, 3),
  ST_Relate(a.geom, b.geom, 'T**FF*FF*')
FROM geom_operators_test a
JOIN geom_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 125: query (line 3402)
SELECT
  a.dsc,
  ST_AsEWKT(ST_Envelope(a.geom)),
  ST_AsEWKT(ST_Envelope(a.geom::box2d))
FROM geom_operators_test a
ORDER BY a.dsc;

-- Test 126: query (line 3424)
SELECT
  a.dsc,
  GeometryType(a.geom),
  ST_GeometryType(a.geom),
  ST_NDims(a.geom),
  ST_CoordDim(a.geom),
  ST_Dimension(a.geom),
  ST_NPoints(a.geom),
  ST_NumGeometries(a.geom),
  ST_HasArc(a.geom)
FROM geom_operators_test a
ORDER BY a.dsc;

-- Test 127: query (line 3452)
SELECT
  dsc,
  ST_AsEWKT(ST_Points(geom))
FROM geom_operators_test
ORDER BY dsc;

-- Test 128: query (line 3472)
SELECT
  a.dsc,
  ST_AsEWKT(ST_GeometryN(a.geom, 0)),
  ST_AsEWKT(ST_GeometryN(a.geom, 1)),
  ST_AsEWKT(ST_GeometryN(a.geom, 2))
FROM geom_operators_test a
ORDER BY a.dsc;

-- Test 129: query (line 3495)
SELECT
  st_x(a.geom),
  st_y(a.geom)
FROM (VALUES
  ('POINT(1.0 2.0)'::geometry),
  ('POINT(33.0 66.0)'::geometry),
  ('POINT EMPTY'::geometry)
) a(geom);

-- Test 130: query (line 3510)
SELECT
  st_xmin(a.geom),
  st_ymin(a.geom)
FROM (VALUES
  ('POINT(1.0 2.0)'::geometry),
  ('POINT(33.0 66.0)'::geometry),
  ('POINT EMPTY'::geometry)
) a(geom);

-- Test 131: query (line 3524)
SELECT
  st_xmax(a.geom),
  st_ymax(a.geom)
FROM (VALUES
  ('POINT(1.0 2.0)'::geometry),
  ('POINT(33.0 66.0)'::geometry),
  ('POINT EMPTY'::geometry)
) a(geom);

-- Test 132: statement (line 3538)
SELECT st_x('LINESTRING(0.0 0.0, 1.0 1.0)');

-- Test 133: statement (line 3541)
SELECT st_y('LINESTRING(0.0 0.0, 1.0 1.0)');

-- Test 134: query (line 3545)
SELECT
  ST_AsEWKT(ST_StartPoint(a.geom)),
  ST_AsEWKT(ST_EndPoint(a.geom)),
  ST_NumPoints(a.geom),
  ST_AsEWKT(ST_PointN(a.geom, 0)),
  ST_AsEWKT(ST_PointN(a.geom, 1)),
  ST_AsEWKT(ST_PointN(a.geom, 2)),
  ST_AsEWKT(ST_PointN(a.geom, 3)),
  ST_AsEWKT(ST_PointN(a.geom, 4))
FROM (VALUES
  ('LINESTRING EMPTY'::geometry),
  ('LINESTRING (0.0 0.0, 1.0 1.0, 2.0 2.0)'::geometry),
  ('SRID=4326;LINESTRING (0.0 0.0, 1.0 1.0, 2.0 2.0)'::geometry),
  ('MULTILINESTRING ((0.0 0.0, 1.0 1.0, 2.0 2.0), (3.0 3.0, 4.0 4.0))'::geometry)
) a(geom);

-- Test 135: query (line 3568)
SELECT
  ST_NRings(a.geom),
  ST_NumInteriorRing(a.geom),
  ST_NumInteriorRings(a.geom),
  ST_AsEWKT(ST_ExteriorRing(a.geom)),
  ST_AsEWKT(ST_InteriorRingN(a.geom, 0)),
  ST_AsEWKT(ST_InteriorRingN(a.geom, 1)),
  ST_AsEWKT(ST_InteriorRingN(a.geom, 2))
FROM (VALUES
  ('POLYGON EMPTY'::geometry),
  ('POLYGON((0 0,1 0, 1 1, 0 0))'::geometry),
  ('POLYGON((0 0,1 0, 1 1, 0 0),(0.1 0.1,0.9 0.1, 0.9 0.9, 0.1 0.1))'::geometry),
  ('SRID=4326;POLYGON((0 0,1 0, 1 1, 0 0),(0.1 0.1,0.9 0.1, 0.9 0.9, 0.1 0.1))'::geometry),
  ('LINESTRING EMPTY'::geometry)
) a(geom);

-- Test 136: query (line 3592)
SELECT
  ST_xmin(a.geom),
  ST_xmax(a.geom),
  ST_ymin(a.geom),
  ST_ymax(a.geom)
FROM (VALUES
  ('POLYGON EMPTY'::geometry),
  ('POLYGON((0 0,1 0, 1 1, 0 0))'::geometry),
  ('POLYGON((0 0,2 0, 2 2, 0 0),(0.1 0.1,0.9 0.1, 0.9 0.9, 0.1 0.1))'::geometry),
  ('SRID=4326;POLYGON((0 0,1 0, 1 1, 0 0),(0.1 0.1,0.9 0.1, 0.9 0.9, 0.1 0.1))'::geometry),
  ('LINESTRING EMPTY'::geometry)
) a(geom);

-- Test 137: statement (line 3612)
SELECT ST_MakePolygon('MULTIPOINT(0 0, 1 1)');

-- Test 138: statement (line 3615)
SELECT ST_MakePolygon('abc');

-- Test 139: statement (line 3618)
SELECT ST_MakePolygon('LINESTRING EMPTY'::geometry);

-- Test 140: statement (line 3621)
SELECT ST_MakePolygon('LINESTRING (0 0, 1 0, 1 1, 0 0)'::geometry, ARRAY['LINESTRING EMPTY'::geometry]);

-- Test 141: statement (line 3624)
SELECT ST_AsEWKT(ST_MakePolygon(
      ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)', 4326),
      ARRAY[
        ST_GeomFromText('LINESTRING(50 70 40, 70 70 40, 70 50 40, 50 50 40, 50 70 40)', 4326)
      ]));

-- Test 142: statement (line 3631)
SELECT ST_MakePolygon(
    ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)'),
    ARRAY[
      ST_GeomFromText('MULTIPOINT(50 70, 70 70, 70 50, 50 50, 50 70)')
    ]);

-- Test 143: statement (line 3638)
SELECT ST_MakePolygon(
    ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)'),
    ARRAY[
      'MULTIPOINT(50 70, 70 70, 70 50, 50 50, 50 70)'
    ]);

-- Test 144: statement (line 3645)
SELECT ST_MakePolygon(
    ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)'),
    ARRAY['abc']);

-- Test 145: statement (line 3651)
SELECT ST_MakePolygon(
    ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)', 4326),
    ARRAY[
      ST_GeomFromText('LINESTRING(50 70, 70 70, 70 50, 50 50, 50 70)')
    ]);

-- Test 146: statement (line 3659)
SELECT ST_MakePolygon(
    ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)', 4326),
    ARRAY[
      ST_GeomFromText('LINESTRING(50 70, 70 70, 70 50, 50 50, 50 70)', 3857)
    ]);

-- Test 147: statement (line 3667)
SELECT ST_MakePolygon(
    ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)', 4326),
    ARRAY[
      ST_GeomFromText('LINESTRING(50 70, 70 70, 70 50, 50 50, 50 70)', 4326),
      ST_GeomFromText('LINESTRING(60 60, 75 60, 75 45, 60 45, 60 60)', 3857)
    ]);

-- Test 148: statement (line 3675)
SELECT ST_MakePolygon(ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 70)'));

-- Test 149: statement (line 3678)
SELECT ST_MakePolygon(ST_GeomFromText('LINESTRING(40 80, 80 80, 40 80)'));

-- Test 150: statement (line 3681)
SELECT ST_MakePolygon(
    ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)'),
    ARRAY[
      ST_GeomFromText('LINESTRING(50 70, 70 70, 70 50, 50 50, 50 60)')
    ]);

-- Test 151: statement (line 3688)
SELECT ST_MakePolygon(
    ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)'),
    ARRAY[
      ST_GeomFromText('LINESTRING(50 70, 70 70, 50 70)')
    ]);

-- Test 152: query (line 3695)
SELECT ST_AsEWKT(ST_MakePolygon( ST_GeomFromText('LINESTRING(75 29,77 29,77 29, 75 29)')));

-- Test 153: query (line 3700)
SELECT ST_AsEWKT(ST_MakePolygon( ST_GeomFromText('LINESTRING(75 29,77 29,77 29, 75 29)', 4326)));

-- Test 154: query (line 3705)
SELECT ST_AsEWKT(ST_MakePolygon(
      ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)'),
      ARRAY[
        ST_GeomFromText('LINESTRING(50 70, 70 70, 70 50, 50 50, 50 70)')
      ]));

-- Test 155: query (line 3714)
SELECT ST_AsEWKT(ST_MakePolygon(
      ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)'),
      ARRAY[
        ST_GeomFromText('LINESTRING(50 70, 70 70, 70 50, 50 50, 50 70)'),
        ST_GeomFromText('LINESTRING(60 60, 75 60, 75 45, 60 45, 60 60)')
      ]));

-- Test 156: query (line 3724)
SELECT ST_AsEWKT(ST_MakePolygon(
      ST_GeomFromText('LINESTRING(40 80, 80 80, 80 40, 40 40, 40 80)', 4326),
      ARRAY[
        ST_GeomFromText('LINESTRING(50 70, 70 70, 70 50, 50 50, 50 70)', 4326)
      ]));

-- Test 157: query (line 3733)
SELECT ST_AsEWKT(ST_Polygon( ST_GeomFromText('LINESTRING(75 29,77 29,77 29, 75 29)'), 4326));

-- Test 158: query (line 3739)
SELECT
  ST_NumGeometries(a.geom),
  ST_AsEWKT(ST_GeometryN(a.geom, 0)),
  ST_AsEWKT(ST_GeometryN(a.geom, 1)),
  ST_AsEWKT(ST_GeometryN(a.geom, 2))
FROM (VALUES
  ('MULTIPOINT EMPTY'::geometry),
  ('MULTILINESTRING EMPTY'::geometry),
  ('MULTIPOLYGON EMPTY'::geometry),
  ('MULTIPOINT((0 0), (1 1), (2 2))'::geometry),
  ('SRID=4326;MULTIPOINT((0 0), (1 1), (2 2))'::geometry),
  ('MULTILINESTRING((0 0, 1 1), (2 2, 3 3))'::geometry),
  ('SRID=4326;MULTILINESTRING((0 0, 1 1), (2 2, 3 3))'::geometry),
  ('MULTIPOLYGON(((0 0,1 0, 1 1, 0 0)),((0.1 0.1,0.9 0.1, 0.9 0.9, 0.1 0.1)))'::geometry),
  ('SRID=4326;MULTIPOLYGON(((0 0,1 0, 1 1, 0 0)),((0.1 0.1,0.9 0.1, 0.9 0.9, 0.1 0.1)))'::geometry),
  ('GEOMETRYCOLLECTION (POINT (40 10),LINESTRING (10 10, 20 20, 10 40),POLYGON ((40 40, 20 45, 45 30, 40 40)))'::geometry),
  ('SRID=4326;GEOMETRYCOLLECTION (POINT (40 10),LINESTRING (10 10, 20 20, 10 40),POLYGON ((40 40, 20 45, 45 30, 40 40)))'::geometry)
) a(geom);

-- Test 159: statement (line 3771)
CREATE TABLE geom_linear (
  dsc  TEXT PRIMARY KEY,
  geom GEOMETRY
);

-- Test 160: statement (line 3777)
INSERT INTO geom_linear VALUES
  ('Empty LineString', 'LINESTRING EMPTY'),
  ('LineString anticlockwise covering all the quadrants', 'LINESTRING(1 -1, 2 2, -2 2, -1 -1)'),
  ('LineString clockwise covering all the quadrants with SRID 4004', 'SRID=4004;LINESTRING(1 -1, -1 -1, -2 2, 2 2)');

-- Test 161: query (line 3784)
SELECT
  a.dsc,
  b.fraction,
  c.repeat,
  ST_AsEWKT(ST_LineInterpolatePoint(a.geom, b.fraction::float)),
  ST_AsEWKT(ST_LineInterpolatePoints(a.geom, b.fraction::float)),
  ST_AsEWKT(ST_LineInterPolatePoints(a.geom, b.fraction::float, c.repeat))
FROM geom_linear a
JOIN (VALUES (0.0), (0.2), (0.5), (0.51), (1.0)) b(fraction) ON (1=1)
JOIN (VALUES (true), (false)) c(repeat) ON (1=1)
ORDER BY a.dsc, b.fraction, c.repeat;

-- Test 162: statement (line 3828)
SELECT ST_LineInterpolatePoint('LINESTRING (0 0, 1 1)'::geometry, -1);

-- Test 163: statement (line 3831)
SELECT ST_LineInterpolatePoints('LINESTRING (0 0, 1 1)'::geometry, -1, false);

-- Test 164: statement (line 3834)
SELECT ST_LineInterpolatePoint('MULTILINESTRING ((0 0, 1 1), (1 1, 0 0))'::geometry, 0.2);

-- Test 165: statement (line 3837)
SELECT ST_LineInterpolatePoints('MULTILINESTRING ((0 0, 1 1), (1 1, 0 0))'::geometry, 0.2, false);

-- Test 166: statement (line 3840)
SELECT ST_LineInterpolatePoint('POINT (0 0)'::geometry, 0.2);

-- Test 167: statement (line 3843)
SELECT ST_LineInterpolatePoints('POINT (0 0)'::geometry, 0.2, false);

-- Test 168: statement (line 3846)
SELECT ST_LineInterpolatePoint('POLYGON((-1.0 0.0, 0.0 0.0, 0.0 1.0, -1.0 1.0, -1.0 0.0))'::geometry, 0.2);

-- Test 169: statement (line 3849)
SELECT ST_LineInterpolatePoints('POLYGON((-1.0 0.0, 0.0 0.0, 0.0 1.0, -1.0 1.0, -1.0 0.0))'::geometry, 0.2, false);

-- Test 170: statement (line 3854)
CREATE TABLE geog_operators_test AS SELECT dsc, geom::geography AS geog FROM geom_operators_test;

-- Test 171: query (line 3858)
SELECT
  a.dsc,
  round(ST_Area(a.geog), 2)
FROM geog_operators_test a
GROUP BY a.dsc, a.geog
ORDER BY a.dsc;

-- Test 172: query (line 3880)
SELECT
  a.dsc,
  round(ST_Area(a.geog), 4), round(ST_Area(a.geog, false), 4), round(ST_Area(a.geog, true), 4),
  round(ST_Length(a.geog), 4), round(ST_Length(a.geog, false), 4), round(ST_Length(a.geog, true), 4),
  round(ST_Perimeter(a.geog), 4), round(ST_Perimeter(a.geog, false), 4), round(ST_Perimeter(a.geog, true), 4)
FROM geog_operators_test a
ORDER BY a.dsc;

-- Test 173: query (line 3902)
SELECT
  a.dsc,
  ST_AsEWKT(a.geom),
  ST_AsEWKT(ST_Normalize(a.geom)),
  ST_AsEWKT(a.geom) = ST_AsEWKT(ST_Normalize(a.geom))
FROM geom_operators_test a
ORDER BY a.dsc;

-- Test 174: query (line 3925)
SELECT
  a.dsc,
  b.dsc,
  ST_Distance(a.geog, b.geog), ST_Distance(a.geog, b.geog, false), ST_Distance(a.geog, b.geog, true)
FROM geog_operators_test a
JOIN geog_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 175: query (line 4080)
SELECT
  a.dsc,
  b.dsc,
  ST_Covers(a.geog, b.geog),
  ST_CoveredBy(a.geog, b.geog),
  ST_Intersects(a.geog, b.geog)
FROM geog_operators_test a
JOIN geog_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 176: query (line 4236)
SELECT
  a.dsc,
  b.dsc,
  _ST_Covers(a.geog, b.geog),
  _ST_CoveredBy(a.geog, b.geog),
  _ST_Intersects(a.geog, b.geog)
FROM geog_operators_test a
JOIN geog_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 177: query (line 4393)
SELECT
  a.dsc,
  b.dsc,
  ST_DWithin(a.geog, b.geog, 70558),
  ST_DWithin(a.geog, b.geog, 70558, false),
  ST_DWithin(a.geog, b.geog, 70558, true)
FROM geog_operators_test a
JOIN geog_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 178: query (line 4549)
SELECT
  a.dsc,
  b.dsc,
  _ST_DWithin(a.geog, b.geog, 70558),
  _ST_DWithin(a.geog, b.geog, 70558, false),
  _ST_DWithin(a.geog, b.geog, 70558, true)
FROM geog_operators_test a
JOIN geog_operators_test b ON (1=1)
ORDER BY a.dsc, b.dsc;

-- Test 179: query (line 4710)
SELECT
  dsc,
  ST_AsText(ST_Segmentize(geog, 100000)),
  regexp_replace(ST_AsText(ST_Segmentize(geog, 50000)), '1.000028552944326', '1.000028552944327', 'g')
FROM geog_operators_test
ORDER BY dsc;

-- Test 180: query (line 4732)
SELECT
  a.dsc,
  ST_AsEWKT(ST_Buffer(a.geog, 10), 5),
  ST_AsEWKT(ST_Buffer(a.geog, 10, 2), 5),
  ST_AsEWKT(ST_Buffer(a.geog, 10, 'quad_segs=4 endcap=flat'), 5)
FROM geog_operators_test a
ORDER BY a.dsc;

-- Test 181: query (line 4755)
SELECT
  dsc,
  st_asewkt(st_intersection(a, b), 5)
FROM ( VALUES
  ('empty', 'POINT EMPTY'::geography, 'POINT EMPTY'::geography),
  ('non intersecting', 'POINT (1.5 1.5)'::geography, 'POINT (1.6 1.6)'::geography),
  ('intersecting', 'LINESTRING (0 0, 1 1)'::geography, 'LINESTRING (0 1, 1 0)'::geography)
) t(dsc, a, b);

-- Test 182: query (line 4770)
SELECT
  a.dsc,
  ST_AsEWKT(ST_Centroid(a.geog, false)),
  ST_AsEWKT(ST_Centroid(a.geog, true))
FROM geog_operators_test a
WHERE a.dsc != 'Nested Geometry Collection' -- unhandled in ST_Centroid, like in PostGIS.
ORDER BY a.dsc;

-- Test 183: statement (line 4791)
SELECT ST_Centroid('GEOMETRYCOLLECTION(POINT(0 0), LINESTRING EMPTY)'::geography, true);

-- Test 184: query (line 4794)
SELECT ST_AsText(ST_Segmentize('MULTIPOINT (0 0, 1 1)'::geography, -1));

-- Test 185: statement (line 4799)
SELECT ST_Segmentize('POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0))'::geography, 0);

-- Test 186: query (line 4802)
SELECT
  dsc,
  ST_AsText(ST_Segmentize(geom, 1)),
  ST_AsText(ST_Segmentize(geom, 0.3))
FROM geom_operators_test
ORDER BY dsc;

-- Test 187: query (line 4823)
SELECT ST_AsText(ST_Segmentize('MULTIPOINT (0 0, 1 1)'::geometry, -1));

-- Test 188: statement (line 4828)
SELECT ST_Segmentize('POLYGON ((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0))'::geometry, -1);

-- Test 189: query (line 4832)
SELECT
  dsc,
  ST_AsEWKT(ST_Force2D(geom))
FROM geom_operators_test
ORDER BY dsc;

-- Test 190: query (line 4853)
SELECT
  dsc,
  ST_AsEWKT(ST_Expand(geom, 10)),
  ST_AsEWKT(ST_Expand(geom, 15, 20))
FROM geom_operators_test
ORDER BY dsc;

-- Test 191: statement (line 4876)
CREATE TABLE geo_st_srid(
  id int primary key,
  geog geography(geometry),
  geom geometry(point)
);

-- Test 192: statement (line 4883)
INSERT INTO geo_st_srid VALUES
  (1, ST_GeogFromText('SRID=4004;POINT(1.0 2.0)'), ST_GeomFromText('POINT(5.0 5.0)', 0)),
  (2, ST_GeogFromText('SRID=4326;POINT(1.0 2.0)'), ST_GeomFromText('POINT(5.0 5.0)', 4326)),
  (3, ST_SetSRID(ST_GeogFromText('SRID=4326;POINT(1.0 2.0)'), 4004), ST_SetSRID(ST_GeomFromText('POINT(5.0 5.0)', 4326), 3857));

-- Test 193: query (line 4889)
SELECT
  id,
  st_srid(geog),
  st_srid(geom)
FROM geo_st_srid
ORDER BY id;

-- Test 194: statement (line 4903)
CREATE TABLE transform_test(geom geometry); INSERT INTO transform_test VALUES
  ('SRID=4326;POINT(1.0 1.0)'::geometry),
  ('SRID=3857;POINT(1.0 1.0)'::geometry),
  ('SRID=4326;LINESTRING(1.0 1.0, 2.0 2.0)'::geometry),
  ('SRID=3857;LINESTRING(1.0 1.0, 2.0 2.0)'::geometry),
  ('SRID=4326;POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0))'::geometry),
  ('SRID=3857;POLYGON((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0))'::geometry),
  ('SRID=4326;MULTIPOINT((1.0 1.0), (2.0 2.0))'::geometry),
  ('SRID=3857;MULTIPOINT((1.0 1.0), (2.0 2.0))'::geometry),
  ('SRID=4326;MULTILINESTRING((1.0 1.0, 2.0 2.0), (3.0 3.0, 4.0 4.0))'::geometry),
  ('SRID=3857;MULTILINESTRING((1.0 1.0, 2.0 2.0), (3.0 3.0, 4.0 4.0))'::geometry),
  ('SRID=4326;MULTIPOLYGON(((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0)))'::geometry),
  ('SRID=3857;MULTIPOLYGON(((0.0 0.0, 1.0 0.0, 1.0 1.0, 0.0 1.0, 0.0 0.0)))'::geometry),
  ('SRID=4326;GEOMETRYCOLLECTION (POINT (40 10),LINESTRING (10 10, 20 20, 10 40))'::geometry),
  ('SRID=3857;GEOMETRYCOLLECTION (POINT (40 10),LINESTRING (10 10, 20 20, 10 40))'::geometry);

-- Test 195: query (line 4922)
SELECT
  ST_AsEWKT(a.geom) d,
  ST_Transform(a.geom, 4326) = a.geom,
  ST_Transform(a.geom, 3857) = a.geom
FROM transform_test a
ORDER BY d ASC;

-- Test 196: query (line 4945)
SELECT
  ST_AsEWKT(a.geom) d,
  ST_Transform(a.geom, '+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs', '+proj=longlat +datum=WGS84 +no_defs') = a.geom,
  ST_Transform(a.geom, '+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs', 3857) = a.geom
FROM transform_test a
ORDER BY d ASC;

-- Test 197: query (line 4968)
SELECT
  ST_AsText(a.geom) d,
  ST_AsText(ST_Translate(a.geom, 1, 1))
FROM geom_operators_test a
ORDER BY d ASC;

-- Test 198: query (line 4988)
SELECT
  ST_AsText(a.geom) d,
  ST_AsText(ST_Scale(a.geom, .5 , 2)),
  ST_AsText(ST_Scale(a.geom, 'Point(.25 3)')),
  ST_AsText(ST_Scale(a.geom, 'Point(2 2)', 'Point(1 1)')),
  ST_AsText(ST_Scale(a.geom, 'POINT EMPTY'))
FROM geom_operators_test a
ORDER BY d ASC;

-- Test 199: query (line 5011)
SELECT
  ST_AsText(a.geom) d,
  ST_AsText(ST_Affine(a.geom, 1, 2, 3, 4, 5, 6), 3)
FROM geom_operators_test a
ORDER BY d ASC;

-- Test 200: query (line 5031)
SELECT ST_Summary('POINT(0 0)'::geometry);

-- Test 201: query (line 5038)
SELECT ST_Summary('POINT(0 0)'::geometry);

-- Test 202: query (line 5043)
SELECT ST_Summary('SRID=4326;POINT(0 0)'::geometry);

-- Test 203: query (line 5048)
SELECT ST_Summary('MULTIPOINT(0 0)'::geometry);

-- Test 204: query (line 5054)
SELECT ST_Summary('SRID=4326;MULTIPOINT(0 0)'::geometry);

-- Test 205: query (line 5060)
SELECT ST_Summary('GEOMETRYCOLLECTION(MULTILINESTRING((0 0, 1 0),(2 0, 4 4)),MULTIPOINT(0 0))'::geometry);

-- Test 206: query (line 5071)
SELECT ST_Summary('SRID=4326;GEOMETRYCOLLECTION(MULTILINESTRING((0 0, 1 0),(2 0, 4 4)),MULTIPOINT(0 0))'::geometry);

-- Test 207: query (line 5081)
SELECT ST_Summary('POINT(0 0)'::geography);

-- Test 208: query (line 5086)
SELECT ST_Summary('SRID=4326;POINT(0 0)'::geography);

-- Test 209: query (line 5091)
SELECT ST_Summary('MULTIPOINT(0 0)'::geography);

-- Test 210: query (line 5097)
SELECT ST_Summary('SRID=4326;MULTIPOINT(0 0)'::geography);

-- Test 211: query (line 5103)
SELECT ST_Summary('GEOMETRYCOLLECTION(MULTILINESTRING((0 0, 1 0),(2 0, 4 4)),MULTIPOINT(0 0))'::geography);

-- Test 212: query (line 5114)
SELECT ST_Summary('SRID=4326;GEOMETRYCOLLECTION(MULTILINESTRING((0 0, 1 0),(2 0, 4 4)),MULTIPOINT(0 0))'::geography);

-- Test 213: query (line 5124)
SELECT
	degrees(ST_Azimuth(ST_Point(25, 45)::geography, ST_Point(75, 90)::geography)) AS degA_B,
	degrees(ST_Azimuth(ST_Point(75, 90)::geography, ST_Point(25, 45)::geography)) AS degB_A;

-- Test 214: query (line 5131)
SELECT ST_Azimuth(ST_Point(0, 0)::geography, ST_Point(0, 0)::geography);

-- Test 215: statement (line 5136)
SELECT st_azimuth('0101000020E6100000000000000000F87F000000000000F87F':::GEOGRAPHY::GEOGRAPHY, '0101000020E6100000000000000000F03F000000000000F03F':::GEOGRAPHY::GEOGRAPHY)::FLOAT8;

-- Test 216: query (line 5140)
SELECT
  ST_Area(geom_str),
  ST_AsEWKT(geom_str),
  ST_AsGeoJSON(geom_str),
  ST_AsText(geom_str),
  ST_Length(geom_str)
FROM (VALUES
  ('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0 ))'),
  ('LINESTRING(0 0, 1 1, 2 2)')
) t(geom_str);

-- Test 217: query (line 5156)
SELECT
  ST_CoveredBy(a, b),
  ST_Covers(a, b),
  ST_Distance(a, b),
  ST_DWithin(a, b, 10),
  ST_Intersects(a, b)
FROM ( VALUES
  ('POLYGON ((0 0, 1 0, 1 1, 0 1, 0 0))', 'POINT(1.0 1.0)'),
  ('POINT(3 0)', 'POINT(10 0)'),
  ('POINT(3 0)', 'POINT(100 0)')
) t(a, b);

-- Test 218: query (line 5181)
SELECT ST_AsEWKT(ST_MakeLine(g::geometry)) FROM ( VALUES
  (NULL),
  ('POINT (30 10)'), -- value is used
  ('POINT EMPTY'),
  ('LINESTRING (30 10, 10 30, 40 40)'), -- value is used
  ('LINESTRING EMPTY'),
  ('POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10), (20 30, 35 35, 30 20, 20 30))'),
  ('MULTIPOINT ((10 40), (40 30), (20 20), (30 10))'), -- value is used
  ('MULTIPOINT EMPTY'),
  ('MULTILINESTRING ((10 10, 20 20, 10 40), (40 40, 30 30, 40 20, 30 10))'),
  ('MULTIPOLYGON (((30 20, 45 40, 10 40, 30 20)), ((15 5, 40 10, 10 20, 5 10, 15 5)))'),
  ('GEOMETRYCOLLECTION (POINT (40 10), LINESTRING (10 10, 20 20, 10 40), POLYGON ((40 40, 20 45, 45 30, 40 40)))')
) t(g);

-- Test 219: query (line 5198)
SELECT ST_AsEWKT(ST_MakeLine(g::geometry)) FROM ( VALUES
  (NULL)
) t(g);

-- Test 220: query (line 5205)
SELECT ST_AsText(ST_MakeLine(geom ORDER BY geom)) FROM geo_table;

-- Test 221: query (line 5210)
SELECT ST_Extent(g::geometry) FROM ( VALUES
  (NULL),
  ('POINT(-10.5 10.5)'),
  ('LINESTRING(0 0, 15 15)'),
  ('POLYGON ((35 10, 45 45, 15 40, 10 20, 35 10), (20 30, 35 35, 30 20, 20 30))'),
  ('POINT EMPTY')
) t(g);

-- Test 222: query (line 5221)
SELECT ST_Extent(g::geometry) FROM ( VALUES (NULL), ('POINT EMPTY') ) t(g);

-- Test 223: query (line 5226)
SELECT ST_AsEWKT(ST_Union(g::geometry)) FROM ( VALUES (NULL) ) tbl(g);

-- Test 224: query (line 5231)
SELECT ST_AsEWKT(ST_Union(g::geometry)) FROM ( VALUES (NULL), ('POINT(1 0)') ) tbl(g);

-- Test 225: statement (line 5236)
SELECT ST_AsEWKT(ST_Union(g::geometry)) FROM ( VALUES ('POINT(1 0)'), ('SRID=3857;POINT(1 0)') ) tbl(g);

-- Test 226: query (line 5239)
SELECT ST_AsEWKT(ST_Union(g::geometry)) FROM ( VALUES (NULL), ('POINT(1 0)'), ('LINESTRING(0 0, 5 0)')) tbl(g);

-- Test 227: query (line 5244)
SELECT ST_AsEWKT(ST_MemUnion(g::geometry)) FROM ( VALUES (NULL), ('POINT(1 0)'), ('LINESTRING(0 0, 5 0)')) tbl(g);

-- Test 228: query (line 5249)
SELECT ST_AsEWKT(ST_Collect(g::geometry)) FROM ( VALUES (NULL) ) tbl(g);

-- Test 229: query (line 5254)
SELECT ST_AsEWKT(ST_Collect(g::geometry)) FROM ( VALUES (NULL), ('POINT(1 0)') ) tbl(g);

-- Test 230: statement (line 5259)
SELECT ST_AsEWKT(ST_Collect(g::geometry)) FROM ( VALUES ('POINT(1 0)'), ('SRID=3857;POINT(1 0)') ) tbl(g);

-- Test 231: query (line 5262)
SELECT ST_AsEWKT(ST_Collect(g::geometry)) FROM ( VALUES (NULL), ('POINT(1 0)'), ('LINESTRING(0 0, 5 0)')) tbl(g);

-- Test 232: query (line 5267)
SELECT ST_AsEWKT(ST_Collect(g::geometry)) FROM ( VALUES (NULL), ('POINT (1 1)'), ('POINT EMPTY'), ('POINT (2 2)')) tbl(g);

-- Test 233: query (line 5272)
SELECT ST_AsEWKT(ST_Collect(g::geometry)) FROM ( VALUES ('MULTIPOINT (1 1, 2 2)'), ('POINT (3 3)')) tbl(g);

-- Test 234: query (line 5277)
SELECT ST_AsEWKT(ST_Collect(g::geometry)) FROM ( VALUES ('MULTIPOINT (1 1, 2 2)'), ('MULTIPOINT (3 3, 4 4)')) tbl(g);

-- Test 235: query (line 5282)
SELECT ST_AsEWKT(ST_Collect(g::geometry)) FROM ( VALUES ('GEOMETRYCOLLECTION (POINT (1 1))'), ('GEOMETRYCOLLECTION (POINT (2 2))')) tbl(g);

-- Test 236: query (line 5287)
SELECT ST_AsText(ST_Collect(geom ORDER BY geom)) FROM geo_table;

-- Test 237: query (line 5292)
SELECT ST_AsText(ST_MemCollect(geom ORDER BY geom)) FROM geo_table;

-- Test 238: query (line 5297)
SELECT ST_AsEWKT(ST_MemCollect(g::geometry)) FROM ( VALUES (NULL), ('POINT (1 1)'), ('POINT EMPTY'), ('POINT (2 2)')) tbl(g);

-- Test 239: query (line 5302)
SELECT ST_AsEWKT(
  ST_SharedPaths(
    ST_GeomFromText('MULTILINESTRING((26 125,26 200,126 200,126 125,26 125),
	   (51 150,101 150,76 175,51 150))'),
	ST_GeomFromText('LINESTRING(151 100,126 156.25,126 125,90 161, 76 175)')));

-- Test 240: query (line 5313)
SELECT
  ST_AsText(ST_AddPoint(ls::geometry, p::geometry, i))
FROM ( VALUES
  ('LINESTRING(0 0, 1 1, 2 2)', 'POINT(5 5)', 0),
  ('LINESTRING(0 0, 1 1, 2 2)', 'POINT(5 5)', 2),
  ('LINESTRING(0 0, 1 1, 2 2)', 'POINT(5 5)', 3),
  ('LINESTRING(0 0, 1 1, 2 2)', 'POINT(5 5)', -1)
  )
 t(ls, p, i);

-- Test 241: query (line 5329)
SELECT
  ST_AsText(ST_AddPoint(ls::geometry, p::geometry))
FROM ( VALUES
  ('LINESTRING(0 0, 1 1, 2 2)', 'POINT(5 5)')
  )
 t(ls, p);

-- Test 242: query (line 5342)
SELECT
  ST_AsText(ST_SetPoint(ls::geometry, i, p::geometry))
FROM ( VALUES
  ('LINESTRING(-1 2,-1 3)', 0, 'POINT(10 10)'),
  ('LINESTRING(0 0, 1 1, 2 2)', 2, 'POINT(10 10)'),
  ('LINESTRING(0 0, 1 1, 2 2, 3 3)', -1, 'POINT(10 10)'),
  ('LINESTRING(0 0, 1 1, 2 2, 3 3)', -4, 'POINT(10 10)')
  )
 t(ls, i, p);

-- Test 243: query (line 5360)
SELECT
  ST_AsText(ST_RemovePoint(ls::geometry, i))
FROM ( VALUES
  ('LINESTRING(0 0, 1 1, 2 2)', 2),
  ('LINESTRING(0 0, 1 1, 2 2, 3 3)', 0),
  ('LINESTRING(0 0, 1 1, 2 2, 3 3)', 1)
  )
 t(ls, i);

-- Test 244: query (line 5376)
SELECT
  ST_AsText(ST_RemoveRepeatedPoints(ls::geometry, i::float))
FROM ( VALUES
  ('LINESTRING(0 0, 0 0, 1 1, 2 2, 3 3, 4 4)', 0.0),
  ('LINESTRING(0 0, 1 1, 2 2, 3 3, 4 4, 5 5)', 1.4),
  ('LINESTRING(0 0, 1 1, 2 2, 3 3, 4 4, 5 5)', 1.5),
  ('LINESTRING(0 0, 1 1, 2 2, 3 3, 4 4, 5 5)', 3.0)
  )
 t(ls, i);

-- Test 245: query (line 5394)
SELECT
  ST_AsText(a.geom) d,
  ST_AsText(ST_Reverse(a.geom))
FROM geom_operators_test a
ORDER BY d ASC;

-- Test 246: query (line 5416)
SELECT
  ST_AsText(ST_LineFromMultiPoint(mp::geometry))
FROM ( VALUES
  ('MULTIPOINT EMPTY'),
  ('MULTIPOINT (1 1, 2 2, 3 3)')
  )
 t(mp);

-- Test 247: query (line 5430)
SELECT
  ST_AsText(ST_LineMerge(g::geometry))
FROM ( VALUES
  ('MULTILINESTRING ((1 2, 3 4), (3 4, 5 6))'),
  ('MULTILINESTRING ((1 2, 3 4), (5 6, 7 8))'),
  ('POINT (1 2)')
  )
 t(g);

-- Test 248: statement (line 5444)
select st_linemerge('01020000C003000000000000000000F0FF000000000000F8FF60DB272315DEBAC13CDE36003499DEC1000000000000F0FF000000000000F8FF9CDB5D9AA401E1C1D0C80253A5F1C4C1000000000000F0FF000000000000F8FF003E39CD6CDDD2C1A6909F31D737F4C1'::geometry);

-- Test 249: query (line 5449)
SELECT public.ST_AsText('POINT(10.5 20.25)'::geometry);

-- Test 250: statement (line 5454)
SELECT public.log(10);

-- Test 251: query (line 5457)
SELECT
  ST_AsText(a.geom) d,
  ST_AsText(ST_FlipCoordinates(a.geom))
FROM geom_operators_test a
ORDER BY d ASC;

-- Test 252: query (line 5480)
SELECT
  ST_AsText(a.geom) d,
  ST_AsText(ST_Rotate(a.geom, pi())),
  regexp_replace(ST_AsText(ST_Rotate(a.geom, pi()/4)), 'POINT \(0.000000000000001 7.071067811865476\)', 'POINT (0 7.071067811865476)', 'g')
FROM geom_operators_test a
ORDER BY d ASC;

-- Test 253: query (line 5501)
SELECT
    ST_AsText(a.geom) d,
    ST_AsText(ST_Rotate(a.geom, pi(),4,7))
FROM geom_operators_test a
ORDER BY d;

-- Test 254: query (line 5522)
SELECT
    ST_AsText(ST_Rotate(a.geom, pi(), 'POINT (6 3)'::geometry)) as t
FROM geom_operators_test a
ORDER BY t;

-- Test 255: query (line 5541)
SELECT st_asewkt(st_rotate('LINESTRING (1 5, 5 1)'::geometry,pi()/4,'POINT EMPTY'::geometry));

-- Test 256: query (line 5546)
SELECT
  ST_AsText(a.geom) d,
  ST_AsEWKT(ST_SnapToGrid(a.geom, 0.1)),
  ST_AsEWKT(ST_SnapToGrid(a.geom, 0.1, 0.01)),
  ST_AsEWKT(ST_SnapToGrid(a.geom, 0.05, 0.05, 0.1, 0.01))
FROM geom_operators_test a
ORDER BY d ASC;

-- Test 257: query (line 5568)
SELECT
  ST_AsText(a.geom) d,
  ST_AsText(ST_SwapOrdinates(a.geom,'Xy'))
FROM geom_operators_test a
ORDER BY d;

-- Test 258: query (line 5588)
SELECT
  ST_AsEWKT(geom::geometry),
  ST_AsEWKT(ST_S2Covering(geom::geometry)),
  ST_AsEWKT(ST_S2Covering(geom::geometry, 's2_max_cells=2'))
FROM ( VALUES
  ('POLYGON EMPTY'),
  ('LINESTRING(-30000 -40000, 15 15)'),
  ('LINESTRING(-15 -15, 15 15)'),
  ('SRID=3854;LINESTRING(56000 9000, 58000 9323)'),
  ('SRID=3857;LINESTRING(-30000 -40000, 15 15)'),
  ('SRID=3857;LINESTRING(-3004343200 -4002312300, 15 15)')
) tbl(geom);

-- Test 259: query (line 5609)
SELECT
  ST_AsEWKT(geog::geography),
  ST_AsEWKT(ST_S2Covering(geog::geography)),
  ST_AsEWKT(ST_S2Covering(geog::geography, 's2_max_cells=2'))
FROM ( VALUES
  ('POLYGON EMPTY'),
  ('LINESTRING(15 15, 30 30)'),
  ('SRID=4004;LINESTRING(15 15, 30 30)'),
  ('SRID=4004;LINESTRING(-180 -90, 180 90)')
) tbl(geog);

-- Test 260: query (line 5628)
SELECT ST_MemSize(g) FROM ( VALUES
   (ST_GeomFromText('POINT EMPTY')),
   (ST_GeomFromText('POINT (0 0)')),
   (ST_GeomFromText('POLYGON EMPTY')),
   (ST_GeomFromText('LINESTRING EMPTY')),
   (ST_GeomFromText('POLYGON ((-1 0, 1 0, 1 1, -1 1, -1 0))')),
   (ST_GeomFromText('LINESTRING (-0.5 0.5, 0.5 0.5)')),
   (ST_GeomFromText('GEOMETRYCOLLECTION (GEOMETRYCOLLECTION (POINT (0 0)))'))
) mem_size_test(g);

-- Test 261: query (line 5649)
SELECT ST_PointInsideCircle(point, x, y, radius) FROM ( VALUES
   ((ST_Point(1,2)),    (0.5::float), (2.0::float), (3.0::float)),
   ((ST_Point(0,0)),    (3.0::float), (3.0::float), (2.0::float)),
   ((ST_Point(1,-1)),    (1.5::float), (-2.0::float), (5.0::float)),
   ((ST_Point(0,0)),    (1.0::float), (1.0::float), (1.0::float)),
   ((ST_Point(0,0)),    (1.0::float), (1.0::float), (2.0::float)),
   ((ST_Point(-1,-1)),  (1.0::float), (1.0::float), (1.0::float)),
   ((ST_Point(-1,-1)),  (1.0::float), (1.0::float), (2.0::float)),
   ((ST_Point(2.5,-2)), (2.5::float), (-1.5::float), (1.0::float)),
   ((ST_Point(2.5,-2)), (2.5::float), (-1.0::float), (0.5::float)),
   ((ST_Point(2.5,-2)), (2.5::float), (-1.5::float), (2.0::float))
) points_inside_circle(point, x, y, radius);

-- Test 262: statement (line 5674)
SELECT ST_PointInsideCircle(ST_Point(1,2), 0.5, 2, -3);

-- Test 263: statement (line 5677)
SELECT ST_PointInsideCircle(ST_GeomFromText('LINESTRING (-0.5 0.5, 0.5 0.5)'), 0.5, 2, -3);

-- Test 264: query (line 5682)
SELECT round(ST_LineLocatePoint(line, point)::float, 2) FROM ( VALUES
  ((ST_GeomFromText('LINESTRING (0 2, 2 0)')), (ST_Point(0, 0))),
  ((ST_GeomFromText('LINESTRING (0 0, 0 2)')), (ST_Point(1, 1))),
  ((ST_GeomFromText('LINESTRING (-1 -1, 3 3)')), (ST_Point(1, 0))),
  ((ST_GeomFromText('LINESTRING (0 1, 2 0)')), (ST_Point(0, 0))),
  ((ST_GeomFromText('LINESTRING (-1 0, 0 1)')), (ST_Point(1, 0))),
  ((ST_GeomFromText('LINESTRING (0 0, 0 1)')), (ST_Point(1, 0))),
  ((ST_GeomFromText('LINESTRING (-3 5, 4 -2)')), (ST_Point(-1, -1))),
  ((ST_GeomFromText('LINESTRING (0 0, 10 10)')), (ST_Point(0, 3))),
  ((ST_GeomFromText('LINESTRING (-5 7, 1 4)')), (ST_Point(-3, 3)))
) line_locate_point(line, point);

-- Test 265: statement (line 5705)
SELECT ST_LineLocatePoint(ST_GeomFromText('GEOMETRYCOLLECTION (GEOMETRYCOLLECTION (POINT (0 0)))'), ST_Point(0, 0));

-- Test 266: query (line 5709)
SELECT
  ST_AsEWKT(ST_LineFromEncodedPolyline('ud}|Hi_juBa~kk@m}t_@'), 5),
  ST_AsEWKT(ST_LineFromEncodedPolyline('|_cw}Daosrst@udew}D`osrst@', 8), 8);

-- Test 267: statement (line 5717)
SELECT ST_AsEWKT(ST_LineFromEncodedPolyline('NO'), 5);

-- Test 268: query (line 5720)
SELECT
  ST_AsEncodedPolyline(GeomFromEWKT('SRID=4326;LINESTRING(-120.2 38.5,-120.95 40.7,-126.453 43.252)')),
  ST_AsEncodedPolyline(GeomFromEWKT('SRID=4326;LINESTRING(9.00000001 -1.00009999, 0.00000007 0.00000091)'), 8);

-- Test 269: statement (line 5728)
SELECT ST_AsEncodedPolyline(GeomFromEWKT('SRID=4004;LINESTRING(9.00000001 -1.00009999, 0.00000007 0.00000091)'), 8);

-- Test 270: query (line 5733)
SELECT ST_AsText(center), round(radius, 2) FROM ST_MinimumBoundingRadius('POLYGON((26426 65078,26531 65242,26075 65136,26096 65427,26426 65078))');

-- Test 271: query (line 5738)
SELECT ST_AsText(center), round(radius, 2) FROM ST_MinimumBoundingRadius('GEOMETRYCOLLECTION (LINESTRING(0 0, 4 0), POINT(0 4))');

-- Test 272: query (line 5743)
SELECT ST_AsText(center), round(radius, 2) FROM ST_MinimumBoundingRadius('LINESTRING EMPTY');

-- Test 273: query (line 5748)
SELECT ST_AsText(center), round(radius, 2) FROM ST_MinimumBoundingRadius('POLYGON((0 2,-2 0,0 -2,2 0,0 2))');

-- Test 274: query (line 5756)
SELECT ST_AsText(ST_SnapToGrid(ST_MinimumBoundingCircle(ST_GeomFromText('GEOMETRYCOLLECTION (LINESTRING(55 75,125 150), POINT(20 80))')), 0.001));

-- Test 275: query (line 5761)
SELECT ST_AsText(ST_SnapToGrid(ST_MinimumBoundingCircle(ST_GeomFromText('GEOMETRYCOLLECTION (LINESTRING(0 0, 4 0), POINT(0 4))')), 0.001));

-- Test 276: query (line 5766)
SELECT ST_AsText(ST_SnapToGrid(ST_MinimumBoundingCircle(ST_GeomFromText('POINT EMPTY')), 0.001));

-- Test 277: query (line 5771)
SELECT ST_AsText(ST_SnapToGrid(ST_MinimumBoundingCircle(ST_GeomFromText('POINT(0 0)')), 0.001));

-- Test 278: statement (line 5776)
SELECT st_astext(st_minimumboundingcircle(
  st_makepoint(
    (-0.23349138300862382)::FLOAT8,
    (-1.0):::FLOAT8::FLOAT8 ^ (0.7478831141483115:::FLOAT8 - (0))::FLOAT8
  )
)) AS regression_81277;

-- Test 279: query (line 5784)
SELECT ST_AsText(ST_SnapToGrid(ST_MinimumBoundingCircle(ST_GeomFromText('GEOMETRYCOLLECTION (LINESTRING(55 75,125 150), POINT(20 80))'), 4), 0.001));

-- Test 280: query (line 5789)
SELECT ST_MinimumBoundingCircle(NULL::geometry) IS NULL;

-- Test 281: statement (line 5794)
select st_minimumboundingcircle(st_makepoint(((-0.27013513189303495):::FLOAT8::FLOAT8 // 5e-324:::FLOAT8::FLOAT8)::FLOAT8::FLOAT8, (-0.4968052087960828):::FLOAT8::FLOAT8)::GEOMETRY::GEOMETRY)::GEOMETRY;

-- Test 282: statement (line 5797)
select st_minimumboundingcircle(st_makepoint(((-0.27013513189303495):::FLOAT8::FLOAT8 // 5e-324:::FLOAT8::FLOAT8)::FLOAT8::FLOAT8, (-0.4968052087960828):::FLOAT8::FLOAT8)::GEOMETRY::GEOMETRY, 10)::GEOMETRY;

-- Test 283: query (line 5802)
SELECT ST_AsText(ST_UnaryUnion(ST_GeomFromText('MULTIPOLYGON(((0 0,4 0,4 4,0 4,0 0),(1 1,2 1,2 2,1 2,1 1)), ((-1 -1,-1 -2,-2 -2,-2 -1,-1 -1)))')));

-- Test 284: query (line 5808)
SELECT
   st_astext(st_transscale(geom,10,4,8,9)) as a
FROM geom_operators_test ORDER BY a;

-- Test 285: query (line 5829)
SELECT
  ST_AsText(ST_Node(ST_GeomFromText('LINESTRING(1 1, 4 4, 1 4, 4 1)'))),
  ST_AsText(ST_Node(ST_GeomFromText('MULTILINESTRING((0 0, 10 10, 0 10, 10 0), (1 1, 4 4), (1 3, 4 2), (0 0, 10 10, 0 10, 10 0))')));

-- Test 286: statement (line 5837)
SELECT ST_AsText(ST_Node(ST_GeomFromText('POLYGON((1 1, 1 3, 3 3, 3 1, 1 1))')));

-- Test 287: query (line 5840)
SELECT
ST_AsEWKT(
  ST_SubDivide('SRID=4326;POLYGON((132 10,119 23,85 35,68 29,66 28,49 42,32 56,22 64,32 110,40 119,36 150,
                          57 158,75 171,92 182,114 184,132 186,146 178,176 184,179 162,184 141,190 122,
                          190 100,185 79,186 56,186 52,178 34,168 18,147 13,132 10))'::geometry,10)
);

-- Test 288: query (line 5854)
SELECT ST_AsText(ST_Subdivide('POLYGON((-1 -1,-1 -0.5, -1 0, 1 0.5, 1 -1,-1 -1))'::geometry));

-- Test 289: query (line 5859)
SELECT ST_AsText(ST_Subdivide('SRID=4269;LINESTRING(0 0, 10 15, 0 0, 10 15, 10 0, 10 15)'::geometry, 5));

-- Test 290: statement (line 5867)
SELECT ST_AsText(ST_SubDivide(ST_GeomFromText('POLYGON((1 1, 1 3, 3 3, 3 1, 1 1))'), 4));

-- Test 291: query (line 5870)
SELECT ST_AsText(ST_VoronoiPolygons(ST_GeomFromText('MULTIPOINT(50 30, 60 30, 100 100,10 150, 110 120)'))::geometry, 1);

-- Test 292: query (line 5877)
SELECT ST_AsText(ST_VoronoiLines(ST_GeomFromText('MULTIPOINT(50 30, 60 30, 100 100,10 150, 110 120)'))::geometry, 5);

-- Test 293: query (line 5882)
SELECT ST_AsText(ST_GeneratePoints('POLYGON((0 0,2 5,2.5 4,3 5,3 1,0 0))'::geometry, 5, 1996)::geometry, 5);

-- Test 294: statement (line 5887)
SELECT ST_AsText(ST_GeneratePoints('POLYGON((0 0, 1 1, 1 1, 0 0))'::geometry, 4, 1));

-- Test 295: statement (line 5890)
SELECT ST_AsText(ST_GeneratePoints('POLYGON((0 0,2 5,2.5 4,3 5,3 1,0 0))'::geometry, 5, 0));

-- Test 296: query (line 5893)
SELECT t AS should_be_null FROM ( VALUES
  (ST_GeneratePoints('POLYGON ((0 0, 1 0, 1 1, 0 0))', -1)),
  (ST_GeneratePoints('POLYGON ((0 0, 1 0, 1 1, 0 0))', -2, 3)),
  (ST_GeneratePoints('POLYGON EMPTY', 2)),
  (ST_GeneratePoints('POLYGON EMPTY', 2))
) t(t);

-- Test 297: query (line 5908)
SELECT ST_AsText(ST_OrientedEnvelope(ST_GeomFromText('MULTIPOINT ((0 0), (-1 -1), (3 2))')));

-- Test 298: statement (line 5914)
select st_astext(st_linesubstring('LINESTRING(0 0, 0 5, 5 5,10 3)'::geometry,0.5,0.4));

-- Test 299: statement (line 5917)
select st_astext(st_linesubstring('LINESTRING(0 0, 0 5, 5 5,10 3)'::geometry,0,1.4));

-- Test 300: statement (line 5920)
select st_astext(st_linesubstring('POINT(0 0)'::geometry,0.5,0.4));

-- Test 301: query (line 5923)
select st_astext(st_linesubstring(g,star,"end")::geometry, 1)from (VALUES
       ('LINESTRING(0 0, 0 5, 4 5, 4 2)'::geometry, 0.0, 0.3),
       ('LINESTRING(-25 -50, 100 125, 150 190, 40 60)'::geometry, 0.8, 0.9),
       ('LINESTRING(70 10, 10 125.6, 15.40 1.9, 4 6)'::geometry, 0.1, 0.8),
       ('LINESTRING(70 10, 10 125)'::geometry, 0.1, 0.8),
       ('LINESTRING(70 10, 10 125)'::geometry, 0.8, 0.8),
       ('LINESTRING(0 0, 0 0)'::geometry, 0.8, 0.8),
       ('LINESTRING EMPTY'::geometry, 0.1, 0.2)
    ) t(g,star, "end");

-- Test 302: query (line 5942)
SELECT ST_AsEWKT(ST_ShiftLongitude(geom)) FROM ( VALUES
  ('POINT(0 0)'::geometry),
  ('POINT(-1 90)'::geometry),
  ('POINT(181 -23)'::geometry),
  ('LINESTRING(2 2, 5 -60, 200 0)'::geometry),
  ('POLYGON((-6 -10, 6 -10, 0 20, -6 -10), (3 2, -1 -1, 1 -5, 3 2))'::geometry)
) t(geom);

-- Test 303: query (line 5957)
SELECT ST_AsEWKT(ST_ShiftLongitude(geom)) FROM ( VALUES
  ('SRID=4326;POINT(0 0)'::geometry),
  ('SRID=4326;POINT(-1 90)'::geometry),
  ('SRID=4326;POINT(181 -23)'::geometry),
  ('SRID=4326;LINESTRING(2 2, 5 -60, 200 0)'::geometry),
  ('SRID=4326;POLYGON((-6 -10, 6 -10, 0 20, -6 -10), (3 2, -1 -1, 1 -5, 3 2))'::geometry)
) t(geom);

-- Test 304: query (line 5972)
SELECT ST_AsText(
    ST_Snap(poly,line, ST_Distance(poly, line)*1.25)
) AS polysnapped
FROM (SELECT
    ST_GeomFromText('MULTIPOLYGON(
      (( 26 125, 26 200, 126 200, 126 125, 26 125 ),
      ( 51 150, 101 150, 76 175, 51 150 )),
      (( 151 100, 151 200, 176 175, 151 100 )))') As poly,
    ST_GeomFromText('LINESTRING (5 107, 54 84, 101 100)') As line
	) tbl(poly, line);

-- Test 305: query (line 5986)
SELECT
  ST_EstimatedExtent('a', 'b', 'c', false),
  ST_EstimatedExtent('a', 'b', 'c'),
  ST_EstimatedExtent('a', 'b');

-- Test 306: query (line 5994)
SELECT ST_LineCrossingDirection(line1, line2), ST_LineCrossingDirection(line2, line1) FROM ( VALUES
    ((ST_GeomFromText('LINESTRING(0 -20, 0 20)')), (ST_GeomFromText('LINESTRING(5 5, 5 10)'))),
    ((ST_GeomFromText('LINESTRING(25 169,89 114,40 70,86 43)')), (ST_GeomFromText('LINESTRING(171 154,20 140,71 74,161 53)'))),
    ((ST_GeomFromText('LINESTRING(25 169,89 114,40 70,86 43)')), (ST_GeomFromText('LINESTRING (20 140, 71 74, 161 53)'))),
    ((ST_GeomFromText('LINESTRING(25 169,89 114,40 70,86 43)')), (ST_GeomFromText('LINESTRING (171 154, 20 140, 71 74, 2.99 90.16)'))),
    ((ST_GeomFromText('LINESTRING(25 169,89 114,40 70,86 43)')), (ST_GeomFromText('LINESTRING(2.99 90.16,71 74,20 140,171 154)')))
) line_crossing_direction_test(line1, line2);

-- Test 307: query (line 6010)
SELECT ST_Intersects(point, polygon), ST_Within(point, polygon), ST_Contains(polygon, point)
FROM ( VALUES
  (ST_MakePoint('NaN', 1), 'POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'::geometry),
  (ST_MakePoint(0, 1), ST_MakePolygon(ST_AddPoint(ST_AddPoint('LINESTRING(0 0, 1 0)', ST_MakePoint(0, 'NaN')), ST_MakePoint(0, 0))))
) t(point, polygon);

-- Test 308: query (line 6021)
SELECT ST_AsEWKT(ST_MakeEnvelope(30.01,50.01,72.01,52.01,4326));

-- Test 309: query (line 6026)
SELECT ST_AsEWKT(ST_MakeEnvelope(30.01,50.01,72.01,52.01));

-- Test 310: query (line 6033)
SELECT
  ST_AsText(ST_BdPolyFromText('MULTILINESTRING((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))', 4326)),
  ST_AsText(ST_BdPolyFromText('MULTILINESTRING((0 0, 1 0, 1 1, 0 1, 0 0))', 4326)),
  ST_AsEWKT(ST_BdPolyFromText('MULTILINESTRING((0 0, 1 0, 1 1, 0 1, 0 0))', 4326));

-- Test 311: query (line 6041)
SELECT
  ST_AsEWKT(ST_BdPolyFromText(NULL, 4326)),
  ST_AsEWKT(ST_BdPolyFromText('MULTILINESTRING((0 0, 10 0, 10 10, 0 10, 0 0),(1 1, 1 2, 2 2, 2 1, 1 1))', NULL));

-- Test 312: statement (line 6048)
SELECT ST_AsText(ST_BdPolyFromText('POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))', 4326));

-- Test 313: statement (line 6051)
SELECT ST_AsText(ST_BdPolyFromText('LINESTRING(0 0, 1 0, 1 1, 0 1, 0 0)', 4326));

-- Test 314: statement (line 6054)
SELECT ST_AsText(ST_BdPolyFromText('POINT(0 0)', 4326));

-- Test 315: query (line 6059)
SELECT ST_AsText(ST_AsMVTGeom(
    ST_GeomFromText('LINESTRING (0 0, 10.6 0.4, 10.6 5.4, 0 -5, 0 0)'),
    ST_MakeBox2D(ST_Point(0, 0), ST_Point(20, 20)),
    20, 0, false));

-- Test 316: statement (line 6067)
SELECT ST_AsText(ST_AsMVTGeom(
    ST_GeomFromText('LINESTRING (0 0, 10.6 0.4, 10.6 5.4, 0 -5, 0 0)'),
    ST_MakeBox2D(ST_Point(0, 0), ST_Point(20, 20)),
    20, -1, false));

-- Test 317: query (line 6073)
SELECT st_asmvtgeom(
  '0103000000010000000500000000000000000000000000000000000000000000000000F03F0000000000000000000000000000F03F000000000000F03F0000000000000000000000000000F03F00000000000000000000000000000000'::GEOMETRY,
  'BOX(-0.7283491852530968 -1.8211168776573217,0.5639272771291987 1.4483176236186077)'::BOX2D,
  1,
  34268045,
  true
) AS regression_109113;

-- Test 318: statement (line 6098)
insert into t103616 values ('null', null, null);

-- Test 319: statement (line 6101)
insert into t103616 values ('point (0 0)', 'POINT(0 0)'::GEOGRAPHY, 'POINT(0 0)'::GEOMETRY);

-- Test 320: statement (line 6104)
insert into t103616 values ('point (10 10)', 'POINT(10 10)'::GEOGRAPHY, 'POINT(10 10)'::GEOMETRY);

-- Test 321: statement (line 6107)
insert into t103616 values ('empty 1', ST_GeogFromText('POLYGON EMPTY'), ST_GeomFromText('POLYGON EMPTY'));

-- Test 322: statement (line 6110)
insert into t103616 values ('empty 2', ST_GeogFromText('GEOMETRYCOLLECTION EMPTY'), ST_GeomFromText('GEOMETRYCOLLECTION EMPTY'));

-- Test 323: query (line 6114)
SELECT tag FROM t103616@geog_idx
WHERE
    st_distance(geog, 'POINT(0 0)'::GEOGRAPHY, false) = 0;

-- Test 324: query (line 6122)
SELECT tag FROM t103616@geog_idx
WHERE
    st_distance(geog, 'POINT(0 0)'::GEOGRAPHY, false) = 0;

-- Test 325: query (line 6130)
SELECT tag FROM t103616@geog_idx
WHERE
    NOT 1.2345678901234566e-43 < st_distance(geog, 'POINT(0 0)'::GEOGRAPHY);

-- Test 326: query (line 6138)
SELECT tag FROM t103616
WHERE
    NOT 1.2345678901234566e-43 > st_distance(geog, 'POINT(0 0)'::GEOGRAPHY);

-- Test 327: query (line 6146)
SELECT tag FROM t103616@geog_idx
WHERE
    1.2345678901234566e-43 > st_distance(geog, 'POINT(0 0)'::GEOGRAPHY);

-- Test 328: query (line 6154)
SELECT tag FROM t103616
WHERE
    1.2345678901234566e-43 < st_distance(geog, 'POINT(0 0)'::GEOGRAPHY);

-- Test 329: query (line 6162)
SELECT tag FROM t103616
WHERE
    0 <= st_distance(geog, 'POINT(0 0)'::GEOGRAPHY);

-- Test 330: query (line 6171)
SELECT tag FROM t103616
WHERE
    (st_distance(geog, 'POINT(0 0)'::GEOGRAPHY, false) = 0) IS NULL;

-- Test 331: query (line 6181)
SELECT tag FROM t103616
WHERE
    (0 <= st_distance(geog, 'POINT(0 0)'::GEOGRAPHY)) IS NULL;

-- Test 332: query (line 6191)
SELECT tag FROM t103616@geom_idx
WHERE
    NOT 1.2345678901234566e-43 < st_maxdistance(geom, 'POINT(0 0)'::GEOMETRY);

-- Test 333: query (line 6199)
SELECT tag FROM t103616
WHERE
    NOT 1.2345678901234566e-43 > st_maxdistance(geom, 'POINT(0 0)'::GEOMETRY);

-- Test 334: query (line 6207)
SELECT tag FROM t103616@geom_idx
WHERE
    1.2345678901234566e-43 > st_maxdistance(geom, 'POINT(0 0)'::GEOMETRY);

-- Test 335: query (line 6215)
SELECT tag FROM t103616
WHERE
    1.2345678901234566e-43 < st_maxdistance(geom, 'POINT(0 0)'::GEOMETRY);

-- Test 336: query (line 6223)
SELECT tag FROM t103616
WHERE
    0 <= st_maxdistance(geom, 'POINT(0 0)'::GEOMETRY);

-- Test 337: query (line 6232)
SELECT tag FROM t103616
WHERE
    (0 <= st_maxdistance(geom, 'POINT(0 0)'::GEOMETRY)) IS NULL;

-- Test 338: statement (line 6248)
CREATE TABLE t111556_in (g GEOMETRY NOT NULL);
CREATE TABLE t111556_res (g GEOMETRY);

-- Test 339: statement (line 6253)
INSERT INTO t111556_in(g)
SELECT '0103000000010000000500000000000000000000000000000000000000000000000000F03F0000000000000000000000000000F03F000000000000F03F0000000000000000000000000000F03F00000000000000000000000000000000'
FROM generate_series(1, 2);

-- Test 340: statement (line 6259)
INSERT INTO t111556_res
SELECT st_union(t2.g) FROM t111556_in t1 JOIN t111556_in t2 ON t1.g = t2.g;

-- Test 341: statement (line 6264)
SET testing_optimizer_disable_rule_probability = 1.0;

-- Test 342: statement (line 6268)
INSERT INTO t111556_res
SELECT st_union(t2.g) FROM t111556_in t1 JOIN t111556_in t2 ON t1.g = t2.g;

-- Test 343: query (line 6274)
SELECT count(DISTINCT g) FROM t111556_res;

-- Test 344: statement (line 6279)
SET testing_optimizer_disable_rule_probability = 0;

-- Test 345: query (line 6288)
SELECT ST_Extent(ST_GeomFromGeoHash('C'::TEXT, NULL::INT4)::GEOMETRY);

-- Test 346: query (line 6293)
SELECT ST_Extent(ST_GeomFromGeoHash(NULL::TEXT, 1::INT4)::GEOMETRY);

-- Test 347: query (line 6298)
SELECT ST_Extent(ST_PointFromGeoHash('C'::TEXT, NULL::INT4)::GEOMETRY);

-- Test 348: query (line 6303)
SELECT ST_Extent(ST_PointFromGeoHash(NULL::TEXT, 1::INT4)::GEOMETRY);

-- Test 349: query (line 6309)
SELECT ST_AsEWKT(ST_MakeEnvelope(8.0::FLOAT8, 2.0::FLOAT8, 5.0::FLOAT8, 4.0::FLOAT8)::GEOMETRY);

-- Test 350: query (line 6315)
SELECT ST_AsEWKT(ST_MakeEnvelope(5.0::FLOAT8, 4.0::FLOAT8, 8.0::FLOAT8, 2.0::FLOAT8)::GEOMETRY);

-- Test 351: query (line 6324)
SELECT ST_TileEnvelope(NULL, NULL, NULL);

-- Test 352: query (line 6329)
SELECT ST_AsText(ST_TileEnvelope(8, 1, 2));

-- Test 353: query (line 6334)
SELECT ST_TileEnvelope(8, 1, 2, NULL);

-- Test 354: query (line 6339)
SELECT ST_AsText(ST_TileEnvelope(3, 1, 1, ST_MakeEnvelope(-180, -90, 180, 90, 4326)) );

-- Test 355: query (line 6344)
SELECT ST_TileEnvelope(3, 1, 1, ST_MakeEnvelope(-180, -90, 180, 90, 4326), NULL);

-- Test 356: query (line 6349)
SELECT ST_AsText(ST_TileEnvelope(3, 1, 1, ST_MakeEnvelope(-180, -90, 180, 90, 4326), 0.125));

-- Test 357: statement (line 6354)
SELECT st_tileenvelope(0, 0, 0, '010500000000000000');

-- Test 358: query (line 6361)
SELECT st_asgeojson(tbl.*, 'g', 4)::JSONB->'geometry'->'coordinates'
  FROM (VALUES ('SRID=4326;POINT (-123.45678901234 12.3456789012)'::GEOMETRY)) tbl(g);

-- Test 359: query (line 6371)
SELECT '{0101000020e6100000cdcccccccc4c1b40cdcccccccc8c4740:0101000020e6100000333333333333fd3fcdcccccccc0c4640}'::geometry[];

-- Test 360: query (line 6376)
SELECT '{0101000020e6100000cdcccccccc4c1b40cdcccccccc8c4740:0101000020e6100000333333333333fd3fcdcccccccc0c4640}'::geography[];

-- Test 361: query (line 6385)
SELECT st_snap('01010000C0000000000000F87F000000000000F87F000000000000F87F000000000000F87F'::GEOMETRY, '01010000C0000000000000F87F000000000000F87F000000000000F87F000000000000F87F'::GEOMETRY, 0.5::FLOAT8);
