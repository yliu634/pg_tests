-- PostgreSQL compatible tests from ranges
-- 50 tests

-- Test 1: statement (line 3)
CREATE TABLE t (k1 INT, k2 INT DEFAULT 999, v INT DEFAULT 999, w INT DEFAULT 999, PRIMARY KEY (k1, k2))

-- Test 2: statement (line 87)
CREATE INDEX idx ON t(v, w)

-- Test 3: statement (line 136)
CREATE DATABASE d

-- Test 4: statement (line 139)
CREATE TABLE d.a ()

-- Test 5: statement (line 142)
CREATE DATABASE e

-- Test 6: statement (line 145)
CREATE TABLE e.b (i INT)

-- Test 7: statement (line 151)
CREATE TABLE d.c (i INT)

-- Test 8: statement (line 154)
DROP DATABASE e CASCADE

-- Test 9: statement (line 157)
CREATE INDEX ON d.c (i)

-- Test 10: query (line 168)
SELECT encode(start_key, 'hex'), start_pretty, encode(end_key, 'hex'), end_pretty, replicas, crdb_internal.lease_holder(start_key) FROM crdb_internal.ranges_no_leases;

-- Test 11: query (line 269)
SELECT encode(start_key, 'hex'), start_pretty, encode(end_key, 'hex'), end_pretty, replicas, lease_holder FROM crdb_internal.ranges

-- Test 12: statement (line 394)
CREATE DATABASE """"

-- Test 13: statement (line 397)
CREATE TABLE """".t (x INT PRIMARY KEY)

-- Test 14: query (line 413)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name='sql.show.ranges' AND usage_count > 0

-- Test 15: statement (line 420)
CREATE TABLE simple_range_for_row(x INT PRIMARY KEY)

-- Test 16: query (line 427)
SELECT start_key, end_key FROM [SHOW RANGE FROM TABLE simple_range_for_row FOR ROW (0)]

-- Test 17: query (line 433)
SELECT start_key, end_key FROM [SHOW RANGE FROM TABLE simple_range_for_row FOR ROW (1)]

-- Test 18: query (line 439)
SELECT start_key, end_key FROM [SHOW RANGE FROM TABLE simple_range_for_row FOR ROW (2)]

-- Test 19: statement (line 444)
CREATE TABLE range_for_row(x INT, y INT, z INT, w INT, PRIMARY KEY (x, y), INDEX i (z, w))

-- Test 20: query (line 453)
SELECT start_key, end_key FROM [SHOW RANGE FROM TABLE range_for_row FOR ROW (1, 2)]

-- Test 21: query (line 458)
SELECT start_key, end_key FROM [SHOW RANGE FROM TABLE range_for_row FOR ROW (1, 3)]

-- Test 22: query (line 463)
SELECT start_key, end_key FROM [SHOW RANGE FROM TABLE range_for_row FOR ROW (1, 1)]

-- Test 23: query (line 468)
SELECT start_key, end_key FROM [SHOW RANGE FROM INDEX range_for_row@i FOR ROW (1, 2, 1, 2)]

-- Test 24: query (line 473)
SELECT start_key, end_key FROM [SHOW RANGE FROM INDEX range_for_row@i FOR ROW (3, 4, 1, 2)]

-- Test 25: query (line 478)
SELECT start_key, end_key FROM [SHOW RANGE FROM INDEX range_for_row@i FOR ROW (3, 5, 1, 2)]

-- Test 26: query (line 489)
SELECT start_key, end_key FROM [SHOW RANGE FROM TABLE range_for_row_string FOR ROW ('he')]

-- Test 27: statement (line 494)
CREATE TABLE range_for_row_decimal(x DECIMAL PRIMARY KEY)

-- Test 28: query (line 500)
SELECT start_key, end_key FROM [SHOW RANGE FROM TABLE range_for_row_decimal FOR ROW (1)]

-- Test 29: statement (line 505)
CREATE TABLE range_for_row_nulls(x INT PRIMARY KEY, y INT, INDEX i (y))

-- Test 30: query (line 511)
SELECT start_key, end_key from [SHOW RANGE FROM INDEX range_for_row_nulls@i FOR ROW (NULL, 1)]

-- Test 31: statement (line 519)
CREATE TABLE t42456 (x int primary key);

-- Test 32: statement (line 522)
CREATE INDEX i1 on t42456 (x);

-- Test 33: statement (line 525)
CREATE INDEX i2 on t42456 (x);

-- Test 34: statement (line 528)
DROP INDEX t42456@i1;

-- Test 35: statement (line 531)
DROP INDEX t42456@i2;

-- Test 36: statement (line 534)
CREATE INDEX i3 on t42456 (x)

let $t42456_id
SELECT id FROM system.namespace WHERE name='t42456'

-- Test 37: query (line 544)
WITH indexes AS (
    SELECT json_array_elements(crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor)->'table'->'indexes') as idx from system.descriptor WHERE id = $t42456_id
)
SELECT idx->'id' from indexes WHERE idx->>'name' = 'i3';

-- Test 38: query (line 552)
SELECT crdb_internal.pretty_key(crdb_internal.encode_key($t42456_id, 6, (1, )), 0)

-- Test 39: query (line 606)
SELECT start_key, end_key FROM [SHOW RANGE FROM TABLE t63646 FOR ROW ('b')]

-- Test 40: statement (line 615)
GRANT SELECT ON TABLE t to testuser

user testuser

-- Test 41: statement (line 628)
GRANT ZONECONFIG ON TABLE t TO testuser

user testuser

-- Test 42: statement (line 644)
REVOKE ZONECONFIG ON TABLE t FROM testuser

user testuser

-- Test 43: statement (line 658)
ALTER ROLE testuser WITH VIEWACTIVITY

user testuser

-- Test 44: statement (line 672)
ALTER ROLE testuser with NOVIEWACTIVITY

-- Test 45: statement (line 676)
ALTER ROLE testuser with VIEWACTIVITYREDACTED

user testuser

-- Test 46: statement (line 693)
SELECT crdb_internal.range_stats(k)
  FROM (
          SELECT *
            FROM (
                     SELECT start_key AS k, random() AS r FROM crdb_internal.ranges_no_leases
                     UNION ALL SELECT NULL, random() FROM ROWS FROM (generate_series(1, 100))
                 )
        ORDER BY r DESC
       );

user root

-- Test 47: statement (line 708)
CREATE TABLE tbl_for_row(i INT PRIMARY KEY);

-- Test 48: query (line 712)
SHOW RANGE FROM TABLE tbl_for_row FOR ROW (0)

-- Test 49: statement (line 723)
CREATE TABLE tbl_with_idx_for_row(i INT, INDEX idx (i));

-- Test 50: query (line 726)
SHOW RANGE FROM INDEX tbl_with_idx_for_row@idx FOR ROW (NULL, 0)

