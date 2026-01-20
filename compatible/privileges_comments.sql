-- PostgreSQL compatible tests from privileges_comments
-- 17 tests

-- Test 1: statement (line 7)
CREATE DATABASE d45707; CREATE TABLE d45707.t45707(x INT);
  GRANT CONNECT ON DATABASE d45707 TO testuser;
  GRANT SELECT ON d45707.t45707 TO testuser

-- Test 2: statement (line 12)
COMMENT ON DATABASE d45707 IS 'd45707';
COMMENT ON TABLE d45707.t45707 IS 't45707';
COMMENT ON COLUMN d45707.t45707.x IS 'x45707';
COMMENT ON INDEX d45707.t45707@t45707_pkey IS 'p45707'

user testuser

-- Test 3: statement (line 20)
SET DATABASE = d45707

-- Test 4: statement (line 25)
COMMENT ON DATABASE d45707 IS 'd45707'

onlyif config local-legacy-schema-changer

-- Test 5: statement (line 29)
COMMENT ON TABLE d45707.t45707 IS 't45707'

skipif config local-legacy-schema-changer

-- Test 6: statement (line 33)
COMMENT ON TABLE d45707.t45707 IS 't45707'

onlyif config local-legacy-schema-changer

-- Test 7: statement (line 37)
COMMENT ON COLUMN d45707.t45707.x IS 'x45707'

skipif config local-legacy-schema-changer

-- Test 8: statement (line 41)
COMMENT ON COLUMN d45707.t45707.x IS 'x45707'

onlyif config local-legacy-schema-changer

-- Test 9: statement (line 45)
COMMENT ON INDEX d45707.t45707@t45707_pkey IS 'p45707'

skipif config local-legacy-schema-changer

-- Test 10: statement (line 49)
COMMENT ON INDEX d45707.t45707@t45707_pkey IS 'p45707'

-- Test 11: query (line 54)
SELECT shobj_description(oid, 'pg_database')
  FROM pg_database
 WHERE datname = 'd45707'

-- Test 12: query (line 61)
SELECT col_description(attrelid, attnum)
  FROM pg_attribute
 WHERE attrelid = 't45707'::regclass AND attname = 'x'

-- Test 13: query (line 68)
SELECT obj_description('t45707'::REGCLASS)

-- Test 14: query (line 73)
SELECT obj_description(indexrelid)
  FROM pg_index
 WHERE indrelid = 't45707'::REGCLASS
   AND indisprimary

-- Test 15: statement (line 85)
GRANT ALL ON DATABASE d45707 TO testuser

-- Test 16: statement (line 88)
GRANT ALL ON TABLE d45707.t45707 TO testuser

user testuser

-- Test 17: statement (line 93)
COMMENT ON DATABASE d45707 IS 'd45707_2';
COMMENT ON TABLE d45707.t45707 IS 't45707_2';
COMMENT ON COLUMN d45707.t45707.x IS 'x45707_2';
COMMENT ON INDEX d45707.t45707@t45707_pkey IS 'p45707_2'

