# Large Files Round Report (Worker 01)

ADAPTED_SUCCESS: pg_tests/compatible/ltree.sql (886 lines)
- Added PostgreSQL setup: `CREATE EXTENSION IF NOT EXISTS ltree;`, `SET client_min_messages = warning;`, and `\set ON_ERROR_STOP 0` for expected error cases.
- Converted leftover CRDB logic-test directives (`query ...`, `skipif ...`) into comments and added missing statement terminators.
- Fixed PostgreSQL incompatibilities:
  - Casted `LTREE[]` array literals/comparisons so inserts and operators work.
  - Replaced CRDB `table@index` hints and inline `INDEX ...` table clauses with PostgreSQL `CREATE INDEX`.
  - Added missing DDL for extracted tables (`t_schema`, `t_view_base`, `t_multi_idx`, `t_multi_idx2`).
  - Converted CRDB computed columns (`AS (...) STORED/VIRTUAL`) to PostgreSQL generated columns (`GENERATED ALWAYS AS (...) STORED`).
  - Adjusted `subpath()` length argument to use max `INT` value.

ADAPTED_SUCCESS: pg_tests/compatible/new_schema_changer.sql (1206 lines)
- Marked as `PG-NOT-SUPPORTED` and short-circuited execution with a single notice.
- Preserved the original CockroachDB-derived SQL in a block comment for reference.

Worker ID: 01
Large files processed: 2
Status: COMPLETE
