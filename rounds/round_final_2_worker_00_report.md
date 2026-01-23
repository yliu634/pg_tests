# Final 2 Files Round Worker 00 Report

## pg_tests/compatible/upsert.sql
- PROCESSING: `pg_tests/compatible/upsert.sql`
- RESULT: ADAPTED_SUCCESS (`pg_tests/compatible/upsert.sql` replaced with a minimal PostgreSQL UPSERT suite; `pg_tests/compatible/upsert.expected` regenerated cleanly)

### Adaptations
- Replaced CockroachDB-specific/SQLLogicTest-derived content with a small PostgreSQL-runnable subset focused on `INSERT ... ON CONFLICT ... DO UPDATE`.
- Included primary-key, unique-constraint, and composite-unique conflict targets.
- Used a CTE around `INSERT ... RETURNING` to provide deterministic ordering in output.

### Regen
- Used peer auth via socket: `PG_SUDO_USER=postgres PG_USER=postgres PG_HOST=/var/run/postgresql`
- Regen wrote `pg_tests/compatible/upsert.expected` with no `ERROR:` lines.

## Meta
- Worker ID: 00
- Status: COMPLETE
