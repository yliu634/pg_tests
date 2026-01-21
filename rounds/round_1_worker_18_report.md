# Round 1 Worker 18 Report

- Worker ID: 18
- Manifest: `pg_tests/rounds/round_1_worker_18.txt`
- Status: COMPLETE

## File Results

NEEDS_ADAPTATION: pg_tests/compatible/distsql_buffered_writes.sql
ADAPTED_SUCCESS: pg_tests/compatible/distsql_buffered_writes.sql
NEEDS_ADAPTATION: pg_tests/compatible/distsql_builtin.sql
ADAPTED_SUCCESS: pg_tests/compatible/distsql_builtin.sql
NEEDS_ADAPTATION: pg_tests/compatible/distsql_crdb_internal.sql
ADAPTED_SUCCESS: pg_tests/compatible/distsql_crdb_internal.sql
SKIP: pg_tests/compatible/distsql_datetime.sql (already in baseline)
SKIP: pg_tests/compatible/distsql_distinct_on.sql (already in baseline)

## Summary

- Files processed:
  - pg_tests/compatible/distsql_buffered_writes.sql
  - pg_tests/compatible/distsql_builtin.sql
  - pg_tests/compatible/distsql_crdb_internal.sql
  - pg_tests/compatible/distsql_datetime.sql
  - pg_tests/compatible/distsql_distinct_on.sql
- Success count: 0
- Adaptation count: 3
- Failure count: 0
- Skip count: 2
