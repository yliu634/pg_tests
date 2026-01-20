-- PostgreSQL compatible tests from drop_owned_by
-- 126 tests

-- Test 1: statement (line 5)
DROP OWNED BY testuser

-- Test 2: statement (line 8)
CREATE USER testuser2

-- Test 3: statement (line 21)
CREATE TABLE u()

user root

-- Test 4: statement (line 26)
GRANT CREATE ON DATABASE test TO testuser WITH GRANT OPTION

user testuser

-- Test 5: statement (line 31)
CREATE TABLE t(a INT)

-- Test 6: statement (line 34)
CREATE VIEW v AS SELECT 1

-- Test 7: statement (line 37)
CREATE SEQUENCE seq

-- Test 8: statement (line 40)
CREATE TYPE enum AS ENUM('a', 'b')

-- Test 9: query (line 43)
SHOW TABLES FROM public

-- Test 10: query (line 51)
SHOW ENUMS

-- Test 11: statement (line 56)
DROP OWNED BY testuser

-- Test 12: query (line 59)
SHOW TABLES FROM public

-- Test 13: query (line 64)
SELECT * FROM t

query error pgcode 42P01 relation "v" does not exist
SELECT * FROM v

query TTTT
SHOW ENUMS

-- Test 14: statement (line 76)
DROP OWNED BY testuser2

-- Test 15: query (line 79)
SHOW TABLES FROM public

-- Test 16: statement (line 93)
CREATE TABLE t(a INT)

-- Test 17: statement (line 96)
GRANT SELECT ON t TO testuser2 WITH GRANT OPTION

user testuser2

-- Test 18: statement (line 101)
CREATE VIEW v AS SELECT a FROM t

user testuser

-- Test 19: statement (line 106)
DROP OWNED BY testuser

-- Test 20: statement (line 109)
DROP OWNED BY testuser RESTRICT

-- Test 21: query (line 112)
SHOW TABLES FROM public

-- Test 22: statement (line 120)
DROP OWNED BY testuser2 CASCADE

-- Test 23: statement (line 123)
DROP OWNED BY testuser, testuser2

-- Test 24: query (line 126)
SHOW TABLES FROM public

-- Test 25: statement (line 136)
GRANT CREATE ON DATABASE test TO testuser WITH GRANT OPTION

user testuser

-- Test 26: statement (line 141)
CREATE TYPE type AS ENUM ('hello')

-- Test 27: statement (line 144)
GRANT USAGE ON TYPE type TO testuser2

user testuser2

-- Test 28: statement (line 149)
CREATE TABLE t(x type)

user root

-- Test 29: statement (line 154)
DROP OWNED BY testuser

-- Test 30: statement (line 157)
DROP OWNED BY testuser, testuser2

-- Test 31: query (line 160)
SHOW TABLES FROM public

-- Test 32: query (line 164)
SHOW TYPES

-- Test 33: statement (line 174)
GRANT CREATE ON DATABASE test TO testuser WITH GRANT OPTION

user testuser

-- Test 34: statement (line 179)
CREATE TYPE type AS ENUM ('hello')

-- Test 35: statement (line 182)
GRANT USAGE ON TYPE type TO testuser2

user testuser2

-- Test 36: statement (line 187)
CREATE TABLE t(a int)

-- Test 37: statement (line 190)
CREATE VIEW v AS SELECT a, 'hello'::type FROM t

user root

-- Test 38: statement (line 195)
DROP OWNED BY testuser

-- Test 39: statement (line 198)
DROP OWNED BY testuser, testuser2

-- Test 40: query (line 201)
SHOW TABLES FROM public

-- Test 41: query (line 205)
SHOW TYPES

-- Test 42: statement (line 216)
GRANT ALL ON DATABASE test TO testuser WITH GRANT OPTION

user testuser

-- Test 43: statement (line 221)
CREATE SCHEMA s

-- Test 44: statement (line 224)
CREATE TABLE s.t1()

-- Test 45: statement (line 227)
CREATE TABLE s.t2()

-- Test 46: statement (line 230)
DROP OWNED BY testuser

-- Test 47: statement (line 233)
SHOW TABLES FROM s

user root

-- Test 48: query (line 247)
SHOW GRANTS ON DATABASE test

-- Test 49: statement (line 257)
DROP OWNED BY testuser

-- Test 50: query (line 260)
SHOW GRANTS ON DATABASE test

-- Test 51: statement (line 277)
CREATE SCHEMA s

-- Test 52: statement (line 280)
GRANT CREATE ON SCHEMA s TO testuser WITH GRANT OPTION

user testuser

-- Test 53: statement (line 285)
CREATE TABLE s.t()

-- Test 54: statement (line 288)
DROP OWNED BY testuser

-- Test 55: query (line 291)
SHOW GRANTS ON SCHEMA s

-- Test 56: query (line 297)
SHOW TABLES FROM s

-- Test 57: statement (line 303)
DROP SCHEMA s

-- Test 58: statement (line 312)
CREATE TABLE t()

-- Test 59: statement (line 315)
GRANT ALL ON t TO testuser WITH GRANT OPTION

user testuser

-- Test 60: query (line 320)
SHOW GRANTS ON t

-- Test 61: statement (line 327)
DROP OWNED BY testuser

-- Test 62: query (line 330)
SHOW GRANTS ON t

-- Test 63: statement (line 338)
DROP TABLE t

-- Test 64: statement (line 344)
CREATE ROLE r1

-- Test 65: statement (line 347)
CREATE ROLE r2

-- Test 66: statement (line 350)
SET ROLE r1

-- Test 67: statement (line 353)
CREATE TABLE t1()

-- Test 68: statement (line 356)
SET ROLE r2

-- Test 69: statement (line 359)
CREATE TABLE t2()

-- Test 70: statement (line 362)
SET ROLE root

-- Test 71: query (line 365)
SHOW TABLES FROM public

-- Test 72: statement (line 371)
DROP OWNED BY r1, r2

-- Test 73: query (line 374)
SHOW TABLES FROM public

-- Test 74: statement (line 384)
DROP OWNED BY testuser2

-- Test 75: statement (line 387)
DROP OWNED BY testuser, testuser2

-- Test 76: statement (line 390)
DROP OWNED BY root

-- Test 77: statement (line 393)
DROP OWNED BY admin

-- Test 78: statement (line 402)
CREATE DATABASE d1

-- Test 79: statement (line 405)
CREATE DATABASE d2

-- Test 80: statement (line 408)
CREATE DATABASE d3

-- Test 81: statement (line 411)
CREATE DATABASE d4

-- Test 82: statement (line 414)
CREATE SCHEMA d1.s1

-- Test 83: statement (line 417)
CREATE SCHEMA d1.s2

-- Test 84: statement (line 420)
GRANT CREATE, DROP ON DATABASE d1 TO testuser WITH GRANT OPTION

-- Test 85: statement (line 423)
GRANT ALL ON DATABASE d2 TO testuser WITH GRANT OPTION

-- Test 86: statement (line 426)
GRANT CREATE ON DATABASE d3 TO testuser WITH GRANT OPTION

-- Test 87: statement (line 429)
GRANT CREATE ON SCHEMA d1.s1 TO testuser WITH GRANT OPTION

-- Test 88: statement (line 435)
CREATE VIEW d1.v1 AS SELECT k,v FROM d1.t1

-- Test 89: statement (line 438)
CREATE TABLE d1.s1.t1 (a INT)

-- Test 90: statement (line 441)
CREATE SCHEMA d2.s1

user testuser

-- Test 91: statement (line 446)
CREATE SCHEMA d1.s3

-- Test 92: statement (line 449)
CREATE SCHEMA d1.s4

-- Test 93: statement (line 455)
CREATE VIEW d1.v2 AS SELECT k,v FROM d1.t2

-- Test 94: statement (line 458)
CREATE TABLE d1.s1.t2 (a INT)

-- Test 95: statement (line 461)
CREATE SCHEMA d2.s2

-- Test 96: statement (line 464)
CREATE TABLE d2.t1()

user root

-- Test 97: query (line 469)
SHOW DATABASES

-- Test 98: statement (line 481)
SET DATABASE = d1

-- Test 99: query (line 484)
SHOW SCHEMAS FROM d1

-- Test 100: query (line 497)
SHOW TABLES FROM d1

-- Test 101: query (line 507)
SHOW GRANTS ON DATABASE d1

-- Test 102: query (line 516)
SHOW GRANTS ON SCHEMA d1.s1

-- Test 103: statement (line 523)
DROP OWNED BY testuser

-- Test 104: query (line 526)
SHOW SCHEMAS FROM d1

-- Test 105: query (line 537)
SHOW TABLES FROM d1

-- Test 106: query (line 544)
SHOW GRANTS ON SCHEMA d1.s1

-- Test 107: query (line 550)
SHOW GRANTS ON DATABASE d1

-- Test 108: statement (line 557)
SET DATABASE = d2

-- Test 109: query (line 560)
SHOW SCHEMAS FROM d2

-- Test 110: query (line 571)
SHOW TABLES FROM d2

-- Test 111: query (line 576)
SHOW GRANTS ON DATABASE d2

-- Test 112: statement (line 584)
DROP OWNED BY testuser

-- Test 113: query (line 587)
SHOW SCHEMAS FROM d2

-- Test 114: query (line 597)
SHOW TABLES FROM d2

-- Test 115: query (line 601)
SHOW GRANTS ON DATABASE d2

-- Test 116: statement (line 608)
SET DATABASE = d3

-- Test 117: query (line 611)
SHOW GRANTS ON DATABASE d3

-- Test 118: statement (line 619)
DROP OWNED BY testuser

-- Test 119: query (line 622)
SHOW GRANTS ON DATABASE d3

-- Test 120: statement (line 631)
GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser

-- Test 121: statement (line 634)
DROP OWNED BY testuser

-- Test 122: statement (line 639)
CREATE USER u_drop_udf;

-- Test 123: statement (line 642)
CREATE FUNCTION f_drop_udf() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 124: statement (line 645)
ALTER FUNCTION f_drop_udf OWNER TO u_drop_udf;

-- Test 125: statement (line 648)
DROP OWNED BY u_drop_udf;

-- Test 126: statement (line 651)
SHOW CREATE FUNCTION f_drop_udf;

