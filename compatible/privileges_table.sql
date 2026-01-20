-- PostgreSQL compatible tests from privileges_table
-- 105 tests

-- Test 1: statement (line 3)
CREATE DATABASE a

-- Test 2: statement (line 6)
SET DATABASE = a

-- Test 3: statement (line 9)
CREATE TABLE t (k INT PRIMARY KEY, v int)

let $t_id
SELECT id FROM system.namespace WHERE name = 't'

-- Test 4: statement (line 15)
SELECT * from [$t_id as num_ref]

-- Test 5: statement (line 18)
SHOW GRANTS ON t

-- Test 6: statement (line 21)
CREATE USER bar

-- Test 7: statement (line 24)
GRANT ALL ON t TO bar WITH GRANT OPTION

-- Test 8: statement (line 27)
REVOKE ALL ON t FROM bar

-- Test 9: statement (line 30)
INSERT INTO t VALUES (1, 1), (2, 2)

-- Test 10: statement (line 33)
SELECT * from t

-- Test 11: statement (line 36)
DELETE FROM t

-- Test 12: statement (line 39)
DELETE FROM t where k = 1

-- Test 13: statement (line 42)
UPDATE t SET v = 0

-- Test 14: statement (line 45)
UPDATE t SET v = 2 WHERE k = 2

-- Test 15: statement (line 48)
ALTER TABLE t SET (schema_locked=false)

-- Test 16: statement (line 51)
TRUNCATE t

-- Test 17: statement (line 54)
ALTER TABLE t RESET (schema_locked)

-- Test 18: statement (line 57)
DROP TABLE t

-- Test 19: statement (line 60)
CREATE TABLE t (k INT PRIMARY KEY, v int)

let $t_id
SELECT id FROM system.namespace WHERE name = 't'

-- Test 20: statement (line 70)
SET DATABASE = a

-- Test 21: statement (line 73)
SHOW GRANTS ON t

-- Test 22: statement (line 76)
SHOW COLUMNS FROM t

-- Test 23: statement (line 79)
SELECT r FROM t

-- Test 24: statement (line 82)
SELECT * from [$t_id as num_ref]

-- Test 25: statement (line 85)
GRANT ALL ON t TO bar

-- Test 26: statement (line 88)
REVOKE ALL ON t FROM bar

-- Test 27: statement (line 91)
INSERT INTO t VALUES (1, 1), (2, 2)

-- Test 28: statement (line 94)
SELECT * FROM t

-- Test 29: statement (line 97)
SELECT 1

-- Test 30: statement (line 100)
DELETE FROM t

-- Test 31: statement (line 103)
DELETE FROM t where k = 1

-- Test 32: statement (line 106)
UPDATE t SET v = 0

-- Test 33: statement (line 109)
UPDATE t SET v = 2 WHERE k = 2

-- Test 34: statement (line 112)
TRUNCATE t

-- Test 35: statement (line 115)
DROP TABLE t

-- Test 36: statement (line 121)
GRANT SELECT ON t TO testuser WITH GRANT OPTION

user testuser

-- Test 37: query (line 126)
SHOW COLUMNS FROM t

-- Test 38: statement (line 132)
GRANT ALL ON t TO bar

-- Test 39: statement (line 135)
REVOKE ALL ON t FROM bar

-- Test 40: statement (line 138)
INSERT INTO t VALUES (1, 1), (2, 2)

-- Test 41: statement (line 141)
UPSERT INTO t VALUES (1, 1), (2, 2)

-- Test 42: statement (line 144)
SELECT * FROM t

-- Test 43: statement (line 147)
SELECT 1

-- Test 44: statement (line 150)
DELETE FROM t

-- Test 45: statement (line 153)
DELETE FROM t where k = 1

-- Test 46: statement (line 156)
UPDATE t SET v = 0

-- Test 47: statement (line 159)
UPDATE t SET v = 2 WHERE k = 2

-- Test 48: statement (line 162)
TRUNCATE t

-- Test 49: statement (line 165)
DROP TABLE t

-- Test 50: statement (line 171)
GRANT ALL ON t TO testuser WITH GRANT OPTION

-- Test 51: statement (line 174)
REVOKE SELECT ON t FROM testuser

user testuser

-- Test 52: statement (line 179)
GRANT INSERT ON t TO bar WITH GRANT OPTION

-- Test 53: statement (line 182)
REVOKE INSERT ON t FROM bar

-- Test 54: statement (line 185)
GRANT ALL ON t TO bar

-- Test 55: statement (line 188)
GRANT SELECT ON t TO bar

-- Test 56: statement (line 191)
INSERT INTO t VALUES (1, 1), (2, 2)

-- Test 57: statement (line 194)
SELECT * FROM t

-- Test 58: statement (line 197)
SELECT 1

-- Test 59: statement (line 200)
DELETE FROM t

-- Test 60: statement (line 203)
DELETE FROM t where k = 1

-- Test 61: statement (line 206)
UPDATE t SET v = 0

-- Test 62: statement (line 209)
UPDATE t SET v = 2 WHERE k = 2

-- Test 63: statement (line 212)
ALTER TABLE t SET (schema_locked=false)

-- Test 64: statement (line 215)
TRUNCATE t

-- Test 65: statement (line 218)
ALTER TABLE t RESET (schema_locked)

-- Test 66: statement (line 221)
DROP TABLE t

-- Test 67: statement (line 227)
CREATE TABLE t (k INT PRIMARY KEY, v int)

-- Test 68: statement (line 230)
GRANT ALL ON t TO testuser WITH GRANT OPTION

user testuser

-- Test 69: statement (line 235)
GRANT ALL ON t TO bar WITH GRANT OPTION

-- Test 70: statement (line 238)
REVOKE ALL ON t FROM bar

-- Test 71: statement (line 241)
INSERT INTO t VALUES (1, 1), (2, 2)

-- Test 72: statement (line 244)
SELECT * FROM t

-- Test 73: statement (line 247)
SELECT 1

-- Test 74: statement (line 250)
DELETE FROM t

-- Test 75: statement (line 253)
DELETE FROM t where k = 1

-- Test 76: statement (line 256)
UPDATE t SET v = 0

-- Test 77: statement (line 259)
UPDATE t SET v = 2 WHERE k = 2

-- Test 78: statement (line 262)
ALTER TABLE t SET (schema_locked=false)

-- Test 79: statement (line 265)
TRUNCATE t

-- Test 80: statement (line 268)
ALTER TABLE t RESET (schema_locked)

-- Test 81: statement (line 271)
DROP TABLE t

-- Test 82: statement (line 277)
CREATE TABLE t (k INT PRIMARY KEY, v int)

-- Test 83: statement (line 280)
GRANT INSERT ON t TO testuser WITH GRANT OPTION

user testuser

-- Test 84: statement (line 285)
INSERT INTO t VALUES (1, 2)

-- Test 85: statement (line 288)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO NOTHING

-- Test 86: statement (line 291)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO UPDATE SET v = excluded.v

-- Test 87: statement (line 294)
UPSERT INTO t VALUES (1, 2)

user root

-- Test 88: statement (line 299)
GRANT SELECT ON t TO testuser WITH GRANT OPTION

user testuser

-- Test 89: statement (line 304)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO NOTHING

-- Test 90: statement (line 307)
UPSERT INTO t VALUES (1, 2)

-- Test 91: statement (line 310)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO UPDATE SET v = excluded.v

-- Test 92: statement (line 316)
GRANT UPDATE ON t TO testuser WITH GRANT OPTION

user testuser

-- Test 93: statement (line 321)
UPSERT INTO t VALUES (1, 2)

-- Test 94: statement (line 324)
INSERT INTO t VALUES (1, 2) ON CONFLICT (k) DO UPDATE SET v = excluded.v

user root

-- Test 95: statement (line 329)
DROP TABLE t

-- Test 96: statement (line 334)
CREATE TABLE t (k INT PRIMARY KEY, v int)

user testuser

-- Test 97: statement (line 339)
SHOW COLUMNS FROM t

-- Test 98: statement (line 342)
SHOW CREATE TABLE t

-- Test 99: statement (line 345)
SHOW INDEX FROM t

-- Test 100: statement (line 348)
SHOW CONSTRAINTS FROM t

user root

-- Test 101: statement (line 353)
GRANT SELECT ON t TO testuser WITH GRANT OPTION

user testuser

-- Test 102: statement (line 358)
SHOW COLUMNS FROM t

-- Test 103: statement (line 361)
SHOW CREATE TABLE t

-- Test 104: statement (line 364)
SHOW INDEX FROM t

-- Test 105: statement (line 367)
SHOW CONSTRAINTS FROM t

