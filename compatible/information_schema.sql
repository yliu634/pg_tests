-- PostgreSQL compatible tests from information_schema
-- 275 tests

-- Test 1: query (line 9)
ALTER DATABASE information_schema RENAME TO not_information_schema

statement error schema cannot be modified: "information_schema"
CREATE TABLE information_schema.t (x INT)

query error database "information_schema" does not exist
DROP DATABASE information_schema

query TTTTIT rowsort
SHOW TABLES FROM information_schema

-- Test 2: statement (line 111)
CREATE DATABASE other_db

-- Test 3: statement (line 114)
ALTER DATABASE other_db RENAME TO information_schema

-- Test 4: statement (line 117)
CREATE DATABASE information_schema

-- Test 5: statement (line 120)
DROP DATABASE information_schema CASCADE

-- Test 6: statement (line 126)
ALTER TABLE information_schema.tables RENAME TO information_schema.bad

-- Test 7: statement (line 129)
ALTER TABLE information_schema.tables RENAME COLUMN x TO y

-- Test 8: statement (line 132)
ALTER TABLE information_schema.tables ADD COLUMN x DECIMAL

-- Test 9: statement (line 135)
ALTER TABLE information_schema.tables DROP COLUMN x

-- Test 10: statement (line 138)
ALTER TABLE information_schema.tables ADD CONSTRAINT foo UNIQUE (b)

-- Test 11: statement (line 141)
ALTER TABLE information_schema.tables DROP CONSTRAINT bar

-- Test 12: statement (line 144)
ALTER TABLE information_schema.tables ALTER COLUMN x SET DEFAULT 'foo'

-- Test 13: statement (line 147)
ALTER TABLE information_schema.tables ALTER x DROP NOT NULL

-- Test 14: statement (line 150)
ALTER TABLE information_schema.collation_character_set_applicability ALTER x DROP NOT NULL

-- Test 15: statement (line 153)
ALTER TABLE information_schema.collations ALTER x DROP NOT NULL

-- Test 16: statement (line 156)
CREATE INDEX i on information_schema.tables (x)

-- Test 17: statement (line 159)
DROP TABLE information_schema.tables

-- Test 18: statement (line 162)
DROP INDEX information_schema.tables@i

-- Test 19: statement (line 165)
ALTER TABLE information_schema.session_variables ALTER x DROP NOT NULL

-- Test 20: query (line 170)
DELETE FROM information_schema.tables

query error user root does not have INSERT privilege on relation tables
INSERT INTO information_schema.tables VALUES ('abc')

statement error user root does not have UPDATE privilege on relation tables
UPDATE information_schema.tables SET a = 'abc'

statement error tables is a virtual object and cannot be modified
TRUNCATE TABLE information_schema.tables

# Verify information_schema collation_character_set_applicability handles read-only property correctly.

query error user root does not have DELETE privilege on relation collation_character_set_applicability
DELETE FROM information_schema.collation_character_set_applicability

query error user root does not have INSERT privilege on relation collation_character_set_applicability
INSERT INTO information_schema.collation_character_set_applicability VALUES ('abc')

statement error user root does not have UPDATE privilege on relation collation_character_set_applicability
UPDATE information_schema.collation_character_set_applicability SET a = 'abc'

statement error collation_character_set_applicability is a virtual object and cannot be modified
TRUNCATE TABLE information_schema.collation_character_set_applicability

# Verify information_schema collations handles read-only property correctly.

query error user root does not have DELETE privilege on relation collations
DELETE FROM information_schema.collations

query error user root does not have INSERT privilege on relation collations
INSERT INTO information_schema.collations VALUES ('abc')

statement error user root does not have UPDATE privilege on relation collations
UPDATE information_schema.collations SET a = 'abc'

statement error collations is a virtual object and cannot be modified
TRUNCATE TABLE information_schema.collations

# Verify information_schema session_variables handles read-only property correctly.

query error user root does not have DELETE privilege on relation session_variables
DELETE FROM information_schema.session_variables

query error user root does not have INSERT privilege on relation session_variables
INSERT INTO information_schema.session_variables VALUES ('abc')

statement error user root does not have UPDATE privilege on relation session_variables
UPDATE information_schema.session_variables SET a = 'abc'

statement error session_variables is a virtual object and cannot be modified
TRUNCATE TABLE information_schema.session_variables

# Verify information_schema handles reflection correctly.

query TTTTTT rowsort
SHOW DATABASES

-- Test 21: query (line 234)
SHOW TABLES FROM test.information_schema

-- Test 22: query (line 325)
SHOW CREATE TABLE information_schema.tables

-- Test 23: query (line 338)
SHOW COLUMNS FROM information_schema.tables

-- Test 24: query (line 349)
SHOW INDEXES FROM information_schema.tables

-- Test 25: query (line 354)
SHOW CONSTRAINTS FROM information_schema.tables

-- Test 26: query (line 359)
SHOW GRANTS ON information_schema.tables

-- Test 27: query (line 370)
SELECT * FROM information_schema.schemata

-- Test 28: query (line 380)
SELECT * FROM INFormaTION_SCHEMa.schemata

-- Test 29: query (line 394)
select table_schema, table_name FROM information_schema.tables
WHERE (table_schema <> 'crdb_internal' OR table_name = 'node_build_info');

-- Test 30: statement (line 619)
CREATE DATABASE other_db

-- Test 31: statement (line 622)
CREATE TABLE other_db.xyz (i INT)

-- Test 32: statement (line 625)
CREATE SEQUENCE other_db.seq

-- Test 33: statement (line 628)
CREATE VIEW other_db.abc AS SELECT i from other_db.xyz

-- Test 34: statement (line 631)
GRANT UPDATE ON other_db.xyz TO testuser

user testuser

-- Test 35: query (line 639)
SELECT table_name FROM information_schema.tables WHERE table_catalog = 'other_db'

-- Test 36: query (line 644)
SELECT table_name FROM other_db.information_schema.tables WHERE table_catalog = 'other_db' AND table_schema = 'public'

-- Test 37: query (line 651)
SELECT table_name FROM "".information_schema.tables WHERE table_catalog = 'other_db'
AND (table_schema <> 'crdb_internal' OR table_name = 'node_build_info')

-- Test 38: query (line 879)
SET DATABASE = other_db; SELECT table_name FROM information_schema.tables WHERE table_catalog = 'other_db' AND table_schema = 'public'

-- Test 39: query (line 888)
SET DATABASE = ''; SELECT table_name FROM information_schema.tables WHERE table_catalog = 'other_db' AND table_schema = 'public'

-- Test 40: query (line 895)
SET DATABASE = test; SELECT table_name FROM information_schema.tables WHERE table_schema = 'other_db'

-- Test 41: query (line 900)
CREATE SCHEMA myschema;
CREATE TABLE myschema.abc();
CREATE TABLE abc();
SELECT table_schema, table_name FROM information_schema.tables WHERE table_name = 'abc';

-- Test 42: query (line 910)
SELECT table_name FROM other_db.information_schema.tables WHERE table_name > 't'  ORDER BY 1 DESC

-- Test 43: query (line 950)
SELECT table_catalog, table_schema, table_name, table_type, is_insertable_into
FROM system.information_schema.tables
WHERE
(table_schema <> 'crdb_internal' OR table_name = 'node_build_info')
AND NOT (table_schema = 'public' AND table_name <> 'locations')
ORDER BY table_name, table_schema

-- Test 44: statement (line 1181)
ALTER TABLE other_db.xyz ADD COLUMN j INT

onlyif config schema-locked-disabled

-- Test 45: query (line 1185)
SELECT table_catalog, table_name, version
  FROM "".information_schema.tables
 WHERE table_catalog != 'system' AND version > 1 AND table_schema = 'public' ORDER BY 1,2

-- Test 46: query (line 1194)
SELECT table_catalog, table_name, version
  FROM "".information_schema.tables
 WHERE table_catalog != 'system' AND version > 1 AND table_schema = 'public' ORDER BY 1,2

-- Test 47: query (line 1207)
SELECT * FROM other_db.information_schema.tables
WHERE table_catalog = 'other_db' AND table_schema = 'public'
ORDER BY table_name

-- Test 48: query (line 1217)
SELECT * FROM other_db.information_schema.tables
WHERE table_catalog = 'other_db' AND table_schema = 'public'
ORDER BY table_name

-- Test 49: statement (line 1228)
GRANT SELECT ON other_db.abc TO testuser

user testuser

-- Test 50: query (line 1235)
SELECT * FROM other_db.information_schema.tables WHERE table_catalog = 'other_db' AND table_schema = 'public' ORDER BY 1, 3

-- Test 51: query (line 1243)
SELECT * FROM other_db.information_schema.tables WHERE table_catalog = 'other_db' AND table_schema = 'public' ORDER BY 1, 3

-- Test 52: statement (line 1252)
DROP DATABASE other_db CASCADE

-- Test 53: statement (line 1255)
SET DATABASE = test

-- Test 54: query (line 1263)
SELECT *
FROM system.information_schema.table_constraints
WHERE NOT (table_catalog = 'system' AND table_schema = 'public' AND table_name <> 'locations')
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME

-- Test 55: query (line 1276)
SELECT *
FROM system.information_schema.character_sets

-- Test 56: query (line 1287)
SELECT *
FROM system.information_schema.check_constraints
ORDER BY CONSTRAINT_CATALOG, CONSTRAINT_NAME

-- Test 57: query (line 1612)
SELECT *
FROM system.information_schema.constraint_column_usage
WHERE NOT (table_catalog = 'system' AND table_schema = 'public' AND table_name <> 'locations')
ORDER BY TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME

-- Test 58: query (line 1622)
SELECT *
FROM system.information_schema.constraint_column_usage
WHERE NOT (table_catalog = 'system' AND table_schema = 'public' AND table_name <> 'locations')
ORDER BY TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME

-- Test 59: statement (line 1632)
CREATE DATABASE constraint_db

-- Test 60: statement (line 1635)
CREATE TABLE constraint_db.t1 (
  p FLOAT PRIMARY KEY,
  a INT UNIQUE CHECK (a > 4),
  CONSTRAINT c2 CHECK (a < 99)
)

-- Test 61: statement (line 1642)
CREATE TABLE constraint_db.t2 (
    t1_ID INT,
    CONSTRAINT fk FOREIGN KEY (t1_ID) REFERENCES constraint_db.t1(a),
    INDEX (t1_ID)
)

-- Test 62: statement (line 1649)
SET DATABASE = constraint_db

-- Test 63: query (line 1652)
SELECT *
FROM information_schema.table_constraints
ORDER BY TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME

-- Test 64: query (line 1667)
SELECT *
FROM information_schema.check_constraints
ORDER BY CONSTRAINT_CATALOG, CONSTRAINT_NAME

-- Test 65: query (line 1677)
SELECT *
FROM information_schema.constraint_column_usage
WHERE constraint_catalog = 'constraint_db'
ORDER BY TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME

-- Test 66: query (line 1692)
SELECT tc.table_schema, tc.table_name, cc.constraint_name, cc.check_clause
FROM information_schema.table_constraints AS tc
JOIN information_schema.check_constraints AS cc
USING (constraint_catalog, constraint_schema, constraint_name)
WHERE tc.table_schema in ('public')
ORDER BY tc.table_schema, tc.table_name, cc.constraint_name

-- Test 67: statement (line 1705)
DROP DATABASE constraint_db CASCADE

-- Test 68: statement (line 1710)
SET DATABASE = test;

-- Test 69: statement (line 1713)
CREATE TABLE t2(a smallint DEFAULT 0);

-- Test 70: query (line 1716)
select data_type, column_default from information_schema.columns where table_name = 't2' and column_name = 'a';

-- Test 71: query (line 1722)
SELECT table_catalog, table_schema, table_name, column_name, ordinal_position
FROM system.information_schema.columns
WHERE table_schema != 'information_schema' AND table_schema != 'pg_catalog' AND table_schema != 'crdb_internal'
AND NOT (table_catalog = 'system' AND table_schema = 'public' AND table_name NOT IN ('locations', 'comments'))
ORDER BY 3,4

-- Test 72: statement (line 1758)
SET DATABASE = test

-- Test 73: query (line 1764)
SELECT table_name, column_name, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'with_defaults'

-- Test 74: statement (line 1776)
DROP TABLE with_defaults

-- Test 75: query (line 1782)
SELECT table_name, column_name, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'nullability'

-- Test 76: statement (line 1794)
DROP TABLE nullability

-- Test 77: query (line 1846)
SELECT table_name, column_name, data_type, crdb_sql_type, udt_catalog, udt_schema, udt_name, collation_catalog, collation_schema, collation_name
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'data_types'
ORDER BY column_name

-- Test 78: statement (line 1900)
DROP TABLE data_types

-- Test 79: statement (line 1903)
CREATE TABLE computed (a INT, b INT AS (a + 1) STORED)

-- Test 80: query (line 1906)
SELECT column_name, is_generated, generation_expression, is_updatable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'computed'
ORDER BY column_name

-- Test 81: statement (line 1917)
CREATE TABLE generated_as_identity (
  a INT,
  b INT GENERATED ALWAYS AS IDENTITY,
  c INT GENERATED BY DEFAULT AS IDENTITY
)

-- Test 82: query (line 1924)
SELECT column_name, is_identity, identity_generation, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'generated_as_identity'
ORDER BY column_name

-- Test 83: statement (line 1936)
CREATE DATABASE test_identity

-- Test 84: statement (line 1939)
SET DATABASE = test_identity

-- Test 85: statement (line 1942)
CREATE TABLE add_generated_as_identity (
  a INT NOT NULL,
  b INT NOT NULL
) WITH (schema_locked=false)

-- Test 86: statement (line 1948)
ALTER TABLE add_generated_as_identity ALTER COLUMN a ADD GENERATED ALWAYS AS IDENTITY (START WITH 10 INCREMENT BY 2);

-- Test 87: statement (line 1951)
ALTER TABLE add_generated_as_identity ALTER COLUMN b ADD GENERATED BY DEFAULT AS IDENTITY (START WITH 10 INCREMENT BY 2);

-- Test 88: query (line 1954)
SELECT column_name, is_identity, identity_generation, is_nullable, column_default, identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'add_generated_as_identity'
ORDER BY column_name

-- Test 89: statement (line 1965)
CREATE TABLE set_generated_as_identity (
  a INT GENERATED ALWAYS AS IDENTITY (START WITH 10),
  b INT GENERATED BY DEFAULT AS IDENTITY (START WITH 10)
) WITH (schema_locked=false)

-- Test 90: statement (line 1971)
ALTER TABLE set_generated_as_identity ALTER COLUMN a SET GENERATED BY DEFAULT;

-- Test 91: statement (line 1974)
ALTER TABLE set_generated_as_identity ALTER COLUMN b SET GENERATED ALWAYS;

-- Test 92: query (line 1977)
SELECT column_name, is_identity, identity_generation, is_nullable, column_default, identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'set_generated_as_identity'
ORDER BY column_name

-- Test 93: statement (line 1988)
CREATE TABLE drop_generated_as_identity (a INT GENERATED ALWAYS AS IDENTITY (START WITH 10)) WITH (schema_locked=false)

-- Test 94: statement (line 1991)
ALTER TABLE drop_generated_as_identity ALTER COLUMN a DROP IDENTITY;

-- Test 95: query (line 1994)
SELECT column_name, is_identity, identity_generation, is_nullable, column_default, identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'drop_generated_as_identity'
ORDER BY column_name

-- Test 96: query (line 2004)
SELECT * FROM information_schema.sequences ORDER BY sequence_name

-- Test 97: statement (line 2013)
CREATE TABLE alter_opts_generated_as_identity (a INT GENERATED ALWAYS AS IDENTITY (START WITH 2)) WITH (schema_locked=false)

-- Test 98: query (line 2016)
SELECT column_name, is_identity, identity_generation, is_nullable, column_default, identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle
FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'alter_opts_generated_as_identity' AND column_name = 'a'

-- Test 99: query (line 2023)
SELECT * FROM information_schema.sequences WHERE sequence_name = 'alter_opts_generated_as_identity_a_seq'

-- Test 100: statement (line 2029)
ALTER TABLE alter_opts_generated_as_identity ALTER COLUMN a SET INCREMENT BY 2;

-- Test 101: query (line 2032)
SELECT * FROM information_schema.sequences WHERE sequence_name = 'alter_opts_generated_as_identity_a_seq'

-- Test 102: query (line 2038)
SELECT column_name, is_identity, identity_generation, is_nullable, column_default, identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle
FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'alter_opts_generated_as_identity' AND column_name = 'a'

-- Test 103: query (line 2045)
SELECT * FROM information_schema.sequences WHERE sequence_name = 'alter_opts_generated_as_identity_a_seq'

-- Test 104: statement (line 2051)
ALTER TABLE alter_opts_generated_as_identity ALTER COLUMN a SET MAXVALUE 40 SET START WITH 2 SET CACHE 5 SET INCREMENT BY 2;

-- Test 105: query (line 2054)
SELECT column_name, is_identity, identity_generation, is_nullable, column_default, identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle
FROM information_schema.columns WHERE table_schema = 'public' AND table_name = 'alter_opts_generated_as_identity' AND column_name = 'a'

-- Test 106: query (line 2061)
SELECT * FROM information_schema.sequences WHERE sequence_name = 'alter_opts_generated_as_identity_a_seq'

-- Test 107: statement (line 2067)
SET DATABASE = test

-- Test 108: query (line 2081)
SELECT table_name, column_name, character_maximum_length, character_octet_length
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'char_len'

-- Test 109: statement (line 2104)
DROP TABLE char_len

-- Test 110: statement (line 2107)
CREATE TABLE num_prec (a INT, b FLOAT, c FLOAT(23), d DECIMAL, e DECIMAL(12), f DECIMAL(12, 6), g BOOLEAN)

-- Test 111: query (line 2110)
SELECT table_name, column_name, numeric_precision, numeric_precision_radix, numeric_scale, datetime_precision
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'num_prec'

-- Test 112: statement (line 2125)
DROP TABLE num_prec

-- Test 113: statement (line 2128)
CREATE TABLE time_prec (
  a TIME,
  b TIME(0),
  c TIMETZ,
  d TIMETZ(1),
  e TIMESTAMP,
  f TIMESTAMP(2),
  g TIMESTAMPTZ,
  h TIMESTAMPTZ(3),
  i INTERVAL,
  j INTERVAL(6))

-- Test 114: query (line 2141)
SELECT table_name, column_name, numeric_precision, numeric_precision_radix, numeric_scale, datetime_precision
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'time_prec'

-- Test 115: statement (line 2159)
DROP TABLE time_prec

-- Test 116: query (line 2170)
SELECT table_catalog, table_schema, table_name, column_name, column_comment
FROM information_schema.columns
WHERE table_name = 't1'

-- Test 117: statement (line 2181)
COMMENT ON COLUMN public.t1.id IS 'identification'

-- Test 118: statement (line 2184)
COMMENT ON COLUMN public.t1.name IS 'character'

-- Test 119: query (line 2187)
SELECT table_catalog, table_schema, table_name, column_name, column_comment
FROM information_schema.columns
WHERE table_name = 't1'

-- Test 120: query (line 2198)
SELECT table_catalog, table_schema, table_name, column_name, column_comment
FROM information_schema.columns
WHERE table_name = 't1' AND column_comment != ''

-- Test 121: statement (line 2207)
DROP TABLE t1

-- Test 122: statement (line 2213)
CREATE DATABASE constraint_column

-- Test 123: statement (line 2216)
CREATE TABLE constraint_column.t1 (
  p FLOAT PRIMARY KEY,
  a INT UNIQUE,
  b INT,
  c INT CHECK(c > 0),
  UNIQUE INDEX index_key(b, c)
)

-- Test 124: statement (line 2225)
CREATE TABLE constraint_column.t2 (
    t1_ID INT PRIMARY KEY,
    CONSTRAINT fk FOREIGN KEY (t1_ID) REFERENCES constraint_column.t1(a) ON DELETE RESTRICT
)

-- Test 125: statement (line 2231)
CREATE TABLE constraint_column.t3 (
    a INT,
    b INT,
    CONSTRAINT fk2 FOREIGN KEY (a, b) REFERENCES constraint_column.t1(b, c) ON UPDATE CASCADE,
    INDEX (a, b)
)

-- Test 126: statement (line 2258)
SET DATABASE = constraint_column

-- Test 127: query (line 2261)
SELECT * FROM information_schema.key_column_usage WHERE constraint_schema = 'public' ORDER BY TABLE_NAME, CONSTRAINT_NAME, ORDINAL_POSITION

-- Test 128: query (line 2283)
SELECT * FROM information_schema.referential_constraints WHERE constraint_schema = 'public' ORDER BY TABLE_NAME, CONSTRAINT_NAME

-- Test 129: statement (line 2292)
DROP DATABASE constraint_column CASCADE

-- Test 130: statement (line 2297)
CREATE DATABASE other_db; SET DATABASE = other_db

-- Test 131: statement (line 2300)
CREATE SCHEMA other_schema

-- Test 132: query (line 2303)
SELECT * FROM information_schema.schema_privileges

-- Test 133: statement (line 2318)
GRANT CONNECT ON DATABASE other_db TO testuser

-- Test 134: query (line 2321)
SELECT * FROM information_schema.schema_privileges

-- Test 135: statement (line 2336)
GRANT CREATE ON SCHEMA other_schema TO testuser

-- Test 136: query (line 2339)
SELECT * FROM information_schema.schema_privileges

-- Test 137: query (line 2358)
SELECT * FROM system.information_schema.table_privileges
WHERE
  (table_schema <> 'crdb_internal' OR table_name = 'node_build_info') AND
  NOT (table_catalog = 'system' AND table_schema = 'public' AND 'table_name' <> 'locations')
ORDER BY table_schema, table_name, table_schema, grantee, privilege_type

-- Test 138: query (line 2587)
SELECT * FROM system.information_schema.role_table_grants
WHERE
(table_schema <> 'crdb_internal' OR table_name = 'node_build_info')
AND NOT (table_schema = 'public' AND table_name <> 'locations');

-- Test 139: statement (line 2823)
USE other_db;

-- Test 140: statement (line 2826)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser;

-- Test 141: statement (line 2829)
CREATE TABLE other_db.xyz (i INT)

-- Test 142: statement (line 2832)
USE test;

-- Test 143: statement (line 2835)
CREATE VIEW other_db.abc AS SELECT i from other_db.xyz

-- Test 144: query (line 2838)
SELECT * FROM other_db.information_schema.table_privileges WHERE TABLE_SCHEMA = 'public'

-- Test 145: query (line 2849)
SELECT * FROM other_db.information_schema.role_table_grants WHERE TABLE_SCHEMA = 'public'

-- Test 146: statement (line 2860)
GRANT UPDATE ON other_db.xyz TO testuser

-- Test 147: query (line 2863)
SELECT * FROM other_db.information_schema.table_privileges WHERE TABLE_SCHEMA = 'public'

-- Test 148: query (line 2875)
SELECT * FROM other_db.information_schema.role_table_grants WHERE TABLE_SCHEMA = 'public'

-- Test 149: statement (line 2890)
SET DATABASE = other_db

-- Test 150: query (line 2893)
SELECT * FROM information_schema.table_privileges WHERE TABLE_SCHEMA = 'public'

-- Test 151: query (line 2905)
SELECT * FROM information_schema.role_table_grants WHERE TABLE_SCHEMA = 'public'

-- Test 152: statement (line 2917)
SET DATABASE = test

user root

-- Test 153: query (line 2927)
SELECT * FROM other_db.information_schema.statistics WHERE table_schema='public' AND table_name='teststatics' ORDER BY INDEX_SCHEMA,INDEX_NAME,SEQ_IN_INDEX

-- Test 154: statement (line 2942)
CREATE VIEW other_db.v_xyz AS SELECT i FROM other_db.xyz

-- Test 155: query (line 2945)
SELECT TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, VIEW_DEFINITION, CHECK_OPTION
FROM other_db.information_schema.views
WHERE TABLE_NAME='v_xyz'

-- Test 156: query (line 2953)
SELECT IS_UPDATABLE, IS_INSERTABLE_INTO, IS_TRIGGER_UPDATABLE, IS_TRIGGER_DELETABLE, IS_TRIGGER_INSERTABLE_INTO
FROM other_db.information_schema.views
WHERE TABLE_NAME='v_xyz'

-- Test 157: statement (line 2961)
SET DATABASE = 'test'

-- Test 158: statement (line 2964)
DROP DATABASE other_db CASCADE

-- Test 159: query (line 2969)
SELECT * FROM information_schema.user_privileges ORDER BY grantee,privilege_type

-- Test 160: statement (line 3002)
SET DATABASE = test

-- Test 161: query (line 3005)
SELECT * FROM information_schema.sequences

-- Test 162: statement (line 3011)
CREATE SEQUENCE test_seq

-- Test 163: statement (line 3014)
CREATE SEQUENCE test_seq_2 INCREMENT -1 MINVALUE 5 MAXVALUE 1000 START WITH 15

-- Test 164: statement (line 3017)
CREATE SEQUENCE test_seq_3 AS smallint

-- Test 165: statement (line 3020)
CREATE SEQUENCE test_seq_4 AS integer

-- Test 166: statement (line 3023)
CREATE SEQUENCE test_seq_5 AS bigint

-- Test 167: statement (line 3026)
CREATE SEQUENCE test_seq_6 AS INT2

-- Test 168: statement (line 3029)
CREATE SEQUENCE test_seq_7 AS INT4

-- Test 169: statement (line 3032)
CREATE SEQUENCE test_seq_8 AS INT8

-- Test 170: query (line 3035)
SELECT * FROM information_schema.sequences

-- Test 171: statement (line 3050)
CREATE DATABASE other_db

-- Test 172: statement (line 3053)
SET DATABASE = other_db

-- Test 173: query (line 3058)
SELECT * FROM information_schema.sequences

-- Test 174: statement (line 3062)
SET DATABASE = test

-- Test 175: statement (line 3065)
DROP DATABASE other_db CASCADE

-- Test 176: query (line 3069)
SHOW COLUMNS FROM information_schema.column_privileges

-- Test 177: query (line 3084)
SHOW COLUMNS FROM information_schema.routines

-- Test 178: query (line 3171)
SELECT * FROM information_schema.routines WHERE routine_name = 'pg_get_functiondef'

-- Test 179: query (line 3179)
SHOW COLUMNS FROM information_schema.parameters

-- Test 180: query (line 3216)
SELECT * FROM information_schema.parameters WHERE specific_name LIKE 'get_byte%' ORDER BY specific_name, ordinal_position

-- Test 181: query (line 3239)
SELECT p.parameter_name, p.parameter_default
FROM information_schema.routines AS r
JOIN information_schema.parameters AS p ON r.specific_name = p.specific_name
WHERE r.routine_name = 'f_default'
ORDER BY p.ordinal_position;

-- Test 182: statement (line 3251)
CREATE FUNCTION f_inout_default(
  INOUT p_inout_no_default INT,
  INOUT p_inout_with_default INT DEFAULT 42
) RETURNS RECORD AS $$ SELECT p_inout_no_default + 1, p_inout_with_default + 1; $$ LANGUAGE SQL;

-- Test 183: query (line 3257)
SELECT p.parameter_name, p.parameter_default
FROM information_schema.routines AS r
JOIN information_schema.parameters AS p ON r.specific_name = p.specific_name
WHERE r.routine_name = 'f_inout_default'
ORDER BY p.ordinal_position;

-- Test 184: statement (line 3269)
CREATE FUNCTION f_mixed_defaults(
  p_in_no_default INT,
  OUT p_out_param INT,
  INOUT p_inout_no_default INT,
  p_in_default INT DEFAULT 10,
  INOUT p_inout_default INT DEFAULT 20
) RETURNS RECORD AS $$
  SELECT p_in_no_default + p_in_default, p_inout_no_default + 1, p_inout_default + 1;
$$ LANGUAGE SQL;

-- Test 185: query (line 3280)
SELECT p.parameter_name, p.parameter_default
FROM information_schema.routines AS r
JOIN information_schema.parameters AS p ON r.specific_name = p.specific_name
WHERE r.routine_name = 'f_mixed_defaults'
ORDER BY p.ordinal_position;

-- Test 186: statement (line 3294)
CREATE FUNCTION f_complex_defaults(
  OUT p_out_result INT,
  INOUT p_complex_default INT DEFAULT length('test'),
  p_function_default INT DEFAULT length('hello')
) RETURNS RECORD AS $$
  SELECT p_complex_default + p_function_default, p_complex_default;
$$ LANGUAGE SQL;

-- Test 187: query (line 3303)
SELECT p.parameter_name, p.parameter_default
FROM information_schema.routines AS r
JOIN information_schema.parameters AS p ON r.specific_name = p.specific_name
WHERE r.routine_name = 'f_complex_defaults'
ORDER BY p.ordinal_position;

-- Test 188: query (line 3314)
SELECT * FROM system.information_schema.column_privileges WHERE table_name = 'eventlog'

-- Test 189: query (line 3363)
SELECT * FROM information_schema.administrable_role_authorizations

-- Test 190: query (line 3371)
SELECT * FROM information_schema.administrable_role_authorizations

-- Test 191: query (line 3380)
SELECT * FROM information_schema.applicable_roles

-- Test 192: query (line 3388)
SELECT * FROM information_schema.applicable_roles

-- Test 193: query (line 3397)
SELECT * FROM information_schema.enabled_roles

-- Test 194: query (line 3406)
SELECT * FROM information_schema.enabled_roles

-- Test 195: statement (line 3416)
CREATE DATABASE dfk; SET database=dfk

-- Test 196: statement (line 3419)
CREATE TABLE v(x INT, y INT, UNIQUE (x,y))

-- Test 197: statement (line 3422)
CREATE TABLE w(
  a INT, b INT, c INT, d INT,
  FOREIGN KEY (a,b) REFERENCES v(x,y) MATCH FULL,
  FOREIGN KEY (c,d) REFERENCES v(x,y) MATCH SIMPLE
  );

-- Test 198: query (line 3429)
SELECT constraint_name, table_name, referenced_table_name, match_option
  FROM information_schema.referential_constraints

-- Test 199: statement (line 3436)
SET database = test

-- Test 200: statement (line 3439)
DROP DATABASE dfk CASCADE

-- Test 201: statement (line 3445)
CREATE TABLE ab(a INT, b INT)

-- Test 202: statement (line 3448)
ALTER TABLE ab DROP COLUMN a

let $attnum
SELECT attnum FROM pg_attribute WHERE attrelid = 'ab'::regclass AND attname = 'b'

-- Test 203: query (line 3454)
SELECT
	ordinal_position
FROM
	information_schema.columns
WHERE
	table_name = 'ab'
	AND column_name = 'b'
	AND ordinal_position = $attnum;

-- Test 204: statement (line 3466)
DROP TABLE ab

-- Test 205: statement (line 3471)
CREATE TYPE typ1 AS ENUM ('hello');
CREATE TYPE typ2 AS ENUM ('bye');
CREATE TABLE tb_enum_cols (x typ1, y INT, z typ2, w typ2)

-- Test 206: query (line 3476)
SELECT * FROM information_schema.type_privileges WHERE type_name IN ('int', 'typ2')

-- Test 207: statement (line 3487)
GRANT ALL ON TYPE typ2 TO testuser

-- Test 208: query (line 3490)
SELECT * FROM information_schema.type_privileges WHERE type_name IN ('int', 'typ2')

-- Test 209: query (line 3502)
SELECT * FROM information_schema.column_udt_usage

-- Test 210: query (line 3513)
SELECT * FROM information_schema.collations ORDER BY collation_name

-- Test 211: query (line 3620)
SELECT * FROM information_schema.collation_character_set_applicability

-- Test 212: query (line 3996)
SELECT table_catalog, table_schema, table_name, column_name, ordinal_position
FROM "".information_schema.columns
WHERE (table_catalog = 'test' OR table_catalog = 'other_db')
AND table_schema = 'public'
AND (table_name = 't1' OR table_name = 't2')
ORDER BY 3,4

-- Test 213: statement (line 4012)
SET DATABASE = "";

-- Test 214: query (line 4015)
SELECT table_catalog, table_schema, table_name, column_name, ordinal_position
FROM "".information_schema.columns
WHERE (table_catalog = 'test' OR table_catalog = 'other_db')
AND table_schema = 'public'
AND (table_name = 't1' OR table_name = 't2')
ORDER BY 3,4

-- Test 215: statement (line 4031)
SET DATABASE = test

-- Test 216: statement (line 4035)
CREATE DATABASE enum_db;
SET DATABASE = enum_db;
CREATE SCHEMA sh;
CREATE TYPE e AS ENUM ('a', 'b');
CREATE TYPE sh.d AS ENUM('x', 'y');
CREATE TABLE t (e e, d sh.d, a e[]);

-- Test 217: query (line 4043)
select udt_schema, udt_name, data_type
from information_schema.columns
where table_name = 't'
ORDER BY udt_name

-- Test 218: statement (line 4056)
SET DATABASE = "";

-- Test 219: query (line 4059)
SELECT distinct is_identity FROM information_schema.columns

-- Test 220: statement (line 4066)
SET DATABASE = test

-- Test 221: statement (line 4073)
CREATE TABLE t70505 (k INT PRIMARY KEY, a INT, b INT, INDEX ((a + b), (a + 10)))

-- Test 222: query (line 4076)
SELECT column_name FROM information_schema.columns WHERE table_name = 't70505'

-- Test 223: statement (line 4086)
CREATE TABLE t (
  id1 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 10),
  id2 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (START 10),
  id3 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (MINVALUE 5),
  id4 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 5),
  id5 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (START 2 INCREMENT 5),
  id6 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT BY -1 START -5),
  id7 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (MINVALUE 5 MAXVALUE 10),
  id8 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (MAXVALUE 10 START WITH 9),
  id9 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT BY -1 MINVALUE -10 START WITH -10),
  id10 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 9223372036854775807),
  id11 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (MINVALUE -9223372036854775808 START WITH -9223372036854775808 INCREMENT -1),
  id12 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (VIRTUAL),
  id13 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (CACHE 10 INCREMENT 1),
  id14 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT 5),
  id15 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (MAXVALUE 4 START WITH 2 CACHE 5 INCREMENT BY 2),
  id16 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (MINVALUE -4 START WITH -2 CACHE 5 INCREMENT BY -2),
  id17 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (MINVALUE -2 MAXVALUE 2 START WITH 2 CACHE 5 INCREMENT BY -2),
  id18 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (AS int2 START WITH -4 INCREMENT BY -3),
  id19 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (AS integer),
  id20 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (AS int8),
  id21 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (AS smallint),
  id22 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (AS integer START WITH 2 INCREMENT BY 1 MINVALUE 0 MAXVALUE 234567 CACHE 1),
  id23 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (AS smallint START WITH -4 INCREMENT BY -3),
  id24 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (AS integer START WITH 1 INCREMENT BY 1 MAXVALUE 9001 CACHE 1),
  id25 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT  BY 3  MINVALUE 6 MAXVALUE 10),
  id26 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (MINVALUE -2 MAXVALUE 2 START WITH 1 CACHE 5 INCREMENT BY -2),
  id27 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY (INCREMENT  BY 3  MINVALUE 6 MAXVALUE 12),
  id28 INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY
)

-- Test 224: query (line 4118)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id1';

-- Test 225: query (line 4123)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id2';

-- Test 226: query (line 4128)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id3';

-- Test 227: query (line 4133)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id4';

-- Test 228: query (line 4138)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id5';

-- Test 229: query (line 4143)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id6';

-- Test 230: query (line 4148)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id7';

-- Test 231: query (line 4153)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id8';

-- Test 232: query (line 4158)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id9';

-- Test 233: query (line 4163)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id10';

-- Test 234: query (line 4168)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id11';

-- Test 235: query (line 4173)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id12';

-- Test 236: query (line 4178)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id13';

-- Test 237: query (line 4183)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id14';

-- Test 238: query (line 4188)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id15';

-- Test 239: query (line 4193)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id16';

-- Test 240: query (line 4198)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id17';

-- Test 241: query (line 4203)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id18';

-- Test 242: query (line 4208)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id19';

-- Test 243: query (line 4213)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id20';

-- Test 244: query (line 4218)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id21';

-- Test 245: query (line 4223)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id22';

-- Test 246: query (line 4228)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id23';

-- Test 247: query (line 4233)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id24';

-- Test 248: query (line 4238)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id25';

-- Test 249: query (line 4243)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id26';

-- Test 250: query (line 4248)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id27';

-- Test 251: query (line 4253)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id28';

-- Test 252: statement (line 4261)
DROP TABLE IF EXISTS t

-- Test 253: statement (line 4264)
SET default_int_size=4

-- Test 254: statement (line 4269)
CREATE TABLE t (
  id1 INT GENERATED BY DEFAULT AS IDENTITY (START WITH 10)
)

-- Test 255: query (line 4274)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id1';

-- Test 256: statement (line 4279)
DROP TABLE IF EXISTS t

-- Test 257: statement (line 4282)
SET default_int_size=8

-- Test 258: statement (line 4285)
CREATE TABLE t (
  id1 INT GENERATED BY DEFAULT AS IDENTITY (START WITH 10)
)

-- Test 259: query (line 4290)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id1';

-- Test 260: statement (line 4295)
DROP TABLE IF EXISTS t

-- Test 261: statement (line 4298)
set default_int_size = 8;

-- Test 262: statement (line 4301)
CREATE TABLE t (
  id1 INT GENERATED BY DEFAULT AS IDENTITY (START WITH 10)
)

-- Test 263: query (line 4306)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id1';

-- Test 264: statement (line 4311)
set default_int_size = 4;

-- Test 265: query (line 4314)
select identity_start, identity_increment, identity_maximum, identity_minimum, identity_cycle from information_schema.columns where table_name = 't' and column_name='id1';

-- Test 266: statement (line 4321)
DROP TABLE IF EXISTS t

-- Test 267: statement (line 4324)
CREATE TABLE t (i INTEGER PRIMARY KEY, x VARCHAR, y VARCHAR, z VARCHAR GENERATED ALWAYS AS (x || ' ' || y) STORED);

-- Test 268: query (line 4327)
SELECT column_name, is_generated FROM information_schema.columns WHERE table_name = 't';

-- Test 269: query (line 4337)
SELECT * FROM information_schema.role_routine_grants
WHERE reverse(split_part(reverse(specific_name), '_', 1))::INT < 50
ORDER BY specific_name, grantee;

-- Test 270: statement (line 4495)
CREATE TYPE u AS (ufoo int, ubar int);

-- Test 271: query (line 4498)
SHOW COLUMNS FROM information_schema.user_defined_types

-- Test 272: query (line 4532)
SELECT * FROM information_schema.user_defined_types WHERE user_defined_type_name = 'u'

-- Test 273: query (line 4538)
SELECT * FROM information_schema.user_defined_types WHERE user_defined_type_name = 'dne'

-- Test 274: query (line 4547)
SHOW COLUMNS FROM information_schema.attributes

-- Test 275: query (line 4583)
SELECT * FROM information_schema.attributes WHERE udt_name = 'u'

