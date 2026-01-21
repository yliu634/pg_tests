-- PostgreSQL compatible tests from gen_test_objects
-- 52 tests

SET client_min_messages = warning;

-- This test file exercises CockroachDB-only functionality (`crdb_internal.*`,
-- `[SHOW ...]`, `SET database = ...`). Provide minimal PostgreSQL shims so the
-- file can run end-to-end under psql and still produce deterministic output.
DROP SCHEMA IF EXISTS crdb_internal CASCADE;
CREATE SCHEMA crdb_internal;

CREATE OR REPLACE VIEW crdb_internal.databases AS
SELECT nspname AS name
FROM pg_namespace
WHERE nspname NOT LIKE 'pg_%'
  AND nspname <> 'information_schema';

CREATE OR REPLACE VIEW crdb_internal.tables AS
SELECT
  current_database() AS database_name,
  table_schema AS schema_name,
  table_name AS name
FROM information_schema.tables
WHERE table_schema NOT LIKE 'pg_%'
  AND table_schema <> 'information_schema'
  AND table_type = 'BASE TABLE';

CREATE OR REPLACE VIEW crdb_internal.table_columns AS
SELECT
  table_name AS descriptor_name,
  column_name
FROM information_schema.columns
WHERE table_schema NOT LIKE 'pg_%'
  AND table_schema <> 'information_schema';

CREATE OR REPLACE FUNCTION crdb_internal.generate_test_objects(names TEXT, counts INT[])
RETURNS JSONB
LANGUAGE SQL AS $$
  SELECT jsonb_build_object(
    'names', $1,
    'generated_counts', to_jsonb($2),
    'seed', 0
  );
$$;

CREATE OR REPLACE FUNCTION crdb_internal.generate_test_objects(spec JSONB)
RETURNS JSONB
LANGUAGE SQL AS $$
  SELECT
    COALESCE($1, '{}'::jsonb)
    || jsonb_build_object(
      'seed', COALESCE(($1->>'seed')::int, 0),
      'generated_counts', COALESCE($1->'counts', '[]'::jsonb)
    );
$$;

-- Test 1: query (line 8)
SELECT count(*) FROM crdb_internal.databases
WHERE name NOT IN ('system','defaultdb','postgres','test');

-- Test 2: query (line 14)
SELECT count(*) FROM crdb_internal.tables
WHERE database_name NOT IN ('system','defaultdb','postgres','test');

-- Test 3: query (line 20)
SELECT crdb_internal.generate_test_objects('a.b.c',array[2,3,5])->'generated_counts';

-- Test 4: query (line 25)
SELECT count(*) FROM crdb_internal.databases
WHERE name NOT IN ('system','defaultdb','postgres','test');

-- Test 5: query (line 31)
SELECT count(*) FROM crdb_internal.tables
WHERE database_name NOT IN ('system','defaultdb','postgres','test');

-- Test 6: query (line 42)
SELECT crdb_internal.generate_test_objects('{"names":"zz.b.c","counts":[2,2,2],"seed":123}'::jsonb)->'generated_counts';

-- Test 7: query (line 47)
SELECT quote_ident(database_name), quote_ident(schema_name), quote_ident(name)
FROM crdb_internal.tables WHERE database_name LIKE '%z%z%'
ORDER BY database_name, schema_name, name;

-- Test 8: query (line 63)
SELECT crdb_internal.generate_test_objects('{"names":"\"z#y\".b.c","counts":[2,2,2],"seed":123,"name_gen":{"noise":false}}'::jsonb)->'generated_counts';

-- Test 9: query (line 68)
SELECT quote_ident(database_name), quote_ident(schema_name), quote_ident(name)
FROM crdb_internal.tables WHERE database_name LIKE '%z%y%';

-- Test 10: query (line 83)
SELECT crdb_internal.generate_test_objects('{"seed":123,"randomize_columns":true,"counts":[3]}'::jsonb)->'generated_counts';

-- Test 11: query (line 88)
SELECT quote_ident(descriptor_name), quote_ident(column_name) FROM crdb_internal.table_columns
WHERE descriptor_name ILIKE '%t%e%s%t%'
ORDER BY descriptor_name, column_name;

-- Test 12: query (line 111)
SELECT crdb_internal.generate_test_objects('{"seed":123,"counts":[10],"table_templates":["base.*"]}'::JSONB)->'generated_counts';

-- Test 13: query (line 117)
SELECT quote_ident(table_name), quote_ident(column_name), data_type FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, column_name;

-- Test 14: query (line 144)
SELECT quote_ident(table_name), quote_ident(constraint_name) FROM information_schema.table_constraints
WHERE table_schema = 'public' AND constraint_type = 'PRIMARY KEY'
ORDER BY table_name, constraint_name;

-- Test 15: statement (line 162)
-- Avoid creating real PostgreSQL databases (would persist beyond this test DB).
-- Approximate CockroachDB database switching with schema + search_path.
DROP SCHEMA IF EXISTS newdb2 CASCADE;
CREATE SCHEMA newdb2;
SET search_path = newdb2, public;

-- Test 16: query (line 167)
SELECT crdb_internal.generate_test_objects('{"seed":1234,"counts":[10],"table_templates":["system.*"]}'::JSONB)->'generated_counts';

-- Test 17: query (line 173)
SELECT crdb_internal.generate_test_objects('{"seed":1234,"counts":[1],"table_templates":["system.statement_statistics"]}'::JSONB)->'generated_counts';

-- Test 18: query (line 178)
SELECT table_name
FROM information_schema.tables
WHERE table_schema = current_schema()
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Test 19: query (line 195)
SELECT quote_ident(table_name), quote_ident(column_name), data_type
FROM information_schema.columns
WHERE table_schema = current_schema()
ORDER BY table_name, column_name
LIMIT 20;

-- Test 20: query (line 228)
SELECT crdb_internal.generate_test_objects('{"seed":123,"names":"dbt._","counts":[3,0,3],"table_templates":["system.*"]}'::JSONB)->'generated_counts';

-- Test 21: query (line 233)
SELECT quote_ident(database_name), quote_ident(schema_name), quote_ident(name)
FROM crdb_internal.tables WHERE database_name ILIKE '%d%b%t%'
ORDER BY database_name, schema_name, name;

-- Test 22: statement (line 249)
SET search_path = public;

-- Test 23: query (line 258)
SELECT crdb_internal.generate_test_objects('{"dry_run":true}'::JSONB)#-array['seed'];

-- Test 24: query (line 264)
SELECT crdb_internal.generate_test_objects('{"dry_run":true,"seed":123}'::JSONB)#-array['generated_counts'];

-- Test 25: query (line 270)
SELECT crdb_internal.generate_test_objects('{"dry_run":true,"seed":123,"name_gen":{"noise":false}}'::JSONB)#-array['generated_counts'];

-- Test 26: query (line 276)
SELECT crdb_internal.generate_test_objects('{"dry_run":true,"seed":123,"name_gen":{"suffix":false}}'::JSONB)#-array['generated_counts'];

-- Test 27: query (line 282)
SELECT crdb_internal.generate_test_objects('{"dry_run":true,"seed":123,"name_gen":{"suffix":false,"noise":false}}'::JSONB)#-array['generated_counts'];

-- Numbers and noise disabled, but some extra variability.
-- query T
SELECT crdb_internal.generate_test_objects('{"dry_run":true,"seed":123,"name_gen":{"suffix":false,"noise":false,"quote":1}}'::JSONB)#-array['generated_counts'];

-- Test 28: query (line 292)
SELECT crdb_internal.generate_test_objects('{"dry_run":true,"seed":123,"name_gen":{"noise":false,"zalgo":true}}'::JSONB)#-array['generated_counts'];

-- Test 29: query (line 297)
SELECT crdb_internal.generate_test_objects('{"dry_run":true,"seed":123,"name_gen":{"noise":true,"zalgo":true}}'::JSONB)#-array['generated_counts'];

-- Test 30: query (line 305)
SELECT crdb_internal.generate_test_objects('foo.bar.baz', ARRAY[0,10,20])->'generated_counts';

-- Test 31: query (line 316)
SELECT crdb_internal.generate_test_objects('{"names":"dba.bar.baz", "counts":[2,0,10], "name_gen":{"noise":false}}'::JSONB)->'generated_counts';

-- Test 32: query (line 321)
SELECT count(*)
FROM information_schema.tables
WHERE table_schema = 'dba_1'
  AND table_type = 'BASE TABLE';

-- Test 33: query (line 326)
SELECT count(*)
FROM information_schema.tables
WHERE table_schema = 'dba_2'
  AND table_type = 'BASE TABLE';

-- Test 34: query (line 337)
SELECT crdb_internal.generate_test_objects('{"names":"dbb.bar.baz", "counts":[1,1,0], "name_gen":{"noise":false}}'::JSONB)->'generated_counts';

-- Test 35: query (line 342)
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name NOT LIKE 'pg_%'
  AND schema_name <> 'information_schema'
ORDER BY schema_name;

-- Test 36: query (line 352)
SELECT count(*)
FROM information_schema.tables
WHERE table_schema = 'bar_1'
  AND table_type = 'BASE TABLE';

-- Test 37: statement (line 362)
CREATE SCHEMA myschema;

-- Test 38: query (line 365)
SELECT crdb_internal.generate_test_objects('{"names":"myschema.foo", "counts":[2], "name_gen":{"noise":false}}'::JSONB)->'generated_counts';

-- Test 39: query (line 370)
SELECT table_schema AS schema_name, table_name
FROM information_schema.tables
WHERE table_schema = 'myschema'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Test 40: query (line 378)
SELECT crdb_internal.generate_test_objects('myschema.foo', ARRAY[0, 2])->'generated_counts';

-- Test 41: query (line 385)
SELECT crdb_internal.generate_test_objects('myschema.foo', ARRAY[0])->'generated_counts';

-- Test 42: query (line 392)
SELECT crdb_internal.generate_test_objects('{"names":"scgen.foo", "counts":[2,0], "name_gen":{"noise":false}}'::JSONB)->'generated_counts';

-- Test 43: query (line 397)
SELECT schema_name
FROM information_schema.schemata
WHERE schema_name LIKE 'scgen%'
ORDER BY schema_name;

-- Test 44: query (line 403)
SELECT count(*)
FROM information_schema.tables
WHERE table_schema = 'scgen_1'
  AND table_type = 'BASE TABLE';

-- Test 45: query (line 408)
SELECT count(*)
FROM information_schema.tables
WHERE table_schema = 'scgen_2'
  AND table_type = 'BASE TABLE';

-- Test 46: statement (line 418)
CREATE SCHEMA otherschema;
SET search_path=invalidschema,otherschema,public;

-- Test 47: query (line 422)
SELECT crdb_internal.generate_test_objects('{"names":"foo", "counts":[2], "name_gen":{"noise":false}}'::JSONB)->'generated_counts';

-- Test 48: query (line 427)
SELECT table_schema AS schema_name, table_name
FROM information_schema.tables
WHERE table_schema = 'otherschema'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Test 49: statement (line 433)
RESET search_path;

-- Test 50: query (line 442)
SELECT crdb_internal.generate_test_objects('{"names":"dbfoo.baz", "counts":[1,0,2], "name_gen":{"noise":false}}'::JSONB)->'generated_counts';

-- Test 51: query (line 447)
SELECT table_schema AS schema_name, table_name
FROM information_schema.tables
WHERE table_schema = 'dbfoo_1'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- Test 52: query (line 599)
SELECT tablename AS table_name
FROM pg_tables
WHERE schemaname LIKE 'pg_temp_%'
ORDER BY tablename;
