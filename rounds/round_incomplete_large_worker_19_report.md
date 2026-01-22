PROCESSING: pg_tests/compatible/window.sql
File size: 1627 lines
Status: MISSING .expected

RESULT: SUCCESS
Generated: pg_tests/compatible/window.expected (3893 lines)

Major adaptations:
- Converted logic-test directives (query/statement/query error/#) into psql-friendly SQL comments and added missing statement terminators.
- Added PostgreSQL setup: created concat_agg aggregate and self-contained kv table (k,v,w,d,f,s,b,i) with initial data.
- Fixed CRDB-only syntax/features: BYTES -> bytea, bytes literals, duplicate WINDOW definitions, and COPY-window usage with frame clauses.
- Added targeted \\set ON_ERROR_STOP 0/1 wrappers so expected-error statements don’t abort regeneration.
- Added missing fixtures for referenced tables: string_agg_test, t54604, and t.
- Replaced unsupported pieces: count(DISTINCT ...) OVER () via scalar subqueries; sqrdiff(x) via var_pop(x) * count(x); commented out CRDB-internal crdb_internal.feature_usage query.
- Adjusted out-of-range DATE literal for Postgres RANGE+INTERVAL window frame (5874897 -> 294276).

Worker ID: 19
Status: COMPLETE
