OK|pg_tests/compatible/alter_default_privileges_for_all_roles.sql
OK|pg_tests/compatible/alter_default_privileges_for_schema.sql
OK|pg_tests/compatible/alter_default_privileges_for_sequence.sql
OK|pg_tests/compatible/alter_default_privileges_for_table.sql
OK|pg_tests/compatible/alter_default_privileges_for_type.sql
OK|pg_tests/compatible/alter_default_privileges_in_schema.sql
OK|pg_tests/compatible/alter_default_privileges_with_grant_option.sql
OK|pg_tests/compatible/alter_external_connection.sql
OK|pg_tests/compatible/alter_primary_key.sql
OK|pg_tests/compatible/alter_role.sql
OK|pg_tests/compatible/alter_role_set.sql
OK|pg_tests/compatible/alter_schema_owner.sql
OK|pg_tests/compatible/alter_sequence.sql
OK|pg_tests/compatible/alter_sequence_owner.sql
OK|pg_tests/compatible/alter_table.sql
OK|pg_tests/compatible/alter_table_owner.sql
OK|pg_tests/compatible/alter_type.sql
OK|pg_tests/compatible/alter_type_owner.sql
OK|pg_tests/compatible/alter_view_owner.sql
OK|pg_tests/compatible/and_or.sql
OK|pg_tests/compatible/apply_join.sql
FAIL|pg_tests/compatible/array.sql|Too many PG incompatibilities; requires major rewrite
OK|pg_tests/compatible/as_of.sql
OK|pg_tests/compatible/auto_span_config_reconciliation_job.sql
OK|pg_tests/compatible/bit.sql
OK|pg_tests/compatible/bpchar.sql
OK|pg_tests/compatible/buffered_writes.sql
FAIL|pg_tests/compatible/builtin_function.sql|Large logic-test file with many PG-incompatible directives/literals
OK|pg_tests/compatible/builtin_function_notenant.sql
OK|pg_tests/compatible/bytes.sql
OK|pg_tests/compatible/canary_stats.sql
FAIL|pg_tests/compatible/cascade.sql|Extensive CRDB-only syntax/features; major port needed
OK|pg_tests/compatible/case.sql
OK|pg_tests/compatible/case_sensitive_names.sql
FAIL|pg_tests/compatible/cast.sql|Extensive CRDB-only syntax/features; major port needed
FAIL|pg_tests/compatible/check_constraints.sql|Contains many intentional error cases/invalid constraints; needs rewrite
OK|pg_tests/compatible/citext.sql
FAIL|pg_tests/compatible/cluster_locks.sql|Relies on CRDB cluster locks/user-session semantics; not directly portable
FAIL|pg_tests/compatible/cluster_locks_write_buffering.sql|Relies on CRDB cluster locks/write buffering semantics; not directly portable
OK|pg_tests/compatible/cluster_settings.sql
FAIL|pg_tests/compatible/collatedstring.sql|Many collation variants/unsupported constructs; needs substantial rewrite
OK|pg_tests/compatible/collatedstring_constraint.sql
OK|pg_tests/compatible/collatedstring_index1.sql
OK|pg_tests/compatible/collatedstring_index2.sql
OK|pg_tests/compatible/collatedstring_normalization.sql
OK|pg_tests/compatible/collatedstring_nullinindex.sql
OK|pg_tests/compatible/collatedstring_uniqueindex1.sql
OK|pg_tests/compatible/collatedstring_uniqueindex2.sql
OK|pg_tests/compatible/column_families.sql
FAIL|pg_tests/compatible/comment_on.sql|CRDB system tables/SHOW commands/directives; major rewrite needed
