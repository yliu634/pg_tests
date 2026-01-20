-- PostgreSQL compatible tests from create_table
-- 184 tests

-- Test 1: statement (line 3)
SET create_table_with_schema_locked=false

-- Test 2: statement (line 8)
CREATE TABLE TEST2 (COL1 SERIAL PRIMARY KEY, COL2 INT8)

-- Test 3: statement (line 11)
CREATE TABLE TEST1 (COL1 SERIAL PRIMARY KEY, COL2 INT8, COL3 INT8, CONSTRAINT duplicate_name FOREIGN KEY (col2) REFERENCES TEST2(COL1), CONSTRAINT duplicate_name FOREIGN KEY (col3) REFERENCES TEST2(COL1))

-- Test 4: statement (line 14)
DROP TABLE TEST2

-- Test 5: statement (line 19)
CREATE TABLE IF NOT EXISTS t43894 (PRIMARY KEY (a), a UUID NOT NULL, b JSONB NOT NULL DEFAULT '5')

-- Test 6: statement (line 24)
CREATE TABLE new_table (a timetz(3))

-- Test 7: statement (line 27)
ALTER TABLE new_table ADD COLUMN c timetz(4)

-- Test 8: query (line 31)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name IN ('sql.schema.new_column_type.timetz_3_', 'sql.schema.new_column_type.timetz_4_') AND usage_count > 0 ORDER BY feature_name

-- Test 9: statement (line 37)
SET autocommit_before_ddl = false

-- Test 10: statement (line 40)
CREATE TABLE sec_col_fam(x INT, y INT, z INT, FAMILY (x), FAMILY (y), FAMILY (z), INDEX (x) STORING (y, z));
CREATE INDEX ON sec_col_fam (x) STORING (y, z)

-- Test 11: query (line 44)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name = 'sql.schema.secondary_index_column_families' AND usage_count >= 2

-- Test 12: statement (line 49)
RESET autocommit_before_ddl

-- Test 13: statement (line 52)
set require_explicit_primary_keys=true

-- Test 14: statement (line 55)
CREATE TABLE t (x INT, y INT)

-- Test 15: statement (line 59)
CREATE TABLE t (x INT PRIMARY KEY, y INT)

-- Test 16: statement (line 63)
reset require_explicit_primary_keys;

-- Test 17: statement (line 66)
DROP TABLE IF EXISTS t;

-- Test 18: statement (line 69)
CREATE TABLE t (rowid INT, rowid_1 INT, FAMILY (rowid, rowid_1))

-- Test 19: query (line 72)
SELECT column_name FROM [SHOW COLUMNS FROM t]

-- Test 20: query (line 79)
SELECT index_name, column_name FROM [SHOW INDEXES FROM t]

-- Test 21: query (line 86)
SHOW CREATE t

-- Test 22: statement (line 99)
CREATE TABLE telemetry_test (a int DEFAULT 1, b int UNIQUE CHECK(b > 1), c int AS (a + b) STORED)

-- Test 23: query (line 102)
SELECT feature_name FROM crdb_internal.feature_usage
WHERE feature_name IN (
  'sql.schema.new_column.qualification.computed',
  'sql.schema.new_column.qualification.default_expr',
  'sql.schema.new_column.qualification.unique'
)

-- Test 24: statement (line 114)
DROP TABLE telemetry_test

-- Test 25: statement (line 117)
CREATE TABLE telemetry (
  x INT PRIMARY KEY,
  y INT,
  z JSONB,
  v VECTOR(3),
  INVERTED INDEX (z),
  INDEX (y) USING HASH WITH (bucket_count=4),
  VECTOR INDEX (v)
)

-- Test 26: query (line 128)
SELECT feature_name FROM crdb_internal.feature_usage
WHERE feature_name IN (
  'sql.schema.inverted_index',
  'sql.schema.hash_sharded_index',
  'sql.schema.vector_index'
)

-- Test 27: statement (line 166)
CREATE TABLE like_none (LIKE like_table)

-- Test 28: query (line 169)
SHOW CREATE TABLE like_none

-- Test 29: statement (line 185)
CREATE TABLE like_constraints (LIKE like_table INCLUDING CONSTRAINTS)

-- Test 30: query (line 188)
SHOW CREATE TABLE like_constraints

-- Test 31: statement (line 208)
CREATE TABLE like_indexes (LIKE like_table INCLUDING INDEXES)

-- Test 32: query (line 211)
SHOW CREATE TABLE like_indexes

-- Test 33: statement (line 231)
CREATE TABLE like_generated (LIKE like_table INCLUDING GENERATED)

-- Test 34: query (line 234)
SHOW CREATE TABLE like_generated

-- Test 35: statement (line 250)
CREATE TABLE like_defaults (LIKE like_table INCLUDING DEFAULTS)

-- Test 36: query (line 253)
SHOW CREATE TABLE like_defaults

-- Test 37: statement (line 269)
CREATE TABLE like_all (LIKE like_table INCLUDING ALL)

-- Test 38: query (line 272)
SHOW CREATE TABLE like_all

-- Test 39: statement (line 295)
CREATE TABLE like_mixed (LIKE like_table INCLUDING ALL EXCLUDING GENERATED EXCLUDING CONSTRAINTS INCLUDING GENERATED)

-- Test 40: query (line 300)
SHOW CREATE TABLE like_mixed

-- Test 41: statement (line 319)
CREATE TABLE like_no_pk_table (
  a INT, b INT
)

-- Test 42: statement (line 324)
CREATE TABLE like_no_pk_rowid_hidden (LIKE like_no_pk_table INCLUDING INDEXES)

-- Test 43: query (line 327)
SHOW CREATE TABLE like_no_pk_rowid_hidden

-- Test 44: statement (line 337)
CREATE TABLE duplicate_column (LIKE like_table, c DECIMAL)

-- Test 45: statement (line 340)
CREATE TABLE other_table (blah INT)

-- Test 46: statement (line 345)
CREATE TABLE like_more_specifiers (LIKE like_table, z DECIMAL, INDEX(a,blah,z), LIKE other_table)

-- Test 47: query (line 348)
SHOW CREATE TABLE like_more_specifiers

-- Test 48: statement (line 367)
CREATE TABLE like_hash_base (a INT, INDEX (a) USING HASH WITH (bucket_count=4))

-- Test 49: statement (line 370)
CREATE TABLE like_hash (LIKE like_hash_base INCLUDING INDEXES)

-- Test 50: query (line 373)
SHOW CREATE TABLE like_hash

-- Test 51: statement (line 384)
DROP TABLE like_hash;

-- Test 52: statement (line 387)
CREATE TABLE like_hash (LIKE like_hash_base INCLUDING ALL)

-- Test 53: query (line 390)
SHOW CREATE TABLE like_hash

-- Test 54: statement (line 401)
CREATE TABLE regression_67196 (pk INT PRIMARY KEY, hidden INT NOT VISIBLE);

-- Test 55: statement (line 404)
CREATE TABLE regression_67196_like (LIKE regression_67196)

-- Test 56: query (line 407)
SHOW CREATE TABLE regression_67196_like

-- Test 57: statement (line 417)
CREATE TABLE error (LIKE like_hash_base INCLUDING COMMENTS)

-- Test 58: statement (line 420)
CREATE TABLE error (LIKE like_hash_base INCLUDING STATISTICS)

-- Test 59: statement (line 423)
CREATE TABLE error (LIKE like_hash_base INCLUDING STORAGE)

-- Test 60: statement (line 431)
CREATE TABLE unique_without_index (a INT UNIQUE WITHOUT INDEX)

-- Test 61: statement (line 434)
CREATE TABLE unique_without_index (a INT, b INT, UNIQUE WITHOUT INDEX (a, b))

-- Test 62: statement (line 440)
CREATE TABLE unique_without_index (a INT UNIQUE WITHOUT INDEX)

-- Test 63: statement (line 443)
CREATE TABLE unique_without_index1 (a INT, b INT, CONSTRAINT ab UNIQUE WITHOUT INDEX (a, b))

-- Test 64: query (line 446)
SELECT * FROM [SHOW CONSTRAINTS FROM unique_without_index] ORDER BY constraint_name

-- Test 65: query (line 453)
SELECT * FROM [SHOW CONSTRAINTS FROM unique_without_index1] ORDER BY constraint_name

-- Test 66: statement (line 463)
CREATE TABLE error (a INT UNIQUE WITHOUT INDEX, CONSTRAINT unique_a UNIQUE WITHOUT INDEX (a))

-- Test 67: statement (line 466)
CREATE TABLE error (a INT CHECK (a > 5), CONSTRAINT check_a CHECK (a > 5))

-- Test 68: statement (line 469)
CREATE TABLE error (a INT, b INT, UNIQUE WITHOUT INDEX (a) STORING (b))

-- Test 69: statement (line 472)
CREATE TABLE error (a INT, b INT, UNIQUE WITHOUT INDEX (a) PARTITION BY LIST (b) (
  PARTITION p1 VALUES IN (1)
))

-- Test 70: statement (line 483)
CREATE TABLE unique_without_index_partial (a INT, b INT, UNIQUE WITHOUT INDEX (a) WHERE c > 0)

-- Test 71: statement (line 486)
CREATE TABLE unique_without_index_partial (a INT, b INT, UNIQUE WITHOUT INDEX (a) WHERE b > 5)

-- Test 72: statement (line 491)
CREATE TABLE error (a INT, b INT, INDEX idx (a), INDEX idx (b))

-- Test 73: statement (line 496)
CREATE TABLE error (a INT, b INT, INDEX idx (a), UNIQUE INDEX idx (b))

-- Test 74: statement (line 499)
CREATE TABLE error (a INT, b INT, UNIQUE INDEX idx (a), UNIQUE INDEX idx (b))

-- Test 75: statement (line 502)
CREATE TABLE ctas1 AS (SELECT * FROM crdb_internal.node_statement_statistics);

-- Test 76: statement (line 505)
CREATE TABLE ctas2 AS (SELECT * FROM crdb_internal.node_transaction_statistics);

-- Test 77: statement (line 508)
CREATE TABLE ctas3 AS (SELECT * FROM crdb_internal.node_txn_stats);

-- Test 78: statement (line 512)
CREATE TABLE generated_always_t (
  a INT UNIQUE,
  b INT GENERATED ALWAYS AS IDENTITY,
  FAMILY f1 (a, b)
)

-- Test 79: query (line 519)
SHOW CREATE TABLE generated_always_t

-- Test 80: statement (line 531)
CREATE TABLE generated_by_default_t (
  a INT UNIQUE,
  b INT GENERATED BY DEFAULT AS IDENTITY,
  FAMILY f1 (a, b)
)

-- Test 81: query (line 538)
SHOW CREATE TABLE generated_by_default_t

-- Test 82: statement (line 550)
CREATE TABLE generated_always_t_notnull (a INT UNIQUE, b INT NOT NULL GENERATED ALWAYS AS IDENTITY)

-- Test 83: statement (line 553)
CREATE TABLE generated_by_default_t_notnull (a INT UNIQUE, b INT NOT NULL GENERATED BY DEFAULT AS IDENTITY)

-- Test 84: statement (line 556)
CREATE TYPE regression_72804_enum AS ENUM ()

-- Test 85: statement (line 559)
CREATE TABLE regression_72804 (
  a INT,
  b regression_72804_enum GENERATED ALWAYS AS IDENTITY
)

-- Test 86: statement (line 565)
CREATE TABLE regression_72804 (
  a INT,
  c regression_72804_enum GENERATED BY DEFAULT AS IDENTITY,
)

-- Test 87: statement (line 572)
CREATE TABLE gen_always_as_id_seqopt (
  a INT UNIQUE,
  b INT GENERATED ALWAYS AS IDENTITY (START 2 INCREMENT 3),
  FAMILY f1 (a, b)
)

-- Test 88: query (line 579)
SHOW CREATE TABLE gen_always_as_id_seqopt

-- Test 89: statement (line 591)
CREATE TABLE gen_always_as_id_seqopt_cache (
  a INT UNIQUE,
  b INT GENERATED ALWAYS AS IDENTITY (START 2 INCREMENT 3 CACHE 10),
  FAMILY f1 (a, b)
)

-- Test 90: query (line 598)
SHOW CREATE TABLE gen_always_as_id_seqopt_cache

-- Test 91: statement (line 610)
CREATE TABLE gen_by_default_as_id_seqopt (
  a INT UNIQUE,
  b INT GENERATED BY DEFAULT AS IDENTITY (START 2 INCREMENT 3),
  FAMILY f1 (a, b)
)

-- Test 92: query (line 617)
SHOW CREATE TABLE gen_by_default_as_id_seqopt

-- Test 93: statement (line 629)
CREATE TABLE gen_by_default_as_id_seqopt_cache (
  a INT UNIQUE,
  b INT GENERATED BY DEFAULT AS IDENTITY (START 2 INCREMENT 3 CACHE 10),
  FAMILY f1 (a, b)
)

-- Test 94: query (line 636)
SHOW CREATE TABLE gen_by_default_as_id_seqopt_cache

-- Test 95: statement (line 648)
CREATE SEQUENCE serial_test_sequence start 1 increment 1

-- Test 96: statement (line 663)
CREATE TABLE regression_73648 AS select * from [SHOW CLUSTER QUERIES]

-- Test 97: statement (line 669)
SET serial_normalization = sql_sequence;

-- Test 98: statement (line 672)
CREATE TABLE test_ownership_invalid_fillfactor (
        a INT PRIMARY KEY,
        b SERIAL
) with (fillfactor = 70000)

-- Test 99: statement (line 678)
CREATE TABLE test_serial (
	a INT PRIMARY KEY,
	b SERIAL
);

-- Test 100: query (line 684)
SELECT l.table_id, l.name, l.state, r.refobjid
FROM (
  SELECT table_id, name, state
  FROM crdb_internal.tables WHERE name
  LIKE 'test_serial%' AND state = 'PUBLIC'
) l
LEFT JOIN pg_catalog.pg_depend r ON l.table_id = r.objid;

-- Test 101: statement (line 697)
DROP TABLE test_serial;

-- Test 102: query (line 700)
SELECT l.table_id, l.name, l.state, r.refobjid
FROM (
  SELECT table_id, name, state
  FROM crdb_internal.tables WHERE name
  LIKE 'test_serial%' AND state = 'PUBLIC'
) l
LEFT JOIN pg_catalog.pg_depend r ON l.table_id = r.objid;

-- Test 103: statement (line 711)
CREATE TABLE test_serial (
	a INT PRIMARY KEY,
	b SERIAL
);

-- Test 104: query (line 717)
SELECT l.table_id, l.name, l.state, r.refobjid
FROM (
  SELECT table_id, name, state
  FROM crdb_internal.tables WHERE name
  LIKE 'test_serial%' AND state = 'PUBLIC'
) l
LEFT JOIN pg_catalog.pg_depend r ON l.table_id = r.objid;

-- Test 105: statement (line 730)
ALTER TABLE test_serial DROP COLUMN b;

-- Test 106: query (line 733)
SELECT l.table_id, l.name, l.state, r.refobjid
FROM (
  SELECT table_id, name, state
  FROM crdb_internal.tables WHERE name
  LIKE 'test_serial%' AND state = 'PUBLIC'
) l
LEFT JOIN pg_catalog.pg_depend r ON l.table_id = r.objid;

-- Test 107: statement (line 745)
DROP TABLE test_serial;

-- Test 108: statement (line 750)
CREATE TABLE t_bad_param (
  a INT PRIMARY KEY WITH (s2_max_level=20)
);

-- Test 109: statement (line 755)
CREATE TABLE t_bad_param (
  a INT PRIMARY KEY USING HASH WITH (s2_max_level=20)
);

-- Test 110: statement (line 760)
CREATE TABLE t_bad_param (
  a INT PRIMARY KEY WITH (bucket_count=5)
);

-- Test 111: statement (line 765)
CREATE TABLE t_bad_param (
  a INT PRIMARY KEY USING HASH WITH BUCKET_COUNT = 5 WITH (bucket_count=5)
);

-- Test 112: statement (line 770)
CREATE TABLE t_bad_param (
  a INT PRIMARY KEY USING HASH WITH BUCKET_COUNT = NULL
);

-- Test 113: statement (line 775)
CREATE TABLE t_bad_param (
  a INT NOT NULL,
  PRIMARY KEY (a) WITH (s2_max_level=20)
);

-- Test 114: statement (line 781)
CREATE TABLE t_bad_param (
  a INT NOT NULL,
  PRIMARY KEY (a) USING HASH WITH (s2_max_level=20)
);

-- Test 115: statement (line 787)
CREATE TABLE t_bad_param (
  a INT NOT NULL,
  PRIMARY KEY (a) WITH (bucket_count=5)
);

-- Test 116: statement (line 793)
CREATE TABLE t_bad_param (
  a INT NOT NULL,
  PRIMARY KEY (a) USING HASH WITH BUCKET_COUNT = 5 WITH (bucket_count=5)
);

-- Test 117: statement (line 799)
CREATE TABLE t_bad_param (
  a INT NOT NULL,
  CONSTRAINT t_bad_param_pkey PRIMARY KEY (a) WITH (s2_max_level=20)
);

-- Test 118: statement (line 805)
CREATE TABLE t_bad_param (
  a INT NOT NULL,
  CONSTRAINT t_bad_param_pkey PRIMARY KEY (a) USING HASH WITH (s2_max_level=20)
);

-- Test 119: statement (line 811)
CREATE TABLE t_bad_param (
  a INT NOT NULL,
  CONSTRAINT t_bad_param_pkey PRIMARY KEY (a) WITH (bucket_count=5)
);

-- Test 120: statement (line 817)
CREATE TABLE t_bad_param (
  a INT NOT NULL,
  CONSTRAINT t_bad_param_pkey PRIMARY KEY (a) USING HASH WITH BUCKET_COUNT = 5 WITH (bucket_count=5)
);

-- Test 121: statement (line 823)
CREATE TABLE t_bad_param (
  a INT,
  UNIQUE INDEX (a) WITH (s2_max_level=20)
);

-- Test 122: statement (line 829)
CREATE TABLE t_bad_param (
  a INT,
  UNIQUE INDEX (a) USING HASH WITH (s2_max_level=20)
);

-- Test 123: statement (line 835)
CREATE TABLE t_bad_param (
  a INT,
  UNIQUE INDEX (a) WITH (bucket_count=5)
);

-- Test 124: statement (line 841)
CREATE TABLE t_bad_param (
  a INT,
  UNIQUE INDEX (a) USING HASH WITH BUCKET_COUNT = 5 WITH (bucket_count=5)
);

-- Test 125: statement (line 847)
CREATE TABLE t_bad_param (
  a INT,
  INDEX (a) WITH (bucket_count=5)
);

-- Test 126: statement (line 853)
CREATE TABLE t_bad_param (
  a INT,
  INDEX (a) USING HASH WITH BUCKET_COUNT = 5 WITH (bucket_count=5)
);

-- Test 127: statement (line 859)
CREATE TABLE t_source (
  a INT PRIMARY KEY
);

-- Test 128: statement (line 864)
CREATE TABLE t_bad_param (
  a PRIMARY KEY WITH (s2_max_level=20)
) AS SELECT * FROM t_source;

-- Test 129: statement (line 869)
CREATE TABLE t_bad_param (
  a,
  PRIMARY KEY (a) WITH (s2_max_level=20)
) AS SELECT * FROM t_source;

-- Test 130: statement (line 877)
CREATE TABLE t_good_hash_indexes_1 (
 a INT PRIMARY KEY USING HASH WITH BUCKET_COUNT = 5,
 b INT,
 c INT,
 INDEX (b) USING HASH WITH BUCKET_COUNT = 5,
 FAMILY "primary" (a, b, c)
);

-- Test 131: query (line 886)
SELECT create_statement FROM [SHOW CREATE TABLE t_good_hash_indexes_1];

-- Test 132: statement (line 899)
CREATE TABLE t_good_hash_indexes_2 (
 a INT,
 PRIMARY KEY (a) USING HASH WITH BUCKET_COUNT = 5
);

-- Test 133: query (line 905)
SELECT create_statement FROM [SHOW CREATE TABLE t_good_hash_indexes_2];

-- Test 134: statement (line 916)
CREATE TABLE t1 (a int) WITH (sql_stats_automatic_collection_enabled = true)

-- Test 135: query (line 920)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->>'autoStatsSettings'
FROM
    crdb_internal.tables AS tbl
    INNER JOIN system.descriptor AS d ON d.id = tbl.table_id
WHERE
    tbl.name = 't1'
    AND tbl.drop_time IS NULL

-- Test 136: statement (line 933)
DROP TABLE t1

-- Test 137: statement (line 936)
CREATE TABLE t1 (a int) WITH (sql_stats_automatic_collection_fraction_stale_rows = 0.5,
                              sql_stats_automatic_collection_min_stale_rows = 4000)

-- Test 138: query (line 941)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->>'autoStatsSettings'
FROM
    crdb_internal.tables AS tbl
    INNER JOIN system.descriptor AS d ON d.id = tbl.table_id
WHERE
    tbl.name = 't1'
    AND tbl.drop_time IS NULL

-- Test 139: query (line 954)
SELECT create_statement FROM [SHOW CREATE TABLE t1]

-- Test 140: statement (line 963)
CREATE TABLE t11 (a int) WITH (sql_stats_automatic_collection_enabled = true,
                               sql_stats_automatic_collection_fraction_stale_rows = 1.797693134862315708145274237317043567981e+308,
                               sql_stats_automatic_collection_min_stale_rows = 9223372036854775807)

-- Test 141: query (line 969)
SELECT create_statement FROM [SHOW CREATE TABLE t11]

-- Test 142: statement (line 978)
CREATE TABLE t22 (a int) WITH (sql_stats_automatic_collection_fraction_stale_rows = -1.0)

-- Test 143: statement (line 981)
CREATE TABLE t22 (a int) WITH (sql_stats_automatic_collection_min_stale_rows = -1)

-- Test 144: statement (line 986)
CREATE SEQUENCE IF NOT EXISTS s

-- Test 145: statement (line 989)
DROP TABLE IF EXISTS tbl

-- Test 146: statement (line 992)
CREATE TABLE tbl (i INT PRIMARY KEY, j INT NOT NULL ON UPDATE nextval('s'), FAMILY f1 (i, j))

-- Test 147: query (line 995)
SHOW CREATE TABLE tbl

-- Test 148: statement (line 1005)
CREATE SEQUENCE IF NOT EXISTS s1

-- Test 149: statement (line 1008)
CREATE SEQUENCE IF NOT EXISTS s2

-- Test 150: statement (line 1011)
DROP TABLE IF EXISTS tbl

-- Test 151: statement (line 1014)
CREATE TABLE tbl (i INT PRIMARY KEY, j INT NOT NULL DEFAULT nextval('s1') ON UPDATE nextval('s2'), FAMILY f1 (i, j))

-- Test 152: query (line 1017)
SHOW CREATE TABLE tbl

-- Test 153: statement (line 1031)
CREATE TABLE gen_by_default_int2 (
  a INT UNIQUE,
  b INT4 GENERATED BY DEFAULT AS IDENTITY (START 2 INCREMENT 3 CACHE 10),
  c INT2 GENERATED BY DEFAULT AS IDENTITY (START 2 INCREMENT 3 CACHE 10),
  d INT GENERATED BY DEFAULT AS IDENTITY (START 2 INCREMENT 3 CACHE 10),
  FAMILY f1 (a, b)
)

-- Test 154: statement (line 1040)
SET default_int_size=4;

-- Test 155: statement (line 1043)
CREATE TABLE gen_by_default_int3 (
  a INT UNIQUE,
  b INT4 GENERATED BY DEFAULT AS IDENTITY (START 2 INCREMENT 3 CACHE 10),
  c INT2 GENERATED BY DEFAULT AS IDENTITY (START 2 INCREMENT 3 CACHE 10),
  d INT GENERATED BY DEFAULT AS IDENTITY (START 2 INCREMENT 3 CACHE 10),
  FAMILY f1 (a, b)
)

-- Test 156: statement (line 1052)
SET default_int_size=8;

-- Test 157: query (line 1056)
SELECT
  sequence_schema, sequence_name,
  data_type AS type
FROM information_schema.sequences
JOIN pg_namespace AS ns ON ns.nspname = sequence_schema
JOIN pg_class AS cls ON cls.relnamespace = ns.oid AND cls.relname = sequence_name;

-- Test 158: statement (line 1093)
CREATE TABLE t_115352 (i INT, UNIQUE WITHOUT INDEX (i) NOT VALID);

-- Test 159: query (line 1098)
SELECT create_statement FROM [SHOW CREATE t_115352];

-- Test 160: statement (line 1111)


-- Test 161: statement (line 1115)
SET inject_retry_errors_enabled=true

-- Test 162: statement (line 1118)
CREATE TABLE t_125619 (i INT8, j INT8, INDEX ((i + j)));

-- Test 163: statement (line 1121)
ALTER TABLE t_125619 ADD CONSTRAINT uni UNIQUE ((i + j + i))

-- Test 164: statement (line 1124)
SET inject_retry_errors_enabled=false

-- Test 165: statement (line 1134)
CREATE TABLE v_133399 (c01 INT);

-- Test 166: statement (line 1137)
CREATE TABLE t_133399 AS (SELECT * FROM v_133399 WINDOW window_name AS (ROWS c01 BETWEEN nextval ('abc', 'abc', 'abc') AND c01 PRECEDING));

-- Test 167: statement (line 1144)
CREATE TABLE IF NOT EXISTS t1 (
  id1 UUID NOT NULL DEFAULT gen_random_uuid(),
  id2 UUID NOT NULL DEFAULT gen_random_uuid(),
  ts TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  val JSONB,
  PRIMARY KEY(id1, id2)
);

-- Test 168: query (line 1155)
CREATE TABLE t2 AS SELECT * FROM t1;

-- Test 169: statement (line 1164)
CREATE TABLE create_table_with_duplicate_storage_params_a (
  a INT PRIMARY KEY,
  b TEXT NOT NULL
) WITH (fillfactor=10, fillfactor=15);

-- Test 170: statement (line 1170)
CREATE TABLE IF NOT EXISTS create_table_with_duplicate_storage_params_b (
  a INT
) WITH (fillfactor=10, fillfactor=20);

-- Test 171: statement (line 1179)
CREATE TABLE create_table_with_as_duplicate_storage_params_a (a INT);

-- Test 172: statement (line 1182)
CREATE TABLE create_table_with_as_duplicate_storage_params_b (a) WITH (fillfactor=10, fillfactor=20) AS (SELECT * FROM create_table_with_as_duplicate_storage_params_a);

-- Test 173: statement (line 1185)
CREATE TABLE IF NOT EXISTS create_table_with_as_duplicate_storage_params_c (a) WITH (fillfactor=10, fillfactor=20) AS (SELECT * FROM create_table_with_as_duplicate_storage_params_a);

-- Test 174: statement (line 1193)
CREATE TABLE create_table_primary_key_with_duplicate_storage_params_a (a INT PRIMARY KEY USING HASH WITH (bucket_count=10, bucket_count=20));

-- Test 175: statement (line 1200)
CREATE TABLE create_table_index_elem_duplicate_storage_params_a (
  a INT PRIMARY KEY,
  b INT,
  INDEX (b) WITH (fillfactor=10, fillfactor=20)
);

-- Test 176: statement (line 1207)
CREATE TABLE create_table_index_elem_duplicate_storage_params_b (
  a INT PRIMARY KEY,
  b INT,
  INDEX b_idx (b) WITH (fillfactor=10, fillfactor=20)
);

-- Test 177: statement (line 1214)
CREATE TABLE create_table_index_elem_duplicate_storage_params_c (
  a INT PRIMARY KEY,
  b INT,
  UNIQUE INDEX (b) USING HASH WITH (bucket_count=10, bucket_count=20)
);

-- Test 178: statement (line 1221)
CREATE TABLE create_table_index_elem_duplicate_storage_params_d (
  a INT PRIMARY KEY,
  b JSONB,
  INVERTED INDEX (b) WITH (fillfactor=10, fillfactor=20)
);

-- Test 179: statement (line 1228)
CREATE TABLE create_table_index_elem_duplicate_storage_params_e (
  a INT,
  PRIMARY KEY (a) USING HASH WITH (bucket_count=10, bucket_count=20)
);

-- Test 180: statement (line 1236)
CREATE TABLE not_indexable (COL1 INT PRIMARY KEY, COL2 REFCURSOR, COL3 REFCURSOR, INDEX (COL2, COL3))

-- Test 181: statement (line 1241)
SET CLUSTER SETTING feature.infer_rbr_region_col_using_constraint.enabled = true;

-- Test 182: statement (line 1244)
CREATE TABLE parent (k INT PRIMARY KEY);

-- Test 183: statement (line 1249)
CREATE TABLE t_infer_rbr_region_col (
  a INT PRIMARY KEY,
  b INT,
  CONSTRAINT foo FOREIGN KEY (b) REFERENCES parent(k)
) WITH (infer_rbr_region_col_using_constraint = foo);

-- Test 184: statement (line 1256)
RESET CLUSTER SETTING feature.infer_rbr_region_col_using_constraint.enabled;

