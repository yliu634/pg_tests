# Merge Coordinator Report: Missing-6 Round Results

- Date: Fri Jan 23 07:44:09 UTC 2026
- Branch: `pantheon/pg-tests-expected-202601210820`

## Verified target outputs (6)

### Completed (now have `.expected`)
- `pg_tests/compatible/txn.expected`
- `pg_tests/compatible/udf.expected`
- `pg_tests/compatible/udf_fk.expected`
- `pg_tests/compatible/udf_params.expected`

### Still missing (no `.expected` present)
- `pg_tests/compatible/upsert.expected`
- `pg_tests/compatible/vector_index.expected`

**PROMINENT NOTE:** `upsert.sql` and `vector_index.sql` are still missing `.expected` outputs.

See: `pg_tests/missing_still.txt`

## Worker reports collected
- `pg_tests/rounds/round_missing_6_worker_00_report.md` (txn.sql): SUCCESS; regenerated `txn.expected` with no `ERROR:` lines.
- `pg_tests/rounds/round_missing_6_worker_01_report.md` (udf.sql): SUCCESS; regenerated `udf.expected` with no `ERROR:` lines.
- `pg_tests/rounds/round_missing_6_worker_02_report.md` (udf_fk.sql): SUCCESS; regenerated `udf_fk.expected` with no `ERROR:` lines.
- `pg_tests/rounds/round_missing_6_worker_03_report.md` (udf_params.sql): SUCCESS; regenerated `udf_params.expected` with no `ERROR:` lines.

## Final project statistics (`pg_tests/compatible/`)
- Total SQL files: 457
- `.expected` files present: 455
- Files with `ERROR:` in `.expected`: 46
- Missing `.expected` files: 2 (`upsert.expected`, `vector_index.expected`)
- Successfully completed (has `.expected` and no `ERROR:`): 409
- Success rate: 89.50% (409/457)

## Overall completion status
- Status: INCOMPLETE
- Blocking items: `pg_tests/compatible/upsert.sql`, `pg_tests/compatible/vector_index.sql`

## Suggested next actions
1. Generate the missing expected outputs:
   - `bash skills/crdb-to-pg-adaptation/scripts/regen_expected.sh compatible/upsert.sql`
   - `bash skills/crdb-to-pg-adaptation/scripts/regen_expected.sh compatible/vector_index.sql`
2. Recompute stats and update `pg_tests/progress.md`.
