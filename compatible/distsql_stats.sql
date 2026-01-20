-- PostgreSQL compatible tests from distsql_stats
-- 423 tests

-- Test 1: statement (line 6)
SET CLUSTER SETTING jobs.registry.interval.adopt = '10ms'

-- Test 2: statement (line 10)
SET CLUSTER SETTING sql.stats.histogram_collection.enabled = false

-- Test 3: statement (line 13)
CREATE TABLE data (a INT, b INT, c FLOAT, d DECIMAL, e BOOL, PRIMARY KEY (a, b, c, d), INDEX c_idx (c, d))

let $t_id
SELECT id FROM system.namespace WHERE name='data'

-- Test 4: statement (line 30)
INSERT INTO data SELECT a, b, c::FLOAT, d::DECIMAL, (a+b+c+d) % 2 = 0 FROM
   generate_series(1, 4) AS a(a),
   generate_series(1, 4) AS b(b),
   generate_series(1, 4) AS c(c),
   generate_series(1, 4) AS d(d)

-- Test 5: statement (line 54)
SET CLUSTER SETTING feature.stats.enabled = FALSE

-- Test 6: statement (line 57)
CREATE STATISTICS s1 ON a FROM data

-- Test 7: statement (line 60)
ANALYZE data

-- Test 8: statement (line 63)
SET CLUSTER SETTING feature.stats.enabled = TRUE

-- Test 9: statement (line 66)
CREATE STATISTICS s1 ON a FROM data

-- Test 10: query (line 69)
SELECT statistics_name, column_names, row_count, distinct_count, null_count, histogram_id
FROM [SHOW STATISTICS FOR TABLE data]

-- Test 11: statement (line 76)
SET CLUSTER SETTING sql.stats.histogram_collection.enabled = true

-- Test 12: statement (line 79)
CREATE STATISTICS s1 ON a FROM data

-- Test 13: query (line 82)
SELECT
	statistics_name,
	column_names,
	row_count,
	distinct_count,
	null_count,
	histogram_id IS NOT NULL AS has_histogram
FROM
	[SHOW STATISTICS FOR TABLE data];

-- Test 14: query (line 99)
SHOW HISTOGRAM $hist_id_1

-- Test 15: statement (line 108)
CREATE STATISTICS "" ON b FROM data

-- Test 16: statement (line 132)
SET CLUSTER SETTING sql.stats.histogram_buckets.count = 2

-- Test 17: statement (line 135)
CREATE STATISTICS s2 ON a FROM data

let $hist_id_2
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE data] WHERE statistics_name = 's2'

-- Test 18: query (line 141)
SHOW HISTOGRAM $hist_id_2

-- Test 19: statement (line 149)
ALTER TABLE data SET (sql_stats_histogram_buckets_count = 3)

-- Test 20: statement (line 152)
CREATE STATISTICS s3 ON a FROM data

let $hist_id_3
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE data] WHERE statistics_name = 's3'

-- Test 21: query (line 158)
SHOW HISTOGRAM $hist_id_3

-- Test 22: statement (line 166)
ALTER TABLE data RESET (sql_stats_histogram_buckets_count)

-- Test 23: statement (line 172)
RESET CLUSTER SETTING sql.stats.histogram_samples.count

-- Test 24: statement (line 177)
SET CLUSTER SETTING sql.stats.histogram_buckets.count = 20000

-- Test 25: statement (line 180)
CREATE TABLE big (i INT PRIMARY KEY);
INSERT INTO big SELECT generate_series(1, 20000)

-- Test 26: statement (line 184)
CREATE STATISTICS s_dynamic FROM big

let $hist_id_dynamic
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE big] WHERE statistics_name = 's_dynamic';

-- Test 27: query (line 194)
SELECT (count(*) // 10) * 10 FROM [SHOW HISTOGRAM $hist_id_dynamic]

-- Test 28: statement (line 199)
CREATE STATISTICS s_dynamic FROM big

let $hist_id_dynamic
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE big] WHERE statistics_name = 's_dynamic';

-- Test 29: query (line 209)
SELECT (count(*) // 10) * 10 FROM [SHOW HISTOGRAM $hist_id_dynamic]

-- Test 30: statement (line 216)
ALTER TABLE big INJECT STATISTICS '[
      {
          "columns": [
              "i"
          ],
          "created_at": "1988-08-05 00:00:00",
          "name": "injected_stats",
          "row_count": 100000
      }
]'

-- Test 31: statement (line 228)
CREATE STATISTICS s_injected FROM big

let $hist_id_injected
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE big] WHERE statistics_name = 's_injected';

-- Test 32: query (line 234)
SELECT (count(*) // 10) * 10 FROM [SHOW HISTOGRAM $hist_id_injected]

-- Test 33: statement (line 239)
ALTER TABLE big INJECT STATISTICS '[
      {
          "columns": [
              "i"
          ],
          "created_at": "2024-06-10 00:00:00",
          "name": "injected_stats",
          "row_count": 1000000000
      }
]'

-- Test 34: statement (line 251)
CREATE STATISTICS s_injected FROM big

let $hist_id_injected
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE big] WHERE statistics_name = 's_injected';

-- Test 35: query (line 257)
SELECT (count(*) // 10) * 10 FROM [SHOW HISTOGRAM $hist_id_injected]

-- Test 36: statement (line 265)
SET CLUSTER SETTING sql.stats.histogram_samples.min = 15000

-- Test 37: statement (line 268)
CREATE STATISTICS s_dynamic_min FROM big

let $hist_id_dynamic_min
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE big] WHERE statistics_name = 's_dynamic_min';

-- Test 38: query (line 276)
SELECT (count(*) // 10) * 10 FROM [SHOW HISTOGRAM $hist_id_dynamic_min]

-- Test 39: statement (line 281)
RESET CLUSTER SETTING sql.stats.histogram_samples.min

-- Test 40: statement (line 284)
SET CLUSTER SETTING sql.stats.histogram_samples.max = 10500

-- Test 41: statement (line 287)
CREATE STATISTICS s_dynamic_max FROM big

let $hist_id_dynamic_max
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE big] WHERE statistics_name = 's_dynamic_max';

-- Test 42: query (line 295)
SELECT (count(*) // 10) * 10 FROM [SHOW HISTOGRAM $hist_id_dynamic_max]

-- Test 43: statement (line 303)
SET CLUSTER SETTING sql.stats.histogram_samples.min = 11000

-- Test 44: statement (line 306)
CREATE STATISTICS s_dynamic_default_bounds FROM big

let $hist_id_dynamic_default_bounds
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE big] WHERE statistics_name = 's_dynamic_default_bounds';

-- Test 45: query (line 314)
SELECT (count(*) // 10) * 10 FROM [SHOW HISTOGRAM $hist_id_dynamic_default_bounds]

-- Test 46: statement (line 319)
RESET CLUSTER SETTING sql.stats.histogram_samples.min

-- Test 47: statement (line 322)
RESET CLUSTER SETTING sql.stats.histogram_samples.max

-- Test 48: statement (line 328)
SET CLUSTER SETTING sql.stats.histogram_samples.count = 20000

-- Test 49: statement (line 331)
CREATE STATISTICS s20000 FROM big

let $hist_id_20000
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE big] WHERE statistics_name = 's20000'

-- Test 50: query (line 337)
SELECT count(*) FROM [SHOW HISTOGRAM $hist_id_20000]

-- Test 51: statement (line 343)
ALTER TABLE big SET (sql_stats_histogram_samples_count = 500)

-- Test 52: statement (line 346)
CREATE STATISTICS s500 FROM big

let $hist_id_500
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE big] WHERE statistics_name = 's500'

-- Test 53: query (line 354)
SELECT (count(*) // 10) * 10 FROM [SHOW HISTOGRAM $hist_id_500]

-- Test 54: statement (line 359)
RESET CLUSTER SETTING sql.stats.histogram_buckets.count

-- Test 55: statement (line 362)
RESET CLUSTER SETTING sql.stats.histogram_samples.count

-- Test 56: statement (line 366)
ANALYZE data

-- Test 57: statement (line 392)
DELETE FROM system.table_statistics

-- Test 58: statement (line 396)
ALTER TABLE data INJECT STATISTICS '$json_stats'

-- Test 59: statement (line 416)
CREATE STATISTICS s3 ON c FROM data

-- Test 60: statement (line 429)
ALTER TABLE data INJECT STATISTICS '$json_stats'

-- Test 61: query (line 442)
ALTER TABLE data INJECT STATISTICS '[
    {
        "columns": ["z"],
        "created_at": "2018-05-01 1:00:00.00000+00:00",
        "row_count": 10,
        "distinct_count": 2
    },
    {
        "columns": ["a", "z"],
        "created_at": "2018-05-01 1:00:00.00000+00:00",
        "row_count": 10,
        "distinct_count": 2
    },
    {
        "columns": ["a"],
        "created_at": "2018-05-01 1:00:00.00000+00:00",
        "row_count": 10,
        "distinct_count": 2
    }
]'

-- Test 62: statement (line 479)
SET CLUSTER SETTING kv.gc_ttl.strict_enforcement.enabled = false

-- Test 63: statement (line 501)
SET CLUSTER SETTING sql.stats.multi_column_collection.enabled = false

-- Test 64: statement (line 504)
CREATE STATISTICS s3 FROM data

-- Test 65: statement (line 522)
SET CLUSTER SETTING sql.stats.multi_column_collection.enabled = true

-- Test 66: statement (line 526)
CREATE INDEX ON data (c DESC, b ASC); CREATE INDEX ON data (b DESC, a);

-- Test 67: statement (line 529)
CREATE STATISTICS s4 FROM data

-- Test 68: statement (line 551)
DROP INDEX data@c_idx; DROP INDEX data@data_c_b_idx

-- Test 69: statement (line 554)
CREATE STATISTICS s5 FROM [$t_id]

-- Test 70: statement (line 574)
CREATE TABLE simple (x INT, y INT)

-- Test 71: statement (line 577)
CREATE STATISTICS default_stat1 FROM simple

-- Test 72: statement (line 591)
INSERT INTO simple VALUES (DEFAULT, DEFAULT)

-- Test 73: statement (line 595)
CREATE UNIQUE INDEX ON simple (y) STORING (x)

-- Test 74: statement (line 598)
CREATE STATISTICS default_stat2 FROM simple

-- Test 75: statement (line 613)
INSERT INTO simple VALUES (DEFAULT, DEFAULT);
INSERT INTO simple VALUES (0, DEFAULT);
INSERT INTO simple VALUES (DEFAULT, 0);
INSERT INTO simple VALUES (0, 1);

-- Test 76: statement (line 620)
CREATE INDEX ON simple (x, y)

-- Test 77: statement (line 623)
CREATE STATISTICS default_stat3 FROM simple

-- Test 78: query (line 642)
SHOW HISTOGRAM $hist_id_3

-- Test 79: statement (line 653)
CREATE STATISTICS s6 ON a FROM [$t_id]

-- Test 80: statement (line 674)
CREATE STATISTICS __auto__ FROM [$t_id]

-- Test 81: statement (line 697)
DROP INDEX data@data_b_a_idx

-- Test 82: statement (line 700)
CREATE STATISTICS __auto__ FROM [$t_id];
CREATE STATISTICS __auto__ FROM [$t_id];
CREATE STATISTICS __auto__ FROM [$t_id];
CREATE STATISTICS __auto__ FROM [$t_id];
CREATE STATISTICS __auto__ FROM [$t_id];
CREATE STATISTICS __auto__ FROM [$t_id];

-- Test 83: statement (line 757)
CREATE STATISTICS s7 ON a FROM [$t_id]

-- Test 84: statement (line 808)
CREATE STATISTICS s8 ON a FROM [$t_id]

-- Test 85: statement (line 920)
SET CLUSTER SETTING sql.stats.non_default_columns.min_retention_period = '0s'

-- Test 86: statement (line 923)
CREATE STATISTICS s9 ON e FROM data;
ALTER TABLE data DROP COLUMN e

-- Test 87: statement (line 928)
CREATE STATISTICS s10 ON a FROM data

-- Test 88: query (line 976)
SELECT name
FROM system.table_statistics
  WHERE NOT EXISTS (
    SELECT * FROM crdb_internal.table_columns
    WHERE "tableID" = descriptor_id
    AND "columnIDs" @> array[column_id]
    AND descriptor_name = 'data'
  )
  AND EXISTS (
    SELECT * FROM crdb_internal.table_columns
    WHERE "tableID" = descriptor_id
    AND descriptor_name = 'data'
  )
  ORDER BY name

-- Test 89: statement (line 999)
ANALYZE data

-- Test 90: query (line 1003)
SELECT name
FROM system.table_statistics
  WHERE NOT EXISTS (
    SELECT * FROM crdb_internal.table_columns
    WHERE "tableID" = descriptor_id
    AND "columnIDs" @> array[column_id]
    AND descriptor_name = 'data'
  )
  AND EXISTS (
    SELECT * FROM crdb_internal.table_columns
    WHERE "tableID" = descriptor_id
    AND descriptor_name = 'data'
  )

-- Test 91: statement (line 1061)
RESET CLUSTER SETTING sql.stats.non_default_columns.min_retention_period

-- Test 92: statement (line 1065)
CREATE TABLE t (x int); INSERT INTO t VALUES (1); ALTER TABLE t DROP COLUMN x

-- Test 93: statement (line 1069)
CREATE STATISTICS s FROM t

-- Test 94: statement (line 1073)
CREATE TABLE arr (x INT[])

-- Test 95: statement (line 1076)
INSERT INTO arr VALUES (ARRAY[1,2]), (ARRAY[1,2]), (ARRAY[3,4]), (NULL)

-- Test 96: statement (line 1079)
CREATE STATISTICS arr_stats FROM arr

-- Test 97: statement (line 1092)
CREATE STATISTICS arr_stats_x ON x FROM arr

-- Test 98: statement (line 1111)
CREATE TYPE e AS ENUM ('hello', 'howdy', 'hi');

-- Test 99: statement (line 1114)
CREATE TABLE et (x e, y e, z e[], PRIMARY KEY (x), FAMILY (x, y, z));

-- Test 100: statement (line 1117)
INSERT INTO et VALUES ('hello', 'hello', '{hello}'), ('howdy', 'howdy', '{howdy}'), ('hi', 'hi', '{hi}');

-- Test 101: statement (line 1120)
CREATE STATISTICS s FROM et

-- Test 102: statement (line 1249)
DELETE FROM system.table_statistics

-- Test 103: statement (line 1253)
ALTER TABLE et INJECT STATISTICS $$$json_stats$$

-- Test 104: statement (line 1274)
CREATE TABLE groups (data JSON); INSERT INTO groups VALUES ('{"data": {"domain": "github.com"}}')

-- Test 105: statement (line 1278)
CREATE STATISTICS s ON data FROM groups

-- Test 106: statement (line 1289)
CREATE STATISTICS s FROM groups

-- Test 107: statement (line 1301)
CREATE TABLE users (
  profile_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  last_updated TIMESTAMP DEFAULT now(),
  user_profile JSONB,
  INVERTED INDEX user_details (user_profile)
)

-- Test 108: statement (line 1309)
INSERT INTO users (user_profile) VALUES
  ('{"first_name": "Lola", "last_name": "Dog", "location": "NYC", "online" : true, "friends" : 547}'),
  ('{"first_name": "Ernie", "status": "Looking for treats", "location" : "Brooklyn"}'),
  ('{"first_name": "Ernie", "status": "Looking for treats", "location" : "Brooklyn"}'),
  (NULL),
  ('{"first_name": "Carl", "last_name": "Kimball", "location": "NYC", "breed": "Boston Terrier"}'
)

-- Test 109: statement (line 1320)
CREATE STATISTICS s FROM users

-- Test 110: query (line 1323)
SELECT
  statistics_name,
  column_names,
  row_count,
  distinct_count,
  null_count,
  histogram_id IS NOT NULL AS has_histogram
FROM
  [SHOW STATISTICS FOR TABLE users]
ORDER BY
  statistics_name, column_names

-- Test 111: statement (line 1345)
SET CLUSTER SETTING sql.stats.multi_column_collection.enabled = false

-- Test 112: statement (line 1348)
CREATE TABLE prim (a INT, b INT, c INT, PRIMARY KEY (a, b, c));

-- Test 113: statement (line 1351)
INSERT INTO prim VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3);

-- Test 114: statement (line 1354)
CREATE STATISTICS s FROM prim

-- Test 115: query (line 1378)
SHOW HISTOGRAM $hist_id_1

-- Test 116: statement (line 1388)
CREATE TABLE sec (a INT, b INT, c INT, INDEX (a, b, c));

-- Test 117: statement (line 1391)
INSERT INTO sec VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3);

-- Test 118: statement (line 1394)
CREATE STATISTICS s FROM sec

-- Test 119: query (line 1419)
SHOW HISTOGRAM $hist_id_1

-- Test 120: statement (line 1429)
CREATE TABLE partial (
  a INT,
  b INT,
  c INT,
  d INT,
  j JSON,
  INDEX (a) WHERE b > 0 OR c > 0,
  INVERTED INDEX (j) WHERE d = 10
);

-- Test 121: statement (line 1440)
INSERT INTO partial VALUES (1, 1, 1, 1, '{"a": "b"}'), (2, 2, 2, 10, '{"c": "d"}'), (3, 3, 3, 1, '{"e": "f"}');

-- Test 122: statement (line 1443)
CREATE STATISTICS s FROM partial

-- Test 123: query (line 1470)
SHOW HISTOGRAM $hist_id_1

-- Test 124: statement (line 1479)
SET CLUSTER SETTING sql.stats.multi_column_collection.enabled = true

-- Test 125: statement (line 1482)
SET CLUSTER SETTING sql.stats.virtual_computed_columns.enabled = false

-- Test 126: statement (line 1485)
CREATE TABLE virt (
  a INT,
  b INT,
  v INT AS (a + 10) VIRTUAL,
  INDEX (v),
  INDEX (a, v),
  INDEX (a, v, b),
  INDEX (a) WHERE v > 0
)

-- Test 127: statement (line 1496)
INSERT INTO virt VALUES (1), (2), (3)

-- Test 128: statement (line 1499)
CREATE STATISTICS s FROM virt

-- Test 129: statement (line 1522)
CREATE TABLE expression (
  a INT,
  b INT,
  j JSON,
  INDEX a_plus_b ((a + b)),
  INDEX a_a_plus_b (a, (a + b)),
  INVERTED INDEX j_a ((j->'a')),
  INVERTED INDEX a_j_a (a, (j->'a'))
);

-- Test 130: statement (line 1533)
INSERT INTO expression VALUES (1, 1, '{"a": "b"}'), (2, 10, '{"c": "d"}'), (3, 1, '{"e": "f"}');

-- Test 131: statement (line 1536)
CREATE STATISTICS s FROM expression

-- Test 132: statement (line 1557)
RESET CLUSTER SETTING sql.stats.virtual_computed_columns.enabled

-- Test 133: statement (line 1562)
CREATE TABLE noind (a INT, b INT, c INT);

-- Test 134: statement (line 1565)
INSERT INTO noind VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3);

-- Test 135: statement (line 1568)
CREATE STATISTICS s FROM noind

-- Test 136: query (line 1593)
SHOW HISTOGRAM $hist_id_1

-- Test 137: statement (line 1601)
CREATE TABLE geo_table (
   id INT8 PRIMARY KEY,
   geog GEOGRAPHY(GEOMETRY,4326) NULL,
   geom GEOMETRY(GEOMETRY,3857) NULL
);

-- Test 138: statement (line 1608)
INSERT INTO geo_table VALUES (1, 'LINESTRING(0 0, 100 100)', ST_GeomFromText('LINESTRING(0 0, 100 100)', 3857));

-- Test 139: statement (line 1611)
CREATE STATISTICS s FROM geo_table;

-- Test 140: statement (line 1628)
CREATE INDEX geom_idx_1 ON geo_table USING GIST(geom) WITH (geometry_min_x=0, s2_max_level=15);

-- Test 141: statement (line 1631)
CREATE INDEX geog_idx_1 ON geo_table USING GIST(geog) WITH (s2_level_mod=3);

-- Test 142: statement (line 1634)
CREATE STATISTICS s FROM geo_table;

-- Test 143: statement (line 1651)
CREATE INDEX geom_idx_2 ON geo_table USING GIST(geom) WITH (geometry_min_x=5);

-- Test 144: statement (line 1654)
CREATE INDEX geog_idx_2 ON geo_table USING GIST(geog);

-- Test 145: statement (line 1657)
CREATE STATISTICS s FROM geo_table;

-- Test 146: query (line 1686)
SHOW HISTOGRAM $hist_id_1

-- Test 147: query (line 1695)
SHOW HISTOGRAM $hist_id_1

-- Test 148: statement (line 1702)
DROP INDEX geo_table@geog_idx_1;

-- Test 149: statement (line 1705)
CREATE STATISTICS s FROM geo_table;

-- Test 150: query (line 1715)
SHOW HISTOGRAM $hist_id_1

-- Test 151: query (line 1726)
SHOW HISTOGRAM $hist_id_1

-- Test 152: statement (line 1744)
INSERT INTO multi_col VALUES (1, 'foo', '{"a": "b"}');

-- Test 153: statement (line 1747)
CREATE STATISTICS s FROM multi_col;

-- Test 154: statement (line 1765)
SET CLUSTER SETTING sql.stats.multi_column_collection.enabled = true

-- Test 155: statement (line 1768)
CREATE STATISTICS s FROM multi_col;

-- Test 156: statement (line 1787)
SET CLUSTER SETTING sql.stats.multi_column_collection.enabled = false

-- Test 157: statement (line 1792)
CREATE TABLE all_null (k INT PRIMARY KEY, c INT);

-- Test 158: statement (line 1795)
INSERT INTO all_null VALUES (1, NULL);

-- Test 159: statement (line 1798)
CREATE STATISTICS s FROM all_null

-- Test 160: statement (line 1847)
SELECT * FROM all_null WHERE c IS NOT NULL

-- Test 161: statement (line 1851)
CREATE TYPE greeting AS ENUM ('hello', 'howdy', 'hi');

-- Test 162: statement (line 1854)
CREATE TABLE greeting_stats (x greeting PRIMARY KEY);

-- Test 163: statement (line 1857)
INSERT INTO greeting_stats VALUES ('hi');

-- Test 164: statement (line 1860)
CREATE STATISTICS s FROM greeting_stats

-- Test 165: statement (line 1900)
ALTER TABLE greeting_stats INJECT STATISTICS '$stats'

-- Test 166: query (line 1904)
SELECT feature_name FROM crdb_internal.feature_usage
WHERE feature_name in ('job.typedesc_schema_change.successful',
'job.new_schema_change.successful',
'job.create_stats.successful',
'job.auto_create_stats.successful') AND
usage_count > 0
ORDER BY feature_name DESC

-- Test 167: statement (line 1924)
CREATE DATABASE another_db

-- Test 168: statement (line 1927)
USE another_db

-- Test 169: statement (line 1930)
ALTER TABLE $db.public.greeting_stats INJECT STATISTICS '$stats'

-- Test 170: statement (line 1933)
USE $db

-- Test 171: statement (line 1938)
CREATE TABLE t63387 (
    i INT,
    j JSONB,
    INDEX (i) WHERE j->>'a' = 'b'
);

-- Test 172: statement (line 1945)
INSERT INTO t63387 VALUES (1, '{}');

-- Test 173: statement (line 1948)
CREATE STATISTICS s FROM t63387;

-- Test 174: statement (line 1953)
SET CLUSTER SETTING sql.stats.virtual_computed_columns.enabled = false

-- Test 175: statement (line 1956)
SET CLUSTER SETTING sql.stats.multi_column_collection.enabled = true

-- Test 176: statement (line 1959)
CREATE TABLE t71080 (
  k INT PRIMARY KEY,
  a INT,
  b INT NOT NULL AS (a + 10) VIRTUAL,
  INDEX (a, b)
)

-- Test 177: statement (line 1967)
INSERT INTO t71080 VALUES (1, 2)

-- Test 178: statement (line 1970)
CREATE STATISTICS s FROM t71080

-- Test 179: statement (line 1973)
CREATE STATISTICS s ON b FROM t71080

-- Test 180: statement (line 1976)
CREATE STATISTICS s ON a, b FROM t71080

-- Test 181: statement (line 1981)
CREATE TABLE t76867 (
  a INT,
  b INT AS (a + 1) VIRTUAL,
  c INT AS (a + 2) VIRTUAL,
  INDEX (b, c)
)

-- Test 182: statement (line 1989)
ANALYZE t76867

-- Test 183: statement (line 1992)
RESET CLUSTER SETTING sql.stats.virtual_computed_columns.enabled

-- Test 184: statement (line 1996)
ANALYZE system.locations

-- Test 185: query (line 2000)
SELECT * FROM [EXPLAIN SELECT * FROM system.locations] OFFSET 1

-- Test 186: statement (line 2010)
ANALYZE system.lease

-- Test 187: statement (line 2014)
ANALYZE system.table_statistics

-- Test 188: statement (line 2018)
ANALYZE system.jobs

-- Test 189: statement (line 2022)
ANALYZE system.scheduled_jobs

-- Test 190: statement (line 2027)
CREATE TABLE tabula (r INT, a INT, sa INT, PRIMARY KEY (r), INDEX (a, sa))

-- Test 191: statement (line 2030)
CREATE STATISTICS aristotle FROM tabula

-- Test 192: query (line 2049)
SHOW HISTOGRAM $hist_id_1

-- Test 193: statement (line 2118)
INSERT INTO tabula VALUES (11, 12, NULL)

-- Test 194: statement (line 2121)
CREATE STATISTICS locke FROM tabula

-- Test 195: query (line 2140)
SHOW HISTOGRAM $hist_id_1

-- Test 196: query (line 2151)
SHOW HISTOGRAM $hist_id_1

-- Test 197: statement (line 2231)
CREATE TABLE t1 (a INT, b INT, c INT)

-- Test 198: statement (line 2234)
ANALYZE t1

-- Test 199: statement (line 2237)
CREATE STATISTICS t1_ab ON a,b FROM t1

-- Test 200: statement (line 2240)
CREATE STATISTICS t1_ac ON a,c FROM t1

-- Test 201: statement (line 2243)
CREATE STATISTICS t1_bc ON b,c FROM t1

-- Test 202: statement (line 2246)
ALTER TABLE t1 drop column c

-- Test 203: statement (line 2249)
show statistics for table t1

-- Test 204: statement (line 2332)
CREATE TABLE u (d INT, c INT, b INT, a INT, PRIMARY KEY (a, b), INDEX (c, d, a, b));

-- Test 205: statement (line 2335)
CREATE STATISTICS u_defaults FROM u;

-- Test 206: statement (line 2338)
CREATE STATISTICS u_a_b ON a, b FROM u;

-- Test 207: statement (line 2341)
CREATE STATISTICS u_b_a ON b, a FROM u;

-- Test 208: statement (line 2344)
CREATE STATISTICS u_c_d_b ON c, d, b FROM u;

-- Test 209: query (line 2347)
SELECT statistics_name, column_names
FROM [SHOW STATISTICS FOR TABLE u]
ORDER BY column_names, statistics_name

-- Test 210: statement (line 2366)
CREATE TABLE indexed_arr(a INT[]);
CREATE INDEX ON indexed_arr(a)

-- Test 211: statement (line 2370)
INSERT INTO indexed_arr SELECT ARRAY[g] FROM generate_series(1,10000) g(g)

-- Test 212: statement (line 2373)
ANALYZE indexed_arr

-- Test 213: statement (line 2384)
CREATE INDEX ON indexed_arr USING GIN (a)

-- Test 214: query (line 2387)
SELECT * FROM indexed_arr WHERE a = ARRAY[100]

-- Test 215: query (line 2392)
SELECT * FROM indexed_arr WHERE a @> ARRAY[100]

-- Test 216: statement (line 2397)
ANALYZE indexed_arr

-- Test 217: query (line 2408)
SELECT * FROM indexed_arr WHERE a = ARRAY[100]

-- Test 218: query (line 2413)
SELECT * FROM indexed_arr WHERE a @> ARRAY[100]

-- Test 219: statement (line 2420)
CREATE TABLE abcd (a INT PRIMARY KEY, b INT, c INT, d INT, INDEX (c, d));

-- Test 220: statement (line 2423)
CREATE TABLE xy (x INT, y INT, INDEX (x, y))

-- Test 221: statement (line 2426)
INSERT INTO xy VALUES (0, 10), (1, 11), (2, 12), (3, 13)

-- Test 222: statement (line 2429)
INSERT INTO abcd VALUES
(1, 10, 100, 1000),
(2, 20, 200, 2000),
(3, 30, 300, 3000),
(4, 40, 400, 4000),
(5, 50, 500, 5000),
(6, 60, 600, 6000),
(7, 70, 700, 7000),
(8, 80, 800, 8000);

-- Test 223: statement (line 2440)
CREATE STATISTICS abcd_a ON a FROM abcd;

-- Test 224: statement (line 2443)
CREATE STATISTICS abcd_c ON c FROM abcd;

-- Test 225: statement (line 2446)
CREATE STATISTICS xy_x ON x FROM xy;

-- Test 226: statement (line 2450)
INSERT INTO abcd VALUES
(-2, -20, 900, 9000),
(-1, -10, 920, 9200),
(0, -9, 920, 9300);

-- Test 227: statement (line 2457)
INSERT INTO xy VALUES (-1, 9), (-2, 8), (5, 15), (6, 16)

-- Test 228: statement (line 2462)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 229: statement (line 2465)
CREATE STATISTICS abcd_a_partial ON a FROM abcd USING EXTREMES;

-- Test 230: statement (line 2468)
CREATE STATISTICS abcd_c_partial ON c FROM abcd USING EXTREMES;

-- Test 231: statement (line 2471)
CREATE STATISTICS xy_x_partial ON x FROM xy USING EXTREMES;

let $hist_abcd_a_partial
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE abcd] WHERE statistics_name = 'abcd_a_partial';

let $hist_abcd_c_partial
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE abcd] WHERE statistics_name = 'abcd_c_partial';

let $hist_xy_x_partial
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE xy] WHERE statistics_name = 'xy_x_partial';

-- Test 232: query (line 2483)
SHOW HISTOGRAM $hist_abcd_a_partial

-- Test 233: query (line 2491)
SHOW HISTOGRAM $hist_abcd_c_partial

-- Test 234: query (line 2498)
SHOW HISTOGRAM $hist_xy_x_partial

-- Test 235: query (line 2507)
SELECT "name", "partialPredicate" FROM system.table_statistics WHERE name='abcd_a_partial';

-- Test 236: query (line 2513)
SELECT "name", "partialPredicate" FROM system.table_statistics WHERE name='abcd_c_partial';

-- Test 237: query (line 2519)
SELECT "name", "partialPredicate" FROM system.table_statistics WHERE name='xy_x_partial';

-- Test 238: statement (line 2526)
CREATE STATISTICS xy_x_partial_2 ON x FROM xy USING EXTREMES

-- Test 239: query (line 2529)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE xy]
ORDER BY statistics_name

-- Test 240: query (line 2545)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE xy]
WHERE full_histogram_id = '$statistics_id'
ORDER BY statistics_name

-- Test 241: query (line 2555)
SELECT jsonb_pretty(stat->'name')
FROM (
  SELECT jsonb_array_elements(statistics) AS stat
  FROM [SHOW STATISTICS USING JSON FOR TABLE xy]
)
WHERE stat->>'full_statistic_id' = '$statistics_id'
ORDER BY stat->>'name';

-- Test 242: statement (line 2568)
CREATE TABLE a_null (a INT, INDEX (a));

-- Test 243: statement (line 2571)
INSERT INTO a_null VALUES (NULL), (1), (2);

-- Test 244: statement (line 2574)
CREATE STATISTICS a_null_stat ON a FROM a_null;

-- Test 245: statement (line 2577)
INSERT INTO a_null VALUES (NULL), (NULL), (NULL);

-- Test 246: statement (line 2582)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 247: statement (line 2585)
CREATE STATISTICS a_null_stat_partial ON a FROM a_null USING EXTREMES;

let $hist_a_null_stat_partial
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE a_null] WHERE statistics_name = 'a_null_stat_partial';

-- Test 248: query (line 2591)
SHOW HISTOGRAM $hist_a_null_stat_partial

-- Test 249: query (line 2596)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE a_null]
ORDER BY statistics_name

-- Test 250: statement (line 2606)
CREATE TABLE d_desc (a INT, b INT, index (a DESC, b));

-- Test 251: statement (line 2609)
INSERT INTO d_desc VALUES (1, 10), (2, 20), (3, 30), (4, 40);

-- Test 252: statement (line 2612)
CREATE STATISTICS sd ON a FROM d_desc;

-- Test 253: statement (line 2615)
INSERT INTO d_desc VALUES (0, 0), (5, 50);

-- Test 254: statement (line 2620)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 255: statement (line 2623)
CREATE STATISTICS sdp ON a FROM d_desc USING EXTREMES;

let $hist_d_desc
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE d_desc] WHERE statistics_name = 'sdp';

-- Test 256: query (line 2629)
SHOW HISTOGRAM $hist_d_desc

-- Test 257: query (line 2636)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE d_desc]
ORDER BY statistics_name

-- Test 258: statement (line 2646)
INSERT INTO d_desc VALUES (NULL, NULL), (NULL, 2);

-- Test 259: statement (line 2649)
CREATE STATISTICS sdn ON a FROM d_desc;

-- Test 260: statement (line 2654)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 261: statement (line 2657)
CREATE STATISTICS sdnp ON a FROM d_desc USING EXTREMES;

-- Test 262: query (line 2660)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE d_desc]
ORDER BY statistics_name

-- Test 263: statement (line 2670)
SET enable_create_stats_using_extremes = off

-- Test 264: statement (line 2673)
CREATE STATISTICS abcd_defaults ON a FROM abcd USING EXTREMES;

-- Test 265: statement (line 2676)
RESET enable_create_stats_using_extremes

-- Test 266: statement (line 2679)
CREATE STATISTICS abcd_a_b ON a, c FROM abcd USING EXTREMES;

-- Test 267: statement (line 2682)
SET CLUSTER SETTING sql.stats.histogram_collection.enabled = false

-- Test 268: statement (line 2685)
CREATE STATISTICS abcd_a_b ON a FROM abcd USING EXTREMES;

-- Test 269: statement (line 2688)
CREATE STATISTICS abcd_a_b ON a FROM abcd WHERE a > 5;

-- Test 270: statement (line 2691)
RESET CLUSTER SETTING sql.stats.histogram_collection.enabled

-- Test 271: statement (line 2699)
INSERT INTO s VALUES ('c'), ('d'), ('e');

-- Test 272: statement (line 2702)
CREATE STATISTICS str ON s FROM s;

-- Test 273: statement (line 2705)
INSERT INTO s VALUES ('a'), ('b'), ('f');

-- Test 274: statement (line 2710)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 275: statement (line 2713)
CREATE STATISTICS s_partial ON s FROM s USING EXTREMES;

-- Test 276: query (line 2716)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE s]
ORDER BY statistics_name

-- Test 277: statement (line 2726)
CREATE TABLE j (j JSONB, INVERTED INDEX (j));

-- Test 278: statement (line 2729)
INSERT INTO j VALUES ('{"1":"10"}'), ('{"2":"20"}'),  ('{"3":"30"}');

-- Test 279: statement (line 2732)
CREATE STATISTICS j_full ON j FROM j;

-- Test 280: statement (line 2737)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 281: statement (line 2740)
CREATE STATISTICS j_partial ON j FROM j USING EXTREMES;

-- Test 282: statement (line 2743)
CREATE TABLE xyz (x INT, y INT, z INT, INDEX (x, y));

-- Test 283: statement (line 2746)
EXPLAIN ANALYZE CREATE STATISTICS xyz_x ON x FROM xyz USING EXTREMES;

-- Test 284: statement (line 2749)
EXPLAIN ANALYZE CREATE STATISTICS xyz_x ON x FROM xyz WHERE x > 5;

-- Test 285: statement (line 2752)
EXPLAIN ANALYZE CREATE STATISTICS u_partial ON a FROM u USING EXTREMES;

-- Test 286: statement (line 2755)
EXPLAIN ANALYZE CREATE STATISTICS u_partial ON a FROM u WHERE a > 5;

-- Test 287: statement (line 2758)
CREATE STATISTICS xy_y_partial ON y FROM xy USING EXTREMES;

-- Test 288: statement (line 2761)
CREATE TABLE only_null (a INT, INDEX (a));

-- Test 289: statement (line 2764)
INSERT INTO only_null VALUES (NULL), (NULL), (NULL);

-- Test 290: statement (line 2767)
CREATE STATISTICS only_null_stat ON a FROM only_null;

-- Test 291: statement (line 2772)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 292: statement (line 2775)
EXPLAIN ANALYZE CREATE STATISTICS only_null_partial ON a FROM only_null USING EXTREMES;

-- Test 293: statement (line 2778)
EXPLAIN ANALYZE CREATE STATISTICS only_null_partial ON a FROM only_null WHERE a > 5;

-- Test 294: statement (line 2781)
CREATE INDEX ON xy (y) WHERE y > 5;

-- Test 295: statement (line 2784)
CREATE STATISTICS xy_partial_idx ON y FROM xy USING EXTREMES;

-- Test 296: statement (line 2788)
CREATE TYPE enum1 as ENUM ('hello', 'hi');
CREATE TABLE t100909 (x int, y enum1);
INSERT INTO t100909 VALUES (1, 'hello'), (2, 'hello'), (3, 'hi');

-- Test 297: statement (line 2793)
CREATE STATISTICS s1 ON y FROM t100909;

let $hist_id_1
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE t100909] WHERE statistics_name = 's1'

-- Test 298: query (line 2799)
SHOW HISTOGRAM $hist_id_1

-- Test 299: statement (line 2808)
CREATE TABLE t107651 (i INT PRIMARY KEY)

-- Test 300: statement (line 2811)
SET TIME ZONE -7

-- Test 301: statement (line 2814)
ALTER TABLE t107651 INJECT STATISTICS '[
    {
        "avg_size": 0,
        "columns": [
            "i"
        ],
        "created_at": "2023-09-15 21:00:00.000000",
        "distinct_count": 0,
        "histo_col_type": "",
        "name": "__auto__",
        "null_count": 0,
        "row_count": 0
    }
]'

-- Test 302: query (line 2830)
SELECT statistics_name, created FROM
[SHOW STATISTICS FOR TABLE t107651]

-- Test 303: statement (line 2836)
SET TIME ZONE -4

-- Test 304: query (line 2839)
SELECT statistics_name, created FROM
[SHOW STATISTICS FOR TABLE t107651]

-- Test 305: statement (line 2847)
CREATE TABLE tab_test_privileges (a INT PRIMARY KEY);

-- Test 306: statement (line 2850)
INSERT INTO tab_test_privileges VALUES (1);

-- Test 307: statement (line 2853)
CREATE STATISTICS tab_test_privileges_stat ON a FROM tab_test_privileges;

user testuser

-- Test 308: query (line 2858)
SELECT statistics_name, created FROM [SHOW STATISTICS FOR TABLE tab_test_privileges]

user root

statement ok
GRANT SELECT ON tab_test_privileges TO testuser

user testuser

query T
SELECT statistics_name FROM [SHOW STATISTICS FOR TABLE tab_test_privileges]

-- Test 309: statement (line 2896)
INSERT INTO t68254 (a, b, c) VALUES (4, NULL, NULL)

-- Test 310: statement (line 2899)
CREATE STATISTICS j1 FROM t68254

-- Test 311: statement (line 2923)
CREATE STATISTICS j2 ON d FROM t68254

-- Test 312: statement (line 2926)
CREATE STATISTICS j3 ON e FROM t68254

-- Test 313: statement (line 2929)
CREATE STATISTICS j4 ON f FROM t68254

let $hist_d
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE t68254] WHERE statistics_name = 'j2'

let $hist_e
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE t68254] WHERE statistics_name = 'j3'

let $hist_f
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE t68254] WHERE statistics_name = 'j4'

-- Test 314: query (line 2941)
SHOW HISTOGRAM $hist_d

-- Test 315: query (line 2950)
SHOW HISTOGRAM $hist_e

-- Test 316: query (line 2959)
SHOW HISTOGRAM $hist_f

-- Test 317: query (line 2968)
EXPLAIN SELECT * FROM t68254 WHERE e IN ('{"baz": 2}', '{"baz": 3}', '{"baz": 4}')

-- Test 318: query (line 2984)
EXPLAIN SELECT * FROM t68254 WHERE f IN ('{"baz": 2}', '{"baz": 3}', '{"baz": 4}')

-- Test 319: query (line 3000)
EXPLAIN SELECT * FROM t68254 WHERE c->'foo'->'bar' > '{"baz": 0}'

-- Test 320: statement (line 3017)
CREATE INDEX ON t68254 ((c->'foo'))

-- Test 321: statement (line 3020)
CREATE STATISTICS j4 FROM t68254

-- Test 322: statement (line 3045)
CREATE STATISTICS j5 ON crdb_internal_idx_expr FROM t68254

let $hist_crdb_internal_idx_expr
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE t68254] WHERE statistics_name = 'j5'

-- Test 323: query (line 3051)
SHOW HISTOGRAM $hist_crdb_internal_idx_expr

-- Test 324: statement (line 3062)
CREATE TABLE t130817 (k INT PRIMARY KEY AS (NULL) VIRTUAL);

-- Test 325: statement (line 3065)
ANALYZE t130817;

-- Test 326: statement (line 3069)
INSERT INTO t68254 (a, b, c) VALUES (5, '5', '{"foo": {"bar": {"baz": 5}}}')

-- Test 327: statement (line 3074)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 328: statement (line 3077)
CREATE STATISTICS j6 ON d FROM t68254 USING EXTREMES

-- Test 329: statement (line 3080)
CREATE STATISTICS j7 ON e FROM t68254 USING EXTREMES

-- Test 330: statement (line 3083)
CREATE STATISTICS j8 ON crdb_internal_idx_expr FROM t68254 USING EXTREMES

let $hist_d
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE t68254] WHERE statistics_name = 'j6'

let $hist_e
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE t68254] WHERE statistics_name = 'j7'

let $hist_crdb_internal_idx_expr
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE t68254] WHERE statistics_name = 'j8'

-- Test 331: query (line 3095)
SHOW HISTOGRAM $hist_d

-- Test 332: query (line 3101)
SHOW HISTOGRAM $hist_e

-- Test 333: query (line 3107)
SHOW HISTOGRAM $hist_crdb_internal_idx_expr

-- Test 334: statement (line 3115)
CREATE TABLE int_outer_buckets (a INT PRIMARY KEY)

-- Test 335: statement (line 3120)
ALTER TABLE int_outer_buckets INJECT STATISTICS '[
  {
    "name": "int_outer_buckets_full",
    "columns": ["a"],
    "created_at": "2018-01-01 1:00:00.00000+00:00",
    "row_count": 10000,
    "distinct_count": 10000,
    "null_count": 0,
    "avg_size": 2,
    "histo_col_type": "int",
    "histo_version": 3,
    "histo_buckets": [
      {"num_eq": 0, "num_range": 0, "distinct_range": 0, "upper_bound": "-9223372036854775808"},
      {"num_eq": 1, "num_range": 0, "distinct_range": 0, "upper_bound": "0"},
      {"num_eq": 1, "num_range": 9998, "distinct_range": 9998, "upper_bound": "9999"},
      {"num_eq": 0, "num_range": 0, "distinct_range": 0, "upper_bound": "9223372036854775807"}
    ]
  }
]'

-- Test 336: statement (line 3141)
INSERT INTO int_outer_buckets SELECT generate_series(-10, -1) UNION ALL SELECT generate_series(10000, 10009);

-- Test 337: statement (line 3146)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 338: statement (line 3149)
CREATE STATISTICS int_outer_buckets_partial ON a FROM int_outer_buckets USING EXTREMES;

-- Test 339: query (line 3154)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE int_outer_buckets]
WHERE statistics_name = 'int_outer_buckets_partial'

-- Test 340: statement (line 3164)
INSERT INTO int_outer_buckets VALUES (-9223372036854775808), (9223372036854775807);

-- Test 341: statement (line 3167)
SET CLUSTER SETTING sql.stats.histogram_samples.count = 10050;

-- Test 342: statement (line 3170)
CREATE STATISTICS int_outer_buckets_full ON a FROM int_outer_buckets;

-- Test 343: statement (line 3175)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 344: statement (line 3178)
CREATE STATISTICS int_outer_buckets_partial ON a FROM int_outer_buckets USING EXTREMES;

-- Test 345: query (line 3183)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE int_outer_buckets]
WHERE statistics_name = 'int_outer_buckets_partial'

-- Test 346: statement (line 3193)
CREATE TABLE timestamp_outer_buckets (a TIMESTAMP PRIMARY KEY);

-- Test 347: statement (line 3196)
INSERT INTO timestamp_outer_buckets VALUES
  ('2024-06-26 01:00:00'),
  ('2024-06-26 02:00:00'),
  ('2024-06-27 01:30:00'),
  ('2024-06-27 02:30:00');

-- Test 348: statement (line 3203)
CREATE STATISTICS timestamp_outer_buckets_full ON a FROM timestamp_outer_buckets;

let $hist_id_timestamp_outer_buckets_full
SELECT histogram_id FROM [SHOW STATISTICS FOR TABLE timestamp_outer_buckets] WHERE statistics_name = 'timestamp_outer_buckets_full'

-- Test 349: query (line 3210)
SELECT count(*) FROM [SHOW HISTOGRAM $hist_id_timestamp_outer_buckets_full]

-- Test 350: statement (line 3215)
INSERT INTO timestamp_outer_buckets VALUES
  ('2024-06-26 00:00:00'),
  ('2024-06-27 03:30:00');

-- Test 351: statement (line 3222)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 352: statement (line 3225)
CREATE STATISTICS timestamp_outer_buckets_partial ON a FROM timestamp_outer_buckets USING EXTREMES;

-- Test 353: query (line 3229)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE timestamp_outer_buckets]
WHERE statistics_name = 'timestamp_outer_buckets_partial'

-- Test 354: statement (line 3238)
ALTER TABLE timestamp_outer_buckets INJECT STATISTICS '[
    {
        "avg_size": 7,
        "columns": [
            "a"
        ],
        "created_at": "2024-06-27 19:00:16.450303",
        "distinct_count": 4,
        "histo_buckets": [
            {
                "distinct_range": 0.000001,
                "num_eq": 0,
                "num_range": 0,
                "upper_bound": "4714-11-24 00:00:00 BC"
            },
            {
                "distinct_range": 0,
                "num_eq": 1,
                "num_range": 0,
                "upper_bound": "2024-06-26 01:00:00"
            },
            {
                "distinct_range": 0,
                "num_eq": 1,
                "num_range": 0,
                "upper_bound": "2024-06-26 02:00:00"
            },
            {
                "distinct_range": 0,
                "num_eq": 1,
                "num_range": 0,
                "upper_bound": "2024-06-27 01:30:00"
            },
            {
                "distinct_range": 0,
                "num_eq": 1,
                "num_range": 0,
                "upper_bound": "2024-06-27 02:30:00"
            },
            {
                "distinct_range": 0.000001,
                "num_eq": 0,
                "num_range": 0,
                "upper_bound": "294276-12-31 23:59:59.999999"
            }
        ],
        "histo_col_type": "TIMESTAMP",
        "histo_version": 3,
        "name": "timestamp_outer_buckets_full",
        "null_count": 0,
        "row_count": 4
    }
]'

-- Test 355: statement (line 3293)
INSERT INTO timestamp_outer_buckets VALUES ('2024-06-28 01:00:00');

-- Test 356: statement (line 3298)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 357: statement (line 3301)
CREATE STATISTICS timestamp_outer_buckets_partial ON a FROM timestamp_outer_buckets USING EXTREMES;

-- Test 358: query (line 3307)
SELECT "statistics_name", "partial_predicate", "row_count", "null_count"
FROM [SHOW STATISTICS FOR TABLE timestamp_outer_buckets]
WHERE statistics_name = 'timestamp_outer_buckets_partial'

-- Test 359: statement (line 3317)
CREATE TABLE bool_table (a bool PRIMARY KEY)

-- Test 360: statement (line 3320)
INSERT INTO bool_table VALUES (true), (false)

-- Test 361: statement (line 3323)
CREATE STATISTICS bool_table_full ON a FROM bool_table

-- Test 362: statement (line 3328)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 363: statement (line 3331)
CREATE STATISTICS bool_table_partial ON a FROM bool_table USING EXTREMES;

-- Test 364: statement (line 3334)
CREATE TABLE enum_table (a e PRIMARY KEY)

-- Test 365: statement (line 3337)
INSERT INTO enum_table VALUES ('hello'), ('howdy'), ('hi')

-- Test 366: statement (line 3340)
CREATE STATISTICS enum_table_full ON a FROM enum_table

-- Test 367: statement (line 3345)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 368: statement (line 3348)
CREATE STATISTICS enum_table_full ON a FROM enum_table USING EXTREMES

-- Test 369: statement (line 3351)
SET enable_create_stats_using_extremes_bool_enum = on

-- Test 370: statement (line 3354)
CREATE STATISTICS bool_table_full ON a FROM bool_table USING EXTREMES

-- Test 371: statement (line 3357)
CREATE STATISTICS enum_table_partial ON a FROM bool_table USING EXTREMES

-- Test 372: statement (line 3360)
RESET enable_create_stats_using_extremes_bool_enum

-- Test 373: statement (line 3365)
CREATE TABLE t118537 (
  a INT,
  PRIMARY KEY (a) USING HASH WITH (bucket_count = 3)
)

-- Test 374: statement (line 3371)
INSERT INTO t118537 SELECT generate_series(0, 9)

-- Test 375: statement (line 3374)
SET CLUSTER SETTING jobs.debug.pausepoints = 'newschemachanger.before.exec'

skipif config local-legacy-schema-changer

-- Test 376: statement (line 3378)
ALTER TABLE t118537 ALTER PRIMARY KEY USING COLUMNS (a) USING HASH

-- Test 377: statement (line 3381)
CREATE STATISTICS mutation FROM t118537

-- Test 378: statement (line 3394)
SET CLUSTER SETTING jobs.debug.pausepoints = ''

let $job
SELECT job_id FROM crdb_internal.jobs WHERE description LIKE 'ALTER TABLE %t118537 ALTER PRIMARY KEY USING COLUMNS (a) USING HASH' AND status LIKE 'pause%' FETCH FIRST 1 ROWS ONLY

-- Test 379: statement (line 3400)
RESUME JOB $job

-- Test 380: statement (line 3403)
SHOW JOB WHEN COMPLETE $job

-- Test 381: statement (line 3408)
CREATE TABLE mno (
  m int NOT NULL,
  n int,
  o int AS (sqrt(m::float)::int) VIRTUAL,
  PRIMARY KEY (m),
  INDEX (n),
  INDEX (o) STORING (n)
)

-- Test 382: statement (line 3418)
INSERT INTO mno (m, n) SELECT i, i % 50 FROM generate_series(0, 999) s(i)

-- Test 383: statement (line 3421)
ANALYZE mno

-- Test 384: query (line 3434)
SELECT info FROM [EXPLAIN SELECT * FROM mno WHERE n = 1 AND o = 9] WHERE info LIKE '%estimated row count:%'

-- Test 385: query (line 3441)
SELECT info FROM [EXPLAIN SELECT * FROM mno WHERE n = 1 AND o = 11] WHERE info LIKE '%estimated row count:%'

-- Test 386: statement (line 3447)
SET optimizer_use_virtual_computed_column_stats = false

-- Test 387: query (line 3451)
SELECT info FROM [EXPLAIN SELECT * FROM mno WHERE n = 1 AND o = 9] WHERE info LIKE '%estimated row count:%'

-- Test 388: query (line 3458)
SELECT info FROM [EXPLAIN SELECT * FROM mno WHERE n = 1 AND o = 11] WHERE info LIKE '%estimated row count:%'

-- Test 389: statement (line 3469)
ANALYZE t122312

-- Test 390: statement (line 3474)
CREATE TYPE order_status AS ENUM ('pending', 'paid', 'dispatched', 'delivered')

-- Test 391: statement (line 3477)
CREATE TABLE orders (
  "id" UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  "customer_id" UUID NOT NULL,
  "total" DECIMAL NOT NULL,
  "balance" DECIMAL NOT NULL,
  "order_ts" TIMESTAMPTZ(0) NOT NULL DEFAULT now(),
  "dispatch_ts" TIMESTAMPTZ(0),
  "delivery_ts" TIMESTAMPTZ(0),
  "status" order_status AS (
    CASE
      WHEN "delivery_ts" IS NOT NULL THEN 'delivered'
      WHEN "dispatch_ts" IS NOT NULL THEN 'dispatched'
      WHEN "balance" = 0 THEN 'paid'
      ELSE 'pending'
    END) VIRTUAL,
  INDEX ("status")
)

-- Test 392: statement (line 3496)
INSERT INTO orders ("customer_id", "total", "balance", "dispatch_ts", "delivery_ts") VALUES
  ('bdeb232e-12e9-4a33-9dd5-7bb9b694291a', 100, 100, NULL, NULL),
  ('0dc59725-d20b-4370-a05d-11db025a0064', 200, 0, NULL, NULL),
  ('d53d4021-9390-4b3a-9e5a-4bf1ff3e5a4c', 300, 0, now(), NULL),
  ('d53d4021-9390-4b3a-9e5a-4bf1ff3e5a4c', 400, 0, now(), now())

-- Test 393: statement (line 3503)
ANALYZE orders

-- Test 394: query (line 3524)
SHOW HISTOGRAM $hist_status

-- Test 395: statement (line 3536)
CREATE TABLE t138809 (
  a INT PRIMARY KEY,
  b INT AS (a + 1) VIRTUAL,
  c INT AS (a + 2) VIRTUAL
)

-- Test 396: statement (line 3543)
INSERT INTO t138809 (a) VALUES (1), (2)

-- Test 397: statement (line 3546)
ANALYZE t138809

-- Test 398: query (line 3560)
SELECT info FROM [EXPLAIN SELECT count(*) FROM t138809 WHERE b > 1] WHERE info LIKE '%estimated row count:%'

-- Test 399: statement (line 3566)
SET CLUSTER SETTING jobs.debug.pausepoints = 'schemachanger.root..1'

-- Test 400: statement (line 3569)
ALTER TABLE t138809 DROP COLUMN c

-- Test 401: query (line 3573)
SELECT info FROM [EXPLAIN SELECT count(*) FROM t138809 WHERE b > 1] WHERE info LIKE '%estimated row count:%'

-- Test 402: statement (line 3579)
SET CLUSTER SETTING jobs.debug.pausepoints = DEFAULT

let $job
SELECT job_id FROM crdb_internal.jobs WHERE description LIKE 'ALTER TABLE %t138809 DROP COLUMN c' AND status LIKE 'pause%' FETCH FIRST 1 ROWS ONLY

-- Test 403: statement (line 3585)
RESUME JOB $job

-- Test 404: statement (line 3588)
SHOW JOB WHEN COMPLETE $job

-- Test 405: statement (line 3594)
CREATE TABLE pstat_allindex (
  a INT,
  b INT,
  c INT,
  d INT,
  e INT,
  f INT,
  j JSONB,
  PRIMARY KEY (a),
  INDEX(b, c),
  INDEX(b, c, d),
  INDEX(d),
  INVERTED INDEX (j),
  INDEX (c) USING HASH,
  INDEX (e) WHERE e > 2,
  INDEX ((f + 1))
);

-- Test 406: statement (line 3613)
INSERT INTO pstat_allindex VALUES
  (1, 1, 1, 1, 1, 1, '{"1": "1"}'),
  (2, 2, 2, 2, 2, 2, '{"2": "2"}'),
  (3, 3, 3, 3, 3, 3, '{"3": "3"}'),
  (4, 4, 4, 4, 4, 4, '{"4": "4"}');

-- Test 407: statement (line 3620)
CREATE STATISTICS pstat_allindex_full FROM pstat_allindex;

-- Test 408: statement (line 3623)
INSERT INTO pstat_allindex VALUES
  (5, 5, 5, 5, 5, 5,'{"5": "5"}'),
  (6, 6, 6, 6, 6, 6, '{"6": "6"}'),
  (7, 7, 7, 7, 7, 7, '{"7": "7"}');

-- Test 409: statement (line 3631)
SELECT crdb_internal.clear_table_stats_cache();

-- Test 410: statement (line 3634)
CREATE STATISTICS pstat_allindex_partial FROM pstat_allindex USING EXTREMES;

-- Test 411: statement (line 3659)
CREATE TABLE t134031 (
  a INT PRIMARY KEY
) WITH (sql_stats_automatic_collection_enabled = false, sql_stats_histogram_buckets_count = 4)

-- Test 412: statement (line 3681)
ALTER TABLE t134031 INJECT STATISTICS '[
    {
        "avg_size": 4,
        "columns": [
            "a"
        ],
        "created_at": "2024-11-15 17:38:35.191236",
        "distinct_count": 1001,
        "histo_buckets": [
            {
                "distinct_range": 0,
                "num_eq": 1,
                "num_range": 0,
                "upper_bound": "0"
            },
            {
                "distinct_range": 331.79445036468786,
                "num_eq": 1,
                "num_range": 332,
                "upper_bound": "221778"
            },
            {
                "distinct_range": 332.043798577731,
                "num_eq": 1,
                "num_range": 332,
                "upper_bound": "887112"
            },
            {
                "distinct_range": 333.16175105758106,
                "num_eq": 1,
                "num_range": 333,
                "upper_bound": "2000000"
            }
        ],
        "histo_col_type": "INT8",
        "histo_version": 3,
        "id": 1021122691703046145,
        "name": "__auto__",
        "null_count": 0,
        "row_count": 1001
    },
    {
        "avg_size": 4,
        "columns": [
            "a"
        ],
        "created_at": "2024-11-15 17:38:36.240863",
        "distinct_count": 1002,
        "histo_buckets": [
            {
                "distinct_range": 0,
                "num_eq": 1,
                "num_range": 0,
                "upper_bound": "0"
            },
            {
                "distinct_range": 331.7944820909316,
                "num_eq": 1,
                "num_range": 332,
                "upper_bound": "221778"
            },
            {
                "distinct_range": 333.0442332658522,
                "num_eq": 1,
                "num_range": 333,
                "upper_bound": "889778"
            },
            {
                "distinct_range": 333.16128464321633,
                "num_eq": 1,
                "num_range": 333,
                "upper_bound": "2000002"
            }
        ],
        "histo_col_type": "INT8",
        "histo_version": 3,
        "id": 1021122695141097473,
        "name": "__auto__",
        "null_count": 0,
        "row_count": 1002
    },
    {
        "avg_size": 4,
        "columns": [
            "a"
        ],
        "created_at": "2024-11-15 17:38:37.296779",
        "distinct_count": 1003,
        "histo_buckets": [
            {
                "distinct_range": 0,
                "num_eq": 0,
                "num_range": 0,
                "upper_bound": "-9223372036854775808"
            },
            {
                "distinct_range": 5.684341886080802E-14,
                "num_eq": 1,
                "num_range": 0,
                "upper_bound": "0"
            },
            {
                "distinct_range": 332.7947242432267,
                "num_eq": 1,
                "num_range": 333,
                "upper_bound": "223112"
            },
            {
                "distinct_range": 333.0446396262168,
                "num_eq": 1,
                "num_range": 333,
                "upper_bound": "892448"
            },
            {
                "distinct_range": 333.16063613055655,
                "num_eq": 1,
                "num_range": 333,
                "upper_bound": "2000004"
            },
            {
                "distinct_range": 5.684341886080185E-14,
                "num_eq": 0,
                "num_range": 0,
                "upper_bound": "9223372036854775807"
            }
        ],
        "histo_col_type": "INT8",
        "histo_version": 3,
        "id": 1021122698602217473,
        "name": "__auto__",
        "null_count": 0,
        "row_count": 1003
    },
    {
        "avg_size": 4,
        "columns": [
            "a"
        ],
        "created_at": "2024-11-15 17:38:39.337031",
        "distinct_count": 1,
        "full_statistic_id": 1021122698602217473,
        "histo_buckets": [
            {
                "distinct_range": 0,
                "num_eq": 1,
                "num_range": 0,
                "upper_bound": "3000000"
            }
        ],
        "histo_col_type": "INT8",
        "histo_version": 3,
        "id": 1021122705285644289,
        "name": "__auto_partial__",
        "null_count": 0,
        "partial_predicate": "(a IS NULL) OR ((a \u003c 0:::INT8) OR (a \u003e 2000004:::INT8))",
        "row_count": 1
    }
]'

-- Test 413: query (line 3843)
SELECT stat->>'name', stat->'histo_buckets'->0
FROM (
  SELECT jsonb_array_elements(statistics) AS stat
  FROM [SHOW STATISTICS USING JSON FOR TABLE t134031 WITH MERGE, FORECAST]
)
WHERE stat->'name' <@ '["__merged__", "__forecast__"]'
ORDER BY stat->>'name' DESC

-- Test 414: statement (line 3858)
CREATE TYPE e67050 AS ENUM ('a', 'b', 'c')

-- Test 415: statement (line 3861)
CREATE TABLE t67050 (x e67050 PRIMARY KEY)

-- Test 416: statement (line 3864)
INSERT INTO t67050 VALUES ('a'), ('b'), ('c')

-- Test 417: statement (line 3867)
ANALYZE t67050

-- Test 418: statement (line 3870)
DELETE FROM t67050 WHERE x = 'a'

-- Test 419: statement (line 3873)
ALTER TYPE e67050 DROP VALUE 'a'

-- Test 420: query (line 3876)
SELECT jsonb_pretty(statistics->0->'histo_buckets') FROM
[SHOW STATISTICS USING JSON FOR TABLE t67050]

-- Test 421: statement (line 3897)
CREATE TABLE t155184 (
  a INT PRIMARY KEY
) WITH (sql_stats_automatic_collection_enabled = false, sql_stats_histogram_samples_count = 2)

-- Test 422: statement (line 3907)
ALTER TABLE t155184 INJECT STATISTICS '[
    {
        "avg_size": 1,
        "columns": [
            "a"
        ],
        "created_at": "2025-10-10 13:41:08.711908",
        "distinct_count": 10,
        "histo_buckets": [
            {
                "distinct_range": 0,
                "num_eq": 0,
                "num_range": 0,
                "upper_bound": "-9223372036854775808"
            },
            {
                "distinct_range": 3.5,
                "num_eq": 1,
                "num_range": 4,
                "upper_bound": "8"
            },
            {
                "distinct_range": 1,
                "num_eq": 1,
                "num_range": 1,
                "upper_bound": "10"
            },
            {
                "distinct_range": 3.5,
                "num_eq": 0,
                "num_range": 4,
                "upper_bound": "9223372036854775807"
            }
        ],
        "histo_col_type": "INT8",
        "histo_version": 3,
        "id": 1114221014922133505,
        "null_count": 0,
        "row_count": 10
    }
]'

-- Test 423: query (line 3951)
SELECT info FROM [EXPLAIN SELECT * FROM t155184 WHERE a < 8] WHERE info LIKE '%estimated row count:%'

