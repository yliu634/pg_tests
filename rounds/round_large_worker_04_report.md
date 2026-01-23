---
SQL_FILE: pg_tests/compatible/privilege_builtins.sql
LINES: 1071
BASELINE: no
EXPECTED: missing

---
SQL_FILE: pg_tests/compatible/procedure_params.sql
LINES: 567
BASELINE: no
EXPECTED: missing

ADAPTED_SUCCESS: pg_tests/compatible/privilege_builtins.sql (1071 lines)
- Converted sqllogictest-style directives to psql-friendly SQL: commented `query ...` lines and ensured every statement ends with `;`.
- Added setup/cleanup to keep reruns idempotent: drop per-run DB/roles, `DROP OWNED` to remove grant dependencies, and reset `ON_ERROR_STOP`.
- Removed hard-coded CRDB database names: use `:"orig_db"` for GRANTs on the harness DB and `current_database()`/`template1` for lookups.
- Replaced `use my_db` with `\c :my_db` and made the cross-db name unique (`current_database() || '_my_db'`).
- Added a small Postgres compatibility wrapper for CRDB `has_system_privilege(...)` and mapped `GRANT/REVOKE SYSTEM` to `pg_monitor`.

ADAPTED_SUCCESS: pg_tests/compatible/procedure_params.sql (567 lines)
- Added `\set ON_ERROR_STOP 0`/`1` so expected-error cases don't abort the run.
- Removed CRDB-only `RETURNS` clause from `CREATE PROCEDURE`.
- Fixed CRDB-only syntax: `//` -> `/`, `IN OUT` -> `INOUT`, `STRING(n)` -> `VARCHAR(n)`, and added one missing `;`.
- Replaced `SELECT ... FROM [SHOW CREATE PROCEDURE ...]` with Postgres `pg_get_functiondef(...)` queries.

Worker ID: 04
Large files processed: 2
Status: COMPLETE
