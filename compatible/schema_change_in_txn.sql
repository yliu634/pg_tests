-- PostgreSQL compatible tests from schema_change_in_txn
-- 502 tests

-- Test 1: statement (line 8)
SET autocommit_before_ddl = false

-- Test 2: statement (line 13)
SET create_table_with_schema_locked = 'off';

-- Test 3: statement (line 18)
BEGIN

-- Test 4: statement (line 21)
CREATE TABLE test.parent (id int primary key)

-- Test 5: statement (line 24)
INSERT INTO test.parent values (1)

-- Test 6: statement (line 27)
CREATE TABLE test.child (id int primary key, parent_id int)

-- Test 7: statement (line 30)
ALTER TABLE test.child ADD CONSTRAINT fk_child_parent_id FOREIGN KEY (parent_id) REFERENCES test.parent (id);

-- Test 8: statement (line 33)
INSERT INTO test.child VALUES (1, 1)

-- Test 9: statement (line 36)
COMMIT

-- Test 10: query (line 42)
SELECT * FROM [SHOW CONSTRAINTS FROM test.child] ORDER BY constraint_name

-- Test 11: statement (line 48)
ALTER TABLE test.child VALIDATE CONSTRAINT fk_child_parent_id

-- Test 12: query (line 51)
SELECT * FROM [SHOW CONSTRAINTS FROM test.child] ORDER BY constraint_name

-- Test 13: statement (line 57)
DROP TABLE test.child, test.parent

-- Test 14: statement (line 62)
CREATE TABLE test.parent (id int primary key)

-- Test 15: statement (line 65)
INSERT INTO test.parent values (1)

-- Test 16: statement (line 68)
CREATE TABLE test.child (id int primary key, parent_id int)

-- Test 17: statement (line 71)
BEGIN

-- Test 18: statement (line 74)
ALTER TABLE test.child ADD CONSTRAINT fk_child_parent_id FOREIGN KEY (parent_id) REFERENCES test.parent (id);

-- Test 19: statement (line 77)
INSERT INTO test.child VALUES (1, 1)

-- Test 20: statement (line 80)
COMMIT

-- Test 21: query (line 84)
SELECT * FROM [SHOW CONSTRAINTS FROM test.child] ORDER BY constraint_name

-- Test 22: statement (line 90)
DROP TABLE test.child, test.parent

-- Test 23: statement (line 95)
BEGIN

-- Test 24: statement (line 98)
CREATE TABLE parent_composite_index (a_id INT NOT NULL, b_id INT NOT NULL, PRIMARY KEY (a_id, b_id))

-- Test 25: statement (line 101)
CREATE TABLE child_composite_index (id SERIAL NOT NULL, parent_a_id INT, parent_b_id INT, PRIMARY KEY (id))

-- Test 26: statement (line 104)
ALTER TABLE child_composite_index ADD CONSTRAINT fk_id FOREIGN KEY (parent_a_id, parent_b_id) REFERENCES parent_composite_index;

-- Test 27: statement (line 107)
INSERT INTO parent_composite_index VALUES (100, 200)

-- Test 28: statement (line 110)
INSERT INTO child_composite_index VALUES (1, 100, 200)

-- Test 29: statement (line 113)
COMMIT

-- Test 30: statement (line 116)
DROP TABLE parent_composite_index, child_composite_index

-- Test 31: statement (line 121)
BEGIN

-- Test 32: statement (line 124)
CREATE TABLE nonempty_a (id SERIAL NOT NULL, self_id INT, b_id INT NOT NULL, PRIMARY KEY (id))

-- Test 33: statement (line 127)
CREATE TABLE nonempty_b (id SERIAL NOT NULL, PRIMARY KEY (id))

-- Test 34: statement (line 130)
INSERT INTO nonempty_b VALUES (1), (2), (3);

-- Test 35: statement (line 133)
INSERT INTO nonempty_a VALUES (1, NULL, 1)

-- Test 36: statement (line 136)
ALTER TABLE nonempty_a ADD CONSTRAINT fk_self_id FOREIGN KEY (self_id) REFERENCES nonempty_a;

-- Test 37: statement (line 139)
COMMIT

-- Test 38: statement (line 144)
BEGIN

-- Test 39: statement (line 147)
CREATE TABLE parent_name_collision (id SERIAL NOT NULL, PRIMARY KEY (id))

-- Test 40: statement (line 150)
CREATE TABLE child_name_collision (id SERIAL NOT NULL, parent_id INT, other_col INT)

-- Test 41: statement (line 153)
CREATE INDEX child_name_collision_auto_index_fk_id ON child_name_collision (other_col)

-- Test 42: statement (line 160)
ALTER TABLE child_name_collision ADD CONSTRAINT fk_id FOREIGN KEY (parent_id) references parent_name_collision

-- Test 43: statement (line 163)
COMMIT

-- Test 44: statement (line 168)
BEGIN

-- Test 45: statement (line 171)
CREATE TABLE parent (a_id INT, b_id INT, PRIMARY KEY (a_id, b_id))

-- Test 46: statement (line 174)
CREATE TABLE child_duplicate_cols (id INT, parent_id INT, PRIMARY KEY (id))

-- Test 47: statement (line 178)
ALTER TABLE child_duplicate_cols ADD CONSTRAINT fk FOREIGN KEY (parent_id, parent_id) references parent

-- Test 48: statement (line 181)
COMMIT

-- Test 49: statement (line 186)
CREATE TABLE kv (item, quantity) AS VALUES ('cups', 10), ('plates', 30), ('forks', 15)

-- Test 50: statement (line 189)
SELECT * FROM kv

-- Test 51: statement (line 192)
BEGIN

-- Test 52: statement (line 195)
CREATE TABLE test.parent (id int primary key)

-- Test 53: statement (line 198)
INSERT into test.parent values (1)

-- Test 54: statement (line 201)
CREATE TABLE test.chill (id int primary key, parent_id int)

-- Test 55: statement (line 205)
ALTER TABLE test.chill RENAME TO test.child

-- Test 56: statement (line 208)
INSERT INTO test.child VALUES (1, 1)

-- Test 57: statement (line 213)
CREATE INDEX idx_child_parent_id ON test.child (parent_id)

-- Test 58: statement (line 217)
ALTER TABLE test.child ADD CONSTRAINT fk_child_parent_id FOREIGN KEY (parent_id) REFERENCES test.parent (id);

-- Test 59: statement (line 220)
INSERT INTO test.child VALUES (2, 1)

-- Test 60: query (line 224)
SELECT * FROM test.child@idx_child_parent_id

-- Test 61: statement (line 231)
CREATE INDEX foo ON test.kv (quantity)

-- Test 62: statement (line 234)
COMMIT

-- Test 63: query (line 238)
SELECT * FROM test.kv@foo

-- Test 64: statement (line 247)
BEGIN

-- Test 65: statement (line 251)
CREATE INDEX bar ON test.kv (quantity)

-- Test 66: statement (line 255)
SELECT * FROM test.kv@bar

-- Test 67: statement (line 258)
COMMIT

-- Test 68: statement (line 263)
SELECT * FROM test.kv@bar

-- Test 69: statement (line 268)
BEGIN

-- Test 70: statement (line 271)
CREATE TABLE b (parent_id INT REFERENCES parent(id));

-- Test 71: statement (line 275)
CREATE INDEX foo ON b (parent_id)

-- Test 72: statement (line 278)
ALTER TABLE b ADD COLUMN d INT DEFAULT 23, ADD CONSTRAINT bar UNIQUE (parent_id)

-- Test 73: query (line 281)
SHOW CREATE TABLE b

-- Test 74: statement (line 295)
INSERT INTO b VALUES (1);

-- Test 75: statement (line 298)
COMMIT

-- Test 76: statement (line 303)
BEGIN

-- Test 77: statement (line 306)
CREATE TABLE stock (item, quantity) AS VALUES ('cups', 10), ('plates', 30), ('forks', 15)

-- Test 78: statement (line 309)
SELECT * FROM stock

-- Test 79: statement (line 314)
CREATE INDEX idx_quantity ON stock (quantity)

-- Test 80: statement (line 318)
ALTER TABLE stock ADD COLUMN c INT AS (quantity + 4) STORED, ADD COLUMN d INT DEFAULT 23, ADD CONSTRAINT bar UNIQUE (c)

-- Test 81: query (line 322)
SELECT * FROM test.stock@idx_quantity

-- Test 82: query (line 330)
SELECT * FROM test.stock@bar

-- Test 83: statement (line 337)
COMMIT

-- Test 84: statement (line 342)
BEGIN

-- Test 85: statement (line 348)
INSERT INTO warehouse VALUES ('cups', 10), ('plates', 30), ('forks', 15)

-- Test 86: statement (line 351)
DROP INDEX warehouse@bar

-- Test 87: statement (line 354)
ALTER TABLE warehouse DROP quantity

-- Test 88: statement (line 358)
ALTER TABLE warehouse ADD COLUMN quantity INT DEFAULT 23

-- Test 89: statement (line 361)
CREATE INDEX bar ON warehouse (item)

-- Test 90: query (line 365)
SELECT * FROM warehouse@bar

-- Test 91: statement (line 373)
ALTER TABLE warehouse DROP COLUMN quantity

-- Test 92: query (line 376)
SELECT * FROM warehouse@bar

-- Test 93: statement (line 383)
COMMIT

-- Test 94: statement (line 388)
BEGIN

-- Test 95: statement (line 391)
CREATE TABLE hood (item, quantity) AS VALUES ('cups', 10), ('plates', 30), ('forks', 15)

-- Test 96: statement (line 394)
SELECT * FROM hood

-- Test 97: statement (line 397)
DROP TABLE hood

-- Test 98: statement (line 400)
CREATE TABLE hood (item, quantity) AS VALUES ('plates', 10), ('knives', 30), ('spoons', 12)

-- Test 99: statement (line 403)
SELECT * FROM hood

-- Test 100: query (line 406)
SELECT * FROM hood

-- Test 101: statement (line 413)
COMMIT

-- Test 102: statement (line 418)
BEGIN

-- Test 103: statement (line 421)
CREATE TABLE shop (item, quantity) AS VALUES ('cups', 10), ('plates', 30), ('forks', 15)

-- Test 104: statement (line 424)
SELECT * FROM shop

-- Test 105: statement (line 427)
ALTER TABLE shop RENAME TO ship

-- Test 106: statement (line 430)
CREATE TABLE shop (item, quantity) AS VALUES ('spoons', 11), ('plates', 34), ('knives', 22)

-- Test 107: statement (line 433)
SELECT * FROM shop

-- Test 108: query (line 436)
SELECT * FROM shop

-- Test 109: query (line 443)
SELECT * FROM ship

-- Test 110: statement (line 450)
COMMIT

-- Test 111: statement (line 455)
BEGIN

-- Test 112: statement (line 458)
CREATE TABLE shopping (item, quantity) AS VALUES ('cups', 10), ('plates', 30), ('forks', 10)

-- Test 113: statement (line 461)
SELECT * FROM shopping

-- Test 114: statement (line 464)
CREATE UNIQUE INDEX bar ON shopping (quantity)

-- Test 115: statement (line 467)
COMMIT

-- Test 116: query (line 471)
SELECT * FROM shopping

subtest add_column_not_null_violation

statement ok
BEGIN

statement ok
CREATE TABLE shopping (item, quantity) AS VALUES ('cups', 10), ('plates', 30), ('forks', 10)

statement count 3
SELECT * FROM shopping

statement error pgcode 23502 null value in column \"q\" violates not-null constraint
ALTER TABLE shopping ADD COLUMN q DECIMAL NOT NULL

statement ok
COMMIT

# Ensure the above transaction didn't commit.
statement error pgcode 42P01 relation \"shopping\" does not exist
SELECT * FROM shopping

subtest add_column_computed_column_failure

statement ok
BEGIN

statement ok
CREATE TABLE shopping (item, quantity) AS VALUES ('cups', 10), ('plates', 30), ('forks', 10)

statement count 3
SELECT * FROM shopping

statement error pgcode 22012 division by zero
ALTER TABLE shopping ADD COLUMN c int AS (quantity::int // 0) STORED

statement ok
COMMIT

subtest create_as_add_multiple_columns

statement ok
BEGIN

statement ok
CREATE TABLE cutlery (item, quantity) AS VALUES ('cups', 10), ('plates', 30), ('forks', 15)

statement count 3
SELECT * FROM cutlery

# Add two columns, one with a computed and the other without any default.
statement ok
ALTER TABLE cutlery ADD COLUMN c INT AS (quantity + 4) STORED, ADD COLUMN d INT

query TIII rowsort
SELECT * FROM test.cutlery

-- Test 117: statement (line 534)
COMMIT

-- Test 118: statement (line 539)
BEGIN

-- Test 119: statement (line 542)
CREATE TABLE dontwant (k CHAR PRIMARY KEY, v CHAR)

-- Test 120: statement (line 545)
CREATE TABLE want (k CHAR PRIMARY KEY, v CHAR)

-- Test 121: statement (line 548)
INSERT INTO dontwant (k,v) VALUES ('a', 'b')

-- Test 122: statement (line 551)
INSERT INTO want (k,v) VALUES ('c', 'd')

-- Test 123: statement (line 554)
ALTER TABLE want RENAME TO forlater

-- Test 124: statement (line 557)
ALTER TABLE dontwant RENAME TO want

-- Test 125: statement (line 560)
INSERT INTO want (k,v) VALUES ('e', 'f')

-- Test 126: statement (line 563)
COMMIT

-- Test 127: query (line 566)
SELECT * FROM want

-- Test 128: statement (line 574)
BEGIN

-- Test 129: statement (line 577)
CREATE TABLE parents (k CHAR PRIMARY KEY)

-- Test 130: statement (line 580)
INSERT INTO parents (k) VALUES ('b')

-- Test 131: statement (line 583)
CREATE TABLE children (k CHAR PRIMARY KEY, v CHAR REFERENCES parents)

-- Test 132: statement (line 586)
INSERT INTO children (k,v) VALUES ('a', 'b')

-- Test 133: statement (line 590)
ALTER TABLE children ADD COLUMN d INT DEFAULT 23

-- Test 134: query (line 593)
SELECT * FROM children

-- Test 135: statement (line 598)
COMMIT

-- Test 136: statement (line 603)
BEGIN

-- Test 137: statement (line 606)
CREATE TABLE class (k CHAR PRIMARY KEY)

-- Test 138: statement (line 609)
INSERT INTO class (k) VALUES ('b')

-- Test 139: statement (line 612)
CREATE TABLE student (k CHAR PRIMARY KEY, v CHAR REFERENCES class)

-- Test 140: statement (line 615)
INSERT INTO student (k,v) VALUES ('a', 'b')

-- Test 141: statement (line 618)
ALTER TABLE student DROP CONSTRAINT student_v_fkey

-- Test 142: statement (line 621)
ALTER TABLE student ADD FOREIGN KEY (v) REFERENCES class

-- Test 143: query (line 624)
SELECT * FROM student

-- Test 144: statement (line 629)
COMMIT

-- Test 145: statement (line 634)
CREATE TABLE customers (k CHAR PRIMARY KEY)

-- Test 146: statement (line 637)
INSERT INTO customers (k) VALUES ('b')

-- Test 147: statement (line 640)
CREATE TABLE orders (k CHAR PRIMARY KEY, v CHAR)

-- Test 148: statement (line 643)
INSERT INTO orders (k,v) VALUES ('a', 'b')

-- Test 149: statement (line 646)
BEGIN

-- Test 150: statement (line 649)
TRUNCATE want

-- Test 151: statement (line 652)
INSERT INTO want (k,v) VALUES ('a', 'b')

-- Test 152: query (line 655)
SELECT * FROM want

-- Test 153: statement (line 660)
COMMIT

-- Test 154: query (line 663)
SELECT * FROM want

-- Test 155: statement (line 668)
BEGIN

-- Test 156: statement (line 671)
TRUNCATE orders

-- Test 157: statement (line 674)
INSERT INTO orders (k,v) VALUES ('a', 'b')

-- Test 158: statement (line 677)
COMMIT;

-- Test 159: statement (line 680)
BEGIN

-- Test 160: statement (line 683)
TRUNCATE customers CASCADE

-- Test 161: statement (line 686)
INSERT INTO customers (k) VALUES ('b')

-- Test 162: statement (line 689)
COMMIT;

-- Test 163: statement (line 694)
INSERT INTO customers (k) VALUES ('z'), ('x')

skip_on_retry

-- Test 164: statement (line 699)
BEGIN

-- Test 165: statement (line 702)
ALTER TABLE customers ADD i INT DEFAULT 5

-- Test 166: statement (line 705)
ALTER TABLE customers ADD j INT DEFAULT 4

-- Test 167: statement (line 708)
ALTER TABLE customers ADD l INT DEFAULT 3

-- Test 168: statement (line 711)
ALTER TABLE customers ADD m CHAR

-- Test 169: statement (line 714)
ALTER TABLE customers ADD n CHAR DEFAULT 'a'

-- Test 170: statement (line 717)
CREATE INDEX j_idx ON customers (j)

-- Test 171: statement (line 720)
CREATE INDEX l_idx ON customers (l)

-- Test 172: statement (line 723)
CREATE INDEX m_idx ON customers (m)

-- Test 173: statement (line 726)
CREATE UNIQUE INDEX i_idx ON customers (i)

-- Test 174: statement (line 729)
CREATE UNIQUE INDEX n_idx ON customers (n)

-- Test 175: query (line 733)
SELECT status, job_type FROM crdb_internal.jobs WHERE status='pending'

-- Test 176: statement (line 738)
COMMIT

-- Test 177: query (line 741)
SHOW COLUMNS FROM customers

-- Test 178: statement (line 765)
BEGIN

-- Test 179: statement (line 768)
ALTER TABLE customers ADD i INT DEFAULT 5

-- Test 180: statement (line 771)
ALTER TABLE customers ADD j INT AS (i-1) STORED

-- Test 181: statement (line 774)
ALTER TABLE customers ADD COLUMN d INT DEFAULT 15, ADD COLUMN e INT AS (d + (i-1)) STORED

-- Test 182: statement (line 777)
COMMIT

-- Test 183: query (line 780)
SELECT * FROM customers

-- Test 184: statement (line 800)
BEGIN

-- Test 185: statement (line 813)
ALTER TABLE orders2 ADD FOREIGN KEY (product) REFERENCES products

-- Test 186: statement (line 816)
COMMIT

-- Test 187: statement (line 819)
BEGIN

-- Test 188: statement (line 823)
ALTER TABLE orders2 ADD CHECK (id > 0)

-- Test 189: statement (line 826)
ALTER TABLE orders2 VALIDATE CONSTRAINT orders2_product_fkey

-- Test 190: statement (line 829)
COMMIT

-- Test 191: statement (line 832)
DROP TABLE products, orders2

-- Test 192: statement (line 848)
BEGIN

-- Test 193: statement (line 851)
ALTER TABLE orders2 ADD FOREIGN KEY (product) REFERENCES products

-- Test 194: statement (line 854)
ALTER TABLE orders2 VALIDATE CONSTRAINT orders2_product_fkey

-- Test 195: statement (line 857)
COMMIT

-- Test 196: statement (line 861)
BEGIN

-- Test 197: statement (line 864)
ALTER TABLE orders2 ADD FOREIGN KEY (product) REFERENCES products

-- Test 198: statement (line 867)
ALTER TABLE orders2 DROP COLUMN product

-- Test 199: statement (line 870)
COMMIT

-- Test 200: statement (line 874)
BEGIN

-- Test 201: statement (line 877)
ALTER TABLE orders2 ADD FOREIGN KEY (product) REFERENCES products

-- Test 202: statement (line 880)
DROP INDEX orders2@orders2_product_idx

-- Test 203: statement (line 883)
COMMIT

-- Test 204: statement (line 887)
BEGIN

-- Test 205: statement (line 890)
ALTER TABLE orders2 ADD CONSTRAINT c FOREIGN KEY (product) REFERENCES products

-- Test 206: statement (line 893)
ALTER TABLE orders2 RENAME CONSTRAINT c to d

-- Test 207: statement (line 896)
COMMIT

-- Test 208: statement (line 902)
CREATE TABLE check_table (k INT PRIMARY KEY)

-- Test 209: statement (line 905)
INSERT INTO check_table VALUES (1)

-- Test 210: statement (line 908)
BEGIN

-- Test 211: statement (line 911)
ALTER TABLE check_table ADD c INT

-- Test 212: statement (line 914)
ALTER TABLE check_table ADD CONSTRAINT c_0 CHECK (c > 0) NOT VALID

-- Test 213: statement (line 917)
ALTER TABLE check_table ADD d INT DEFAULT 1

-- Test 214: statement (line 920)
ALTER TABLE check_table ADD CONSTRAINT d_0 CHECK (d > 0)

-- Test 215: statement (line 923)
COMMIT

-- Test 216: query (line 926)
SELECT * FROM [SHOW CONSTRAINTS FROM check_table] ORDER BY constraint_name

-- Test 217: statement (line 933)
BEGIN

-- Test 218: statement (line 936)
ALTER TABLE check_table ADD e INT DEFAULT 0

-- Test 219: statement (line 939)
ALTER TABLE check_table ADD CONSTRAINT e_0 CHECK (e > 0)

-- Test 220: statement (line 942)
COMMIT

-- Test 221: statement (line 946)
BEGIN

-- Test 222: statement (line 952)
ALTER TABLE check_table ADD CONSTRAINT e_0 CHECK (e::INT > 0)

-- Test 223: statement (line 955)
COMMIT

-- Test 224: query (line 959)
SELECT * FROM [SHOW CONSTRAINTS FROM check_table] ORDER BY constraint_name

-- Test 225: query (line 967)
SHOW COLUMNS FROM check_table

-- Test 226: statement (line 974)
DROP TABLE check_table

-- Test 227: statement (line 980)
CREATE TABLE check_table (k INT PRIMARY KEY, a INT)

-- Test 228: statement (line 983)
INSERT INTO check_table VALUES (0, 0), (1, 0)

-- Test 229: statement (line 986)
BEGIN

-- Test 230: statement (line 989)
CREATE UNIQUE INDEX idx ON check_table (a)

-- Test 231: statement (line 992)
ALTER TABLE check_table ADD CHECK (a >= 0)

-- Test 232: statement (line 995)
COMMIT

-- Test 233: query (line 998)
SHOW CONSTRAINTS FROM check_table

-- Test 234: statement (line 1003)
BEGIN

-- Test 235: statement (line 1006)
ALTER TABLE check_table ADD CHECK (a >= 0)

-- Test 236: statement (line 1009)
ALTER TABLE check_table ADD CHECK (a < 0)

-- Test 237: statement (line 1012)
COMMIT

-- Test 238: query (line 1015)
SHOW CONSTRAINTS FROM check_table

-- Test 239: statement (line 1020)
DROP TABLE check_table

-- Test 240: statement (line 1025)
CREATE TABLE check_table (k INT PRIMARY KEY)

-- Test 241: statement (line 1028)
BEGIN

-- Test 242: statement (line 1031)
ALTER TABLE check_table ADD f INT

-- Test 243: statement (line 1034)
ALTER TABLE check_table ADD CONSTRAINT f_0 CHECK (f > 0)

-- Test 244: statement (line 1037)
ALTER TABLE check_table DROP CONSTRAINT f_0

-- Test 245: statement (line 1040)
COMMIT

-- Test 246: statement (line 1043)
BEGIN

-- Test 247: statement (line 1046)
ALTER TABLE check_table ADD g INT

-- Test 248: statement (line 1049)
ALTER TABLE check_table ADD CONSTRAINT g_0 CHECK (g > 0)

-- Test 249: statement (line 1052)
ALTER TABLE check_table DROP COLUMN g

-- Test 250: statement (line 1055)
COMMIT

-- Test 251: statement (line 1058)
BEGIN

-- Test 252: statement (line 1061)
ALTER TABLE check_table ADD h INT

-- Test 253: statement (line 1064)
ALTER TABLE check_table ADD CONSTRAINT h_0 CHECK (h > 0)

-- Test 254: statement (line 1067)
ALTER TABLE check_table VALIDATE CONSTRAINT h_0

-- Test 255: statement (line 1070)
COMMIT

-- Test 256: statement (line 1073)
DROP TABLE check_table

-- Test 257: statement (line 1078)
CREATE TABLE check_table (k INT PRIMARY KEY)

-- Test 258: statement (line 1081)
BEGIN

-- Test 259: statement (line 1084)
ALTER TABLE check_table ADD f INT

-- Test 260: statement (line 1087)
ALTER TABLE check_table ADD CONSTRAINT f_0 CHECK (f > 0)

-- Test 261: statement (line 1090)
ALTER TABLE check_table RENAME CONSTRAINT f_0 to f_1

-- Test 262: statement (line 1093)
COMMIT

-- Test 263: statement (line 1096)
BEGIN

-- Test 264: statement (line 1099)
ALTER TABLE check_table ADD f INT

-- Test 265: statement (line 1102)
ALTER TABLE check_table ADD CONSTRAINT f_0 CHECK (f > 0),
                        RENAME CONSTRAINT f_0 to f_1

-- Test 266: statement (line 1106)
COMMIT

-- Test 267: statement (line 1109)
DROP TABLE check_table

-- Test 268: statement (line 1116)
BEGIN

-- Test 269: statement (line 1119)
CREATE TABLE check_table (a INT)

-- Test 270: statement (line 1122)
INSERT INTO check_table VALUES (0)

-- Test 271: statement (line 1126)
ALTER TABLE check_table ADD CONSTRAINT ck_a CHECK (a = 0)

-- Test 272: statement (line 1129)
ALTER TABLE check_table ADD COLUMN b INT DEFAULT 1

-- Test 273: statement (line 1133)
ALTER TABLE check_table ADD CONSTRAINT ck_b CHECK (b > 0)

-- Test 274: statement (line 1137)
ALTER TABLE check_table ADD COLUMN c INT DEFAULT 2, ADD CONSTRAINT ck_c CHECK (c > b)

-- Test 275: statement (line 1140)
COMMIT

-- Test 276: query (line 1144)
SELECT * FROM [SHOW CONSTRAINTS FROM check_table] ORDER BY constraint_name

-- Test 277: statement (line 1154)
INSERT INTO check_table VALUES (0, 1, 2)

-- Test 278: statement (line 1157)
UPDATE check_table SET b = 1 WHERE b IS NULL

-- Test 279: statement (line 1160)
DROP TABLE check_table

-- Test 280: statement (line 1165)
BEGIN

-- Test 281: statement (line 1168)
CREATE TABLE check_table (a INT)

-- Test 282: statement (line 1171)
INSERT INTO check_table VALUES (0)

-- Test 283: statement (line 1175)
ALTER TABLE check_table ADD CONSTRAINT ck CHECK (a > 0)

-- Test 284: statement (line 1178)
COMMIT

-- Test 285: statement (line 1181)
BEGIN

-- Test 286: statement (line 1184)
CREATE TABLE check_table (a INT PRIMARY KEY)

-- Test 287: statement (line 1187)
INSERT INTO check_table VALUES (0)

-- Test 288: statement (line 1190)
ALTER TABLE check_table ADD COLUMN b INT DEFAULT 0

-- Test 289: statement (line 1194)
ALTER TABLE check_table ADD CONSTRAINT ck CHECK (b > 0)

-- Test 290: statement (line 1197)
COMMIT

-- Test 291: statement (line 1200)
BEGIN

-- Test 292: statement (line 1203)
CREATE TABLE check_table (a INT PRIMARY KEY)

-- Test 293: statement (line 1206)
INSERT INTO check_table VALUES (0)

-- Test 294: statement (line 1210)
ALTER TABLE check_table ADD COLUMN c INT DEFAULT 0, ADD CONSTRAINT ck CHECK (c > 0)

-- Test 295: statement (line 1213)
COMMIT

-- Test 296: statement (line 1219)
CREATE TABLE t (a INT)

-- Test 297: statement (line 1223)
INSERT INTO t VALUES (2)

-- Test 298: statement (line 1226)
BEGIN

-- Test 299: statement (line 1229)
ALTER TABLE t ADD COLUMN b INT DEFAULT 1

-- Test 300: statement (line 1232)
ALTER TABLE t ADD CHECK (a > b)

-- Test 301: statement (line 1235)
INSERT INTO t (a) VALUES (3)

-- Test 302: statement (line 1238)
UPDATE t SET a = 4 WHERE a < 4

-- Test 303: statement (line 1241)
COMMIT

-- Test 304: statement (line 1244)
DROP TABLE t

-- Test 305: statement (line 1249)
CREATE TABLE t (a INT)

-- Test 306: statement (line 1252)
BEGIN

-- Test 307: statement (line 1255)
ALTER TABLE t ADD COLUMN c INT DEFAULT 10

-- Test 308: statement (line 1258)
ALTER TABLE t ADD CHECK (a < c)

-- Test 309: statement (line 1261)
INSERT INTO t (a) VALUES (11)

-- Test 310: statement (line 1264)
COMMIT

-- Test 311: statement (line 1268)
INSERT INTO t VALUES (2)

-- Test 312: statement (line 1271)
BEGIN

-- Test 313: statement (line 1274)
ALTER TABLE t ADD COLUMN c INT DEFAULT 10

-- Test 314: statement (line 1277)
ALTER TABLE t ADD CHECK (a < c)

-- Test 315: statement (line 1280)
UPDATE t SET a = 12 WHERE a < 12

-- Test 316: statement (line 1283)
COMMIT

-- Test 317: statement (line 1286)
DROP TABLE t

-- Test 318: statement (line 1290)
CREATE TABLE t (a INT)

-- Test 319: statement (line 1293)
INSERT INTO t VALUES (2)

-- Test 320: statement (line 1296)
BEGIN

-- Test 321: statement (line 1299)
ALTER TABLE t ADD COLUMN d INT DEFAULT 1

-- Test 322: statement (line 1302)
ALTER TABLE t ADD CHECK (a > d AND d IS NOT NULL)

-- Test 323: statement (line 1305)
INSERT INTO t (a) VALUES (3)

-- Test 324: statement (line 1308)
UPDATE t SET a = 4 WHERE a < 4

-- Test 325: statement (line 1311)
COMMIT

-- Test 326: statement (line 1314)
DROP TABLE t

-- Test 327: statement (line 1320)
CREATE TABLE t (a INT)

-- Test 328: statement (line 1324)
INSERT INTO t VALUES (2)

-- Test 329: statement (line 1327)
BEGIN

-- Test 330: statement (line 1330)
ALTER TABLE t ADD COLUMN b INT AS (a - 1) STORED

-- Test 331: statement (line 1333)
ALTER TABLE t ADD CHECK (a > b)

-- Test 332: statement (line 1336)
INSERT INTO t (a) VALUES (3)

-- Test 333: statement (line 1339)
UPDATE t SET a = 4 WHERE a < 4

-- Test 334: statement (line 1342)
COMMIT

-- Test 335: statement (line 1345)
DROP TABLE t

-- Test 336: statement (line 1350)
CREATE TABLE t (a INT)

-- Test 337: statement (line 1353)
BEGIN

-- Test 338: statement (line 1356)
ALTER TABLE t ADD COLUMN c INT AS (a - 1) STORED

-- Test 339: statement (line 1359)
ALTER TABLE t ADD CHECK (a < c)

-- Test 340: statement (line 1362)
INSERT INTO t (a) VALUES (11)

-- Test 341: statement (line 1365)
COMMIT

-- Test 342: statement (line 1369)
INSERT INTO t VALUES (2)

-- Test 343: statement (line 1372)
BEGIN

-- Test 344: statement (line 1375)
ALTER TABLE t ADD COLUMN c INT AS (a - 1) STORED

-- Test 345: statement (line 1378)
ALTER TABLE t ADD CHECK (a < c)

-- Test 346: statement (line 1381)
UPDATE t SET a = 12 WHERE a < 12

-- Test 347: statement (line 1384)
COMMIT

-- Test 348: statement (line 1387)
DROP TABLE t

-- Test 349: statement (line 1391)
CREATE TABLE t (a INT)

-- Test 350: statement (line 1394)
INSERT INTO t VALUES (2)

-- Test 351: statement (line 1397)
BEGIN

-- Test 352: statement (line 1400)
ALTER TABLE t ADD COLUMN d INT AS (a - 1) STORED

-- Test 353: statement (line 1403)
ALTER TABLE t ADD CHECK (a > d AND d IS NOT NULL)

-- Test 354: statement (line 1406)
INSERT INTO t (a) VALUES (3)

-- Test 355: statement (line 1409)
UPDATE t SET a = 4 WHERE a < 4

-- Test 356: statement (line 1412)
COMMIT

-- Test 357: statement (line 1415)
DROP TABLE t

-- Test 358: statement (line 1421)
CREATE TABLE t (a INT)

-- Test 359: statement (line 1424)
INSERT INTO t VALUES (1)

-- Test 360: statement (line 1427)
BEGIN

-- Test 361: statement (line 1430)
ALTER TABLE t ADD COLUMN b INT AS (a) STORED

-- Test 362: statement (line 1433)
ALTER TABLE t ALTER COLUMN b SET NOT NULL

-- Test 363: statement (line 1436)
COMMIT

-- Test 364: statement (line 1439)
BEGIN

-- Test 365: statement (line 1442)
ALTER TABLE t ADD COLUMN c INT

-- Test 366: statement (line 1445)
ALTER TABLE t ALTER COLUMN c SET NOT NULL

-- Test 367: statement (line 1448)
COMMIT

-- Test 368: statement (line 1451)
DROP TABLE t

-- Test 369: statement (line 1457)
CREATE TABLE t (a INT)

-- Test 370: statement (line 1460)
INSERT INTO t VALUES (1)

-- Test 371: statement (line 1463)
BEGIN

-- Test 372: statement (line 1466)
ALTER TABLE t ADD CHECK (a > 0)

-- Test 373: statement (line 1470)
ALTER TABLE t ADD CONSTRAINT a_auto_not_null CHECK (a IS NOT NULL)

-- Test 374: statement (line 1473)
ALTER TABLE t ALTER COLUMN a SET NOT NULL

-- Test 375: statement (line 1476)
COMMIT

-- Test 376: statement (line 1479)
DROP TABLE t

-- Test 377: statement (line 1486)
CREATE TABLE x (a INT PRIMARY KEY, b INT, UNIQUE INDEX (b), c INT)

-- Test 378: statement (line 1489)
CREATE TABLE y (a INT PRIMARY KEY, b INT, INDEX (b))

-- Test 379: statement (line 1492)
INSERT INTO x VALUES (1, 1, 1), (2, 2, 1);

-- Test 380: statement (line 1495)
INSERT INTO y VALUES (1, 1), (2, 1);

-- Test 381: statement (line 1499)
ALTER TABLE y ADD FOREIGN KEY (b) REFERENCES x (b)

-- Test 382: statement (line 1502)
BEGIN

-- Test 383: statement (line 1506)
DROP INDEX y_b_idx CASCADE;

-- Test 384: statement (line 1510)
CREATE UNIQUE INDEX ON y (b);

-- Test 385: statement (line 1513)
COMMIT

-- Test 386: query (line 1518)
SELECT * FROM [SHOW CONSTRAINTS FROM y] ORDER BY constraint_name

-- Test 387: statement (line 1525)
ALTER TABLE y ADD FOREIGN KEY (b) REFERENCES x (b)

-- Test 388: statement (line 1528)
BEGIN

-- Test 389: statement (line 1532)
DROP INDEX x_b_key CASCADE;

-- Test 390: statement (line 1536)
CREATE UNIQUE INDEX ON x (c);

-- Test 391: statement (line 1539)
COMMIT

-- Test 392: query (line 1544)
SHOW CONSTRAINTS FROM x

-- Test 393: query (line 1552)
SHOW CONSTRAINTS FROM y

-- Test 394: statement (line 1557)
DROP TABLE x, y

-- Test 395: statement (line 1562)
CREATE TABLE t (a INT)

-- Test 396: statement (line 1565)
ALTER TABLE t ADD CONSTRAINT c CHECK (a > 0)

-- Test 397: statement (line 1568)
BEGIN

-- Test 398: statement (line 1571)
ALTER TABLE t DROP CONSTRAINT c

-- Test 399: statement (line 1576)
INSERT INTO t VALUES (0)

-- Test 400: statement (line 1579)
ROLLBACK

-- Test 401: statement (line 1582)
ALTER TABLE t DROP CONSTRAINT c

-- Test 402: statement (line 1585)
ALTER TABLE t ADD CONSTRAINT c_not_valid CHECK (a > 0) NOT VALID

-- Test 403: statement (line 1588)
BEGIN

-- Test 404: statement (line 1591)
ALTER TABLE t DROP CONSTRAINT c_not_valid

-- Test 405: statement (line 1596)
INSERT INTO t VALUES (0)

-- Test 406: statement (line 1599)
COMMIT

-- Test 407: statement (line 1602)
DROP TABLE t

-- Test 408: statement (line 1605)
CREATE TABLE t (a INT)

-- Test 409: statement (line 1608)
ALTER TABLE t ALTER COLUMN a SET NOT NULL

-- Test 410: statement (line 1611)
BEGIN

-- Test 411: statement (line 1614)
ALTER TABLE t ALTER COLUMN a DROP NOT NULL

-- Test 412: statement (line 1619)
INSERT INTO t VALUES (NULL)

-- Test 413: statement (line 1622)
ROLLBACK

-- Test 414: statement (line 1625)
DROP TABLE t

-- Test 415: statement (line 1628)
CREATE TABLE t (a INT)

-- Test 416: statement (line 1631)
CREATE TABLE t2 (b INT PRIMARY KEY)

-- Test 417: statement (line 1634)
ALTER TABLE t ADD CONSTRAINT fk FOREIGN KEY (a) REFERENCES t2

-- Test 418: statement (line 1637)
BEGIN

-- Test 419: statement (line 1640)
ALTER TABLE t DROP CONSTRAINT fk

-- Test 420: statement (line 1645)
INSERT INTO t VALUES (1)

-- Test 421: statement (line 1648)
ROLLBACK

-- Test 422: statement (line 1651)
ALTER TABLE t DROP CONSTRAINT fk

-- Test 423: statement (line 1675)
DROP TABLE t, t2

-- Test 424: statement (line 1681)
BEGIN;

-- Test 425: statement (line 1684)
CREATE TABLE a ();

-- Test 426: statement (line 1687)
CREATE TABLE b ( key INT );

-- Test 427: statement (line 1690)
CREATE INDEX b_idx ON b (key);

-- Test 428: statement (line 1693)
COMMIT;

-- Test 429: statement (line 1697)
BEGIN;

-- Test 430: statement (line 1700)
DROP TABLE a;

-- Test 431: statement (line 1703)
DROP INDEX b_idx CASCADE;

-- Test 432: statement (line 1706)
COMMIT;

-- Test 433: statement (line 1739)
CREATE TABLE t42508(x INT); INSERT INTO t42508(x) VALUES (1);

-- Test 434: statement (line 1742)
CREATE SEQUENCE s42508

-- Test 435: statement (line 1745)
ALTER TABLE t42508 ADD COLUMN y INT DEFAULT nextval('s42508')

-- Test 436: statement (line 1748)
BEGIN

-- Test 437: statement (line 1751)
ALTER TABLE t42508 ADD COLUMN y INT DEFAULT nextval('s42508')

-- Test 438: statement (line 1754)
COMMIT

-- Test 439: statement (line 1765)
begin; savepoint s; create table t(x int); rollback to savepoint s;

-- Test 440: query (line 1768)
select * from t;

statement ok
commit;

subtest no_database_schemachange_deadlock_after_savepoint_rollback

statement ok
begin; savepoint s; create database d46224; rollback to savepoint s;

query error  relation "d46224.t" does not exist
select * from d46224.t;

statement ok
commit;

# Test that adding a self-referencing foreign key to a table in the same
# transaction which creates the table is okay. In the past this created an
# infinite loop.
subtest create_and_add_self_referencing_fk_in_same_txn

statement ok
BEGIN;

statement ok
CREATE TABLE self_ref_fk (id INT8 PRIMARY KEY, parent_id INT8);

statement ok
ALTER TABLE "self_ref_fk" ADD CONSTRAINT fk_self_ref_fk__parent_id FOREIGN KEY (parent_id) REFERENCES self_ref_fk (id) ON DELETE CASCADE;

# Test that the constraint is enforced in this transaction. Create a savepoint
# so that we can rollback the error and commit the transaction.

statement ok
SAVEPOINT fk_violation;

statement error insert on table "self_ref_fk" violates foreign key constraint "fk_self_ref_fk__parent_id"
INSERT INTO self_ref_fk VALUES (2, 1);

statement ok
ROLLBACK TO SAVEPOINT fk_violation;

statement ok
COMMIT;

# Ensure that the constraint is enforced after the transaction commits.

query error insert on table "self_ref_fk" violates foreign key constraint "fk_self_ref_fk__parent_id"
INSERT INTO self_ref_fk VALUES (2, 1);

# Add some data and ensure the constraint is applied.

statement ok
INSERT INTO self_ref_fk VALUES (1, NULL), (2, 1), (3, 2);

query II rowsort
SELECT * FROM self_ref_fk

-- Test 441: statement (line 1833)
DELETE FROM self_ref_fk WHERE id = 1;

-- Test 442: query (line 1836)
SELECT * FROM self_ref_fk;

-- Test 443: statement (line 1840)
DROP TABLE self_ref_fk;

-- Test 444: statement (line 1847)
BEGIN

-- Test 445: statement (line 1850)
CREATE TABLE t_52501_valid(a INT)

-- Test 446: statement (line 1853)
INSERT INTO t_52501_valid VALUES (1)

-- Test 447: statement (line 1856)
ALTER TABLE t_52501_valid ALTER COLUMN a SET NOT NULL

-- Test 448: statement (line 1859)
COMMIT

-- Test 449: query (line 1862)
SELECT * FROM [SHOW CONSTRAINTS FROM t_52501_valid] ORDER BY constraint_name

-- Test 450: statement (line 1868)
DROP TABLE t_52501_valid

-- Test 451: statement (line 1871)
BEGIN

-- Test 452: statement (line 1874)
CREATE TABLE t_52501_invalid(a INT)

-- Test 453: statement (line 1877)
INSERT INTO t_52501_invalid VALUES (NULL)

-- Test 454: statement (line 1880)
ALTER TABLE t_52501_invalid ALTER COLUMN a SET NOT NULL

-- Test 455: statement (line 1883)
ROLLBACK

-- Test 456: statement (line 1890)
CREATE TABLE parent_54265 (a INT PRIMARY KEY)

-- Test 457: statement (line 1893)
BEGIN

-- Test 458: statement (line 1896)
CREATE TABLE child_54265 (a INT)

-- Test 459: statement (line 1899)
ALTER TABLE child_54265 ADD FOREIGN KEY (a) REFERENCES parent_54265 NOT VALID

-- Test 460: statement (line 1902)
COMMIT

-- Test 461: query (line 1905)
SELECT * FROM [SHOW CONSTRAINTS FROM child_54265] ORDER BY constraint_name

-- Test 462: statement (line 1915)
CREATE TABLE t1_57592(a INT)

-- Test 463: statement (line 1918)
CREATE UNIQUE INDEX idx ON t1_57592(a)

-- Test 464: statement (line 1921)
CREATE TABLE t2_57592(a INT)

-- Test 465: statement (line 1924)
BEGIN

-- Test 466: statement (line 1927)
ALTER TABLE t2_57592 ADD FOREIGN KEY (a) REFERENCES t1_57592(a);

-- Test 467: statement (line 1930)
DROP INDEX t1_57592@idx;

-- Test 468: statement (line 1933)
COMMIT

-- Test 469: statement (line 1940)
CREATE DATABASE db_87672;

-- Test 470: statement (line 1943)
USE db_87672;

-- Test 471: statement (line 1946)
CREATE SCHEMA sc;

-- Test 472: statement (line 1949)
BEGIN;

-- Test 473: statement (line 1952)
CREATE SCHEMA sc2;

-- Test 474: statement (line 1955)
SELECT * FROM crdb_internal.tables;

-- Test 475: statement (line 1958)
DROP SCHEMA sc;

-- Test 476: statement (line 1962)
COMMIT;

-- Test 477: statement (line 1975)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET TRANSACTION PRIORITY HIGH;
ALTER TABLE t2 RENAME TO t3;
ALTER TABLE t1 VALIDATE CONSTRAINT fk;
COMMIT;

-- Test 478: statement (line 1982)
DROP TABLE t1, t3 CASCADE

-- Test 479: statement (line 1990)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET TRANSACTION PRIORITY HIGH;
ALTER TABLE t1 RENAME TO t3;
ALTER TABLE t3 VALIDATE CONSTRAINT fk;
COMMIT;

-- Test 480: statement (line 1997)
DROP TABLE t2, t3 CASCADE

-- Test 481: statement (line 2009)
DROP TABLE t1, t2 CASCADE

-- Test 482: statement (line 2012)
SET autocommit_before_ddl = true

-- Test 483: statement (line 2018)
BEGIN;
SELECT 1;

skipif config weak-iso-level-configs

-- Test 484: query (line 2023)
ALTER TABLE t1 ADD COLUMN c INT DEFAULT 1

-- Test 485: query (line 2029)
ALTER TABLE t1 ADD COLUMN c INT DEFAULT 1

-- Test 486: query (line 2035)
COMMIT

-- Test 487: statement (line 2041)
DROP TABLE t1

-- Test 488: statement (line 2051)
set autocommit_before_ddl=on

-- Test 489: statement (line 2054)
CREATE TABLE dropme_1();

-- Test 490: statement (line 2057)
CREATE TABLE dropme_2();

-- Test 491: statement (line 2066)
SET default_transaction_isolation = 'serializable';

-- Test 492: statement (line 2069)
BEGIN

-- Test 493: query (line 2073)
DROP TABLE dropme_1;

-- Test 494: query (line 2079)
DROP TABLE dropme_2;

-- Test 495: statement (line 2091)
set autocommit_before_ddl = $autocommit_orig;

-- Test 496: statement (line 2094)
set default_transaction_isolation = '$iso';

-- Test 497: statement (line 2099)
CREATE TABLE dropme_3();

-- Test 498: statement (line 2102)
CREATE TABLE dropme_4();

-- Test 499: statement (line 2105)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 500: statement (line 2109)
SET LOCAL autocommit_before_ddl = false;

-- Test 501: query (line 2112)
DROP TABLE dropme_3;

-- Test 502: query (line 2116)
DROP TABLE dropme_4;

