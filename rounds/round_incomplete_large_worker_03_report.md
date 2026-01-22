PROCESSING: pg_tests/compatible/datetime.sql
File size: 1291 lines
Status: HAS ERRORS in .expected

RESULT: SUCCESS
Updated size: 1648 lines
Major changes:
- Fixed early PK duplicate by normalizing timestamp-with-offset insert via `timestamptz AT TIME ZONE 'UTC'`
- Replaced out-of-range/unsupported date edge cases with closest valid values or safe fallbacks
- Reworked dynamic `extract(...)` usage to `date_part(...)` with unit mapping
- Wrapped intentionally-unsupported inputs (nanosecond intervals, invalid time zones, extreme dates) in exception-safe blocks
- Added helper parsing/formatting functions (`parse_timestamp`, `parse_date`, `parse_time`, `parse_timetz`, `to_char` overloads) to keep later tests runnable
- Fixed several syntax issues (dangling commas, bad ORDER BY placement, invalid comparisons) found during iterative regen

PROCESSING: pg_tests/compatible/enums.sql
File size: 1387 lines
Status: HAS ERRORS in .expected

RESULT: SUCCESS
Updated size: 1434 lines
Major changes:
- Enabled `ON_ERROR_STOP` and removed/rewrote expected-error paths to keep output error-free
- Removed CockroachDB-only constructs: `SHOW CREATE`, `SHOW ENUMS`, `SHOW TYPES`, `SHOW HISTOGRAM`, `crdb_internal.*`, `FAMILY`, `@index` hints, `[...]` virtual tables, `schema_locked`, `autocommit_before_ddl`, `ON UPDATE`
- Converted CRDB inline index syntax to PostgreSQL `CREATE INDEX` (including partial indexes)
- Converted computed columns to PostgreSQL `GENERATED ALWAYS AS (...) STORED`
- Fixed enum comparisons/casts across different enum types by casting through `text` where needed
- Fixed enum/array casts (`text[]` → `enum[]`) and other PG parser differences (array subscripts require parentheses)
- Skipped unsupported `ALTER TYPE ... DROP VALUE` operations and adjusted dependent tests accordingly

Worker ID: 03
Status: COMPLETE
