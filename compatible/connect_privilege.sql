-- PostgreSQL compatible tests from connect_privilege
-- 7 tests

-- Test 1: query (line 4)
SELECT schemaname, tablename, tableowner FROM pg_catalog.pg_tables WHERE tablename = 'a'

-- Test 2: statement (line 9)
REVOKE CONNECT ON DATABASE test FROM public

user testuser

-- Test 3: query (line 14)
SELECT schemaname, tablename, tableowner FROM pg_catalog.pg_tables WHERE tablename = 'a'

-- Test 4: query (line 18)
SELECT table_catalog, table_schema, table_name FROM information_schema.tables WHERE table_name = 'a'

-- Test 5: statement (line 27)
GRANT CONNECT ON DATABASE test TO testuser

user testuser

-- Test 6: query (line 32)
SELECT schemaname, tablename, tableowner FROM pg_catalog.pg_tables WHERE tablename = 'a'

-- Test 7: query (line 37)
SELECT table_catalog, table_schema, table_name FROM information_schema.tables WHERE table_name = 'a'

