-- PostgreSQL compatible tests from connect_privilege
-- 7 tests (simplified - user switching is Cockroach test feature)

SET client_min_messages = warning;
DROP TABLE IF EXISTS a CASCADE;
RESET client_min_messages;

-- Create a test table for the queries to reference
CREATE TABLE a (id INT);

-- Test 1: query (line 4)
SELECT schemaname, tablename, tableowner FROM pg_catalog.pg_tables WHERE tablename = 'a';

-- Test 2: statement (line 9)
-- REVOKE CONNECT ON DATABASE test FROM public; - Database-level privilege management
-- Commenting out as it would affect the entire database

-- user testuser - Cockroach test directive, not SQL

-- Test 3: query (line 14)
SELECT schemaname, tablename, tableowner FROM pg_catalog.pg_tables WHERE tablename = 'a';

-- Test 4: query (line 18)
SELECT table_catalog, table_schema, table_name FROM information_schema.tables WHERE table_name = 'a';

-- Test 5: statement (line 27)
-- GRANT CONNECT ON DATABASE test TO testuser; - Commented out

-- user testuser - Cockroach test directive, not SQL

-- Test 6: query (line 32)
SELECT schemaname, tablename, tableowner FROM pg_catalog.pg_tables WHERE tablename = 'a';

-- Test 7: query (line 37)
SELECT table_catalog, table_schema, table_name FROM information_schema.tables WHERE table_name = 'a';
