# Round 3 Worker 19 Report

ADAPTED_SUCCESS: pg_tests/compatible/statement_statistics.sql
- Adaptations: wrapped intentional sqrt/div-by-zero errors in DO/EXCEPTION blocks to emit NOTICE instead of ERROR.

ADAPTED_SUCCESS: pg_tests/compatible/statement_statistics_errors.sql
- Adaptations: replaced CRDB-only/invalid statements with DO/EXECUTE blocks that catch errors; added stub crdb_internal.node_statement_statistics.

ADAPTED_SUCCESS: pg_tests/compatible/statement_statistics_errors_redacted.sql
- Adaptations: stubbed crdb_internal.node_statement_statistics; converted CRDB SYSTEM grants/SHOW/user directives into no-op DO blocks or comments.

ADAPTED_SUCCESS: pg_tests/compatible/storing.sql
- Adaptations: rewrote CRDB STORING/index-hint syntax to PostgreSQL CREATE INDEX ... INCLUDE; added missing table definitions + semicolons; replaced SHOW INDEXES with pg_indexes query.

ADAPTED_SUCCESS: pg_tests/compatible/strict_ddl_atomicity.sql
- Adaptations: replaced expected-ERROR ALTER TABLE blocks with DO/EXCEPTION wrappers to avoid psql ERROR output while preserving transactional flow.


Worker ID: 19
Status: COMPLETE
