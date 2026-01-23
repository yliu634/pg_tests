# Coordinator Report: Round Missing-6 Setup

## Branch
- Delivery branch: `pantheon/pg-tests-expected-202601210820`

## Goal
Prepare a dedicated round for 6 large SQL files that are currently missing their corresponding `.expected` outputs.

## Missing `.expected` Targets (6)
- `pg_tests/compatible/txn.sql`
- `pg_tests/compatible/udf.sql`
- `pg_tests/compatible/udf_fk.sql`
- `pg_tests/compatible/udf_params.sql`
- `pg_tests/compatible/upsert.sql`
- `pg_tests/compatible/vector_index.sql`

## Manifests Created
- Round manifest: `pg_tests/rounds/round_missing_6.txt`
- Worker manifests:
  - `pg_tests/rounds/round_missing_6_worker_00.txt` → `pg_tests/compatible/txn.sql`
  - `pg_tests/rounds/round_missing_6_worker_01.txt` → `pg_tests/compatible/udf.sql`
  - `pg_tests/rounds/round_missing_6_worker_02.txt` → `pg_tests/compatible/udf_fk.sql`
  - `pg_tests/rounds/round_missing_6_worker_03.txt` → `pg_tests/compatible/udf_params.sql`
  - `pg_tests/rounds/round_missing_6_worker_04.txt` → `pg_tests/compatible/upsert.sql`
  - `pg_tests/rounds/round_missing_6_worker_05.txt` → `pg_tests/compatible/vector_index.sql`

## Notes
- These files are large/complex and expected to require aggressive CRDB-to-Postgres adaptation to produce stable `.expected` outputs.
