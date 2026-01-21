-- PostgreSQL compatible tests from grant_inherited
-- 41 tests

SET client_min_messages = warning;

-- Roles are cluster-scoped in PostgreSQL; make the test re-runnable.
DROP ROLE IF EXISTS alice;
DROP ROLE IF EXISTS bob;
DROP ROLE IF EXISTS chuck;
DROP ROLE IF EXISTS dave;
DROP ROLE IF EXISTS meeter;
DROP ROLE IF EXISTS greeter;
DROP ROLE IF EXISTS granter;
DROP ROLE IF EXISTS parent;
DROP ROLE IF EXISTS child;

-- Test 1: statement (line 3)
CREATE USER alice;

-- Test 2: statement (line 6)
CREATE USER bob;

-- Test 3: statement (line 9)
CREATE USER chuck;

-- Test 4: statement (line 12)
CREATE USER dave;

-- Test 5: statement (line 15)
CREATE ROLE meeter;

-- Test 6: statement (line 18)
CREATE ROLE greeter;

-- Test 7: statement (line 21)
CREATE ROLE granter;

-- Test 8: statement (line 24)
GRANT granter TO alice, bob, chuck, dave;

-- Test 9: statement (line 27)
GRANT meeter TO granter;

-- Test 10: statement (line 30)
GRANT greeter TO alice WITH ADMIN OPTION;

-- Test 11: query (line 33)
-- CRDB's kv_inherited_role_members doesn't exist in PG; show the transitive
-- closure of role grants for the roles created in this test.
WITH RECURSIVE r AS (
  SELECT oid FROM pg_roles
  WHERE rolname IN ('alice', 'bob', 'chuck', 'dave', 'meeter', 'greeter', 'granter', 'parent', 'child')
),
inh(roleid, member, admin_option) AS (
  SELECT roleid, member, admin_option
  FROM pg_auth_members
  WHERE roleid IN (SELECT oid FROM r) AND member IN (SELECT oid FROM r)
  UNION
  SELECT inh.roleid, m.member, (inh.admin_option OR m.admin_option)
  FROM inh
  JOIN pg_auth_members m ON m.roleid = inh.member
  WHERE m.roleid IN (SELECT oid FROM r) AND m.member IN (SELECT oid FROM r)
),
collapsed AS (
  SELECT roleid, member, bool_or(admin_option) AS admin_option
  FROM inh
  GROUP BY roleid, member
)
SELECT roleid::regrole AS role, member::regrole AS member, admin_option
FROM collapsed
ORDER BY role, member;

-- Test 12: query (line 49)
SELECT roleid::regrole AS role, member::regrole AS member, admin_option
FROM pg_auth_members
WHERE roleid::regrole::text IN ('meeter', 'greeter', 'granter')
ORDER BY role, member;

-- Test 13: statement (line 61)
SELECT current_database() AS db \gset
GRANT ALL ON DATABASE :"db" TO meeter WITH GRANT OPTION;

-- Test 14: query (line 64)
SELECT
  has_database_privilege('alice', current_database(), 'CONNECT') AS alice_connect,
  has_database_privilege('alice', current_database(), 'CONNECT WITH GRANT OPTION') AS alice_connect_go,
  has_database_privilege('alice', current_database(), 'CREATE') AS alice_create,
  has_database_privilege('alice', current_database(), 'CREATE WITH GRANT OPTION') AS alice_create_go,
  has_database_privilege('alice', current_database(), 'TEMP') AS alice_temp,
  has_database_privilege('alice', current_database(), 'TEMP WITH GRANT OPTION') AS alice_temp_go;

-- Test 15: statement (line 71)
CREATE SCHEMA sc;

-- Test 16: statement (line 74)
GRANT ALL ON SCHEMA sc TO meeter WITH GRANT OPTION;

-- Test 17: query (line 77)
SELECT
  has_schema_privilege('alice', 'sc', 'USAGE') AS alice_usage_sc,
  has_schema_privilege('alice', 'sc', 'USAGE WITH GRANT OPTION') AS alice_usage_sc_go,
  has_schema_privilege('alice', 'sc', 'CREATE') AS alice_create_sc,
  has_schema_privilege('alice', 'sc', 'CREATE WITH GRANT OPTION') AS alice_create_sc_go;

-- Test 18: statement (line 83)
CREATE SEQUENCE sq;

-- Test 19: statement (line 86)
GRANT ALL ON SEQUENCE sq TO meeter WITH GRANT OPTION;

-- Test 20: query (line 89)
SELECT
  has_sequence_privilege('alice', 'sq', 'USAGE') AS alice_usage_sq,
  has_sequence_privilege('alice', 'sq', 'USAGE WITH GRANT OPTION') AS alice_usage_sq_go,
  has_sequence_privilege('alice', 'sq', 'SELECT') AS alice_select_sq,
  has_sequence_privilege('alice', 'sq', 'SELECT WITH GRANT OPTION') AS alice_select_sq_go;

-- Test 21: statement (line 95)
CREATE TABLE tbl (i INT PRIMARY KEY);

-- Test 22: statement (line 98)
GRANT ALL ON TABLE tbl TO meeter WITH GRANT OPTION;

-- Test 23: query (line 101)
SELECT
  has_table_privilege('alice', 'tbl', 'SELECT') AS alice_select_tbl,
  has_table_privilege('alice', 'tbl', 'SELECT WITH GRANT OPTION') AS alice_select_tbl_go,
  has_table_privilege('alice', 'tbl', 'INSERT') AS alice_insert_tbl,
  has_table_privilege('alice', 'tbl', 'INSERT WITH GRANT OPTION') AS alice_insert_tbl_go;

-- Test 24: statement (line 107)
CREATE TYPE typ AS ENUM ('a', 'b');

-- Test 25: statement (line 110)
GRANT ALL ON TYPE typ TO meeter WITH GRANT OPTION;

-- Test 26: query (line 113)
SELECT
  has_type_privilege('alice', 'typ', 'USAGE') AS alice_usage_typ,
  has_type_privilege('alice', 'typ', 'USAGE WITH GRANT OPTION') AS alice_usage_typ_go;

-- Test 27: statement (line 120)
CREATE FUNCTION fn(IN x INT)
	RETURNS INT
	STABLE
	LANGUAGE SQL
	AS $$
SELECT x + 1;
$$;

-- Test 28: statement (line 129)
GRANT EXECUTE ON FUNCTION fn TO meeter WITH GRANT OPTION;

-- Test 29: query (line 132)
SELECT
  has_function_privilege('alice', 'fn(int)'::regprocedure, 'EXECUTE') AS alice_exec_fn,
  has_function_privilege('alice', 'fn(int)'::regprocedure, 'EXECUTE WITH GRANT OPTION') AS alice_exec_fn_go;

-- Test 30: statement (line 139)
-- CRDB-only object type (no direct PostgreSQL equivalent).
-- CREATE EXTERNAL CONNECTION conn AS 'nodelocal://1/foo';

-- Test 31: statement (line 142)
-- GRANT ALL ON EXTERNAL CONNECTION conn TO meeter WITH GRANT OPTION;

-- Test 32: query (line 145)
-- SHOW GRANTS ON EXTERNAL CONNECTION conn FOR alice

-- Test 33: statement (line 151)
-- PostgreSQL does not have CRDB-style system privileges.
-- GRANT SYSTEM ALL TO meeter WITH GRANT OPTION;

-- Test 34: query (line 154)
-- SHOW SYSTEM GRANTS FOR alice

-- Test 35: statement (line 163)
CREATE ROLE parent;

-- Test 36: statement (line 166)
CREATE ROLE child;

-- Test 37: statement (line 169)
GRANT parent TO child;

-- Test 38: statement (line 172)
CREATE SCHEMA test_schema;

-- Test 39: statement (line 175)
GRANT USAGE ON SCHEMA test_schema TO public;

-- Test 40: statement (line 178)
GRANT CREATE ON SCHEMA test_schema TO parent;

-- Test 41: query (line 181)
SELECT
  has_schema_privilege('child', 'test_schema', 'CREATE') AS child_create_test_schema,
  has_schema_privilege('child', 'test_schema', 'CREATE WITH GRANT OPTION') AS child_create_test_schema_go;

RESET client_min_messages;
