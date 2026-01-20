# Repo Notes (Codex / Agents)

## Purpose

This repo contains CockroachDB-derived SQL test cases and helpers for running/adapting them on PostgreSQL.

## Vendored Skill: `crdb-to-pg-adaptation`

This repo vendors a Codex skill under `skills/crdb-to-pg-adaptation/` to help adapt `compatible/*.sql` files to run on PostgreSQL **without changing test semantics**, and to regenerate matching `compatible/*.expected` output.

## Install The Skill

```bash
scripts/install_codex_skills.sh
```
