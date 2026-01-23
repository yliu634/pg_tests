ADAPTED_SUCCESS: pg_tests/compatible/with.sql (800 lines)

Adaptations made:
- Converted sqllogictest directives (#/query/statement) into SQL comments and added missing statement terminators.
- Fixed PG-only restrictions: data-modifying WITH must be top-level; duplicate CTE name; CTE column-count mismatch; INSERT CTE without RETURNING.
- Rewrote Cockroach-only syntax: UPSERT -> INSERT .. ON CONFLICT; inline INDEX clauses -> CREATE INDEX; removed @index hints; commented Cockroach CLUSTER/enable_* settings.
- Resolved semantic mismatches/limits: ordered ON CONFLICT insert to avoid conflicts; split some multi-upsert statements (PG cannot affect the same row twice in one statement); rewrote DELETE .. ORDER BY/LIMIT using ctid subqueries.
- Added DROP TABLE IF EXISTS for a few names (r/s, t100561a/b) to avoid conflicts with polluted template DBs.

Worker ID: 19
Large files processed: 1
Status: COMPLETE
