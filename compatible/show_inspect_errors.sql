-- PostgreSQL compatible tests from show_inspect_errors
-- 26 tests

-- Test 1: statement (line 3)
SHOW INSPECT ERRORS

user root

-- Test 2: statement (line 8)
GRANT SYSTEM INSPECT TO testuser;

-- Test 3: statement (line 11)
SHOW INSPECT ERRORS FOR TABLE bad_table

-- Test 4: statement (line 14)
CREATE TABLE foo (a INT);
CREATE TABLE bar (b INT);

let $foo_table_id
SELECT 'foo'::regclass::oid

let $bar_table_id
SELECT 'bar'::regclass::oid

let $database_id
SELECT id FROM system.namespace WHERE name = current_database() AND "parentID" = 0

let $schema_id
SELECT current_schema()::regnamespace::oid

let $aost
SELECT '2025-09-23-11:02:14-04:00'::timestamp

-- Test 5: statement (line 34)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (555, 'testuser', 'failed', 'INSPECT');
INSERT INTO system.job_info (job_id, info_key, value)
VALUES (
  555,
  'legacy_payload',
  crdb_internal.json_to_pb(
    'cockroach.sql.jobs.jobspb.Payload',
    json_build_object(
      'inspectDetails', json_build_object(
        'checks', json_build_array(
          json_build_object('tableId', $foo_table_id),
          json_build_object('tableId', $bar_table_id)
        )
      )
    )
  )
);

-- Test 6: statement (line 54)
INSERT INTO system.inspect_errors (job_id, error_type, aost, database_id, schema_id, id, details)
VALUES
  (555, '555_foo', '$aost', $database_id, $schema_id, $foo_table_id, '{"detail":"555\"foo"}'),
  (555, '555_bar', '$aost', $database_id, $schema_id, $bar_table_id, '{"detail":"555\"bar"}');

-- Test 7: statement (line 60)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (666, 'testuser', 'failed', 'INSPECT');
INSERT INTO system.job_info (job_id, info_key, value)
VALUES (
  666,
  'legacy_payload',
  crdb_internal.json_to_pb(
    'cockroach.sql.jobs.jobspb.Payload',
    json_build_object(
      'inspectDetails', json_build_object(
        'checks', json_build_array(
          json_build_object('tableId', $foo_table_id)
        )
      )
    )
  )
);

-- Test 8: statement (line 79)
INSERT INTO system.inspect_errors (job_id, error_type, aost, database_id, schema_id, id, details)
VALUES (666, '666_foo', '$aost', $database_id, $schema_id, $foo_table_id, '{"detail1":"\u2603 666_foo_1","detail2":"\n666_foo_2"}');

-- Test 9: statement (line 83)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (777, 'testuser', 'running', 'INSPECT');
INSERT INTO system.job_info (job_id, info_key, value)
VALUES (
  777,
  'legacy_payload',
  crdb_internal.json_to_pb(
    'cockroach.sql.jobs.jobspb.Payload',
    json_build_object(
      'inspectDetails', json_build_object(
        'checks', json_build_array(
          json_build_object('tableId', $foo_table_id)
        )
      )
    )
  )
);

-- Test 10: statement (line 102)
INSERT INTO system.inspect_errors (job_id, error_type, aost, database_id, schema_id, id, details)
VALUES (777, '777_foo', '$aost', $database_id, $schema_id, $foo_table_id, '{"detail":"777 foo"}');

user testuser

-- Test 11: query (line 109)
SHOW INSPECT ERRORS

-- Test 12: query (line 115)
SHOW INSPECT ERRORS WITH DETAILS

-- Test 13: query (line 125)
SHOW INSPECT ERRORS FOR JOB 777

-- Test 14: query (line 130)
SHOW INSPECT ERRORS FOR JOB 555

-- Test 15: query (line 137)
SHOW INSPECT ERRORS FOR TABLE foo

-- Test 16: query (line 143)
SHOW INSPECT ERRORS FOR TABLE bar

-- Test 17: query (line 148)
SHOW INSPECT ERRORS FOR TABLE public.bar

-- Test 18: query (line 153)
SHOW INSPECT ERRORS FOR TABLE test.public.bar

-- Test 19: query (line 158)
SHOW INSPECT ERRORS FOR TABLE foo FOR JOB 555 WITH DETAILS

-- Test 20: statement (line 173)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (888, 'testuser', 'succeeded', 'INSPECT');
INSERT INTO system.job_info (job_id, info_key, value)
VALUES (
  888,
  'legacy_payload',
  crdb_internal.json_to_pb(
    'cockroach.sql.jobs.jobspb.Payload',
    json_build_object(
      'inspectDetails', json_build_object(
        'checks', json_build_array(
          json_build_object('tableId', $foo_table_id)
        )
      )
    )
  )
);

-- Test 21: query (line 199)
SHOW INSPECT ERRORS FOR TABLE foo

-- Test 22: query (line 204)
SHOW INSPECT ERRORS FOR TABLE foo FOR JOB 666

-- Test 23: statement (line 217)
INSERT INTO system.jobs (id, owner, status, job_type)
VALUES (999, 'testuser', 'succeeded', 'INSPECT');
INSERT INTO system.job_info (job_id, info_key, value)
VALUES (
  999,
  'legacy_payload',
  crdb_internal.json_to_pb(
    'cockroach.sql.jobs.jobspb.Payload',
    json_build_object(
      'inspectDetails', json_build_object(
        'checks', json_build_array()
      )
    )
  )
);

user testuser

-- Test 24: query (line 236)
SHOW INSPECT ERRORS FOR TABLE foo

-- Test 25: query (line 240)
SHOW INSPECT ERRORS FOR TABLE bar

-- Test 26: query (line 245)
SHOW INSPECT ERRORS FOR JOB 999

