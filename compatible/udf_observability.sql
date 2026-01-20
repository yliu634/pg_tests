-- PostgreSQL compatible tests from udf_observability
-- 17 tests

-- Test 1: statement (line 4)
CREATE USER u_test_event;
CREATE SCHEMA sc_test_event;
DELETE FROM system.eventlog;

-- Test 2: statement (line 9)
CREATE FUNCTION f_test_log() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;

-- Test 3: query (line 15)
WITH tmp AS (
  SELECT "eventType" AS etype, info::JSONB AS info_json
  FROM system.eventlog
  WHERE "eventType" = 'create_function'
)
SELECT etype, info_json->'DescriptorID', info_json->'FunctionName', info_json->'Statement' FROM tmp;

-- Test 4: statement (line 25)
CREATE OR REPLACE FUNCTION f_test_log() RETURNS INT LANGUAGE SQL AS $$ SELECT 2 $$;

onlyif config local-legacy-schema-changer

-- Test 5: query (line 29)
WITH tmp AS (
  SELECT "eventType" AS etype, info::JSONB AS info_json
  FROM system.eventlog
  WHERE "eventType" = 'create_function'
)
SELECT etype, info_json->'DescriptorID', info_json->'FunctionName', info_json->'Statement'
FROM tmp
ORDER BY 4

-- Test 6: statement (line 42)
ALTER FUNCTION f_test_log RENAME TO f_test_log_new;

onlyif config local-legacy-schema-changer

-- Test 7: query (line 46)
WITH tmp AS (
  SELECT "eventType" AS etype, info::JSONB AS info_json
  FROM system.eventlog
  WHERE "eventType" = 'rename_function'
)
SELECT etype, info_json->'DescriptorID', info_json->'FunctionName', info_json->'NewFunctionName', info_json->'Statement' FROM tmp;

-- Test 8: statement (line 56)
ALTER FUNCTION f_test_log_new RENAME TO f_test_log;

-- Test 9: statement (line 59)
ALTER FUNCTION f_test_log OWNER TO u_test_event;

onlyif config local-legacy-schema-changer

-- Test 10: query (line 63)
WITH tmp AS (
  SELECT "eventType" AS etype, info::JSONB AS info_json
  FROM system.eventlog
  WHERE "eventType" = 'alter_function_owner'
)
SELECT etype, info_json->'DescriptorID', info_json->'FunctionName', info_json->'Owner', info_json->'Statement' FROM tmp;

-- Test 11: statement (line 73)
ALTER FUNCTION f_test_log SET SCHEMA sc_test_event;

onlyif config local-legacy-schema-changer

-- Test 12: query (line 77)
WITH tmp AS (
  SELECT "eventType" AS etype, info::JSONB AS info_json
  FROM system.eventlog
  WHERE "eventType" = 'set_schema'
)
SELECT etype, info_json->'DescriptorID', info_json->'DescriptorName', info_json->'NewDescriptorName', info_json->'Statement' FROM tmp;

-- Test 13: statement (line 87)
ALTER FUNCTION sc_test_event.f_test_log SET SCHEMA public;
ALTER FUNCTION f_test_log IMMUTABLE;
DROP FUNCTION f_test_log;

onlyif config local-legacy-schema-changer

-- Test 14: query (line 93)
WITH tmp AS (
  SELECT "eventType" AS etype, info::JSONB AS info_json
  FROM system.eventlog
  WHERE "eventType" = 'alter_function_options'
)
SELECT etype, info_json->'DescriptorID', info_json->'FunctionName', info_json->'Statement' FROM tmp;

-- Test 15: query (line 104)
WITH tmp AS (
  SELECT "eventType" AS etype, info::JSONB AS info_json
  FROM system.eventlog
  WHERE "eventType" = 'drop_function'
)
SELECT etype, info_json->'DescriptorID', info_json->'FunctionName', info_json->'Statement' FROM tmp;

-- Test 16: statement (line 120)
CREATE TABLE trace_tab (
  a INT PRIMARY KEY
);
INSERT INTO trace_tab VALUES (1), (2), (3);
CREATE FUNCTION trace_fn(i INT) RETURNS INT LANGUAGE SQL AS $$
  SELECT 'no-op';
  SELECT i;
$$

-- Test 17: statement (line 133)
SELECT trace_fn(a) FROM trace_tab

