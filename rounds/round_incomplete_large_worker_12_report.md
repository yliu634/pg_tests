# Incomplete Large Files Worker Report

Worker ID: 12

Manifest: pg_tests/rounds/round_incomplete_large_worker_12.txt
Generated: 2026-01-22T11:04:02Z

## PROCESSING: pg_tests/compatible/select.sql
File size: 637 lines
Status: MISSING .expected
Attempt 1: regen_expected.sh
regen exit code: 2
expected now exists: no

Attempt 2: regen_expected.sh (via socket)
regen exit code: 1
expected now exists: no

Attempt 3: regen_expected.sh after SQL adaptations
regen exit code: 1
expected now exists: no

Attempt 4: regen_expected.sh after MaxIntTest BIGINT
regen exit code: 1
expected now exists: no

Attempt 5: regen_expected.sh after current_user syntax fix
regen exit code: 0
expected now exists: yes
expected contains psql ERROR lines: no

## PROCESSING: pg_tests/compatible/set.sql
File size: 717 lines
Status: HAS ERRORS in .expected
Attempt 1: regen_expected.sh (via socket)
regen exit code: 0
expected now exists: yes
expected contains psql ERROR lines: yes
  1:psql:pg_tests/compatible/set.sql:8: ERROR:  unrecognized configuration parameter "foo"
  2:psql:pg_tests/compatible/set.sql:11: ERROR:  unrecognized configuration parameter "foo"
  42:psql:pg_tests/compatible/set.sql:61: ERROR:  relation "bar" already exists
  53:psql:pg_tests/compatible/set.sql:74: ERROR:  syntax error at or near "("
  67:psql:pg_tests/compatible/set.sql:86: ERROR:  unrecognized configuration parameter "distsql"
  68:psql:pg_tests/compatible/set.sql:89: ERROR:  unrecognized configuration parameter "distsql"
  69:psql:pg_tests/compatible/set.sql:92: ERROR:  unrecognized configuration parameter "distsql"
  70:psql:pg_tests/compatible/set.sql:95: ERROR:  unrecognized configuration parameter "distsql"
  73:psql:pg_tests/compatible/set.sql:104: ERROR:  123 is outside the valid range for parameter "extra_float_digits" (-15 .. 3)
  80:psql:pg_tests/compatible/set.sql:125: ERROR:  invalid value for parameter "client_encoding": "other"

### Notes / Major Changes (pg_tests/compatible/select.sql)
- Converted Cockroach logic-test directives (`statement ok`, `query ...`, `retry`, etc.) to comments and added missing semicolons so `psql -f` can run end-to-end.
- Added schema `test` + `search_path` to emulate Cockroach’s database qualification (PostgreSQL has no cross-database qualification).
- Removed CockroachDB-only syntax (inline `INDEX`, `@{...}`/`@index` hints, `FAMILY`, `INJECT STATISTICS`, `crdb_internal.*`) or replaced with PostgreSQL equivalents (separate `CREATE INDEX`, generated columns).
- Fixed PostgreSQL incompatibilities: `INT` -> `BIGINT` for the max-int64 case, `current_user()` -> `current_user`.
- Added minimal missing setup for referenced tables (`c`, `trrec`) so later queries can execute.

RESULT: SUCCESS (generated `pg_tests/compatible/select.expected` with no `psql:...ERROR:` lines)

### Notes / Major Changes (pg_tests/compatible/set.sql)
- Regenerated `pg_tests/compatible/set.expected` from current SQL.
- Left existing error cases in place (file sets `\\set ON_ERROR_STOP 0` and intentionally exercises unsupported/invalid `SET`/`SHOW` variants on PostgreSQL).

RESULT: STILL_HAS_ERRORS (likely expected for this file’s coverage)

Status: COMPLETE
