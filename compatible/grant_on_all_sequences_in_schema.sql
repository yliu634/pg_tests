-- PostgreSQL compatible tests from grant_on_all_sequences_in_schema
-- 23 tests

-- Test 1: statement (line 1)
SET client_min_messages = warning;

DROP SCHEMA IF EXISTS s CASCADE;
DROP SCHEMA IF EXISTS s2 CASCADE;
DROP SCHEMA IF EXISTS s3 CASCADE;
DROP SCHEMA IF EXISTS s4 CASCADE;

DROP ROLE IF EXISTS testuser3;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS testuser;

CREATE ROLE testuser LOGIN;
CREATE ROLE testuser2 LOGIN;
GRANT testuser TO :"USER";
GRANT testuser2 TO :"USER";

-- Test 2: statement (line 4)
CREATE SCHEMA s;
CREATE SCHEMA s2;
GRANT USAGE ON SCHEMA s, s2 TO testuser, testuser2;

-- Test 3: statement (line 9)
GRANT SELECT ON ALL SEQUENCES IN SCHEMA s TO testuser;

-- Test 4: query (line 12)
-- No sequences exist in schema s yet.
SELECT count(*) AS sequences_in_s
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname = 's' AND c.relkind = 'S';

-- Test 5: statement (line 19)
CREATE SEQUENCE s.q;
CREATE SEQUENCE s2.q;
CREATE TABLE s.t();
CREATE TABLE s2.t();

-- Test 6: statement (line 25)
-- The first GRANT above ran before s.q existed, so it should not apply.
SELECT has_sequence_privilege('testuser', 's.q', 'SELECT') AS testuser_select_s_q;

SET ROLE testuser;

-- Test 7: statement (line 28)
-- Expected ERROR (permission denied).
\set ON_ERROR_STOP 0
SELECT * FROM s.q;
\set ON_ERROR_STOP 1

-- Test 8: statement (line 31)
RESET ROLE;

-- Test 9: statement (line 34)
GRANT SELECT ON ALL SEQUENCES IN SCHEMA s TO testuser;

-- Test 10: query (line 55)
SELECT
  has_sequence_privilege('testuser', 's.q', 'SELECT') AS testuser_select_s_q,
  has_sequence_privilege('testuser', 's2.q', 'SELECT') AS testuser_select_s2_q;

-- Test 11: statement (line 64)
GRANT USAGE ON ALL SEQUENCES IN SCHEMA s TO testuser;

-- Test 12: query (line 67)
SELECT has_sequence_privilege('testuser', 's.q', 'USAGE') AS testuser_usage_s_q;

-- Test 13: statement (line 77)
GRANT SELECT ON ALL SEQUENCES IN SCHEMA s, s2 TO testuser, testuser2;

-- Test 14: query (line 80)
SELECT
  has_sequence_privilege('testuser',  's.q',  'SELECT') AS testuser_select_s_q,
  has_sequence_privilege('testuser',  's2.q', 'SELECT') AS testuser_select_s2_q,
  has_sequence_privilege('testuser2', 's.q',  'SELECT') AS testuser2_select_s_q,
  has_sequence_privilege('testuser2', 's2.q', 'SELECT') AS testuser2_select_s2_q;

-- Test 15: statement (line 93)
GRANT ALL ON ALL SEQUENCES IN SCHEMA s, s2 TO testuser, testuser2;

-- Test 16: query (line 96)
SELECT
  has_sequence_privilege('testuser',  's.q',  'USAGE') AS testuser_usage_s_q,
  has_sequence_privilege('testuser',  's2.q', 'USAGE') AS testuser_usage_s2_q,
  has_sequence_privilege('testuser2', 's.q',  'USAGE') AS testuser2_usage_s_q,
  has_sequence_privilege('testuser2', 's2.q', 'USAGE') AS testuser2_usage_s2_q;

-- Test 17: statement (line 108)
CREATE ROLE testuser3 LOGIN;
GRANT testuser3 TO :"USER";

-- Test 18: statement (line 112)
GRANT ALL ON ALL TABLES IN SCHEMA s2 TO testuser3;

-- Test 19: query (line 115)
SELECT
  has_table_privilege('testuser3', 's2.t', 'SELECT') AS testuser3_select_s2_t,
  has_sequence_privilege('testuser3', 's2.q', 'USAGE') AS testuser3_usage_s2_q;

-- Test 20: statement (line 124)
-- Postgres doesn't support "FOR ALL ROLES"; apply default privileges for the current role.
ALTER DEFAULT PRIVILEGES GRANT USAGE ON SEQUENCES TO testuser3;

-- Test 21: statement (line 127)
CREATE SCHEMA s3;
CREATE SCHEMA s4;
GRANT USAGE ON SCHEMA s3, s4 TO testuser3;
CREATE SEQUENCE s3.q;
CREATE SEQUENCE s4.q;

-- Test 22: query (line 133)
SELECT
  has_sequence_privilege('testuser',  's3.q', 'USAGE') AS testuser_usage_s3_q,
  has_sequence_privilege('testuser2', 's3.q', 'USAGE') AS testuser2_usage_s3_q;

-- Test 23: query (line 147)
SELECT
  has_sequence_privilege('testuser3', 's3.q', 'USAGE') AS testuser3_usage_s3_q,
  has_sequence_privilege('testuser3', 's4.q', 'USAGE') AS testuser3_usage_s4_q;

RESET client_min_messages;
