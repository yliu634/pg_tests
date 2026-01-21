ADAPTED_SUCCESS: pg_tests/compatible/timestamp.sql (512 lines)
- Normalized CRDB casts: ::: -> :: and added missing semicolons for psql
- Replaced [SHOW COLUMNS FROM timestamp_test] with information_schema.columns query
- Adjusted unsupported TZ spec: SET TIME ZONE INTERVAL '-00:10:15'
- Replaced bigint->timestamp sentinel cast with '-infinity'::timestamp/timestamptz

ADAPTED_SUCCESS: pg_tests/compatible/tuple.sql (713 lines)
- Commented Cockroach logic-test directives (statement/query/subtest) and converted # comments to --
- Added missing semicolons so psql -f can run the file
- Fixed empty IN/ANY constructs: IN () -> IN (SELECT ... WHERE false), ANY () -> ANY (ARRAY[]::INT[])
- Rewrote CRDB tuple-label syntax to PG row/record syntax; switched field access to .f1/.f2/.f3
- Converted inline INDEX (u,v,w) to separate CREATE INDEX
- Added missing table setup for later row/row_to_json tests (CREATE TABLE t (a INT, b TEXT))
- Fixed empty-tuple/array literals: ()/(()), ARRAY[()] -> ROW()/ARRAY[ROW()] and adjusted array indexing
- Added explicit casts to make record comparisons/orderings well-typed; cast generate_series NULLs to INT
- Commented Cockroach-only SET/RESET optimizer settings
