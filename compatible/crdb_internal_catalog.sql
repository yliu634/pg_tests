-- PostgreSQL compatible tests from crdb_internal_catalog
-- 20 tests
-- Most tests are commented out because they rely on CockroachDB-specific features

SET client_min_messages = warning;
DROP DATABASE IF EXISTS db;
DROP TABLE IF EXISTS kv;
DROP MATERIALIZED VIEW IF EXISTS mv;
DROP FUNCTION IF EXISTS strip_volatile(JSONB);
DROP SCHEMA IF EXISTS sc CASCADE;
RESET client_min_messages;

-- Test 1: statement (line 6)
CREATE DATABASE db;

-- Test 2: statement (line 9)
-- ALTER DATABASE db CONFIGURE ZONE USING gc.ttlseconds = 7200;

-- Test 3: statement (line 12)
\c db

-- Test 4: statement (line 15)
CREATE SCHEMA sc;

-- Test 5: statement (line 18)
CREATE TYPE sc.greeting AS ENUM('hi', 'hello');

CREATE TABLE kv (
  k INT PRIMARY KEY,
  v TEXT
);

-- Test 6: statement (line 24)
ALTER TABLE kv ADD CONSTRAINT ck CHECK (k > 0);

-- Test 7: statement (line 27)
CREATE MATERIALIZED VIEW mv AS SELECT k, v FROM kv;

-- Test 8: statement (line 30)
CREATE INDEX idx ON mv(v);

-- Test 9: statement (line 33)
-- ALTER TABLE kv CONFIGURE ZONE USING gc.ttlseconds = 3600;

-- Test 10: statement (line 36)
\c pg_tests
COMMENT ON DATABASE pg_tests IS 'this is the test database';

\c db

-- Test 11: statement (line 39)
COMMENT ON SCHEMA sc IS 'this is a schema';

-- Test 12: statement (line 42)
COMMENT ON SCHEMA public IS 'this is the public schema';

-- Test 13: statement (line 45)
COMMENT ON TABLE kv IS 'this is a table';

-- Test 14: statement (line 48)
COMMENT ON INDEX idx IS 'this is an index';

-- Test 15: statement (line 51)
COMMENT ON CONSTRAINT ck ON kv IS 'this is a check constraint';

-- Test 16: statement (line 54)
COMMENT ON CONSTRAINT kv_pkey ON kv IS 'this is a primary key constraint';

-- Test 17: statement (line 57)
\c pg_tests

-- Test 18: statement (line 60)
CREATE FUNCTION strip_volatile(IN d JSONB)
	RETURNS JSONB
	STABLE
	LANGUAGE SQL
	AS $$
SELECT
	d - 'table' - 'function' - 'type' - 'schema' - 'database'
$$;

-- Test 19: query (line 116)
-- SELECT least(id, 999), strip_volatile(descriptor) FROM crdb_internal.kv_catalog_descriptor WHERE id IN (1, 2, 3, 29, 'geometry_columns'::regclass::int) OR (id > 100 and id < 200) ORDER BY id;

-- Test 20: query (line 138)
-- SELECT least(id, 999), strip_volatile(descriptor) FROM crdb_internal.kv_catalog_descriptor WHERE id IN (1, 2, 3, 29, 'geometry_columns'::regclass::int) OR (id > 100 and id < 200) ORDER BY id;
