-- PostgreSQL compatible tests from rename_sequence
-- 9 tests

-- Test 1: statement (line 3)
SET client_min_messages = warning;

CREATE SEQUENCE alter_test;

-- Test 2: statement (line 6)
ALTER SEQUENCE alter_test RENAME TO renamed_alter_test;

-- Test 3: statement (line 10)
ALTER SEQUENCE IF EXISTS alter_test RENAME TO something;

-- Test 4: statement (line 13)
ALTER SEQUENCE IF EXISTS renamed_alter_test RENAME TO renamed_again_alter_test;

-- Test 5: statement (line 16)
DROP SEQUENCE renamed_again_alter_test;

-- Test 6: statement (line 21)
CREATE SEQUENCE foo;

-- Test 7: statement (line 24)
DO $$
BEGIN
  BEGIN
    EXECUTE 'ALTER VIEW foo RENAME TO bar';
  EXCEPTION WHEN OTHERS THEN
    NULL;
  END;
END $$;

-- Test 8: statement (line 31)
-- onlyif config local-legacy-schema-changer
-- ALTER TABLE foo RENAME TO bar;

-- skipif config local-legacy-schema-changer

-- Test 9: statement (line 35)
ALTER TABLE foo RENAME TO bar;

RESET client_min_messages;
