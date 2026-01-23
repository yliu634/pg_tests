-- PostgreSQL compatible tests from udf_security
-- 63 tests

\set ON_ERROR_STOP 1
SET client_min_messages = warning;

-- Cleanup for repeatability (roles are cluster-scoped).
RESET ROLE;
DROP ROLE IF EXISTS owner2;
DROP ROLE IF EXISTS owner1;
DROP ROLE IF EXISTS secret_role;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS invoker;
DROP ROLE IF EXISTS owner;

-- Test 1: statement (line 3)
CREATE ROLE owner;
CREATE ROLE invoker;
CREATE ROLE testuser;

-- This test file creates functions/tables in the public schema under various roles.
GRANT USAGE, CREATE ON SCHEMA public TO owner, testuser;

CREATE TABLE top_secret_data (id INT PRIMARY KEY);
INSERT INTO top_secret_data VALUES (1), (2);

CREATE TABLE secret_data (id INT PRIMARY KEY);
INSERT INTO secret_data VALUES (10), (20);

CREATE TABLE t (id INT PRIMARY KEY);
INSERT INTO t VALUES (1);

GRANT SELECT ON TABLE top_secret_data TO owner;
GRANT SELECT ON TABLE secret_data TO owner;
GRANT SELECT ON TABLE t TO owner;

-- Test 2: statement (line 12)
SET ROLE owner;

CREATE FUNCTION get_top_secret_data() RETURNS SETOF INT
LANGUAGE SQL SECURITY DEFINER AS $$
  SELECT id FROM top_secret_data ORDER BY id;
$$;

CREATE FUNCTION get_secret_data() RETURNS SETOF INT
LANGUAGE SQL SECURITY DEFINER AS $$
  SELECT id FROM secret_data ORDER BY id;
$$;

CREATE FUNCTION get_t() RETURNS INT
LANGUAGE SQL SECURITY DEFINER AS $$
  SELECT id FROM t ORDER BY id LIMIT 1;
$$;

CREATE FUNCTION get_t_nested() RETURNS INT
LANGUAGE SQL AS $$
  SELECT get_t();
$$;

-- Test 3: statement (line 20)
SET ROLE invoker;

-- Test 4: statement (line 24)
\set ON_ERROR_STOP 0
SELECT * FROM top_secret_data;
\set ON_ERROR_STOP 1

-- Test 5: query (line 27)
SELECT get_top_secret_data();

-- Test 6: statement (line 38)
SET ROLE owner;

-- Test 7: statement (line 41)
ALTER FUNCTION get_top_secret_data() SECURITY INVOKER;

-- Test 8: statement (line 44)
SET ROLE invoker;

-- Test 9: statement (line 47)
\set ON_ERROR_STOP 0
SELECT get_top_secret_data();
\set ON_ERROR_STOP 1

-- Test 10: statement (line 56)
RESET ROLE;

-- Test 11: statement (line 59)
REVOKE SELECT ON TABLE top_secret_data FROM owner;

-- Test 12: statement (line 62)
ALTER FUNCTION get_top_secret_data() SECURITY DEFINER;

-- Test 13: statement (line 65)
SET ROLE invoker;

-- Test 14: statement (line 68)
\set ON_ERROR_STOP 0
SELECT get_top_secret_data();
\set ON_ERROR_STOP 1

-- Test 15: statement (line 75)
RESET ROLE;

-- Test 16: statement (line 89)
REVOKE ALL ON TABLE secret_data FROM owner;

-- Test 17: query (line 92)
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name = 'secret_data' AND grantee = 'owner'
ORDER BY grantee, privilege_type;

-- Test 18: statement (line 98)
RESET ROLE;

-- Test 19: statement (line 101)
ALTER TABLE secret_data OWNER TO testuser;

-- Test 20: query (line 104)
SELECT grantee, privilege_type
FROM information_schema.role_table_grants
WHERE table_name = 'secret_data' AND grantee = 'owner'
ORDER BY grantee, privilege_type;

-- Test 21: statement (line 109)
SET ROLE invoker;

-- Test 22: statement (line 112)
\set ON_ERROR_STOP 0
SELECT get_top_secret_data();
\set ON_ERROR_STOP 1

-- Test 23: statement (line 119)
RESET ROLE;

-- Test 24: statement (line 122)
ALTER FUNCTION get_secret_data() OWNER TO testuser;
GRANT SELECT ON secret_data TO testuser;
SET ROLE invoker;

-- Test 25: query (line 127)
SELECT get_secret_data();

-- Test 26: statement (line 138)
SET ROLE testuser;

-- Test 27: statement (line 141)
REVOKE ALL ON FUNCTION get_secret_data() FROM PUBLIC;
SET ROLE invoker;

-- Test 28: statement (line 145)
\set ON_ERROR_STOP 0
SELECT get_secret_data();
\set ON_ERROR_STOP 1

-- Test 29: statement (line 155)
\set ON_ERROR_STOP 0
CREATE FUNCTION create_secret_role() RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
    CREATE ROLE secret_role;
$$;
\set ON_ERROR_STOP 1

-- Test 30: statement (line 160)
\set ON_ERROR_STOP 0
CREATE OR REPLACE FUNCTION create_secret_role() RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
    SET ROLE testuser;
$$;
\set ON_ERROR_STOP 1

-- Test 31: statement (line 169)
RESET ROLE;

-- Test 32: statement (line 172)
CREATE ROLE owner1;

-- Test 33: statement (line 181)
SET ROLE owner;

-- Test 34: statement (line 189)
SET ROLE owner1;

-- Test 35: statement (line 198)
SET ROLE invoker;

-- Test 36: statement (line 202)
\set ON_ERROR_STOP 0
SELECT * FROM t;
\set ON_ERROR_STOP 1

-- Test 37: query (line 207)
SELECT get_t_nested();

-- Test 38: statement (line 213)
SET ROLE owner;

-- Test 39: statement (line 216)
ALTER FUNCTION get_t() SECURITY INVOKER;

-- Test 40: statement (line 219)
SET ROLE invoker;

-- Test 41: statement (line 223)
\set ON_ERROR_STOP 0
SELECT get_t_nested();
\set ON_ERROR_STOP 1

-- Test 42: statement (line 226)
SET ROLE owner;

-- Test 43: statement (line 229)
ALTER FUNCTION get_t() SECURITY DEFINER;

-- Test 44: statement (line 232)
RESET ROLE;

-- Test 45: statement (line 236)
REVOKE EXECUTE ON FUNCTION get_t() FROM PUBLIC;
GRANT EXECUTE ON FUNCTION get_t() TO invoker;

-- Test 46: statement (line 240)
SET ROLE invoker;

-- Test 47: statement (line 244)
SELECT get_t_nested();

-- Test 48: query (line 247)
SELECT get_t();

-- Test 49: statement (line 252)
RESET ROLE;

-- Test 50: statement (line 255)
GRANT EXECUTE ON FUNCTION get_t() TO owner1;

-- Test 51: statement (line 258)
SET ROLE invoker;

-- Test 52: query (line 263)
SELECT get_t_nested();

-- Test 53: statement (line 270)
RESET ROLE;

-- Test 54: statement (line 273)
CREATE ROLE owner2;
GRANT USAGE, CREATE ON SCHEMA public TO owner2;

-- Test 55: statement (line 276)
ALTER FUNCTION get_t() OWNER TO owner2;

-- Test 56: statement (line 279)
SET ROLE invoker;

-- Test 57: statement (line 282)
\set ON_ERROR_STOP 0
SELECT get_t_nested();
\set ON_ERROR_STOP 1

-- Test 58: statement (line 289)
RESET ROLE;

-- Test 59: statement (line 294)
GRANT SELECT ON TABLE secret_data TO owner, invoker;

-- Test 60: statement (line 297)
ALTER FUNCTION get_secret_data() OWNER TO owner;

-- Test 61: statement (line 300)
GRANT EXECUTE ON FUNCTION get_secret_data() TO invoker;

-- Test 62: statement (line 303)
SET ROLE invoker;

-- Test 63: statement (line 308)
SELECT get_secret_data()
UNION
SELECT id FROM secret_data
ORDER BY 1;

RESET ROLE;
RESET client_min_messages;
