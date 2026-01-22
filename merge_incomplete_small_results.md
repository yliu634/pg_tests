# Merge Coordinator Report: Incomplete Small Files Round Results

## Delivery Branch

- Branch: `pantheon/pg-tests-expected-202601210820`
- Date: Thu Jan 22 14:15:17 UTC 2026

## Worker Branches Requested

The following 16 worker branches were requested for merge. At merge time, these refs were not advertised by `origin` (no matching `refs/heads/*`), so no direct `git merge origin/<branch>` could be performed.

- `gentle-mole-ee16f`
- `proud-yak-09cb7`
- `fearless-unicorn-0b0ba`
- `humble-newt-9439b`
- `dynamic-unicorn-14134`
- `jolly-monkey-93c99`
- `daring-kite-81631`
- `tranquil-jay-18a60`
- `inventive-jaguar-dab99`
- `graceful-owl-a5dd4`
- `unique-unicorn-4db05`
- `outstanding-falcon-03907`
- `agile-kite-7196a`
- `uplifting-zebra-51c76`
- `humble-ibis-53335`
- `agile-whale-17a04`

## Incomplete Small Round Coverage

- Manifest: `rounds/round_incomplete_small_1.txt` (78 SQL files)
- Worker report files present on delivery branch: 14 (`rounds/round_incomplete_small_1_worker_*_report.md`)
- SQL files covered by worker reports: 68
- Manifest entries not mentioned in any worker report: 10

Coordinator action taken to ensure manifest coverage on the delivery branch:

- Regenerated `.expected` outputs for the 10 missing manifest entries:
  - `compatible/udf_in_constraints.expected`
  - `compatible/udf_in_index.expected`
  - `compatible/udf_insert.expected`
  - `compatible/udf_oid_ref.expected`
  - `compatible/udf_schema_change.expected`
  - `compatible/udf_security.expected`
  - `compatible/udf_setof.expected`
  - `compatible/udf_star.expected`
  - `compatible/udf_unsupported.expected`
  - `compatible/udf_update.expected`

## Final Completion Statistics (All 457 SQL Files)

- Total SQL files: 457
- Baseline `.expected` files: 122
- Total `.expected` files in `compatible/`: 451
- New `.expected` files generated: 329
- Successfully completed (no `ERROR` in `.expected`): 405
- Files with `ERROR` remaining (`.expected` contains `ERROR`): 46
- SQL files missing `.expected`: 6

## Remaining Problematic Files

### Missing `.expected` (6)

- `compatible/txn.sql`
- `compatible/udf.sql`
- `compatible/udf_fk.sql`
- `compatible/udf_params.sql`
- `compatible/upsert.sql`
- `compatible/vector_index.sql`

### `.expected` Files Containing `ERROR` (46)

- `compatible/array.expected`
- `compatible/builtin_function.expected`
- `compatible/cascade.expected`
- `compatible/cast.expected`
- `compatible/default.expected`
- `compatible/fk.expected`
- `compatible/geospatial.expected`
- `compatible/pg_catalog.expected`
- `compatible/plpgsql_builtins.expected`
- `compatible/prepare.expected`
- `compatible/privileges_comments.expected`
- `compatible/privileges_table.expected`
- `compatible/proc_invokes_proc.expected`
- `compatible/procedure.expected`
- `compatible/procedure_polymorphic.expected`
- `compatible/role.expected`
- `compatible/row_level_security.expected`
- `compatible/schema_change_in_txn.expected`
- `compatible/set.expected`
- `compatible/show_create.expected`
- `compatible/show_create_all_tables_builtin.expected`
- `compatible/time.expected`
- `compatible/txn_as_of.expected`
- `compatible/txn_retry.expected`
- `compatible/type_privileges.expected`
- `compatible/typing.expected`
- `compatible/udf_calling_udf.expected`
- `compatible/udf_delete.expected`
- `compatible/udf_deps.expected`
- `compatible/udf_in_constraints.expected`
- `compatible/udf_in_index.expected`
- `compatible/udf_insert.expected`
- `compatible/udf_oid_ref.expected`
- `compatible/udf_record.expected`
- `compatible/udf_schema_change.expected`
- `compatible/udf_security.expected`
- `compatible/udf_setof.expected`
- `compatible/udf_star.expected`
- `compatible/udf_unsupported.expected`
- `compatible/udf_update.expected`
- `compatible/update.expected`
- `compatible/values.expected`
- `compatible/vectorize_local.expected`
- `compatible/views.expected`
- `compatible/virtual_columns.expected`
- `compatible/window.expected`

## Overall Project Status

The suite is not fully complete yet:

- 6 (large) SQL files still lack a generated `.expected`.
- 46 `.expected` files still contain `ERROR` output (some may be semantically expected errors, but they count toward the remaining-error metric used here).

Suggested next actions:

- Generate/adapt the 6 missing-expected SQL files to allow `compatible/<name>.expected` generation.
- Review the 46 remaining `ERROR`-bearing `.expected` files to confirm whether errors are expected/acceptable or should be eliminated via further SQL adaptation.
