-- PostgreSQL compatible tests from procedure_privileges
--
-- The upstream CockroachDB logic-test file includes Cockroach-specific SHOW
-- commands. This reduced version exercises PostgreSQL EXECUTE privileges on a
-- procedure using has_function_privilege().

SET client_min_messages = warning;

DROP PROCEDURE IF EXISTS test_priv_p1();
DROP ROLE IF EXISTS test_user;

CREATE PROCEDURE test_priv_p1() LANGUAGE SQL AS $$
  SELECT 1;
$$;

CREATE ROLE test_user;

REVOKE ALL ON PROCEDURE test_priv_p1() FROM PUBLIC;

SELECT has_function_privilege('test_user', 'test_priv_p1()', 'EXECUTE') AS can_execute_before;

GRANT EXECUTE ON PROCEDURE test_priv_p1() TO test_user;

SELECT has_function_privilege('test_user', 'test_priv_p1()', 'EXECUTE') AS can_execute_after;

SET ROLE test_user;
CALL test_priv_p1();
RESET ROLE;

DROP PROCEDURE test_priv_p1();
REVOKE ALL PRIVILEGES ON SCHEMA public FROM test_user;
DROP ROLE test_user;

RESET client_min_messages;
