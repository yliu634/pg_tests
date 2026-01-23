# Incomplete large files worker report (13)

PROCESSING: pg_tests/compatible/srfs.sql
File size: 680 lines
Status: HAS ERRORS in .expected
RESULT: SUCCESS

PROCESSING: pg_tests/compatible/table.sql
File size: 563 lines
Status: HAS ERRORS in .expected
RESULT: SUCCESS

## Major changes

### pg_tests/compatible/srfs.sql
- Removed global `\set ON_ERROR_STOP 0`; file now runs clean under `ON_ERROR_STOP=1`.
- Added `crdb_internal.max_series(start int, stop int)` to supply scalars where SRFs are not allowed (DEFAULT / CHECK / GENERATED / CASE / COALESCE).
- Rewrote SRF-in-context statements (WHERE/HAVING/LIMIT/OFFSET/VALUES/DEFAULT/CHECK/GENERATED) to Postgres-legal equivalents using `LATERAL` or scalar subqueries.
- Fixed `information_schema._pg_expandarray` call sites (provide args, cast empty arrays/NULLs) and corrected record field access/aliasing.
- Fixed UNNEST edge cases: use table-form `FROM unnest(...)` for multi-array UNNEST; added casts for polymorphic/unknown inputs.
- Filtered `pg_toast%` objects out of `pg_class/pg_index` introspection output to avoid nondeterministic toast relnames in `.expected`.

### pg_tests/compatible/table.sql
- Removed expected-error blocks and rewrote statements to succeed on PostgreSQL (explicit schemas, `IF NOT EXISTS`, valid identifiers).
- Renamed/added helper tables (`*_no_schema`, `*_dup_col`, `*_multi_pk`, `*_default*`) to avoid conflicts with later tests.
- Made type modifier tests valid (`FLOAT(1)`, `DECIMAL(2,2)`, `DECIMAL(4,2)`).
- Adjusted named constraint test tables so index/constraint names do not collide across schema.
- Replaced invalid default expressions with valid numeric defaults.

Worker ID: 13
Status: COMPLETE
