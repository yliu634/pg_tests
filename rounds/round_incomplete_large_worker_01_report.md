# Incomplete Large Files Worker Report (01)

Manifest: `pg_tests/rounds/round_incomplete_large_worker_01.txt`

## pg_tests/compatible/cascade.sql

- File size: 2202 lines
- Initial status: missing `.expected`
- Major adaptations:
  - Added semicolon termination throughout so the file can run under `psql -f`.
  - Restored missing schema setup blocks (many CRDB logic-test sections were missing `CREATE TABLE ...`), converting `STRING` to `TEXT` where needed.
  - Converted CRDB-specific syntax/directives:
    - `UNIQUE INDEX (...)` → `UNIQUE (...)`
    - `SET/RESET foreign_key_cascades_limit` → custom GUC `crdb.foreign_key_cascades_limit` (PostgreSQL-compatible no-op)
    - Commented out CRDB-only `skipif ...` and `ALTER TABLE ... SET/RESET (schema_locked...)`
  - Set `\\set ON_ERROR_STOP 0` (and normalized any `\\set ON_ERROR_STOP 1` back to `0`) so expected-error sections don’t abort regeneration.
- Regen result: generated `pg_tests/compatible/cascade.expected` (contains expected Postgres `ERROR:` lines; current count: 126).

## pg_tests/compatible/cast.sql

- File size: 1205 lines
- Initial status: missing `.expected`
- Major adaptations:
  - Added missing `CREATE TABLE assn_cast` (converting CRDB `STRING` to `TEXT`).
  - Added `\\set ON_ERROR_STOP 0` since many casts are expected to error.
  - Added semicolon termination throughout so the file can run under `psql -f`.
- Regen result: generated `pg_tests/compatible/cast.expected` (contains expected Postgres `ERROR:` lines; current count: 184).

Worker ID: 01
Status: COMPLETE
