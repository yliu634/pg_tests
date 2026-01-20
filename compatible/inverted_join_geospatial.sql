-- PostgreSQL compatible tests from inverted_join_geospatial
-- 42 tests

-- Test 1: statement (line 3)
CREATE TABLE ltable(
  lk int primary key,
  geom1 geometry,
  geom2 geometry
)

-- Test 2: statement (line 10)
INSERT INTO ltable VALUES
  (1, 'POINT(3.0 3.0)', 'POINT(3.0 3.0)'),
  (2, 'POINT(4.5 4.5)', 'POINT(3.0 3.0)'),
  (3, 'POINT(1.5 1.5)', 'POINT(3.0 3.0)'),
  (4, NULL, 'POINT(3.0 3.0)'),
  (5, 'POINT(1.5 1.5)', NULL),
  (6, NULL, NULL)

-- Test 3: statement (line 19)
CREATE TABLE rtable(
  rk int primary key,
  geom geometry,
  INVERTED INDEX geom_index(geom)
)

-- Test 4: statement (line 26)
INSERT INTO rtable VALUES
  (11, 'POINT(1.0 1.0)'),
  (12, 'LINESTRING(1.0 1.0, 2.0 2.0)'),
  (13, 'POINT(3.0 3.0)'),
  (14, 'LINESTRING(4.0 4.0, 5.0 5.0)'),
  (15, 'LINESTRING(40.0 40.0, 41.0 41.0)'),
  (16, 'POLYGON((1.0 1.0, 5.0 1.0, 5.0 5.0, 1.0 5.0, 1.0 1.0))')

-- Test 5: query (line 35)
SELECT lk, rk FROM ltable JOIN rtable@geom_index ON ST_Intersects(ltable.geom1, rtable.geom) ORDER BY (lk, rk)

-- Test 6: query (line 47)
SELECT lk, rk FROM ltable JOIN rtable@geom_index ON ST_DWithin(ltable.geom1, rtable.geom, 2) ORDER BY (lk, rk)

-- Test 7: query (line 63)
SELECT lk, rk FROM ltable JOIN rtable@geom_index
ON ST_Intersects(rtable.geom, ltable.geom1) OR ST_DWithin(ltable.geom1, rtable.geom, 2) ORDER BY (lk, rk)

-- Test 8: query (line 80)
SELECT lk, rk FROM ltable JOIN rtable@geom_index
ON ST_Intersects(ltable.geom1, rtable.geom) AND ST_DWithin(rtable.geom, ltable.geom1, 2) ORDER BY (lk, rk)

-- Test 9: query (line 93)
SELECT lk, rk FROM ltable JOIN rtable@geom_index
ON ST_Intersects(ltable.geom1, rtable.geom) AND ST_DWithin(rtable.geom, ltable.geom2, 2) ORDER BY (lk, rk)

-- Test 10: query (line 104)
SELECT lk, rk FROM ltable JOIN rtable@geom_index
ON ST_Intersects(ltable.geom1, rtable.geom) OR ST_DWithin(rtable.geom, ltable.geom2, 2) ORDER BY (lk, rk)

-- Test 11: query (line 129)
SELECT lk, rk FROM ltable JOIN rtable@rtable_pkey
ON ST_Intersects(ltable.geom1, rtable.geom) AND ST_DWithin(rtable.geom, ltable.geom2, 2) ORDER BY (lk, rk)

-- Test 12: query (line 140)
SELECT lk, rk FROM ltable JOIN rtable@rtable_pkey
ON ST_Intersects(ltable.geom1, rtable.geom) OR ST_DWithin(rtable.geom, ltable.geom2, 2) ORDER BY (lk, rk)

-- Test 13: query (line 163)
SELECT ltable.lk, rtable.rk FROM ltable JOIN rtable@geom_index
ON ST_Intersects(ltable.geom1, rtable.geom) AND ST_Covers(ltable.geom2, rtable.geom)
AND (ST_DFullyWithin(rtable.geom, ltable.geom1, 100) OR ST_Intersects('POINT(1.0 1.0)', rtable.geom))

-- Test 14: query (line 172)
SELECT lk FROM ltable WHERE EXISTS (SELECT * FROM rtable WHERE ST_Intersects(ltable.geom2, rtable.geom))
ORDER BY lk

-- Test 15: query (line 181)
SELECT rk FROM rtable WHERE EXISTS (SELECT * FROM ltable WHERE ST_Intersects(ltable.geom2, rtable.geom))
ORDER BY rk

-- Test 16: query (line 189)
SELECT lk, rk FROM ltable LEFT JOIN rtable@geom_index ON ST_Intersects(ltable.geom1, rtable.geom) ORDER BY (lk, rk)

-- Test 17: query (line 203)
SELECT lk, rk FROM ltable LEFT JOIN rtable@geom_index ON ST_DWithin(ltable.geom1, rtable.geom, 2) ORDER BY (lk, rk)

-- Test 18: query (line 221)
SELECT lk, rk FROM ltable LEFT JOIN rtable@geom_index
ON ST_Intersects(rtable.geom, ltable.geom1) OR ST_DWithin(ltable.geom1, rtable.geom, 2) ORDER BY (lk, rk)

-- Test 19: query (line 240)
SELECT lk, rk FROM ltable LEFT JOIN rtable@geom_index
ON ST_Intersects(ltable.geom1, rtable.geom) AND ST_DWithin(rtable.geom, ltable.geom1, 2) ORDER BY (lk, rk)

-- Test 20: query (line 255)
SELECT lk, rk FROM ltable LEFT JOIN rtable@geom_index
ON ST_Intersects(ltable.geom1, rtable.geom) AND ST_DWithin(rtable.geom, ltable.geom2, 2) ORDER BY (lk, rk)

-- Test 21: query (line 269)
SELECT lk, rk FROM ltable LEFT JOIN rtable@geom_index
ON ST_Intersects(ltable.geom1, rtable.geom) OR ST_DWithin(rtable.geom, ltable.geom2, 2) ORDER BY (lk, rk)

-- Test 22: query (line 293)
WITH q AS (
  SELECT * FROM ltable WHERE lk > 2
)
SELECT lk, count(*), (SELECT count(*) FROM q) FROM (
  SELECT lk, rk
  FROM q
  LEFT JOIN rtable@geom_index ON ST_Intersects(q.geom1, rtable.geom)
) GROUP BY lk ORDER BY lk

-- Test 23: query (line 309)
SELECT lk FROM ltable WHERE NOT EXISTS (SELECT * FROM rtable@geom_index WHERE ST_Intersects(ltable.geom2, rtable.geom))
ORDER BY lk

-- Test 24: query (line 316)
SELECT rk FROM rtable WHERE NOT EXISTS (SELECT * FROM ltable WHERE ST_Intersects(ltable.geom2, rtable.geom))
ORDER BY rk

-- Test 25: query (line 325)
SELECT lk FROM ltable
WHERE NOT EXISTS (
  SELECT * FROM rtable@geom_index WHERE ST_Covers(ltable.geom2, rtable.geom) AND lk > 1 AND rk > 12
) ORDER BY lk

-- Test 26: statement (line 337)
CREATE TABLE rtable2(
  rk1 int,
  geom geometry,
  rk2 int,
  primary key (rk1, rk2),
  INVERTED INDEX geom_index(geom)
)

-- Test 27: statement (line 346)
INSERT INTO rtable2 VALUES
  (11, 'POINT(1.0 1.0)', 22),
  (12, 'LINESTRING(1.0 1.0, 2.0 2.0)', 24),
  (13, 'POINT(3.0 3.0)', 26),
  (14, 'LINESTRING(4.0 4.0, 5.0 5.0)', 28),
  (15, 'LINESTRING(40.0 40.0, 41.0 41.0)', 30),
  (16, 'POLYGON((1.0 1.0, 5.0 1.0, 5.0 5.0, 1.0 5.0, 1.0 1.0))', 32)

-- Test 28: query (line 355)
SELECT lk, rk1, rk2 FROM ltable JOIN rtable2@geom_index ON ST_Intersects(ltable.geom1, rtable2.geom) ORDER BY (lk, rk1, rk2)

-- Test 29: query (line 367)
SELECT lk, rk1, rk2 FROM ltable LEFT JOIN rtable2@geom_index
ON ST_Intersects(ltable.geom1, rtable2.geom) ORDER BY (lk, rk1, rk2)

-- Test 30: query (line 382)
SELECT lk FROM ltable WHERE EXISTS (SELECT * FROM rtable2@geom_index
WHERE ST_Intersects(ltable.geom1, rtable2.geom)) ORDER BY lk

-- Test 31: query (line 391)
SELECT lk FROM ltable WHERE NOT EXISTS (SELECT * FROM rtable2@geom_index
WHERE ST_Intersects(ltable.geom1, rtable2.geom)) ORDER BY lk

-- Test 32: statement (line 398)
CREATE TABLE g (
  k INT PRIMARY KEY,
  geom GEOMETRY
)

-- Test 33: statement (line 404)
CREATE INVERTED INDEX foo_inv ON g(geom)

-- Test 34: statement (line 407)
INSERT INTO g VALUES
  (1, ST_MakePolygon('LINESTRING(0 0, 0 15, 15 15, 15 0, 0 0)'::geometry)),
  (2, ST_MakePolygon('LINESTRING(0 0, 0 2, 2 2, 2 0, 0 0)'::geometry))

-- Test 35: query (line 413)
SELECT g1.k, g2.k FROM g@foo_inv AS g1, g@g_pkey AS g2 WHERE ST_Contains(g1.geom, g2.geom) ORDER BY g1.k, g2.k

-- Test 36: query (line 421)
SELECT g1.k, g2.k FROM g@g_pkey AS g1, g@g_pkey AS g2 WHERE ST_Contains(g1.geom, g2.geom) ORDER BY g1.k, g2.k

-- Test 37: query (line 430)
SELECT * FROM
(SELECT g1.k, g2.k FROM g@foo_inv AS g1, g@g_pkey AS g2 WHERE ST_Contains(g1.geom, g2.geom)) AS inv_join(k1, k2)
FULL OUTER JOIN
(SELECT g1.k, g2.k FROM g@g_pkey AS g1, g@g_pkey AS g2 WHERE ST_Contains(g1.geom, g2.geom)) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL

-- Test 38: query (line 441)
SELECT g1.k, g2.k FROM g@foo_inv AS g1, g@g_pkey AS g2
WHERE ST_Contains(g1.geom, g2.geom)
  AND ST_Contains(g1.geom, ST_MakePolygon('LINESTRING(0 0, 0 5, 5 5, 5 0, 0 0)'::geometry))
  AND g2.k < 20
ORDER BY g1.k, g2.k

-- Test 39: query (line 452)
SELECT g1.k, g2.k FROM g@g_pkey AS g1, g@g_pkey AS g2
WHERE ST_Contains(g1.geom, g2.geom)
  AND ST_Contains(g1.geom, ST_MakePolygon('LINESTRING(0 0, 0 5, 5 5, 5 0, 0 0)'::geometry))
  AND g2.k < 20
ORDER BY g1.k, g2.k

-- Test 40: query (line 464)
SELECT * FROM
(
  SELECT g1.k, g2.k FROM g@foo_inv AS g1, g@g_pkey AS g2
  WHERE ST_Contains(g1.geom, g2.geom)
  AND ST_Contains(g1.geom, ST_MakePolygon('LINESTRING(0 0, 0 5, 5 5, 5 0, 0 0)'::geometry))
  AND g2.k < 20
) AS inv_join(k1, k2)
FULL OUTER JOIN
(
  SELECT g1.k, g2.k FROM g@g_pkey AS g1, g@g_pkey AS g2
  WHERE ST_Contains(g1.geom, g2.geom)
  AND ST_Contains(g1.geom, ST_MakePolygon('LINESTRING(0 0, 0 5, 5 5, 5 0, 0 0)'::geometry))
  AND g2.k < 20
) AS cross_join(k1, k2)
ON inv_join.k1 = cross_join.k1 AND inv_join.k2 = cross_join.k2
WHERE inv_join.k1 IS NULL OR cross_join.k1 IS NULL

-- Test 41: statement (line 485)
CREATE TABLE t62686 (
  c GEOMETRY,
  INVERTED INDEX (c ASC)
);
INSERT INTO t62686 VALUES (ST_GeomFromText('POINT(1 1)'));

-- Test 42: statement (line 492)
SELECT * FROM t62686 t1 JOIN t62686 t2 ON ST_DFullyWithin(t1.c, t2.c, NULL::FLOAT8)

