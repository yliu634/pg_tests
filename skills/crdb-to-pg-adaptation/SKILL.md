---
name: crdb-to-pg-adaptation
description: >
  Adapt CockroachDB-derived SQL tests in this workspace (compatible/*.sql) to run
  on PostgreSQL without changing test semantics; iterate from PostgreSQL error
  output; regenerate matching compatible/*.expected outputs.
metadata:
  short-description: Fix CRDB SQL tests for Postgres
---

# CRDB SQL → PG SQL (preserve semantics)

## Non-negotiables

- Do **not** “hide” failures with `DO $$ ... EXCEPTION ... END $$;`.
- Do **not** comment out core test statements to avoid errors (unless the
  semantic is truly unavailable in PostgreSQL and the test is explicitly marked
  as such).
- Do **not** replace failing statements with `SELECT true` (same exception as
  above).

## Inputs

- One or more `compatible/*.sql` files in this repo.

## References (bundled)

- Translation patterns: `references/COCKROACH_TO_PG.md`

## Workflow (error-driven loop)

1) Run the SQL file on PostgreSQL and capture the error output.
   - Use this repo’s runner: `./run_postgres_tests.sh compatible/<file>.sql`
   - Or use your own `psql` invocation (ensure a clean DB or explicit `DROP ...`).

2) Fix the SQL with the smallest possible change that preserves semantics.
   - Comment out Cockroach logic-test directives (`statement`, `query`,
     `skipif`, `onlyif`, etc.) so `psql` can run the file.
   - Apply the mapping/fix patterns from `references/COCKROACH_TO_PG.md`.
   - Prefer PG-native equivalents over “approximations” that change meaning.

3) Repeat steps 1–2 until there are **no** PostgreSQL `ERROR:` lines.
   - `NOTICE:` output is usually noise; prefer suppressing it via
     `SET client_min_messages = warning;` ... `RESET client_min_messages;`
     inside the SQL (many files already do this).

4) Regenerate the `.expected` file from a clean run.
   - Use the skill helper script (installed with this skill):
     `${CODEX_HOME:-~/.codex}/skills/crdb-to-pg-adaptation/scripts/regen_expected.sh compatible/<file>.sql`
   - It runs the file in an isolated temporary database and writes
     `compatible/<file>.expected` from the `psql` output.

5) Review before you submit (avoid “hacks”).
   - Review the SQL diff and confirm changes are *minimal* and *syntax/compat only*.
   - Review the generated `.expected` and confirm it reflects the intended test behavior
     (including any *expected* errors), not a “papered over” pass.
   - Red flags (do not do these):
     - Wrapping failures with `DO $$ ... EXCEPTION ... END $$;`
     - Commenting out the core statement/query under test
     - Replacing failing logic with `SELECT true`
     - Disabling errors globally (`\set ON_ERROR_STOP 0` for the whole file); only scope it
       tightly around *expected-error* statements when needed.

## Output expectations

- Keep output stable and comparable to `psql` default formatting.
- If you add `DROP ... IF EXISTS` for repeatability, keep it semantically
  neutral (setup/teardown only) and expect the command tags to appear in
  `.expected`.
