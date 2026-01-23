ADAPTED_SUCCESS: pg_tests/compatible/subquery_correlated.sql (694 lines)
- Added missing semicolons between statements to make the script psql-runnable.
- Commented non-SQL harness lines (e.g. '#' and 'query IT') as SQL comments.
- Fixed scalar subqueries that returned multiple rows (DISTINCT / ORDER BY ... LIMIT 1).
- Replaced CRDB-only constructs: concat_agg -> string_agg, unique_rowid() -> IDENTITY.
- Added required aliases for derived tables in FROM.

SUCCESS: pg_tests/compatible/table.sql (563 lines)
- Regenerated pg_tests/compatible/table.expected (script completes; ERROR lines are expected in this test via \set ON_ERROR_STOP 0 blocks).


Worker ID: 11
Large files processed: 2
Status: COMPLETE
