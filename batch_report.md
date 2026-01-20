# Batch Report: pg_tests Expected Generation

## Batch 1

Processed files (from `pg_tests/todo.txt`):

| SQL file | Status | Notes |
| --- | --- | --- |
| `pg_tests/compatible/aggregate.sql` | Success | Generated `aggregate.expected` |
| `pg_tests/compatible/alias_types.sql` | Success | Output matched existing `alias_types.expected` |
| `pg_tests/compatible/alter_column_type.sql` | Success | Regenerated `alter_column_type.expected` from PG output |
| `pg_tests/compatible/alter_database_convert_to_schema.sql` | Success | Adapted CRDB `USE`/`CONVERT TO SCHEMA` to PG (`\\connect` + schema) and generated expected |
| `pg_tests/compatible/alter_database_owner.sql` | Success | Fixed directives/semicolons, added setup+cleanup for roles/dbs, and generated expected |

Remaining files in `pg_tests/todo.txt`: 452

