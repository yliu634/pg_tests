-- PostgreSQL compatible tests from drop_view
-- 51 tests

-- Test 1: statement (line 4)
INSERT INTO a VALUES ('a', '1'), ('b', '2'), ('c', '3')

-- Test 2: statement (line 7)
CREATE VIEW b AS SELECT k,v from a

-- Test 3: statement (line 10)
CREATE VIEW c AS SELECT k,v from b

-- Test 4: query (line 13)
SHOW TABLES FROM test

-- Test 5: statement (line 20)
DROP TABLE a

-- Test 6: statement (line 23)
DROP TABLE b

-- Test 7: statement (line 26)
DROP VIEW b

-- Test 8: statement (line 29)
CREATE VIEW d AS SELECT k,v FROM a

-- Test 9: statement (line 32)
CREATE VIEW diamond AS SELECT count(*) FROM b AS b JOIN d AS d ON b.k = d.k

-- Test 10: statement (line 35)
DROP VIEW d

-- Test 11: statement (line 38)
GRANT ALL ON d TO testuser

-- Test 12: query (line 41)
SHOW TABLES FROM test

-- Test 13: statement (line 52)
DROP VIEW diamond

-- Test 14: statement (line 55)
DROP VIEW d

user root

-- Test 15: statement (line 60)
CREATE VIEW testuser1 AS SELECT k,v FROM a

-- Test 16: statement (line 63)
CREATE VIEW testuser2 AS SELECT k,v FROM testuser1

-- Test 17: statement (line 66)
CREATE VIEW testuser3 AS SELECT k,v FROM testuser2

-- Test 18: statement (line 69)
GRANT ALL ON testuser1 to testuser

-- Test 19: statement (line 72)
GRANT ALL ON testuser2 to testuser

-- Test 20: statement (line 75)
GRANT ALL ON testuser3 to testuser

-- Test 21: query (line 78)
SHOW TABLES FROM test

-- Test 22: statement (line 91)
REVOKE CONNECT ON DATABASE test FROM public

user testuser

-- Test 23: statement (line 96)
DROP VIEW testuser3

-- Test 24: query (line 99)
SHOW TABLES FROM test

-- Test 25: statement (line 106)
DROP VIEW testuser1

-- Test 26: statement (line 109)
DROP VIEW testuser1 RESTRICT

-- Test 27: statement (line 112)
DROP VIEW testuser1 CASCADE

-- Test 28: query (line 115)
SHOW TABLES FROM test

-- Test 29: statement (line 120)
DROP VIEW testuser2

user root

-- Test 30: statement (line 125)
GRANT ALL ON a to testuser

-- Test 31: statement (line 128)
GRANT ALL ON b to testuser

-- Test 32: statement (line 131)
GRANT ALL ON c to testuser

-- Test 33: statement (line 134)
GRANT ALL ON d to testuser

user testuser

-- Test 34: statement (line 139)
DROP TABLE a CASCADE

user root

-- Test 35: statement (line 144)
DROP TABLE a CASCADE

-- Test 36: query (line 147)
SHOW TABLES FROM test

-- Test 37: statement (line 151)
CREATE VIEW x AS VALUES (1, 2), (3, 4)

-- Test 38: statement (line 154)
CREATE VIEW y AS SELECT column1, column2 FROM x

-- Test 39: statement (line 157)
DROP VIEW x

-- Test 40: statement (line 160)
DROP VIEW x, y

-- Test 41: statement (line 163)
CREATE VIEW x AS VALUES (1, 2), (3, 4)

-- Test 42: statement (line 166)
CREATE VIEW y AS SELECT column1, column2 FROM x

-- Test 43: statement (line 169)
DROP VIEW x

-- Test 44: statement (line 172)
DROP VIEW y, x

-- Test 45: statement (line 177)
CREATE DATABASE a

-- Test 46: statement (line 180)
SET DATABASE=a

-- Test 47: statement (line 183)
CREATE TABLE a (a int);

-- Test 48: statement (line 186)
CREATE TABLE b (b int);

-- Test 49: statement (line 189)
CREATE VIEW v AS SELECT a.a, b.b FROM a CROSS JOIN b

-- Test 50: statement (line 192)
CREATE VIEW u AS SELECT a FROM a UNION SELECT a FROM a

-- Test 51: statement (line 195)
DROP DATABASE a CASCADE

