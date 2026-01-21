# Large Files Round - Worker 10

This report tracks processing of the large SQL files assigned in `rounds/round_large_worker_10.txt`.

ADAPTED_SUCCESS: pg_tests/compatible/statement_hint_builtins.sql (1201 lines)
- Commented Cockroach logic-test directives and embedded EXPLAIN output blocks (`user`, `onlyif`, `let`, and plan text).
- Stubbed minimal `system`/`crdb_internal` schemas, tables, and functions referenced by the test.
- Rewrote Cockroach-only DDL (inline `INDEX (...)`) into PostgreSQL `CREATE INDEX` statements.
- Removed Cockroach variable placeholders (`$hint*`) by inlining constants and commented the Cockroach-only `[SHOW ...]` query.

ADAPTED_SUCCESS: pg_tests/compatible/subquery.sql (646 lines)
- Added missing PostgreSQL setup objects (`abc`, `kv`) and stubbed `crdb_internal` objects referenced by queries.
- Converted logic-test directives / non-SQL lines (`query ...`, `query error ...`, `subtest ...`, `# ...`) into SQL comments.
- Commented Cockroach-only statements (`INJECT STATISTICS`, `[show session_id]`) and rewrote the Cockroach bracketed INSERT-as-relation case into a plain INSERT.
- Fixed PostgreSQL syntax/behavior differences (array subscripting, scalar subqueries returning multiple columns via `ROW(...)`, join constraint for `FULL JOIN`, typed-NULL subqueries, and minor data tweaks to avoid PK conflicts in `xyz`).

Worker ID: 10
Large files processed: 2
Status: COMPLETE
