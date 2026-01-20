-- PostgreSQL compatible tests from udf_security
-- 63 tests

-- Test 1: statement (line 3)
CREATE ROLE owner;
CREATE ROLE invoker;

-- Test 2: statement (line 12)
SET ROLE owner;

-- Test 3: statement (line 20)
SET ROLE invoker;

-- Test 4: statement (line 24)
SELECT * FROM top_secret_data;

-- Test 5: query (line 27)
SELECT get_top_secret_data();

-- Test 6: statement (line 38)
SET ROLE owner;

-- Test 7: statement (line 41)
ALTER FUNCTION get_top_secret_data() SECURITY INVOKER;

-- Test 8: statement (line 44)
SET ROLE invoker;

-- Test 9: statement (line 47)
SELECT get_top_secret_data();

-- Test 10: statement (line 56)
SET ROLE root;

-- Test 11: statement (line 59)
REVOKE SELECT ON TABLE top_secret_data FROM owner;

-- Test 12: statement (line 62)
ALTER FUNCTION get_top_secret_data() SECURITY DEFINER;

-- Test 13: statement (line 65)
SET ROLE invoker;

-- Test 14: statement (line 68)
SELECT get_top_secret_data();

-- Test 15: statement (line 75)
SET ROLE owner;

-- Test 16: statement (line 89)
REVOKE ALL ON TABLE secret_data FROM owner;

-- Test 17: query (line 92)
SELECT * FROM [SHOW GRANTS ON TABLE secret_data] WHERE grantee = 'owner';

-- Test 18: statement (line 98)
SET ROLE root;

-- Test 19: statement (line 101)
ALTER TABLE secret_data OWNER TO testuser;

-- Test 20: query (line 104)
SELECT * FROM [SHOW GRANTS ON TABLE secret_data] WHERE grantee = 'owner';

-- Test 21: statement (line 109)
SET ROLE invoker;

-- Test 22: statement (line 112)
SELECT get_top_secret_data();

-- Test 23: statement (line 119)
SET ROLE root;

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
SELECT get_secret_data();

-- Test 29: statement (line 155)
CREATE FUNCTION create_secret_role() RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
    CREATE ROLE secret_role;
$$;

-- Test 30: statement (line 160)
CREATE FUNCTION create_secret_role() RETURNS VOID LANGUAGE SQL SECURITY DEFINER AS $$
    SET ROLE testuser;
$$;

-- Test 31: statement (line 169)
SET ROLE root;

-- Test 32: statement (line 172)
CREATE ROLE owner1;

-- Test 33: statement (line 181)
SET ROLE owner;

-- Test 34: statement (line 189)
SET ROLE owner1;

-- Test 35: statement (line 198)
SET ROLE invoker;

-- Test 36: statement (line 202)
SELECT * FROM t;

-- Test 37: query (line 207)
SELECT get_t_nested();

-- Test 38: statement (line 213)
SET ROLE owner;

-- Test 39: statement (line 216)
ALTER FUNCTION get_t() SECURITY INVOKER;

-- Test 40: statement (line 219)
SET ROLE invoker;

-- Test 41: statement (line 223)
SELECT get_t_nested();

-- Test 42: statement (line 226)
SET ROLE owner;

-- Test 43: statement (line 229)
ALTER FUNCTION get_t() SECURITY DEFINER;

-- Test 44: statement (line 232)
SET ROLE root;

-- Test 45: statement (line 236)
REVOKE EXECUTE ON FUNCTION get_t FROM PUBLIC;
GRANT EXECUTE ON FUNCTION get_t TO invoker;

-- Test 46: statement (line 240)
SET ROLE invoker;

-- Test 47: statement (line 244)
SELECT get_t_nested();

-- Test 48: query (line 247)
SELECT get_t();

-- Test 49: statement (line 252)
SET ROLE root;

-- Test 50: statement (line 255)
GRANT EXECUTE ON FUNCTION get_t TO owner1;

-- Test 51: statement (line 258)
SET ROLE invoker;

-- Test 52: query (line 263)
SELECT get_t_nested();

-- Test 53: statement (line 270)
SET ROLE root;

-- Test 54: statement (line 273)
CREATE ROLE owner2;

-- Test 55: statement (line 276)
ALTER FUNCTION get_t() OWNER TO owner2;

-- Test 56: statement (line 279)
SET ROLE invoker;

-- Test 57: statement (line 282)
SELECT get_t_nested();

-- Test 58: statement (line 289)
SET ROLE root;

-- Test 59: statement (line 294)
GRANT SELECT ON TABLE secret_data TO owner;

-- Test 60: statement (line 297)
ALTER FUNCTION get_secret_data() OWNER TO owner;

-- Test 61: statement (line 300)
GRANT EXECUTE ON FUNCTION get_secret_data TO invoker;

-- Test 62: statement (line 303)
SET ROLE invoker;

-- Test 63: statement (line 308)
SELECT get_secret_data()
UNION
SELECT id FROM secret_data;

