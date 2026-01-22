# Incomplete large files worker 11 report

Branch: pantheon/pg-tests-expected-202601210820
Date: 2026-01-22T10:53:28Z

PROCESSING: pg_tests/compatible/row_level_security.sql
File size: 4466 lines
Status: MISSING .expected

Major changes:
- Added psql harness preamble (`\set ON_ERROR_STOP 0`, role bootstrap, cluster cleanup) and helpers (`pg_show_policies`, `:orig_db`).
- Converted Cockroach directives (`USE`, `onlyif`/`skipif`, `user`, `statement/query` markers) to PostgreSQL/psql-compatible equivalents or comments.
- Replaced Cockroach-only constructs (`SHOW POLICIES`, `[SHOW POLICIES ...]`, `GRANT/REVOKE SYSTEM ...`, `system.eventlog`, `use_declarative_schema_changer`, `FAMILY ...`) with Postgres-compatible alternatives.
- Made a few ordering/privilege fixes so the script can proceed on Postgres (policy/role dependency cleanup, role membership for `SET ROLE`).

Generated: pg_tests/compatible/row_level_security.expected
RESULT: SUCCESS

PROCESSING: pg_tests/compatible/schema_change_in_txn.sql
File size: 1681 lines
Status: MISSING .expected

Major changes:
- Added psql harness preamble (`\set ON_ERROR_STOP 0`, `CREATE SCHEMA test`, `pg_show_constraints`).
- Converted Cockroach logictest directives (`subtest`, `statement ...`, `query ...`) to comments and added `ORDER BY 1..N` for `rowsort` queries.
- Replaced `[SHOW CONSTRAINTS FROM ...]` with `pg_show_constraints(...)` and removed Cockroach index-hint syntax (`@index`) / adapted `DROP INDEX` forms.
- Converted Cockroach computed column syntax (`AS (...) STORED`, `//`) to PostgreSQL generated columns (`GENERATED ALWAYS AS (...) STORED`) and normalized statement terminators.

Generated: pg_tests/compatible/schema_change_in_txn.expected
RESULT: SUCCESS

Worker ID: 11
Status: COMPLETE
