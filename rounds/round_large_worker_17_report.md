Processing LARGE file: pg_tests/compatible/vectorize.sql
File size: 668 lines
NEEDS_RUN: pg_tests/compatible/vectorize.sql

Processing LARGE file: pg_tests/compatible/views.sql
File size: 1324 lines
NEEDS_RUN: pg_tests/compatible/views.sql

ADAPTED_SUCCESS: pg_tests/compatible/vectorize.sql (668 lines)
- Added missing setup tables/data for isolated PG runs (a, b, builtin_test, t38959*, t_*, etc.)
- Converted CRDB-only syntax: LOOKUP/MERGE JOIN -> JOIN; removed @index hints; commented Cockroach-only settings/system tables
- Normalized statement terminators (added semicolons) and rewrote unsupported WITH ORDINALITY usage via row_number()
- Fixed Postgres type/function mismatches (BYTES->BYTEA, min(bytea) via encode(...,'hex'), epoch casts, to_jsonb(text), boolean WHERE CASE)

ADAPTED_SUCCESS: pg_tests/compatible/views.sql (1324 lines)
- Added \set ON_ERROR_STOP 0 and created role testuser; translated CRDB 'user' directives to SET ROLE/RESET ROLE
- Mapped Cockroach databases to PG schemas (CREATE DATABASE/USE/SET DATABASE -> CREATE SCHEMA + SET search_path)
- Replaced SHOW CREATE VIEW / [SHOW CREATE ...] with pg_get_viewdef; SHOW COLUMNS -> information_schema.columns
- Commented Cockroach-only system tables/settings (system.*, crdb_internal.*) and fixed remaining CRDB placeholders/bracket forms

Worker ID: 17
Large files processed: 2
Status: COMPLETE
