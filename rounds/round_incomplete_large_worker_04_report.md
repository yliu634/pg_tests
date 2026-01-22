PROCESSING: pg_tests/compatible/fk.sql
File size: 3791 lines
Status: MISSING .expected

Actions:
- Added statement terminators (`;`) throughout so `psql` can run the file.
- Commented Cockroach-only directives/settings (`CLUSTER SETTING`, `enable_insert_fast_path`, `schema_locked`, `skipif/onlyif`).
- Converted `CREATE DATABASE "user content"` to `CREATE SCHEMA IF NOT EXISTS "user content"` (avoid creating extra DBs).
- Added `\\set ON_ERROR_STOP 0` so `.expected` can be regenerated even when statements error.

Regen:
- `pg_tests/skills/crdb-to-pg-adaptation/scripts/regen_expected.sh pg_tests/compatible/fk.sql`

Result:
- Generated: `pg_tests/compatible/fk.expected`
- RESULT: PERSISTENT_ERRORS (628 lines containing `ERROR:`)

PROCESSING: pg_tests/compatible/geospatial.sql
File size: 2128 lines
Status: MISSING .expected

Actions:
- Installed PostGIS packages in the environment and enabled `postgis` in the test DB (`CREATE EXTENSION IF NOT EXISTS postgis;`).
- Removed Cockroach `FAMILY` clause from `CREATE TABLE geo_table`.
- Added statement terminators (`;`) and commented `skipif/onlyif` directives.
- Added `\\set ON_ERROR_STOP 0` so `.expected` can be regenerated even when statements error.

Regen:
- `pg_tests/skills/crdb-to-pg-adaptation/scripts/regen_expected.sh pg_tests/compatible/geospatial.sql`

Result:
- Generated: `pg_tests/compatible/geospatial.expected`
- RESULT: PERSISTENT_ERRORS (126 lines containing `ERROR:`; common failures include SRID/type modifier mismatches)

Worker ID: 04
Status: COMPLETE
