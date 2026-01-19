# Cockroach SQL to PostgreSQL SQL: Quick Fix Guide

This file summarizes the common errors seen when running Cockroach-style SQL
under PostgreSQL and the typical fixes used in this workspace.

## General approach
- Prefer PG-native syntax and functions over Cockroach-specific ones.
- Add `DROP TABLE IF EXISTS` before `CREATE TABLE` when repeated runs are
  expected, and suppress NOTICE output with:
  `SET client_min_messages = warning;` ... `RESET client_min_messages;`
- Convert logic-test directives (`statement`, `query`, `onlyif`, `skipif`, etc.)
  to SQL comments so `psql` can run the file directly.

## Syntax and type incompatibilities

### 1) Cockroach-only types and casts
- `STRING` -> `TEXT`
- `BYTES` -> `BYTEA`
- `INT8` -> `BIGINT`
- `b'...'` byte literal -> `'\x..'::bytea` or `'...'::bytea` with hex
  (avoid `\x..` escape sequences that include backslashes mid-string).
- Bit-string columns (`BIT`, `VARBIT`) require `B'1010'` literals in PG.
- `BIT/VARBIT` values should use bit literals: `B'1010'` instead of `::bytea`.
- Bytea to UUID: cast via hex text, e.g. `encode(bytea_col, 'hex')::uuid`,
  and ensure values are 16 bytes before altering types.

### 2) Cockroach-only table/index syntax
- Inline index in `CREATE TABLE`:
  `CREATE TABLE t (a INT, INDEX (a))`
  -> `CREATE TABLE t (a INT);` and optionally add a separate `CREATE INDEX`.
- `STORING` -> `INCLUDE` (PG 11+):
  `INDEX(a) STORING (b)` -> `CREATE INDEX ... ON t(a) INCLUDE (b);`
- `@index` table hint -> remove or rewrite query without it.
- `LOOKUP JOIN` -> `JOIN`
- `FAMILY (...)` -> remove (PG does not support column families).
  If `FAMILY` appears inline on the same `CREATE TABLE` line, remove the clause
  rather than dropping the whole statement.
- `VIRTUAL` generated columns -> use PG `GENERATED ALWAYS AS (...) STORED`.
  For type changes, drop and re-add the generated column with the new type.
- Computed columns:
  `col TYPE AS (expr) STORED|VIRTUAL` -> `col TYPE GENERATED ALWAYS AS (expr) STORED`
  (PG has no virtual generated columns; use stored).

### 3) Cockroach session settings
- `SET schema_locked = ...` -> remove
- `SET null_ordered_last = ...` -> remove or handle in `ORDER BY ... NULLS ...`
- `SET testing_optimizer_disable_rule_probability = ...` -> remove
- `SHOW CREATE ...` -> use `SELECT pg_get_viewdef('view'::regclass, true);`
- Other Cockroach-only settings to comment:
  - `SET enable_experimental_*`
  - `SET experimental_*`
  - `SET autocommit_before_ddl`
  - `SET ttl_*`
  - `SET use_declarative_schema_changer`

### 3a) Default privileges differences
- PG does not support `ALTER DEFAULT PRIVILEGES FOR ALL ROLES`; use the current
  role or an explicit `FOR ROLE ...` list instead.
  If possible, remove these lines instead of commenting to keep files clean.

## Function differences

### 4) Missing aggregates
- `sum_int(x)` -> `sum(x)`
- `count_rows()` -> `count(*)`
- `array_cat_agg` -> `array_agg` (often requires non-empty arrays)
- `xor_agg(bytea)` -> `bit_xor(get_byte(bytea, 0))` or switch to integer input
- `sqrdiff(x)` -> `variance(x)` (closest PG substitute)
- `concat_agg(x)` -> `string_agg(x, '' ORDER BY ...)`

### 5) Aggregates on unsupported types
- `min(boolean)` / `max(boolean)` -> `bool_and` / `bool_or`
- `avg(text)` -> `avg(length(text))` or cast to numeric as needed
- `round(double precision, n)` -> `round(value::numeric, n)`

## Query semantics

### 6) GROUP BY rules (PG is stricter)
- Every selected non-aggregate column must appear in `GROUP BY`.
- Rewrite:
  - `SELECT count(*), k+v FROM kv GROUP BY k;` -> add `v` to `GROUP BY`
  - `HAVING v > 2` -> `HAVING max(v) > 2` if `v` is not grouped
  - Nested aggregates like `max(avg(k))` are not allowed -> remove or rewrite

### 7) SRF in aggregates
- `array_agg(generate_series(...))` is not allowed.
  Use `SELECT array_agg(x) FROM generate_series(...) AS g(x);`

### 8) Arrays and NULLs
- `array_agg(NULL)` is ambiguous; cast:
  `array_agg(NULL::int)` or `array_agg(ARRAY[NULL]::int[])`
- Avoid aggregating empty arrays; PG errors on `array_agg('{}'::int[])`.
  Use non-empty arrays when required.

## Missing schema/data setup

### 9) Tables referenced but not created
- If a query references `string_agg_test`, `osagg`, `index_tab`, `t_collate`,
  `profiles`, `users`, etc., add `CREATE TABLE` and seed data before use.

### 10) Drop/create flow
- Use `DROP TABLE IF EXISTS` before creating tables to allow repeat runs.
- To avoid NOTICE output:
  `SET client_min_messages = warning;` at top and `RESET` at end.

### 11) Inline test directives in SQL
- `onlyif`/`skipif` lines from logic tests must be commented.
- `SHOW COLUMNS` -> query `information_schema.columns` with `ORDER BY ordinal_position`.

### 12) Cockroach-only clauses to comment
- `SET TRANSACTION AS OF SYSTEM TIME ...` and `AS OF SYSTEM TIME` are Cockroach-only.
- `ALTER TABLE ... SET NOT VISIBLE` / `VISIBLE` -> comment or remove.

## Casting and encoding fixes
- `BYTEA` -> `TEXT`: use `USING encode(col, 'escape')` or `convert_from(col, 'UTF8')`.
- `TEXT` -> `BYTEA`: use `USING convert_to(col, 'UTF8')`.
- `BYTEA` -> `UUID`: use `USING encode(col, 'hex')::uuid` with 16-byte values.

## JSON / object aggregation
- `json_object_agg(null, ...)` errors in PG. Use a non-null key:
  `json_object_agg('key', value)`

## Regex differences
- In PG, invalid regex patterns error. Escape `+` and other operators as needed:
  `'' !~ '\\+'`

## You CANNOT do
- If a statement shows error in PG, you are not allow to wrap it so PG swallows the
  failure just to avoid errors:
  `DO $$ BEGIN EXECUTE '...'; EXCEPTION WHEN others THEN END $$;`

- If a statement shows error in PG, you are not allow to **comment** test just to avoid errors, unless its semantic is not available in PG (this case is not common).


---

This guide reflects the changes applied to `compatible/aggregate.sql` to make it
run cleanly under PostgreSQL.