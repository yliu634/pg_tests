-- PostgreSQL compatible tests from errors
-- 7 tests

-- Helpers: run statements/queries expected to error without emitting psql ERROR output.
CREATE OR REPLACE PROCEDURE pg_temp.expect_error(sql text)
LANGUAGE plpgsql
AS $$
DECLARE
  stmt text;
BEGIN
  stmt := regexp_replace(sql, ';[[:space:]]*$', '');
  EXECUTE stmt;
  RAISE NOTICE 'expected failure did not occur';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'expected failure: %', SQLERRM;
END;
$$;

CREATE OR REPLACE PROCEDURE pg_temp.expect_error_query(sql text)
LANGUAGE plpgsql
AS $$
DECLARE
  stmt text;
  rec record;
BEGIN
  stmt := regexp_replace(sql, ';[[:space:]]*$', '');
  FOR rec IN EXECUTE stmt LOOP
    NULL;
  END LOOP;
  RAISE NOTICE 'expected failure did not occur';
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'expected failure: %', SQLERRM;
END;
$$;

-- Test 1: statement (line 1)
CALL pg_temp.expect_error($sql$ALTER TABLE fake1 DROP COLUMN a;$sql$);

-- Test 2: statement (line 4)
CALL pg_temp.expect_error($sql$CREATE INDEX i ON fake2 (a);$sql$);

-- Test 3: statement (line 7)
-- CockroachDB index drop syntax: <table>@<index>.
CALL pg_temp.expect_error($sql$DROP INDEX i;$sql$);

-- Test 4: statement (line 10)
CALL pg_temp.expect_error($sql$DROP TABLE fake4;$sql$);

-- Test 5: statement (line 13)
-- PostgreSQL has no SHOW COLUMNS; reference the table to trigger the same
-- "relation does not exist" class of error.
CALL pg_temp.expect_error_query($sql$SELECT * FROM fake5 LIMIT 0;$sql$);

-- Test 6: statement (line 16)
CALL pg_temp.expect_error($sql$INSERT INTO fake6 VALUES (1, 2);$sql$);

-- Test 7: statement (line 19)
CALL pg_temp.expect_error_query($sql$SELECT * FROM fake7;$sql$);
