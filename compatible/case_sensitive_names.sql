-- PostgreSQL compatible tests from case_sensitive_names
-- 63 tests

-- Test 1: statement (line 3)
CREATE DATABASE D

-- Test 2: statement (line 6)
SHOW TABLES FROM d

-- Test 3: statement (line 9)
SHOW TABLES FROM "D"

-- Test 4: statement (line 12)
CREATE DATABASE "E"

-- Test 5: statement (line 15)
SHOW TABLES FROM e

-- Test 6: statement (line 18)
SHOW TABLES FROM "E"

-- Test 7: statement (line 24)
CREATE TABLE A(x INT) WITH (schema_locked=false)

-- Test 8: statement (line 27)
SHOW COLUMNS FROM "A"

-- Test 9: statement (line 30)
SHOW INDEXES FROM "A"

-- Test 10: statement (line 33)
SHOW CREATE TABLE "A"

-- Test 11: statement (line 36)
SHOW GRANTS ON TABLE "A"

-- Test 12: statement (line 39)
SHOW GRANTS ON TABLE test."A"

-- Test 13: statement (line 42)
SHOW CONSTRAINTS FROM "A"

-- Test 14: statement (line 45)
SELECT * FROM "A"

-- Test 15: statement (line 48)
INSERT INTO "A"(x) VALUES(1)

-- Test 16: statement (line 51)
UPDATE "A" SET x = 42

-- Test 17: statement (line 54)
DELETE FROM "A"

-- Test 18: statement (line 57)
TRUNCATE "A"

-- Test 19: statement (line 60)
DROP TABLE "A"

-- Test 20: statement (line 63)
SHOW COLUMNS FROM a

-- Test 21: statement (line 66)
SHOW INDEXES FROM a

-- Test 22: statement (line 69)
SHOW CREATE TABLE a

-- Test 23: statement (line 72)
SHOW CONSTRAINTS FROM a

-- Test 24: statement (line 75)
SELECT * FROM a

-- Test 25: statement (line 78)
INSERT INTO a(x) VALUES(1)

-- Test 26: statement (line 81)
UPDATE a SET x = 42

-- Test 27: statement (line 84)
DELETE FROM a

-- Test 28: statement (line 87)
TRUNCATE a

-- Test 29: statement (line 90)
DROP TABLE a

-- Test 30: statement (line 96)
CREATE TABLE "B"(x INT) WITH (schema_locked=false)

-- Test 31: statement (line 99)
SHOW COLUMNS FROM B

-- Test 32: statement (line 102)
SHOW INDEXES FROM B

-- Test 33: statement (line 105)
SHOW CREATE TABLE B

-- Test 34: statement (line 108)
SHOW GRANTS ON TABLE B

-- Test 35: statement (line 111)
SHOW GRANTS ON TABLE test.B

-- Test 36: statement (line 114)
SHOW CONSTRAINTS FROM B

-- Test 37: statement (line 117)
SELECT * FROM B

-- Test 38: statement (line 120)
INSERT INTO B(x) VALUES(1)

-- Test 39: statement (line 123)
UPDATE B SET x = 42

-- Test 40: statement (line 126)
DELETE FROM B

-- Test 41: statement (line 129)
TRUNCATE B

-- Test 42: statement (line 132)
DROP TABLE B

-- Test 43: statement (line 135)
SHOW COLUMNS FROM "B"

-- Test 44: statement (line 138)
SHOW INDEXES FROM "B"

-- Test 45: statement (line 141)
SHOW CREATE TABLE "B"

-- Test 46: statement (line 144)
SHOW GRANTS ON TABLE "B"

-- Test 47: statement (line 147)
SHOW GRANTS ON TABLE test."B"

-- Test 48: statement (line 150)
SHOW CONSTRAINTS FROM "B"

-- Test 49: statement (line 153)
SELECT * FROM "B"

-- Test 50: statement (line 156)
INSERT INTO "B"(x) VALUES(1)

-- Test 51: statement (line 159)
UPDATE "B" SET x = 42

-- Test 52: statement (line 162)
DELETE FROM "B"

-- Test 53: statement (line 165)
TRUNCATE "B"

-- Test 54: statement (line 168)
DROP TABLE "B"

-- Test 55: statement (line 173)
CREATE TABLE foo(X INT, "Y" INT)

-- Test 56: query (line 176)
SELECT x, X, "Y" FROM foo

-- Test 57: statement (line 181)
SELECT "X" FROM foo

-- Test 58: statement (line 184)
SELECT Y FROM foo

-- Test 59: query (line 188)
SELECT Y, "Y" FROM (SELECT x as y, "Y" FROM foo)

-- Test 60: statement (line 195)
CREATE VIEW XV AS SELECT X, "Y" FROM foo

-- Test 61: query (line 198)
SHOW CREATE VIEW xv

-- Test 62: query (line 206)
SHOW CREATE VIEW "XV"

statement ok
CREATE VIEW "YV" AS SELECT X, "Y" FROM foo

query TT
SHOW CREATE VIEW "YV"

-- Test 63: query (line 220)
SHOW CREATE VIEW YV

# Case sensitivity of index names.

statement ok
CREATE TABLE a(x INT, y INT, CONSTRAINT Foo PRIMARY KEY(x)); CREATE INDEX I ON a(y)

statement error index "I" not found
SELECT * FROM a@"I"

statement error index "Foo" not found
SELECT * FROM a@"Foo"

statement error index "I" not found
SELECT * FROM a ORDER BY INDEX a@"I"

statement error index "Foo" not found
SELECT * FROM a ORDER BY INDEX a@"Foo"

statement error index "I" does not exist
DROP INDEX a@"I"

statement ok
SELECT * FROM a@I

statement ok
SELECT * FROM a@Foo

statement ok
SELECT * FROM a ORDER BY INDEX a@I

statement ok
SELECT * FROM a ORDER BY INDEX a@Foo

statement ok
DROP INDEX a@I

# Unicode sequences are preserved.

# Check that normalization occurs
statement error duplicate column name: "Amélie"
CREATE TABLE Amelie("Amélie" INT, "Amélie" INT); INSERT INTO Amelie VALUES (1, 2)

# Check that function names are also recognized case-insensitively.
query I
SELECT LENGTH('abc') -- lint: uppercase function OK

