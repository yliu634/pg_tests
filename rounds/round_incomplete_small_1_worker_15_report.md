# Incomplete Small Files Round 1 Worker 15 Report

## pg_tests/compatible/values.sql
- PROCESSING: `pg_tests/compatible/values.sql`
- Status: `.expected` already present
- Result: SUCCESS (regen matched; file intentionally includes expected error output)

## pg_tests/compatible/vectorize_local.sql
- PROCESSING: `pg_tests/compatible/vectorize_local.sql`
- Status: `.expected` already present
- Result: SUCCESS (regen matched; file intentionally includes expected error output)

## pg_tests/compatible/zone_config_system_tenant.sql
- PROCESSING: `pg_tests/compatible/zone_config_system_tenant.sql`
- Status: MISSING `.expected`
- Adaptation:
  - Commented out CockroachDB-only `CONFIGURE ZONE`, `ALTER RANGE`, and `SET CLUSTER SETTING` statements.
  - Commented out CockroachDB-only internal catalog queries (`crdb_internal`, `system.*`).
  - Created schema `db2` for PostgreSQL.
- Result: SUCCESS (`pg_tests/compatible/zone_config_system_tenant.expected` generated)

Worker ID: 15
Status: COMPLETE
