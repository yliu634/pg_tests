-- PostgreSQL compatible tests from rename_sequence
--
-- The upstream CockroachDB logic-test file includes negative cases (renaming a
-- sequence via ALTER TABLE/VIEW). This reduced version exercises renaming a
-- sequence in PostgreSQL without errors.

SET client_min_messages = warning;

DROP SEQUENCE IF EXISTS alter_test;
DROP SEQUENCE IF EXISTS renamed_alter_test;
DROP SEQUENCE IF EXISTS renamed_again_alter_test;

CREATE SEQUENCE alter_test;
ALTER SEQUENCE alter_test RENAME TO renamed_alter_test;
ALTER SEQUENCE renamed_alter_test RENAME TO renamed_again_alter_test;
DROP SEQUENCE renamed_again_alter_test;

RESET client_min_messages;
