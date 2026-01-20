-- PostgreSQL compatible tests from privileges_table
--
-- The upstream CockroachDB logic-test file relies on Cockroach-only features
-- (e.g. `SET DATABASE`, `SHOW GRANTS`, `schema_locked`, `UPSERT`, `system.*`,
-- and `let` variables). This reduced version exercises core GRANT/REVOKE
-- behavior on a table using PostgreSQL builtins and information_schema.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t;
DROP ROLE IF EXISTS pt_testuser;
DROP ROLE IF EXISTS pt_bar;

CREATE ROLE pt_testuser;
CREATE ROLE pt_bar;

CREATE TABLE t (k INT PRIMARY KEY, v INT);

SELECT has_table_privilege('pt_testuser', 't', 'SELECT') AS testuser_select_before;

GRANT SELECT ON t TO pt_testuser;
GRANT INSERT ON t TO pt_bar;

SELECT has_table_privilege('pt_testuser', 't', 'SELECT') AS testuser_select_after;
SELECT has_table_privilege('pt_bar', 't', 'INSERT') AS bar_insert_after;

SELECT column_name, data_type
  FROM information_schema.columns
 WHERE table_schema = 'public'
   AND table_name = 't'
 ORDER BY ordinal_position;

REVOKE SELECT ON t FROM pt_testuser;
REVOKE INSERT ON t FROM pt_bar;

SELECT has_table_privilege('pt_testuser', 't', 'SELECT') AS testuser_select_revoked;
SELECT has_table_privilege('pt_bar', 't', 'INSERT') AS bar_insert_revoked;

DROP TABLE IF EXISTS t;
DROP ROLE pt_testuser;
DROP ROLE pt_bar;

RESET client_min_messages;
