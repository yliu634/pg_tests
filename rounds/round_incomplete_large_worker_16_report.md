# Incomplete large files worker 16 report

Regen config (local peer auth):
- PG_SUDO_USER=postgres
- PG_USER=postgres
- PG_HOST=/var/run/postgresql

PROCESSING: pg_tests/compatible/udf_record.sql
File size: 533 lines
Status: HAS ERRORS in .expected
RESULT: REGEN_SUCCESS (file contains expected ERROR output; no diffs after regen)

PROCESSING: pg_tests/compatible/update.sql
File size: 518 lines
Status: HAS ERRORS in .expected
RESULT: REGEN_SUCCESS (file intentionally runs with \\set ON_ERROR_STOP 0; no diffs after regen)

Worker ID: 16
Status: COMPLETE
