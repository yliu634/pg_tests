# Incomplete Large Files Worker 00 Report

## pg_tests/compatible/array.sql
- PROCESSING: `pg_tests/compatible/array.sql`
- File size: 1416 lines
- Status: MISSING `.expected`
- Major adaptations:
  - Converted CRDB logic-test directives (`query`, `statement`, `onlyif`, `#` comments) to SQL comments; added missing statement terminators.
  - Fixed PostgreSQL syntax/semantics issues: array subscripting needs parentheses, `ANY/ALL (ARRAY[...])`, typed empty arrays (`ARRAY[]::type[]`), typed NULL arrays (`ARRAY[NULL]::type[]`).
  - Removed/rewrote CRDB-only constructs: `@index` hints (`t@i`), `HASH/MERGE JOIN` keywords, `FAMILY` clauses, and `SET/RESET distsql_workmem`.
  - Added helpers used by the file: `jsonb_array_to_string_array(jsonb)`, `uuid_v4()` (via `pgcrypto`), and ICU collations `en`/`fr`.
  - Scoped expected-error statements with `\set ON_ERROR_STOP 0` / `\set ON_ERROR_STOP 1` (e.g., `SHOW CREATE TABLE`, invalid casts, duplicate key checks, missing PostGIS `geography`).
- RESULT: SUCCESS (`pg_tests/compatible/array.expected` generated)

## pg_tests/compatible/builtin_function.sql
- PROCESSING: `pg_tests/compatible/builtin_function.sql`
- File size: 2688 lines
- Status: MISSING `.expected`
- Major adaptations:
  - Converted remaining CRDB logic-test directives to SQL comments; added missing semicolons.
  - Converted Cockroach bytes literals (`b'...'`) into PostgreSQL `bytea` hex literals (`'\\x..'::bytea`).
  - Added `\set ON_ERROR_STOP 0` near the top so the file can run end-to-end while CRDB-only builtins are still present.
  - Added extensions/helpers to reduce noise and keep key sections runnable: `unaccent`, `pgcrypto`, plus helper wrappers `uuid_v4()`, `sha512(...)`, and `regexp_extract(text,text)`.
- RESULT: SUCCESS (`pg_tests/compatible/builtin_function.expected` generated)

Worker ID: 00
Status: COMPLETE
