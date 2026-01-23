# Incomplete Large Files Worker 09 Report

Manifest: `pg_tests/rounds/round_incomplete_large_worker_09.txt`

## pg_tests/compatible/pg_catalog.sql
- File size: 1877 lines
- Initial state: `pg_tests/compatible/pg_catalog.expected` was missing; file contained Cockroach logic-test directives and many statements missing `;`, so `psql` parsing failed.
- Major adaptations:
  - Added a PostgreSQL/psql setup header: `\set ON_ERROR_STOP 0`, `current_database()` via `\gset`, and a dedicated role `pg_catalog_testuser`.
  - Converted Cockroach directives to comments (e.g., `statement ok`, `query ...`).
  - Mapped Cockroach `CREATE/DROP/ALTER DATABASE` → `CREATE/DROP/ALTER SCHEMA` for per-test isolation.
  - Mapped Cockroach `SET DATABASE ...` → `SET search_path ...`.
  - Replaced Cockroach `SHOW TABLES/SHOW CREATE/SHOW COLUMNS/SHOW INDEXES/SHOW CONSTRAINTS/SHOW GRANTS` with PostgreSQL equivalents (SQL against catalogs and `\d+`).
  - Rewrote Cockroach variable capture `let $testid` to psql `\gset` + `:testid` usage.
  - Added missing statement terminators (`;`) broadly to make the file runnable under `psql`.
  - Converted Cockroach-only table/index syntax in a few key spots (generated columns, inline/partial index definitions) into PostgreSQL-compatible DDL.
  - Converted `user testuser` directives into scoped `SET ROLE ...;` / `RESET ROLE;`.
- Regeneration:
  - Ran `pg_tests/skills/crdb-to-pg-adaptation/scripts/regen_expected.sh` and generated `pg_tests/compatible/pg_catalog.expected`.

## pg_tests/compatible/plpgsql_builtins.sql
- File size: 704 lines
- Initial state: `.expected` existed but contained many unintended PostgreSQL errors due to incomplete `crdb_internal.*` emulation.
- Major adaptations:
  - Fixed `crdb_internal.plpgsql_close` to catch `invalid_cursor_name` (PostgreSQL) instead of Cockroach's `undefined_cursor`.
  - Reworked `crdb_internal.plpgsql_raise` to avoid `RAISE ... USING` NULL-option errors by only emitting `ERRCODE/DETAIL/HINT` when non-empty, matching intended semantics.
- Regeneration:
  - Regenerated `pg_tests/compatible/plpgsql_builtins.expected` (remaining `ERROR:` lines correspond to intentionally-tested error cases in the file).

Worker ID: 09
Status: COMPLETE
