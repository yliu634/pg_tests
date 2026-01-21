-- PostgreSQL compatible tests from privileges_comments
-- 17 tests

-- Test 1: statement (line 7)
SET client_min_messages = warning;

DROP DATABASE IF EXISTS d45707;
DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser LOGIN;
GRANT testuser TO :"USER";

CREATE DATABASE d45707;
\connect d45707
DROP TABLE IF EXISTS t45707;
CREATE TABLE t45707(x INT PRIMARY KEY);
GRANT CONNECT ON DATABASE d45707 TO testuser;
GRANT SELECT ON t45707 TO testuser;

-- Test 2: statement (line 12)
COMMENT ON DATABASE d45707 IS 'd45707';
COMMENT ON TABLE t45707 IS 't45707';
COMMENT ON COLUMN t45707.x IS 'x45707';
COMMENT ON INDEX t45707_pkey IS 'p45707';

-- user testuser
-- Test 3: statement (line 20)
SET ROLE testuser;

-- Test 4: statement (line 25)
-- Expected ERROR (insufficient privilege).
\set ON_ERROR_STOP 0
COMMENT ON DATABASE d45707 IS 'd45707';
\set ON_ERROR_STOP 1

-- Test 5: statement (line 29)
-- onlyif config local-legacy-schema-changer
-- skipif config local-legacy-schema-changer
-- Test 6: statement (line 33)
-- Expected ERROR (insufficient privilege).
\set ON_ERROR_STOP 0
COMMENT ON TABLE t45707 IS 't45707';
\set ON_ERROR_STOP 1

-- Test 7: statement (line 37)
-- Expected ERROR (insufficient privilege).
\set ON_ERROR_STOP 0
COMMENT ON COLUMN t45707.x IS 'x45707';
\set ON_ERROR_STOP 1

-- Test 9: statement (line 45)
-- Expected ERROR (insufficient privilege).
\set ON_ERROR_STOP 0
COMMENT ON INDEX t45707_pkey IS 'p45707';
\set ON_ERROR_STOP 1

-- Test 11: query (line 54)
SELECT shobj_description(oid, 'pg_database')
  FROM pg_database
 WHERE datname = 'd45707';

-- Test 12: query (line 61)
SELECT col_description(attrelid, attnum)
  FROM pg_attribute
 WHERE attrelid = 't45707'::regclass AND attname = 'x';

-- Test 13: query (line 68)
SELECT obj_description('t45707'::REGCLASS);

-- Test 14: query (line 73)
SELECT obj_description(indexrelid)
  FROM pg_index
 WHERE indrelid = 't45707'::REGCLASS
   AND indisprimary;

-- Test 15: statement (line 85)
RESET ROLE;
GRANT ALL ON DATABASE d45707 TO testuser;

-- Test 16: statement (line 88)
GRANT ALL ON TABLE t45707 TO testuser;
ALTER DATABASE d45707 OWNER TO testuser;
ALTER TABLE t45707 OWNER TO testuser;

-- Test 17: statement (line 93)
SET ROLE testuser;
COMMENT ON DATABASE d45707 IS 'd45707_2';
COMMENT ON TABLE t45707 IS 't45707_2';
COMMENT ON COLUMN t45707.x IS 'x45707_2';
COMMENT ON INDEX t45707_pkey IS 'p45707_2';

RESET ROLE;
\connect postgres
DROP DATABASE IF EXISTS d45707;

RESET client_min_messages;
