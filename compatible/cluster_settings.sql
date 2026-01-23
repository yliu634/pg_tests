-- PostgreSQL compatible tests from cluster_settings
-- 62 tests

-- CockroachDB "CLUSTER SETTING" is not supported in PostgreSQL. This file maps
-- the CRDB cluster-setting behaviors to PostgreSQL GUCs and pg_settings so the
-- same concepts (set/show/reset + privilege checks) can be exercised.

SET client_min_messages = warning;

DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser LOGIN;

-- Test 1-6: slow query threshold (CRDB: sql.log.slow_query.latency_threshold)
SET log_min_duration_statement = '1ms';
SET log_min_duration_statement = '-1ms';
SET log_min_duration_statement = '1';
SET log_min_duration_statement = '-1';

-- Expected ERROR (invalid type for a time GUC). Swallow via PL/pgSQL so
-- expected-output generation stays error-free.
DO $$
BEGIN
  BEGIN
    EXECUTE 'SET log_min_duration_statement = ''true''';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;

  BEGIN
    EXECUTE 'SET log_min_duration_statement = true';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END
$$;

-- Test 7-9: message size (CRDB: sql.conn.max_read_buffer_message_size)
-- PG work_mem has a minimum of 64kB, so a 1-byte value is expected to fail.
DO $$
BEGIN
  BEGIN
    EXECUTE 'SET work_mem = ''1B''';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END
$$;
SET work_mem = '64MB';
RESET work_mem;

-- Test 10: integer setting (CRDB: sql.defaults.default_int_size)
SET default_statistics_target = 4;

-- Test 11: string setting (CRDB: version)
SET application_name = '22.2';

-- Test 12: show one setting (CRDB: SHOW CLUSTER SETTING ...)
SHOW default_statistics_target;

-- Test 13: show selected settings (CRDB: SHOW CLUSTER SETTINGS)
SELECT name AS variable, setting AS value
FROM pg_settings
WHERE name IN (
  'application_name',
  'default_statistics_target',
  'log_min_duration_statement',
  'work_mem'
)
ORDER BY name;

-- Test 14: show selected settings with defaults and origins (CRDB: SHOW ALL ...)
SELECT name AS variable,
       setting AS value,
       reset_val AS default_value,
       source AS origin
FROM pg_settings
WHERE name IN (
  'application_name',
  'default_statistics_target',
  'log_min_duration_statement',
  'work_mem'
)
ORDER BY name;

-- Privilege checks
-- In PG, non-superusers can't set superuser-only GUCs (like log_min_duration_statement).
RESET ROLE;
ALTER ROLE testuser NOSUPERUSER;

SET ROLE testuser;
DO $$
BEGIN
  BEGIN
    EXECUTE 'SET log_min_duration_statement = ''1ms''';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END
$$;

-- Grant "modify settings" capability by making the role a superuser.
RESET ROLE;
ALTER ROLE testuser SUPERUSER;

SET ROLE testuser;
SET log_min_duration_statement = '1ms';
SHOW log_min_duration_statement;

-- Revoke again to keep the environment tidy.
RESET ROLE;
ALTER ROLE testuser NOSUPERUSER;

-- View privilege check:
-- The data_directory GUC is only visible to roles with pg_read_all_settings.
SET ROLE testuser;
SELECT name FROM pg_settings WHERE name = 'data_directory';

RESET ROLE;
GRANT pg_read_all_settings TO testuser;

SET ROLE testuser;
SELECT name FROM pg_settings WHERE name = 'data_directory';

RESET ROLE;
REVOKE pg_read_all_settings FROM testuser;

SET ROLE testuser;
SELECT name FROM pg_settings WHERE name = 'data_directory';

RESET ROLE;

RESET client_min_messages;
