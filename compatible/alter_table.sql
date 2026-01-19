-- PostgreSQL compatible tests from alter_table
-- 1009 tests

-- Test 1: statement (line 5)
CREATE TABLE other (b INT PRIMARY KEY)

-- Test 2: statement (line 8)
INSERT INTO other VALUES (9)

-- Test 3: statement (line 11)
CREATE TABLE t (a INT PRIMARY KEY CHECK(a > 0), f INT REFERENCES other, INDEX (f))

-- Test 4: statement (line 14)
INSERT INTO t VALUES (1, 9)

-- Test 5: statement (line 17)
ALTER TABLE t RENAME TO t.*

-- Test 6: statement (line 20)
ALTER TABLE t ADD b INT

-- Test 7: query (line 23)
SHOW COLUMNS FROM t

-- Test 8: statement (line 31)
ALTER TABLE t ADD CONSTRAINT foo UNIQUE (b)

-- Test 9: statement (line 34)
ALTER TABLE t ADD CONSTRAINT IF NOT EXISTS foo UNIQUE (b)

-- Test 10: statement (line 37)
ALTER TABLE t ADD CONSTRAINT IF NOT EXISTS foo UNIQUE (f)

-- Test 11: query (line 40)
SELECT description, user_name, status, fraction_completed, error
FROM crdb_internal.jobs
WHERE job_type in ('NEW SCHEMA CHANGE', 'SCHEMA CHANGE')
ORDER BY created DESC
LIMIT 1

-- Test 12: statement (line 49)
ALTER TABLE t ADD CONSTRAINT foo UNIQUE (b)

-- Test 13: statement (line 52)
ALTER TABLE t ADD CONSTRAINT bar PRIMARY KEY (b)

-- Test 14: query (line 55)
SHOW INDEXES FROM t

-- Test 15: query (line 67)
SELECT * FROM t

-- Test 16: statement (line 72)
ALTER TABLE t ADD c INT

-- Test 17: statement (line 75)
INSERT INTO t VALUES (2, 9, 1, 1), (3, 9, 2, 1)

-- Test 18: statement (line 78)
ALTER TABLE t ADD CONSTRAINT bar UNIQUE (c)

-- Test 19: statement (line 81)
ALTER TABLE t ADD CONSTRAINT dne_unique UNIQUE (dne)

-- Test 20: query (line 90)
SELECT job_type, regexp_replace(description, 'JOB \d+', 'JOB ...'), user_name
FROM crdb_internal.jobs
WHERE job_type = 'SCHEMA CHANGE' OR job_type = 'SCHEMA CHANGE GC'
ORDER BY created DESC, 2 DESC
LIMIT 3

-- Test 21: query (line 101)
SELECT * FROM t

-- Test 22: query (line 109)
SHOW CONSTRAINTS FROM t

-- Test 23: statement (line 118)
INSERT INTO t (a, f) VALUES (-2, 9)

-- Test 24: statement (line 121)
ALTER TABLE t DROP CONSTRAINT check_a

-- Test 25: statement (line 124)
INSERT INTO t (a, f) VALUES (-2, 9)

-- Test 26: statement (line 127)
ALTER TABLE t ADD CONSTRAINT check_a CHECK (a > 0)

-- Test 27: statement (line 130)
DELETE FROM t WHERE a = -2

-- Test 28: statement (line 133)
ALTER TABLE t ADD CONSTRAINT IF NOT EXISTS check_a CHECK (a > 0)

-- Test 29: statement (line 136)
INSERT INTO t (a) VALUES (-3)

-- Test 30: query (line 139)
SHOW CONSTRAINTS FROM t

-- Test 31: statement (line 147)
ALTER TABLE t ADD CONSTRAINT check_a CHECK (a > 0)

-- Test 32: statement (line 150)
ALTER TABLE t ADD CONSTRAINT IF NOT EXISTS check_a CHECK (a < 0)

-- Test 33: statement (line 153)
ALTER TABLE t ADD CONSTRAINT t_f_fkey FOREIGN KEY (a) REFERENCES other (b)

-- Test 34: statement (line 157)
ALTER TABLE t ADD CONSTRAINT IF NOT EXISTS t_f_fkey FOREIGN KEY (a) REFERENCES other (b)

-- Test 35: statement (line 161)
ALTER TABLE t ADD CONSTRAINT IF NOT EXISTS t_f_fkey CHECK (a < 0)

-- Test 36: statement (line 165)
ALTER TABLE t ADD CHECK (a > 0)

-- Test 37: query (line 168)
SHOW CONSTRAINTS FROM t

-- Test 38: statement (line 177)
ALTER TABLE t VALIDATE CONSTRAINT typo

-- Test 39: statement (line 187)
ALTER TABLE t VALIDATE CONSTRAINT check_a

-- Test 40: query (line 190)
SHOW CONSTRAINTS FROM t

-- Test 41: statement (line 199)
ALTER TABLE t DROP CONSTRAINT check_a, DROP CONSTRAINT check_a1

-- Test 42: statement (line 202)
ALTER TABLE t DROP d

-- Test 43: statement (line 205)
ALTER TABLE t DROP IF EXISTS d

-- Test 44: statement (line 208)
ALTER TABLE t DROP a

-- Test 45: statement (line 211)
ALTER TABLE t DROP CONSTRAINT bar

-- Test 46: statement (line 214)
ALTER TABLE t DROP CONSTRAINT IF EXISTS bar

-- Test 47: statement (line 217)
ALTER TABLE t DROP CONSTRAINT foo

-- Test 48: statement (line 220)
DROP INDEX foo CASCADE

onlyif config local-legacy-schema-changer

-- Test 49: query (line 224)
SELECT job_type, description, user_name, status, fraction_completed, error
FROM crdb_internal.jobs
WHERE job_type = 'SCHEMA CHANGE' OR job_type = 'SCHEMA CHANGE GC'
ORDER BY created DESC
LIMIT 2

-- Test 50: query (line 236)
SELECT job_type, description, user_name, status, fraction_completed, error
FROM crdb_internal.jobs
WHERE job_type = 'NEW SCHEMA CHANGE' OR job_type = 'SCHEMA CHANGE GC'
ORDER BY created DESC
LIMIT 2

-- Test 51: query (line 248)
SHOW INDEXES FROM t

-- Test 52: statement (line 259)
ALTER TABLE t DROP b, DROP c

-- Test 53: query (line 262)
SELECT * FROM t

-- Test 54: statement (line 269)
ALTER TABLE t ADD d INT UNIQUE

-- Test 55: statement (line 272)
INSERT INTO t VALUES (4, 9, 1)

-- Test 56: statement (line 275)
INSERT INTO t VALUES (5, 9, 1)

-- Test 57: statement (line 279)
ALTER TABLE t ADD COLUMN x DECIMAL

-- Test 58: statement (line 283)
ALTER TABLE t ADD COLUMN y DECIMAL NOT NULL DEFAULT (DECIMAL '1.3')

-- Test 59: statement (line 286)
ALTER TABLE t ADD COLUMN p DECIMAL NOT NULL DEFAULT (DECIMAL '1-3')

-- Test 60: statement (line 290)
ALTER TABLE t ADD COLUMN q DECIMAL NOT NULL

-- Test 61: statement (line 293)
ALTER TABLE t ADD COLUMN z DECIMAL DEFAULT (DECIMAL '1.4')

-- Test 62: statement (line 296)
INSERT INTO t VALUES (11, 9, 12, DECIMAL '1.0')

-- Test 63: statement (line 299)
INSERT INTO t (a, d) VALUES (13, 14)

-- Test 64: statement (line 302)
INSERT INTO t (a, d, y) VALUES (21, 22, DECIMAL '1.0')

-- Test 65: statement (line 305)
INSERT INTO t (a, d) VALUES (23, 24)

-- Test 66: statement (line 308)
INSERT INTO t VALUES (31, 7, 32)

-- Test 67: statement (line 311)
ALTER TABLE t DROP CONSTRAINT t_f_fkey

-- Test 68: statement (line 314)
INSERT INTO t VALUES (31, 7, 32)

-- Test 69: statement (line 317)
INSERT INTO t (a, d, x, y, z) VALUES (33, 34, DECIMAL '2.0', DECIMAL '2.1', DECIMAL '2.2')

-- Test 70: statement (line 320)
DROP INDEX t@t_f_idx

onlyif config local-legacy-schema-changer

-- Test 71: query (line 324)
SELECT job_type, description, user_name, status, fraction_completed, error
FROM crdb_internal.jobs
WHERE job_type = 'SCHEMA CHANGE' OR job_type = 'SCHEMA CHANGE GC'
ORDER BY created DESC
LIMIT 2

-- Test 72: query (line 335)
SELECT job_type, description, user_name, status, fraction_completed, error
FROM crdb_internal.jobs
WHERE job_type = 'NEW SCHEMA CHANGE' OR job_type = 'SCHEMA CHANGE GC'
ORDER BY created DESC
LIMIT 2

-- Test 73: statement (line 345)
ALTER TABLE t DROP COLUMN f

-- Test 74: query (line 348)
SELECT * FROM t

-- Test 75: statement (line 363)
ALTER TABLE t DROP COLUMN d

-- Test 76: statement (line 366)
ALTER TABLE t ADD COLUMN e INT; ALTER TABLE t ADD COLUMN d INT

-- Test 77: statement (line 369)
CREATE VIEW v AS SELECT x, y FROM t WHERE e > 5

-- Test 78: statement (line 372)
ALTER TABLE t DROP COLUMN x

-- Test 79: statement (line 375)
ALTER TABLE t DROP COLUMN y

-- Test 80: statement (line 378)
ALTER TABLE t DROP COLUMN e

-- Test 81: statement (line 381)
ALTER TABLE t DROP COLUMN e CASCADE

-- Test 82: statement (line 384)
ALTER TABLE t ADD COLUMN e INT

-- Test 83: statement (line 387)
CREATE VIEW v AS SELECT x, y FROM t WHERE e > 5

-- Test 84: statement (line 390)
ALTER TABLE t DROP COLUMN IF EXISTS q

-- Test 85: statement (line 393)
ALTER TABLE t DROP COLUMN IF EXISTS e

-- Test 86: statement (line 400)
ALTER TABLE t DROP COLUMN IF EXISTS e CASCADE

onlyif config weak-iso-level-configs

-- Test 87: statement (line 404)
ALTER TABLE t DROP COLUMN IF EXISTS e CASCADE

-- Test 88: statement (line 407)
ALTER TABLE t ADD COLUMN g INT UNIQUE

-- Test 89: statement (line 410)
CREATE TABLE o (gf INT REFERENCES t (g), h INT, i INT, INDEX oi (i), INDEX oh (h), INDEX oih (i) STORING (h))

-- Test 90: statement (line 413)
ALTER TABLE t DROP COLUMN g

-- Test 91: statement (line 416)
ALTER TABLE t DROP COLUMN g CASCADE

-- Test 92: statement (line 425)
ALTER TABLE o DROP COLUMN h

-- Test 93: query (line 428)
SHOW INDEXES FROM o

-- Test 94: statement (line 438)
ALTER TABLE t ADD f INT CHECK (f > 1)

-- Test 95: statement (line 441)
ALTER TABLE t ADD g INT DEFAULT 1 CHECK (g > 0)

-- Test 96: statement (line 444)
ALTER TABLE t ADD h INT CHECK (h > 0) CHECK (h < 10) UNIQUE

-- Test 97: statement (line 447)
ALTER TABLE t ADD i INT DEFAULT 1 CHECK (i < 0)

-- Test 98: statement (line 450)
ALTER TABLE t ADD i INT DEFAULT 1 CHECK (i < g)

-- Test 99: statement (line 453)
ALTER TABLE t ADD i INT AS (g - 1) STORED CHECK (i > 0)

-- Test 100: query (line 456)
SHOW CONSTRAINTS FROM t

-- Test 101: statement (line 466)
DROP TABLE t

-- Test 102: statement (line 473)
CREATE TABLE t (a INT PRIMARY KEY)

-- Test 103: statement (line 476)
INSERT INTO t VALUES (1)

-- Test 104: statement (line 480)
ALTER TABLE t ADD b INT DEFAULT 1, ADD c INT DEFAULT 2 CHECK (c > b)

-- Test 105: statement (line 483)
ALTER TABLE t ADD d INT UNIQUE, ADD e INT UNIQUE, ADD f INT

-- Test 106: statement (line 487)
ALTER TABLE t ADD g INT DEFAULT 3, ADD h INT DEFAULT 2 CHECK (g = h)

-- Test 107: statement (line 491)
ALTER TABLE t ADD COLUMN u INT UNIQUE, ADD COLUMN v INT UNIQUE, ADD CONSTRAINT ck CHECK (a > 0);

-- Test 108: query (line 494)
SHOW CONSTRAINTS FROM t

-- Test 109: statement (line 505)
DROP TABLE t

-- Test 110: statement (line 509)
CREATE TABLE tt (a INT PRIMARY KEY)

-- Test 111: statement (line 512)
ALTER TABLE tt ADD COLUMN q DECIMAL NOT NULL

-- Test 112: statement (line 515)
ALTER table tt ADD COLUMN r DECIMAL

-- Test 113: statement (line 520)
ALTER TABLE tt ADD COLUMN s DECIMAL UNIQUE NOT NULL

-- Test 114: statement (line 523)
ALTER TABLE tt ADD t DECIMAL UNIQUE DEFAULT 4.0

-- Test 115: query (line 526)
SHOW COLUMNS FROM tt

-- Test 116: statement (line 537)
CREATE TABLE add_default (a int primary key, b int not null)

-- Test 117: statement (line 540)
INSERT INTO add_default (a) VALUES (1)

-- Test 118: statement (line 543)
ALTER TABLE add_default ALTER COLUMN b SET DEFAULT 42

-- Test 119: query (line 546)
SHOW COLUMNS FROM add_default

-- Test 120: statement (line 553)
INSERT INTO add_default (a) VALUES (2)

-- Test 121: statement (line 556)
ALTER TABLE add_default ALTER COLUMN b SET DEFAULT 10

-- Test 122: statement (line 562)
INSERT INTO add_default (a) VALUES (3)

-- Test 123: statement (line 565)
ALTER TABLE add_default ALTER COLUMN b SET DEFAULT 'foo'

-- Test 124: statement (line 568)
ALTER TABLE add_default ALTER COLUMN b SET DEFAULT c

-- Test 125: statement (line 571)
ALTER TABLE add_default ALTER COLUMN b SET DEFAULT (SELECT 1)

-- Test 126: statement (line 574)
ALTER TABLE add_default ALTER COLUMN b DROP DEFAULT

-- Test 127: statement (line 577)
INSERT INTO add_default (a) VALUES (4)

-- Test 128: statement (line 580)
ALTER TABLE add_default ALTER COLUMN b SET DEFAULT NULL

-- Test 129: statement (line 583)
INSERT INTO add_default (a) VALUES (4)

-- Test 130: query (line 587)
SELECT * FROM add_default

-- Test 131: statement (line 593)
ALTER TABLE add_default ALTER b DROP NOT NULL

-- Test 132: statement (line 596)
INSERT INTO add_default (a) VALUES (5)

-- Test 133: query (line 599)
SELECT * from add_default WHERE a=5

-- Test 134: statement (line 605)
ALTER TABLE add_default ADD COLUMN c TIMESTAMP DEFAULT current_timestamp()

-- Test 135: query (line 608)
SELECT a,b FROM add_default WHERE current_timestamp > c AND current_timestamp() - c < interval '20s'

-- Test 136: statement (line 616)
ALTER TABLE add_default ADD COLUMN d TIMESTAMP DEFAULT transaction_timestamp()

-- Test 137: query (line 619)
SELECT a,b FROM add_default WHERE d > c AND d - c < interval '20s'

-- Test 138: statement (line 627)
ALTER TABLE add_default ADD COLUMN e TIMESTAMP DEFAULT statement_timestamp()

-- Test 139: query (line 630)
SELECT a,b FROM add_default WHERE e > d AND e - d < interval '20s'

-- Test 140: statement (line 638)
ALTER TABLE add_default ADD COLUMN f TIMESTAMP DEFAULT NULL

-- Test 141: query (line 641)
SELECT a,b,f FROM add_default

-- Test 142: statement (line 650)
ALTER TABLE add_default ADD g INT UNIQUE DEFAULT 1

-- Test 143: statement (line 655)
CREATE SEQUENCE initial_seq

-- Test 144: statement (line 658)
ALTER TABLE add_default ADD g INT DEFAULT nextval('initial_seq')

-- Test 145: statement (line 661)
ALTER TABLE add_default ADD g OID DEFAULT 'foo'::regclass::oid

-- Test 146: statement (line 664)
ALTER TABLE add_default ADD g INT DEFAULT 'foo'::regtype::INT

-- Test 147: statement (line 670)
ALTER TABLE add_default SET (schema_locked=false)

-- Test 148: statement (line 673)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 149: statement (line 676)
SET LOCAL autocommit_before_ddl = false;

-- Test 150: statement (line 679)
ALTER TABLE add_default ADD fee FLOAT NOT NULL DEFAULT 2.99

-- Test 151: statement (line 682)
ALTER TABLE add_default ALTER COLUMN fee DROP DEFAULT

-- Test 152: statement (line 685)
COMMIT

-- Test 153: statement (line 688)
BEGIN

-- Test 154: statement (line 691)
ALTER TABLE add_default ALTER COLUMN a SET DEFAULT 2

-- Test 155: statement (line 694)
ALTER TABLE add_default ALTER COLUMN a DROP DEFAULT

-- Test 156: statement (line 697)
COMMIT

skipif config schema-locked-disabled

-- Test 157: statement (line 701)
ALTER TABLE add_default SET (schema_locked=true)

-- Test 158: query (line 704)
SHOW COLUMNS FROM add_default

-- Test 159: query (line 715)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name = 'sql.schema.change_in_explicit_txn'

-- Test 160: statement (line 720)
ALTER TABLE add_default DROP fee

-- Test 161: statement (line 724)
CREATE TABLE d (a INT PRIMARY KEY)

-- Test 162: statement (line 727)
INSERT INTO d VALUES (1), (2)

-- Test 163: statement (line 730)
ALTER TABLE d ADD COLUMN c INT, ADD COLUMN b INT DEFAULT 7

-- Test 164: statement (line 733)
INSERT INTO d (a, c) VALUES (3, 4)

-- Test 165: query (line 736)
SELECT * FROM d

-- Test 166: statement (line 745)
CREATE TABLE privs (a INT PRIMARY KEY, b INT)

-- Test 167: statement (line 748)
INSERT INTO privs VALUES (1)

user testuser

-- Test 168: query (line 753)
SHOW DATABASE

-- Test 169: statement (line 758)
ALTER TABLE privs ADD c INT

-- Test 170: statement (line 761)
ALTER TABLE privs ADD CONSTRAINT foo UNIQUE (b)

user root

-- Test 171: query (line 766)
SHOW COLUMNS FROM privs

-- Test 172: statement (line 773)
GRANT CREATE ON privs TO testuser

user testuser

-- Test 173: statement (line 778)
ALTER TABLE privs ADD c INT

-- Test 174: statement (line 781)
ALTER TABLE privs ADD CONSTRAINT foo UNIQUE (b)

-- Test 175: query (line 784)
SHOW COLUMNS FROM privs

-- Test 176: statement (line 804)
ALTER TABLE nonexistent UNSPLIT ALL

-- Test 177: statement (line 807)
ALTER INDEX nonexistent@noindex UNSPLIT ALL

user root

-- Test 178: statement (line 812)
CREATE VIEW privsview AS SELECT a,b,c FROM privs

-- Test 179: statement (line 815)
ALTER TABLE privsview ADD d INT

-- Test 180: statement (line 824)
ALTER TABLE privsview UNSPLIT ALL

-- Test 181: statement (line 829)
CREATE TABLE impure (x INT); INSERT INTO impure(x) VALUES (1), (2), (3);

-- Test 182: statement (line 832)
ALTER TABLE impure ADD COLUMN a INT DEFAULT unique_rowid();

-- Test 183: query (line 835)
SELECT count(distinct a) FROM impure

-- Test 184: query (line 841)
SELECT count(*) FROM crdb_internal.jobs
WHERE job_type = 'SCHEMA CHANGE' AND status = 'pending' OR status = 'started'

-- Test 185: statement (line 850)
CREATE TABLE default_err_test (foo text)

-- Test 186: statement (line 853)
INSERT INTO default_err_test VALUES ('foo'), ('bar'), ('baz')

-- Test 187: statement (line 856)
ALTER TABLE default_err_test ADD COLUMN id int DEFAULT crdb_internal.force_error('foo', 'some_msg')

-- Test 188: query (line 859)
SELECT * from default_err_test ORDER BY foo

-- Test 189: statement (line 867)
CREATE TABLE decomputed_column (a INT PRIMARY KEY, b INT AS ( a + 1 ) STORED, FAMILY "primary" (a, b))

-- Test 190: statement (line 870)
INSERT INTO decomputed_column VALUES (1), (2)

-- Test 191: statement (line 873)
INSERT INTO decomputed_column VALUES (3, NULL), (4, 99)

-- Test 192: statement (line 876)
ALTER TABLE decomputed_column ALTER COLUMN b DROP STORED

-- Test 193: statement (line 879)
ALTER TABLE decomputed_column ALTER COLUMN a DROP STORED

-- Test 194: statement (line 882)
ALTER TABLE decomputed_column ALTER COLUMN b DROP STORED

-- Test 195: statement (line 886)
INSERT INTO decomputed_column VALUES (3, NULL), (4, 99)

-- Test 196: query (line 889)
select a, b from decomputed_column order by a

-- Test 197: query (line 898)
show create table decomputed_column

-- Test 198: query (line 908)
show create table decomputed_column

-- Test 199: statement (line 919)
CREATE TABLE b26483()

-- Test 200: statement (line 924)
SET create_table_with_schema_locked=false

-- Test 201: statement (line 930)
RESET create_table_with_schema_locked

-- Test 202: query (line 933)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name = 'sql.schema.set_audit_mode.read_write'

-- Test 203: statement (line 939)
GRANT CREATE ON audit TO testuser

user testuser

-- Test 204: statement (line 945)
ALTER TABLE audit ADD COLUMN y INT

-- Test 205: query (line 957)
SELECT feature_name FROM crdb_internal.feature_usage WHERE feature_name = 'sql.schema.set_audit_mode.off'

-- Test 206: statement (line 997)
ALTER TABLE vehicles ADD CONSTRAINT fk_city_ref_users FOREIGN KEY (city, owner_id) REFERENCES users (city, id)

-- Test 207: statement (line 1000)
ALTER TABLE rides ADD CONSTRAINT fk_city_ref_users FOREIGN KEY (city, rider_id) REFERENCES users (city, id)

-- Test 208: statement (line 1003)
ALTER TABLE rides ADD CONSTRAINT fk_vehicle_city_ref_vehicles FOREIGN KEY (vehicle_city, vehicle_id) REFERENCES vehicles (city, id)

-- Test 209: statement (line 1007)
INSERT INTO users VALUES (10, 'lagos', 'chimamanda')

-- Test 210: statement (line 1010)
INSERT INTO vehicles VALUES (100, 'lagos', 'toyota', 10, 'mycol')

-- Test 211: statement (line 1013)
INSERT INTO rides VALUES (567, 'lagos', 'lagos', 10, 100)

-- Test 212: statement (line 1016)
ALTER TABLE vehicles DROP COLUMN mycol;

-- Test 213: statement (line 1022)
CREATE TABLE t32917 (a INT PRIMARY KEY)

-- Test 214: statement (line 1025)
INSERT INTO t32917 VALUES (1), (2), (3)

-- Test 215: statement (line 1028)
CREATE TABLE t32917_2 (b INT PRIMARY KEY)

-- Test 216: statement (line 1031)
INSERT INTO t32917_2 VALUES (1), (2), (3)

-- Test 217: statement (line 1035)
CREATE TABLE t (a INT)

-- Test 218: statement (line 1038)
INSERT INTO t VALUES (1), (NULL)

-- Test 219: statement (line 1041)
ALTER TABLE t ALTER COLUMN a SET NOT NULL

-- Test 220: statement (line 1044)
DELETE FROM t WHERE a IS NULL

-- Test 221: statement (line 1047)
ALTER TABLE t ALTER COLUMN a SET NOT NULL

-- Test 222: statement (line 1050)
INSERT INTO t VALUES (NULL)

-- Test 223: query (line 1053)
SHOW CONSTRAINTS FROM t

-- Test 224: statement (line 1058)
ALTER TABLE t ALTER COLUMN a DROP NOT NULL

-- Test 225: statement (line 1061)
INSERT INTO t VALUES (NULL)

-- Test 226: statement (line 1064)
DROP TABLE t

-- Test 227: statement (line 1068)
CREATE TABLE t (a INT)

-- Test 228: statement (line 1071)
INSERT INTO t VALUES (1)

-- Test 229: statement (line 1075)
ALTER TABLE t ADD CONSTRAINT a_auto_not_null CHECK (a IS NOT NULL)

-- Test 230: statement (line 1078)
ALTER TABLE t ADD CONSTRAINT a_auto_not_null1 CHECK (a IS NOT NULL), ALTER COLUMN a SET NOT NULL

-- Test 231: statement (line 1081)
INSERT INTO t VALUES (NULL)

-- Test 232: query (line 1084)
SHOW CONSTRAINTS FROM t

-- Test 233: statement (line 1091)
DROP TABLE t

-- Test 234: statement (line 1095)
CREATE TABLE t (a int);

-- Test 235: statement (line 1098)
INSERT INTO t VALUES (10), (15), (17)

-- Test 236: statement (line 1101)
ALTER TABLE t ADD CHECK (a < 16)

-- Test 237: statement (line 1104)
ALTER TABLE t ADD CHECK (a < 100)

-- Test 238: statement (line 1107)
ALTER TABLE t ADD CHECK (a < 16) NOT VALID

-- Test 239: query (line 1110)
SHOW CONSTRAINTS FROM t

-- Test 240: query (line 1117)
INSERT INTO t VALUES (20)

statement error pq: validation of CHECK "a < 16:::INT8" failed on row: a=17
ALTER TABLE t VALIDATE CONSTRAINT check_a1

statement count 1
DELETE FROM t WHERE a = 17

statement ok
ALTER TABLE t VALIDATE CONSTRAINT check_a1

query TTTTB nosort
SHOW CONSTRAINTS FROM t

-- Test 241: statement (line 1138)
CREATE TABLE TEST2 (COL1 SERIAL PRIMARY KEY, COL2 INT8)

-- Test 242: statement (line 1141)
CREATE TABLE TEST1 (COL1 SERIAL PRIMARY KEY, COL2 INT8, COL3 INT8)

-- Test 243: statement (line 1144)
ALTER TABLE TEST1 ADD CONSTRAINT duplicate_name FOREIGN KEY (COL2) REFERENCES TEST2 (COL1)

-- Test 244: statement (line 1147)
ALTER TABLE TEST1 ADD CONSTRAINT duplicate_name FOREIGN KEY (COL3) REFERENCES TEST2 (COL1)

-- Test 245: statement (line 1150)
DROP TABLE test1; DROP TABLE test2

-- Test 246: statement (line 1155)
CREATE TABLE t1(x INT, y INT);

skipif config schema-locked-disabled

-- Test 247: statement (line 1159)
ALTER TABLE t1 SET (schema_locked=false)

-- Test 248: statement (line 1162)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t1 ALTER COLUMN x SET NOT NULL;
ALTER TABLE t1 ALTER COLUMN y SET NOT NULL;
COMMIT

-- Test 249: statement (line 1169)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t1 ALTER COLUMN x DROP NOT NULL;
ALTER TABLE t1 ALTER COLUMN y DROP NOT NULL;
COMMIT

skipif config schema-locked-disabled

-- Test 250: statement (line 1177)
ALTER TABLE t1 SET (schema_locked=true)

-- Test 251: statement (line 1180)
DROP TABLE t1

-- Test 252: statement (line 1185)
CREATE TABLE t43092(x INT PRIMARY KEY)

-- Test 253: statement (line 1188)
ALTER TABLE t43092 ALTER COLUMN x DROP NOT NULL

-- Test 254: statement (line 1191)
DROP TABLE t43092

-- Test 255: statement (line 1196)
CREATE TABLE telemetry_test (d int);

-- Test 256: statement (line 1203)
ALTER TABLE telemetry_test SET (schema_locked=false)

-- Test 257: statement (line 1206)
ALTER TABLE telemetry_test
  ADD COLUMN a int DEFAULT 1,
  ADD COLUMN b int UNIQUE CHECK(b > 1),
  ADD COLUMN c int AS (a + b) STORED

skipif config schema-locked-disabled

-- Test 258: statement (line 1213)
ALTER TABLE telemetry_test SET (schema_locked=true)

-- Test 259: query (line 1216)
SELECT feature_name FROM crdb_internal.feature_usage
WHERE feature_name IN (
  'sql.schema.new_column.qualification.computed',
  'sql.schema.new_column.qualification.default_expr',
  'sql.schema.new_column.qualification.unique'
)

-- Test 260: statement (line 1228)
DROP TABLE telemetry_test

-- Test 261: statement (line 1231)
SET create_table_with_schema_locked=false

-- Test 262: statement (line 1235)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 263: statement (line 1238)
SET LOCAL autocommit_before_ddl = false;

-- Test 264: statement (line 1241)
CREATE TABLE inject_stats (k CHAR PRIMARY KEY, v TIMESTAMPTZ)

-- Test 265: statement (line 1244)
ALTER TABLE inject_stats INJECT STATISTICS '[]'

-- Test 266: statement (line 1247)
ROLLBACK

-- Test 267: statement (line 1250)
RESET create_table_with_schema_locked

-- Test 268: statement (line 1255)
CREATE TABLE regression_47141(a time(3), b bytea)

-- Test 269: statement (line 1259)
CREATE TABLE t25045 (x INT, y INT AS (x+1) STORED)

-- Test 270: statement (line 1262)
ALTER TABLE t25045 DROP COLUMN x

-- Test 271: statement (line 1267)
DROP TABLE IF EXISTS t1, t2;
CREATE TABLE t1 (x INT PRIMARY KEY);

-- Test 272: statement (line 1271)
CREATE TABLE t2 (y INT)

-- Test 273: statement (line 1274)
ALTER TABLE t2 ADD COLUMN x INT REFERENCES t1 (x)

-- Test 274: statement (line 1277)
INSERT INTO t1 VALUES (1)

-- Test 275: statement (line 1280)
INSERT INTO t2 VALUES (2, 2)

-- Test 276: statement (line 1283)
INSERT INTO t2 VALUES (1, 1)

-- Test 277: query (line 1288)
SHOW CREATE t2

-- Test 278: query (line 1300)
SHOW CREATE t2

-- Test 279: statement (line 1313)
CREATE TABLE t3 (y INT)

-- Test 280: statement (line 1316)
ALTER TABLE t3 ADD COLUMN x INT UNIQUE REFERENCES t1 (x)

onlyif config schema-locked-disabled

-- Test 281: query (line 1320)
SHOW CREATE t3

-- Test 282: query (line 1333)
SHOW CREATE t3

-- Test 283: statement (line 1348)
DROP TABLE t1, t2 CASCADE;

-- Test 284: statement (line 1351)
CREATE TABLE t1 (x INT PRIMARY KEY);
CREATE TABLE t2 (x INT, y INT, INDEX i (x))

skipif config schema-locked-disabled

-- Test 285: statement (line 1356)
ALTER TABLE t2 SET (schema_locked = false);

-- Test 286: statement (line 1359)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t2 DROP COLUMN x;
ALTER TABLE t2 ADD FOREIGN KEY (x) REFERENCES t1(x);

-- Test 287: statement (line 1365)
ROLLBACK

skipif config schema-locked-disabled

-- Test 288: statement (line 1369)
ALTER TABLE t2 SET (schema_locked = true);

-- Test 289: statement (line 1372)
INSERT INTO t2 VALUES (1, 2)

-- Test 290: statement (line 1376)
DROP TABLE t1 CASCADE;

-- Test 291: statement (line 1379)
CREATE TABLE t1 (x INT PRIMARY KEY);

-- Test 292: statement (line 1382)
ALTER TABLE t1 ADD COLUMN x2 INT REFERENCES t1 (x)

onlyif config schema-locked-disabled

-- Test 293: query (line 1386)
SHOW CREATE t1

-- Test 294: query (line 1397)
SHOW CREATE t1

-- Test 295: statement (line 1407)
INSERT INTO t1 VALUES (1, 2)

-- Test 296: statement (line 1411)
DROP TABLE t1, t2 CASCADE

-- Test 297: statement (line 1414)
SET create_table_with_schema_locked=false

-- Test 298: statement (line 1417)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE t1 (x INT PRIMARY KEY);
CREATE TABLE t2 (y INT);
ALTER TABLE t2 ADD COLUMN x INT REFERENCES t1 (x);
COMMIT

-- Test 299: query (line 1425)
SHOW CREATE t2

-- Test 300: statement (line 1437)
DROP TABLE t1, t2 CASCADE

-- Test 301: statement (line 1440)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE t1 (x INT PRIMARY KEY);
CREATE TABLE t2 (y INT);
ALTER TABLE t2 ADD COLUMN x INT;
ALTER TABLE t2 ADD FOREIGN KEY (x) REFERENCES t1 (x);
COMMIT

-- Test 302: query (line 1449)
SHOW CREATE t2

-- Test 303: statement (line 1461)
DROP TABLE t1, t2 CASCADE

-- Test 304: statement (line 1464)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE t1 (x INT PRIMARY KEY);
INSERT INTO t1 VALUES (1);
CREATE TABLE t2 (y INT);
INSERT INTO t2 VALUES (2);
ALTER TABLE t2 ADD COLUMN x INT;
CREATE INDEX ON t2 (x);
ALTER TABLE t2 ADD FOREIGN KEY (x) REFERENCES t1 (x);
COMMIT

-- Test 305: query (line 1476)
SHOW CREATE t2

-- Test 306: statement (line 1489)
DROP TABLE t1, t2 CASCADE;

-- Test 307: statement (line 1493)
CREATE TABLE t1 (x INT PRIMARY KEY);

-- Test 308: statement (line 1496)
CREATE TABLE t2 (y INT)

-- Test 309: statement (line 1499)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t2 ADD COLUMN x INT;
CREATE INDEX ON t2 (x);
ALTER TABLE t2 ADD FOREIGN KEY (x) REFERENCES t1 (x);
COMMIT

-- Test 310: query (line 1507)
SHOW CREATE t2

-- Test 311: statement (line 1520)
DROP TABLE t1, t2 CASCADE;

-- Test 312: statement (line 1523)
CREATE TABLE t1 (x INT PRIMARY KEY);

-- Test 313: statement (line 1526)
CREATE TABLE t2 (x INT)

-- Test 314: statement (line 1529)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE INDEX ON t2 (x);
ALTER TABLE t2 ADD FOREIGN KEY (x) REFERENCES t1 (x);
COMMIT

-- Test 315: query (line 1536)
SHOW CREATE t2

-- Test 316: statement (line 1548)
DROP TABLE t1, t2 CASCADE

-- Test 317: statement (line 1551)
CREATE TABLE t1 (x INT PRIMARY KEY);
INSERT INTO t1 VALUES (1);

-- Test 318: statement (line 1555)
CREATE TABLE t2 (y INT);

-- Test 319: statement (line 1558)
INSERT INTO t2 VALUES (2)

-- Test 320: statement (line 1561)
ALTER TABLE t2 ADD COLUMN x INT DEFAULT 2 UNIQUE REFERENCES t1 (x)

-- Test 321: statement (line 1565)
ALTER TABLE t2 ADD COLUMN x INT DEFAULT 1 UNIQUE REFERENCES t1 (x)

-- Test 322: query (line 1568)
SHOW CREATE t2

-- Test 323: statement (line 1580)
RESET create_table_with_schema_locked

-- Test 324: statement (line 1585)
CREATE TABLE t50069_a (x INT);
CREATE TABLE t50069_b (x INT);

-- Test 325: statement (line 1589)
ALTER TABLE t50069_a ADD COLUMN y INT AS (t50069_b.x + 1) STORED

-- Test 326: statement (line 1592)
CREATE DATABASE d;
CREATE TABLE d.public.t50069_a (x INT);

-- Test 327: statement (line 1596)
ALTER TABLE t50069_a ADD COLUMN y INT AS (d.public.t50069_a.x + 1) STORED

-- Test 328: statement (line 1600)
DROP TABLE IF EXISTS parent, child;
CREATE TABLE parent (p INT PRIMARY KEY);
CREATE TABLE child (c INT PRIMARY KEY, p INT REFERENCES parent(p), FAMILY (c, p));
ALTER TABLE child DROP COLUMN p

onlyif config schema-locked-disabled

-- Test 329: query (line 1607)
SHOW CREATE child

-- Test 330: query (line 1617)
SHOW CREATE child

-- Test 331: statement (line 1626)
SET create_table_with_schema_locked=false

-- Test 332: statement (line 1630)
CREATE TABLE t52816 (x INT, y INT);
ALTER TABLE t52816 RENAME COLUMN x TO x2, RENAME COLUMN y TO y;
SELECT x2, y FROM t52816

-- Test 333: statement (line 1636)
CREATE TABLE IF NOT EXISTS regression_54196 (
	col1 int,
	col2 int,
	col3 int,
	INDEX (col1, col2),
	INDEX (col1, col3),
	INDEX (col2, col3)
); ALTER TABLE regression_54196 DROP COLUMN col1

-- Test 334: query (line 1646)
SELECT index_name, column_name FROM [SHOW INDEXES FROM regression_54196]
ORDER BY index_name, column_name ASC

-- Test 335: statement (line 1657)
RESET create_table_with_schema_locked

-- Test 336: statement (line 1663)
CREATE TABLE t_cannot_rename_constraint_over_index (
    k INT PRIMARY KEY,
    v INT,
    CONSTRAINT v_unique UNIQUE (v),
    INDEX idx_v (v)
);

-- Test 337: statement (line 1671)
ALTER TABLE t_cannot_rename_constraint_over_index RENAME CONSTRAINT v_unique TO idx_v;

-- Test 338: statement (line 1674)
ALTER TABLE t_cannot_rename_constraint_over_index RENAME CONSTRAINT "t_cannot_rename_constraint_over_index_pkey" TO idx_v;

-- Test 339: statement (line 1679)
CREATE TABLE unique_without_index_error (
  a INT UNIQUE WITHOUT INDEX
)

-- Test 340: statement (line 1684)
CREATE TABLE unique_without_index_error (
  a INT
)

-- Test 341: statement (line 1689)
ALTER TABLE unique_without_index_error ADD CONSTRAINT a_key UNIQUE WITHOUT INDEX (a)

-- Test 342: statement (line 1695)
CREATE TABLE unique_without_index (
  a INT,
  b INT UNIQUE WITHOUT INDEX,
  c INT UNIQUE,
  d INT UNIQUE WITHOUT INDEX,
  e INT,
  UNIQUE WITHOUT INDEX (b),
  UNIQUE WITHOUT INDEX (a, b),
  UNIQUE WITHOUT INDEX (c),
  UNIQUE WITHOUT INDEX (d, e)
)

-- Test 343: statement (line 1708)
CREATE TABLE uwi_child (
  d INT REFERENCES unique_without_index (d),
  e INT,
  CONSTRAINT fk_d_e FOREIGN KEY (d, e) REFERENCES unique_without_index (d, e),
  CONSTRAINT fk_e_d FOREIGN KEY (e, d) REFERENCES unique_without_index (e, d)
)

-- Test 344: statement (line 1718)
ALTER TABLE unique_without_index ADD COLUMN f INT UNIQUE WITHOUT INDEX

-- Test 345: statement (line 1723)
ALTER TABLE unique_without_index ADD COLUMN f INT;
ALTER TABLE unique_without_index ADD CONSTRAINT my_unique_f UNIQUE WITHOUT INDEX (f);
ALTER TABLE unique_without_index ADD CONSTRAINT my_partial_unique_f UNIQUE WITHOUT INDEX (f) WHERE f > 0

-- Test 346: statement (line 1734)
ALTER TABLE unique_without_index ADD CONSTRAINT bad_partial_unique UNIQUE WITHOUT INDEX (f) WHERE g > 0

-- Test 347: statement (line 1739)
INSERT INTO unique_without_index (f) VALUES (1), (1)

-- Test 348: statement (line 1744)
INSERT INTO unique_without_index (e, f) VALUES (1, 1), (1, 2)

-- Test 349: statement (line 1751)
ALTER TABLE unique_without_index ADD CONSTRAINT my_unique_e UNIQUE WITHOUT INDEX (e)

-- Test 350: statement (line 1755)
ALTER TABLE unique_without_index ADD CONSTRAINT my_unique_e UNIQUE WITHOUT INDEX (e) NOT VALID;
ALTER TABLE unique_without_index ADD CONSTRAINT my_unique_e2 UNIQUE WITHOUT INDEX (e) NOT VALID

-- Test 351: statement (line 1761)
ALTER TABLE unique_without_index VALIDATE CONSTRAINT my_unique_e

-- Test 352: statement (line 1766)
DELETE FROM unique_without_index WHERE e = 1 AND f = 1;

-- Test 353: statement (line 1769)
ALTER TABLE unique_without_index VALIDATE CONSTRAINT my_unique_e

-- Test 354: statement (line 1774)
ALTER TABLE unique_without_index VALIDATE CONSTRAINT unique_b;
ALTER TABLE unique_without_index VALIDATE CONSTRAINT unique_a_b;
ALTER TABLE unique_without_index VALIDATE CONSTRAINT unique_c;

-- Test 355: statement (line 1779)
CREATE TABLE unique_without_index_partial (
  a INT,
  b INT,
  c INT
);
INSERT INTO unique_without_index_partial VALUES
  (1, 1, 1),
  (2, 2, 2),
  (1, 3, -3),
  (2, -2, -2),
  (NULL, 4, 4),
  (NULL, 5, 5);

let $constraint_violations_before
SELECT usage_count
  FROM crdb_internal.feature_usage
 WHERE feature_name = 'sql.schema_changer.errors.constraint_violation';

-- Test 356: statement (line 1799)
ALTER TABLE unique_without_index_partial ADD CONSTRAINT uniq_a_1 UNIQUE WITHOUT INDEX (a) WHERE b > 0 OR c > 0

-- Test 357: query (line 1807)
SELECT usage_count > $constraint_violations_before
  FROM crdb_internal.feature_usage
 WHERE feature_name = 'sql.schema_changer.errors.constraint_violation';

-- Test 358: query (line 1814)
SELECT count(usage_count)
  FROM crdb_internal.feature_usage
 WHERE feature_name = 'sql.schema_changer.errors.uncategorized' and usage_count >= 1;

-- Test 359: statement (line 1822)
ALTER TABLE unique_without_index_partial ADD CONSTRAINT uniq_a_1 UNIQUE WITHOUT INDEX (a) WHERE b > 0 OR c > 0 NOT VALID

-- Test 360: statement (line 1826)
ALTER TABLE unique_without_index_partial VALIDATE CONSTRAINT uniq_a_1

-- Test 361: statement (line 1830)
DELETE FROM unique_without_index_partial WHERE a = 1 AND b = 3 AND c = -3;

-- Test 362: statement (line 1833)
ALTER TABLE unique_without_index_partial VALIDATE CONSTRAINT uniq_a_1;

-- Test 363: statement (line 1837)
ALTER TABLE unique_without_index_partial ADD CONSTRAINT uniq_a_2 UNIQUE WITHOUT INDEX (a) WHERE b > 0 OR c > 0

-- Test 364: query (line 1840)
SHOW CONSTRAINTS FROM unique_without_index

-- Test 365: statement (line 1857)
ALTER TABLE unique_without_index RENAME COLUMN a TO aa

-- Test 366: statement (line 1860)
ALTER TABLE unique_without_index RENAME CONSTRAINT unique_b_2 TO unique_b_3

-- Test 367: statement (line 1863)
ALTER TABLE unique_without_index RENAME CONSTRAINT unique_b TO unique_b_1

-- Test 368: statement (line 1866)
ALTER TABLE unique_without_index RENAME CONSTRAINT unique_b TO unique_b_2

-- Test 369: query (line 1869)
SHOW CONSTRAINTS FROM unique_without_index

-- Test 370: statement (line 1885)
ALTER TABLE unique_without_index DROP CONSTRAINT unique_without_index_c_key

-- Test 371: statement (line 1888)
ALTER TABLE unique_without_index DROP CONSTRAINT unique_b

-- Test 372: statement (line 1892)
ALTER TABLE unique_without_index DROP CONSTRAINT unique_b_2

-- Test 373: statement (line 1896)
ALTER TABLE unique_without_index DROP CONSTRAINT my_unique_e2

-- Test 374: query (line 1899)
SHOW CONSTRAINTS FROM unique_without_index

-- Test 375: statement (line 1914)
ALTER TABLE unique_without_index DROP COLUMN b

-- Test 376: query (line 1917)
SHOW CONSTRAINTS FROM unique_without_index

-- Test 377: query (line 1929)
SHOW CONSTRAINTS FROM uwi_child

-- Test 378: statement (line 1938)
ALTER TABLE unique_without_index DROP COLUMN d

-- Test 379: statement (line 1942)
ALTER TABLE unique_without_index DROP COLUMN d CASCADE

-- Test 380: query (line 1945)
SHOW CONSTRAINTS FROM unique_without_index

-- Test 381: query (line 1955)
SHOW CONSTRAINTS FROM uwi_child

-- Test 382: statement (line 1961)
CREATE TABLE t54629 (c INT NOT NULL, UNIQUE INDEX (c));
ALTER TABLE t54629 ADD CONSTRAINT pk PRIMARY KEY (c);
INSERT INTO t54629 VALUES (1);
DELETE FROM t54629 WHERE c = 1;

-- Test 383: statement (line 1969)
SET create_table_with_schema_locked=false

-- Test 384: statement (line 1972)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE t45985 (a INT);
ALTER TABLE t45985 ADD COLUMN b INT;
COMMIT;

-- Test 385: query (line 1979)
SELECT count(descriptor_id)
  FROM (
        SELECT json_array_elements_text(
                crdb_internal.pb_to_json('cockroach.sql.jobs.jobspb.Payload', value)->'descriptorIds'
               )::INT8 AS descriptor_id
          FROM system.job_info WHERE info_key = 'legacy_payload'
       )
 WHERE descriptor_id = ('test.public.t45985'::REGCLASS)::INT8;

-- Test 386: statement (line 1992)
CREATE TABLE t_col_drop (a INT);

-- Test 387: statement (line 1995)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t_col_drop ALTER COLUMN a SET NOT NULL;
ALTER TABLE t_col_drop DROP COLUMN a;

-- Test 388: statement (line 2001)
ROLLBACK

-- Test 389: statement (line 2004)
DROP TABLE t_col_drop

-- Test 390: statement (line 2007)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE t_col_drop (a INT);
ALTER TABLE t_col_drop ALTER COLUMN a SET NOT NULL;
ALTER TABLE t_col_drop DROP COLUMN a;
COMMIT

-- Test 391: query (line 2016)
SELECT feature_name FROM crdb_internal.feature_usage
WHERE feature_name IN ('job.schema_change.successful',
'job.schema_change.failed') AND
usage_count > 0
ORDER BY feature_name DESC

-- Test 392: statement (line 2026)
RESET create_table_with_schema_locked

-- Test 393: statement (line 2033)
CREATE TABLE t61762 ()

-- Test 394: statement (line 2036)
ALTER TABLE t61762 ADD COLUMN v OIDVECTOR

-- Test 395: statement (line 2039)
ALTER TABLE t61762 ADD COLUMN v INT2VECTOR

-- Test 396: statement (line 2042)
ALTER TABLE t61762 ADD COLUMN v OIDVECTOR AS (ARRAY[1]) STORED

-- Test 397: statement (line 2045)
ALTER TABLE t61762 ADD COLUMN v OIDVECTOR AS (ARRAY[1]) VIRTUAL

-- Test 398: statement (line 2048)
ALTER TABLE t61762 ADD COLUMN v INT2VECTOR AS (ARRAY[1]) STORED

-- Test 399: statement (line 2051)
ALTER TABLE t61762 ADD COLUMN v INT2VECTOR AS (ARRAY[1]) VIRTUAL

-- Test 400: statement (line 2057)
SET create_table_with_schema_locked=false

-- Test 401: statement (line 2060)
CREATE TABLE t60786(i INT PRIMARY KEY);

-- Test 402: statement (line 2063)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE child_60786(i INT PRIMARY KEY);
ALTER TABLE t60786 ADD CONSTRAINT fk FOREIGN KEY (i) REFERENCES child_60786(i) NOT VALID;
ALTER TABLE t60786 DROP CONSTRAINT fk CASCADE

-- Test 403: statement (line 2070)
ROLLBACK

-- Test 404: statement (line 2073)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t60786 ADD CONSTRAINT ck CHECK(i > 0) NOT VALID;
ALTER TABLE t60786 DROP CONSTRAINT ck CASCADE

-- Test 405: statement (line 2079)
ROLLBACK

-- Test 406: statement (line 2082)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t60786 ADD CONSTRAINT uq UNIQUE WITHOUT INDEX(i) NOT VALID;
ALTER TABLE t60786 DROP CONSTRAINT uq CASCADE

-- Test 407: statement (line 2088)
ROLLBACK

-- Test 408: statement (line 2091)
RESET create_table_with_schema_locked

-- Test 409: statement (line 2095)
CREATE TABLE visible_table (a int primary key)

-- Test 410: statement (line 2098)
ALTER TABLE visible_table ALTER COLUMN a SET VISIBLE

-- Test 411: statement (line 2101)
ALTER TABLE visible_table ALTER COLUMN non_existent_column SET VISIBLE

onlyif config schema-locked-disabled

-- Test 412: query (line 2105)
SHOW CREATE TABLE visible_table

-- Test 413: query (line 2114)
SHOW CREATE TABLE visible_table

-- Test 414: statement (line 2122)
ALTER TABLE visible_table ALTER COLUMN a SET NOT VISIBLE

onlyif config schema-locked-disabled

-- Test 415: query (line 2126)
SHOW CREATE TABLE visible_table

-- Test 416: query (line 2135)
SHOW CREATE TABLE visible_table

-- Test 417: statement (line 2145)
CREATE TABLE new_table()

-- Test 418: query (line 2150)
CREATE TABLE IF NOT EXISTS new_table();

-- Test 419: statement (line 2157)
CREATE TABLE duplicate_index_test (k INT PRIMARY KEY, v INT, INDEX idx (v));

-- Test 420: statement (line 2160)
ALTER TABLE duplicate_index_test ADD CONSTRAINT idx UNIQUE (v)

-- Test 421: statement (line 2167)
DROP TABLE IF EXISTS t;

-- Test 422: statement (line 2170)
CREATE TABLE t (i INT PRIMARY KEY, j INT);
ALTER TABLE t ADD CONSTRAINT fk FOREIGN KEY (j) REFERENCES t(i) NOT VALID;

-- Test 423: statement (line 2175)
INSERT INTO t VALUES (1, 0)

-- Test 424: statement (line 2178)
DROP TABLE t;

-- Test 425: statement (line 2184)
CREATE TABLE t67234 (k INT PRIMARY KEY, a INT, b INT, FAMILY (k, a, b));

-- Test 426: statement (line 2187)
ALTER TABLE t67234 ADD CONSTRAINT t67234_c1 UNIQUE (a) WHERE b > 0;

-- Test 427: statement (line 2190)
ALTER TABLE t67234 ADD CONSTRAINT t67234_c2 UNIQUE WITHOUT INDEX (b) WHERE a > 0

onlyif config schema-locked-disabled

-- Test 428: query (line 2194)
SELECT create_statement FROM [SHOW CREATE TABLE t67234]

-- Test 429: query (line 2208)
SELECT create_statement FROM [SHOW CREATE TABLE t67234]

-- Test 430: statement (line 2222)
DROP TABLE IF EXISTS t;

-- Test 431: statement (line 2225)
CREATE TABLE t (a INT UNIQUE)

-- Test 432: statement (line 2228)
ALTER TABLE t ADD COLUMN b INT GENERATED ALWAYS AS IDENTITY

-- Test 433: statement (line 2231)
INSERT INTO t (b) VALUES (2)

-- Test 434: statement (line 2234)
ALTER TABLE t ADD COLUMN c INT GENERATED BY DEFAULT AS IDENTITY

onlyif config schema-locked-disabled

-- Test 435: query (line 2238)
SHOW CREATE TABLE t

-- Test 436: query (line 2251)
SHOW CREATE TABLE t

-- Test 437: statement (line 2263)
INSERT INTO t (c) VALUES (2)

-- Test 438: statement (line 2266)
ALTER TABLE t ADD COLUMN d SERIAL GENERATED BY DEFAULT AS IDENTITY

onlyif config schema-locked-disabled

-- Test 439: query (line 2270)
SHOW CREATE TABLE t

-- Test 440: query (line 2284)
SHOW CREATE TABLE t

-- Test 441: statement (line 2297)
INSERT INTO t (c) VALUES (2)

-- Test 442: statement (line 2300)
DROP TABLE t

-- Test 443: statement (line 2305)
SET serial_normalization = rowid

-- Test 444: statement (line 2308)
CREATE TABLE t(a INT PRIMARY KEY)

-- Test 445: statement (line 2311)
ALTER TABLE t ADD COLUMN b SERIAL GENERATED ALWAYS AS IDENTITY

-- Test 446: query (line 2314)
SELECT crdb_internal.pb_to_json('desc', descriptor)->'table'->'columns'->1->>'defaultExpr'
FROM system.descriptor
WHERE id = 't'::regclass::oid

-- Test 447: query (line 2321)
SELECT crdb_internal.pb_to_json('desc', descriptor)->'table'->'columns'->1->>'generatedAsIdentityType'
FROM system.descriptor
WHERE id = 't'::regclass::oid

-- Test 448: statement (line 2329)
ALTER TABLE t ALTER COLUMN b DROP IDENTITY;

onlyif config schema-locked-disabled

-- Test 449: statement (line 2333)
ALTER TABLE t ALTER COLUMN b SET CYCLE;

-- Test 450: statement (line 2336)
DROP TABLE t;

-- Test 451: statement (line 2342)
DROP TABLE IF EXISTS t;

-- Test 452: statement (line 2345)
CREATE TABLE t (a INT UNIQUE)

-- Test 453: statement (line 2348)
ALTER TABLE t ADD COLUMN b INT GENERATED ALWAYS AS IDENTITY (START 1 INCREMENT 3)

-- Test 454: statement (line 2351)
ALTER TABLE t ADD COLUMN c INT GENERATED ALWAYS AS IDENTITY (START 1 INCREMENT 3
 CACHE 10)

-- Test 455: statement (line 2355)
ALTER TABLE t DROP COLUMN c

-- Test 456: statement (line 2358)
INSERT INTO t (a) VALUES (7), (8), (9)

-- Test 457: query (line 2364)
SELECT a, b - lag(b, 1) OVER (ORDER BY a) FROM t ORDER BY a;

-- Test 458: statement (line 2371)
INSERT INTO t (a, b) VALUES (10, 2)

-- Test 459: statement (line 2374)
ALTER TABLE t ALTER COLUMN b SET DEFAULT 10

-- Test 460: statement (line 2377)
ALTER TABLE t ALTER COLUMN b TYPE numeric(10,2)

-- Test 461: statement (line 2380)
DROP TABLE IF EXISTS t;

-- Test 462: statement (line 2383)
CREATE TABLE t (a INT UNIQUE)

-- Test 463: statement (line 2386)
ALTER TABLE t ADD COLUMN b INT GENERATED BY DEFAULT AS IDENTITY (START 1 INCREMENT 3)

-- Test 464: statement (line 2389)
ALTER TABLE t ADD COLUMN c INT GENERATED BY DEFAULT AS IDENTITY (START 1 INCREMENT 3
 CACHE 10)

onlyif config schema-locked-disabled

-- Test 465: query (line 2394)
SHOW CREATE TABLE t

-- Test 466: query (line 2407)
SHOW CREATE TABLE t

-- Test 467: statement (line 2419)
ALTER TABLE t DROP COLUMN c

-- Test 468: statement (line 2422)
INSERT INTO t (a) VALUES (7), (8), (9)

-- Test 469: query (line 2425)
SELECT * FROM t ORDER BY a

-- Test 470: statement (line 2432)
INSERT INTO t (a, b) VALUES (10, 2)

-- Test 471: query (line 2435)
SELECT * FROM t ORDER BY a

-- Test 472: statement (line 2443)
ALTER TABLE t ALTER COLUMN b SET DEFAULT 10

-- Test 473: statement (line 2446)
ALTER TABLE t ALTER COLUMN b TYPE numeric(10,2)

-- Test 474: statement (line 2450)
DROP TABLE IF EXISTS t;

-- Test 475: statement (line 2453)
CREATE TABLE t (id INT NOT NULL)

-- Test 476: statement (line 2456)
ALTER TABLE t ADD CONSTRAINT t_pkey PRIMARY KEY (id)

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 477: query (line 2461)
SHOW CREATE TABLE t

-- Test 478: query (line 2470)
SHOW CREATE TABLE t

-- Test 479: statement (line 2479)
DROP TABLE IF EXISTS t;

-- Test 480: statement (line 2482)
CREATE TABLE t (
  id INT NOT NULL,
  rowid INT8 NOT VISIBLE NOT NULL DEFAULT unique_rowid(),
  CONSTRAINT t_pk PRIMARY KEY (rowid),
  CONSTRAINT t_pkey UNIQUE (id)
)

-- Test 481: statement (line 2490)
ALTER TABLE t ADD CONSTRAINT t_pkey PRIMARY KEY (id)

-- Test 482: statement (line 2495)
DROP TABLE IF EXISTS t;

-- Test 483: statement (line 2498)
CREATE TABLE t (
  id INT NOT NULL,
  explicit_rowid INT8 NOT VISIBLE NOT NULL DEFAULT unique_rowid(),
  CONSTRAINT t_pk PRIMARY KEY (explicit_rowid)
)

-- Test 484: statement (line 2505)
ALTER TABLE t ADD CONSTRAINT t_pkey PRIMARY KEY (id)

-- Test 485: statement (line 2508)
DROP TABLE IF EXISTS t;

-- Test 486: statement (line 2511)
CREATE TABLE public.t (
   id INT8 NOT NULL,
   rowid INT8 NOT VISIBLE NOT NULL,
   CONSTRAINT t_pkey PRIMARY KEY (id ASC)
)

-- Test 487: statement (line 2518)
ALTER TABLE t ADD CONSTRAINT t_pkey PRIMARY KEY (id)

-- Test 488: statement (line 2521)
DROP TABLE IF EXISTS t;

-- Test 489: statement (line 2524)
CREATE TABLE public.t (
   id INT8 NOT NULL,
   rowid INT4 NOT VISIBLE NOT NULL DEFAULT unique_rowid(),
   CONSTRAINT t_pkey PRIMARY KEY (id ASC)
)

-- Test 490: statement (line 2531)
ALTER TABLE t ADD CONSTRAINT t_pkey PRIMARY KEY (id)

-- Test 491: statement (line 2541)
BEGIN

-- Test 492: statement (line 2544)
CREATE TABLE colref (id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY);
CREATE TABLE colsource (id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY);

-- Test 493: statement (line 2551)
ALTER TABLE colsource DROP COLUMN description, DROP COLUMN customer_id

-- Test 494: statement (line 2557)
COMMIT

-- Test 495: statement (line 2571)
INSERT INTO multipleinstmt (key, value) VALUES ('a', 'a');
INSERT INTO multipleinstmt (key, value) VALUES ('b', 'b');
INSERT INTO multipleinstmt (key, value) VALUES ('c', 'c');


skipif config schema-locked-disabled

-- Test 496: statement (line 2578)
ALTER TABLE multipleinstmt SET (schema_locked=false)

-- Test 497: statement (line 2589)
ALTER TABLE multipleinstmt SET (schema_locked=true)

-- Test 498: query (line 2592)
SELECT * FROM multipleinstmt ORDER BY key ASC;

-- Test 499: query (line 2603)
SELECT * FROM multipleinstmt ORDER BY key ASC;

-- Test 500: statement (line 2617)
SET use_declarative_schema_changer = 'off';

-- Test 501: statement (line 2620)
SET create_table_with_schema_locked=false

-- Test 502: query (line 2632)
SELECT count(*) FROM [SHOW KV TRACE FOR SESSION] WHERE message LIKE '%sending batch%' AND message LIKE '% Put to %';

-- Test 503: query (line 2637)
SELECT count(*) FROM tb WHERE v = 'abc';

-- Test 504: statement (line 2642)
ROLLBACK;

-- Test 505: statement (line 2647)
SET CLUSTER SETTING bulkio.column_backfill.update_chunk_size_threshold_bytes = 1;

-- Test 506: query (line 2658)
SELECT count(*) FROM [SHOW KV TRACE FOR SESSION] WHERE message LIKE '%sending batch%' AND message LIKE '% Put to %';

-- Test 507: query (line 2663)
SELECT count(*) FROM tb WHERE v = 'abc';

-- Test 508: statement (line 2668)
ROLLBACK;

-- Test 509: statement (line 2672)
RESET CLUSTER SETTING bulkio.column_backfill.update_chunk_size_threshold_bytes;

-- Test 510: statement (line 2675)
SET use_declarative_schema_changer = $use_decl_sc;

-- Test 511: statement (line 2678)
RESET create_table_with_schema_locked

-- Test 512: statement (line 2683)
CREATE TABLE storage_param_table()

-- Test 513: statement (line 2686)
ALTER TABLE storage_param_table SET (foo=100)

-- Test 514: statement (line 2689)
ALTER TABLE storage_param_table SET (fillfactor=true)

-- Test 515: statement (line 2692)
ALTER TABLE storage_param_table SET (toast_tuple_target=100)

-- Test 516: query (line 2697)
ALTER TABLE storage_param_table SET (fillfactor=99.9, autovacuum_enabled = off)

-- Test 517: statement (line 2703)
ALTER TABLE storage_param_table SET (autovacuum_enabled='11')

-- Test 518: statement (line 2709)
ALTER TABLE storage_param_table RESET (foo)

-- Test 519: statement (line 2712)
ALTER TABLE storage_param_table RESET (fillfactor, toast_tuple_target)

-- Test 520: statement (line 2721)
SET create_table_with_schema_locked=false

-- Test 521: statement (line 2724)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
create table const_tbl (a int, b int, constraint "bob" primary key (a, b));
alter table const_tbl drop constraint "bob";
alter table const_tbl add constraint "bob" primary key (a, b); -- this statement
COMMIT;

-- Test 522: statement (line 2732)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
alter table const_tbl drop constraint "bob";
alter table const_tbl add constraint "bob" primary key (a, b); -- this statement
alter table const_tbl drop constraint "bob";
COMMIT;

-- Test 523: statement (line 2748)
alter table const_tbl add constraint "dave" CHECK (a > 100);

-- Test 524: statement (line 2751)
rollback

-- Test 525: statement (line 2754)
alter table const_tbl add constraint "steve" CHECK (a > 100);

-- Test 526: statement (line 2757)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
alter table const_tbl drop constraint "steve";
alter table const_tbl add constraint "steve" CHECK (a > 100);
COMMIT;

-- Test 527: statement (line 2766)
rollback

-- Test 528: statement (line 2770)
RESET create_table_with_schema_locked

-- Test 529: statement (line 2776)
SET serial_normalization = sql_sequence;

-- Test 530: statement (line 2779)
CREATE TABLE test_serial (
	a INT PRIMARY KEY
);

-- Test 531: statement (line 2784)
ALTER TABLE test_serial ADD COLUMN b SERIAL;

-- Test 532: query (line 2787)
SELECT l.table_id, l.name, l.state, r.refobjid
FROM (
  SELECT table_id, name, state
  FROM crdb_internal.tables WHERE name
  LIKE 'test_serial%' AND state = 'PUBLIC'
) l
LEFT JOIN pg_catalog.pg_depend r ON l.table_id = r.objid;

-- Test 533: statement (line 2800)
DROP TABLE test_serial;

-- Test 534: query (line 2803)
SELECT l.table_id, l.name, l.state, r.refobjid
FROM (
  SELECT table_id, name, state
  FROM crdb_internal.tables WHERE name
  LIKE 'test_serial%' AND state = 'PUBLIC'
) l
LEFT JOIN pg_catalog.pg_depend r ON l.table_id = r.objid;

-- Test 535: statement (line 2814)
CREATE TABLE test_serial (
	a INT PRIMARY KEY
);

-- Test 536: statement (line 2819)
ALTER TABLE test_serial ADD COLUMN b SERIAL;

-- Test 537: query (line 2822)
SELECT l.table_id, l.name, l.state, r.refobjid
FROM (
  SELECT table_id, name, state
  FROM crdb_internal.tables WHERE name
  LIKE 'test_serial%' AND state = 'PUBLIC'
) l
LEFT JOIN pg_catalog.pg_depend r ON l.table_id = r.objid;

-- Test 538: statement (line 2835)
ALTER TABLE test_serial DROP COLUMN b;

-- Test 539: query (line 2838)
SELECT l.table_id, l.name, l.state, r.refobjid
FROM (
  SELECT table_id, name, state
  FROM crdb_internal.tables WHERE name
  LIKE 'test_serial%' AND state = 'PUBLIC'
) l
LEFT JOIN pg_catalog.pg_depend r ON l.table_id = r.objid;

-- Test 540: statement (line 2850)
DROP TABLE test_serial;

-- Test 541: statement (line 2857)
SET create_table_with_schema_locked=false

-- Test 542: statement (line 2860)
CREATE TABLE pk_fk_src(id int8 primary key, legacy_id int8 not null);
CREATE TABLE pk_fk_ref(a_id int8 references pk_fk_src (id));

-- Test 543: statement (line 2864)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE pk_fk_src DROP CONSTRAINT "pk_fk_src_pkey";
ALTER TABLE pk_fk_src ADD CONSTRAINT "pk_fk_src_pkey" PRIMARY KEY (legacy_id);
COMMIT;

-- Test 544: statement (line 2871)
ROLLBACK;

-- Test 545: statement (line 2874)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE pk_fk_src DROP CONSTRAINT "pk_fk_src_pkey";
ALTER TABLE pk_fk_src ADD CONSTRAINT "pk_fk_src_pkey_new" PRIMARY KEY (legacy_id);
COMMIT;

-- Test 546: statement (line 2881)
ROLLBACK;

-- Test 547: statement (line 2885)
RESET create_table_with_schema_locked

-- Test 548: statement (line 2891)
CREATE TABLE t5 (a int)

-- Test 549: statement (line 2895)
ALTER TABLE t5 SET (sql_stats_automatic_collection_enabled = true)

-- Test 550: query (line 2899)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->'autoStatsSettings'
FROM
    crdb_internal.tables AS tbl
    INNER JOIN system.descriptor AS d ON d.id = tbl.table_id
WHERE
    tbl.name = 't5'
    AND tbl.drop_time IS NULL
    AND crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                                      d.descriptor, false)->'table'->'autoStatsSettings'
                                      ->> 'enabled' = 'true'

-- Test 551: statement (line 2916)
ALTER TABLE t5 SET (sql_stats_automatic_collection_enabled = 'false')

-- Test 552: query (line 2920)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->'autoStatsSettings'
FROM
    crdb_internal.tables AS tbl
    INNER JOIN system.descriptor AS d ON d.id = tbl.table_id
WHERE
    tbl.name = 't5'
    AND tbl.drop_time IS NULL
    AND crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                                      d.descriptor, false)->'table'->'autoStatsSettings'
                                      ->> 'enabled' = 'false'

-- Test 553: query (line 2940)
SELECT create_statement FROM [SHOW CREATE TABLE t5]

-- Test 554: query (line 2950)
SELECT create_statement FROM [SHOW CREATE TABLE t5]

-- Test 555: statement (line 2959)
ALTER TABLE t5 SET (sql_stats_automatic_collection_enabled = 123)

-- Test 556: statement (line 2962)
ALTER TABLE t5 RESET (sql_stats_automatic_collection_enabled)

-- Test 557: query (line 2966)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->>'autoStatsSettings'
FROM
    crdb_internal.tables AS tbl
    INNER JOIN system.descriptor AS d ON d.id = tbl.table_id
WHERE
    tbl.name = 't5'
    AND tbl.drop_time IS NULL

-- Test 558: statement (line 2979)
ALTER TABLE t5 SET (sql_stats_automatic_collection_fraction_stale_rows = 'hello')

-- Test 559: statement (line 2982)
ALTER TABLE t5 SET (sql_stats_automatic_collection_min_stale_rows = 'world')

-- Test 560: statement (line 2986)
ALTER TABLE t5 SET (sql_stats_automatic_collection_fraction_stale_rows = '0.15',
                    sql_stats_automatic_collection_min_stale_rows = '1234')

-- Test 561: query (line 2991)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->>'autoStatsSettings'
FROM
    crdb_internal.tables AS tbl
    INNER JOIN system.descriptor AS d ON d.id = tbl.table_id
WHERE
    tbl.name = 't5'
    AND tbl.drop_time IS NULL

-- Test 562: query (line 3005)
SELECT create_statement FROM [SHOW CREATE TABLE t5]

-- Test 563: query (line 3015)
SELECT create_statement FROM [SHOW CREATE TABLE t5]

-- Test 564: statement (line 3028)
ALTER TABLE t5 SET (sql_stats_forecasts_enabled = true)

-- Test 565: query (line 3031)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->>'forecastStats'
FROM
    system.namespace AS ns
    INNER JOIN system.descriptor AS d ON d.id = ns.id
WHERE
    ns.name = 't5'

-- Test 566: statement (line 3043)
ALTER TABLE t5 SET (sql_stats_forecasts_enabled = false)

-- Test 567: query (line 3046)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->>'forecastStats'
FROM
    system.namespace AS ns
    INNER JOIN system.descriptor AS d ON d.id = ns.id
WHERE
    ns.name = 't5'

-- Test 568: statement (line 3058)
ALTER TABLE t5 RESET (sql_stats_forecasts_enabled)

-- Test 569: query (line 3061)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->'forecastStats'
FROM
    system.namespace AS ns
    INNER JOIN system.descriptor AS d ON d.id = ns.id
WHERE
    ns.name = 't5'

-- Test 570: statement (line 3073)
ALTER TABLE t5 SET (sql_stats_forecasts_enabled = 'invalid')

-- Test 571: statement (line 3080)
ALTER TABLE t5 SET (sql_stats_automatic_partial_collection_min_stale_rows = 1000)

-- Test 572: query (line 3083)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->'autoStatsSettings'->>'partialMinStaleRows'
FROM
    system.namespace AS ns
    INNER JOIN system.descriptor AS d ON d.id = ns.id
WHERE
    ns.name = 't5'

-- Test 573: statement (line 3095)
ALTER TABLE t5 RESET (sql_stats_automatic_partial_collection_min_stale_rows)

-- Test 574: statement (line 3098)
ALTER TABLE t5 SET (sql_stats_automatic_partial_collection_min_stale_rows = -1)

-- Test 575: statement (line 3105)
ALTER TABLE t5 SET (sql_stats_automatic_partial_collection_fraction_stale_rows = 0.25)

-- Test 576: query (line 3108)
SELECT
    crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor',
                              d.descriptor, false)->'table'->'autoStatsSettings'->>'partialFractionStaleRows'
FROM
    system.namespace AS ns
    INNER JOIN system.descriptor AS d ON d.id = ns.id
WHERE
    ns.name = 't5'

-- Test 577: statement (line 3120)
ALTER TABLE t5 RESET (sql_stats_automatic_partial_collection_fraction_stale_rows)

-- Test 578: statement (line 3123)
ALTER TABLE t5 SET (sql_stats_automatic_partial_collection_fraction_stale_rows = -0.5)

-- Test 579: statement (line 3126)
DROP TABLE t5

-- Test 580: statement (line 3138)
CREATE TABLE t_index_params (a INT PRIMARY KEY, b INT)

-- Test 581: statement (line 3141)
CREATE INDEX idx ON t_index_params (b) WITH (vacuum_cleanup_index_scale_factor = 0.1)

-- Test 582: statement (line 3144)
CREATE INDEX idx ON t_index_params (b) WITH (buffering = 'on')

-- Test 583: statement (line 3147)
CREATE INDEX idx ON t_index_params (b) WITH (fastupdate = true)

-- Test 584: statement (line 3150)
CREATE INDEX idx ON t_index_params (b) WITH (gin_pending_list_limit = 1000)

-- Test 585: statement (line 3153)
CREATE INDEX idx ON t_index_params (b) WITH (pages_per_range = 128)

-- Test 586: statement (line 3156)
CREATE INDEX idx ON t_index_params (b) WITH (autosummarize = true)

-- Test 587: statement (line 3159)
DROP TABLE t_index_params

-- Test 588: statement (line 3166)
create table t81448 (a int primary key);
insert into t81448 values (1), (2), (3)

-- Test 589: statement (line 3170)
alter table t81448 add column b float8 unique default (random())

-- Test 590: statement (line 3173)
create table t81448_b as select b from t81448@t81448_pkey;

-- Test 591: query (line 3178)
select (select count(*) from t81448@t81448_b_key bk inner join t81448_b cp on (cp.b = bk.b))

-- Test 592: statement (line 3183)
drop table t81448, t81448_b

-- Test 593: statement (line 3188)
DROP TABLE IF EXISTS tbl

-- Test 594: statement (line 3191)
CREATE TABLE tbl (i INT PRIMARY KEY)

-- Test 595: statement (line 3194)
CREATE SEQUENCE IF NOT EXISTS s1

-- Test 596: statement (line 3197)
CREATE SEQUENCE IF NOT EXISTS s2

-- Test 597: statement (line 3200)
ALTER TABLE tbl ADD COLUMN j INT NOT NULL DEFAULT nextval('s1') ON UPDATE nextval('s2')

onlyif config schema-locked-disabled

-- Test 598: query (line 3204)
SHOW CREATE TABLE tbl

-- Test 599: query (line 3214)
SHOW CREATE TABLE tbl

-- Test 600: statement (line 3225)
ALTER TABLE tbl ALTER COLUMN j SET DEFAULT nextval('s2')

-- Test 601: statement (line 3228)
ALTER TABLE tbl ALTER COLUMN j SET ON UPDATE nextval('s1')

onlyif config schema-locked-disabled

-- Test 602: query (line 3232)
SHOW CREATE TABLE tbl

-- Test 603: query (line 3242)
SHOW CREATE TABLE tbl

-- Test 604: statement (line 3255)
CREATE TABLE t_add_column_not_null (i INT PRIMARY KEY);
INSERT INTO t_add_column_not_null VALUES (1), (2), (3)

-- Test 605: statement (line 3259)
ALTER TABLE t_add_column_not_null ADD COLUMN j INT NOT NULL DEFAULT (NULL:::INT)

-- Test 606: statement (line 3262)
ALTER TABLE t_add_column_not_null ADD COLUMN j INT GENERATED ALWAYS AS (NULL:::INT) STORED NOT NULL;

-- Test 607: statement (line 3267)
ALTER TABLE t_add_column_not_null ADD COLUMN j INT GENERATED ALWAYS AS (NULL::INT) VIRTUAL NOT NULL UNIQUE;

onlyif config local-legacy-schema-changer

-- Test 608: statement (line 3271)
ALTER TABLE t_add_column_not_null ADD COLUMN j INT GENERATED ALWAYS AS (NULL::INT) VIRTUAL NOT NULL UNIQUE;

-- Test 609: statement (line 3274)
ALTER TABLE t_add_column_not_null ADD COLUMN j INT GENERATED ALWAYS AS (NULL::INT) VIRTUAL NOT NULL;

-- Test 610: statement (line 3277)
DROP TABLE t_add_column_not_null

-- Test 611: statement (line 3282)
CREATE TABLE t81448 (a INT PRIMARY KEY)

-- Test 612: statement (line 3285)
ALTER TABLE t81448 ADD COLUMN b INT PRIMARY KEY

-- Test 613: statement (line 3288)
DROP TABLE t81448

-- Test 614: statement (line 3293)
CREATE TABLE t1_unique_array (n INT8);

-- Test 615: statement (line 3296)
ALTER TABLE t1_unique_array ADD COLUMN x CHAR(256)[] UNIQUE;

-- Test 616: statement (line 3301)
CREATE TABLE t_89025 (i int primary key);

-- Test 617: statement (line 3304)
INSERT INTO t_89025 VALUES (1)

-- Test 618: statement (line 3307)
ALTER TABLE t_89025 ADD COLUMN j INT DEFAULT (crdb_internal.lease_holder('a'));

-- Test 619: statement (line 3310)
DROP TABLE t_89025

-- Test 620: statement (line 3319)
create table t_with_dropped_index_expr (i INT PRIMARY KEY, j INT, INDEX((j+1)));

-- Test 621: statement (line 3325)
SET CLUSTER SETTING jobs.debug.pausepoints="newschemachanger.before.exec";

skipif config local-legacy-schema-changer

-- Test 622: statement (line 3329)
ALTER TABLE t_with_dropped_index_expr DROP COLUMN j CASCADE;

-- Test 623: statement (line 3332)
SET CLUSTER SETTING jobs.debug.pausepoints="";

-- Test 624: query (line 3335)
SELECT count(*) from t_with_dropped_index_expr;

-- Test 625: statement (line 3340)
RESUME JOB (SELECT job_id FROM crdb_internal.jobs WHERE description LIKE 'ALTER TABLE %t_with_dropped_index_expr DROP COLUMN j CASCADE%' AND status='paused' FETCH FIRST 1 ROWS ONLY);

-- Test 626: statement (line 3350)
CREATE TABLE t_93398 (c1 INT);
INSERT INTO t_93398 VALUES (0);

-- Test 627: statement (line 3354)
ALTER TABLE t_93398 ADD COLUMN c2 DECIMAL DEFAULT pi();

-- Test 628: query (line 3357)
SELECT * FROM t_93398;

-- Test 629: statement (line 3362)
ALTER TABLE t_93398 ADD COLUMN c3 CHAR(1) DEFAULT 'foo'::TEXT;

-- Test 630: statement (line 3365)
ALTER TABLE t_93398 ADD COLUMN c3 "char" DEFAULT 'foo'::TEXT;

-- Test 631: query (line 3368)
SELECT c1, c3 FROM t_93398;

-- Test 632: statement (line 3382)
CREATE SEQUENCE seq_96115;

-- Test 633: statement (line 3385)
CREATE TYPE typ_96115 AS ENUM ('a', 'b');

-- Test 634: statement (line 3391)
ALTER TABLE t_96115 ADD CHECK (i > nextval('seq_96115') AND j::typ_96115 = 'a'::typ_96115);

skipif config local-legacy-schema-changer

-- Test 635: query (line 3395)
SELECT table_name, constraint_name, constraint_type, validated
FROM [SHOW CONSTRAINTS FROM t_96115]
ORDER BY constraint_type;

-- Test 636: statement (line 3404)
ALTER TABLE t_96115 DROP CONSTRAINT check_i_j;

skipif config local-legacy-schema-changer

-- Test 637: query (line 3408)
SELECT table_name, constraint_name, constraint_type, validated
FROM [SHOW CONSTRAINTS FROM t_96115]
ORDER BY constraint_type;

-- Test 638: statement (line 3416)
ALTER TABLE t_96115 ADD CHECK (i > nextval('seq_96115') AND j::typ_96115 = 'a'::typ_96115);

skipif config local-legacy-schema-changer

-- Test 639: query (line 3420)
SELECT table_name, constraint_name, constraint_type, validated
FROM [SHOW CONSTRAINTS FROM t_96115]
ORDER BY constraint_type;

-- Test 640: statement (line 3429)
DROP SEQUENCE seq_96115 CASCADE;

skipif config local-legacy-schema-changer

-- Test 641: query (line 3433)
SELECT table_name, constraint_name, constraint_type, validated
FROM [SHOW CONSTRAINTS FROM t_96115]
ORDER BY constraint_type;

-- Test 642: statement (line 3441)
CREATE SEQUENCE seq_96115;

-- Test 643: statement (line 3444)
ALTER TABLE t_96115 ADD CHECK (i > nextval('seq_96115') AND j::typ_96115 = 'a'::typ_96115);

-- Test 644: statement (line 3447)
DROP TABLE t_96115;

-- Test 645: statement (line 3450)
DROP TYPE typ_96115;

-- Test 646: statement (line 3453)
DROP SEQUENCE seq_96115

-- Test 647: statement (line 3459)
CREATE TABLE t_96115 (i INT PRIMARY KEY, j INT);

-- Test 648: statement (line 3465)
ALTER TABLE t_96115 ADD UNIQUE WITHOUT INDEX (j) WHERE j > 0;

-- Test 649: query (line 3468)
SELECT table_name, constraint_name, constraint_type, validated
FROM [SHOW CONSTRAINTS FROM t_96115]
ORDER BY constraint_type;

-- Test 650: statement (line 3477)
ALTER TABLE t_96115 DROP CONSTRAINT unique_j;

-- Test 651: query (line 3480)
SELECT table_name, constraint_name, constraint_type, validated
FROM [SHOW CONSTRAINTS FROM t_96115]
ORDER BY constraint_type;

-- Test 652: statement (line 3488)
DROP TABLE t_96115;

-- Test 653: statement (line 3496)
CREATE TABLE t_96648 (i INT PRIMARY KEY);

-- Test 654: statement (line 3499)
ALTER TABLE t_96648 ADD CONSTRAINT check_i CHECK (i > 0), VALIDATE CONSTRAINT check_i;

-- Test 655: statement (line 3502)
ALTER TABLE t_96648 ADD CONSTRAINT check_i CHECK (i > 0);

-- Test 656: statement (line 3506)
INSERT INTO t_96648 VALUES (0);

skipif config schema-locked-disabled

-- Test 657: statement (line 3510)
ALTER TABLE t_96648 SET (schema_locked=false)

-- Test 658: statement (line 3513)
ALTER TABLE t_96648 ADD CONSTRAINT check_i1 CHECK (i > 10) NOT VALID, VALIDATE CONSTRAINT check_i1;

skipif config schema-locked-disabled

-- Test 659: statement (line 3517)
ALTER TABLE t_96648 SET (schema_locked=true)

-- Test 660: statement (line 3521)
INSERT INTO t_96648 VALUES (5)

-- Test 661: statement (line 3524)
ALTER TABLE t_96648 DROP CONSTRAINT check_i, VALIDATE CONSTRAINT check_i;

-- Test 662: statement (line 3527)
ALTER TABLE t_96648 DROP CONSTRAINT check_i1, VALIDATE CONSTRAINT check_i1;

-- Test 663: statement (line 3530)
ALTER TABLE t_96648 DROP CONSTRAINT check_i, DROP CONSTRAINT check_i1;

-- Test 664: statement (line 3533)
DROP TABLE t_96648

-- Test 665: statement (line 3540)
CREATE TABLE t_97538_2 (i INT PRIMARY KEY, j INT);

-- Test 666: statement (line 3546)
ALTER TABLE t_97538_2 ADD UNIQUE WITHOUT INDEX (j);

-- Test 667: statement (line 3549)
CREATE UNIQUE INDEX t_97538_2_j_key on t_97538_2(j);

-- Test 668: statement (line 3552)
CREATE TABLE t_97538_1 (i INT PRIMARY KEY REFERENCES t_97538_2(j));

-- Test 669: statement (line 3555)
DROP INDEX t_97538_2_j_key;

-- Test 670: query (line 3560)
SHOW CONSTRAINTS FROM t_97538_1

-- Test 671: statement (line 3568)
CREATE UNIQUE INDEX t_97538_2_j_key on t_97538_2(j);

-- Test 672: statement (line 3571)
ALTER TABLE t_97538_2 DROP CONSTRAINT unique_j;

-- Test 673: query (line 3576)
SHOW CONSTRAINTS FROM t_97538_1

-- Test 674: statement (line 3583)
DROP INDEX t_97538_2_j_key CASCADE;

-- Test 675: query (line 3587)
SHOW CONSTRAINTS FROM t_97538_1

-- Test 676: statement (line 3597)
CREATE TABLE t_96727_2 (i INT PRIMARY KEY, j INT UNIQUE, FAMILY (i, j));

-- Test 677: statement (line 3603)
ALTER TABLE t_96727_2 ADD UNIQUE WITHOUT INDEX (j);

-- Test 678: statement (line 3606)
CREATE TABLE t_96727_1 (i INT PRIMARY KEY REFERENCES t_96727_2(j));

-- Test 679: statement (line 3611)
ALTER TABLE t_96727_2 DROP COLUMN j;

-- Test 680: statement (line 3614)
ALTER TABLE t_96727_2 DROP COLUMN j CASCADE;

-- Test 681: query (line 3620)
SHOW CREATE TABLE t_96727_2

-- Test 682: query (line 3631)
SHOW CREATE TABLE t_96727_2

-- Test 683: query (line 3641)
SHOW CREATE TABLE t_96727_1

-- Test 684: query (line 3650)
SHOW CREATE TABLE t_96727_1

-- Test 685: statement (line 3659)
ALTER TABLE t_96727_2 ADD COLUMN j INT;

-- Test 686: statement (line 3662)
ALTER TABLE t_96727_2 ADD CHECK (j > 0), ADD CHECK (j < 10) NOT VALID, ADD UNIQUE WITHOUT INDEX (j);

-- Test 687: statement (line 3665)
CREATE UNIQUE INDEX idx ON t_96727_2(j);

-- Test 688: statement (line 3668)
ALTER TABLE t_96727_2 DROP COLUMN j;

-- Test 689: query (line 3674)
SHOW CREATE TABLE t_96727_2

-- Test 690: query (line 3684)
SHOW CREATE TABLE t_96727_2

-- Test 691: statement (line 3695)
CREATE TABLE t_twocol (
  id INT PRIMARY KEY,
  a INT,
  b INT,
  FAMILY fam_0 (id, a, b)
);
CREATE FUNCTION f1() RETURNS t_twocol AS 'SELECT * FROM t_twocol' LANGUAGE SQL;
CREATE FUNCTION f2() RETURNS t_twocol AS 'SELECT * FROM t_twocol' LANGUAGE SQL;
CREATE FUNCTION f3() RETURNS INT AS 'SELECT a FROM t_twocol' LANGUAGE SQL;

-- Test 692: statement (line 3706)
ALTER TABLE t_twocol DROP COLUMN b CASCADE;

-- Test 693: statement (line 3709)
SELECT f1();

-- Test 694: statement (line 3712)
SELECT f2();

onlyif config schema-locked-disabled

-- Test 695: query (line 3716)
SELECT create_statement FROM [SHOW CREATE TABLE t_twocol]

-- Test 696: query (line 3727)
SELECT create_statement FROM [SHOW CREATE TABLE t_twocol]

-- Test 697: statement (line 3737)
DROP TABLE t_twocol CASCADE;

-- Test 698: statement (line 3742)
CREATE TABLE t_twocol (
  id INT PRIMARY KEY,
  a INT,
  b INT,
  FAMILY fam_0 (id, a, b)
);
CREATE FUNCTION f_unqualified_twocol() RETURNS t_twocol AS
$$
  SELECT t_twocol.id, t_twocol.a, t_twocol.b FROM t_twocol;
$$ LANGUAGE SQL;
CREATE FUNCTION f_allcolsel_alias() RETURNS t_twocol AS
$$
  SELECT t1.id, t1.a, t1.b FROM t_twocol AS t1, t_twocol AS t2 WHERE t1.a = t2.a;
$$ LANGUAGE SQL;
CREATE FUNCTION f_tuplestar() RETURNS t_twocol AS
$$
  SELECT t_twocol.id, t_twocol.a, t_twocol.b FROM t_twocol;
$$ LANGUAGE SQL;

-- Test 699: statement (line 3763)
ALTER TABLE t_twocol DROP COLUMN b CASCADE;

onlyif config schema-locked-disabled

-- Test 700: query (line 3767)
SELECT create_statement FROM [SHOW CREATE TABLE t_twocol]

-- Test 701: query (line 3778)
SELECT create_statement FROM [SHOW CREATE TABLE t_twocol]

-- Test 702: statement (line 3791)
CREATE TABLE t_96729 (i INT NOT NULL)

-- Test 703: statement (line 3794)
ALTER TABLE t_96729 ADD PRIMARY KEY (i) NOT VALID;

-- Test 704: statement (line 3797)
ALTER TABLE t_96729 ADD PRIMARY KEY (i);

-- Test 705: query (line 3800)
SHOW CONSTRAINTS FROM t_96729

-- Test 706: statement (line 3809)
CREATE TABLE t_96728 (i INT PRIMARY KEY, j INT, k INT);

-- Test 707: statement (line 3812)
ALTER TABLE t_96728 ADD UNIQUE (j) NOT VALID;

-- Test 708: statement (line 3815)
ALTER TABLE t_96728 ADD UNIQUE (j, k) WHERE (i > 0);

-- Test 709: query (line 3818)
SHOW CONSTRAINTS FROM t_96728

-- Test 710: statement (line 3836)
DROP TABLE IF EXISTS t_99035;
CREATE TABLE t_99035 (i INT PRIMARY KEY, j INT NOT NULL, FAMILY "primary" (i, j));
INSERT INTO t_99035 VALUES (0,0);

skipif config local-legacy-schema-changer

-- Test 711: statement (line 3842)
ALTER TABLE t_99035 ADD COLUMN k INT DEFAULT unique_rowid(), DROP COLUMN j;

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 712: query (line 3847)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 713: query (line 3857)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 714: statement (line 3867)
ALTER TABLE t_99035 ADD COLUMN j INT DEFAULT unique_rowid(), DROP COLUMN j; -- noop

skipif config local-legacy-schema-changer

-- Test 715: statement (line 3871)
ALTER TABLE t_99035 ADD COLUMN j INT, DROP COLUMN j;  -- noop

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 716: query (line 3876)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 717: query (line 3886)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 718: statement (line 3895)
DROP TABLE IF EXISTS t_99035;
CREATE TABLE t_99035 (i INT PRIMARY KEY, j INT NOT NULL, FAMILY "primary" (i, j));
INSERT INTO t_99035 VALUES (0,0);

skipif config local-legacy-schema-changer

-- Test 719: statement (line 3901)
ALTER TABLE t_99035 ADD COLUMN k INT DEFAULT unique_rowid(), ALTER PRIMARY KEY USING COLUMNS (j);

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 720: query (line 3906)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 721: query (line 3918)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 722: statement (line 3929)
DROP TABLE IF EXISTS t_99035;
CREATE TABLE t_99035 (i INT PRIMARY KEY, j INT NOT NULL, FAMILY "primary" (i, j));
INSERT INTO t_99035 VALUES (0,0);

skipif config local-legacy-schema-changer

-- Test 723: statement (line 3935)
ALTER TABLE t_99035 ALTER PRIMARY KEY USING COLUMNS (j), DROP COLUMN i;

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 724: query (line 3940)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 725: query (line 3949)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 726: statement (line 3957)
DROP TABLE IF EXISTS t_99035;
CREATE TABLE t_99035 (i INT PRIMARY KEY, j INT NOT NULL, FAMILY "primary" (i, j));
INSERT INTO t_99035 VALUES (0,0);

skipif config local-legacy-schema-changer

-- Test 727: statement (line 3963)
ALTER TABLE t_99035 ADD COLUMN k INT DEFAULT unique_rowid(), ALTER PRIMARY KEY USING COLUMNS (j), DROP COLUMN i;

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 728: query (line 3968)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 729: query (line 3979)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 730: statement (line 3988)
DROP TABLE IF EXISTS t_99035;
CREATE TABLE t_99035 (i INT PRIMARY KEY, j INT NOT NULL, FAMILY "primary" (i, j));
INSERT INTO t_99035 VALUES (0,0);

skipif config local-legacy-schema-changer

-- Test 731: statement (line 3994)
ALTER TABLE t_99035 ADD COLUMN k INT DEFAULT unique_rowid(), ALTER PRIMARY KEY USING COLUMNS (j), DROP COLUMN i, ADD COLUMN p INT DEFAULT 30, ADD CHECK (j>0);

-- Test 732: query (line 3997)
SELECT * FROM t_99035

-- Test 733: statement (line 4003)
ALTER TABLE t_99035 ADD COLUMN k INT DEFAULT unique_rowid(), ALTER PRIMARY KEY USING COLUMNS (j), DROP COLUMN i, ADD COLUMN p INT DEFAULT 30, ADD CHECK (j>=0);

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 734: query (line 4008)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 735: query (line 4020)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 736: statement (line 4031)
DROP TABLE IF EXISTS t_99035;
CREATE TABLE t_99035 (i INT PRIMARY KEY, j INT NOT NULL, FAMILY "primary" (i, j));
INSERT INTO t_99035 VALUES (0,0);

skipif config local-legacy-schema-changer

-- Test 737: statement (line 4037)
ALTER TABLE t_99035 ADD COLUMN k INT DEFAULT unique_rowid(), ALTER PRIMARY KEY USING COLUMNS (j), DROP COLUMN i, ADD COLUMN p INT DEFAULT 0, ADD CHECK (j>=0), ADD FOREIGN KEY (p) REFERENCES t_99035(j);

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 738: query (line 4042)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 739: query (line 4055)
SELECT create_statement FROM [SHOW CREATE TABLE t_99035]

-- Test 740: statement (line 4073)
CREATE TABLE t_98269 (i INT PRIMARY KEY);
INSERT INTO t_98269 VALUES (0);

-- Test 741: statement (line 4077)
ALTER TABLE t_98269 ADD COLUMN j DECIMAL NOT NULL DEFAULT cluster_logical_timestamp();

-- Test 742: statement (line 4087)
ALTER TABLE IF EXISTS t_non_existent_99185 ADD FOREIGN KEY (i) REFERENCES t_other_99185 (i);

-- Test 743: statement (line 4096)
CREATE TABLE t_99281 (i INT PRIMARY KEY, j INT NOT NULL, k INT NOT NULL, FAMILY "primary" (i,j,k));
INSERT INTO t_99281 VALUES (0,0,0), (1,0,1);

-- Test 744: statement (line 4100)
ALTER TABLE t_99281 ADD UNIQUE WITHOUT INDEX (j);

-- Test 745: statement (line 4103)
ALTER TABLE t_99281 ADD COLUMN p INT DEFAULT unique_rowid(), ADD UNIQUE WITHOUT INDEX (j);

-- Test 746: statement (line 4108)
ALTER TABLE t_99281 DROP COLUMN k, ADD UNIQUE WITHOUT INDEX (j);

-- Test 747: statement (line 4111)
ALTER TABLE t_99281 ADD COLUMN p INT DEFAULT unique_rowid(), ADD CHECK (i > 0);

-- Test 748: statement (line 4114)
ALTER TABLE t_99281 ADD COLUMN p INT DEFAULT unique_rowid(), ADD CHECK (i >= 0), ADD CHECK (j > 0);

-- Test 749: statement (line 4117)
CREATE TABLE t_99281_other (i INT PRIMARY KEY);

-- Test 750: statement (line 4120)
ALTER TABLE t_99281 ADD COLUMN p INT DEFAULT unique_rowid(), ADD FOREIGN KEY (j) REFERENCES t_99281_other;

-- Test 751: statement (line 4125)
ALTER TABLE t_99281 ALTER PRIMARY KEY USING COLUMNS (k), ADD FOREIGN KEY (j) REFERENCES t_99281_other;

onlyif config schema-locked-disabled

-- Test 752: query (line 4129)
show create table t_99281

-- Test 753: query (line 4140)
show create table t_99281

-- Test 754: statement (line 4159)
ALTER TABLE t_99764 DROP COLUMN j CASCADE;

onlyif config schema-locked-disabled
skipif config local-legacy-schema-changer

-- Test 755: query (line 4164)
show create table t_99764

-- Test 756: query (line 4173)
show create table t_99764

-- Test 757: statement (line 4185)
create table t_drop_cascade_with_key(n int primary key, k int);

-- Test 758: statement (line 4188)
alter table t_drop_cascade_with_key add column j int as (n) stored null;

-- Test 759: statement (line 4191)
set sql_safe_updates=false

-- Test 760: statement (line 4194)
alter table t_drop_cascade_with_key drop column n cascade;

-- Test 761: statement (line 4204)
CREATE TABLE t_108974_f(i INT PRIMARY KEY, j INT NOT NULL, k INT, INDEX (i,j));
INSERT INTO t_108974_f SELECT p,p+1,p+2 FROM generate_series(1,100) AS tmp(p);
CREATE TABLE t_108974_v(i INT PRIMARY KEY, j INT NOT NULL, k INT, INDEX (i,j));
INSERT INTO t_108974_v SELECT p,p+1,p+2 FROM generate_series(1,100) AS tmp(p);
CREATE FUNCTION f_108974() RETURNS RECORD LANGUAGE SQL AS
$$
SELECT i, j FROM t_108974_f;
SELECT i, j FROM t_108974_f@t_108974_f_pkey;
SELECT i, j FROM t_108974_f@t_108974_f_i_j_idx;
SELECT i, j FROM t_108974_f@[0];
SELECT i, j FROM t_108974_f@[1];
SELECT i, j FROM t_108974_f@[2];
$$;
CREATE VIEW v_108974 AS SELECT i, j FROM t_108974_v@t_108974_v_pkey;
SET sql_safe_updates = false;

-- Test 762: statement (line 4221)
DROP INDEX t_108974_f@t_108974_f_i_j_idx;

-- Test 763: statement (line 4224)
ALTER TABLE t_108974_f ALTER PRIMARY KEY USING COLUMNS (j);

-- Test 764: statement (line 4227)
ALTER TABLE t_108974_v ALTER PRIMARY KEY USING COLUMNS (j);

-- Test 765: statement (line 4230)
ALTER TABLE t_108974_f ADD COLUMN p INT DEFAULT 30;

-- Test 766: statement (line 4233)
ALTER TABLE t_108974_v ADD COLUMN p INT DEFAULT 30;

-- Test 767: statement (line 4236)
ALTER TABLE t_108974_f DROP COLUMN k;

-- Test 768: statement (line 4239)
ALTER TABLE t_108974_v DROP COLUMN k;

-- Test 769: statement (line 4248)
CREATE TABLE t_110629 (a INT PRIMARY KEY);

-- Test 770: statement (line 4259)
CREATE TABLE t_118246 (i INT PRIMARY KEY);
INSERT INTO t_118246 VALUES (0);

-- Test 771: statement (line 4266)
ALTER TABLE t_118246 ADD COLUMN j INT, ADD UNIQUE WITHOUT INDEX (j);

-- Test 772: statement (line 4269)
ALTER TABLE t_118246 ADD COLUMN k INT DEFAULT 30, ADD UNIQUE WITHOUT INDEX (k);

onlyif config schema-locked-disabled

-- Test 773: query (line 4273)
SELECT create_statement FROM [SHOW CREATE TABLE t_118246]

-- Test 774: query (line 4286)
SELECT create_statement FROM [SHOW CREATE TABLE t_118246]

-- Test 775: statement (line 4308)
CREATE TABLE public.t_118626(n int primary key, b int NOT NULL, c int NOT NULL);
INSERT INTO public.t_118626 VALUES(1, 2, 3);

-- Test 776: statement (line 4312)
CREATE UNIQUE INDEX ON public.t_118626(c) WHERE n>= 1;

-- Test 777: statement (line 4315)
ALTER TABLE public.t_118626 ALTER PRIMARY KEY USING COLUMNS(b);

-- Test 778: statement (line 4322)
CREATE TABLE t_120017 (
  a INT PRIMARY KEY,
  b TEXT,
  c INT NOT NULL,
  CHECK (b IN ('x', 'y'))
)

skipif config local-legacy-schema-changer

-- Test 779: statement (line 4331)
ALTER TABLE t_120017
DROP CONSTRAINT check_b,
ADD CONSTRAINT check_b CHECK (b IN ('x', 'y', 'z'))

-- Test 780: query (line 4336)
SELECT crdb_internal.pb_to_json('desc', descriptor) #> '{table,mutations}'
FROM system.descriptor
WHERE id = 't_120017'::regclass::oid

-- Test 781: statement (line 4344)
ALTER TABLE t_120017 SET (schema_locked=false)

-- Test 782: statement (line 4347)
ALTER TABLE t_120017
DROP CONSTRAINT "t_120017_pkey",
ADD CONSTRAINT "t_120017_pkey" PRIMARY KEY (a, c)

skipif config schema-locked-disabled

-- Test 783: statement (line 4353)
ALTER TABLE t_120017 SET (schema_locked=true)

-- Test 784: statement (line 4360)
SET create_table_with_schema_locked=false

-- Test 785: statement (line 4373)
ALTER TABLE t_add_generated ALTER COLUMN a ADD GENERATED BY DEFAULT AS IDENTITY (START WITH 2 INCREMENT 3);

-- Test 786: query (line 4376)
SELECT create_statement FROM [SHOW CREATE TABLE t_add_generated]

-- Test 787: statement (line 4390)
ALTER TABLE t_add_generated ALTER COLUMN b ADD GENERATED ALWAYS AS IDENTITY (START WITH 2 INCREMENT 3);

-- Test 788: query (line 4393)
SELECT create_statement FROM [SHOW CREATE TABLE t_add_generated]

-- Test 789: query (line 4407)
ALTER TABLE t_add_generated ALTER COLUMN c ADD GENERATED ALWAYS AS IDENTITY;

query error pq: column "e" of relation "t_add_generated" already has a default value
ALTER TABLE t_add_generated ALTER COLUMN e ADD GENERATED ALWAYS AS IDENTITY;

query error pq: column "a" of relation "t_add_generated" is already an identity column
ALTER TABLE t_add_generated ALTER COLUMN a ADD GENERATED ALWAYS AS IDENTITY;

query error pq: column "d" of relation "t_add_generated" type must be an integer type
ALTER TABLE t_add_generated ALTER COLUMN d ADD GENERATED ALWAYS AS IDENTITY;

statement ok
INSERT INTO t_add_generated (d) VALUES ('11'), ('12'), ('13');

statement ok
INSERT INTO t_add_generated (a,d) VALUES (21,'21'), (22,'22'), (23,'23');

statement error pq: cannot insert into column "b"\nDETAIL: Column "b" is an identity column defined as GENERATED ALWAYS
INSERT INTO t_add_generated (b,d) VALUES (31,'31'), (32,'32'), (33,'33');

query IIITI
SELECT * FROM t_add_generated ORDER BY a

-- Test 790: statement (line 4438)
CREATE TABLE t_set_generated (
  a int GENERATED ALWAYS AS IDENTITY (START WITH 2 INCREMENT 3),
  b int GENERATED BY DEFAULT AS IDENTITY (START WITH 2 INCREMENT 3),
  c int,
  FAMILY (a,b,c)
);

-- Test 791: statement (line 4446)
ALTER TABLE t_set_generated ALTER COLUMN a SET GENERATED BY DEFAULT;

-- Test 792: query (line 4449)
SELECT create_statement FROM [SHOW CREATE TABLE t_set_generated]

-- Test 793: statement (line 4461)
ALTER TABLE t_set_generated ALTER COLUMN b SET GENERATED ALWAYS;

-- Test 794: query (line 4464)
SELECT create_statement FROM [SHOW CREATE TABLE t_set_generated]

-- Test 795: statement (line 4476)
ALTER TABLE t_set_generated ALTER COLUMN c SET GENERATED BY DEFAULT;

-- Test 796: statement (line 4479)
ALTER TABLE t_set_generated ALTER COLUMN c SET GENERATED ALWAYS;

-- Test 797: statement (line 4482)
INSERT INTO t_set_generated DEFAULT VALUES;

-- Test 798: statement (line 4485)
INSERT INTO t_set_generated DEFAULT VALUES;

-- Test 799: statement (line 4488)
INSERT INTO t_set_generated (a) VALUES (3);

-- Test 800: statement (line 4491)
INSERT INTO t_set_generated (b) VALUES (4);

-- Test 801: query (line 4494)
SELECT * FROM t_set_generated ORDER BY a

-- Test 802: statement (line 4501)
RESET create_table_with_schema_locked

-- Test 803: statement (line 4506)
SET create_table_with_schema_locked=false

-- Test 804: statement (line 4509)
CREATE TABLE t_alter_identity (id SERIAL PRIMARY KEY, a int GENERATED ALWAYS AS IDENTITY, b int GENERATED ALWAYS AS IDENTITY, z int);

-- Test 805: statement (line 4512)
ALTER TABLE t_alter_identity ALTER COLUMN b SET INCREMENT 0;

-- Test 806: query (line 4515)
ALTER TABLE t_alter_identity ALTER COLUMN b SET MAXVALUE 10 SET START WITH 11;

query error pq: START value \(5\) cannot be less than MINVALUE \(10\)
ALTER TABLE t_alter_identity ALTER COLUMN b SET MINVALUE 10 SET START WITH 5;

query error pq: column "z" of relation "t_alter_identity" is not an identity column
ALTER TABLE t_alter_identity ALTER COLUMN z SET START WITH 5;

# Verify sequence options are implemented on the identity

statement error sequence option "AS" not supported here
ALTER TABLE t_alter_identity ALTER COLUMN a SET AS INT4;

statement error pq: unimplemented: CYCLE option is not supported
ALTER TABLE t_alter_identity ALTER COLUMN a SET CYCLE;

statement ok
ALTER TABLE t_alter_identity ALTER COLUMN a SET NO CYCLE;

statement error sequence option "OWNED BY" not supported here
ALTER TABLE t_alter_identity ALTER COLUMN a SET OWNED BY NONE;

statement ok
ALTER TABLE t_alter_identity ALTER COLUMN a SET PER NODE CACHE 5;

statement ok
ALTER TABLE t_alter_identity ALTER COLUMN a SET PER SESSION CACHE 5;

statement error sequence option "VIRTUAL" not supported here
ALTER TABLE t_alter_identity ALTER COLUMN a SET VIRTUAL;

statement ok
INSERT INTO t_alter_identity DEFAULT VALUES;

statement ok
ALTER TABLE t_alter_identity ALTER COLUMN b SET START WITH 5;

statement ok
ALTER TABLE t_alter_identity ALTER COLUMN b SET INCREMENT 4;

statement ok
ALTER TABLE t_alter_identity ALTER COLUMN b RESTART;

statement ok
INSERT INTO t_alter_identity DEFAULT VALUES;

statement ok
INSERT INTO t_alter_identity DEFAULT VALUES;

statement ok
ALTER TABLE t_alter_identity ALTER COLUMN b SET MAXVALUE 40 RESTART WITH 20 SET CACHE 5 SET INCREMENT BY 2;

statement ok
INSERT INTO t_alter_identity DEFAULT VALUES;

statement ok
INSERT INTO t_alter_identity DEFAULT VALUES;

query I rowsort
SELECT b from t_alter_identity ORDER BY b;

-- Test 807: statement (line 4585)
CREATE TABLE test_52552_asc (c1 int GENERATED ALWAYS AS IDENTITY);

-- Test 808: statement (line 4588)
ALTER TABLE test_52552_asc ALTER COLUMN c1 SET INCREMENT BY 3 SET MINVALUE 1 SET MAXVALUE 12 RESTART;

-- Test 809: statement (line 4591)
ALTER TABLE test_52552_asc ALTER COLUMN c1 SET INCREMENT BY 8;

-- Test 810: statement (line 4594)
INSERT INTO test_52552_asc DEFAULT VALUES;

-- Test 811: statement (line 4597)
INSERT INTO test_52552_asc DEFAULT VALUES;

-- Test 812: statement (line 4600)
INSERT INTO test_52552_asc DEFAULT VALUES;

-- Test 813: statement (line 4603)
INSERT INTO test_52552_asc DEFAULT VALUES;

-- Test 814: query (line 4606)
SELECT c1 FROM test_52552_asc;

-- Test 815: statement (line 4612)
ALTER TABLE test_52552_asc ALTER COLUMN c1 SET NO MAXVALUE;

-- Test 816: statement (line 4615)
INSERT INTO test_52552_asc DEFAULT VALUES;

-- Test 817: query (line 4618)
SELECT c1 FROM test_52552_asc;

-- Test 818: statement (line 4625)
CREATE TABLE test_52552_desc (c1 int GENERATED ALWAYS AS IDENTITY);

-- Test 819: statement (line 4628)
ALTER TABLE test_52552_desc ALTER COLUMN c1 SET INCREMENT BY -5 SET MINVALUE 1 SET MAXVALUE 12 SET START 12 RESTART;

-- Test 820: statement (line 4631)
ALTER TABLE test_52552_desc ALTER COLUMN c1 SET INCREMENT BY -8;

-- Test 821: statement (line 4634)
INSERT INTO test_52552_desc DEFAULT VALUES;

-- Test 822: statement (line 4637)
INSERT INTO test_52552_desc DEFAULT VALUES;

-- Test 823: query (line 4640)
SELECT c1 FROM test_52552_desc;

-- Test 824: statement (line 4646)
INSERT INTO test_52552_desc DEFAULT VALUES;

-- Test 825: statement (line 4649)
INSERT INTO test_52552_desc DEFAULT VALUES;

-- Test 826: statement (line 4652)
ALTER TABLE test_52552_desc ALTER COLUMN c1 SET NO MINVALUE;

-- Test 827: statement (line 4655)
INSERT INTO test_52552_desc DEFAULT VALUES;

-- Test 828: query (line 4658)
SELECT c1 FROM test_52552_desc;

-- Test 829: statement (line 4665)
CREATE TABLE test_52552_start (c1 int GENERATED ALWAYS AS IDENTITY);

-- Test 830: statement (line 4668)
ALTER TABLE test_52552_start ALTER COLUMN c1 SET INCREMENT 3 SET MINVALUE 1 SET MAXVALUE 100 SET START 50;

-- Test 831: statement (line 4671)
ALTER TABLE test_52552_start ALTER COLUMN c1 SET INCREMENT 8;

-- Test 832: statement (line 4674)
INSERT INTO test_52552_start DEFAULT VALUES;

-- Test 833: query (line 4677)
SELECT c1 FROM test_52552_start;

-- Test 834: statement (line 4684)
CREATE TABLE t_identity_drop (a int GENERATED ALWAYS AS IDENTITY (START WITH 10), b int GENERATED BY DEFAULT AS IDENTITY);

-- Test 835: statement (line 4687)
INSERT INTO t_identity_drop (a) VALUES (3);

-- Test 836: statement (line 4690)
ALTER TABLE t_identity_drop ALTER COLUMN a DROP IDENTITY;

-- Test 837: statement (line 4693)
ALTER TABLE t_identity_drop ALTER COLUMN a DROP IDENTITY;

-- Test 838: statement (line 4696)
ALTER TABLE t_identity_drop ALTER COLUMN a DROP IDENTITY IF EXISTS;

-- Test 839: statement (line 4699)
INSERT INTO t_identity_drop (a) VALUES (3);

-- Test 840: statement (line 4702)
CREATE TABLE t_identity_drop_dependency(id INT PRIMARY KEY DEFAULT nextval('public.t_identity_drop_b_seq'));

-- Test 841: statement (line 4705)
ALTER TABLE t_identity_drop ALTER COLUMN b DROP IDENTITY;

let $old_serial_normalization
SHOW serial_normalization

-- Test 842: statement (line 4711)
SET serial_normalization = rowid

-- Test 843: statement (line 4715)
CREATE TABLE t_serial_identity_no_sequence(a SERIAL PRIMARY KEY GENERATED ALWAYS AS IDENTITY)

-- Test 844: query (line 4718)
SELECT crdb_internal.pb_to_json('desc', descriptor)->'table'->'columns'->0->>'defaultExpr'
FROM system.descriptor
WHERE id = 't_serial_identity_no_sequence'::regclass::oid

-- Test 845: query (line 4725)
SELECT crdb_internal.pb_to_json('desc', descriptor)->'table'->'columns'->0->>'generatedAsIdentityType'
FROM system.descriptor
WHERE id = 't_serial_identity_no_sequence'::regclass::oid

-- Test 846: statement (line 4732)
SET serial_normalization = sql_sequence

-- Test 847: statement (line 4736)
CREATE TABLE t_serial_identity_with_sequence(a SERIAL PRIMARY KEY GENERATED ALWAYS AS IDENTITY)

-- Test 848: query (line 4739)
SELECT substring(crdb_internal.pb_to_json('desc', descriptor)->'table'->'columns'->0->>'defaultExpr' FOR 7)
FROM system.descriptor
WHERE id = 't_serial_identity_with_sequence'::regclass::oid

-- Test 849: query (line 4746)
SELECT crdb_internal.pb_to_json('desc', descriptor)->'table'->'columns'->0->>'generatedAsIdentityType'
FROM system.descriptor
WHERE id = 't_serial_identity_with_sequence'::regclass::oid

-- Test 850: statement (line 4753)
SET serial_normalization = $old_serial_normalization

-- Test 851: statement (line 4758)
CREATE TABLE foo (i int);

skipif config local-legacy-schema-changer

-- Test 852: statement (line 4762)
ALTER TABLE foo DROP COLUMN i, ADD COLUMN i bool;

skipif config local-legacy-schema-changer

-- Test 853: statement (line 4766)
ALTER TABLE foo DROP COLUMN i, DROP COLUMN i;

-- Test 854: statement (line 4769)
RESET create_table_with_schema_locked

-- Test 855: statement (line 4776)
CREATE TABLE foo_bar (i int unique not null, j int);

skipif config local-legacy-schema-changer

-- Test 856: statement (line 4780)
ALTER TABLE foo_bar DROP COLUMN i, ALTER PRIMARY KEY USING COLUMNS (i);

-- Test 857: statement (line 4787)
CREATE TABLE x (a int8 not null primary key, computed_col int8 null as (a) stored);

-- Test 858: statement (line 4790)
CREATE TABLE y (a int8 not null primary key, computed_col int8 null as (a) stored);

-- Test 859: statement (line 4793)
INSERT INTO x VALUES (0),(1),(2),(3),(4);

-- Test 860: statement (line 4796)
INSERT INTO y VALUES (0),(1),(2);

-- Test 861: query (line 4799)
SELECT a,computed_col from y;

-- Test 862: statement (line 4806)
ALTER TABLE y ADD FOREIGN KEY (computed_col) REFERENCES x;

-- Test 863: statement (line 4809)
DELETE FROM x WHERE A IN (0,2,4);

-- Test 864: statement (line 4812)
ALTER TABLE y DROP CONSTRAINT y_computed_col_fkey;

-- Test 865: statement (line 4815)
ALTER TABLE y ADD FOREIGN KEY (computed_col) REFERENCES x ON DELETE CASCADE;

-- Test 866: statement (line 4818)
DELETE FROM x WHERE A IN (0,2);

-- Test 867: query (line 4821)
SELECT a,computed_col from y;

-- Test 868: statement (line 4826)
ALTER TABLE y ADD FOREIGN KEY (computed_col) REFERENCES x ON UPDATE CASCADE;

-- Test 869: statement (line 4829)
ALTER TABLE y ADD FOREIGN KEY (computed_col) REFERENCES x ON UPDATE CASCADE;

-- Test 870: statement (line 4832)
ALTER TABLE y ADD FOREIGN KEY (computed_col) REFERENCES x ON UPDATE SET DEFAULT;

-- Test 871: statement (line 4835)
ALTER TABLE y ADD FOREIGN KEY (computed_col) REFERENCES x ON UPDATE SET NULL;

-- Test 872: statement (line 4838)
ALTER TABLE y ADD FOREIGN KEY (computed_col) REFERENCES x ON UPDATE SET NULL ON DELETE SET DEFAULT;

-- Test 873: statement (line 4841)
ALTER TABLE y ADD FOREIGN KEY (computed_col) REFERENCES x ON DELETE SET DEFAULT;

-- Test 874: statement (line 4844)
ALTER TABLE y ADD FOREIGN KEY (computed_col) REFERENCES x ON DELETE SET NULL;

-- Test 875: statement (line 4847)
DROP TABLE y CASCADE;

-- Test 876: statement (line 4850)
DROP TABLE x CASCADE;

-- Test 877: statement (line 4857)
CREATE TABLE t_114316 (i INT PRIMARY KEY)

-- Test 878: statement (line 4860)
ALTER TABLE t_114316 ADD COLUMN a INT[] DEFAULT ARRAY[]::OID[]

onlyif config schema-locked-disabled

-- Test 879: query (line 4864)
SELECT create_statement FROM [SHOW CREATE TABLE t_114316];

-- Test 880: query (line 4874)
SELECT create_statement FROM [SHOW CREATE TABLE t_114316];

-- Test 881: statement (line 4887)
create table t_124546(a int);

-- Test 882: statement (line 4891)
ALTER TABLE t_124546 ADD CONSTRAINT ident UNIQUE ( ( EXISTS ( TABLE error FOR READ ONLY ) ) DESC ) STORING ( ident , ident );

-- Test 883: statement (line 4898)
create table roach (id int);
insert into roach DEFAULT VALUES;
insert into roach DEFAULT VALUES;
SET serial_normalization = rowid

-- Test 884: statement (line 4904)
alter table roach add column serial_id SERIAL;

-- Test 885: query (line 4907)
show columns from roach;

-- Test 886: statement (line 4919)
SET serial_normalization = sql_sequence

-- Test 887: statement (line 4922)
alter table roach add column serial_id2 SERIAL

-- Test 888: statement (line 4936)
ALTER TABLE t1_with_composite DROP COLUMN j;

-- Test 889: query (line 4939)
SELECT * FROM t1_with_composite ORDER BY i ASC;

-- Test 890: statement (line 4953)
INSERT INTO tbl_with_dft_column_family VALUES(1.0, 1.0, '{"cat": "mouse"}', 'abc');
INSERT INTO tbl_with_dft_column_family VALUES(2.0, 2.0, '{"lion": "gazelle"}', 'def');
INSERT INTO tbl_with_dft_column_family VALUES(3.0, 3.0, '{"wolf": "sheep"}', 'ghi');

-- Test 891: query (line 4958)
SELECT f, d, j, s FROM tbl_with_dft_column_family ORDER BY 1

-- Test 892: statement (line 4965)
ALTER TABLE tbl_with_dft_column_family ALTER PRIMARY KEY USING COLUMNS (f);

-- Test 893: query (line 4968)
SELECT * FROM tbl_with_dft_column_family ORDER BY 1

-- Test 894: statement (line 4975)
ALTER TABLE tbl_with_dft_column_family ALTER PRIMARY KEY USING COLUMNS (d);

-- Test 895: query (line 4978)
SELECT * FROM tbl_with_dft_column_family ORDER BY 1

-- Test 896: statement (line 4985)
ALTER TABLE tbl_with_dft_column_family ALTER PRIMARY KEY USING COLUMNS (j);

-- Test 897: query (line 4988)
SELECT * FROM tbl_with_dft_column_family ORDER BY 1

-- Test 898: statement (line 4995)
ALTER TABLE tbl_with_dft_column_family ALTER PRIMARY KEY USING COLUMNS (s);

-- Test 899: query (line 4998)
SELECT * FROM tbl_with_dft_column_family ORDER BY 1

-- Test 900: statement (line 5012)
set use_declarative_schema_changer = 'unsafe_always';

-- Test 901: statement (line 5015)
create table t_droppedcol (dropme int);

-- Test 902: statement (line 5018)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 903: statement (line 5022)
alter table t_droppedcol drop column dropme;

skipif config local-legacy-schema-changer

-- Test 904: statement (line 5026)
alter table t_droppedcol alter column dropme set not null;

onlyif config local-legacy-schema-changer

-- Test 905: statement (line 5030)
alter table t_droppedcol alter column dropme set not null;

-- Test 906: statement (line 5033)
rollback;

-- Test 907: statement (line 5036)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 908: statement (line 5040)
alter table t_droppedcol drop column dropme;

skipif config local-legacy-schema-changer

-- Test 909: statement (line 5044)
alter table t_droppedcol alter column dropme set default 99;

onlyif config local-legacy-schema-changer

-- Test 910: statement (line 5048)
alter table t_droppedcol alter column dropme set default 99;

-- Test 911: statement (line 5051)
rollback;

onlyif config schema-locked-disabled

-- Test 912: query (line 5055)
SHOW CREATE TABLE t_droppedcol;

-- Test 913: query (line 5065)
SHOW CREATE TABLE t_droppedcol;

-- Test 914: statement (line 5074)
DROP TABLE t_droppedcol;

-- Test 915: statement (line 5078)
SET use_declarative_schema_changer = $schema_changer_state

-- Test 916: statement (line 5086)
SET create_table_with_schema_locked=false

-- Test 917: statement (line 5089)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
create table t1_135692(n int);
alter table t1_135692 alter column n set not null;
insert into t1_135692 values (null);

-- Test 918: statement (line 5096)
ROLLBACK;

-- Test 919: statement (line 5104)
create table t1_serial_columns(n int);

-- Test 920: statement (line 5107)
SET serial_normalization = sql_sequence;

-- Test 921: statement (line 5111)
alter table t1_serial_columns add column i serial, add column j serial, add column k serial;

-- Test 922: statement (line 5117)
SET serial_normalization = sql_sequence_cached;
alter table t1_serial_columns add column i_cache serial;

skipif config local-read-committed
skipif config local-repeatable-read

-- Test 923: statement (line 5123)
SET serial_normalization = virtual_sequence;
alter table t1_serial_columns add column i_virtual serial;

skipif config local-read-committed
skipif config local-repeatable-read

-- Test 924: statement (line 5129)
SET serial_normalization = sql_sequence_cached_node;
alter table t1_serial_columns add column i_node_cache serial;

skipif config local-read-committed
skipif config local-repeatable-read

-- Test 925: statement (line 5135)
SET serial_normalization = unordered_rowid;
alter table t1_serial_columns add column i_unordered_rowid serial;

-- Test 926: statement (line 5139)
SET serial_normalization = sql_sequence;

skipif config local-read-committed
skipif config local-repeatable-read

-- Test 927: statement (line 5144)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE SEQUENCE t1_serial_columns_z_seq;
alter table t1_serial_columns add column z serial;
alter table t1_serial_columns add column l serial;
COMMIT;

skipif config local-read-committed
skipif config local-repeatable-read

-- Test 928: query (line 5154)
SELECT create_statement FROM crdb_internal.create_statements WHERE descriptor_name like 't1_serial_columns%' ORDER BY descriptor_name;

-- Test 929: statement (line 5181)
RESET create_table_with_schema_locked

-- Test 930: statement (line 5189)
CREATE TABLE t_parent (
  id INT PRIMARY KEY
);

-- Test 931: statement (line 5195)
CREATE TABLE t_constraints (
  a INT,
  b INT NOT NULL,
  c INT UNIQUE,
  d INT,
  e INT,
  CONSTRAINT pkey_a PRIMARY KEY (a),
  CONSTRAINT check_b CHECK (b > 0),
  CONSTRAINT unique_d UNIQUE WITHOUT INDEX (d),
  CONSTRAINT fk_e FOREIGN KEY (e) REFERENCES t_parent(id),
  FAMILY f1 (a, b, c, d, e)
) WITH (schema_locked = false);

-- Test 932: statement (line 5210)
COMMENT ON CONSTRAINT pkey_a ON t_constraints IS 'primary key comment';

-- Test 933: statement (line 5213)
COMMENT ON CONSTRAINT check_b ON t_constraints IS 'check constraint comment';

-- Test 934: statement (line 5216)
COMMENT ON CONSTRAINT t_constraints_c_key ON t_constraints IS 'unique with index comment';

-- Test 935: statement (line 5219)
COMMENT ON CONSTRAINT unique_d ON t_constraints IS 'unique without index comment';

-- Test 936: statement (line 5222)
COMMENT ON CONSTRAINT fk_e ON t_constraints IS 'foreign key comment';

-- Test 937: query (line 5226)
SELECT count(*) FROM system.comments WHERE type = 5 AND object_id = (
  SELECT table_id FROM crdb_internal.tables
  WHERE name = 't_constraints' AND schema_name = 'public' AND database_name = current_database()
);

-- Test 938: statement (line 5235)
ALTER TABLE t_constraints DROP CONSTRAINT check_b;

-- Test 939: query (line 5238)
SELECT count(*) FROM system.comments WHERE type = 5 AND object_id = (
  SELECT table_id FROM crdb_internal.tables
  WHERE name = 't_constraints' AND schema_name = 'public' AND database_name = current_database()
);

-- Test 940: statement (line 5247)
ALTER TABLE t_constraints DROP COLUMN e;

-- Test 941: query (line 5250)
SELECT count(*) FROM system.comments WHERE type = 5 AND object_id = (
  SELECT table_id FROM crdb_internal.tables
  WHERE name = 't_constraints' AND schema_name = 'public' AND database_name = current_database()
);

-- Test 942: statement (line 5259)
ALTER TABLE t_constraints DROP COLUMN d;

-- Test 943: query (line 5262)
SELECT count(*) FROM system.comments WHERE type = 5 AND object_id = (
  SELECT table_id FROM crdb_internal.tables
  WHERE name = 't_constraints' AND schema_name = 'public' AND database_name = current_database()
);

-- Test 944: statement (line 5271)
ALTER TABLE t_constraints DROP COLUMN c;

-- Test 945: query (line 5274)
SELECT count(*) FROM system.comments WHERE type = 5 AND object_id = (
  SELECT table_id FROM crdb_internal.tables
  WHERE name = 't_constraints' AND schema_name = 'public' AND database_name = current_database()
);

-- Test 946: statement (line 5283)
ALTER TABLE t_constraints ALTER PRIMARY KEY USING COLUMNS (b);

-- Test 947: query (line 5286)
SELECT count(*) FROM system.comments WHERE type = 5 AND object_id = (
  SELECT table_id FROM crdb_internal.tables
  WHERE name = 't_constraints' AND schema_name = 'public' AND database_name = current_database()
);

-- Test 948: query (line 5294)
SELECT obj_description(oid) FROM pg_constraint WHERE conrelid = 't_constraints'::regclass AND contype = 'p';

-- Test 949: statement (line 5299)
DROP TABLE t_constraints;

-- Test 950: statement (line 5302)
DROP TABLE t_parent;

-- Test 951: statement (line 5310)
CREATE TABLE t1_add ();

-- Test 952: statement (line 5313)
ALTER TABLE t1_add ADD COLUMN c1 BIGINT;

-- Test 953: statement (line 5316)
INSERT INTO t1_add VALUES (100);

-- Test 954: statement (line 5319)
ALTER TABLE t1_add ADD COLUMN IF NOT EXISTS c1 TEXT ON UPDATE EXISTS ( TABLE error );

-- Test 955: statement (line 5322)
ALTER TABLE t1_add ADD COLUMN IF NOT EXISTS c1 TEXT ON UPDATE 10;

onlyif config schema-locked-disabled

-- Test 956: query (line 5326)
SHOW CREATE TABLE t1_add

-- Test 957: query (line 5336)
SHOW CREATE TABLE t1_add

-- Test 958: statement (line 5348)
set use_declarative_schema_changer = 'unsafe_always';

-- Test 959: statement (line 5351)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE t1_add DROP COLUMN c1;
ALTER TABLE t1_add ADD COLUMN IF NOT EXISTS c1 date DEFAULT '2024-08-31';
COMMIT;

-- Test 960: query (line 5358)
SELECT c1 FROM t1_add

-- Test 961: query (line 5364)
SHOW CREATE TABLE t1_add

-- Test 962: query (line 5374)
SHOW CREATE TABLE t1_add

-- Test 963: statement (line 5383)
DROP TABLE t1_add

-- Test 964: statement (line 5386)
SET use_declarative_schema_changer = $use_decl_sc;

-- Test 965: statement (line 5393)
CREATE TABLE alter_table_duplicate_storage_params_a (
  a INT PRIMARY KEY,
  b TEXT NOT NULL
);

-- Test 966: statement (line 5399)
ALTER TABLE alter_table_duplicate_storage_params_a SET (fillfactor=20, fillfactor=30);

-- Test 967: statement (line 5406)
CREATE TABLE alter_table_alter_primary_key_duplicate_storage_params_a (
  a INT PRIMARY KEY,
  b TEXT NOT NULL
);

skipif config local-legacy-schema-changer

-- Test 968: statement (line 5413)
ALTER TABLE alter_table_alter_primary_key_duplicate_storage_params_a
  ALTER PRIMARY KEY
  USING COLUMNS (b)
  USING HASH
  WITH (bucket_count=30, bucket_count=20);

-- Test 969: statement (line 5430)
set use_declarative_schema_changer = on

-- Test 970: statement (line 5433)
CREATE TABLE alter_table_add_column_with_invalid_geometry_expression (
  id INT PRIMARY KEY
);
INSERT INTO alter_table_add_column_with_invalid_geometry_expression VALUES (1);

-- Test 971: statement (line 5439)
ALTER TABLE alter_table_add_column_with_invalid_geometry_expression ADD COLUMN geom GEOMETRY NULL DEFAULT x'001a'

-- Test 972: statement (line 5442)
SET use_declarative_schema_changer = $use_decl_sc;

-- Test 973: statement (line 5451)
CREATE TABLE t_conditional_bump_udt_version (
  id INT PRIMARY KEY
);

-- Test 974: statement (line 5456)
CREATE TYPE e1 AS ENUM ('a', 'b', 'c');

let $e1_version
SELECT crdb_internal.pb_to_json('descriptor', descriptor) -> 'type' ->> 'version'
from system.descriptor
where id = 'e1'::REGTYPE::INT - 100000;

-- Test 975: statement (line 5465)
ALTER TABLE t_conditional_bump_udt_version ADD COLUMN e1_col e1;

-- Test 976: query (line 5468)
SELECT 1
FROM system.descriptor
WHERE id = 'e1'::REGTYPE::INT - 100000 AND
  (crdb_internal.pb_to_json('descriptor', descriptor) -> 'type' ->> 'version')::INT > $e1_version;

-- Test 977: statement (line 5482)
ALTER TABLE t_conditional_bump_udt_version ADD COLUMN i_col INT;

-- Test 978: query (line 5485)
SELECT 1
FROM system.descriptor
WHERE id = 'e1'::REGTYPE::INT - 100000 AND
  (crdb_internal.pb_to_json('descriptor', descriptor) -> 'type' ->> 'version')::INT = $e1_version;

-- Test 979: statement (line 5494)
ALTER TABLE t_conditional_bump_udt_version DROP COLUMN i_col;

-- Test 980: query (line 5497)
SELECT 1
FROM system.descriptor
WHERE id = 'e1'::REGTYPE::INT - 100000 AND
  (crdb_internal.pb_to_json('descriptor', descriptor) -> 'type' ->> 'version')::INT = $e1_version;

-- Test 981: statement (line 5506)
ALTER TABLE t_conditional_bump_udt_version DROP COLUMN e1_col;

-- Test 982: query (line 5509)
SELECT 1
FROM system.descriptor
WHERE id = 'e1'::REGTYPE::INT - 100000 AND
  (crdb_internal.pb_to_json('descriptor', descriptor) -> 'type' ->> 'version')::INT > $e1_version;

-- Test 983: statement (line 5517)
DROP TABLE t_conditional_bump_udt_version;

-- Test 984: statement (line 5520)
DROP TYPE e1;

-- Test 985: statement (line 5527)
CREATE TABLE t_set_logged (a INT PRIMARY KEY);

skipif config weak-iso-level-configs

-- Test 986: query (line 5531)
ALTER TABLE t_set_logged SET LOGGED;

-- Test 987: query (line 5537)
ALTER TABLE t_set_logged SET UNLOGGED;

-- Test 988: statement (line 5548)
CREATE TABLE t_128420 (i int not null);

-- Test 989: statement (line 5553)
ALTER TABLE t_128420 ADD COLUMN box BOX2D NULL UNIQUE, ALTER PRIMARY KEY USING COLUMNS (i) USING HASH;

skipif config local-legacy-schema-changer
onlyif config schema-locked-disabled

-- Test 990: query (line 5558)
show create table t_128420

-- Test 991: query (line 5570)
show create table t_128420

-- Test 992: statement (line 5587)
CREATE TABLE drop_not_null_identity (a int, b text) WITH (schema_locked = false);

-- Test 993: statement (line 5590)
ALTER TABLE drop_not_null_identity ALTER COLUMN a SET NOT NULL;

-- Test 994: statement (line 5593)
ALTER TABLE drop_not_null_identity ALTER COLUMN a ADD GENERATED ALWAYS AS IDENTITY;

-- Test 995: statement (line 5596)
ALTER TABLE drop_not_null_identity ALTER COLUMN a DROP NOT NULL

-- Test 996: statement (line 5603)
SET CLUSTER SETTING feature.infer_rbr_region_col_using_constraint.enabled = true;

-- Test 997: statement (line 5606)
CREATE TABLE parent_infer_rbr_region_col (k INT PRIMARY KEY);

-- Test 998: statement (line 5609)
CREATE TABLE t_infer_rbr_region_col (
  a INT PRIMARY KEY,
  b INT,
  CONSTRAINT foo FOREIGN KEY (b) REFERENCES parent_infer_rbr_region_col(k)
)

-- Test 999: statement (line 5618)
ALTER TABLE t_infer_rbr_region_col SET (infer_rbr_region_col_using_constraint = foo);

-- Test 1000: statement (line 5621)
RESET CLUSTER SETTING feature.infer_rbr_region_col_using_constraint.enabled;

-- Test 1001: statement (line 5634)
CREATE TABLE tbl_with_unique_without_index (i INT DEFAULT 11, j INT);

-- Test 1002: statement (line 5637)
ALTER TABLE tbl_with_unique_without_index ADD CONSTRAINT c UNIQUE WITHOUT INDEX (i, j) WHERE i IS NOT NULL;

skipif config local-legacy-schema-changer

-- Test 1003: statement (line 5641)
ALTER TABLE tbl_with_unique_without_index DROP CONSTRAINT c, DROP COLUMN i;

onlyif config local-legacy-schema-changer

-- Test 1004: statement (line 5645)
ALTER TABLE tbl_with_unique_without_index DROP CONSTRAINT c, DROP COLUMN i;

-- Test 1005: statement (line 5665)
INSERT INTO t_alter_pk_with_inverted VALUES ('test', ARRAY[1.0, 2.0]);

-- Test 1006: statement (line 5668)
ALTER TABLE t_alter_pk_with_inverted ALTER PRIMARY KEY USING COLUMNS (a) USING HASH;

-- Test 1007: statement (line 5691)
INSERT INTO t160436_patterns VALUES (
    1,
    NULL,
    '{"IYUH31EOF": 0.123}',
    'the connection is closing now',
    'error: tls: use of closed connection',
    'use of closed network connection detected',
    'io: read/write on closed pipe',
    'the node unavailable for requests'
);

-- Test 1008: statement (line 5703)
ALTER TABLE t160436_patterns ALTER COLUMN j SET NOT NULL;

-- Test 1009: statement (line 5706)
DROP TABLE t160436_patterns;

