# CRDB-to-PostgreSQL Test Conversion — Final Completion Report

- Date: Fri Jan 23 08:21:03 UTC 2026
- Delivery branch: `pantheon/pg-tests-expected-202601210820`

## Verification

All CockroachDB-derived SQL tests in `compatible/` were verified to have matching PostgreSQL `.expected` output files.

Summary (derived from `compatible/` top-level file counts and `.expected` content checks):

- Total SQL files: **457**
- Total `.expected` files: **457**
- Missing `.expected`: **0**
- Files with `ERROR:` in `.expected`: **46** (**10.07%**)
- Clean `.expected` (no `ERROR:`): **411** (**89.93%**)

## Notes on `ERROR:` results

The `ERROR:` lines in `.expected` files reflect PostgreSQL error output observed/expected when running the test file. Some errors may be *intentional* (tests that validate error paths). Others may still represent remaining CRDB-to-PostgreSQL incompatibilities that could be adapted further if “clean runs” are desired.

## Files with remaining `ERROR:` output (46)

```
array.expected
builtin_function.expected
cascade.expected
cast.expected
default.expected
fk.expected
geospatial.expected
pg_catalog.expected
plpgsql_builtins.expected
prepare.expected
privileges_comments.expected
privileges_table.expected
proc_invokes_proc.expected
procedure.expected
procedure_polymorphic.expected
role.expected
row_level_security.expected
schema_change_in_txn.expected
set.expected
show_create.expected
show_create_all_tables_builtin.expected
time.expected
txn_as_of.expected
txn_retry.expected
type_privileges.expected
typing.expected
udf_calling_udf.expected
udf_delete.expected
udf_deps.expected
udf_in_constraints.expected
udf_in_index.expected
udf_insert.expected
udf_oid_ref.expected
udf_record.expected
udf_schema_change.expected
udf_security.expected
udf_setof.expected
udf_star.expected
udf_unsupported.expected
udf_update.expected
update.expected
values.expected
vectorize_local.expected
views.expected
virtual_columns.expected
window.expected
```

## Project summary

This conversion effort processed **all 457** `compatible/*.sql` test files and produced a complete corresponding set of `compatible/*.expected` outputs for PostgreSQL.

Key adaptation themes applied across the suite included:

- CRDB DDL compatibility changes (e.g., removing `FAMILY` clauses)
- DML rewrites (e.g., `UPSERT` → `INSERT ... ON CONFLICT`)
- Replacing CRDB-only introspection (`SHOW CREATE TABLE`, `crdb_internal`, `distsql`) with PostgreSQL catalog queries or simplified equivalents
- Index syntax updates (e.g., `STORING` → `INCLUDE`)
- Adjustments for PL/pgSQL and function/procedure semantics where CRDB differs

## Next steps (optional)

If the goal shifts from “all files have `.expected`” to “all files run without `ERROR:`”, the recommended follow-up is to triage the 46 files above into:

1) **Intentional error tests** (keep errors as-is), and
2) **Compatibility gaps** (apply minimal SQL-only fixes, then regenerate `.expected`).

