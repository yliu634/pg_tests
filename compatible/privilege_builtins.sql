-- PostgreSQL compatible tests from privilege_builtins
-- 171 tests

-- Setup: this file contains many expected-error cases and is frequently rerun
-- during adaptation. Keep it idempotent and let psql continue on errors.
SET client_min_messages = warning;
DROP ROLE IF EXISTS my_role;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS some_users;
DROP ROLE IF EXISTS all_user_schema;
DROP ROLE IF EXISTS all_user_db;
DROP ROLE IF EXISTS bar;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;
-- Capture the harness-created database name so we can refer to it in GRANTs.
SELECT current_database() AS orig_db \gset
-- Use a per-run database name for the cross-database tests to avoid collisions.
SELECT current_database() || '_my_db' AS my_db \gset
DROP DATABASE IF EXISTS :"my_db";
RESET client_min_messages;

\set ON_ERROR_STOP 0

-- Test 1: statement (line 2)
CREATE USER root SUPERUSER; CREATE USER bar; CREATE USER all_user_db; CREATE USER all_user_schema; CREATE USER testuser;

-- Test 2: statement (line 5)
CREATE SCHEMA test_schema;

-- Test 3: statement (line 8)
GRANT CREATE ON DATABASE :"orig_db" TO bar;

-- Test 4: statement (line 11)
GRANT CONNECT ON DATABASE :"orig_db" TO testuser;

-- Test 5: statement (line 14)
GRANT CREATE ON SCHEMA test_schema TO bar;

-- Test 6: statement (line 17)
GRANT CREATE ON SCHEMA test_schema TO testuser;

-- Test 7: statement (line 20)
GRANT USAGE ON SCHEMA test_schema TO testuser;

-- Test 8: statement (line 23)
GRANT ALL ON DATABASE :"orig_db" TO all_user_db;

-- Test 9: statement (line 26)
GRANT ALL ON SCHEMA test_schema to all_user_schema;

-- Test 10: statement (line 29)
CREATE TABLE t (a INT, b INT);

-- Test 11: statement (line 32)
GRANT DELETE ON t TO bar;

-- Test 12: statement (line 35)
CREATE SEQUENCE seq;

-- Test 13: statement (line 38)
GRANT SELECT ON seq TO bar;

-- Test 14: statement (line 41)
GRANT SELECT ON seq TO testuser;

-- Test 15: query (line 47)
SELECT has_any_column_privilege(12345, 'SELECT'),
       has_any_column_privilege(12345, 'INSERT'),
       has_any_column_privilege(12345, 'UPDATE'),
       has_any_column_privilege(12345, 'REFERENCES');

-- Test 16: query (line 55)
SELECT has_any_column_privilege(12345::OID::REGCLASS, 'SELECT'),
       has_any_column_privilege(12345::OID::REGCLASS, 'INSERT'),
       has_any_column_privilege(12345::OID::REGCLASS, 'UPDATE'),
       has_any_column_privilege(12345::OID::REGCLASS, 'REFERENCES');

-- Test 17: query (line 63)
SELECT has_any_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'SELECT'),
       has_any_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'INSERT'),
       has_any_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'UPDATE'),
       has_any_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'REFERENCES');

-- Test 18: query (line 71)
SELECT has_any_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'SELECT'),
       has_any_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'INSERT'),
       has_any_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'UPDATE'),
       has_any_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'REFERENCES');

-- Test 19: query (line 79)
SELECT has_any_column_privilege('does_not_exist', 'SELECT');

-- query BBBBBB
SELECT has_any_column_privilege('pg_type', 'SELECT'),
       has_any_column_privilege('pg_type', 'INSERT'),
       has_any_column_privilege('pg_type', 'UPDATE'),
       has_any_column_privilege('pg_type', 'REFERENCES'),
       has_any_column_privilege('pg_type', 'SELECT, INSERT, UPDATE'),
       has_any_column_privilege('pg_type', 'INSERT, UPDATE');

-- Test 20: query (line 92)
SELECT has_any_column_privilege('t', 'SELECT'),
       has_any_column_privilege('t', 'INSERT'),
       has_any_column_privilege('t', 'UPDATE'),
       has_any_column_privilege('t', 'REFERENCES'),
       has_any_column_privilege('t', 'SELECT, INSERT, UPDATE');

-- Test 21: query (line 101)
SELECT has_any_column_privilege('t', 'SELECT WITH GRANT OPTION'),
       has_any_column_privilege('t', 'INSERT WITH GRANT OPTION'),
       has_any_column_privilege('t', 'UPDATE WITH GRANT OPTION'),
       has_any_column_privilege('t', 'REFERENCES WITH GRANT OPTION'),
       has_any_column_privilege('t', 'SELECT WITH GRANT OPTION, INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION');

-- Test 22: query (line 110)
SELECT has_any_column_privilege('t'::Name, 'SELECT'),
       has_any_column_privilege('t'::Name, 'INSERT'),
       has_any_column_privilege('t'::Name, 'UPDATE'),
       has_any_column_privilege('t'::Name, 'REFERENCES'),
       has_any_column_privilege('t'::Name, 'SELECT, INSERT, UPDATE');

-- Test 23: query (line 119)
SELECT has_any_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), '');

-- query error pgcode 22023 unrecognized privilege type: "USAGE"
SELECT has_any_column_privilege('t', 'USAGE');

-- query error pgcode 22023 unrecognized privilege type: "USAGE"
SELECT has_any_column_privilege('t', 'SELECT, USAGE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_any_column_privilege('no_user', 't', 'SELECT');

-- query BBBBB
SELECT has_any_column_privilege('bar', 't', 'SELECT'),
       has_any_column_privilege('bar', 't', 'INSERT'),
       has_any_column_privilege('bar', 't', 'UPDATE'),
       has_any_column_privilege('bar', 't', 'REFERENCES'),
       has_any_column_privilege('bar', 't', 'SELECT, INSERT, UPDATE');

-- Test 24: query (line 140)
SELECT has_any_column_privilege('bar', 't', 'SELECT WITH GRANT OPTION'),
       has_any_column_privilege('bar', 't', 'INSERT WITH GRANT OPTION'),
       has_any_column_privilege('bar', 't', 'UPDATE WITH GRANT OPTION'),
       has_any_column_privilege('bar', 't', 'REFERENCES WITH GRANT OPTION'),
       has_any_column_privilege('bar', 't', 'SELECT WITH GRANT OPTION, INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION');

-- Test 25: query (line 152)
SELECT has_column_privilege(12345, 1, 'SELECT'),
       has_column_privilege(12345, 1, 'INSERT'),
       has_column_privilege(12345, 1, 'UPDATE'),
       has_column_privilege(12345, 1, 'REFERENCES');

-- Test 26: query (line 160)
SELECT has_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 1, 'SELECT'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 1, 'INSERT'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 1, 'UPDATE'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 1, 'REFERENCES');

-- Test 27: query (line 168)
SELECT has_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 1, 'SELECT'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 2, 'INSERT'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 1, 'UPDATE'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 2, 'REFERENCES');

-- Test 28: query (line 176)
SELECT has_column_privilege('does_not_exist', 1, 'SELECT');

-- query error pgcode 42703 column 100 of relation pg_type does not exist
SELECT has_column_privilege('pg_type', 100, 'SELECT');

-- query error pgcode 42703 column 100 of relation pg_type does not exist
SELECT has_column_privilege('pg_type'::regclass, 100, 'SELECT');

-- query BBBBBB
SELECT has_column_privilege('pg_type', 1, 'SELECT'),
       has_column_privilege('pg_type', 1, 'INSERT'),
       has_column_privilege('pg_type', 1, 'UPDATE'),
       has_column_privilege('pg_type', 1, 'REFERENCES'),
       has_column_privilege('pg_type', 1, 'SELECT, INSERT, UPDATE'),
       has_column_privilege('pg_type', 1, 'INSERT, UPDATE');

-- Test 29: query (line 195)
SELECT has_column_privilege('t', 1, 'SELECT'),
       has_column_privilege('t', 1, 'INSERT'),
       has_column_privilege('t', 1, 'UPDATE'),
       has_column_privilege('t', 1, 'REFERENCES'),
       has_column_privilege('t', 1, 'SELECT, INSERT, UPDATE');

-- Test 30: query (line 204)
SELECT has_column_privilege('t', 1, 'SELECT WITH GRANT OPTION'),
       has_column_privilege('t', 1, 'INSERT WITH GRANT OPTION'),
       has_column_privilege('t', 1, 'UPDATE WITH GRANT OPTION'),
       has_column_privilege('t', 1, 'REFERENCES WITH GRANT OPTION'),
       has_column_privilege('t', 1, 'SELECT WITH GRANT OPTION, INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION');

-- Test 31: query (line 213)
SELECT has_column_privilege('t', 1, 'USAGE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_column_privilege('no_user', 't', 1, 'SELECT');

-- query BBBBB
SELECT has_column_privilege('bar', 't', 1, 'SELECT'),
       has_column_privilege('bar', 't', 1, 'INSERT'),
       has_column_privilege('bar', 't', 1, 'UPDATE'),
       has_column_privilege('bar', 't', 1, 'REFERENCES'),
       has_column_privilege('bar', 't', 1, 'SELECT, INSERT, UPDATE');

-- Test 32: query (line 228)
SELECT has_column_privilege('bar', 't', 1, 'SELECT WITH GRANT OPTION'),
       has_column_privilege('bar', 't', 1, 'INSERT WITH GRANT OPTION'),
       has_column_privilege('bar', 't', 1, 'UPDATE WITH GRANT OPTION'),
       has_column_privilege('bar', 't', 1, 'REFERENCES WITH GRANT OPTION'),
       has_column_privilege('bar', 't', 1, 'SELECT WITH GRANT OPTION, INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION');

-- Test 33: query (line 237)
SELECT has_column_privilege(12345, 'col', 'SELECT'),
       has_column_privilege(12345, 'col', 'INSERT'),
       has_column_privilege(12345, 'col', 'UPDATE'),
       has_column_privilege(12345, 'col', 'REFERENCES');

-- Test 34: query (line 245)
SELECT has_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'typname', 'SELECT'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'typname', 'INSERT'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'typname', 'UPDATE'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'typname', 'REFERENCES');

-- Test 35: query (line 253)
SELECT has_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'a', 'SELECT'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'b', 'INSERT'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'a', 'UPDATE'),
       has_column_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'b', 'REFERENCES');

-- Test 36: query (line 261)
SELECT has_column_privilege('does_not_exist', 'col', 'SELECT');

-- query error pgcode 42703 column "does not exist" does not exist
SELECT has_column_privilege('pg_type', 'does not exist', 'SELECT');

-- query error pgcode 42703 column "does not exist" does not exist
SELECT has_column_privilege('pg_type'::regclass, 'does not exist', 'SELECT');

-- query BBBBBB
SELECT has_column_privilege('pg_type', 'typname', 'SELECT'),
       has_column_privilege('pg_type', 'typname', 'INSERT'),
       has_column_privilege('pg_type', 'typname', 'UPDATE'),
       has_column_privilege('pg_type', 'typname', 'REFERENCES'),
       has_column_privilege('pg_type', 'typname', 'SELECT, INSERT, UPDATE'),
       has_column_privilege('pg_type', 'typname', 'INSERT, UPDATE');

-- Test 37: query (line 280)
SELECT has_column_privilege('t', 'a', 'SELECT'),
       has_column_privilege('t', 'a', 'INSERT'),
       has_column_privilege('t', 'a', 'UPDATE'),
       has_column_privilege('t', 'a', 'REFERENCES'),
       has_column_privilege('t', 'a', 'SELECT, INSERT, UPDATE');

-- Test 38: query (line 289)
SELECT has_column_privilege('t', 'a', 'SELECT WITH GRANT OPTION'),
       has_column_privilege('t', 'a', 'INSERT WITH GRANT OPTION'),
       has_column_privilege('t', 'a', 'UPDATE WITH GRANT OPTION'),
       has_column_privilege('t', 'a', 'REFERENCES WITH GRANT OPTION'),
       has_column_privilege('t', 'a', 'SELECT WITH GRANT OPTION, INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION');

-- Test 39: query (line 298)
SELECT has_column_privilege('t'::Name, 'a'::Name, 'SELECT WITH GRANT OPTION'),
       has_column_privilege('t'::Name, 'a'::Name, 'INSERT WITH GRANT OPTION'),
       has_column_privilege('t'::Name, 'a'::Name, 'UPDATE WITH GRANT OPTION'),
       has_column_privilege('t'::Name, 'a'::Name, 'REFERENCES WITH GRANT OPTION'),
       has_column_privilege('t'::Name, 'a'::Name, 'SELECT WITH GRANT OPTION, INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION');

-- Test 40: query (line 307)
SELECT has_column_privilege('t', 'a', 'USAGE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_column_privilege('no_user', 't', 'a', 'SELECT');

-- query BBBBB
SELECT has_column_privilege('bar', 't', 'a', 'SELECT'),
       has_column_privilege('bar', 't', 'a', 'INSERT'),
       has_column_privilege('bar', 't', 'a', 'UPDATE'),
       has_column_privilege('bar', 't', 'a', 'REFERENCES'),
       has_column_privilege('bar', 't', 'a', 'SELECT, INSERT, UPDATE');

-- Test 41: query (line 322)
SELECT has_column_privilege('bar', 't', 'a', 'SELECT WITH GRANT OPTION'),
       has_column_privilege('bar', 't', 'a', 'INSERT WITH GRANT OPTION'),
       has_column_privilege('bar', 't', 'a', 'UPDATE WITH GRANT OPTION'),
       has_column_privilege('bar', 't', 'a', 'REFERENCES WITH GRANT OPTION'),
       has_column_privilege('bar', 't', 'a', 'SELECT WITH GRANT OPTION, INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION');

-- Test 42: query (line 334)
SELECT has_database_privilege(12345, 'CREATE'),
       has_database_privilege(12345, 'CONNECT'),
       has_database_privilege(12345, 'TEMPORARY'),
       has_database_privilege(12345, 'TEMP');

-- Test 43: query (line 342)
SELECT has_database_privilege((SELECT oid FROM pg_database WHERE datname = 'template1'), 'CREATE'),
       has_database_privilege((SELECT oid FROM pg_database WHERE datname = 'template1'), 'CONNECT'),
       has_database_privilege((SELECT oid FROM pg_database WHERE datname = 'template1'), 'TEMPORARY'),
       has_database_privilege((SELECT oid FROM pg_database WHERE datname = 'template1'), 'TEMP');

-- Test 44: query (line 350)
SELECT has_database_privilege((SELECT oid FROM pg_database WHERE datname = current_database()), 'CREATE'),
       has_database_privilege((SELECT oid FROM pg_database WHERE datname = current_database()), 'CONNECT'),
       has_database_privilege((SELECT oid FROM pg_database WHERE datname = current_database()), 'TEMPORARY'),
       has_database_privilege((SELECT oid FROM pg_database WHERE datname = current_database()), 'TEMP');

-- Test 45: query (line 358)
SELECT has_database_privilege('does_not_exist', 'CREATE');

-- query BBBBB
SELECT has_database_privilege('template1', '  CrEaTe      '),
       has_database_privilege('template1', '      CONNECT'),
       has_database_privilege('template1', 'TEMPORARY'),
       has_database_privilege('template1', 'TEMP'),
       has_database_privilege('template1', '  CrEaTe      ,CONNECT');

-- Test 46: query (line 370)
SELECT has_database_privilege(current_database(), '  CrEaTe      '),
       has_database_privilege(current_database(), '      CONNECT'),
       has_database_privilege(current_database(), 'TEMPORARY'),
       has_database_privilege(current_database(), 'TEMP'),
       has_database_privilege(current_database(), '  CrEaTe      ,CONNECT');

-- Test 47: query (line 379)
SELECT has_database_privilege(current_database(), 'CREATE WITH GRANT OPTION'),
       has_database_privilege(current_database(), 'CONNECT WITH GRANT OPTION'),
       has_database_privilege(current_database(), 'TEMPORARY WITH GRANT OPTION'),
       has_database_privilege(current_database(), 'TEMP WITH GRANT OPTION'),
       has_database_privilege(current_database(), 'CREATE WITH GRANT OPTION, CONNECT WITH GRANT OPTION');

-- Test 48: query (line 388)
SELECT has_database_privilege(current_database()::Name, 'CREATE'),
       has_database_privilege(current_database()::Name, 'CONNECT'),
       has_database_privilege(current_database()::Name, 'TEMPORARY'),
       has_database_privilege(current_database()::Name, 'TEMP'),
       has_database_privilege(current_database()::Name, 'CREATE, CONNECT');

-- Test 49: query (line 397)
SELECT datname FROM pg_database WHERE has_database_privilege(datname, 'CREATE') ORDER BY datname;

-- Test 50: query (line 404)
SELECT datname FROM pg_database WHERE has_database_privilege(datname, 'CONNECT') ORDER BY datname;

-- Test 51: query (line 412)
SELECT datname FROM pg_database WHERE has_database_privilege(datname, 'TEMP') ORDER BY datname;

-- Test 52: query (line 419)
SELECT datname FROM pg_database WHERE has_database_privilege(datname, 'TEMPORARY') ORDER BY datname;

-- Test 53: query (line 426)
SELECT has_database_privilege(current_database(), 'UPDATE');

-- query error pgcode 22023 unrecognized privilege type: "UPDATE"
SELECT has_database_privilege(current_database(), 'CREATE, UPDATE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_database_privilege('no_user', current_database(), 'CREATE');

-- query BBBBBB
SELECT has_database_privilege('bar', current_database(), 'CREATE'),
       has_database_privilege('bar', current_database(), 'CONNECT'),
       has_database_privilege('bar', current_database(), 'TEMPORARY'),
       has_database_privilege('bar', current_database(), 'TEMP'),
       has_database_privilege('bar', current_database(), 'CREATE, CONNECT'),
       has_database_privilege('bar', current_database(), 'CREATE, TEMP');

-- Test 54: statement (line 445)
GRANT CONNECT ON DATABASE :"orig_db" TO bar;

-- Test 55: query (line 448)
SELECT has_database_privilege('bar', current_database(), 'CONNECT');

-- Test 56: query (line 453)
SELECT has_database_privilege('bar', current_database(), 'CREATE WITH GRANT OPTION'),
       has_database_privilege('bar', current_database(), 'CONNECT WITH GRANT OPTION'),
       has_database_privilege('bar', current_database(), 'TEMPORARY WITH GRANT OPTION'),
       has_database_privilege('bar', current_database(), 'TEMP WITH GRANT OPTION'),
       has_database_privilege('bar', current_database(), 'CREATE WITH GRANT OPTION, CONNECT WITH GRANT OPTION'),
       has_database_privilege('bar', current_database(), 'CREATE WITH GRANT OPTION, TEMP WITH GRANT OPTION');

-- Test 57: query (line 466)
SELECT has_foreign_data_wrapper_privilege(12345, 'USAGE');

-- Test 58: query (line 471)
SELECT has_foreign_data_wrapper_privilege('does_not_exist', 'USAGE');

-- query error pgcode 42704 foreign-data wrapper 'does_not_exist' does not exist
SELECT has_foreign_data_wrapper_privilege('does_not_exist'::Name, 'USAGE');

-- query B
SELECT has_foreign_data_wrapper_privilege(12345, 'USAGE WITH GRANT OPTION');

-- Test 59: query (line 482)
SELECT has_foreign_data_wrapper_privilege(12345, 'UPDATE');

-- query error pgcode 22023 unrecognized privilege type: "UPDATE"
SELECT has_foreign_data_wrapper_privilege(12345, 'USAGE, UPDATE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_foreign_data_wrapper_privilege('no_user', 12345, 'USAGE');

-- query B
SELECT has_foreign_data_wrapper_privilege('bar', 12345, 'USAGE');

-- Test 60: query (line 499)
SELECT has_function_privilege(12345, 'EXECUTE');

-- Test 61: query (line 504)
SELECT has_function_privilege((SELECT oid FROM pg_proc LIMIT 1), 'EXECUTE');

-- Test 62: query (line 509)
SELECT has_function_privilege('does_not_exist', 'EXECUTE');

-- query error pgcode 42883 unknown function: does_not_exist()
SELECT has_function_privilege('does_not_exist()', 'EXECUTE');

-- query B
SELECT has_function_privilege('version()', '  EXECUTE      ');

-- Test 63: query (line 520)
SELECT has_function_privilege('version()', 'EXECUTE');

-- Test 64: query (line 525)
SELECT has_function_privilege('cos(float)', 'EXECUTE WITH GRANT OPTION');

-- Test 65: query (line 530)
SELECT has_function_privilege('cos(float)', 'EXECUTE, EXECUTE WITH GRANT OPTION');

-- Test 66: query (line 535)
SELECT has_function_privilege('version()'::Name, 'EXECUTE');

-- Test 67: query (line 540)
SELECT has_function_privilege('acos(float)', 'UPDATE');

-- query error pgcode 22023 unrecognized privilege type: "UPDATE"
SELECT has_function_privilege('acos(float)', 'EXECUTE, UPDATE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_function_privilege('no_user', 'acos(float)', 'EXECUTE');

-- query B
SELECT has_function_privilege('bar', 'current_date'::REGPROC, 'EXECUTE');

-- Test 68: query (line 554)
SELECT has_function_privilege('bar', 'current_date'::REGPROC::OID, 'EXECUTE');

-- Test 69: query (line 562)
SELECT has_language_privilege(12345, 'USAGE');

-- Test 70: query (line 567)
SELECT has_language_privilege('does_not_exist', 'USAGE');

-- query error pgcode 42704 language 'does_not_exist' does not exist
SELECT has_language_privilege('does_not_exist'::Name, 'USAGE');

-- query B
SELECT has_language_privilege(12345, 'USAGE WITH GRANT OPTION');

-- Test 71: query (line 578)
SELECT has_language_privilege(12345, 'UPDATE');

-- query error pgcode 22023 unrecognized privilege type: "UPDATE"
SELECT has_language_privilege(12345, 'USAGE, UPDATE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_language_privilege('no_user', 12345, 'USAGE');

-- query B
SELECT has_language_privilege('bar', 12345, 'USAGE');

-- Test 72: query (line 595)
SELECT has_schema_privilege(12345, 'CREATE'),
       has_schema_privilege(12345, 'USAGE');

-- Test 73: query (line 601)
SELECT has_schema_privilege((SELECT oid FROM pg_namespace WHERE nspname = 'crdb_internal'), 'CREATE'),
       has_schema_privilege((SELECT oid FROM pg_namespace WHERE nspname = 'crdb_internal'), 'USAGE');

-- Test 74: query (line 607)
SELECT has_schema_privilege((SELECT oid FROM pg_namespace WHERE nspname = 'pg_catalog'), 'CREATE'),
       has_schema_privilege((SELECT oid FROM pg_namespace WHERE nspname = 'pg_catalog'), 'USAGE');

-- Test 75: query (line 613)
SELECT has_schema_privilege((SELECT oid FROM pg_namespace WHERE nspname = 'public'), 'CREATE'),
       has_schema_privilege((SELECT oid FROM pg_namespace WHERE nspname = 'public'), 'USAGE');

-- Test 76: query (line 619)
SELECT has_schema_privilege('does_not_exist', 'CREATE');

-- query BBB
SELECT has_schema_privilege('public', 'CREATE'),
       has_schema_privilege('public', 'USAGE'),
       has_schema_privilege('public', 'CREATE, USAGE');

-- Test 77: query (line 629)
SELECT has_schema_privilege('public', 'CREATE WITH GRANT OPTION'),
       has_schema_privilege('public', 'USAGE WITH GRANT OPTION'),
       has_schema_privilege('public', 'CREATE WITH GRANT OPTION, USAGE WITH GRANT OPTION');

-- Test 78: query (line 636)
SELECT has_schema_privilege('public'::Name, 'CREATE'),
       has_schema_privilege('public'::Name, 'USAGE'),
       has_schema_privilege('public'::Name, 'CREATE, USAGE');

-- Test 79: query (line 643)
SELECT has_schema_privilege('public', 'UPDATE');

-- query error pgcode 22023 unrecognized privilege type: "UPDATE"
SELECT has_schema_privilege('public', 'CREATE, UPDATE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_schema_privilege('no_user', 'public', 'CREATE');

-- query BBB
SELECT has_schema_privilege('bar', 'public', 'CREATE'),
       has_schema_privilege('bar', 'public', 'USAGE'),
       has_schema_privilege('bar', 'public', 'CREATE, USAGE');

-- Test 80: query (line 659)
SELECT has_schema_privilege('bar', 'public', 'CREATE WITH GRANT OPTION'),
       has_schema_privilege('bar', 'public', 'USAGE WITH GRANT OPTION'),
       has_schema_privilege('bar', 'public', 'CREATE WITH GRANT OPTION, USAGE WITH GRANT OPTION');

-- Test 81: query (line 666)
SELECT has_schema_privilege('testuser', 'public', 'CREATE'),
       has_schema_privilege('testuser', 'public', 'USAGE'),
       has_schema_privilege('testuser', 'public', 'CREATE, USAGE');

-- Test 82: query (line 673)
SELECT has_schema_privilege('bar', 'test_schema', 'CREATE'),
       has_schema_privilege('bar', 'test_schema', 'USAGE'),
       has_schema_privilege('bar', 'test_schema', 'CREATE, USAGE');

-- Test 83: query (line 680)
SELECT has_schema_privilege('testuser', 'test_schema', 'CREATE'),
       has_schema_privilege('testuser', 'test_schema', 'USAGE'),
       has_schema_privilege('testuser', 'test_schema', 'CREATE, USAGE');

-- Test 84: query (line 687)
SELECT has_schema_privilege('all_user_db', 'public', 'CREATE'),
       has_schema_privilege('all_user_db', 'public', 'USAGE'),
       has_schema_privilege('all_user_db', 'public', 'CREATE, USAGE');

-- Test 85: query (line 694)
SELECT has_schema_privilege('all_user_db', 'test_schema', 'CREATE'),
       has_schema_privilege('all_user_db', 'test_schema', 'USAGE'),
       has_schema_privilege('all_user_db', 'test_schema', 'CREATE, USAGE');

-- Test 86: query (line 701)
SELECT has_schema_privilege('all_user_schema', 'public', 'CREATE'),
       has_schema_privilege('all_user_schema', 'public', 'USAGE'),
       has_schema_privilege('all_user_schema', 'public', 'CREATE, USAGE');

-- Test 87: query (line 708)
SELECT has_schema_privilege('all_user_schema', 'test_schema', 'CREATE'),
       has_schema_privilege('all_user_schema', 'test_schema', 'USAGE'),
       has_schema_privilege('all_user_schema', 'test_schema', 'CREATE, USAGE');

-- Test 88: query (line 718)
SELECT has_sequence_privilege(12345, 'USAGE'),
       has_sequence_privilege(12345, 'SELECT'),
       has_sequence_privilege(12345, 'UPDATE');

-- Test 89: query (line 725)
SELECT has_sequence_privilege((SELECT oid FROM pg_class WHERE relname = 'seq'), 'USAGE'),
       has_sequence_privilege((SELECT oid FROM pg_class WHERE relname = 'seq'), 'SELECT'),
       has_sequence_privilege((SELECT oid FROM pg_class WHERE relname = 'seq'), 'UPDATE');

-- Test 90: query (line 732)
SELECT has_sequence_privilege('does_not_exist', 'SELECT');

-- query error pgcode 42809 "t" is not a sequence
SELECT has_sequence_privilege('t', 'SELECT');

-- query BBB
SELECT has_sequence_privilege('seq', 'USAGE'),
       has_sequence_privilege('seq', 'SELECT'),
       has_sequence_privilege('seq', 'UPDATE');

-- Test 91: query (line 745)
SELECT has_sequence_privilege('seq', 'USAGE WITH GRANT OPTION'),
       has_sequence_privilege('seq', 'SELECT WITH GRANT OPTION'),
       has_sequence_privilege('seq', 'UPDATE WITH GRANT OPTION');

-- Test 92: query (line 752)
SELECT has_sequence_privilege('seq'::Name, 'USAGE'),
       has_sequence_privilege('seq'::Name, 'SELECT'),
       has_sequence_privilege('seq'::Name, 'UPDATE');

-- Test 93: query (line 759)
SELECT has_sequence_privilege('seq', 'DELETE');

-- query error pgcode 22023 unrecognized privilege type: "DELETE"
SELECT has_sequence_privilege('seq', 'SELECT, DELETE');

-- user testuser

-- query BBB
SELECT has_sequence_privilege('seq', 'USAGE'),
       has_sequence_privilege('seq', 'SELECT'),
       has_sequence_privilege('seq', 'UPDATE');

-- Test 94: query (line 774)
SELECT has_sequence_privilege('seq', 'USAGE WITH GRANT OPTION'),
       has_sequence_privilege('seq', 'SELECT WITH GRANT OPTION'),
       has_sequence_privilege('seq', 'UPDATE WITH GRANT OPTION');

-- Test 95: statement (line 783)
GRANT USAGE, SELECT, UPDATE ON seq TO testuser WITH GRANT OPTION;

-- Test 96: query (line 787)
SELECT has_sequence_privilege('testuser', 'seq', 'USAGE WITH GRANT OPTION'),
       has_sequence_privilege('testuser', 'seq', 'SELECT WITH GRANT OPTION'),
       has_sequence_privilege('testuser', 'seq', 'UPDATE WITH GRANT OPTION');

-- Test 97: statement (line 796)
GRANT SELECT, UPDATE ON seq TO testuser WITH GRANT OPTION;

-- Test 98: query (line 800)
SELECT has_sequence_privilege('testuser', 'seq', 'USAGE WITH GRANT OPTION'),
       has_sequence_privilege('testuser', 'seq', 'SELECT WITH GRANT OPTION'),
       has_sequence_privilege('testuser', 'seq', 'UPDATE WITH GRANT OPTION');

-- Test 99: query (line 807)
SELECT has_sequence_privilege('no_user', 'seq', 'SELECT');

-- query BBB
SELECT has_sequence_privilege('bar', 'seq', 'USAGE'),
       has_sequence_privilege('bar', 'seq', 'SELECT'),
       has_sequence_privilege('bar', 'seq', 'UPDATE');

-- Test 100: query (line 817)
SELECT has_sequence_privilege('bar', 'seq', 'USAGE WITH GRANT OPTION'),
       has_sequence_privilege('bar', 'seq', 'SELECT WITH GRANT OPTION'),
       has_sequence_privilege('bar', 'seq', 'UPDATE WITH GRANT OPTION');

-- Test 101: query (line 827)
SELECT has_server_privilege(12345, 'USAGE');

-- Test 102: query (line 832)
SELECT has_server_privilege('does_not_exist', 'USAGE');

-- query error pgcode 42704 server 'does_not_exist' does not exist
SELECT has_server_privilege('does_not_exist'::Name, 'USAGE');

-- query B
SELECT has_server_privilege(12345, 'USAGE WITH GRANT OPTION');

-- Test 103: query (line 843)
SELECT has_server_privilege(12345, 'UPDATE');

-- query error pgcode 22023 unrecognized privilege type: "UPDATE"
SELECT has_server_privilege(12345, 'USAGE, UPDATE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_server_privilege('no_user', 12345, 'USAGE');

-- query B
SELECT has_server_privilege('bar', 12345, 'USAGE');

-- Test 104: query (line 860)
SELECT has_table_privilege(12345, 'SELECT'),
       has_table_privilege(12345, 'INSERT'),
       has_table_privilege(12345, 'UPDATE'),
       has_table_privilege(12345, 'DELETE'),
       has_table_privilege(12345, 'TRUNCATE'),
       has_table_privilege(12345, 'REFERENCES'),
       has_table_privilege(12345, 'TRIGGER'),
       has_table_privilege(12345, 'RULE');

-- Test 105: query (line 872)
SELECT has_table_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'SELECT'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'INSERT'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'UPDATE'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'DELETE'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'TRUNCATE'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'REFERENCES'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'TRIGGER'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 'pg_type'), 'RULE');

-- Test 106: query (line 884)
SELECT has_table_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'SELECT'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'INSERT'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'UPDATE'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'DELETE'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'TRUNCATE'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'REFERENCES'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'TRIGGER'),
       has_table_privilege((SELECT oid FROM pg_class WHERE relname = 't'), 'RULE');

-- Test 107: query (line 896)
SELECT has_table_privilege('does_not_exist', 'SELECT');

-- query BBBBBBBBBBB
SELECT has_table_privilege('pg_type', 'SELECT'),
       has_table_privilege('pg_type', 'INSERT'),
       has_table_privilege('pg_type', 'UPDATE'),
       has_table_privilege('pg_type', 'DELETE'),
       has_table_privilege('pg_type', 'TRUNCATE'),
       has_table_privilege('pg_type', 'REFERENCES'),
       has_table_privilege('pg_type', 'TRIGGER'),
       has_table_privilege('pg_type', 'SELECT, INSERT, UPDATE'),
       has_table_privilege('pg_type', 'SELECT, TRUNCATE'),
       has_table_privilege('pg_type', 'INSERT, UPDATE'),
       has_table_privilege('pg_type', 'RULE');

-- Test 108: query (line 914)
SELECT has_table_privilege('t', 'SELECT'),
       has_table_privilege('t', 'INSERT'),
       has_table_privilege('t', 'UPDATE'),
       has_table_privilege('t', 'DELETE'),
       has_table_privilege('t', 'TRUNCATE'),
       has_table_privilege('t', 'REFERENCES'),
       has_table_privilege('t', 'TRIGGER'),
       has_table_privilege('t', 'SELECT, INSERT, UPDATE'),
       has_table_privilege('t', 'SELECT, TRUNCATE'),
       has_table_privilege('t', 'RULE');

-- Test 109: query (line 928)
SELECT has_table_privilege('t', 'SELECT WITH GRANT OPTION'),
       has_table_privilege('t', 'INSERT WITH GRANT OPTION'),
       has_table_privilege('t', 'UPDATE WITH GRANT OPTION'),
       has_table_privilege('t', 'DELETE WITH GRANT OPTION'),
       has_table_privilege('t', 'TRUNCATE WITH GRANT OPTION'),
       has_table_privilege('t', 'REFERENCES WITH GRANT OPTION'),
       has_table_privilege('t', 'TRIGGER WITH GRANT OPTION'),
       has_table_privilege('t', 'SELECT WITH GRANT OPTION, INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION'),
       has_table_privilege('t', 'SELECT WITH GRANT OPTION, TRUNCATE WITH GRANT OPTION'),
       has_table_privilege('t', 'RULE WITH GRANT OPTION');

-- Test 110: query (line 942)
SELECT has_table_privilege('t'::Name, 'SELECT'),
       has_table_privilege('t'::Name, 'INSERT'),
       has_table_privilege('t'::Name, 'UPDATE'),
       has_table_privilege('t'::Name, 'DELETE'),
       has_table_privilege('t'::Name, 'TRUNCATE'),
       has_table_privilege('t'::Name, 'REFERENCES'),
       has_table_privilege('t'::Name, 'TRIGGER'),
       has_table_privilege('t'::Name, 'SELECT, INSERT, UPDATE'),
       has_table_privilege('t'::Name, 'SELECT, TRUNCATE'),
       has_table_privilege('t'::Name, 'RULE');

-- Test 111: query (line 957)
SELECT has_table_privilege('seq', 'SELECT'),
       has_table_privilege('seq', 'INSERT'),
       has_table_privilege('seq', 'UPDATE'),
       has_table_privilege('seq', 'DELETE'),
       has_table_privilege('seq', 'TRUNCATE'),
       has_table_privilege('seq', 'REFERENCES'),
       has_table_privilege('seq', 'TRIGGER'),
       has_table_privilege('seq', 'SELECT, INSERT, UPDATE'),
       has_table_privilege('seq', 'SELECT, TRUNCATE'),
       has_table_privilege('seq', 'RULE');

-- Test 112: query (line 971)
SELECT has_table_privilege('t', 'USAGE');

-- query error pgcode 22023 unrecognized privilege type: "USAGE"
SELECT has_table_privilege('t', 'SELECT, USAGE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_table_privilege('no_user', 't', 'SELECT');

-- query BBBBBBBBBBB
SELECT has_table_privilege('bar', 't', 'SELECT'),
       has_table_privilege('bar', 't', 'INSERT'),
       has_table_privilege('bar', 't', 'UPDATE'),
       has_table_privilege('bar', 't', 'DELETE'),
       has_table_privilege('bar', 't', 'TRUNCATE'),
       has_table_privilege('bar', 't', 'REFERENCES'),
       has_table_privilege('bar', 't', 'TRIGGER'),
       has_table_privilege('bar', 't', 'SELECT, INSERT, UPDATE'),
       has_table_privilege('bar', 't', 'SELECT, TRUNCATE'),
       has_table_privilege('bar', 't', 'INSERT, UPDATE'),
       has_table_privilege('bar', 't', 'RULE');

-- Test 113: query (line 995)
SELECT has_table_privilege('bar', 't', 'SELECT WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'INSERT WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'UPDATE WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'DELETE WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'TRUNCATE WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'REFERENCES WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'TRIGGER WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'SELECT WITH GRANT OPTION, INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'SELECT WITH GRANT OPTION, TRUNCATE WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'INSERT WITH GRANT OPTION, UPDATE WITH GRANT OPTION'),
       has_table_privilege('bar', 't', 'RULE WITH GRANT OPTION');

-- Test 114: query (line 1013)
SELECT has_tablespace_privilege(12345, 'CREATE');

-- Test 115: query (line 1018)
SELECT has_tablespace_privilege((SELECT oid FROM pg_tablespace LIMIT 1), 'CREATE');

-- Test 116: query (line 1023)
SELECT has_tablespace_privilege('does_not_exist', 'CREATE');

-- query B
SELECT has_tablespace_privilege('pg_default', '  CrEaTe      ');

-- Test 117: query (line 1031)
SELECT has_tablespace_privilege('pg_default', 'CREATE WITH GRANT OPTION');

-- Test 118: query (line 1036)
SELECT has_tablespace_privilege('pg_default'::Name, 'CREATE');

-- Test 119: query (line 1041)
SELECT has_tablespace_privilege('pg_default', 'CREATE    WITH GRANT OPTION');

-- query error pgcode 22023 unrecognized privilege type: "UPDATE"
SELECT has_tablespace_privilege('pg_default', 'UPDATE');

-- query error pgcode 22023 unrecognized privilege type: "UPDATE"
SELECT has_tablespace_privilege('pg_default', 'CREATE, UPDATE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_tablespace_privilege('no_user', 'pg_default', 'CREATE');

-- query B
SELECT has_tablespace_privilege('bar', (SELECT oid FROM pg_tablespace LIMIT 1), 'CREATE');

-- Test 120: query (line 1061)
SELECT has_type_privilege(12345, 'USAGE');

-- Test 121: query (line 1066)
SELECT has_type_privilege((SELECT oid FROM pg_type LIMIT 1), 'USAGE');

-- Test 122: query (line 1071)
SELECT has_type_privilege('does_not_exist', 'USAGE');

-- query B
SELECT has_type_privilege('int', '  USAGE      ');

-- Test 123: query (line 1079)
SELECT has_type_privilege('decimal(18,2)', 'USAGE WITH GRANT OPTION');

-- Test 124: query (line 1084)
SELECT has_type_privilege('int'::Name, 'USAGE');

-- Test 125: query (line 1089)
SELECT has_type_privilege('int4', 'UPDATE');

-- query error pgcode 22023 unrecognized privilege type: "UPDATE"
SELECT has_type_privilege('int4', 'USAGE, UPDATE');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT has_type_privilege('no_user', 'int4', 'USAGE');

-- query B
SELECT has_type_privilege('bar', 'text'::REGTYPE, 'USAGE');

-- Test 126: query (line 1103)
SELECT has_type_privilege('bar', 'text'::REGTYPE::OID, 'USAGE');

-- Test 127: query (line 1111)
SELECT pg_has_role(12345, 'USAGE'),
       pg_has_role(12345, 'USAGE WITH GRANT OPTION'),
       pg_has_role(12345, 'USAGE WITH ADMIN OPTION'),
       pg_has_role(12345, 'MEMBER'),
       pg_has_role(12345, 'MEMBER WITH GRANT OPTION'),
       pg_has_role(12345, 'MEMBER WITH ADMIN OPTION');

-- Test 128: query (line 1121)
SELECT pg_has_role((SELECT oid FROM pg_roles WHERE rolname = 'root'), 'USAGE'),
       pg_has_role((SELECT oid FROM pg_roles WHERE rolname = 'root'), 'USAGE WITH GRANT OPTION'),
       pg_has_role((SELECT oid FROM pg_roles WHERE rolname = 'root'), 'USAGE WITH ADMIN OPTION'),
       pg_has_role((SELECT oid FROM pg_roles WHERE rolname = 'root'), 'MEMBER'),
       pg_has_role((SELECT oid FROM pg_roles WHERE rolname = 'root'), 'MEMBER WITH GRANT OPTION'),
       pg_has_role((SELECT oid FROM pg_roles WHERE rolname = 'root'), 'MEMBER WITH ADMIN OPTION');

-- Test 129: query (line 1131)
SELECT pg_has_role('does_not_exist', 'USAGE');

-- query BBBBBB
SELECT pg_has_role('root', 'USAGE'),
       pg_has_role('root', 'USAGE WITH GRANT OPTION'),
       pg_has_role('root', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('root', 'MEMBER'),
       pg_has_role('root', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('root', 'MEMBER WITH ADMIN OPTION');

-- Test 130: query (line 1144)
SELECT pg_has_role('root', 'SELECT');

-- query error pgcode 22023 unrecognized privilege type: "SELECT"
SELECT pg_has_role('root', 'SELECT, SELECT');

-- query error pgcode 42704 role 'no_user' does not exist
SELECT pg_has_role('no_user', 'root', 'USAGE');

-- query BBBBBB
SELECT pg_has_role('root', 'root', 'USAGE'),
       pg_has_role('root', 'root', 'USAGE WITH GRANT OPTION'),
       pg_has_role('root', 'root', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('root', 'root', 'MEMBER'),
       pg_has_role('root', 'root', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('root', 'root', 'MEMBER WITH ADMIN OPTION');

-- Test 131: query (line 1163)
SELECT pg_has_role('bar', 'root', 'USAGE'),
       pg_has_role('bar', 'root', 'USAGE WITH GRANT OPTION'),
       pg_has_role('bar', 'root', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('bar', 'root', 'MEMBER'),
       pg_has_role('bar', 'root', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('bar', 'root', 'MEMBER WITH ADMIN OPTION');

-- Test 132: statement (line 1173)
CREATE ROLE some_users;

-- Test 133: statement (line 1176)
GRANT some_users TO bar;

-- Test 134: query (line 1179)
SELECT pg_has_role('testuser', 'some_users', 'USAGE'),
       pg_has_role('testuser', 'some_users', 'USAGE WITH GRANT OPTION'),
       pg_has_role('testuser', 'some_users', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('testuser', 'some_users', 'MEMBER'),
       pg_has_role('testuser', 'some_users', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('testuser', 'some_users', 'MEMBER WITH ADMIN OPTION');

-- Test 135: query (line 1189)
SELECT pg_has_role('root', 'some_users', 'USAGE'),
       pg_has_role('root', 'some_users', 'USAGE WITH GRANT OPTION'),
       pg_has_role('root', 'some_users', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('root', 'some_users', 'MEMBER'),
       pg_has_role('root', 'some_users', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('root', 'some_users', 'MEMBER WITH ADMIN OPTION');

-- Test 136: query (line 1199)
SELECT pg_has_role('bar', 'some_users', 'USAGE'),
       pg_has_role('bar', 'some_users', 'USAGE WITH GRANT OPTION'),
       pg_has_role('bar', 'some_users', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('bar', 'some_users', 'MEMBER'),
       pg_has_role('bar', 'some_users', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('bar', 'some_users', 'MEMBER WITH ADMIN OPTION'),
       pg_has_role('bar', 'some_users', 'USAGE, MEMBER'),
       pg_has_role('bar', 'some_users', 'USAGE, MEMBER WITH GRANT OPTION'),
       pg_has_role('bar', 'some_users', 'USAGE WITH GRANT OPTION, MEMBER'),
       pg_has_role('bar', 'some_users', 'USAGE WITH GRANT OPTION, MEMBER WITH GRANT OPTION');

-- Test 137: statement (line 1213)
GRANT some_users TO bar WITH ADMIN OPTION;

-- Test 138: query (line 1216)
SELECT pg_has_role('bar', 'some_users', 'USAGE'),
       pg_has_role('bar', 'some_users', 'USAGE WITH GRANT OPTION'),
       pg_has_role('bar', 'some_users', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('bar', 'some_users', 'MEMBER'),
       pg_has_role('bar', 'some_users', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('bar', 'some_users', 'MEMBER WITH ADMIN OPTION');

-- Test 139: query (line 1228)
SELECT pg_has_role('testuser', 'testuser', 'USAGE'),
       pg_has_role('testuser', 'testuser', 'USAGE WITH GRANT OPTION'),
       pg_has_role('testuser', 'testuser', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('testuser', 'testuser', 'MEMBER'),
       pg_has_role('testuser', 'testuser', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('testuser', 'testuser', 'MEMBER WITH ADMIN OPTION');

-- Test 140: query (line 1240)
SELECT pg_has_role('testuser', 'testuser', 'USAGE'),
       pg_has_role('testuser', 'testuser', 'USAGE WITH GRANT OPTION'),
       pg_has_role('testuser', 'testuser', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('testuser', 'testuser', 'MEMBER'),
       pg_has_role('testuser', 'testuser', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('testuser', 'testuser', 'MEMBER WITH ADMIN OPTION');

-- Test 141: query (line 1250)
SELECT pg_has_role('testuser', 'USAGE'),
       pg_has_role('testuser', 'USAGE WITH GRANT OPTION'),
       pg_has_role('testuser', 'USAGE WITH ADMIN OPTION'),
       pg_has_role('testuser', 'MEMBER'),
       pg_has_role('testuser', 'MEMBER WITH GRANT OPTION'),
       pg_has_role('testuser', 'MEMBER WITH ADMIN OPTION');

-- Test 142: statement (line 1265)
DROP TABLE IF EXISTS hcp_test; CREATE TABLE hcp_test (a INT8, b INT8, c INT8);

-- Test 143: statement (line 1268)
ALTER TABLE hcp_test DROP COLUMN b;

-- Test 144: query (line 1271)
SELECT attname, attnum FROM pg_attribute WHERE attrelid = 'hcp_test'::REGCLASS;

-- Test 145: query (line 1279)
SELECT has_column_privilege('hcp_test'::REGCLASS, 1, 'SELECT');

-- Test 146: statement (line 1284)
SELECT has_column_privilege('hcp_test'::REGCLASS, 2, 'SELECT');

-- Test 147: query (line 1287)
SELECT has_column_privilege('hcp_test'::REGCLASS, 3, 'SELECT');

-- Test 148: query (line 1292)
SELECT has_column_privilege('hcp_test'::REGCLASS, 4, 'SELECT');

-- Test 149: statement (line 1301)
DROP DATABASE IF EXISTS :"my_db";
CREATE DATABASE :"my_db";

-- Test 150: statement (line 1305)
CREATE ROLE my_role;

-- Test 151: statement (line 1308)
GRANT CREATE ON DATABASE :"my_db" TO my_role;
GRANT my_role TO testuser;

-- Test 152: statement (line 1312)
\c :my_db

-- Test 153: statement (line 1315)
CREATE SCHEMA s;
CREATE TABLE s.t();

-- Test 154: query (line 1320)
SELECT has_schema_privilege('testuser', 's', 'create');

-- Test 155: statement (line 1325)
REVOKE USAGE ON SCHEMA s FROM testuser;

-- Test 156: query (line 1329)
SELECT has_schema_privilege('testuser', 's', 'usage');

-- Test 157: query (line 1335)
SELECT has_database_privilege('testuser', :'my_db', 'create'),
       has_schema_privilege('testuser', 'public', 'usage'),
       has_table_privilege('testuser', 's.t', 'select');

-- Test 158: statement (line 1344)
CREATE USER testuser2;
GRANT testuser TO testuser2;
GRANT ALL ON SCHEMA s TO testuser2;

-- Test 159: statement (line 1349)
\c :my_db

-- Test 160: query (line 1353)
SELECT has_schema_privilege('testuser', 's', 'create'),
       has_schema_privilege('testuser', 's', 'usage'),
       has_schema_privilege('testuser2', 's', 'create'),
       has_schema_privilege('testuser2', 's', 'usage');

-- Test 161: query (line 1362)
SELECT has_database_privilege('testuser2', :'my_db', 'create'),
       has_schema_privilege('testuser2', 'public', 'usage'),
       has_table_privilege('testuser2', 's.t', 'select');

-- Test 162: statement (line 1369)
REVOKE my_role FROM testuser;
REVOKE testuser FROM testuser2;

\c :orig_db

-- Test 163: statement (line 1374)
CREATE SCHEMA owned_schema AUTHORIZATION testuser;

-- Test 164: query (line 1377)
SELECT has_schema_privilege('testuser', 'owned_schema', 'create'),
       has_schema_privilege('testuser', 'owned_schema', 'usage'),
       has_schema_privilege('testuser2', 'owned_schema', 'create'),
       has_schema_privilege('testuser2', 'owned_schema', 'usage');

CREATE OR REPLACE FUNCTION has_system_privilege(username text, priv text)
RETURNS boolean
LANGUAGE plpgsql
AS $$
DECLARE
  p text := upper(regexp_replace(trim(priv), '\\s+', ' ', 'g'));
  with_admin boolean := p ~ ' WITH (GRANT|ADMIN) OPTION$';
  base text := regexp_replace(p, ' WITH (GRANT|ADMIN) OPTION$', '');
BEGIN
  base := trim(base);

  IF base = 'CREATEDB' THEN
    RETURN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = username AND rolcreatedb);
  ELSIF base = 'CREATEROLE' THEN
    RETURN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = username AND rolcreaterole);
  ELSIF base IN ('VIEWACTIVITY', 'VIEWCLUSTERMETADATA') THEN
    -- Best-effort analogue: pg_monitor.
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = username AND rolsuper) THEN
      RETURN true;
    END IF;
    IF with_admin THEN
      RETURN pg_has_role(username, 'pg_monitor', 'MEMBER WITH ADMIN OPTION');
    END IF;
    RETURN pg_has_role(username, 'pg_monitor', 'MEMBER');
  ELSIF base = 'CANCELQUERY' THEN
    -- Best-effort analogue: pg_signal_backend.
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = username AND rolsuper) THEN
      RETURN true;
    END IF;
    IF with_admin THEN
      RETURN pg_has_role(username, 'pg_signal_backend', 'MEMBER WITH ADMIN OPTION');
    END IF;
    RETURN pg_has_role(username, 'pg_signal_backend', 'MEMBER');
  ELSE
    RETURN false;
  END IF;
END;
$$;

-- CockroachDB has SYSTEM privileges; PostgreSQL uses role attributes and
-- predefined roles. Provide a small compatibility wrapper for the tests below.
CREATE OR REPLACE FUNCTION has_system_privilege(priv text)
RETURNS boolean
LANGUAGE SQL
AS $$
  SELECT has_system_privilege(current_user::text, priv);
$$;

-- Test 165: query (line 1399)
SELECT has_system_privilege('VIEWACTIVITY'),
       has_system_privilege('VIEWCLUSTERMETADATA'),
       has_system_privilege('CANCELQUERY');

-- Test 166: query (line 1436)
SELECT has_system_privilege('VIEWACTIVITY'),
       has_system_privilege('VIEWCLUSTERMETADATA'),
       has_system_privilege('CANCELQUERY');

-- Test 167: query (line 1443)
SELECT has_system_privilege('CREATEDB'),
       has_system_privilege('CREATEROLE');

-- Test 168: statement (line 1473)
GRANT pg_monitor TO testuser;

-- Test 169: query (line 1525)
SELECT has_system_privilege('testuser', 'VIEWACTIVITY WITH GRANT OPTION');

-- Test 170: statement (line 1531)
REVOKE pg_monitor FROM testuser;

-- Test 171: query (line 1542)
SELECT has_system_privilege('testuser', 'VIEWACTIVITY WITH GRANT OPTION');

-- Cleanup (roles and databases are cluster-wide; drop them to avoid polluting
-- other test runs).
DROP SCHEMA IF EXISTS owned_schema CASCADE;
DROP DATABASE IF EXISTS :"my_db";
DROP OWNED BY my_role, testuser2, some_users, all_user_schema, all_user_db, bar, testuser, root CASCADE;
DROP ROLE IF EXISTS my_role;
DROP ROLE IF EXISTS testuser2;
DROP ROLE IF EXISTS some_users;
DROP ROLE IF EXISTS all_user_schema;
DROP ROLE IF EXISTS all_user_db;
DROP ROLE IF EXISTS bar;
DROP ROLE IF EXISTS testuser;
DROP ROLE IF EXISTS root;

\set ON_ERROR_STOP 1
