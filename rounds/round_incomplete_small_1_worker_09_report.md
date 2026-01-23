# Incomplete Small Files Round 1 Worker 09 Report

## pg_tests/compatible/show_commit_timestamp.sql
- PROCESSING: `pg_tests/compatible/show_commit_timestamp.sql`
- Status: MISSING `.expected`
- Major adaptations:
  - Replaced Cockroach `SHOW COMMIT TIMESTAMP` with `crdb_internal.show_commit_timestamp()` backed by a per-transaction mapping table + sequence (stable output).
  - Converted CRDB logic-test directives (`let`, bracket syntax) into `psql` constructs (`\gset`, regular SQL).
- RESULT: SUCCESS (`pg_tests/compatible/show_commit_timestamp.expected` generated)

## pg_tests/compatible/show_completions.sql
- PROCESSING: `pg_tests/compatible/show_completions.sql`
- Status: MISSING `.expected`
- Major adaptations:
  - Replaced Cockroach `SHOW COMPLETIONS ...` with `crdb_internal.show_completions_at_offset(...)` implemented via `pg_get_keywords()`.
- RESULT: SUCCESS (`pg_tests/compatible/show_completions.expected` generated)

## pg_tests/compatible/show_create.sql
- PROCESSING: `pg_tests/compatible/show_create.sql`
- Status: MISSING `.expected`
- Major adaptations:
  - No SQL changes needed; generated `.expected` from a clean PostgreSQL run.
- RESULT: SUCCESS (`pg_tests/compatible/show_create.expected` generated; includes expected-error output for unsupported `VALIDATE CONSTRAINT` cases)

## pg_tests/compatible/show_create_all_schemas.sql
- PROCESSING: `pg_tests/compatible/show_create_all_schemas.sql`
- Status: MISSING `.expected`
- Major adaptations:
  - Emulated CockroachDB database scoping using schema groups: `<db>` + `<db>__*`.
  - Implemented `crdb_internal.show_create_all_schemas(dbname)` to return stable `CREATE SCHEMA` / `COMMENT ON SCHEMA` statements.
- RESULT: SUCCESS (`pg_tests/compatible/show_create_all_schemas.expected` generated)

## pg_tests/compatible/show_create_all_tables.sql
- PROCESSING: `pg_tests/compatible/show_create_all_tables.sql`
- Status: MISSING `.expected`
- Major adaptations:
  - Emulated CockroachDB `SHOW CREATE ALL TABLES` using `crdb_internal.show_create_all_tables(dbname)` backed by `pg_dump` over a schema group (`<db>` + `<db>__*`).
  - Rewrote CRDB-only constructs to PG equivalents: `CREATE/USE DATABASE` → schemas + `search_path`, `FAMILY` removed, inline `INDEX(...)` → `CREATE INDEX`, computed columns → `GENERATED ALWAYS AS (...) STORED`, `enum()` → `ENUM ('a')`.
- RESULT: SUCCESS (`pg_tests/compatible/show_create_all_tables.expected` generated)

Worker ID: 09
Status: COMPLETE
