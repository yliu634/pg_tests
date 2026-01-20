-- PostgreSQL compatible tests from schema_locked
-- 62 tests

-- Test 1: statement (line 3)
SET create_table_with_schema_locked=false

-- Test 2: statement (line 6)
CREATE TABLE t (i INT PRIMARY KEY) WITH (schema_locked = t);

-- Test 3: query (line 9)
show create table t

-- Test 4: statement (line 17)
ALTER TABLE t RESET (schema_locked);

-- Test 5: query (line 20)
show create table t

-- Test 6: statement (line 28)
ALTER TABLE t SET (schema_locked = true);

-- Test 7: query (line 31)
show create table t

-- Test 8: statement (line 39)
ALTER TABLE t RESET (schema_locked)

-- Test 9: statement (line 42)
DROP TABLE t;

-- Test 10: statement (line 49)
CREATE TABLE t (i INT PRIMARY KEY) WITH (schema_locked = t);

-- Test 11: statement (line 58)
ALTER TABLE t SET (schema_locked=f); CREATE TABLE t2 (i INT PRIMARY KEY);

-- Test 12: statement (line 61)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 13: statement (line 64)
SET LOCAL autocommit_before_ddl=off;

-- Test 14: statement (line 67)
ALTER TABLE t SET (schema_locked=f);

-- Test 15: statement (line 70)
ROLLBACK

-- Test 16: statement (line 73)
ALTER TABLE t RESET (schema_locked)

-- Test 17: statement (line 76)
DROP TABLE t

-- Test 18: statement (line 85)
CREATE TABLE t (i INT PRIMARY KEY, j INT, UNIQUE INDEX idx (j)) WITH (schema_locked = t);

-- Test 19: statement (line 88)
INSERT INTO t SELECT i, i+1 FROM generate_series(1,10) AS tmp(i);

onlyif config local-legacy-schema-changer

-- Test 20: statement (line 92)
ALTER TABLE t ADD COLUMN k INT DEFAULT 30;

onlyif config local-legacy-schema-changer

-- Test 21: statement (line 96)
ALTER TABLE t DROP COLUMN j;

onlyif config local-legacy-schema-changer

-- Test 22: statement (line 100)
DROP INDEX idx;

onlyif config local-legacy-schema-changer

-- Test 23: statement (line 104)
CREATE INDEX idx2 ON t(j);

-- Test 24: statement (line 107)
CREATE TABLE ref (a INT PRIMARY KEY, b INT)

-- Test 25: statement (line 112)
ALTER TABLE ref ADD CONSTRAINT fk FOREIGN KEY (b) REFERENCES t(j);

-- Test 26: statement (line 117)
GRANT DELETE ON TABLE t TO testuser WITH GRANT OPTION;

-- Test 27: statement (line 122)
COMMENT ON TABLE t IS 't is a table';
COMMENT ON INDEX t@idx IS 'idx is an index';
COMMENT ON COLUMN t.i IS 'i is a column';

-- Test 28: statement (line 132)
ALTER TABLE t ADD COLUMN k INT DEFAULT 30;

skipif config local-legacy-schema-changer

-- Test 29: statement (line 136)
CREATE INDEX idx2 ON t(j);

skipif config local-legacy-schema-changer

-- Test 30: statement (line 140)
DROP INDEX idx2;

skipif config local-legacy-schema-changer

-- Test 31: statement (line 144)
ALTER TABLE ref ADD CONSTRAINT fk FOREIGN KEY (b) REFERENCES t(j);

skipif config local-legacy-schema-changer

-- Test 32: statement (line 148)
ALTER TABLE t DROP COLUMN j CASCADE;

-- Test 33: query (line 152)
SELECT count(create_statement) FROM [SHOW CREATE TABLE t] WHERE create_statement LIKE '%schema_locked = true%'

-- Test 34: statement (line 158)
ALTER TABLE t SET (schema_locked = false);

-- Test 35: statement (line 162)
DROP TABLE t;

-- Test 36: statement (line 168)
ALTER TABLE ref SET (schema_locked = true);

-- Test 37: statement (line 172)
ALTER TABLE ref CONFIGURE ZONE USING num_replicas = 11;

-- Test 38: statement (line 180)
CREATE TABLE t_sl (i INT PRIMARY KEY) WITH (schema_locked = false)

-- Test 39: statement (line 184)
ALTER TABLE t_sl SET (schema_locked=true)

-- Test 40: query (line 187)
SHOW CREATE TABLE t_sl

-- Test 41: statement (line 196)
ALTER TABLE t_sl SET (schema_locked=false)

-- Test 42: query (line 199)
SHOW CREATE TABLE t_sl

-- Test 43: statement (line 207)
SET create_table_with_schema_locked = 'true'

-- Test 44: statement (line 211)
ALTER TABLE t_sl RESET (schema_locked)

-- Test 45: query (line 214)
SHOW CREATE TABLE t_sl

-- Test 46: statement (line 222)
SET create_table_with_schema_locked = 'false'

-- Test 47: statement (line 226)
ALTER TABLE t_sl RESET (schema_locked)

-- Test 48: query (line 229)
SHOW CREATE TABLE t_sl

-- Test 49: statement (line 237)
DROP TABLE t_sl

-- Test 50: statement (line 246)
CREATE TABLE t_147993 (
  k INT8 NOT NULL,
  geom1 GEOMETRY(POINT,4326) NULL,
  geom2 GEOMETRY(POLYGON,4326) NULL,
  geom3 GEOMETRY(MULTIPOLYGON,4326) NULL,
  geom4 GEOMETRY(LINESTRING,4326) NULL,
  geom5 GEOMETRY(MULTIPOINT,4326) NULL,
  geom6 GEOMETRY(MULTILINESTRING,4326) NULL,
  CONSTRAINT t_147993_pkey PRIMARY KEY (k ASC),
  FAMILY fam (k, geom1, geom2, geom3, geom6)
) WITH (schema_locked = true);


skipif config local-legacy-schema-changer

-- Test 51: statement (line 261)
SELECT  AddGeometryColumn ('t_147993','geom7',4326,'POINT',2),
        AddGeometryColumn ('t_147993','geom8',4326,'POINT',2);



skipif config local-legacy-schema-changer

-- Test 52: query (line 268)
show create table t_147993

-- Test 53: statement (line 293)
CREATE TABLE t_150484 (n INT, m INT, FAMILY (n, m)) WITH (schema_locked=true);

-- Test 54: statement (line 298)
ALTER TABLE t_150484 SET (schema_locked=false), DROP COLUMN n;

-- Test 55: statement (line 303)
ALTER TABLE t_150484 RESET (schema_locked), ADD COLUMN k INT;

-- Test 56: query (line 308)
SHOW CREATE TABLE t_150484

-- Test 57: statement (line 322)
ALTER TABLE t_150484 SET (schema_locked=false), DROP COLUMN n;

skipif config local-legacy-schema-changer local-mixed-25.4

-- Test 58: query (line 326)
SHOW CREATE TABLE t_150484

-- Test 59: statement (line 337)
ALTER TABLE t_150484 SET (schema_locked=true)

skipif config local-legacy-schema-changer local-mixed-25.4

-- Test 60: statement (line 341)
ALTER TABLE t_150484 RESET (schema_locked), ADD COLUMN k INT;

skipif config local-legacy-schema-changer local-mixed-25.4

-- Test 61: query (line 345)
SHOW CREATE TABLE t_150484

-- Test 62: statement (line 356)
DROP TABLE t_150484;

