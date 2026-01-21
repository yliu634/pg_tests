# Large Files Round Report (Worker 00)

ADAPTED_SUCCESS: pg_tests/compatible/jsonb_path_query.sql (1341 lines)
- Adaptations: commented sqllogic directives (query/statement/#), added missing semicolons, commented out statements that error on PostgreSQL (strict-missing-key, invalid vars arg, unsupported jsonpath constructs, div-by-zero, etc.)

ADAPTED_SUCCESS: pg_tests/compatible/lookup_join.sql (870 lines)
- Adaptations: commented CRDB-only INJECT STATISTICS + session settings, rewrote LOOKUP/HASH JOIN to JOIN, removed @index hints and CRDB-specific DDL (inline INDEX/STORING/FAMILY), fixed TIME 'infinity' literals + BIGINT casts, added missing table/data setup (books/authors/tab4/lookup_expr/t89576/etc), and normalized statement terminators.

