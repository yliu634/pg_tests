-- PostgreSQL compatible tests from fk
-- 1123 tests

-- Many statements below are expected to error (FK violations, missing objects, etc).
\set ON_ERROR_STOP 0

-- Test 1: statement (line 2)
-- SET CLUSTER SETTING sql.cross_db_fks.enabled = TRUE

-- Test 2: statement (line 10)
-- SET enable_insert_fast_path = $enable_insert_fast_path

-- Test 3: statement (line 16)
CREATE TABLE parent (p INT PRIMARY KEY, other INT);

-- Test 4: statement (line 19)
CREATE TABLE child (c INT PRIMARY KEY, p INT NOT NULL REFERENCES parent(p));

-- Test 5: statement (line 22)
INSERT INTO child VALUES (1,1);

-- Test 6: statement (line 25)
INSERT INTO parent VALUES (1), (2);

-- Test 7: statement (line 28)
INSERT INTO child VALUES (1,1), (2,2), (3,3);

-- Test 8: statement (line 31)
INSERT INTO child VALUES (1,1), (2,2);

-- Test 9: statement (line 35)
CREATE TABLE xy (x INT, y INT);

-- Test 10: statement (line 38)
INSERT INTO xy VALUES (4, 4), (5, 5), (6, 6);

-- Test 11: statement (line 41)
INSERT INTO child SELECT x,y FROM xy;

-- Test 12: statement (line 44)
INSERT INTO parent SELECT x FROM xy;

-- Test 13: statement (line 47)
INSERT INTO child SELECT x,y FROM xy;

-- Test 14: statement (line 50)
DROP TABLE xy;

-- Test 15: statement (line 53)
DROP TABLE child;

-- Test 16: statement (line 56)
DROP TABLE parent;

-- Test 17: statement (line 62)
CREATE TABLE parent (x INT, p INT PRIMARY KEY, u INT UNIQUE);

-- Test 18: statement (line 65)
CREATE TABLE child (c INT PRIMARY KEY, p INT NOT NULL REFERENCES parent(p));

-- Test 19: statement (line 68)
INSERT INTO parent (p, u) VALUES (1, 10), (2, 20);

-- Test 20: statement (line 71)
INSERT INTO child VALUES (1, 1);

-- Test 21: statement (line 74)
DELETE FROM parent WHERE p = 2;

-- Test 22: statement (line 77)
DELETE FROM parent WHERE p = 1;

-- Test 23: statement (line 80)
CREATE TABLE child_u (c INT PRIMARY KEY, u INT NOT NULL REFERENCES parent(u));

-- Test 24: statement (line 83)
DROP TABLE child;

-- Test 25: statement (line 86)
INSERT INTO child_u VALUES (1, 10);

-- Test 26: statement (line 89)
DELETE FROM parent WHERE p = 1;

-- Test 27: statement (line 92)
DROP TABLE child_u;

-- Test 28: statement (line 95)
DROP TABLE parent;

-- Test 29: statement (line 98)
CREATE TABLE parent2 (p1 INT, p2 INT, other INT, PRIMARY KEY (p1, p2));

-- Test 30: statement (line 101)
CREATE TABLE child2 (c INT PRIMARY KEY, p1 INT, p2 INT, FOREIGN KEY (p1, p2) REFERENCES parent2 (p1, p2));

-- Test 31: statement (line 104)
INSERT INTO parent2 VALUES
  (10, 100),
  (10, 150),
  (20, 200);

-- Test 32: statement (line 110)
INSERT INTO child2 VALUES
  (1, 10, 100),
  (2, 10, NULL),
  (3, 10, 150),
  (4, 20, 200),
  (5, NULL, 100);

-- Test 33: statement (line 118)
DELETE FROM parent2 WHERE p1 = 10 AND p2 = 100;

-- Test 34: statement (line 121)
DELETE FROM child2 WHERE p1 = 10 AND p2 = 100;

-- Test 35: statement (line 124)
DELETE FROM parent2 WHERE p1 = 10 AND p2 = 100;

-- Test 36: statement (line 127)
DROP TABLE child2;

-- Test 37: statement (line 130)
DROP TABLE parent2;

-- Test 38: statement (line 136)
CREATE TABLE parent (p INT PRIMARY KEY, other INT);

-- Test 39: statement (line 139)
CREATE TABLE child (c INT PRIMARY KEY, p INT NOT NULL REFERENCES parent(p));

-- Test 40: statement (line 142)
INSERT INTO parent VALUES (1), (2);

-- Test 41: statement (line 146)
INSERT INTO child VALUES (1, 1) ON CONFLICT (c) DO UPDATE SET p = 2;

-- Test 42: statement (line 149)
INSERT INTO child VALUES (2, 10) ON CONFLICT (c) DO UPDATE SET p = 2;

-- Test 43: statement (line 153)
INSERT INTO child VALUES (1, 1) ON CONFLICT (c) DO UPDATE SET p = 1;

-- Test 44: statement (line 156)
INSERT INTO child VALUES (1, 10) ON CONFLICT (c) DO UPDATE SET p = 1;

-- Test 45: statement (line 159)
INSERT INTO child VALUES (1, 10) ON CONFLICT (c) DO UPDATE SET p = 10;

-- Test 46: statement (line 163)
-- ALTER TABLE child SET (schema_locked=false)

-- Test 47: statement (line 166)
TRUNCATE child;

-- Test 48: statement (line 169)
-- ALTER TABLE child RESET (schema_locked)

-- Test 49: statement (line 172)
INSERT INTO child VALUES (1, 1);

-- Test 50: statement (line 179)
INSERT INTO child VALUES (1, 1), (2, 3) ON CONFLICT (c) DO UPDATE SET p = 3;

-- Test 51: statement (line 184)
INSERT INTO child VALUES (1, 2), (2, 3) ON CONFLICT (c) DO UPDATE SET p = 1;

-- Test 52: statement (line 189)
INSERT INTO child VALUES (1, 2), (2, 1) ON CONFLICT (c) DO UPDATE SET p = 3;

-- Test 53: statement (line 194)
INSERT INTO child VALUES (1, 2), (2, 1) ON CONFLICT (c) DO UPDATE SET p = 2;

-- Test 54: statement (line 197)
DROP TABLE child;

-- Test 55: statement (line 200)
DROP TABLE parent;

-- Test 56: statement (line 205)
CREATE TABLE parent (a INT PRIMARY KEY, b INT, UNIQUE (b));

-- Test 57: statement (line 208)
CREATE TABLE child (a INT PRIMARY KEY, b INT REFERENCES parent (b));

-- Test 58: statement (line 211)
INSERT INTO parent VALUES (1, 2);

-- Test 59: statement (line 214)
INSERT INTO child VALUES (10, 2);

-- Test 60: statement (line 217)
UPSERT INTO parent VALUES (1, 3);

-- Test 61: statement (line 220)
INSERT INTO parent VALUES (1, 3), (2, 2) ON CONFLICT (a) DO UPDATE SET b = 3;

-- Test 62: query (line 223)
SELECT * FROM child;

-- Test 63: query (line 228)
SELECT * FROM parent;

-- Test 64: statement (line 236)
INSERT INTO parent VALUES (2, 2) ON CONFLICT (a) DO UPDATE SET b = parent.b - 1;

-- Test 65: statement (line 239)
DROP TABLE child;

-- Test 66: statement (line 242)
DROP TABLE parent;

-- Test 67: statement (line 247)
CREATE TABLE self (k int primary key, a int unique, b int references self(a));

-- Test 68: statement (line 250)
UPSERT INTO self VALUES (1, 1, 2);

-- Test 69: statement (line 253)
UPSERT INTO self VALUES (1, 1, 1);

-- Test 70: statement (line 256)
UPSERT INTO self VALUES (1, 1, 1);

-- Test 71: statement (line 259)
UPSERT INTO self VALUES (1, 1, 2);

-- Test 72: statement (line 262)
UPSERT INTO self VALUES (1, 2, 2);

-- Test 73: statement (line 265)
UPSERT INTO self(k,a) VALUES (1, 1);

-- Test 74: statement (line 268)
UPSERT INTO self VALUES (1, 1, 2), (2, 2, 1);

-- Test 75: statement (line 271)
INSERT INTO self VALUES (2, 2, 2) ON CONFLICT (k) DO UPDATE SET b = self.b + 1;

-- Test 76: statement (line 274)
INSERT INTO self VALUES (2, 2, 2) ON CONFLICT (k) DO UPDATE SET b = self.b + 1;

-- Test 77: statement (line 277)
DROP TABLE self;

-- Test 78: statement (line 285)
INSERT INTO customers VALUES (1, 'a@co.tld'), (2, 'b@co.tld');

-- Test 79: statement (line 291)
INSERT INTO products VALUES ('VP-W9QH-W44L', '867072000006', 'Dave'), ('780', '885155001450', 'iRobot');

-- Test 80: statement (line 297)
CREATE TABLE missing_with_col (customer INT REFERENCES customerz (id));

-- Test 81: statement (line 300)
CREATE TABLE missing_col (customer INT REFERENCES customers (idz));

-- Test 82: statement (line 303)
CREATE TABLE unindexed (customer INT REFERENCES customers);

-- Test 83: query (line 306)
SHOW INDEXES FROM unindexed;

-- Test 84: statement (line 316)
CREATE TABLE mismatch (customer INT REFERENCES customers (email));

-- Test 85: statement (line 330)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 86: statement (line 333)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON DELETE NO ACTION;

-- Test 87: statement (line 336)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 88: statement (line 339)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON UPDATE NO ACTION;

-- Test 89: statement (line 342)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 90: statement (line 345)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON DELETE CASCADE;

-- Test 91: statement (line 348)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 92: statement (line 351)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON UPDATE CASCADE;

-- Test 93: statement (line 354)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 94: statement (line 357)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON DELETE SET NULL;

-- Test 95: statement (line 360)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 96: statement (line 363)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON UPDATE SET NULL;

-- Test 97: statement (line 366)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 98: statement (line 369)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON DELETE SET DEFAULT;

-- Test 99: statement (line 372)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 100: statement (line 375)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON UPDATE SET DEFAULT;

-- Test 101: statement (line 378)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 102: statement (line 381)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON DELETE RESTRICT ON UPDATE NO ACTION;

-- Test 103: statement (line 384)
ALTER TABLE orders DROP CONSTRAINT orders_product_fkey;

-- Test 104: statement (line 387)
ALTER TABLE orders ADD FOREIGN KEY (product) REFERENCES products ON DELETE RESTRICT ON UPDATE RESTRICT;

-- Test 105: statement (line 390)
ALTER TABLE orders VALIDATE CONSTRAINT orders_product_fkey;

-- Test 106: statement (line 393)
CREATE SCHEMA IF NOT EXISTS "user content";

-- Test 107: statement (line 414)
INSERT INTO orders VALUES (1, 1, '780', 2);

-- Test 108: statement (line 417)
INSERT INTO orders VALUES (2, 2, 'fake', 2);

-- Test 109: statement (line 420)
DELETE FROM products;

-- Test 110: statement (line 423)
INSERT INTO "user content"."customer reviews" VALUES (1, '780', 2, 1, 1, NULL);

-- Test 111: statement (line 426)
INSERT INTO "user content"."customer reviews" (id, product, body) VALUES (2, '790', 'would not buy again');

-- Test 112: statement (line 429)
INSERT INTO "user content"."customer reviews" (id, product, body) VALUES (2, '780', 'would not buy again');

-- Test 113: statement (line 432)
CREATE TABLE "user content".review_stats (
  id INT PRIMARY KEY,
  upvotes INT,
  CONSTRAINT reviewfk FOREIGN KEY (id) REFERENCES "user content"."customer reviews"
);

-- Test 114: query (line 439)
SELECT * FROM [SHOW CONSTRAINTS FROM "user content".review_stats] ORDER BY constraint_name;

-- Test 115: statement (line 445)
INSERT INTO "user content".review_stats (id, upvotes) VALUES (5, 1);

-- Test 116: statement (line 448)
INSERT INTO "user content".review_stats (id, upvotes) VALUES (2, 1);

-- Test 117: statement (line 451)
DELETE FROM "user content"."customer reviews" WHERE id = 2;

-- Test 118: statement (line 454)
ALTER TABLE "user content".review_stats DROP CONSTRAINT reviewfk;

-- Test 119: query (line 457)
SHOW CONSTRAINTS FROM "user content".review_stats;

-- Test 120: statement (line 462)
DELETE FROM "user content"."customer reviews";

-- Test 121: statement (line 465)
INSERT INTO orders VALUES (2, 1, '790', 2);

-- Test 122: statement (line 468)
INSERT INTO orders VALUES (2, 1, '780', 43);

-- Test 123: statement (line 471)
INSERT INTO orders VALUES (2, 1, '780', 1);

-- Test 124: statement (line 475)
UPDATE orders SET product = '790' WHERE id = 2;

-- Test 125: statement (line 479)
UPDATE orders SET id = 3, product = '790' WHERE id = 2;

-- Test 126: statement (line 483)
UPDATE orders SET id = 3 WHERE id = 2;

-- Test 127: statement (line 487)
UPDATE orders SET id = 2, product = 'VP-W9QH-W44L' WHERE id = 3;

-- Test 128: statement (line 490)
UPDATE orders SET product = '780' WHERE id = 2;

-- Test 129: query (line 506)
SHOW CREATE TABLE delivery;

-- Test 130: query (line 522)
SHOW CREATE TABLE delivery;

-- Test 131: statement (line 537)
INSERT INTO delivery ("order", shipment, item) VALUES
  (1, 1, '867072000006'), (1, 1, '867072000006'), (1, 1, '885155001450'), (1, 1, '867072000006');

-- Test 132: statement (line 541)
INSERT INTO delivery ("order", shipment, item) VALUES
  (1, 1, '867072000006'), (1, 1, 'missing'), (1, 1, '885155001450'), (1, 1, '867072000006');

-- Test 133: statement (line 545)
INSERT INTO delivery ("order", shipment, item) VALUES
  (1, 1, '867072000006'), (1, 99, '867072000006');

-- Test 134: statement (line 549)
DELETE FROM products WHERE sku = 'VP-W9QH-W44L';

-- Test 135: statement (line 553)
UPDATE products SET vendor = '' WHERE sku = '780';

-- Test 136: statement (line 557)
UPDATE products SET sku = '770' WHERE sku = '750';

-- Test 137: statement (line 561)
UPDATE products SET sku = '770' WHERE sku = '780';

-- Test 138: statement (line 565)
UPDATE products SET upc = '885155001450' WHERE sku = '780';

-- Test 139: statement (line 569)
UPDATE products SET upc = 'blah' WHERE sku = '780';

-- Test 140: statement (line 572)
ALTER TABLE delivery DROP CONSTRAINT delivery_item_fkey;

-- Test 141: statement (line 575)
UPDATE products SET upc = 'blah' WHERE sku = '780';

-- Test 142: statement (line 578)
ALTER TABLE delivery ADD FOREIGN KEY (item) REFERENCES products (upc);

-- Test 143: query (line 581)
SELECT * FROM [SHOW CONSTRAINTS FROM delivery] ORDER BY constraint_name;

-- Test 144: statement (line 587)
UPDATE products SET upc = '885155001450' WHERE sku = '780';

-- Test 145: statement (line 590)
ALTER TABLE delivery ADD FOREIGN KEY (item) REFERENCES products (upc);

-- Test 146: query (line 593)
SELECT * FROM [SHOW CONSTRAINTS FROM delivery] ORDER BY constraint_name;

-- Test 147: statement (line 600)
ALTER TABLE "user content"."customer reviews"
  DROP CONSTRAINT orderfk;

-- Test 148: statement (line 604)
INSERT INTO "user content"."customer reviews" (id, product, body, "order") VALUES (3, '780', 'i ordered 100 of them', 9);

-- Test 149: statement (line 609)
-- ALTER TABLE "user content"."customer reviews" SET (schema_locked=false);

-- skipif config schema-locked-disabled

-- Test 150: statement (line 613)
-- ALTER TABLE orders SET (schema_locked=false);

-- Test 151: statement (line 617)
ALTER TABLE "user content"."customer reviews"
  ADD CONSTRAINT orderfk2 FOREIGN KEY ("order", shipment) REFERENCES orders (id, shipment);

-- Test 152: statement (line 623)
-- ALTER TABLE "user content"."customer reviews" RESET (schema_locked);

-- skipif config schema-locked-disabled

-- Test 153: statement (line 627)
-- ALTER TABLE orders RESET (schema_locked);

-- Test 154: statement (line 631)
ALTER TABLE "user content"."customer reviews"
  VALIDATE CONSTRAINT orderfk2;

-- Test 155: statement (line 636)
INSERT INTO "user content"."customer reviews" (id, product, body, "order") VALUES (4, '780', 'i ordered 101 of them', 9);

-- Test 156: statement (line 639)
INSERT INTO "user content"."customer reviews" (id, product, body, "order", shipment) VALUES (5, '780', 'i ordered 101 of them', 9, 1);

-- Test 157: statement (line 642)
INSERT INTO "user content"."customer reviews" (id, product, body, shipment, "order") VALUES (5, '780', 'i ordered 101 of them', 9, 1);

-- Test 158: statement (line 645)
ALTER TABLE delivery DROP CONSTRAINT delivery_order_shipment_fkey;

-- Test 159: statement (line 649)
-- ALTER TABLE orders SET (schema_locked=false);

-- Test 160: statement (line 652)
-- ALTER TABLE "user content"."customer reviews" SET (schema_locked=false);

-- Test 161: statement (line 655)
TRUNCATE orders, "user content"."customer reviews";

-- Test 162: statement (line 658)
-- ALTER TABLE orders RESET (schema_locked)

-- Test 163: statement (line 661)
-- ALTER TABLE "user content"."customer reviews" RESET (schema_locked)

-- Test 164: statement (line 665)
UPDATE products SET sku = '750', vendor = 'roomba' WHERE sku = '780';

-- Test 165: statement (line 669)
UPDATE products SET sku = '780', upc = 'blah' WHERE sku = '750';

-- Test 166: statement (line 672)
DELETE FROM products WHERE sku = '750';

-- Test 167: statement (line 675)
-- ALTER TABLE products SET (schema_locked=false);

-- Test 168: statement (line 678)
TRUNCATE products;

-- Test 169: statement (line 681)
-- ALTER TABLE products RESET (schema_locked)

-- Test 170: query (line 684)
SELECT count(*) FROM delivery;

-- Test 171: statement (line 690)
-- ALTER TABLE products SET (schema_locked=false);

-- Test 172: statement (line 693)
-- ALTER TABLE "user content"."customer reviews" SET (schema_locked=false);

-- Test 173: statement (line 696)
-- ALTER TABLE orders SET (schema_locked=false);

-- Test 174: statement (line 699)
-- ALTER TABLE delivery SET (schema_locked=false);

-- Test 175: statement (line 702)
TRUNCATE products CASCADE;

-- Test 176: statement (line 705)
-- ALTER TABLE products RESET (schema_locked)

-- Test 177: statement (line 708)
-- ALTER TABLE "user content"."customer reviews" RESET (schema_locked)

-- Test 178: statement (line 711)
-- ALTER TABLE orders RESET (schema_locked)

-- Test 179: statement (line 714)
-- ALTER TABLE delivery RESET (schema_locked)

-- Test 180: query (line 717)
SELECT count(*) FROM delivery;

-- Test 181: statement (line 723)
-- ALTER TABLE delivery SET (schema_locked=false);

-- Test 182: statement (line 726)
-- ALTER TABLE products SET (schema_locked=false);

-- Test 183: statement (line 729)
-- ALTER TABLE orders SET (schema_locked=false);

-- Test 184: statement (line 732)
-- ALTER TABLE "user content"."customer reviews" SET (schema_locked=false);

-- Test 185: statement (line 735)
TRUNCATE delivery, products, orders, "user content"."customer reviews";

-- Test 186: statement (line 738)
-- ALTER TABLE delivery RESET (schema_locked)

-- Test 187: statement (line 742)
-- ALTER TABLE orders RESET (schema_locked)

-- Test 188: statement (line 745)
-- ALTER TABLE "user content"."customer reviews" RESET (schema_locked)

-- Test 189: query (line 748)
SELECT * FROM [SHOW CONSTRAINTS FROM orders] ORDER BY constraint_name;

-- Test 190: statement (line 757)
DROP INDEX products@products_upc_key;

-- skipif config local-legacy-schema-changer

-- Test 191: statement (line 761)
DROP INDEX products@products_upc_key RESTRICT;

-- onlyif config local-legacy-schema-changer

-- Test 192: statement (line 765)
DROP INDEX products@products_upc_key;

-- onlyif config local-legacy-schema-changer

-- Test 193: statement (line 769)
DROP INDEX products@products_upc_key RESTRICT;

-- Test 194: statement (line 772)
ALTER TABLE products DROP COLUMN upc;

-- Test 195: statement (line 775)
ALTER TABLE delivery DROP COLUMN "item";

-- Test 196: statement (line 778)
DROP INDEX products@products_upc_key CASCADE;

-- Test 197: statement (line 781)
DROP TABLE products;

-- Test 198: statement (line 784)
DROP TABLE products RESTRICT;

-- Test 199: statement (line 787)
DROP TABLE orders;

-- Test 200: statement (line 790)
ALTER TABLE "user content"."customer reviews" DROP COLUMN "order" CASCADE;

-- Test 201: statement (line 793)
DROP TABLE "user content"."customer reviews";

-- Test 202: statement (line 796)
DROP TABLE orders;

-- Test 203: statement (line 799)
DROP TABLE products;

-- Test 204: statement (line 802)
CREATE TABLE parent (id int primary key);

-- Test 205: statement (line 805)
CREATE TABLE child (id INT PRIMARY KEY, parent_id INT UNIQUE REFERENCES parent);

-- Test 206: statement (line 808)
CREATE TABLE grandchild (id INT PRIMARY KEY, parent_id INT REFERENCES child (parent_id), INDEX (parent_id));

-- Test 207: statement (line 811)
DROP TABLE parent;

-- Test 208: statement (line 814)
DROP TABLE child;

-- Test 209: statement (line 817)
INSERT INTO child VALUES (2, 2);

-- Test 210: statement (line 820)
DROP TABLE parent CASCADE;

-- Test 211: statement (line 823)
INSERT INTO child VALUES (2, 2);

-- Test 212: statement (line 826)
INSERT INTO grandchild VALUES (1, 1);

-- Test 213: statement (line 829)
DROP INDEX grandchild@grandchild_parent_id_idx;

-- Test 214: statement (line 832)
DROP TABLE grandchild;

-- Test 215: statement (line 835)
CREATE TABLE grandchild (id INT PRIMARY KEY, parent_id INT REFERENCES child (parent_id), INDEX (parent_id));

-- Test 216: statement (line 838)
INSERT INTO grandchild VALUES (1, 1);

-- Test 217: statement (line 841)
DROP INDEX child@child_parent_id_key;

-- Test 218: statement (line 844)
DROP INDEX child@child_parent_id_key CASCADE;

-- Test 219: statement (line 847)
INSERT INTO grandchild VALUES (1, 1);

-- Test 220: statement (line 850)
CREATE TABLE employees (id INT PRIMARY KEY, manager INT REFERENCES employees, INDEX (manager));

-- Test 221: statement (line 853)
INSERT INTO employees VALUES (1, NULL);

-- Test 222: statement (line 856)
INSERT INTO employees VALUES (2, 1), (3, 1);

-- Test 223: statement (line 859)
INSERT INTO employees VALUES (4, 2), (5, 3);

-- Test 224: statement (line 862)
DELETE FROM employees WHERE id = 2;

-- Test 225: statement (line 866)
DELETE FROM employees WHERE id > 1;

-- Test 226: statement (line 869)
DROP TABLE employees;

-- Test 227: statement (line 875)
INSERT INTO pairs VALUES (1, 100, 'one'), (2, 200, 'two');

-- Test 228: query (line 893)
SHOW INDEXES FROM refpairs_wrong_order;

-- Test 229: query (line 907)
SHOW INDEXES FROM refpairs_c_between;

-- Test 230: query (line 930)
SHOW INDEXES FROM refpairs;

-- Test 231: query (line 944)
SHOW CREATE TABLE refpairs;

-- Test 232: query (line 958)
SHOW CREATE TABLE refpairs;

-- Test 233: statement (line 971)
INSERT INTO refpairs VALUES (100, 'two'), (200, 'two');

-- Test 234: statement (line 974)
INSERT INTO refpairs VALUES (100, 'one', 3), (200, 'two', null);

-- Test 235: statement (line 977)
UPDATE pairs SET dest = 'too' WHERE id = 2;

-- Test 236: statement (line 980)
DELETE FROM pairs WHERE id = 2;

-- Test 237: statement (line 983)
DELETE FROM pairs WHERE id = 1;

-- Test 238: statement (line 987)
CREATE TABLE foo (id INT PRIMARY KEY);

-- Test 239: statement (line 990)
CREATE TABLE bar (id INT PRIMARY KEY REFERENCES foo);

-- Test 240: statement (line 993)
INSERT INTO foo VALUES (2);

-- Test 241: statement (line 996)
INSERT INTO bar VALUES (2);

-- Test 242: statement (line 999)
DELETE FROM foo;

-- Test 243: statement (line 1002)
CREATE DATABASE otherdb;

-- Test 244: statement (line 1005)
CREATE TABLE otherdb.othertable (id INT PRIMARY KEY);

-- Test 245: statement (line 1008)
CREATE TABLE crossdb (id INT PRIMARY KEY, FOREIGN KEY (id) REFERENCES otherdb.othertable);

-- Test 246: statement (line 1011)
INSERT INTO crossdb VALUES (2);

-- Test 247: statement (line 1014)
INSERT INTO otherdb.othertable VALUES (1), (2);

-- Test 248: statement (line 1017)
INSERT INTO crossdb VALUES (2);

-- Test 249: statement (line 1020)
DELETE FROM otherdb.othertable WHERE id = 2;

-- Test 250: statement (line 1023)
DROP TABLE otherdb.othertable;

-- Test 251: statement (line 1026)
DROP TABLE otherdb.othertable, crossdb;

-- Test 252: statement (line 1029)
CREATE TABLE modules (id BIGSERIAL NOT NULL PRIMARY KEY);

-- Test 253: statement (line 1032)
CREATE TABLE domains (id BIGSERIAL NOT NULL PRIMARY KEY);

-- Test 254: statement (line 1038)
CREATE TABLE domain_modules (
  id         BIGSERIAL    NOT NULL PRIMARY KEY,
  domain_id  BIGINT       NOT NULL,
  module_id  BIGINT       NOT NULL,
  CONSTRAINT domain_modules_domain_id_fk FOREIGN KEY (domain_id) REFERENCES domains (id),
  CONSTRAINT domain_modules_module_id_fk FOREIGN KEY (module_id) REFERENCES modules (id),
  CONSTRAINT domain_modules_uq UNIQUE (domain_id, module_id)
);

-- Test 255: query (line 1048)
SELECT * FROM [SHOW CONSTRAINTS FROM domain_modules] ORDER BY constraint_name;

-- Test 256: statement (line 1056)
INSERT INTO modules VALUES(3);

-- Test 257: statement (line 1059)
INSERT INTO domain_modules VALUES (1, 2, 3);

-- Test 258: statement (line 1062)
CREATE TABLE tx (
  id INT NOT NULL PRIMARY KEY
);

-- Test 259: statement (line 1067)
CREATE TABLE tx_leg (
  leg_id SERIAL NOT NULL PRIMARY KEY,
  tx_id INT NOT NULL REFERENCES tx
);

skip_on_retry;

-- Test 260: statement (line 1075)
BEGIN TRANSACTION;

-- Test 261: statement (line 1078)
INSERT INTO tx VALUES (2);

-- Test 262: statement (line 1081)
INSERT INTO tx_leg VALUES (201, 2);

-- Test 263: statement (line 1084)
INSERT INTO tx_leg VALUES (202, 2);

-- Test 264: statement (line 1087)
COMMIT;

-- Test 265: statement (line 1090)
BEGIN TRANSACTION;

-- Test 266: statement (line 1093)
INSERT INTO tx_leg VALUES (302, 3);

-- Test 267: statement (line 1096)
COMMIT;

-- Test 268: statement (line 1099)
CREATE TABLE a (id SERIAL NOT NULL, self_id INT, b_id INT NOT NULL, PRIMARY KEY (id));

-- Test 269: statement (line 1102)
CREATE TABLE b (id SERIAL NOT NULL, PRIMARY KEY (id));

-- Test 270: statement (line 1106)
ALTER TABLE a ADD CONSTRAINT fk_self_id FOREIGN KEY (self_id) REFERENCES a;

-- Test 271: statement (line 1110)
ALTER TABLE a ADD CONSTRAINT fk_b FOREIGN KEY (b_id) REFERENCES b;

-- Test 272: statement (line 1113)
INSERT INTO b VALUES (1), (2), (3);

-- Test 273: statement (line 1116)
INSERT INTO a VALUES (1, NULL, 1);

-- Test 274: statement (line 1119)
INSERT INTO a VALUES (2, 1, 1), (3, 1, 2);

-- Test 275: statement (line 1122)
INSERT INTO a VALUES (4, 2, 2);

-- Test 276: statement (line 1125)
DELETE FROM b WHERE id = 3;

-- Test 277: statement (line 1128)
DELETE FROM b WHERE id = 2;

-- Test 278: statement (line 1131)
DELETE FROM a WHERE id = 1;

-- Test 279: statement (line 1134)
DELETE FROM a WHERE id > 2;

-- Test 280: statement (line 1137)
DELETE FROM b WHERE id = 2;

-- Test 281: statement (line 1140)
DROP TABLE a;

-- Test 282: statement (line 1157)
DROP TABLE b;

-- Test 283: statement (line 1161)
CREATE TABLE referee (id INT PRIMARY KEY);

-- Test 284: statement (line 1164)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 285: statement (line 1168)
CREATE TABLE refers (
  a INT REFERENCES referee,
  b INT,
  INDEX b_idx (b),
  FAMILY "primary" (a, b, rowid)
);

-- Test 286: statement (line 1178)
CREATE INDEX foo ON refers (a);

-- Test 287: statement (line 1181)
ALTER INDEX refers@b_idx RENAME TO another_idx;

-- onlyif config schema-locked-disabled

-- Test 288: query (line 1185)
SHOW CREATE TABLE refers;

-- Test 289: query (line 1199)
SHOW CREATE TABLE refers;

-- Test 290: statement (line 1212)
DROP INDEX refers@another_idx;

-- Test 291: query (line 1216)
SHOW TABLES FROM test;

-- Test 292: statement (line 1237)
COMMIT;

-- Test 293: statement (line 1241)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;

-- Test 294: statement (line 1245)
CREATE TABLE refers1 (a INT REFERENCES referee);

-- Test 295: statement (line 1248)
DROP TABLE refers1;

-- Test 296: statement (line 1251)
COMMIT;

-- Test 297: statement (line 1255)
CREATE TABLE employee (
   id INT PRIMARY KEY,
   manager INT,
   UNIQUE (manager)
);

-- Test 298: statement (line 1262)
ALTER TABLE employee
   ADD CONSTRAINT emp_emp
   FOREIGN KEY (manager)
   REFERENCES employee;

-- Test 299: statement (line 1268)
ALTER TABLE employee
   DROP CONSTRAINT emp_emp;

-- Test 300: statement (line 1272)
SHOW CREATE TABLE employee;

-- Test 301: statement (line 1277)
CREATE TABLE pkref_a (a INT PRIMARY KEY);

-- Test 302: statement (line 1280)
CREATE TABLE pkref_b (b INT PRIMARY KEY REFERENCES pkref_a ON UPDATE NO ACTION ON DELETE RESTRICT);

-- onlyif config schema-locked-disabled

-- Test 303: query (line 1284)
SHOW CREATE TABLE pkref_b;

-- Test 304: query (line 1294)
SHOW CREATE TABLE pkref_b;

-- Test 305: statement (line 1312)
INSERT INTO test20042 (x, y, z) VALUES ('pk1', 'k1', null);

-- Test 306: statement (line 1315)
INSERT INTO test20042 (x, y, z) VALUES ('pk2', 'k2 ', 'k1');

-- Test 307: statement (line 1318)
DELETE FROM test20042 WHERE x = 'pk2';

-- Test 308: statement (line 1321)
DELETE FROM test20042 WHERE x = 'pk1';

-- Test 309: statement (line 1333)
INSERT INTO test20045 (x, y, z) VALUES ('pk1', NULL, NULL);

-- Test 310: statement (line 1336)
INSERT INTO test20045 (x, y, z) VALUES ('pk2', 'pk1', NULL);

-- Test 311: statement (line 1339)
INSERT INTO test20045 (x, y, z) VALUES ('pk3', 'pk2', 'pk1');

-- Test 312: statement (line 1342)
DELETE FROM test20045 WHERE x = 'pk3';

-- Test 313: statement (line 1345)
DELETE FROM test20045 WHERE x = 'pk2';

-- Test 314: statement (line 1348)
DELETE FROM test20045 WHERE x = 'pk1';

-- Test 315: statement (line 1353)
CREATE DATABASE d;

-- Test 316: statement (line 1367)
INSERT INTO d.a VALUES ('a1');

-- Test 317: statement (line 1370)
INSERT INTO d.b VALUES ('b1', 'a1');

-- Test 318: statement (line 1373)
GRANT ALL ON DATABASE d TO testuser;

-- Test 319: statement (line 1376)
GRANT ALL ON d.a TO testuser;

user testuser;

-- Test 320: statement (line 1381)
DELETE FROM d.a WHERE id = 'a1';

user root;

-- Test 321: statement (line 1386)
GRANT SELECT ON d.b TO testuser;

user testuser;

-- Test 322: statement (line 1391)
DELETE FROM d.a WHERE id = 'a1';

user root;

-- Test 323: statement (line 1396)
GRANT DELETE ON d.b TO testuser;

user testuser;

-- Test 324: statement (line 1401)
DELETE FROM d.a WHERE id = 'a1';

user root;

-- Test 325: statement (line 1407)
DROP DATABASE d CASCADE;

-- Test 326: statement (line 1413)
CREATE TABLE a (
  id INT PRIMARY KEY
);

-- Test 327: statement (line 1419)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,delete_not_nullable INT NOT NULL REFERENCES a ON DELETE SET NULL
);

-- Test 328: statement (line 1425)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,update_not_nullable INT NOT NULL REFERENCES a ON UPDATE SET NULL
);

-- Test 329: statement (line 1432)
CREATE TABLE primary_key_table (
  id INT PRIMARY KEY REFERENCES a ON DELETE SET NULL
);

-- Test 330: statement (line 1437)
CREATE TABLE primary_key_table (
  id INT PRIMARY KEY REFERENCES a ON UPDATE SET NULL
);

-- Test 331: statement (line 1443)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,delete_not_nullable INT NOT NULL
 ,update_not_nullable INT NOT NULL
);

-- Test 332: statement (line 1450)
ALTER TABLE not_null_table ADD CONSTRAINT not_null_delete_set_null
  FOREIGN KEY (delete_not_nullable) REFERENCES a (id)
  ON DELETE SET NULL;

-- Test 333: statement (line 1455)
ALTER TABLE not_null_table ADD CONSTRAINT not_null_update_set_null
  FOREIGN KEY (update_not_nullable) REFERENCES a (id)
  ON UPDATE SET NULL;

-- Test 334: statement (line 1461)
DROP TABLE not_null_table;

-- Test 335: statement (line 1465)
CREATE TABLE primary_key_table (
  id INT PRIMARY KEY
);

-- Test 336: statement (line 1470)
ALTER TABLE primary_key_table ADD CONSTRAINT not_null_set_null
  FOREIGN KEY (id) REFERENCES a (id)
  ON DELETE SET NULL;

-- Test 337: statement (line 1475)
ALTER TABLE primary_key_table ADD CONSTRAINT not_null_set_null
  FOREIGN KEY (id) REFERENCES a (id)
  ON UPDATE SET NULL;

-- Test 338: statement (line 1481)
DROP TABLE primary_key_table, a;

-- Test 339: statement (line 1485)
CREATE TABLE a (
  id1 INT
 ,id2 INT
 ,PRIMARY KEY (id2, id1)
);

-- Test 340: statement (line 1493)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,ref1 INT NOT NULL
 ,ref2 INT NOT NULL
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON DELETE SET NULL
);

-- Test 341: statement (line 1502)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,ref1 INT NOT NULL
 ,ref2 INT NOT NULL
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON UPDATE SET NULL
);

-- Test 342: statement (line 1511)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,ref1 INT NOT NULL
 ,ref2 INT
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON DELETE SET NULL
);

-- Test 343: statement (line 1520)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,ref1 INT NOT NULL
 ,ref2 INT
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON UPDATE SET NULL
);

-- Test 344: statement (line 1529)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,ref1 INT
 ,ref2 INT NOT NULL
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON DELETE SET NULL
);

-- Test 345: statement (line 1538)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,ref1 INT
 ,ref2 INT NOT NULL
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON UPDATE SET NULL
);

-- Test 346: statement (line 1548)
CREATE TABLE primary_key_table (
  ref1 INT
 ,ref2 INT
 ,PRIMARY KEY (ref2, ref1)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON DELETE SET NULL
);

-- Test 347: statement (line 1557)
CREATE TABLE primary_key_table (
  ref1 INT
 ,ref2 INT
 ,PRIMARY KEY (ref2, ref1)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON UPDATE SET NULL
);

-- Test 348: statement (line 1565)
CREATE TABLE primary_key_table (
  ref1 INT
 ,ref2 INT
 ,PRIMARY KEY (ref2, ref1)
 ,FOREIGN KEY (ref2, ref1) REFERENCES a (id2, id1) ON DELETE SET NULL
);

-- Test 349: statement (line 1573)
CREATE TABLE primary_key_table (
  ref1 INT
 ,ref2 INT
 ,PRIMARY KEY (ref2, ref1)
 ,FOREIGN KEY (ref2, ref1) REFERENCES a (id2, id1) ON UPDATE SET NULL
);

-- Test 350: statement (line 1582)
DROP TABLE a;

-- Test 351: statement (line 1589)
CREATE TABLE a (
  id INT PRIMARY KEY
);

-- Test 352: statement (line 1595)
CREATE TABLE delete_no_default_table (
  id INT PRIMARY KEY
 ,delete_no_default INT REFERENCES a ON DELETE SET DEFAULT
);

-- Test 353: statement (line 1601)
CREATE TABLE update_no_default_table (
  id INT PRIMARY KEY
 ,update_no_default INT NOT NULL REFERENCES a ON UPDATE SET DEFAULT
);

-- Test 354: statement (line 1609)
CREATE TABLE primary_key_table_set_default (
  id INT PRIMARY KEY REFERENCES a ON DELETE SET DEFAULT
);

-- Test 355: statement (line 1614)
CREATE TABLE primary_key_table (
  id INT PRIMARY KEY REFERENCES a ON UPDATE SET DEFAULT
);

-- Test 356: statement (line 1620)
CREATE TABLE no_default_table (
  id INT PRIMARY KEY
 ,delete_no_default INT
 ,update_no_default INT
);

-- Test 357: statement (line 1627)
ALTER TABLE no_default_table ADD CONSTRAINT no_default_delete_set_default
  FOREIGN KEY (delete_no_default) REFERENCES a (id)
  ON DELETE SET DEFAULT;

-- Test 358: statement (line 1632)
ALTER TABLE no_default_table ADD CONSTRAINT no_default_update_set_default
  FOREIGN KEY (update_no_default) REFERENCES a (id)
  ON UPDATE SET DEFAULT;

-- Test 359: statement (line 1638)
DROP TABLE no_default_table;

-- Test 360: statement (line 1643)
CREATE TABLE primary_key_table (
  id INT PRIMARY KEY
);

-- Test 361: statement (line 1649)
ALTER TABLE primary_key_table ADD CONSTRAINT no_default_delete_set_default
  FOREIGN KEY (id) REFERENCES a (id)
  ON DELETE SET DEFAULT;

-- Test 362: statement (line 1654)
ALTER TABLE primary_key_table ADD CONSTRAINT no_default_update_set_default
  FOREIGN KEY (id) REFERENCES a (id)
  ON UPDATE SET DEFAULT;

-- Test 363: statement (line 1660)
DROP TABLE primary_key_table, delete_no_default_table, a;

-- Test 364: statement (line 1664)
CREATE TABLE a (
  id1 INT
 ,id2 INT
 ,PRIMARY KEY (id2, id1)
);

-- Test 365: statement (line 1672)
CREATE TABLE no_default_table (
  id INT PRIMARY KEY
 ,ref1 INT
 ,ref2 INT
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON DELETE SET DEFAULT
);

-- Test 366: statement (line 1681)
INSERT INTO a VALUES (1, 2);

-- Test 367: statement (line 1684)
INSERT INTO a VALUES (3, 4);

-- Test 368: statement (line 1687)
INSERT INTO no_default_table VALUES (6, 2, 1);

-- Test 369: query (line 1690)
SELECT * FROM no_default_table;

-- Test 370: statement (line 1696)
DELETE FROM a WHERE id1=1;

-- Test 371: query (line 1699)
SELECT * FROM no_default_table;

-- Test 372: statement (line 1705)
CREATE TABLE no_default_table_on_update (
  id INT PRIMARY KEY
 ,ref1 INT
 ,ref2 INT
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON UPDATE SET DEFAULT
);

-- Test 373: statement (line 1714)
INSERT INTO no_default_table_on_update VALUES (0, 4, 3);

-- Test 374: query (line 1717)
SELECT * FROM no_default_table_on_update;

-- Test 375: statement (line 1723)
UPDATE a SET id1=33, id2=44 WHERE id1=3;

-- Test 376: query (line 1726)
SELECT * FROM no_default_table_on_update;

-- Test 377: statement (line 1732)
CREATE TABLE no_default_table_ref2_default_on_delete (
  id INT PRIMARY KEY
 ,ref1 INT
 ,ref2 INT DEFAULT 1
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON DELETE SET DEFAULT
);

-- Test 378: statement (line 1741)
CREATE TABLE no_default_table_ref2_default_on_update (
  id INT PRIMARY KEY
 ,ref1 INT
 ,ref2 INT DEFAULT 1
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON UPDATE SET DEFAULT
);

-- Test 379: statement (line 1750)
CREATE TABLE no_default_table_ref1_default_on_delete (
  id INT PRIMARY KEY
 ,ref1 INT DEFAULT 1
 ,ref2 INT
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON DELETE SET DEFAULT
);

-- Test 380: statement (line 1759)
CREATE TABLE no_default_table_ref1_default_on_update (
  id INT PRIMARY KEY
 ,ref1 INT DEFAULT 1
 ,ref2 INT
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON UPDATE SET DEFAULT
);

-- Test 381: statement (line 1769)
CREATE TABLE not_null_table (
  id INT PRIMARY KEY
 ,ref1 INT NOT NULL
 ,ref2 INT NOT NULL
 ,INDEX (ref1, ref2)
 ,FOREIGN KEY (ref1, ref2) REFERENCES a (id2, id1) ON DELETE SET DEFAULT
);

-- Test 382: statement (line 1779)
DROP TABLE a, no_default_table, no_default_table_on_update, no_default_table_ref2_default_on_delete,
no_default_table_ref2_default_on_update, no_default_table_ref1_default_on_delete,
no_default_table_ref1_default_on_update;

-- Test 383: statement (line 1806)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y1', 'z1');

-- Test 384: statement (line 1809)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) NOT VALID;

-- Test 385: statement (line 1812)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 386: query (line 1816)
SELECT
  s.a_z, s.a_y, s.a_x
FROM
  (SELECT * FROM b WHERE a_z IS NOT NULL AND a_y IS NOT NULL AND a_x IS NOT NULL) AS s
  LEFT JOIN a AS t ON s.a_z = t.z AND s.a_y = t.y AND s.a_x = t.x
WHERE
  t.z IS NULL;

-- Test 387: statement (line 1827)
DROP TABLE a, b;

-- Test 388: statement (line 1848)
INSERT INTO a (x, y) VALUES ('x1', 'y1');

-- Test 389: statement (line 1852)
INSERT INTO b (a_x) VALUES ('x1');

-- Test 390: statement (line 1855)
INSERT INTO b (a_y) VALUES ('y1');

-- Test 391: statement (line 1858)
INSERT INTO b (a_y, a_x) VALUES ('y1', NULL);

-- Test 392: statement (line 1861)
INSERT INTO b (a_y, a_x) VALUES (NULL, 'x1');

-- Test 393: statement (line 1864)
INSERT INTO b (a_x, a_y) VALUES ('x1', 'y1');

-- Test 394: statement (line 1867)
INSERT INTO b (a_x, a_y) VALUES (NULL, NULL);

-- Test 395: statement (line 1870)
DROP TABLE b, a;

-- Test 396: statement (line 1890)
INSERT INTO a (x, y, z) VALUES ('x1', 'y1', 'z1');

-- Test 397: statement (line 1894)
INSERT INTO b (a_x) VALUES ('x1');

-- Test 398: statement (line 1897)
INSERT INTO b (a_y) VALUES ('y1');

-- Test 399: statement (line 1900)
INSERT INTO b (a_z) VALUES ('z1');

-- Test 400: statement (line 1903)
INSERT INTO b (a_x, a_y) VALUES ('x1', 'y1');

-- Test 401: statement (line 1906)
INSERT INTO b (a_x, a_y) VALUES (NULL, 'y1');

-- Test 402: statement (line 1909)
INSERT INTO b (a_x, a_y) VALUES ('x1', NULL);

-- Test 403: statement (line 1912)
INSERT INTO b (a_x, a_z) VALUES ('x1', 'z1');

-- Test 404: statement (line 1915)
INSERT INTO b (a_x, a_z) VALUES (NULL, 'z1');

-- Test 405: statement (line 1918)
INSERT INTO b (a_x, a_z) VALUES ('x1', NULL);

-- Test 406: statement (line 1921)
INSERT INTO b (a_y, a_z) VALUES ('y1', 'z1');

-- Test 407: statement (line 1924)
INSERT INTO b (a_y, a_z) VALUES (NULL, 'z1');

-- Test 408: statement (line 1927)
INSERT INTO b (a_y, a_z) VALUES ('y1', NULL);

-- Test 409: statement (line 1930)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, NULL);

-- Test 410: statement (line 1933)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', NULL);

-- Test 411: statement (line 1936)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z1');

-- Test 412: statement (line 1939)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', 'y1', NULL);

-- Test 413: statement (line 1942)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, 'z1');

-- Test 414: statement (line 1945)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', 'z1');

-- Test 415: statement (line 1948)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, NULL);

-- Test 416: statement (line 1951)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', NULL, NULL);

-- Test 417: statement (line 1954)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y2', NULL);

-- Test 418: statement (line 1957)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z2');

-- Test 419: statement (line 1960)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y2', NULL);

-- Test 420: statement (line 1963)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', NULL, 'z2');

-- Test 421: statement (line 1966)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y2', 'z2');

-- Test 422: statement (line 1969)
DROP TABLE b, a;

-- Test 423: statement (line 1991)
INSERT INTO a (x, y, z) VALUES ('x1', 'y1', 'z1');

-- Test 424: statement (line 1995)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, NULL);

-- Test 425: statement (line 1998)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', NULL);

-- Test 426: statement (line 2001)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z1');

-- Test 427: statement (line 2004)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', 'y1', NULL);

-- Test 428: statement (line 2007)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, 'z1');

-- Test 429: statement (line 2010)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', 'z1');

-- Test 430: statement (line 2013)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, NULL);

-- Test 431: statement (line 2016)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', NULL, NULL);

-- Test 432: statement (line 2019)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y2', NULL);

-- Test 433: statement (line 2022)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z2');

-- Test 434: statement (line 2025)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y2', NULL);

-- Test 435: statement (line 2028)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', NULL, 'z2');

-- Test 436: statement (line 2031)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y2', 'z2');

-- Test 437: statement (line 2034)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x);

-- Test 438: statement (line 2037)
DROP TABLE b, a;

-- Test 439: statement (line 2059)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y1', 'z1');

-- Test 440: statement (line 2062)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x);

-- Test 441: statement (line 2065)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 442: statement (line 2068)
TRUNCATE b;

-- Test 443: statement (line 2071)
-- ALTER TABLE b RESET (schema_locked);

-- Test 444: statement (line 2074)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y2', 'z1');

-- Test 445: statement (line 2077)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x);

-- Test 446: statement (line 2080)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 447: statement (line 2083)
TRUNCATE b;

-- Test 448: statement (line 2086)
-- ALTER TABLE b RESET (schema_locked);

-- Test 449: statement (line 2089)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y2', 'z2');

-- Test 450: statement (line 2092)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x);

-- Test 451: statement (line 2095)
DROP TABLE b, a;

-- Test 452: statement (line 2116)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_y, a_x) REFERENCES a (y, x) NOT VALID;

-- Test 453: statement (line 2119)
INSERT INTO a (x, y) VALUES ('x1', 'y1');

-- Test 454: statement (line 2123)
INSERT INTO b (a_x) VALUES ('x1');

-- Test 455: statement (line 2126)
INSERT INTO b (a_y) VALUES ('y1');

-- Test 456: statement (line 2129)
INSERT INTO b (a_y, a_x) VALUES ('y1', NULL);

-- Test 457: statement (line 2132)
INSERT INTO b (a_y, a_x) VALUES (NULL, 'x1');

-- Test 458: statement (line 2135)
INSERT INTO b (a_y, a_x) VALUES ('y2', NULL);

-- Test 459: statement (line 2138)
INSERT INTO b (a_y, a_x) VALUES (NULL, 'x2');

-- Test 460: statement (line 2141)
INSERT INTO b (a_x, a_y) VALUES ('x1', 'y1');

-- Test 461: statement (line 2144)
INSERT INTO b (a_x, a_y) VALUES (NULL, NULL);

-- Test 462: statement (line 2147)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 463: statement (line 2150)
DROP TABLE b, a;

-- Test 464: statement (line 2170)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) NOT VALID;

-- Test 465: statement (line 2173)
INSERT INTO a (x, y, z) VALUES ('x1', 'y1', 'z1');

-- Test 466: statement (line 2177)
INSERT INTO b (a_x) VALUES ('x1');

-- Test 467: statement (line 2180)
INSERT INTO b (a_y) VALUES ('y1');

-- Test 468: statement (line 2183)
INSERT INTO b (a_z) VALUES ('z1');

-- Test 469: statement (line 2186)
INSERT INTO b (a_x, a_y) VALUES ('x1', 'y1');

-- Test 470: statement (line 2189)
INSERT INTO b (a_x, a_y) VALUES (NULL, 'y1');

-- Test 471: statement (line 2192)
INSERT INTO b (a_x, a_y) VALUES ('x1', NULL);

-- Test 472: statement (line 2195)
INSERT INTO b (a_x, a_z) VALUES ('x1', 'z1');

-- Test 473: statement (line 2198)
INSERT INTO b (a_x, a_z) VALUES (NULL, 'z1');

-- Test 474: statement (line 2201)
INSERT INTO b (a_x, a_z) VALUES ('x1', NULL);

-- Test 475: statement (line 2204)
INSERT INTO b (a_y, a_z) VALUES ('y1', 'z1');

-- Test 476: statement (line 2207)
INSERT INTO b (a_y, a_z) VALUES (NULL, 'z1');

-- Test 477: statement (line 2210)
INSERT INTO b (a_y, a_z) VALUES ('y1', NULL);

-- Test 478: statement (line 2213)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, NULL);

-- Test 479: statement (line 2216)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', NULL);

-- Test 480: statement (line 2219)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z1');

-- Test 481: statement (line 2222)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', 'y1', NULL);

-- Test 482: statement (line 2225)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, 'z1');

-- Test 483: statement (line 2228)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', 'z1');

-- Test 484: statement (line 2231)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', NULL, NULL);

-- Test 485: statement (line 2234)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y2', NULL);

-- Test 486: statement (line 2237)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z2');

-- Test 487: statement (line 2240)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y2', NULL);

-- Test 488: statement (line 2243)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', NULL, 'z2');

-- Test 489: statement (line 2246)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y2', 'z2');

-- Test 490: statement (line 2249)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, NULL);

-- Test 491: statement (line 2252)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 492: statement (line 2255)
DROP TABLE b, a;

-- Test 493: statement (line 2278)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_y, a_x) REFERENCES a (y, x) MATCH FULL NOT VALID;

-- Test 494: statement (line 2281)
INSERT INTO a (x, y) VALUES ('x1', 'y1');

-- Test 495: statement (line 2285)
INSERT INTO b (a_x) VALUES ('x1');

-- Test 496: statement (line 2288)
INSERT INTO b (a_y) VALUES ('y1');

-- Test 497: statement (line 2291)
INSERT INTO b (a_y, a_x) VALUES ('y1', NULL);

-- Test 498: statement (line 2294)
INSERT INTO b (a_y, a_x) VALUES (NULL, 'x1');

-- Test 499: statement (line 2298)
INSERT INTO b (a_x, a_y) VALUES ('x1', 'y1');

-- Test 500: statement (line 2301)
INSERT INTO b (a_x, a_y) VALUES (NULL, NULL);

-- Test 501: statement (line 2304)
DROP TABLE b, a;

-- Test 502: statement (line 2323)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 503: statement (line 2326)
INSERT INTO a (x, y, z) VALUES ('x1', 'y1', 'z1');

-- Test 504: statement (line 2330)
INSERT INTO b (a_x) VALUES ('x1');

-- Test 505: statement (line 2333)
INSERT INTO b (a_y) VALUES ('y1');

-- Test 506: statement (line 2336)
INSERT INTO b (a_z) VALUES ('z1');

-- Test 507: statement (line 2339)
INSERT INTO b (a_x, a_y) VALUES ('x1', 'y1');

-- Test 508: statement (line 2342)
INSERT INTO b (a_x, a_y) VALUES (NULL, 'y1');

-- Test 509: statement (line 2345)
INSERT INTO b (a_x, a_y) VALUES ('x1', NULL);

-- Test 510: statement (line 2348)
INSERT INTO b (a_x, a_z) VALUES ('x1', 'z1');

-- Test 511: statement (line 2351)
INSERT INTO b (a_x, a_z) VALUES (NULL, 'z1');

-- Test 512: statement (line 2354)
INSERT INTO b (a_x, a_z) VALUES ('x1', NULL);

-- Test 513: statement (line 2357)
INSERT INTO b (a_y, a_z) VALUES ('y1', 'z1');

-- Test 514: statement (line 2360)
INSERT INTO b (a_y, a_z) VALUES (NULL, 'z1');

-- Test 515: statement (line 2363)
INSERT INTO b (a_y, a_z) VALUES ('y1', NULL);

-- Test 516: statement (line 2366)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, NULL);

-- Test 517: statement (line 2369)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', NULL);

-- Test 518: statement (line 2372)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z1');

-- Test 519: statement (line 2375)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', 'y1', NULL);

-- Test 520: statement (line 2378)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, 'z1');

-- Test 521: statement (line 2381)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', 'z1');

-- Test 522: statement (line 2385)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, NULL);

-- Test 523: statement (line 2388)
DROP TABLE b, a;

-- Test 524: statement (line 2410)
INSERT INTO a (x, y, z) VALUES ('x1', 'y1', 'z1');

-- Test 525: statement (line 2414)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, NULL);

-- Test 526: statement (line 2417)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x);

-- Test 527: statement (line 2420)
DROP TABLE b, a;

-- Test 528: statement (line 2442)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, NULL);

-- Test 529: statement (line 2445)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL;

-- Test 530: statement (line 2448)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 531: statement (line 2451)
TRUNCATE b;

-- Test 532: statement (line 2454)
-- ALTER TABLE b RESET (schema_locked);

-- Test 533: statement (line 2457)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', NULL);

-- Test 534: statement (line 2460)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL;

-- Test 535: statement (line 2463)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 536: statement (line 2466)
TRUNCATE b;

-- Test 537: statement (line 2469)
-- ALTER TABLE b RESET (schema_locked);

-- Test 538: statement (line 2472)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z1');

-- Test 539: statement (line 2475)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL;

-- Test 540: statement (line 2478)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 541: statement (line 2481)
TRUNCATE b;

-- Test 542: statement (line 2484)
-- ALTER TABLE b RESET (schema_locked);

-- Test 543: statement (line 2487)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', 'y1', NULL);

-- Test 544: statement (line 2490)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL;

-- Test 545: statement (line 2493)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 546: statement (line 2496)
TRUNCATE b;

-- Test 547: statement (line 2499)
-- ALTER TABLE b RESET (schema_locked);

-- Test 548: statement (line 2502)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, 'z1');

-- Test 549: statement (line 2505)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL;

-- Test 550: statement (line 2508)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 551: statement (line 2511)
TRUNCATE b;

-- Test 552: statement (line 2514)
-- ALTER TABLE b RESET (schema_locked);

-- Test 553: statement (line 2517)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', 'z1');

-- Test 554: statement (line 2520)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL;

-- Test 555: statement (line 2523)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 556: statement (line 2526)
TRUNCATE b;

-- Test 557: statement (line 2529)
-- ALTER TABLE b RESET (schema_locked);

-- Test 558: statement (line 2532)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y1', 'z1');

-- Test 559: statement (line 2535)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL;

-- Test 560: statement (line 2538)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 561: statement (line 2541)
TRUNCATE b;

-- Test 562: statement (line 2544)
-- ALTER TABLE b RESET (schema_locked);

-- Test 563: statement (line 2547)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y2', 'z1');

-- Test 564: statement (line 2550)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL;

-- Test 565: statement (line 2553)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 566: statement (line 2556)
TRUNCATE b;

-- Test 567: statement (line 2559)
-- ALTER TABLE b RESET (schema_locked);

-- Test 568: statement (line 2562)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y2', 'z2');

-- Test 569: statement (line 2565)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL;

-- Test 570: statement (line 2568)
DROP TABLE b, a;

-- Test 571: statement (line 2589)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_y, a_x) REFERENCES a (y, x) MATCH FULL NOT VALID;

-- Test 572: statement (line 2592)
INSERT INTO a (x, y) VALUES ('x1', 'y1');

-- Test 573: statement (line 2596)
INSERT INTO b (a_x) VALUES ('x1');

-- Test 574: statement (line 2599)
INSERT INTO b (a_y) VALUES ('y1');

-- Test 575: statement (line 2602)
INSERT INTO b (a_y, a_x) VALUES ('y1', NULL);

-- Test 576: statement (line 2605)
INSERT INTO b (a_y, a_x) VALUES (NULL, 'x1');

-- Test 577: statement (line 2609)
INSERT INTO b (a_x, a_y) VALUES ('x1', 'y1');

-- Test 578: statement (line 2612)
INSERT INTO b (a_x, a_y) VALUES (NULL, NULL);

-- Test 579: statement (line 2615)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 580: statement (line 2618)
DROP TABLE b, a;

-- Test 581: statement (line 2638)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 582: statement (line 2641)
INSERT INTO a (x, y, z) VALUES ('x1', 'y1', 'z1');

-- Test 583: statement (line 2645)
INSERT INTO b (a_x) VALUES ('x1');

-- Test 584: statement (line 2648)
INSERT INTO b (a_y) VALUES ('y1');

-- Test 585: statement (line 2651)
INSERT INTO b (a_z) VALUES ('z1');

-- Test 586: statement (line 2654)
INSERT INTO b (a_x, a_y) VALUES ('x1', 'y1');

-- Test 587: statement (line 2657)
INSERT INTO b (a_x, a_y) VALUES (NULL, 'y1');

-- Test 588: statement (line 2660)
INSERT INTO b (a_x, a_y) VALUES ('x1', NULL);

-- Test 589: statement (line 2663)
INSERT INTO b (a_x, a_z) VALUES ('x1', 'z1');

-- Test 590: statement (line 2666)
INSERT INTO b (a_x, a_z) VALUES (NULL, 'z1');

-- Test 591: statement (line 2669)
INSERT INTO b (a_x, a_z) VALUES ('x1', NULL);

-- Test 592: statement (line 2672)
INSERT INTO b (a_y, a_z) VALUES ('y1', 'z1');

-- Test 593: statement (line 2675)
INSERT INTO b (a_y, a_z) VALUES (NULL, 'z1');

-- Test 594: statement (line 2678)
INSERT INTO b (a_y, a_z) VALUES ('y1', NULL);

-- Test 595: statement (line 2681)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, NULL);

-- Test 596: statement (line 2684)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', NULL);

-- Test 597: statement (line 2687)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z1');

-- Test 598: statement (line 2690)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', 'y1', NULL);

-- Test 599: statement (line 2693)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, 'z1');

-- Test 600: statement (line 2696)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', 'z1');

-- Test 601: statement (line 2700)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, NULL);

-- Test 602: statement (line 2703)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 603: statement (line 2706)
DROP TABLE b, a;

-- Test 604: statement (line 2728)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, NULL);

-- Test 605: statement (line 2731)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 606: statement (line 2734)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 607: statement (line 2737)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 608: statement (line 2740)
TRUNCATE b;

-- Test 609: statement (line 2743)
-- ALTER TABLE b RESET (schema_locked);

-- Test 610: statement (line 2746)
ALTER TABLE b DROP CONSTRAINT fk_ref;

-- Test 611: statement (line 2749)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', NULL);

-- Test 612: statement (line 2752)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 613: statement (line 2755)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 614: statement (line 2758)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 615: statement (line 2761)
TRUNCATE b;

-- Test 616: statement (line 2764)
-- ALTER TABLE b RESET (schema_locked);

-- Test 617: statement (line 2767)
ALTER TABLE b DROP CONSTRAINT fk_ref;

-- Test 618: statement (line 2770)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, NULL, 'z1');

-- Test 619: statement (line 2773)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 620: statement (line 2776)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 621: statement (line 2779)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 622: statement (line 2782)
TRUNCATE b;

-- Test 623: statement (line 2785)
-- ALTER TABLE b RESET (schema_locked);

-- Test 624: statement (line 2788)
ALTER TABLE b DROP CONSTRAINT fk_ref;

-- Test 625: statement (line 2791)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', 'y1', NULL);

-- Test 626: statement (line 2794)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 627: statement (line 2797)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 628: statement (line 2800)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 629: statement (line 2803)
TRUNCATE b;

-- Test 630: statement (line 2806)
-- ALTER TABLE b RESET (schema_locked);

-- Test 631: statement (line 2809)
ALTER TABLE b DROP CONSTRAINT fk_ref;

-- Test 632: statement (line 2812)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x1', NULL, 'z1');

-- Test 633: statement (line 2815)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 634: statement (line 2818)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 635: statement (line 2821)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 636: statement (line 2824)
TRUNCATE b;

-- Test 637: statement (line 2827)
-- ALTER TABLE b RESET (schema_locked);

-- Test 638: statement (line 2830)
ALTER TABLE b DROP CONSTRAINT fk_ref;

-- Test 639: statement (line 2833)
INSERT INTO b (a_x, a_y, a_z) VALUES (NULL, 'y1', 'z1');

-- Test 640: statement (line 2836)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 641: statement (line 2839)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 642: statement (line 2842)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 643: statement (line 2845)
TRUNCATE b;

-- Test 644: statement (line 2848)
-- ALTER TABLE b RESET (schema_locked);

-- Test 645: statement (line 2851)
ALTER TABLE b DROP CONSTRAINT fk_ref;

-- Test 646: statement (line 2854)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y1', 'z1');

-- Test 647: statement (line 2857)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 648: statement (line 2860)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 649: statement (line 2863)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 650: statement (line 2866)
TRUNCATE b;

-- Test 651: statement (line 2869)
-- ALTER TABLE b RESET (schema_locked);

-- Test 652: statement (line 2872)
ALTER TABLE b DROP CONSTRAINT fk_ref;

-- Test 653: statement (line 2875)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y2', 'z1');

-- Test 654: statement (line 2878)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 655: statement (line 2881)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 656: statement (line 2884)
-- ALTER TABLE b SET (schema_locked=false);

-- Test 657: statement (line 2887)
TRUNCATE b;

-- Test 658: statement (line 2890)
-- ALTER TABLE b RESET (schema_locked);

-- Test 659: statement (line 2893)
ALTER TABLE b DROP CONSTRAINT fk_ref;

-- Test 660: statement (line 2896)
INSERT INTO b (a_x, a_y, a_z) VALUES ('x2', 'y2', 'z2');

-- Test 661: statement (line 2899)
ALTER TABLE b ADD CONSTRAINT fk_ref FOREIGN KEY (a_z, a_y, a_x) REFERENCES a (z, y, x) MATCH FULL NOT VALID;

-- Test 662: statement (line 2902)
ALTER TABLE b VALIDATE CONSTRAINT fk_ref;

-- Test 663: statement (line 2905)
DROP TABLE b, a;

-- Test 664: statement (line 2910)
CREATE TABLE parent_composite_index (a_id INT NOT NULL, b_id INT NOT NULL, PRIMARY KEY (a_id, b_id));

-- Test 665: statement (line 2913)
CREATE TABLE child_composite_index (id SERIAL NOT NULL, parent_a_id INT, parent_b_id INT, PRIMARY KEY (id));

-- Test 666: statement (line 2917)
ALTER TABLE child_composite_index ADD CONSTRAINT fk_id FOREIGN KEY (parent_a_id, parent_b_id) REFERENCES parent_composite_index;

-- Test 667: statement (line 2920)
INSERT INTO parent_composite_index VALUES (100, 200);

-- Test 668: statement (line 2923)
INSERT INTO child_composite_index VALUES (1, 100, 200);

-- Test 669: statement (line 2926)
INSERT INTO child_composite_index VALUES (2, 100, 300);

-- Test 670: statement (line 2929)
DROP TABLE child_composite_index, parent_composite_index;

-- Test 671: statement (line 2934)
CREATE TABLE nonempty_a (id SERIAL NOT NULL, self_id INT, b_id INT NOT NULL, PRIMARY KEY (id));

-- Test 672: statement (line 2937)
CREATE TABLE nonempty_b (id SERIAL NOT NULL, PRIMARY KEY (id));

-- Test 673: statement (line 2940)
INSERT INTO nonempty_b VALUES (1), (2), (3);

-- Test 674: statement (line 2943)
INSERT INTO nonempty_a VALUES (1, NULL, 1);

-- Test 675: statement (line 2946)
ALTER TABLE nonempty_a ADD CONSTRAINT fk_self_id FOREIGN KEY (self_id) REFERENCES nonempty_a;

-- Test 676: statement (line 2949)
ALTER TABLE nonempty_a ADD CONSTRAINT fk_b FOREIGN KEY (b_id) REFERENCES nonempty_b;

-- Test 677: statement (line 2952)
DROP TABLE nonempty_a, nonempty_b;

-- Test 678: statement (line 2957)
CREATE TABLE parent_name_collision (id SERIAL NOT NULL, PRIMARY KEY (id));

-- Test 679: statement (line 2960)
CREATE TABLE child_name_collision (id SERIAL NOT NULL, parent_id INT, other_col INT);

-- Test 680: statement (line 2963)
CREATE INDEX child_name_collision_auto_index_fk_id ON child_name_collision (other_col);

-- Test 681: statement (line 2970)
ALTER TABLE child_name_collision ADD CONSTRAINT fk_id FOREIGN KEY (parent_id) references parent_name_collision;

-- Test 682: statement (line 2975)
CREATE TABLE parent (a_id INT, b_id INT, PRIMARY KEY (a_id, b_id));

-- Test 683: statement (line 2978)
CREATE TABLE child_duplicate_cols (id INT, parent_id INT, PRIMARY KEY (id));

-- Test 684: statement (line 2982)
ALTER TABLE child_duplicate_cols ADD CONSTRAINT fk FOREIGN KEY (parent_id, parent_id) references parent;

-- Test 685: statement (line 2985)
DROP TABLE parent, child_duplicate_cols;

-- Test 686: statement (line 2995)
CREATE TABLE parentid (
    k INT NOT NULL PRIMARY KEY,
    v INT NOT NULL
);

-- Test 687: statement (line 3001)
CREATE TABLE childid (
    id INT NOT NULL PRIMARY KEY
);

-- Test 688: statement (line 3007)
INSERT INTO parentid (k, v) VALUES (0, 1); INSERT INTO childid (id) VALUES (2);

-- skipif config schema-locked-disabled

-- Test 689: statement (line 3011)
-- ALTER TABLE parentid SET (schema_locked=false);

-- skipif config schema-locked-disabled

-- Test 690: statement (line 3015)
-- ALTER TABLE childid SET (schema_locked=false);

-- Test 691: statement (line 3018)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE parentid ADD id INT NOT NULL AS (k + 2) STORED;
ALTER TABLE childid ADD CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES parentid (id);

-- Test 692: statement (line 3024)
ROLLBACK;


-- skipif config schema-locked-disabled

-- Test 693: statement (line 3029)
-- ALTER TABLE parentid RESET (schema_locked)

-- skipif config schema-locked-disabled

-- Test 694: statement (line 3033)
-- ALTER TABLE childid RESET (schema_locked)

-- Test 695: statement (line 3039)
CREATE TABLE t1(x INT UNIQUE);

-- Test 696: statement (line 3042)
INSERT INTO t1(x) VALUES (1), (null);

-- Test 697: statement (line 3045)
CREATE TABLE t2(
  x INT REFERENCES t1(x)
);

-- Test 698: statement (line 3050)
INSERT INTO t2(x) VALUES (1), (null);

-- Test 699: statement (line 3053)
DELETE FROM t1 WHERE x IS NULL;

-- Test 700: statement (line 3056)
DROP TABLE t1, t2 CASCADE;

-- Test 701: statement (line 3067)
INSERT INTO pet VALUES (0, 'crookshanks');

-- Test 702: statement (line 3070)
ALTER TABLE pet ADD CONSTRAINT fk_constraint FOREIGN KEY (id) REFERENCES person (id);

-- Test 703: statement (line 3073)
ALTER TABLE pet ADD CONSTRAINT fk_constraint FOREIGN KEY (id) REFERENCES person (id) NOT VALID;

-- Test 704: query (line 3076)
SELECT * FROM [SHOW CONSTRAINTS FROM pet] ORDER BY constraint_name;

-- Test 705: statement (line 3082)
ALTER TABLE pet VALIDATE CONSTRAINT fk_constraint;

-- Test 706: statement (line 3085)
INSERT INTO person VALUES (0, 18, 'Hermione Granger');

-- Test 707: statement (line 3088)
ALTER TABLE pet VALIDATE CONSTRAINT fk_constraint;

-- Test 708: query (line 3091)
SELECT * FROM [SHOW CONSTRAINTS FROM pet] ORDER BY constraint_name;

-- Test 709: statement (line 3097)
DROP TABLE person, pet;

-- Test 710: statement (line 3100)
DROP TABLE child;

-- Test 711: statement (line 3106)
CREATE TABLE parent (x INT, p INT PRIMARY KEY, u INT UNIQUE);

-- Test 712: statement (line 3109)
CREATE TABLE child (c INT PRIMARY KEY, p INT NOT NULL REFERENCES parent(p));

-- Test 713: statement (line 3112)
INSERT INTO parent (p, u) VALUES (1, 10), (2, 20);

-- Test 714: statement (line 3115)
INSERT INTO child VALUES (1, 1);

-- Test 715: statement (line 3119)
UPDATE parent SET p = 3 WHERE p = 1;

-- Test 716: statement (line 3122)
UPDATE parent SET p = 3 WHERE p = 2;

-- Test 717: statement (line 3125)
UPDATE parent SET p = 3 WHERE p = 10;

-- Test 718: statement (line 3129)
UPDATE child SET p = 3 WHERE p = 1;

-- Test 719: statement (line 3132)
DELETE FROM child;

-- Test 720: statement (line 3135)
DELETE FROM parent;

-- Test 721: statement (line 3138)
INSERT INTO parent (p, u) VALUES (2, 10), (3, 20);

-- Test 722: statement (line 3141)
INSERT INTO child (c, p) VALUES (200, 2);

-- Test 723: statement (line 3146)
UPDATE parent SET p = p + 1;

-- Test 724: statement (line 3149)
UPDATE parent SET p = p - 1;

-- Test 725: statement (line 3156)
UPDATE parent SET p = p;

-- Test 726: statement (line 3159)
CREATE TABLE self (x INT PRIMARY KEY, y INT NOT NULL REFERENCES self(x));

-- Test 727: statement (line 3162)
INSERT INTO self VALUES (1, 2), (2, 3), (3, 4), (4, 1);

-- Test 728: statement (line 3165)
UPDATE self SET y = 5 WHERE y = 1;

-- Test 729: statement (line 3168)
UPDATE self SET x = 5 WHERE y = 1;

-- Test 730: statement (line 3171)
-- ALTER TABLE self SET (schema_locked=false);

-- Test 731: statement (line 3174)
TRUNCATE self;

-- Test 732: statement (line 3177)
-- ALTER TABLE self RESET (schema_locked);

-- Test 733: statement (line 3180)
INSERT INTO self VALUES (1, 1);

-- Test 734: statement (line 3183)
UPDATE self SET x = 5, y = 5;

-- Test 735: statement (line 3186)
CREATE TABLE two (a int, b int, primary key (a, b));

-- Test 736: statement (line 3189)
INSERT INTO two VALUES (1, 1), (1, 3), (3, 3);

-- Test 737: statement (line 3192)
CREATE TABLE fam (
  a INT,
  b INT,
  c INT,
  d INT,
  e INT,
  FAMILY (a, b, c),
  FAMILY (d, e),
  FOREIGN KEY (c, d) REFERENCES two (a, b)
);

-- Test 738: statement (line 3204)
INSERT INTO fam VALUES (10, 10, 1, 1, 10);

-- Test 739: statement (line 3212)
UPDATE fam SET d = 3;

-- Test 740: statement (line 3215)
UPDATE fam SET c = 3;

-- Test 741: statement (line 3218)
CREATE TABLE match_full (
  a INT,
  b INT,
  FOREIGN KEY (a, b) REFERENCES two (a, b) MATCH FULL
);

-- Test 742: statement (line 3225)
INSERT INTO match_full VALUES (1, 1);

-- Test 743: statement (line 3228)
UPDATE match_full SET a = NULL;

-- Test 744: statement (line 3231)
UPDATE match_full SET a = NULL, b = NULL;

-- Test 745: statement (line 3234)
CREATE TABLE match_simple (
  a INT,
  b INT,
  FOREIGN KEY (a, b) REFERENCES two (a, b) MATCH SIMPLE
);

-- Test 746: statement (line 3241)
INSERT INTO match_simple VALUES (1, 1);

-- Test 747: statement (line 3244)
UPDATE match_simple SET a = NULL;

-- Test 748: statement (line 3251)
CREATE TABLE fam_parent (
  k INT PRIMARY KEY,
  a INT,
  b INT NOT NULL,
  FAMILY (k, a),
  FAMILY (b)
);

-- Test 749: statement (line 3260)
CREATE TABLE fam_child (
  k INT PRIMARY KEY,
  fk INT REFERENCES fam_parent(k)
);

-- Test 750: statement (line 3266)
INSERT INTO fam_parent VALUES (1, 1, 1);

-- Test 751: statement (line 3269)
GRANT ALL ON fam_parent TO testuser;
GRANT ALL ON fam_child TO testuser;

-- Test 752: statement (line 3274)
BEGIN;

-- Test 753: statement (line 3277)
UPDATE fam_parent SET b = b+1 WHERE k = 1;

user testuser;

-- Test 754: statement (line 3288)
INSERT INTO fam_child VALUES (1, 1);

user root;

-- Test 755: statement (line 3293)
COMMIT;

-- Test 756: statement (line 3301)
CREATE TABLE users (
  id INTEGER PRIMARY KEY
);

-- Test 757: statement (line 3306)
CREATE TABLE good_users (
  id INTEGER PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  id2 INTEGER UNIQUE
);

-- Test 758: statement (line 3312)
CREATE SEQUENCE message_seq START 1 INCREMENT 1;

-- Test 759: statement (line 3324)
ALTER TABLE messages ADD FOREIGN KEY (user_id_1) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Test 760: statement (line 3327)
ALTER TABLE messages ADD FOREIGN KEY (user_id_1) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE;

-- Test 761: statement (line 3331)
INSERT INTO users(id) VALUES (1), (2), (3);

-- Test 762: statement (line 3334)
INSERT INTO good_users(id, id2) VALUES (1, 10), (2, 20), (3, 30);

-- Test 763: statement (line 3337)
INSERT INTO messages (user_id_1, user_id_2, text) VALUES
  (1, 2, 'hi jordan'),
  (2, 1, 'hi oliver'),
  (1, 2, 'you are a good user jordan'),
  (1, 3, 'you are a good user too rohan'),
  (3, 1, 'lucy is a good user');

-- Test 764: query (line 3345)
INSERT INTO messages (user_id_1, user_id_2, text) VALUES
  (999, 1, 'you are a bad user');

# Now try and update the user_id.
statement ok
update users set id = id * 10;

# See that it propagates.
query I
SELECT * FROM users ORDER BY id ASC;

-- Test 765: query (line 3361)
SELECT * FROM good_users ORDER BY id ASC;

-- Test 766: query (line 3368)
SELECT user_id_1, user_id_2, text FROM messages ORDER BY message_id ASC;

-- Test 767: statement (line 3378)
DELETE FROM users WHERE id = 30;

-- Test 768: query (line 3382)
SELECT * FROM users ORDER BY id ASC;

-- Test 769: query (line 3388)
SELECT * FROM good_users ORDER BY id ASC;

-- Test 770: query (line 3394)
SELECT user_id_1, user_id_2, text FROM messages ORDER BY message_id ASC;

-- Test 771: statement (line 3403)
ALTER TABLE messages ADD FOREIGN KEY (user_id_1) REFERENCES good_users(id2);

-- Test 772: statement (line 3406)
ALTER TABLE good_users ADD FOREIGN KEY (id2) REFERENCES users(id);

-- Test 773: statement (line 3410)
UPDATE users SET id = id * 100 WHERE id = 20;

-- Test 774: statement (line 3414)
INSERT INTO users VALUES (40);

-- Test 775: statement (line 3417)
INSERT INTO good_users VALUES (40, 40);

-- Test 776: statement (line 3420)
INSERT INTO messages (user_id_1, user_id_2, text) VALUES
  (10, 40, 'oh hi mark'),
  (40, 10, 'youre tearing me apart lisa!');

-- Test 777: query (line 3425)
INSERT INTO messages (user_id_1, user_id_2, text) VALUES
  (999, 40, 'johnny is my best friend');

# And sanity check everything.
query IIT
SELECT user_id_1, user_id_2, text FROM messages ORDER BY message_id ASC;

-- Test 778: statement (line 3440)
DELETE FROM users WHERE id = 20;

-- Test 779: query (line 3443)
SELECT user_id_1, user_id_2, text FROM messages ORDER BY message_id ASC;

-- Test 780: statement (line 3450)
DROP TABLE users CASCADE;

-- Test 781: statement (line 3453)
DROP TABLE good_users CASCADE;

-- Test 782: statement (line 3456)
DROP TABLE messages;

-- Test 783: statement (line 3467)
CREATE TABLE t1 (a INT PRIMARY KEY); CREATE TABLE t2 (a INT DEFAULT 1);

-- Test 784: statement (line 3471)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON DELETE NO ACTION; ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON DELETE SET NULL;

-- Test 785: statement (line 3474)
insert into t1 values (123); insert into t2 values (123);

-- Test 786: statement (line 3477)
DELETE FROM t1 WHERE a = 123;

-- Test 787: query (line 3480)
SELECT * FROM t2;

-- Test 788: statement (line 3485)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 789: statement (line 3488)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 790: statement (line 3491)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 791: statement (line 3494)
TRUNCATE TABLE t2;

-- Test 792: statement (line 3497)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 793: statement (line 3500)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 794: statement (line 3503)
TRUNCATE TABLE t1;

-- Test 795: statement (line 3506)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 796: statement (line 3510)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON DELETE NO ACTION;

-- Test 797: statement (line 3513)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON DELETE CASCADE;

-- Test 798: statement (line 3516)
insert into t1 values (123); insert into t2 values (123);

-- Test 799: statement (line 3519)
DELETE FROM t1 WHERE a = 123;

-- Test 800: query (line 3522)
SELECT * FROM t2;

-- Test 801: statement (line 3526)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 802: statement (line 3529)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 803: statement (line 3532)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 804: statement (line 3535)
TRUNCATE TABLE t2;

-- Test 805: statement (line 3538)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 806: statement (line 3541)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 807: statement (line 3544)
TRUNCATE TABLE t1;

-- Test 808: statement (line 3547)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 809: statement (line 3551)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON DELETE RESTRICT;

-- Test 810: statement (line 3554)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON DELETE SET NULL;

-- Test 811: statement (line 3557)
insert into t1 values (123); insert into t2 values (123);

-- Test 812: statement (line 3560)
DELETE FROM t1 WHERE a = 123;

-- Test 813: query (line 3563)
SELECT * FROM t2;

-- Test 814: statement (line 3568)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 815: statement (line 3571)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 816: statement (line 3574)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 817: statement (line 3577)
TRUNCATE TABLE t2;

-- Test 818: statement (line 3580)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 819: statement (line 3583)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 820: statement (line 3586)
TRUNCATE TABLE t1;

-- Test 821: statement (line 3589)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 822: statement (line 3593)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON DELETE RESTRICT;

-- Test 823: statement (line 3596)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON DELETE CASCADE;

-- Test 824: statement (line 3599)
insert into t1 values (123); insert into t2 values (123);

-- Test 825: statement (line 3602)
DELETE FROM t1 WHERE a = 123;

-- Test 826: query (line 3605)
SELECT * FROM t2;

-- Test 827: statement (line 3609)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 828: statement (line 3612)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 829: statement (line 3615)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 830: statement (line 3618)
TRUNCATE TABLE t2;

-- Test 831: statement (line 3621)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 832: statement (line 3624)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 833: statement (line 3627)
TRUNCATE TABLE t1;

-- Test 834: statement (line 3630)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 835: statement (line 3634)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON DELETE CASCADE;

-- Test 836: statement (line 3637)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON DELETE SET DEFAULT;

-- Test 837: statement (line 3640)
insert into t1 values (123); insert into t2 values (123);

-- Test 838: statement (line 3643)
DELETE FROM t1 WHERE a = 123;

-- Test 839: query (line 3646)
SELECT * FROM t2;

-- Test 840: statement (line 3650)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 841: statement (line 3653)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 842: statement (line 3656)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 843: statement (line 3659)
TRUNCATE TABLE t2;

-- Test 844: statement (line 3662)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 845: statement (line 3665)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 846: statement (line 3668)
TRUNCATE TABLE t1;

-- Test 847: statement (line 3671)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 848: statement (line 3675)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON DELETE CASCADE;

-- Test 849: statement (line 3678)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON DELETE SET NULL;

-- Test 850: statement (line 3681)
insert into t1 values (123); insert into t2 values (123);

-- Test 851: statement (line 3684)
DELETE FROM t1 WHERE a = 123;

-- Test 852: query (line 3687)
SELECT * FROM t2;

-- Test 853: statement (line 3691)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 854: statement (line 3694)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 855: statement (line 3697)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 856: statement (line 3700)
TRUNCATE TABLE t2;

-- Test 857: statement (line 3703)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 858: statement (line 3706)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 859: statement (line 3709)
TRUNCATE TABLE t1;

-- Test 860: statement (line 3712)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 861: statement (line 3716)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON DELETE SET DEFAULT;
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON DELETE CASCADE;

-- Test 862: statement (line 3720)
INSERT INTO t1 VALUES (123);
INSERT INTO t2 VALUES (123);

-- Test 863: statement (line 3724)
DELETE FROM t1 WHERE a = 123;

-- Test 864: query (line 3727)
SELECT * FROM t2;

-- Test 865: statement (line 3732)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 866: statement (line 3735)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 867: statement (line 3738)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 868: statement (line 3741)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 869: statement (line 3744)
TRUNCATE TABLE t2;

-- Test 870: statement (line 3747)
TRUNCATE TABLE t1;

-- Test 871: statement (line 3750)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 872: statement (line 3753)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 873: statement (line 3757)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON DELETE SET DEFAULT;
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON DELETE SET NULL;

-- Test 874: statement (line 3761)
INSERT INTO t1 VALUES (123);
INSERT INTO t2 VALUES (123);

-- Test 875: statement (line 3765)
DELETE FROM t1 WHERE a = 123;

-- Test 876: query (line 3768)
SELECT * FROM t2;

-- Test 877: statement (line 3773)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 878: statement (line 3776)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 879: statement (line 3779)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 880: statement (line 3782)
TRUNCATE TABLE t2;

-- Test 881: statement (line 3785)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 882: statement (line 3788)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 883: statement (line 3791)
TRUNCATE TABLE t1;

-- Test 884: statement (line 3794)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 885: statement (line 3798)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON DELETE SET NULL;

-- Test 886: statement (line 3801)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON DELETE SET DEFAULT;

-- Test 887: statement (line 3804)
insert into t1 values (123); insert into t2 values (123);

-- Test 888: statement (line 3807)
DELETE FROM t1 WHERE a = 123;

-- Test 889: query (line 3810)
SELECT * FROM t2;

-- Test 890: statement (line 3815)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 891: statement (line 3818)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 892: statement (line 3821)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 893: statement (line 3824)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 894: statement (line 3827)
TRUNCATE TABLE t2;

-- Test 895: statement (line 3830)
TRUNCATE TABLE t1;

-- Test 896: statement (line 3833)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 897: statement (line 3836)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 898: statement (line 3839)
DROP TABLE t2 CASCADE;

-- Test 899: statement (line 3842)
DROP TABLE t1 CASCADE;

-- Test 900: statement (line 3849)
CREATE TABLE t1 (a INT PRIMARY KEY);

-- Test 901: statement (line 3852)
CREATE TABLE t2 (a INT DEFAULT 1);

-- Test 902: statement (line 3856)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON UPDATE NO ACTION;

-- Test 903: statement (line 3859)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON UPDATE SET NULL;

-- Test 904: statement (line 3862)
insert into t1 values (123);

-- Test 905: statement (line 3865)
insert into t2 values (123);

-- Test 906: statement (line 3868)
UPDATE t1 SET a = 2 WHERE a = 123;

-- Test 907: query (line 3871)
SELECT * FROM t2;

-- Test 908: statement (line 3876)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 909: statement (line 3879)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 910: statement (line 3882)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 911: statement (line 3885)
TRUNCATE TABLE t2;

-- Test 912: statement (line 3888)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 913: statement (line 3891)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 914: statement (line 3894)
TRUNCATE TABLE t1;

-- Test 915: statement (line 3897)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 916: statement (line 3901)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON UPDATE NO ACTION;

-- Test 917: statement (line 3904)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON UPDATE CASCADE;

-- Test 918: statement (line 3907)
insert into t1 values (123);

-- Test 919: statement (line 3910)
insert into t2 values (123); UPDATE t1 SET a = 2 WHERE a = 123;

-- Test 920: query (line 3913)
SELECT * FROM t2;

-- Test 921: statement (line 3918)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 922: statement (line 3921)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 923: statement (line 3924)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 924: statement (line 3927)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 925: statement (line 3930)
TRUNCATE TABLE t2;

-- Test 926: statement (line 3933)
TRUNCATE TABLE t1;

-- Test 927: statement (line 3936)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 928: statement (line 3939)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 929: statement (line 3943)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON UPDATE RESTRICT;

-- Test 930: statement (line 3946)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON UPDATE SET NULL;

-- Test 931: statement (line 3949)
insert into t1 values (123); insert into t2 values (123);

-- Test 932: statement (line 3952)
UPDATE t1 SET a = 2 WHERE a = 123;

-- Test 933: query (line 3955)
SELECT * FROM t2;

-- Test 934: statement (line 3960)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 935: statement (line 3963)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 936: statement (line 3966)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 937: statement (line 3969)
TRUNCATE TABLE t2;

-- Test 938: statement (line 3972)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 939: statement (line 3975)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 940: statement (line 3978)
TRUNCATE TABLE t1;

-- Test 941: statement (line 3981)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 942: statement (line 3985)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON UPDATE RESTRICT;

-- Test 943: statement (line 3988)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON UPDATE CASCADE;

-- Test 944: statement (line 3991)
insert into t1 values (123); insert into t2 values (123);

-- Test 945: statement (line 3994)
UPDATE t1 SET a = 2 WHERE a = 123;

-- Test 946: query (line 3997)
SELECT * FROM t2;

-- Test 947: statement (line 4002)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 948: statement (line 4005)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 949: statement (line 4008)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 950: statement (line 4011)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 951: statement (line 4014)
TRUNCATE TABLE t2;

-- Test 952: statement (line 4017)
TRUNCATE TABLE t1;

-- Test 953: statement (line 4020)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 954: statement (line 4023)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 955: statement (line 4027)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON UPDATE CASCADE;

-- Test 956: statement (line 4030)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON UPDATE SET DEFAULT;

-- Test 957: statement (line 4033)
insert into t1 values (123); insert into t2 values (123);

-- Test 958: statement (line 4036)
UPDATE t1 SET a = 2 WHERE a = 123;

-- Test 959: query (line 4039)
SELECT * FROM t2;

-- Test 960: statement (line 4044)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 961: statement (line 4047)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 962: statement (line 4051)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 963: statement (line 4054)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 964: statement (line 4057)
TRUNCATE TABLE t2;

-- Test 965: statement (line 4060)
TRUNCATE TABLE t1;

-- Test 966: statement (line 4063)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 967: statement (line 4066)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 968: statement (line 4070)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON UPDATE CASCADE;

-- Test 969: statement (line 4073)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON UPDATE SET NULL;

-- Test 970: statement (line 4076)
insert into t1 values (123); insert into t2 values (123);

-- Test 971: statement (line 4079)
UPDATE t1 SET a = 2 WHERE a = 123;

-- Test 972: query (line 4082)
SELECT * FROM t2;

-- Test 973: statement (line 4087)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 974: statement (line 4090)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 975: statement (line 4094)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 976: statement (line 4097)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 977: statement (line 4100)
TRUNCATE TABLE t2;

-- Test 978: statement (line 4103)
TRUNCATE TABLE t1;

-- Test 979: statement (line 4106)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 980: statement (line 4109)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 981: statement (line 4113)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON UPDATE SET DEFAULT;

-- Test 982: statement (line 4116)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON UPDATE CASCADE;

-- Test 983: statement (line 4119)
insert into t1 values (123); insert into t2 values (123);

-- Test 984: statement (line 4122)
UPDATE t1 SET a = 2 WHERE a = 123;

-- Test 985: query (line 4125)
SELECT * FROM t2;

-- Test 986: statement (line 4130)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 987: statement (line 4133)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 988: statement (line 4137)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 989: statement (line 4140)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 990: statement (line 4143)
TRUNCATE TABLE t2;

-- Test 991: statement (line 4146)
TRUNCATE TABLE t1;

-- Test 992: statement (line 4149)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 993: statement (line 4152)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 994: statement (line 4156)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON UPDATE SET DEFAULT;

-- Test 995: statement (line 4159)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON UPDATE SET NULL;

-- Test 996: statement (line 4162)
insert into t1 values (123); insert into t2 values (123);

-- Test 997: statement (line 4165)
UPDATE t1 SET a = 2 WHERE a = 123;

-- Test 998: query (line 4168)
SELECT * FROM t2;

-- Test 999: statement (line 4173)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 1000: statement (line 4176)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 1001: statement (line 4180)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 1002: statement (line 4183)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 1003: statement (line 4186)
TRUNCATE TABLE t2;

-- Test 1004: statement (line 4189)
TRUNCATE TABLE t1;

-- Test 1005: statement (line 4192)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 1006: statement (line 4195)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 1007: statement (line 4199)
ALTER TABLE t2 ADD CONSTRAINT fk1 FOREIGN KEY (a) REFERENCES t1 ON UPDATE SET NULL;

-- Test 1008: statement (line 4202)
ALTER TABLE t2 ADD CONSTRAINT fk2 FOREIGN KEY (a) REFERENCES t1 ON UPDATE SET DEFAULT;

-- Test 1009: statement (line 4205)
insert into t1 values (123); insert into t2 values (123);

-- Test 1010: statement (line 4208)
UPDATE t1 SET a = 2 WHERE a = 123;

-- Test 1011: query (line 4211)
SELECT * FROM t2;

-- Test 1012: statement (line 4216)
ALTER TABLE t2 DROP CONSTRAINT fk1;

-- Test 1013: statement (line 4219)
ALTER TABLE t2 DROP CONSTRAINT fk2;

-- Test 1014: statement (line 4223)
-- ALTER TABLE t2 SET (schema_locked=false);

-- Test 1015: statement (line 4226)
-- ALTER TABLE t1 SET (schema_locked=false);

-- Test 1016: statement (line 4229)
TRUNCATE TABLE t2;

-- Test 1017: statement (line 4232)
TRUNCATE TABLE t1;

-- Test 1018: statement (line 4235)
-- ALTER TABLE t2 RESET (schema_locked)

-- Test 1019: statement (line 4238)
-- ALTER TABLE t1 RESET (schema_locked)

-- Test 1020: statement (line 4241)
DROP TABLE t2 CASCADE;

-- Test 1021: statement (line 4244)
DROP TABLE t1 CASCADE;

-- Test 1022: statement (line 4249)
CREATE TABLE nonunique_idx_parent (
  k1 INT,
  k2 INT,
  v INT,
  CONSTRAINT "primary" PRIMARY KEY (k1, k2),
  INDEX (k2)
);

-- Test 1023: statement (line 4258)
CREATE TABLE nonunique_idx_child (
  k INT PRIMARY KEY,
  ref1 INT,
  ref2 INT,
  CONSTRAINT "fk" FOREIGN KEY (ref1, ref2) REFERENCES nonunique_idx_parent (k1, k2)
);

-- Test 1024: statement (line 4266)
INSERT INTO nonunique_idx_parent VALUES (1, 10);

-- Test 1025: statement (line 4269)
INSERT INTO nonunique_idx_child VALUES (0, 1, 10);

-- Test 1026: statement (line 4276)
SET enable_multiple_modifications_of_table = true;

-- Test 1027: statement (line 4279)
CREATE TABLE x (
    k INT PRIMARY KEY
);

-- Test 1028: statement (line 4284)
CREATE TABLE y (
    y INT PRIMARY KEY,
    b INT NULL REFERENCES x(k),
    c INT NULL REFERENCES x(k) ON DELETE CASCADE
);

-- Test 1029: statement (line 4291)
WITH
    a AS (INSERT INTO y VALUES (1) RETURNING 1), b AS (DELETE FROM x WHERE true RETURNING 1)
SELECT
    *
FROM
    a;

-- Test 1030: statement (line 4299)
RESET enable_multiple_modifications_of_table;

-- Test 1031: statement (line 4307)
CREATE TABLE add_self_fk_fail (k int primary key, a int unique, b int);

-- Test 1032: statement (line 4310)
INSERT INTO add_self_fk_fail VALUES (1, 2, 3);

-- Test 1033: statement (line 4313)
ALTER TABLE add_self_fk_fail ADD CONSTRAINT self_fk FOREIGN KEY (b) REFERENCES add_self_fk_fail (a);

-- Test 1034: statement (line 4325)
DROP TABLE add_self_fk_fail;

-- Test 1035: statement (line 4333)
-- SET create_table_with_schema_locked=false

-- Test 1036: statement (line 4336)
-- SET CLUSTER SETTING sql.cross_db_fks.enabled = FALSE

-- Test 1037: statement (line 4339)
CREATE DATABASE db1;

-- Test 1038: statement (line 4342)
CREATE DATABASE db2;

-- Test 1039: statement (line 4345)
USE db1;

-- Test 1040: statement (line 4348)
CREATE TABLE parent (p INT PRIMARY KEY);

-- Test 1041: statement (line 4351)
CREATE TABLE child1 (c INT PRIMARY KEY, p INT REFERENCES parent(p));

-- Test 1042: statement (line 4354)
CREATE TABLE child2 (c INT PRIMARY KEY, p INT REFERENCES db1.public.parent(p));

-- Test 1043: statement (line 4357)
CREATE TABLE db1.public.child3 (c INT PRIMARY KEY, p INT REFERENCES db1.public.parent(p));

-- Test 1044: statement (line 4360)
CREATE TABLE db2.public.child (c INT PRIMARY KEY, p INT REFERENCES parent(p));

-- Test 1045: statement (line 4363)
CREATE SCHEMA sc1;

-- Test 1046: statement (line 4367)
CREATE TABLE db1.sc1.child (c INT PRIMARY KEY, p INT REFERENCES db1.public.parent(p));

-- Test 1047: statement (line 4370)
USE db2;

-- Test 1048: statement (line 4373)
CREATE TABLE child (c INT PRIMARY KEY, p INT REFERENCES db1.public.parent(p));

-- Test 1049: statement (line 4376)
CREATE TABLE db2.public.child (c INT PRIMARY KEY, p INT REFERENCES db1.public.parent(p));

-- Test 1050: statement (line 4379)
CREATE TABLE child (c INT PRIMARY KEY, p INT);

-- Test 1051: statement (line 4382)
ALTER TABLE child ADD CONSTRAINT fk FOREIGN KEY (p) REFERENCES db1.public.parent(p);

-- Test 1052: statement (line 4385)
USE db1;

-- Test 1053: statement (line 4388)
ALTER TABLE db2.public.child ADD CONSTRAINT fk FOREIGN KEY (p) REFERENCES parent(p);

-- Test 1054: statement (line 4391)
-- SET CLUSTER SETTING sql.cross_db_fks.enabled = TRUE

-- Test 1055: statement (line 4394)
ALTER TABLE db2.public.child ADD CONSTRAINT fk FOREIGN KEY (p) REFERENCES parent(p);

-- Test 1056: statement (line 4397)
USE db2;

-- Test 1057: statement (line 4400)
CREATE TABLE child2 (c INT PRIMARY KEY, p INT REFERENCES db1.public.parent(p));

-- Test 1058: query (line 4405)
select * from "".crdb_internal.cross_db_references ORDER BY object_name;

-- Test 1059: statement (line 4413)
USE test;

-- Test 1060: statement (line 4416)
-- SET CLUSTER SETTING sql.cross_db_fks.enabled = FALSE

-- Test 1061: statement (line 4427)
CREATE TABLE partial_parent (
  p INT,
  UNIQUE INDEX (p) WHERE p > 100,
  UNIQUE WITHOUT INDEX (p) WHERE p > 0
);

-- Test 1062: statement (line 4434)
CREATE TABLE partial_child (p INT REFERENCES partial_parent (p));

-- Test 1063: statement (line 4440)
CREATE TABLE parent_59582(a INT);
CREATE TABLE child_59582(i INT);

-- Test 1064: statement (line 4444)
ALTER TABLE child_59582 ADD FOREIGN KEY (i) REFERENCES child_59582(rowid);

-- Test 1065: statement (line 4447)
DROP TABLE parent_59582, child_59582;

-- Test 1066: statement (line 4450)
-- RESET create_table_with_schema_locked

-- Test 1067: statement (line 4458)
-- SET enable_insert_fast_path = true

-- Test 1068: statement (line 4461)
CREATE TABLE t65890_p (
  k INT PRIMARY KEY,
  a INT,
  b INT,
  UNIQUE (a),
  UNIQUE INDEX ba_idx (b, a),
  FAMILY (k, a, b)
);

-- Test 1069: statement (line 4471)
CREATE TABLE t65890_c (
  k INT PRIMARY KEY,
  b INT,
  a INT,
  FAMILY (k, b, a)
);

-- Test 1070: statement (line 4479)
ALTER TABLE t65890_c ADD CONSTRAINT fk FOREIGN KEY (a) REFERENCES t65890_p(a);

-- Test 1071: statement (line 4482)
INSERT INTO t65890_c SELECT 1, 1, 1;

-- Test 1072: statement (line 4485)
ALTER TABLE t65890_c DROP CONSTRAINT fk;

-- Test 1073: statement (line 4488)
ALTER TABLE t65890_c ADD CONSTRAINT fk FOREIGN KEY (a, b) REFERENCES t65890_p(a, b);

-- Test 1074: query (line 4493)
SELECT * FROM [
  EXPLAIN INSERT INTO t65890_c (k, b, a) VALUES (1, 2, 3)
] WHERE info !~ '(distribution|vectorized):.*';

-- Test 1075: query (line 4506)
SELECT * FROM [
  EXPLAIN INSERT INTO t65890_c (k, b, a) VALUES (1, 2, 3)
] WHERE info !~ '(distribution|vectorized):.*';

-- Test 1076: statement (line 4520)
INSERT INTO t65890_c (k, b, a) VALUES (1, 2, 3);

-- Test 1077: statement (line 4523)
INSERT INTO t65890_c SELECT 1, 2, 2;

-- Test 1078: statement (line 4526)
-- SET enable_insert_fast_path = $enable_insert_fast_path

-- Test 1079: statement (line 4535)
CREATE TABLE reference_constraint_different_order_parent (
  a INT8 NOT NULL,
  b INT8 NOT NULL,
  c INT8 NOT NULL,
  p_str VARCHAR(10),
  PRIMARY KEY (a, b, c)
);
CREATE TABLE reference_constraint_different_order_child (
  id INT8,
  x INT8,
  y INT8,
  z INT8,
  c_str VARCHAR(10)
);

-- Test 1080: statement (line 4551)
ALTER TABLE reference_constraint_different_order_child
  ADD CONSTRAINT p_fk FOREIGN KEY (x, y, z) REFERENCES reference_constraint_different_order_parent (a, c, b);

-- Test 1081: statement (line 4555)
INSERT
INTO
	reference_constraint_different_order_parent
VALUES (1, 2, 3, 'par_val');
INSERT
INTO reference_constraint_different_order_child
VALUES (99, 1, 3, 2, 'child_val');

-- Test 1082: query (line 4564)
SELECT
	*
FROM
	reference_constraint_different_order_child
	NATURAL JOIN reference_constraint_different_order_parent;

-- Test 1083: statement (line 4574)
INSERT
INTO reference_constraint_different_order_child
VALUES (99, 1, 2, 3, 'child_val');

-- Test 1084: statement (line 4580)
CREATE TABLE t1 (a INT8 PRIMARY KEY);
CREATE TABLE t2 (a INT8 PRIMARY KEY);
CREATE TABLE t3 (a INT8 PRIMARY KEY, b INT8 REFERENCES t1 (a), c INT8 REFERENCES t2 (a));
INSERT INTO t1 VALUES (1);
INSERT INTO t2 VALUES (1);

-- Test 1085: statement (line 4587)
INSERT INTO t3 VALUES (1, 1, 1), (2, 2, NULL);

-- Test 1086: statement (line 4590)
INSERT INTO t3 VALUES (1, 1, 1), (2, NULL, 2);

-- Test 1087: statement (line 4593)
DROP TABLE t3, t1, t2;

-- Test 1088: statement (line 4600)
CREATE DATABASE db_type_test;

-- Test 1089: query (line 4622)
ALTER TABLE db_type_test.public.child_2 ADD CONSTRAINT child_2_fk_parent_id FOREIGN KEY (parent_id) REFERENCES db_type_test.public.parent(id);

-- Test 1090: statement (line 4628)
ALTER TABLE db_type_test.public.child_2 ADD CONSTRAINT child_2_fk_parent_id FOREIGN KEY (parent_id) REFERENCES db_type_test.public.parent(id);

-- Test 1091: statement (line 4631)
DROP DATABASE db_type_test;

-- Test 1092: statement (line 4649)
INSERT INTO p76852 (p, i) VALUES ('foo', 1);
INSERT INTO c76852 (b, p) VALUES (true, 'foo');
DELETE FROM p76852 WHERE true;

-- Test 1093: query (line 4655)
SELECT b FROM c76852@idx WHERE b;

-- Test 1094: statement (line 4659)
INSERT INTO p76852 (p, i) VALUES ('foo', 1);
INSERT INTO c76852 (b, p) VALUES (true, 'foo');
DELETE FROM p76852 WHERE i = 1;

-- Test 1095: query (line 4665)
SELECT b FROM c76852@idx WHERE b;

-- Test 1096: statement (line 4673)
CREATE TABLE drop_fk_during_addition (name INT8);
CREATE TABLE drop_fk_during_addition_ref (name INT8 PRIMARY KEY);

-- skipif config schema-locked-disabled

-- Test 1097: statement (line 4678)
-- ALTER TABLE drop_fk_during_addition SET (schema_locked=false);

-- skipif config schema-locked-disabled

-- Test 1098: statement (line 4682)
-- ALTER TABLE drop_fk_during_addition_ref SET (schema_locked=false);

-- Test 1099: statement (line 4685)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
ALTER TABLE drop_fk_during_addition
	ADD CONSTRAINT fk FOREIGN KEY (name) REFERENCES drop_fk_during_addition_ref (name);
DROP TABLE drop_fk_during_addition_ref;

-- Test 1100: statement (line 4692)
COMMIT;

-- Test 1101: statement (line 4699)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl = false;
CREATE TABLE parent80828 (id int primary key);
CREATE TABLE child80828 (id INT PRIMARY KEY, pid INT NOT NULL REFERENCES parent80828(id) ON DELETE CASCADE, UNIQUE INDEX (pid));
INSERT INTO parent80828 VALUES (1);
INSERT INTO child80828 VALUES (1, 1);
COMMIT;

-- Test 1102: statement (line 4708)
-- SET CLUSTER SETTING jobs.registry.interval.base = .00001;

-- Test 1103: statement (line 4712)
-- SET CLUSTER SETTING jobs.debug.pausepoints = 'schemachanger.before.exec'

-- Test 1104: statement (line 4718)
CREATE TABLE grandchild80828 (parent_id INT NOT NULL REFERENCES child80828(pid) ON DELETE CASCADE);

-- Test 1105: statement (line 4721)
DELETE FROM parent80828 WHERE id = 1;

-- Test 1106: statement (line 4725)
-- RESET CLUSTER SETTING jobs.debug.pausepoints

-- Test 1107: statement (line 4728)
-- RESET CLUSTER SETTING jobs.registry.interval.base

-- Test 1108: query (line 4731)
SELECT count(*) FROM parent80828;

-- Test 1109: query (line 4736)
SELECT count(*) FROM child80828;

-- Test 1110: statement (line 4745)
create table t104546 (a int primary key);
create table t104546_fk_src (a int primary key, b int);

-- Test 1111: statement (line 4749)
alter table t104546 add constraint con foreign key (b) references t104546_fk_src(b);

-- Test 1112: statement (line 4752)
create schema sc1;
create schema sc2;
create table sc1.parent (p int primary key);
create table sc2.child(p int primary key, r int REFERENCES sc1.parent (p));

-- Test 1113: query (line 4758)
SELECT constraint_catalog, constraint_schema, constraint_name, unique_constraint_catalog, unique_constraint_schema, unique_constraint_name
FROM  information_schema.referential_constraints WHERE unique_constraint_schema='sc1';

-- Test 1114: statement (line 4766)
CREATE TABLE t1_fk ( pk INT PRIMARY KEY, col1 CHAR(7), col2 INT4, UNIQUE (col1,col2), FAMILY f1 (pk,col1,col2) );

-- skipif config weak-iso-level-configs

-- Test 1115: query (line 4770)
CREATE TABLE t2_fk ( pk INT PRIMARY KEY, t1_fk_col1 CHAR(8), t1_fk_col2 INT4, col3 INT, FOREIGN KEY (t1_fk_col1,t1_fk_col2) REFERENCES t1_fk(col1, col2), FAMILY f1 (pk,t1_fk_col1,t1_fk_col2) );

-- Test 1116: query (line 4776)
CREATE TABLE t2_fk ( pk INT PRIMARY KEY, t1_fk_col1 CHAR(8), t1_fk_col2 INT4, col3 INT, FOREIGN KEY (t1_fk_col1,t1_fk_col2) REFERENCES t1_fk(col1, col2), FAMILY f1 (pk,t1_fk_col1,t1_fk_col2) );

-- Test 1117: query (line 4785)
ALTER TABLE t2_fk ALTER COLUMN t1_fk_col2 SET DATA TYPE INT8;

-- Test 1118: query (line 4791)
ALTER TABLE t2_fk ALTER COLUMN t1_fk_col2 SET DATA TYPE INT8;

-- Test 1119: query (line 4799)
ALTER TABLE t2_fk ALTER COLUMN t1_fk_col1 SET DATA TYPE CHAR(5);

-- Test 1120: query (line 4805)
ALTER TABLE t2_fk ALTER COLUMN t1_fk_col1 SET DATA TYPE CHAR(5);

-- Test 1121: query (line 4814)
SHOW CREATE TABLE t2_fk;

-- Test 1122: query (line 4828)
SHOW CREATE TABLE t2_fk;

-- Test 1123: statement (line 4841)
DROP TABLE t2_fk;
DROP TABLE t1_fk;
