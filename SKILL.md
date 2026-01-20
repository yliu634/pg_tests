---
name: crdb-to-pg-adaptation
description: >
  Convert CockroachDB SQL tests in this workspace to PostgreSQL-compatible SQL **WITHOUT** changing the semantic meaning of sql tests. Fix compatible/*.sql based on the error information of pg_tests output and then regenerating .expected outputs.
---

# CRDB SQL -> PG SQL (No DO Wrap / No Commenting Core Tests)

## Inputs

a single *.sql test file

## Workflow

0) Read `COCKROACH_TO_PG.md` and internalize the translation patterns.

1) Use `COCKROACH_TO_PG.md` to perform the first-pass edits on the target SQL file.

2) Run the SQL with postgresql and check for ERROR output. NOTICE can be ignored, write output named as *.expected back to compatible folder

3) If there are ERRORs, fix the SQL according to output, then repeat steps 2-3 until there are no ERRORs, and write output named as *.expected back to compatible folder

