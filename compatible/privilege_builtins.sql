-- PostgreSQL compatible tests from privilege_builtins
--
-- The upstream CockroachDB logic-test version includes harness directives and
-- assumptions about a `test` database. This reduced version exercises native
-- PostgreSQL privilege inspection builtins against the current database.

SET client_min_messages = warning;

DROP SCHEMA IF EXISTS test_schema CASCADE;
DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS seq;

CREATE ROLE pb_bar;
CREATE ROLE pb_testuser;
CREATE ROLE pb_all_user_db;
CREATE ROLE pb_all_user_schema;

CREATE SCHEMA test_schema;

GRANT CREATE ON DATABASE pg_tests TO pb_bar;
GRANT CONNECT ON DATABASE pg_tests TO pb_testuser;

GRANT CREATE ON SCHEMA test_schema TO pb_bar;
GRANT CREATE, USAGE ON SCHEMA test_schema TO pb_testuser;

GRANT ALL PRIVILEGES ON DATABASE pg_tests TO pb_all_user_db;
GRANT ALL PRIVILEGES ON SCHEMA test_schema TO pb_all_user_schema;

CREATE TABLE t (a INT, b INT);
CREATE SEQUENCE seq;

GRANT DELETE ON TABLE t TO pb_bar;
GRANT SELECT ON SEQUENCE seq TO pb_bar;

-- Privilege check helpers (expect true/false).
SELECT
  has_table_privilege('pb_bar', 't', 'DELETE') AS bar_delete_t,
  has_table_privilege('pb_bar', 't', 'SELECT') AS bar_select_t;

SELECT
  has_sequence_privilege('pb_bar', 'seq', 'SELECT') AS bar_select_seq,
  has_sequence_privilege('pb_testuser', 'seq', 'SELECT') AS testuser_select_seq;

-- Column privilege checks.
GRANT SELECT (a) ON TABLE t TO pb_bar;
SELECT
  has_column_privilege('pb_bar', 't', 'a', 'SELECT') AS bar_select_a,
  has_column_privilege('pb_bar', 't', 'b', 'SELECT') AS bar_select_b;

DROP TABLE IF EXISTS t;
DROP SEQUENCE IF EXISTS seq;
DROP SCHEMA IF EXISTS test_schema CASCADE;

REVOKE ALL PRIVILEGES ON DATABASE pg_tests FROM pb_bar;
REVOKE ALL PRIVILEGES ON DATABASE pg_tests FROM pb_testuser;
REVOKE ALL PRIVILEGES ON DATABASE pg_tests FROM pb_all_user_db;
REVOKE ALL PRIVILEGES ON DATABASE pg_tests FROM pb_all_user_schema;

DROP ROLE IF EXISTS pb_bar;
DROP ROLE IF EXISTS pb_testuser;
DROP ROLE IF EXISTS pb_all_user_db;
DROP ROLE IF EXISTS pb_all_user_schema;

RESET client_min_messages;
