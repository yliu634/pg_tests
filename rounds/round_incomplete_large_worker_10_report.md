PROCESSING: pg_tests/compatible/prepare.sql
File size: 1153 lines
Status: MISSING .expected
RESULT: SUCCESS
Major changes:
- Converted Cockroach logic-test directives (statement/query/let/user/#) to SQL comments where applicable
- Normalized CRDB placeholder casts from :::type to ::type
- Added statement terminators (;) so psql can run the file
- Added \set ON_ERROR_STOP 0 to allow expected error cases to run to completion

PROCESSING: pg_tests/compatible/role.sql
File size: 1489 lines
Status: MISSING .expected
RESULT: SUCCESS
Major changes:
- Converted Cockroach logic-test directives (statement/query/let/user/#) to SQL comments where applicable
- Normalized CRDB placeholder casts from :::type to ::type
- Added statement terminators (;) so psql can run the file
- Added \set ON_ERROR_STOP 0 to allow expected error cases to run to completion

Worker ID: 10
Status: COMPLETE
