-- PostgreSQL compatible tests from serial
-- 88 tests

-- Test 1: statement (line 3)
CREATE TABLE serial (
  a SERIAL PRIMARY KEY,
  b INT DEFAULT 7,
  c SERIAL,
  UNIQUE INDEX (c),
  FAMILY "primary" (a, b, c)
)

onlyif config schema-locked-disabled

-- Test 2: query (line 13)
SHOW CREATE TABLE serial

-- Test 3: query (line 25)
SHOW CREATE TABLE serial

-- Test 4: statement (line 36)
INSERT INTO serial (a, b) VALUES (1, 2), (DEFAULT, DEFAULT), (DEFAULT, 3)

-- Test 5: statement (line 39)
INSERT INTO serial (b) VALUES (2)

-- Test 6: query (line 42)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM serial

-- Test 7: statement (line 47)
CREATE TABLE s1 (a SERIAL DEFAULT 7)

-- Test 8: statement (line 50)
CREATE TABLE s1 (a SERIAL NULL)

-- Test 9: statement (line 53)
CREATE TABLE smallbig (
  a SMALLSERIAL, b BIGSERIAL, c INT,
  FAMILY "primary" (a, b, c, rowid)
)

-- Test 10: statement (line 59)
INSERT INTO smallbig (c) VALUES (7), (7)

onlyif config schema-locked-disabled

-- Test 11: query (line 63)
SHOW CREATE TABLE smallbig

-- Test 12: query (line 75)
SHOW CREATE TABLE smallbig

-- Test 13: query (line 86)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM smallbig

-- Test 14: statement (line 91)
CREATE TABLE serials (
  a SERIAL2, b SERIAL4, c SERIAL8, d INT,
  FAMILY "primary" (a, b, c, d, rowid)
)

onlyif config schema-locked-disabled

-- Test 15: query (line 98)
SHOW CREATE TABLE serials

-- Test 16: query (line 111)
SHOW CREATE TABLE serials

-- Test 17: statement (line 123)
INSERT INTO serials (d) VALUES (9), (9)

-- Test 18: query (line 126)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM serials

-- Test 19: statement (line 131)
DROP TABLE serials, smallbig, serial

-- Test 20: statement (line 137)
SET serial_normalization = virtual_sequence

-- Test 21: statement (line 141)
CREATE SEQUENCE serial_c_seq; CREATE SEQUENCE serial_c_seq1

-- Test 22: statement (line 144)
CREATE TABLE serial (
  a SERIAL PRIMARY KEY,
  b INT DEFAULT 7,
  c SERIAL,
  UNIQUE INDEX (c),
  FAMILY "primary" (a, b, c)
)

onlyif config schema-locked-disabled

-- Test 23: query (line 154)
SHOW CREATE TABLE serial

-- Test 24: query (line 166)
SHOW CREATE TABLE serial

-- Test 25: query (line 177)
SHOW CREATE SEQUENCE serial_a_seq

-- Test 26: statement (line 182)
INSERT INTO serial (a, b) VALUES (1, 2), (DEFAULT, DEFAULT), (DEFAULT, 3)

-- Test 27: statement (line 185)
INSERT INTO serial (b) VALUES (2)

-- Test 28: query (line 188)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM serial

-- Test 29: statement (line 193)
CREATE TABLE s1 (a SERIAL DEFAULT 7)

-- Test 30: statement (line 196)
CREATE TABLE s1 (a SERIAL NULL)

-- Test 31: statement (line 199)
CREATE TABLE smallbig (
  a SMALLSERIAL, b BIGSERIAL, c INT,
  FAMILY "primary" (a, b, c, rowid)
)

-- Test 32: statement (line 205)
INSERT INTO smallbig (c) VALUES (7), (7)

onlyif config schema-locked-disabled

-- Test 33: query (line 209)
SHOW CREATE TABLE smallbig

-- Test 34: query (line 221)
SHOW CREATE TABLE smallbig

-- Test 35: query (line 232)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM smallbig

-- Test 36: statement (line 237)
CREATE TABLE serials (
  a SERIAL2, b SERIAL4, c SERIAL8, d INT,
  FAMILY "primary" (a, b, c, d, rowid)
)

onlyif config schema-locked-disabled

-- Test 37: query (line 244)
SHOW CREATE TABLE serials

-- Test 38: query (line 257)
SHOW CREATE TABLE serials

-- Test 39: statement (line 269)
INSERT INTO serials (d) VALUES (9), (9)

-- Test 40: query (line 272)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM serials

-- Test 41: statement (line 277)
DROP TABLE serials, smallbig, serial

-- Test 42: statement (line 283)
SET serial_normalization = sql_sequence

-- Test 43: statement (line 286)
CREATE TABLE serial (
  a SERIAL PRIMARY KEY,
  b INT DEFAULT 7,
  c SERIAL,
  UNIQUE INDEX (c),
  FAMILY "primary" (a, b, c)
)

onlyif config schema-locked-disabled

-- Test 44: query (line 296)
SHOW CREATE TABLE serial

-- Test 45: query (line 308)
SHOW CREATE TABLE serial

-- Test 46: query (line 319)
SHOW CREATE SEQUENCE serial_a_seq

-- Test 47: query (line 324)
SELECT pg_get_serial_sequence('serial', 'a'), pg_get_serial_sequence('serial', 'b')

-- Test 48: statement (line 329)
SELECT pg_get_serial_sequence('non_existent_tbl', 'a')

-- Test 49: statement (line 332)
SELECT pg_get_serial_sequence('serial', 'non_existent_col')

-- Test 50: statement (line 335)
create table serial_2 ("capITALS" SERIAL)

-- Test 51: query (line 338)
SELECT pg_get_serial_sequence('serial_2', 'capITALS')

-- Test 52: statement (line 343)
create schema "schema-hyphen"

-- Test 53: statement (line 346)
create table "schema-hyphen"."Serial_3" ("capITALS" SERIAL)

-- Test 54: query (line 349)
SELECT pg_get_serial_sequence('"schema-hyphen"."Serial_3"', 'capITALS')

-- Test 55: statement (line 354)
INSERT INTO serial (a, b) VALUES (0, 2), (DEFAULT, DEFAULT), (DEFAULT, 3)

-- Test 56: statement (line 357)
INSERT INTO serial (b) VALUES (2)

-- Test 57: query (line 360)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM serial

-- Test 58: statement (line 365)
CREATE TABLE "serial_MixedCase" (
  a SERIAL PRIMARY KEY,
  b INT DEFAULT 7,
  c SERIAL,
  UNIQUE INDEX (c),
  FAMILY "primary" (a, b, c)
)

onlyif config schema-locked-disabled

-- Test 59: query (line 375)
SHOW CREATE TABLE "serial_MixedCase"

-- Test 60: query (line 387)
SHOW CREATE TABLE "serial_MixedCase"

-- Test 61: statement (line 398)
CREATE TABLE s1 (a SERIAL DEFAULT 7)

-- Test 62: statement (line 401)
CREATE TABLE s1 (a SERIAL NULL)

-- Test 63: statement (line 404)
CREATE TABLE smallbig (
  a SMALLSERIAL, b BIGSERIAL, c INT,
  FAMILY "primary" (a, b, c, rowid)
)

-- Test 64: statement (line 410)
INSERT INTO smallbig (c) VALUES (7), (7)

onlyif config schema-locked-disabled

-- Test 65: query (line 414)
SHOW CREATE TABLE smallbig

-- Test 66: query (line 426)
SHOW CREATE TABLE smallbig

-- Test 67: query (line 437)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM smallbig

-- Test 68: statement (line 442)
CREATE TABLE serials (
  a SERIAL2, b SERIAL4, c SERIAL8, d INT,
  FAMILY "primary" (a, b, c, d, rowid)
)

onlyif config schema-locked-disabled

-- Test 69: query (line 449)
SHOW CREATE TABLE serials

-- Test 70: query (line 462)
SHOW CREATE TABLE serials

-- Test 71: statement (line 474)
INSERT INTO serials (d) VALUES (9), (9)

-- Test 72: query (line 477)
SELECT count(DISTINCT a), count(DISTINCT b), count(DISTINCT c) FROM serials

-- Test 73: statement (line 482)
DROP TABLE serials, smallbig, serial

-- Test 74: statement (line 489)
SET serial_normalization = sql_sequence_cached

-- Test 75: statement (line 492)
CREATE TABLE serial (
  cached SERIAL
);

-- Test 76: statement (line 497)
INSERT INTO serial (cached) VALUES (DEFAULT);

-- Test 77: query (line 500)
SELECT cached from serial;

-- Test 78: query (line 505)
SELECT pg_get_serial_sequence('serial', 'cached')

-- Test 79: query (line 510)
SELECT last_value from public.serial_cached_seq;

-- Test 80: statement (line 515)
INSERT INTO serial (cached) VALUES (DEFAULT);

-- Test 81: query (line 518)
SELECT cached from serial ORDER BY cached;

-- Test 82: query (line 524)
SELECT last_value from public.serial_cached_seq;

-- Test 83: statement (line 529)
DROP TABLE serial;

-- Test 84: statement (line 536)
SET CLUSTER SETTING sql.defaults.serial_sequences_cache_size = 512;

-- Test 85: statement (line 539)
CREATE TABLE serial (
  cached512 SERIAL
);

-- Test 86: statement (line 544)
INSERT INTO serial (cached512) VALUES (DEFAULT);

-- Test 87: query (line 547)
SELECT last_value from public.serial_cached512_seq;

-- Test 88: statement (line 552)
DROP TABLE serial;

