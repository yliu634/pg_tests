SET client_min_messages = warning;

-- PostgreSQL compatible tests from parallel_stmts_compat
-- 93 tests

-- Test 1: statement (line 8)
DROP TABLE IF EXISTS kv CASCADE;
DROP TABLE IF EXISTS kv CASCADE;
CREATE TABLE kv(;
    k INT PRIMARY KEY,
    v INT CHECK(v < 100)
);

-- Test 2: statement (line 14)
DROP TABLE IF EXISTS fk CASCADE;
DROP TABLE IF EXISTS fk CASCADE;
CREATE TABLE fk(;
    f INT REFERENCES kv
);

-- Test 3: statement (line 22)
INSERT INTO kv VALUES (1, 2) RETURNING NOTHING;

-- Test 4: statement (line 25)
INSERT INTO kv VALUES (1, 2) RETURNING NOTHING;

-- Test 5: statement (line 28)
UPSERT INTO kv VALUES (2, 2) RETURNING NOTHING

-- Test 6: statement (line 31)
UPSERT INTO kv VALUES (2, 500) RETURNING NOTHING

-- Test 7: statement (line 34)
UPDATE kv SET v = k WHERE k = 3 RETURNING NOTHING;

-- Test 8: statement (line 37)
UPDATE kv SET k = 1 WHERE k = 2 RETURNING NOTHING;

-- Test 9: statement (line 40)
DELETE FROM kv WHERE k = 1 RETURNING NOTHING;

-- Test 10: statement (line 43)
INSERT INTO fk VALUES (2);

-- Test 11: statement (line 46)
DELETE FROM kv WHERE k = 2 RETURNING NOTHING;

-- Test 12: statement (line 49)
DELETE FROM fk;

-- Test 13: statement (line 52)
DELETE FROM kv;

-- Test 14: statement (line 58)
BEGIN;

-- Test 15: statement (line 61)
INSERT INTO kv VALUES (1, 2) RETURNING NOTHING;

-- Test 16: statement (line 64)
INSERT INTO kv VALUES (2, 3) RETURNING NOTHING;

-- Test 17: statement (line 67)
INSERT INTO kv VALUES (3, 4) RETURNING NOTHING;

-- Test 18: statement (line 70)
COMMIT;

-- Test 19: query (line 73)
SELECT k, v FROM kv ORDER BY k;

-- Test 20: statement (line 82)
BEGIN;

-- Test 21: statement (line 85)
INSERT INTO kv VALUES (4, 5) RETURNING NOTHING;

-- Test 22: statement (line 88)
INSERT INTO kv VALUES (2, 3) RETURNING NOTHING;

-- Test 23: statement (line 91)
INSERT INTO kv VALUES (5, 6) RETURNING NOTHING;

-- Test 24: statement (line 94)
COMMIT;

-- Test 25: query (line 97)
SHOW TRANSACTION STATUS;

-- Test 26: query (line 102)
SELECT k, v FROM kv ORDER BY k;

-- Test 27: statement (line 112)
BEGIN;

-- Test 28: statement (line 115)
UPSERT INTO kv VALUES (1, 7) RETURNING NOTHING

-- Test 29: statement (line 118)
UPSERT INTO kv VALUES (4, 8) RETURNING NOTHING

-- Test 30: statement (line 121)
UPSERT INTO kv VALUES (3, 9) RETURNING NOTHING

-- Test 31: statement (line 124)
COMMIT;

-- Test 32: query (line 127)
SELECT k, v FROM kv ORDER BY k;

-- Test 33: statement (line 137)
BEGIN;

-- Test 34: statement (line 140)
UPSERT INTO kv VALUES (1, 8) RETURNING NOTHING

-- Test 35: statement (line 143)
UPSERT INTO kv VALUES (4, 500) RETURNING NOTHING

-- Test 36: statement (line 146)
UPSERT INTO kv VALUES (3, 10) RETURNING NOTHING

-- Test 37: statement (line 149)
COMMIT;

-- Test 38: query (line 152)
SELECT k, v FROM kv ORDER BY k;

-- Test 39: statement (line 163)
BEGIN;

-- Test 40: statement (line 166)
UPDATE kv SET v = k WHERE k = 1 RETURNING NOTHING;

-- Test 41: statement (line 169)
UPDATE kv SET v = k WHERE k = 3 RETURNING NOTHING;

-- Test 42: statement (line 172)
UPDATE kv SET v = k WHERE k = 9 RETURNING NOTHING;

-- Test 43: statement (line 175)
COMMIT;

-- Test 44: query (line 178)
SELECT k, v FROM kv ORDER BY k;

-- Test 45: statement (line 188)
BEGIN;

-- Test 46: statement (line 191)
UPDATE kv SET k = 9 WHERE k = 1 RETURNING NOTHING;

-- Test 47: statement (line 194)
UPDATE kv SET k = 3 WHERE k = 2 RETURNING NOTHING;

-- Test 48: statement (line 197)
UPDATE kv SET k = 10 WHERE k = 4 RETURNING NOTHING;

-- Test 49: statement (line 200)
COMMIT;

-- Test 50: query (line 203)
SELECT k, v FROM kv ORDER BY k;

-- Test 51: statement (line 214)
BEGIN;

-- Test 52: statement (line 217)
DELETE FROM kv WHERE k = 1 RETURNING NOTHING;

-- Test 53: statement (line 220)
DELETE FROM kv WHERE k = 5 RETURNING NOTHING;

-- Test 54: statement (line 223)
COMMIT;

-- Test 55: query (line 226)
SELECT k, v FROM kv ORDER BY k;

-- Test 56: statement (line 235)
INSERT INTO fk VALUES (2);

-- Test 57: statement (line 238)
BEGIN;

-- Test 58: statement (line 241)
DELETE FROM kv WHERE k = 1 RETURNING NOTHING;

-- Test 59: statement (line 244)
DELETE FROM kv WHERE k = 2 RETURNING NOTHING;

-- Test 60: statement (line 247)
DELETE FROM kv WHERE k = 3 RETURNING NOTHING;

-- Test 61: statement (line 250)
COMMIT;

-- Test 62: query (line 253)
SELECT k, v FROM kv ORDER BY k;

-- Test 63: statement (line 260)
DELETE FROM fk;

-- Test 64: statement (line 266)
BEGIN;

-- Test 65: statement (line 269)
INSERT INTO kv VALUES (1, 2) RETURNING NOTHING;

-- Test 66: statement (line 272)
INSERT INTO kv VALUES (5, 9);

-- Test 67: query (line 275)
SELECT k, v FROM kv ORDER BY k;

-- Test 68: statement (line 284)
UPSERT INTO kv VALUES (6, 10) RETURNING NOTHING

-- Test 69: statement (line 287)
UPDATE kv SET v = k+1 WHERE k = 3 RETURNING NOTHING;

-- Test 70: query (line 290)
SELECT k, v FROM kv ORDER BY k;

-- Test 71: statement (line 300)
DELETE FROM kv WHERE k = 2 RETURNING NOTHING;

-- Test 72: statement (line 303)
COMMIT;

-- Test 73: query (line 306)
SELECT k, v FROM kv ORDER BY k;

-- Test 74: statement (line 317)
BEGIN;

-- Test 75: statement (line 320)
INSERT INTO kv VALUES (1, 2) RETURNING NOTHING;

-- Test 76: statement (line 323)
INSERT INTO kv VALUES (7, 7);

-- Test 77: statement (line 326)
ROLLBACK;

-- Test 78: query (line 329)
SELECT k, v FROM kv ORDER BY k;

-- Test 79: statement (line 341)
BEGIN;

-- Test 80: statement (line 344)
UPDATE kv SET z = 10 WHERE k = 3 RETURNING NOTHING;

-- Test 81: statement (line 347)
ROLLBACK;

-- Test 82: statement (line 353)
DELETE FROM kv;

-- Test 83: statement (line 356)
PREPARE x AS INSERT INTO kv VALUES ($1, $2) RETURNING NOTHING

-- Test 84: statement (line 359)
BEGIN;

-- Test 85: statement (line 362)
EXECUTE x(1, 2);

-- Test 86: statement (line 365)
EXECUTE x(1, 2);

-- Test 87: statement (line 368)
ROLLBACK;

-- Test 88: statement (line 371)
BEGIN;

-- Test 89: statement (line 374)
EXECUTE x(1, 2);

-- Test 90: statement (line 377)
EXECUTE x(2, 3);

-- Test 91: statement (line 380)
EXECUTE x(3, 4);

-- Test 92: statement (line 383)
COMMIT;

-- Test 93: query (line 386)
SELECT k, v FROM kv ORDER BY k;



RESET client_min_messages;