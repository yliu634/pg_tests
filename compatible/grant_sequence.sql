-- PostgreSQL compatible tests from grant_sequence
-- 62 tests

-- CockroachDB has additional sequence privilege types (e.g. DROP) and uses
-- SHOW GRANTS. This file is rewritten as pure PostgreSQL SQL/psql while keeping
-- the same semantic focus: GRANT/REVOKE on sequences (USAGE/SELECT/UPDATE),
-- grant options, and the fact that "DROP privilege" is modeled via ownership.

SET client_min_messages = warning;

DROP TABLE IF EXISTS mix_tab;
DROP SEQUENCE IF EXISTS mix_seq;
DROP SEQUENCE IF EXISTS to_drop_seq;
DROP SEQUENCE IF EXISTS a;

DROP SCHEMA IF EXISTS gs_seq_schema CASCADE;
DROP SCHEMA IF EXISTS gs_main CASCADE;

-- Use file-scoped role names to avoid cross-test collisions.
DROP ROLE IF EXISTS gs_mix_u;
DROP ROLE IF EXISTS gs_user2;
DROP ROLE IF EXISTS gs_user1;
DROP ROLE IF EXISTS gs_readwrite;

CREATE ROLE gs_readwrite;
CREATE ROLE gs_user1;
CREATE ROLE gs_user2;
CREATE ROLE gs_mix_u;

CREATE SCHEMA gs_main;
GRANT USAGE, CREATE ON SCHEMA gs_main TO gs_readwrite, gs_user1, gs_user2, gs_mix_u;

-- Test 1: basic sequence usage + permission errors.
CREATE SEQUENCE gs_main.a START 1 INCREMENT BY 2;

SET ROLE gs_readwrite;
\set ON_ERROR_STOP 0
SELECT last_value, is_called FROM gs_main.a;
SELECT nextval('gs_main.a');
\set ON_ERROR_STOP 1
RESET ROLE;

GRANT USAGE ON SEQUENCE gs_main.a TO gs_readwrite;

SET ROLE gs_readwrite;
SELECT nextval('gs_main.a');
SELECT currval('gs_main.a');
RESET ROLE;

-- Test 2: grant ALL with grant option, then inspect grant options.
GRANT ALL ON SEQUENCE gs_main.a TO gs_readwrite WITH GRANT OPTION;

SELECT
  has_sequence_privilege('gs_readwrite', 'gs_main.a', 'USAGE') AS usage,
  has_sequence_privilege('gs_readwrite', 'gs_main.a', 'SELECT') AS select_p,
  has_sequence_privilege('gs_readwrite', 'gs_main.a', 'UPDATE') AS update_p,
  has_sequence_privilege('gs_readwrite', 'gs_main.a', 'USAGE WITH GRANT OPTION') AS usage_go,
  has_sequence_privilege('gs_readwrite', 'gs_main.a', 'SELECT WITH GRANT OPTION') AS select_go,
  has_sequence_privilege('gs_readwrite', 'gs_main.a', 'UPDATE WITH GRANT OPTION') AS update_go;

REVOKE UPDATE ON SEQUENCE gs_main.a FROM gs_readwrite;

SELECT
  has_sequence_privilege('gs_readwrite', 'gs_main.a', 'UPDATE') AS update_after_revoke,
  has_sequence_privilege('gs_readwrite', 'gs_main.a', 'UPDATE WITH GRANT OPTION') AS update_go_after_revoke;

GRANT UPDATE ON SEQUENCE gs_main.a TO gs_readwrite;

SET ROLE gs_readwrite;
SELECT last_value, is_called FROM gs_main.a;
SELECT nextval('gs_main.a');
SELECT nextval('gs_main.a');
RESET ROLE;

-- Test 3: GRANT/REVOKE on ALL SEQUENCES in a schema.
CREATE SCHEMA gs_seq_schema;
CREATE SEQUENCE gs_seq_schema.b START 1 INCREMENT BY 2;

GRANT ALL ON ALL SEQUENCES IN SCHEMA gs_seq_schema TO gs_readwrite WITH GRANT OPTION;

SELECT
  has_sequence_privilege('gs_readwrite', 'gs_seq_schema.b', 'USAGE WITH GRANT OPTION') AS b_usage_go,
  has_sequence_privilege('gs_readwrite', 'gs_seq_schema.b', 'SELECT WITH GRANT OPTION') AS b_select_go,
  has_sequence_privilege('gs_readwrite', 'gs_seq_schema.b', 'UPDATE WITH GRANT OPTION') AS b_update_go;

REVOKE SELECT ON ALL SEQUENCES IN SCHEMA gs_seq_schema FROM gs_readwrite;

SELECT
  has_sequence_privilege('gs_readwrite', 'gs_seq_schema.b', 'SELECT') AS b_select_after_revoke,
  has_sequence_privilege('gs_readwrite', 'gs_seq_schema.b', 'SELECT WITH GRANT OPTION') AS b_select_go_after_revoke;

-- Test 4: "DROP privilege" is modeled by ownership in PostgreSQL.
CREATE SEQUENCE gs_main.to_drop_seq;

SET ROLE gs_user1;
\set ON_ERROR_STOP 0
DROP SEQUENCE gs_main.to_drop_seq;
\set ON_ERROR_STOP 1
RESET ROLE;

ALTER SEQUENCE gs_main.to_drop_seq OWNER TO gs_user1;

SET ROLE gs_user1;
DROP SEQUENCE gs_main.to_drop_seq;
RESET ROLE;

-- Ownership transfer requires being a member of the new owner role.
CREATE SEQUENCE gs_main.to_drop_seq;
ALTER SEQUENCE gs_main.to_drop_seq OWNER TO gs_user1;

SET ROLE gs_user1;
\set ON_ERROR_STOP 0
ALTER SEQUENCE gs_main.to_drop_seq OWNER TO gs_user2;
\set ON_ERROR_STOP 1
RESET ROLE;

GRANT gs_user2 TO gs_user1;

SET ROLE gs_user1;
ALTER SEQUENCE gs_main.to_drop_seq OWNER TO gs_user2;
RESET ROLE;

SET ROLE gs_user2;
DROP SEQUENCE gs_main.to_drop_seq;
RESET ROLE;

-- Test 5: mixing sequence + table privileges, and grant options.
CREATE SEQUENCE gs_main.mix_seq;
CREATE TABLE gs_main.mix_tab (x INT);

GRANT USAGE ON SEQUENCE gs_main.mix_seq TO gs_mix_u WITH GRANT OPTION;

SELECT has_sequence_privilege('gs_mix_u', 'gs_main.mix_seq', 'USAGE WITH GRANT OPTION');

GRANT SELECT, UPDATE ON gs_main.mix_seq, gs_main.mix_tab TO gs_mix_u WITH GRANT OPTION;

SELECT
  has_sequence_privilege('gs_mix_u', 'gs_main.mix_seq', 'USAGE WITH GRANT OPTION') AS usage_go,
  has_sequence_privilege('gs_mix_u', 'gs_main.mix_seq', 'SELECT WITH GRANT OPTION') AS select_go,
  has_sequence_privilege('gs_mix_u', 'gs_main.mix_seq', 'UPDATE WITH GRANT OPTION') AS update_go,
  has_table_privilege('gs_mix_u', 'gs_main.mix_tab', 'SELECT WITH GRANT OPTION') AS tab_select_go,
  has_table_privilege('gs_mix_u', 'gs_main.mix_tab', 'UPDATE WITH GRANT OPTION') AS tab_update_go;

RESET client_min_messages;
