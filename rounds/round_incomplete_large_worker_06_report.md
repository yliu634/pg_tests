# Incomplete large files report

Worker ID: 06  
Manifest: `pg_tests/rounds/round_incomplete_large_worker_06.txt`  
Run date (UTC): 2026-01-22

## Results

### `pg_tests/compatible/insert.sql`

- File size: 687 lines
- Previous status: missing `pg_tests/compatible/insert.expected`
- Major adaptations:
  - Rewrote into psql-friendly SQL (statement terminators, deterministic `ORDER BY` where needed).
  - Removed/translated CockroachDB-only constructs:
    - `UNIQUE INDEX ...` / inline `INDEX ...` / `FAMILY (...)`
    - `@index` hints
    - `schema_locked` / `autocommit_before_ddl`
    - `SHOW CREATE ...` (replaced with `information_schema` introspection queries)
  - PostgreSQL syntax fixes:
    - Generated columns: `... GENERATED ALWAYS AS (...) STORED`
    - Identity inserts needing explicit values: `OVERRIDING SYSTEM VALUE`
    - Collations: `COLLATE en` → `COLLATE "C"`
    - Types: `BYTES` → `BYTEA`
    - Added `CREATE EXTENSION IF NOT EXISTS pgcrypto;` for `gen_random_uuid()`
  - Filled in missing setup tables/objects referenced by the test (`sw`, `string_t`, `t32759`), and made `kview` insertable via an `INSTEAD OF` trigger.
  - Fixed a `tn` CHECK-constraint violation by inserting `x` alongside `y`.
- Regen: SUCCESS (wrote `pg_tests/compatible/insert.expected`)

### `pg_tests/compatible/inspect.sql`

- File size: 300 lines
- Previous status: missing `pg_tests/compatible/inspect.expected`
- Major adaptations:
  - CockroachDB `INSPECT` and job tracking don’t exist in PostgreSQL; replaced with:
    - `ANALYZE` as a lightweight stand-in
    - a `last_inspect_job` table updated from `pg_indexes`
  - Added a small compatibility shim:
    - `crdb_internal.datums_to_bytes(anyelement) -> bytea` via `convert_to($1::text, 'UTF8')`
  - Converted unsupported types/features:
    - `VECTOR(...)` → `DOUBLE PRECISION[]` (pgvector extension not available here)
    - `STORING` → `INCLUDE`
    - `REFCURSOR` columns (not btree-indexable) → `TEXT`/`TEXT[]`
  - Renamed indexes to avoid cross-table name collisions (Postgres requires schema-unique index names).
- Regen: SUCCESS (wrote `pg_tests/compatible/inspect.expected`)

## Notes

- Regeneration was run via local peer auth to avoid password prompts:
  - `PG_SUDO_USER=postgres PG_USER=postgres PG_HOST=/var/run/postgresql`

Status: COMPLETE
