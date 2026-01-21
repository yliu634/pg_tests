# Repo Notes (Codex / Agents)

## Purpose

This repo contains CockroachDB-derived SQL test cases and helpers for running/adapting them on PostgreSQL.

## Vendored Skill: `crdb-to-pg-adaptation`

This repo vendors a Codex skill under `skills/crdb-to-pg-adaptation/` to help adapt `compatible/*.sql` files to run on PostgreSQL **without changing test semantics**, and to regenerate matching `compatible/*.expected` output.

## Install The Skill

Install the vendored skill into your local Codex skills directory:

```bash
./scripts/install_codex_skills.sh
```

Notes:
- Destination is `$CODEX_HOME/skills` (defaults to `~/.codex/skills`).
- Re-run with `--force` to overwrite an existing install.
- Restart Codex after installing so it can load the new skill.

## Typical Workflow (High Level)

1) Pick a test file: `compatible/<name>.sql`
2) Run it on PostgreSQL and capture errors.
3) Make the smallest possible SQL-only changes to preserve semantics while becoming PostgreSQL-compatible.
4) Regenerate expected output:

```bash
~/.codex/skills/crdb-to-pg-adaptation/scripts/regen_expected.sh compatible/<name>.sql
```

## Review Checklist (Before Submitting)

- SQL changes are minimal and compatibility-driven (syntax/types/functions), not a semantic rewrite.
- No “hacks”:
  - No `DO $$ ... EXCEPTION ... END $$;` to swallow failures
  - No commenting out the core statement/query under test
  - No replacing failing logic with `SELECT true`
- `.expected` reflects intended behavior. If a statement is *supposed* to error, keep that error visible in output.
  - If you must keep a file running past an expected error, scope it tightly (e.g. `\set ON_ERROR_STOP 0` only around that statement, then restore it).

