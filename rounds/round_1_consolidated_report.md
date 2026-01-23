# Round 1 - Worker 00 Report

Worker ID: 00

## File Results

SKIP: pg_tests/compatible/alias_types.sql (already in baseline)
SKIP: pg_tests/compatible/alter_column_type.sql (already in baseline)
SKIP: pg_tests/compatible/alter_database_convert_to_schema.sql (already in baseline)
SUCCESS: pg_tests/compatible/aggregate.sql
ADAPTED_SUCCESS: pg_tests/compatible/alter_database_owner.sql

## Summary

Files in manifest (5):
- pg_tests/compatible/aggregate.sql
- pg_tests/compatible/alias_types.sql
- pg_tests/compatible/alter_column_type.sql
- pg_tests/compatible/alter_database_convert_to_schema.sql
- pg_tests/compatible/alter_database_owner.sql

Counts:
- Success: 1
- Adapted success: 1
- Failure: 0
- Skipped (baseline/already clean): 3

Status: COMPLETE
# Round 1 Worker 01 Report

Worker ID: 01

Files processed:
- pg_tests/compatible/alter_default_privileges_for_all_roles.sql
- pg_tests/compatible/alter_default_privileges_for_schema.sql
- pg_tests/compatible/alter_default_privileges_for_sequence.sql
- pg_tests/compatible/alter_default_privileges_for_table.sql
- pg_tests/compatible/alter_default_privileges_for_type.sql

Processing log:
SKIP: pg_tests/compatible/alter_default_privileges_for_all_roles.sql (already in baseline)
SKIP: pg_tests/compatible/alter_default_privileges_for_schema.sql (already in baseline)
SKIP: pg_tests/compatible/alter_default_privileges_for_sequence.sql (already in baseline)
ADAPTED_SUCCESS: pg_tests/compatible/alter_default_privileges_for_table.sql
SKIP: pg_tests/compatible/alter_default_privileges_for_type.sql (already in baseline)

Counts:
- Success: 0
- Adaptation: 1
- Failure: 0

Status: COMPLETE
# Round 1 Worker 02 Report

## Processing Log

SKIP: pg_tests/compatible/alter_default_privileges_in_schema.sql (already in baseline)
NEEDS_ADAPTATION: pg_tests/compatible/alter_default_privileges_with_grant_option.sql
ADAPTED_SUCCESS: pg_tests/compatible/alter_default_privileges_with_grant_option.sql
NEEDS_ADAPTATION: pg_tests/compatible/alter_external_connection.sql
ADAPTED_SUCCESS: pg_tests/compatible/alter_external_connection.sql
NEEDS_ADAPTATION: pg_tests/compatible/alter_primary_key.sql
FAILED: pg_tests/compatible/alter_primary_key.sql
SKIP: pg_tests/compatible/alter_role.sql (already in baseline)

## Summary

- Worker ID: 02
- Files processed:
  - pg_tests/compatible/alter_default_privileges_in_schema.sql
  - pg_tests/compatible/alter_default_privileges_with_grant_option.sql
  - pg_tests/compatible/alter_external_connection.sql
  - pg_tests/compatible/alter_primary_key.sql
  - pg_tests/compatible/alter_role.sql
- Success count: 0
- Adaptation success count: 2
- Failure count: 1
- Skip count: 2
- Status: COMPLETE
# Round 1 Worker 03 Report

ADAPTED_SUCCESS: pg_tests/compatible/alter_schema_owner.sql
ADAPTED_SUCCESS: pg_tests/compatible/alter_sequence.sql
ADAPTED_SUCCESS: pg_tests/compatible/alter_sequence_owner.sql
ADAPTED_SUCCESS: pg_tests/compatible/alter_role_set.sql
FAILED: pg_tests/compatible/alter_table.sql

## Final Summary

- Worker ID: 03
- Files processed:
  - pg_tests/compatible/alter_role_set.sql
  - pg_tests/compatible/alter_schema_owner.sql
  - pg_tests/compatible/alter_sequence.sql
  - pg_tests/compatible/alter_sequence_owner.sql
  - pg_tests/compatible/alter_table.sql
- Success count: 0
- Adaptation count: 4
- Failure count: 1
- Status: COMPLETE
# Round 1 Worker 08 Report

Worker ID: 08
Status: COMPLETE

## Files Processed
- pg_tests/compatible/check_constraints.sql
- pg_tests/compatible/citext.sql
- pg_tests/compatible/cluster_locks.sql
- pg_tests/compatible/cluster_locks_write_buffering.sql
- pg_tests/compatible/cluster_settings.sql

## Results
- ADAPTED_SUCCESS: pg_tests/compatible/check_constraints.sql
- SUCCESS: pg_tests/compatible/citext.sql
- ADAPTED_SUCCESS: pg_tests/compatible/cluster_locks.sql
- SUCCESS: pg_tests/compatible/cluster_locks_write_buffering.sql
- SUCCESS: pg_tests/compatible/cluster_settings.sql

Success count: 3
Adaptation count: 2
Failure count: 0
# Round 1 Worker 09 Report

Worker ID: 09
Manifest: pg_tests/rounds/round_1_worker_09.txt

## Processing Log
- ADAPTED_SUCCESS: pg_tests/compatible/collatedstring.sql
- SUCCESS: pg_tests/compatible/collatedstring_constraint.sql
- ADAPTED_SUCCESS: pg_tests/compatible/collatedstring_index1.sql
- ADAPTED_SUCCESS: pg_tests/compatible/collatedstring_index2.sql
- SKIP: pg_tests/compatible/collatedstring_normalization.sql (already in baseline)

## Summary
Files processed:
- pg_tests/compatible/collatedstring.sql
- pg_tests/compatible/collatedstring_constraint.sql
- pg_tests/compatible/collatedstring_index1.sql
- pg_tests/compatible/collatedstring_index2.sql
- pg_tests/compatible/collatedstring_normalization.sql

Success count: 1
Adaptation count: 3
Skip count: 1
Failure count: 0

Status: COMPLETE
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
# Round 1 Worker 19 Report

(autogenerated by worker)

## Progress Log
NEEDS_ADAPTATION: pg_tests/compatible/distsql_enum.sql
ADAPTED_SUCCESS: pg_tests/compatible/distsql_enum.sql
SKIP: pg_tests/compatible/distsql_event_log.sql (already in baseline)
SKIP: pg_tests/compatible/distsql_expr.sql (already in baseline)
NEEDS_ADAPTATION: pg_tests/compatible/distsql_inspect.sql
ADAPTED_SUCCESS: pg_tests/compatible/distsql_inspect.sql
SKIP: pg_tests/compatible/distsql_join.sql (already in baseline)

## Final Summary

- Worker ID: 19
- Files processed:
  - pg_tests/compatible/distsql_enum.sql
  - pg_tests/compatible/distsql_event_log.sql
  - pg_tests/compatible/distsql_expr.sql
  - pg_tests/compatible/distsql_inspect.sql
  - pg_tests/compatible/distsql_join.sql
- Success count: 0
- Adaptation count: 2
- Failure count: 0
- Status: COMPLETE
