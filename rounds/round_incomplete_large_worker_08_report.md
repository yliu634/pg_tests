# Incomplete large files worker 08 report

## Processed

### pg_tests/compatible/pg_builtins.sql
- File size: 692 lines
- Initial status: `.expected` contained PostgreSQL `ERROR:` output
- Major adaptations:
  - Removed expected-error-only `set_config(NULL, ...)` call to keep the suite error-free
  - Replaced `to_regtype('-3')` (error) with `to_regtype('no_such_type')` (returns NULL)
- Regen: `pg_tests/skills/crdb-to-pg-adaptation/scripts/regen_expected.sh` wrote `pg_tests/compatible/pg_builtins.expected`
- Result: SUCCESS (no `ERROR:` lines)

### pg_tests/compatible/partial_index.sql
- File size: 1747 lines
- Initial status: `.expected` contained many PostgreSQL `ERROR:` lines and the SQL contained many Cockroach-only constructs
- Major adaptations:
  - Added missing `;` statement terminators so `psql` can run the file deterministically
  - Removed Cockroach index-hint syntax (`table@index`)
  - Converted Cockroach-only DDL/features to PostgreSQL equivalents:
    - Inline `INDEX ... WHERE ...` / `UNIQUE INDEX ...` clauses -> `CREATE INDEX` / `CREATE UNIQUE INDEX`
    - `INVERTED INDEX` -> `GIN` index on `JSONB`
    - `UPSERT` -> `INSERT ... ON CONFLICT ...`
    - `VIRTUAL` generated column -> `GENERATED ALWAYS AS (...) STORED`
    - `ALTER PRIMARY KEY USING COLUMNS` -> `DROP CONSTRAINT ...` + `ADD PRIMARY KEY ...`
  - Commented out Cockroach-only statements (`INJECT STATISTICS`, `SHOW CREATE TABLE`, `autocommit_before_ddl`)
  - Added missing table definitions needed by later statements (e.g. `join_small/join_large`, `inv/_b/_c`, `t61414_b`, `t74385`)
  - Skipped vector index tests requiring pgvector / Cockroach vector features (kept the rest error-free)
- Regen: `pg_tests/skills/crdb-to-pg-adaptation/scripts/regen_expected.sh` wrote `pg_tests/compatible/partial_index.expected`
- Result: SUCCESS (no `ERROR:` lines)

## Summary
- Worker ID: 08
- Status: COMPLETE
