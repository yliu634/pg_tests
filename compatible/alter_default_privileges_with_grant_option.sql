-- PostgreSQL compatible tests from alter_default_privileges_with_grant_option
-- 127 tests

-- Test 1: statement (line 2)
ALTER DEFAULT PRIVILEGES FOR ROLE who GRANT SELECT ON TABLES to testuser WITH GRANT OPTION

-- Test 2: statement (line 5)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES to who WITH GRANT OPTION

-- Test 3: statement (line 8)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES to who WITH GRANT OPTION

-- Test 4: statement (line 11)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser GRANT SELECT ON TABLES to testuser, who WITH GRANT OPTION

-- Test 5: statement (line 15)
ALTER DEFAULT PRIVILEGES GRANT USAGE ON TABLES to testuser WITH GRANT OPTION

-- Test 6: statement (line 18)
GRANT CREATE ON DATABASE test to testuser

-- Test 7: statement (line 21)
CREATE USER testuser2

-- Test 8: statement (line 24)
CREATE USER target

-- Test 9: statement (line 27)
ALTER DEFAULT PRIVILEGES FOR ROLE root GRANT SELECT ON TABLES TO testuser;

-- Test 10: statement (line 30)
CREATE TABLE t1()

-- Test 11: query (line 33)
SHOW GRANTS ON TABLE t1;

-- Test 12: statement (line 43)
SELECT * FROM t1

-- Test 13: statement (line 46)
GRANT SELECT ON TABLE t1 to target WITH GRANT OPTION

user root

-- Test 14: statement (line 51)
ALTER DEFAULT PRIVILEGES GRANT SELECT, INSERT ON TABLES TO testuser WITH GRANT OPTION

-- Test 15: statement (line 54)
CREATE TABLE t2()

user testuser

-- Test 16: query (line 59)
SHOW GRANTS ON TABLE t1;

-- Test 17: query (line 67)
SHOW GRANTS ON TABLE t2;

-- Test 18: statement (line 76)
GRANT SELECT ON TABLE t1 to target WITH GRANT OPTION

-- Test 19: statement (line 79)
GRANT SELECT, INSERT ON TABLE t2 to target WITH GRANT OPTION

user root

-- Test 20: statement (line 84)
ALTER DEFAULT PRIVILEGES GRANT ALL PRIVILEGES ON TABLES TO testuser WITH GRANT OPTION

-- Test 21: statement (line 87)
CREATE TABLE t3()

-- Test 22: query (line 90)
SHOW GRANTS ON TABLE t3;

-- Test 23: statement (line 100)
GRANT INSERT, DELETE on table t3 to target

user root

-- Test 24: statement (line 105)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR INSERT, DELETE ON TABLES FROM testuser

-- Test 25: statement (line 108)
CREATE TABLE t4()

-- Test 26: query (line 111)
SHOW GRANTS ON TABLE t4;

-- Test 27: statement (line 121)
GRANT INSERT, DELETE ON TABLE t4 TO target

user root

-- Test 28: statement (line 126)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLES FROM testuser

-- Test 29: statement (line 129)
CREATE TABLE t5()

-- Test 30: query (line 132)
SHOW GRANTS ON TABLE t5;

-- Test 31: statement (line 142)
GRANT SELECT ON TABLE t5 TO target WITH GRANT OPTION

user root

-- Test 32: statement (line 147)
ALTER DEFAULT PRIVILEGES REVOKE ALL PRIVILEGES ON TABLES FROM testuser

-- Test 33: statement (line 150)
CREATE TABLE t6()

-- Test 34: query (line 153)
SHOW GRANTS ON TABLE t6;

-- Test 35: statement (line 163)
CREATE TABLE t7()

-- Test 36: query (line 167)
SHOW GRANTS ON TABLE t7;

-- Test 37: statement (line 175)
GRANT SELECT ON TABLE t7 TO testuser

-- Test 38: statement (line 178)
ALTER DEFAULT PRIVILEGES GRANT ALL ON TABLES TO testuser WITH GRANT OPTION

-- Test 39: statement (line 181)
CREATE TABLE t8()

-- Test 40: query (line 184)
SHOW GRANTS ON TABLE t8;

-- Test 41: statement (line 192)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser WITH GRANT OPTION

-- Test 42: statement (line 195)
CREATE TABLE t9()

-- Test 43: query (line 198)
SHOW GRANTS ON TABLE t9;

-- Test 44: statement (line 206)
GRANT INSERT, DELETE ON TABLE t9 to testuser

-- Test 45: statement (line 209)
GRANT SELECT ON TABLE t9 to testuser WITH GRANT OPTION

-- Test 46: statement (line 212)
ALTER DEFAULT PRIVILEGES GRANT ALL PRIVILEGES ON TABLES TO testuser WITH GRANT OPTION

-- Test 47: statement (line 215)
CREATE TABLE t10()

-- Test 48: statement (line 218)
GRANT INSERT, DELETE ON TABLE t10 to testuser

-- Test 49: statement (line 221)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR SELECT ON TABLES FROM testuser

-- Test 50: statement (line 224)
CREATE TABLE t11()

-- Test 51: statement (line 227)
GRANT SELECT ON TABLE t11 TO testuser

-- Test 52: statement (line 230)
GRANT INSERT, DELETE ON TABLE t11 TO testuser WITH GRANT OPTION

-- Test 53: statement (line 233)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLES FROM testuser

-- Test 54: statement (line 236)
CREATE TABLE t12()

-- Test 55: query (line 239)
SHOW GRANTS ON TABLE t12;

-- Test 56: statement (line 247)
GRANT INSERT, DELETE ON TABLE t12 TO testuser

-- Test 57: statement (line 250)
ALTER DEFAULT PRIVILEGES REVOKE ALL PRIVILEGES ON TABLES FROM testuser

-- Test 58: statement (line 253)
CREATE TABLE t13()

-- Test 59: query (line 256)
SHOW GRANTS ON TABLE t13

-- Test 60: statement (line 264)
GRANT ALL PRIVILEGES ON TABLE t13 TO testuser

-- Test 61: query (line 267)
SHOW GRANTS ON TABLE t13

-- Test 62: statement (line 279)
ALTER DEFAULT PRIVILEGES GRANT SELECT, INSERT ON TABLES TO testuser2 WITH GRANT OPTION

user root

-- Test 63: statement (line 284)
ALTER DEFAULT PRIVILEGES GRANT ALL PRIVILEGES ON TABLES TO testuser WITH GRANT OPTION

user testuser

-- Test 64: statement (line 289)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR SELECT ON TABLES FROM testuser2

-- Test 65: statement (line 292)
CREATE TABLE t14()

-- Test 66: query (line 297)
SHOW GRANTS ON TABLE t14;

-- Test 67: statement (line 307)
GRANT INSERT, DELETE ON TABLE t12 TO target WITH GRANT OPTION

-- Test 68: statement (line 310)
ALTER DEFAULT PRIVILEGES GRANT ALL PRIVILEGES ON TABLES TO testuser WITH GRANT OPTION

user testuser2

-- Test 69: statement (line 315)
GRANT SELECT ON TABLE t14 TO target

user testuser

-- Test 70: statement (line 320)
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO testuser2 WITH GRANT OPTION

-- Test 71: statement (line 323)
CREATE TABLE t15()

-- Test 72: query (line 326)
SHOW GRANTS ON TABLE t15;

-- Test 73: statement (line 338)
GRANT SELECT ON TABLE t15 TO target WITH GRANT OPTION

-- Test 74: statement (line 341)
GRANT INSERT ON TABLE t15 TO target

user testuser

-- Test 75: statement (line 346)
ALTER DEFAULT PRIVILEGES GRANT ALL PRIVILEGES ON TABLES TO testuser2 WITH GRANT OPTION

-- Test 76: statement (line 349)
CREATE TABLE t16()

-- Test 77: query (line 352)
SHOW GRANTS ON TABLE t16;

-- Test 78: statement (line 363)
GRANT INSERT ON TABLE t16 TO target

user testuser

-- Test 79: statement (line 368)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR SELECT, INSERT ON TABLES FROM testuser2

-- Test 80: statement (line 371)
CREATE TABLE t17()

-- Test 81: query (line 374)
SHOW GRANTS ON TABLE t17;

-- Test 82: statement (line 385)
GRANT SELECT, INSERT ON TABLE t17 TO target

user testuser

-- Test 83: statement (line 390)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLES FROM testuser2

-- Test 84: statement (line 393)
CREATE TABLE t18()

-- Test 85: query (line 396)
SHOW GRANTS ON TABLE t18;

-- Test 86: statement (line 407)
GRANT SELECT ON TABLE t18 TO target

user testuser

-- Test 87: statement (line 412)
ALTER DEFAULT PRIVILEGES REVOKE ALL PRIVILEGES ON TABLES FROM testuser2

-- Test 88: statement (line 415)
CREATE TABLE t19()

-- Test 89: query (line 418)
SHOW GRANTS ON TABLE t19;

-- Test 90: statement (line 429)
ALTER DEFAULT PRIVILEGES GRANT ALL PRIVILEGES ON SCHEMAS TO testuser, testuser2 WITH GRANT OPTION

-- Test 91: statement (line 432)
CREATE SCHEMA s1

-- Test 92: query (line 435)
SHOW GRANTS ON SCHEMA s1

-- Test 93: statement (line 444)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR ALL PRIVILEGES ON SCHEMAS FROM testuser, testuser2

-- Test 94: statement (line 447)
CREATE SCHEMA s2

-- Test 95: query (line 450)
SHOW GRANTS ON SCHEMA s2

-- Test 96: statement (line 461)
GRANT CREATE ON SCHEMA s1 TO target

-- Test 97: statement (line 464)
GRANT ALL PRIVILEGES ON SCHEMA s1 TO target

-- Test 98: statement (line 467)
GRANT CREATE ON SCHEMA s2 TO target

-- Test 99: statement (line 470)
GRANT ALL PRIVILEGES ON SCHEMA s2 TO target

-- Test 100: statement (line 473)
ALTER DEFAULT PRIVILEGES GRANT ALL PRIVILEGES ON TABLES TO testuser WITH GRANT OPTION

-- Test 101: statement (line 476)
CREATE TABLE s1.t1()

-- Test 102: query (line 479)
SHOW GRANTS ON TABLE s1.t1

-- Test 103: statement (line 487)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR ALL PRIVILEGES ON SCHEMAS FROM testuser

-- Test 104: statement (line 490)
CREATE TABLE s1.t2()

-- Test 105: statement (line 494)
GRANT ALL PRIVILEGES ON TABLE s1.t2 TO target

-- Test 106: statement (line 498)
ALTER DEFAULT PRIVILEGES GRANT CREATE ON SEQUENCES TO testuser2 WITH GRANT OPTION

-- Test 107: statement (line 501)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR ALL PRIVILEGES ON SEQUENCES FROM testuser

-- Test 108: statement (line 504)
CREATE SEQUENCE seq1

-- Test 109: query (line 507)
SHOW GRANTS ON seq1

-- Test 110: statement (line 519)
ALTER DEFAULT PRIVILEGES GRANT USAGE ON TYPES TO testuser2 WITH GRANT OPTION

-- Test 111: statement (line 522)
ALTER DEFAULT PRIVILEGES REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TYPES FROM testuser

-- Test 112: statement (line 525)
CREATE TYPE type1 AS ENUM()

-- Test 113: query (line 528)
SHOW GRANTS ON TYPE type1

-- Test 114: statement (line 538)
GRANT ALL PRIVILEGES ON TYPE type1 TO target

-- Test 115: statement (line 541)
GRANT USAGE ON TYPE type1 TO target

user testuser2

-- Test 116: statement (line 546)
GRANT USAGE ON TYPE type1 TO target

-- Test 117: statement (line 552)
ALTER DEFAULT PRIVILEGES REVOKE ALL PRIVILEGES ON TABLES FROM testuser

user testuser2

-- Test 118: statement (line 557)
ALTER DEFAULT PRIVILEGES REVOKE ALL PRIVILEGES ON TABLES FROM testuser2

user root

-- Test 119: statement (line 562)
GRANT testuser, testuser2 TO root;

-- Test 120: statement (line 565)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser, testuser2 GRANT ALL PRIVILEGES ON TABLES TO testuser, testuser2 WITH GRANT OPTION

user testuser

-- Test 121: statement (line 570)
CREATE TABLE t20()

-- Test 122: query (line 574)
SHOW GRANTS ON TABLE t20;

-- Test 123: statement (line 585)
ALTER DEFAULT PRIVILEGES FOR ROLE testuser, testuser2 REVOKE GRANT OPTION FOR ALL PRIVILEGES ON TABLES FROM testuser2

user testuser

-- Test 124: statement (line 590)
CREATE TABLE t21()

-- Test 125: query (line 593)
SHOW GRANTS ON TABLE t21;

-- Test 126: statement (line 604)
GRANT ALL PRIVILEGES ON TABLE t21 TO target

-- Test 127: statement (line 607)
GRANT SELECT, INSERT ON TABLE t21 TO target

