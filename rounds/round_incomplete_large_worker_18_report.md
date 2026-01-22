# Incomplete Large Files Worker 18 Report

Manifest: `pg_tests/rounds/round_incomplete_large_worker_18.txt`

## pg_tests/compatible/views.sql
- File size: 1348 lines
- Initial status: `.expected` existed and included Postgres `ERROR:` output.
- Action: regenerated `pg_tests/compatible/views.expected` using `pg_tests/skills/crdb-to-pg-adaptation/scripts/regen_expected.sh`.
- Notes: `pg_tests/compatible/views.sql` intentionally runs with `\\set ON_ERROR_STOP 0` and exercises expected errors (duplicate objects, invalid view definitions, missing relations).

## pg_tests/compatible/virtual_columns.sql
- File size: 1049 lines
- Initial status: missing `.expected`; regeneration failed on CockroachDB `VIRTUAL` computed-column syntax.
- Major adaptations:
  - Added a PostgreSQL-focused executable subset using `GENERATED ALWAYS AS (...) STORED` (Postgres has no “VIRTUAL” generated columns).
  - Preserved the original CockroachDB logic-test content under a `/* ... */` block comment for reference.
- Action: generated `pg_tests/compatible/virtual_columns.expected` successfully.

Worker ID: 18
Status: COMPLETE

