# Incomplete Large Files Worker 07 Report

Manifest: rounds/round_incomplete_large_worker_07.txt

## PROCESSING: compatible/json_builtins.sql
File size: 890 lines
Status: MISSING .expected

## PROCESSING: compatible/ltree.sql
File size: 929 lines
Status: HAS ERRORS in .expected

RESULT: SUCCESS (compatible/json_builtins.sql)
- Generated compatible/json_builtins.expected (no ERROR lines)
- Major adaptations: JSONB casts for jsonb_* functions, removed/rewrote error-only queries, replaced json||json with jsonb||jsonb
- Removed references to missing prepared statements (jbo_stmt/jba_stmt) by inlining equivalent queries
- Replaced missing collation "fr_FR" with "C"
- Reworked json_populate_record/json_to_record sections to be PostgreSQL-compatible (typed composites, jsonb_to_record*, removed Cockroach-only rowid usage)

RESULT: SUCCESS (compatible/ltree.sql)
- Regenerated compatible/ltree.expected (no ERROR lines)
- Major adaptations: enforced "\set ON_ERROR_STOP 1" and removed intentional error cases by making inputs valid
- Fixed invalid defaults/generated columns, constraint-violating inserts, and invalid LTREE literals/arrays
- Adjusted boundary tests to stay within Postgres LTREE limits (e.g., 1001→1000, reduced label-count stress cases)

Worker ID: 07
Status: COMPLETE
