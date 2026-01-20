-- PostgreSQL compatible tests from grant_table
-- 85 tests

-- Test 1: statement (line 3)
CREATE DATABASE a

-- Test 2: statement (line 6)
CREATE USER readwrite

-- Test 3: statement (line 9)
GRANT ALL ON DATABASE a TO readwrite

-- Test 4: query (line 12)
SHOW GRANTS ON DATABASE a

-- Test 5: query (line 24)
WITH grants AS (SHOW GRANTS) SELECT * FROM grants WHERE
  (schema_name <> 'crdb_internal' OR object_name = 'session_variables') ORDER BY database_name, schema_name, object_name,
   object_type, grantee, privilege_type, is_grantable

-- Test 6: query (line 546)
SHOW GRANTS FOR root

-- Test 7: statement (line 750)
SET DATABASE = ''

-- Test 8: query (line 756)
WITH grants AS (SHOW GRANTS) SELECT * FROM grants
 WHERE schema_name NOT IN ('crdb_internal', 'pg_catalog', 'information_schema')
  AND (database_name <> 'system' OR object_name = 'role_options') ORDER BY database_name, schema_name, object_name,
  object_type, grantee, privilege_type, is_grantable

-- Test 9: query (line 804)
WITH grants AS (SHOW GRANTS FOR root) SELECT * FROM grants
WHERE (database_name <> 'system' OR object_name = 'role_options') ORDER BY database_name, schema_name, object_name,
object_type, grantee, privilege_type, is_grantable

-- Test 10: statement (line 1612)
SHOW GRANTS ON a.t

-- Test 11: statement (line 1615)
SHOW GRANTS ON t

-- Test 12: statement (line 1618)
SET DATABASE = a

-- Test 13: statement (line 1621)
SHOW GRANTS ON t

-- Test 14: statement (line 1624)
GRANT ALL ON a.t TO readwrite

-- Test 15: statement (line 1627)
CREATE TABLE t (id INT PRIMARY KEY)

-- Test 16: query (line 1630)
SHOW GRANTS ON t

-- Test 17: query (line 1637)
SHOW GRANTS ON a.t

-- Test 18: statement (line 1644)
CREATE USER "test-user"

-- Test 19: statement (line 1647)
GRANT ALL ON t TO readwrite, "test-user"

-- Test 20: query (line 1650)
SHOW GRANTS ON t

-- Test 21: query (line 1658)
SHOW GRANTS ON t FOR readwrite, "test-user"

-- Test 22: statement (line 1664)
REVOKE INSERT,DELETE ON t FROM "test-user",readwrite

-- Test 23: query (line 1667)
SHOW GRANTS ON t

-- Test 24: query (line 1693)
SHOW GRANTS ON t FOR readwrite, "test-user"

-- Test 25: statement (line 1717)
REVOKE SELECT ON t FROM "test-user"

-- Test 26: query (line 1720)
SHOW GRANTS ON t

-- Test 27: query (line 1745)
SHOW GRANTS ON t FOR readwrite, "test-user"

-- Test 28: statement (line 1768)
REVOKE ALL ON t FROM readwrite,"test-user"

-- Test 29: query (line 1771)
SHOW GRANTS ON t

-- Test 30: query (line 1777)
SHOW GRANTS ON t FOR readwrite, "test-user"

-- Test 31: statement (line 1783)
CREATE VIEW v as SELECT id FROM t

-- Test 32: query (line 1786)
SHOW GRANTS ON v

-- Test 33: query (line 1793)
SHOW GRANTS ON a.v

-- Test 34: statement (line 1800)
GRANT ALL ON v TO readwrite, "test-user"

-- Test 35: query (line 1803)
SHOW GRANTS ON v

-- Test 36: query (line 1811)
SHOW GRANTS ON v FOR readwrite, "test-user"

-- Test 37: statement (line 1817)
REVOKE INSERT,DELETE ON v FROM "test-user",readwrite

-- Test 38: query (line 1820)
SHOW GRANTS ON v

-- Test 39: query (line 1846)
SHOW GRANTS ON v FOR readwrite, "test-user"

-- Test 40: statement (line 1870)
REVOKE SELECT ON v FROM "test-user"

-- Test 41: query (line 1873)
SHOW GRANTS ON v

-- Test 42: query (line 1898)
SHOW GRANTS ON v FOR readwrite, "test-user"

-- Test 43: query (line 1921)
SHOW GRANTS FOR readwrite, "test-user"

-- Test 44: statement (line 1947)
REVOKE ALL ON v FROM readwrite,"test-user"

-- Test 45: query (line 1950)
SHOW GRANTS ON v

-- Test 46: query (line 1956)
SHOW GRANTS ON v FOR readwrite, "test-user"

-- Test 47: query (line 1960)
SHOW GRANTS FOR readwrite, "test-user"

-- Test 48: query (line 1968)
SHOW GRANTS ON DATABASE a

-- Test 49: statement (line 1979)
SET DATABASE = ""

-- Test 50: statement (line 1982)
GRANT ALL ON a.t@xyz TO readwrite

-- Test 51: statement (line 1985)
GRANT ALL ON * TO readwrite

-- Test 52: statement (line 1988)
GRANT ALL ON a.t, a.tt TO readwrite

-- Test 53: statement (line 1992)
GRANT ALL ON DATABASE * TO readwrite

-- Test 54: statement (line 1995)
CREATE DATABASE b

-- Test 55: statement (line 1998)
CREATE TABLE b.t (id INT PRIMARY KEY)

-- Test 56: statement (line 2001)
CREATE TABLE b.t2 (id INT PRIMARY KEY)

-- Test 57: statement (line 2004)
CREATE DATABASE c

-- Test 58: statement (line 2007)
CREATE TABLE c.t (id INT PRIMARY KEY)

-- Test 59: statement (line 2011)
SET DATABASE = "b"

-- Test 60: statement (line 2014)
GRANT ALL ON * TO Vanilli

-- Test 61: statement (line 2017)
CREATE USER Vanilli

-- Test 62: statement (line 2020)
GRANT ALL ON * TO Vanilli

-- Test 63: query (line 2023)
SHOW GRANTS ON *

-- Test 64: statement (line 2036)
CREATE USER Millie

-- Test 65: statement (line 2039)
GRANT ALL ON c.*, b.t TO Millie

-- Test 66: query (line 2042)
SHOW GRANTS ON b.*

-- Test 67: query (line 2054)
SHOW GRANTS ON a.*, b.*

-- Test 68: query (line 2070)
SHOW GRANTS ON c.t

-- Test 69: statement (line 2078)
REVOKE ALL ON *, c.* FROM Vanilli

-- Test 70: query (line 2081)
SHOW GRANTS ON b.*

-- Test 71: statement (line 2091)
CREATE DATABASE empty

-- Test 72: query (line 2094)
SHOW GRANTS ON empty.*

-- Test 73: query (line 2099)
SHOW GRANTS ON empty.*, b.*

-- Test 74: statement (line 2111)
GRANT USAGE ON t TO testuser

-- Test 75: statement (line 2116)
GRANT SELECT ON system.lease TO testuser

-- Test 76: statement (line 2119)
REVOKE SELECT ON system.lease FROM testuser

-- Test 77: statement (line 2124)
GRANT RULE ON t TO testuser

-- Test 78: statement (line 2129)
GRANT SELECT ON TABLE empty.* TO testuser;

-- Test 79: statement (line 2132)
create schema empty.sc

-- Test 80: statement (line 2135)
GRANT SELECT ON TABLE empty.sc.* TO testuser;

-- Test 81: statement (line 2142)
CREATE DATABASE db;
USE db;
CREATE TABLE t (i INT);

-- Test 82: statement (line 2147)
GRANT SELECT ON TABLE t, crdb_internal.tables TO testuser;

-- Test 83: statement (line 2150)
GRANT SELECT ON TABLE crdb_internal.tables, t TO testuser;

-- Test 84: statement (line 2153)
CREATE USER ROACH;
CREATE TABLE table1 (count INT);
CREATE TABLE table2 (count INT);
BEGIN;
GRANT ALL ON table1 TO ROACH;
GRANT ALL ON table2 TO ROACH;
COMMIT;

-- Test 85: query (line 2166)
SHOW GRANTS FOR roach

