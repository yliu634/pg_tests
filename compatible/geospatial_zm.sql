-- PostgreSQL compatible tests from geospatial_zm
-- 57 tests

-- Test 1: statement (line 3)
CREATE TABLE geom_all(geom geometry)

-- Test 2: statement (line 6)
INSERT INTO geom_all VALUES('point(1 2)')

-- Test 3: statement (line 9)
INSERT INTO geom_all VALUES ('pointm(1 2 3)')

-- Test 4: statement (line 12)
INSERT INTO geom_all VALUES ('pointz(1 2 3)')

-- Test 5: statement (line 15)
INSERT INTO geom_all VALUES ('pointzm(1 2 3 4)')

-- Test 6: statement (line 19)
CREATE TABLE geom_2d(geom geometry(geometry))

-- Test 7: statement (line 22)
INSERT INTO geom_2d VALUES('point(1 2)')

-- Test 8: statement (line 25)
INSERT INTO geom_2d VALUES ('pointm(1 2 3)')

-- Test 9: statement (line 28)
INSERT INTO geom_2d VALUES ('pointz(1 2 3)')

-- Test 10: statement (line 31)
INSERT INTO geom_2d VALUES ('pointzm(1 2 3 4)')

-- Test 11: statement (line 35)
CREATE TABLE geom_2d_m(geomm geometry(geometrym))

-- Test 12: statement (line 38)
INSERT INTO geom_2d_m VALUES ('pointm(1 2 3)')

-- Test 13: statement (line 41)
INSERT INTO geom_2d_m VALUES ('point(1 2)')

-- Test 14: statement (line 44)
INSERT INTO geom_2d_m VALUES ('pointz(1 2 3)')

-- Test 15: statement (line 47)
INSERT INTO geom_2d_m VALUES ('pointzm(1 2 3 4)')

-- Test 16: statement (line 51)
CREATE TABLE geom_3d(geomz geometry(geometryz))

-- Test 17: statement (line 54)
INSERT INTO geom_3d VALUES ('pointz(1 2 3)')

-- Test 18: statement (line 57)
INSERT INTO geom_3d VALUES ('point(1 2 3)')

-- Test 19: statement (line 60)
INSERT INTO geom_3d VALUES ('point(1 2)')

-- Test 20: statement (line 63)
INSERT INTO geom_3d VALUES ('pointm(1 2 3)')

-- Test 21: statement (line 66)
INSERT INTO geom_3d VALUES ('pointzm(1 2 3 4)')

-- Test 22: statement (line 70)
CREATE TABLE geom_4d(geomzm geometry(geometryzm))

-- Test 23: statement (line 73)
INSERT INTO geom_4d VALUES ('pointzm(1 2 3 4)')

-- Test 24: statement (line 76)
INSERT INTO geom_4d VALUES ('point(1 2 3 4)')

-- Test 25: statement (line 79)
INSERT INTO geom_4d VALUES ('pointm(1 2 3)')

-- Test 26: statement (line 82)
INSERT INTO geom_4d VALUES ('point(1 2)')

-- Test 27: statement (line 85)
INSERT INTO geom_4d VALUES ('pointz(1 2 3)')

-- Test 28: query (line 89)
SELECT st_astext(point) FROM
( VALUES
  (st_point(1, 2)),
  (st_makepoint(1, 2)),
  (st_makepoint(1, 2, 3)),
  (st_makepoint(1, 2, 3, 4)),
  (st_makepointm(1, 2, 3))
) AS t(point)

-- Test 29: query (line 105)
SELECT ST_AsEWKT(ST_Affine(the_geom, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, pi()/2, pi()), 3)
	FROM (SELECT ST_GeomFromEWKT('LINESTRING(1 2 3, 4 5 6, 7 8 9)') AS the_geom) AS _;

-- Test 30: query (line 112)
SELECT
  st_x(a.geom),
  st_y(a.geom),
  st_z(a.geom),
  st_m(a.geom),
  st_zmflag(a.geom)
FROM (VALUES
  (NULL::geometry),
  ('POINT EMPTY'::geometry),
  ('POINT M EMPTY'::geometry),
  ('POINT Z EMPTY'::geometry),
  ('POINT ZM EMPTY'::geometry),
  ('POINT(1 2)'::geometry),
  ('POINT M (1 2 3)'::geometry),
  ('POINT(1 2 3)'::geometry),
  ('POINT(1 2 3 4)'::geometry)
) a(geom)

-- Test 31: statement (line 141)
SELECT st_z('LINESTRING(0 0 0, 1 1 1)')

-- Test 32: statement (line 144)
SELECT st_m('LINESTRING M (0 0 0, 1 1 1)')

-- Test 33: query (line 148)
SELECT
  ST_Zmflag(a.geom)
FROM (VALUES
  ('GEOMETRYCOLLECTION EMPTY'::geometry),
  ('GEOMETRYCOLLECTION M EMPTY'::geometry),
  ('GEOMETRYCOLLECTION Z EMPTY'::geometry),
  ('GEOMETRYCOLLECTION ZM EMPTY'::geometry)
) a(geom)

-- Test 34: query (line 165)
SELECT
  ST_AsText(geom) d,
  ST_AsText(ST_Translate(geom, 1, 1, 1))
FROM
( VALUES
  ('POINT(1.0 1.0 1.0)'::geometry),
  ('MULTIPOINT (1 1 1, 2 2 2)'::geometry),
  ('LINESTRING (1 1 1, 2 2 2)'::geometry),
  ('MULTILINESTRING ((1 1 1, 2 2 2), (3 3 3, 4 4 4))'::geometry),
  ('POLYGON ((0 0 0, 1 0 0, 1 1 0, 0 0 0))'::geometry)
) AS t(geom)
ORDER BY d ASC

-- Test 35: query (line 186)
SELECT st_astext(st_force2d(geom)) FROM
( VALUES
  ('POINT(1 2)'::geometry),
  ('POINT M (1 2 3)'::geometry),
  ('POINT(1 2 3)'::geometry),
  ('POINT(1 2 3 4)'::geometry),
  ('POINT M EMPTY'::geometry),
  ('GEOMETRYCOLLECTION Z EMPTY'::geometry)
) AS t(geom)

-- Test 36: query (line 204)
SELECT st_astext(st_force3d(geom)) FROM
( VALUES
  ('POINT(1 2)'::geometry),
  ('POINT M (1 2 3)'::geometry),
  ('POINT(1 2 3)'::geometry),
  ('POINT(1 2 3 4)'::geometry),
  ('GEOMETRYCOLLECTION(POINT(1 2))'::geometry)
) AS t(geom)

-- Test 37: query (line 220)
SELECT st_astext(st_force3dz(geom, 7)) FROM
( VALUES
  ('POINT(1 2)'::geometry),
  ('POINT M (1 2 3)'::geometry),
  ('POINT(1 2 3)'::geometry),
  ('POINT(1 2 3 4)'::geometry),
  ('GEOMETRYCOLLECTION(LINESTRING(1 2, 3 4))'::geometry)
) AS t(geom)

-- Test 38: query (line 236)
SELECT st_astext(st_force3dm(geom)) FROM
( VALUES
  ('POINT(1 2)'::geometry),
  ('POINT M (1 2 3)'::geometry),
  ('POINT(1 2 3)'::geometry),
  ('POINT(1 2 3 4)'::geometry),
  ('GEOMETRYCOLLECTION(MULTIPOINT((1 2 3), (4 5 6)))'::geometry)
) AS t(geom)

-- Test 39: query (line 252)
SELECT st_astext(st_force3dm(geom, 7)) FROM
( VALUES
  ('POINT(1 2)'::geometry),
  ('POINT M (1 2 3)'::geometry),
  ('POINT(1 2 3)'::geometry),
  ('POINT(1 2 3 4)'::geometry)
) AS t(geom)

-- Test 40: query (line 266)
SELECT st_astext(st_force4d(geom)) FROM
( VALUES
  ('POINT(1 2)'::geometry),
  ('POINT M (1 2 3)'::geometry),
  ('POINT(1 2 3)'::geometry),
  ('POINT(1 2 3 4)'::geometry),
  ('POLYGON((1 2, 5 5, 0 8, 1 2))'::geometry)
) AS t(geom)

-- Test 41: query (line 282)
SELECT st_astext(st_force4d(geom, 7)) FROM
( VALUES
  ('POINT(1 2)'::geometry),
  ('POINT M (1 2 3)'::geometry),
  ('POINT(1 2 3)'::geometry),
  ('POINT(1 2 3 4)'::geometry)
) AS t(geom)

-- Test 42: query (line 296)
SELECT st_astext(st_force4d(geom, 7, 17)) FROM
( VALUES
  ('POINT(1 2)'::geometry),
  ('POINT M (1 2 3)'::geometry),
  ('POINT(1 2 3)'::geometry),
  ('POINT(1 2 3 4)'::geometry),
  ('GEOMETRYCOLLECTION(POINT EMPTY, LINESTRING(1 2, 3 4))'::geometry)
) AS t(geom)

-- Test 43: query (line 312)
SELECT st_astext(st_addmeasure(geom, 0, 10)) FROM
( VALUES
  ('LINESTRING(0 0, 1 1, 2 2)'::geometry),
  ('MULTILINESTRING((0 0, 1 1, 2 2), EMPTY)'::geometry)
) AS t(geom)

-- Test 44: statement (line 322)
SELECT st_astext(st_addmeasure('POINT(0 0)'::geometry, 0, 1))

-- Test 45: query (line 325)
SELECT distinct(st_astext(geom)) FROM
( VALUES
  (st_snaptogrid('LINESTRING(0 0, 1 1, 2 2, 3 3, 4 4)'::geometry, 2, 1)),
  (st_snaptogrid('LINESTRING(0 0, 1 1, 2 2, 3 3, 4 4)'::geometry, 0, 0, 2, 1)),
  (st_snaptogrid('LINESTRING(0 0, 1 1, 2 2, 3 3, 4 4)'::geometry, 'POINT EMPTY'::geometry, 2, 1, 0, 0)),
  (st_snaptogrid('LINESTRING(0 0, 1 1, 2 2, 3 3, 4 4)'::geometry, 'POINT EMPTY'::geometry, 2, 1, 2, 1)),
  (st_snaptogrid('LINESTRING(0 0, 1 1, 2 2, 3 3, 4 4)'::geometry, 'POINT(0 0)'::geometry, 2, 1, 0, 0)),
  (st_snaptogrid('LINESTRING(0 0, 1 1, 2 2, 3 3, 4 4)'::geometry, 'POINT(0 0 4 5)'::geometry, 2, 1, 2, 1))
) AS t(geom)

-- Test 46: query (line 338)
SELECT distinct(st_astext(geom)) FROM
( VALUES
  (st_snaptogrid('MULTIPOINT(0 0 0, 7 5 5, 6 6 7)'::geometry, 2)),
  (st_snaptogrid('MULTIPOINT(0 0 0, 7 5 5, 6 6 7)'::geometry, 2, 2)),
  (st_snaptogrid('MULTIPOINT(0 0 0, 7 5 5, 6 6 7)'::geometry, 0, 0, 2, 2)),
  (st_snaptogrid('MULTIPOINT(0 0 0, 7 5 5, 6 6 7)'::geometry, 'POINT EMPTY'::geometry, 2, 2, 0, 0)),
  (st_snaptogrid('MULTIPOINT(0 0 0, 7 5 5, 6 6 7)'::geometry, 'POINT(0 0)'::geometry, 2, 2, 0, 0)),
  (st_snaptogrid('MULTIPOINT(0 0 0, 7 5 5, 6 6 7)'::geometry, 'POINT(0 0 0 0)'::geometry, 2, 2, 0, 0)),
  (st_snaptogrid('MULTIPOINT(0 0 0, 7 5 5, 6 6 7)'::geometry, 'POINT(0 0 3 2)'::geometry, 2, 2, 0, 0))
) AS t(geom)

-- Test 47: query (line 352)
SELECT st_astext(st_snaptogrid(geom, 'POINT(2 2)'::geometry, 2, 3, 5, 4)) FROM
( VALUES
  ('POINT(2 1)'::geometry),
  ('LINESTRING(2 1 7 2, 5 6 3 7)'::geometry),
  ('POLYGON((2 3 1, 3 4 1, 1 3 6, 2 3 1))'::geometry)
) AS t(geom)

-- Test 48: statement (line 364)
SELECT st_snaptogrid('POINT(0 0 0)'::geometry, 'LINESTRING(0 0 0, 1 1 1)'::geometry, 1, 1, 1, 1)

-- Test 49: query (line 367)
SELECT ST_AsEWKT(ST_RotateX(ST_GeomFromEWKT('LINESTRING(1 2 3, 1 1 1)'), pi()/2));

-- Test 50: query (line 372)
SELECT ST_AsEWKT(ST_RotateY(ST_GeomFromEWKT('LINESTRING(1 2 3, 1 1 1)'), pi()/2));

-- Test 51: query (line 377)
SELECT ST_AsEWKT(ST_RotateZ(ST_GeomFromEWKT('LINESTRING(1 2 3, 1 1 1)'), pi()/2));

-- Test 52: query (line 382)
SELECT st_length('LINESTRING M(0 0 -25, 1 1 -50, 2 2 0)')

-- Test 53: query (line 387)
SELECT ST_3DLength('LINESTRING(743238 2967416 1,743238 2967450 1,743265 2967450 3, 743265.625 2967416 3,743238 2967416 3)')

-- Test 54: query (line 392)
SELECT ST_3DLength('010200008000000000':::GEOMETRY);

-- Test 55: query (line 397)
SELECT ST_3DLength('01020000C000000000':::GEOMETRY);

-- Test 56: query (line 402)
SELECT
  encode(ST_AsTWKB(t, 5), 'hex'),
  encode(ST_AsTWKB(t, 5, 3), 'hex'),
  encode(ST_AsTWKB(t, 5, 3, 4), 'hex')
FROM ( VALUES
  ('POINT(2 1)'::geometry),
  ('LINESTRING(2 1 7 2, 5 6 3 7)'::geometry),
  ('POLYGON((2 3 1, 3 4 1, 1 3 6, 2 3 1))'::geometry)
) AS t(t)

-- Test 57: statement (line 419)
CREATE TABLE t106884 AS SELECT 1;
SELECT st_asmvtgeom(
          '01060000C000000000'::GEOMETRY,
          'BOX(-2.4310452547766257 -0.7340617188515679,1.4606149586106913 1.509111744681483)'::BOX2D,
          1::INT4
        )::GEOMETRY
        FROM t106884;

