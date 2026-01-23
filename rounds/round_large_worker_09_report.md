# Large Files Round Report (Worker 09)

ADAPTED_SUCCESS: pg_tests/compatible/set.sql (694 lines)
- Added `\set ON_ERROR_STOP 0` and statement terminators so psql can run the full file.
- Replaced CockroachDB-only database/table introspection with PostgreSQL equivalents:
  - `SET database` -> `SET search_path` (schema-based approximation)
  - `CREATE DATABASE foo` -> `CREATE SCHEMA foo`
  - `SHOW TABLES [FROM foo]` -> `information_schema.tables` queries
  - `SHOW database` -> `SELECT current_schema() AS database`
  - `SHOW session_user` -> `SELECT session_user`
- Regenerated `pg_tests/compatible/set.expected`.

ADAPTED_SUCCESS: pg_tests/compatible/srfs.sql (659 lines)
- Commented out CockroachDB logic-test directives and converted `#` comments to `--` so psql can execute the file.
- Added `\set ON_ERROR_STOP 0` and statement terminators; added minimal setup/shims used by the tests:
  - `crdb_internal` schema + `crdb_internal.unary_table()`
  - `isnan(double precision)` shim
  - created tables `t` and `u` used by early joins
- Fixed several CockroachDB/PG incompatibilities so later sections execute meaningfully:
  - disambiguated duplicate `generate_series` table names in `FROM`
  - added default dimension for `generate_subscripts(array)`
  - converted CRDB computed-column syntax to PG generated-column syntax (keeps expected error behavior)
  - rewrote CRDB inline `INDEX` syntax in `CREATE TABLE vals` into PG `CREATE INDEX` (preserving the drop-column CASCADE flow)
  - fixed invalid `INSERT INTO xy (VALUES ...)` syntax
  - added column definitions for `unnest(ARRAY[(..),(..)])` in `FROM`
  - rewrote multi-array `unnest(...)` SELECT-list calls into `FROM unnest(...) ...`
  - renamed CRDB-only session variable `testing_optimizer_disable_rule_probability` to a PG custom GUC `crdb.*`
- Regenerated `pg_tests/compatible/srfs.expected`.

Worker ID: 09
Large files processed: 2
Status: COMPLETE
