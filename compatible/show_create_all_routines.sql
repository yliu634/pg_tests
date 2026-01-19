-- PostgreSQL compatible tests from show_create_all_routines
-- 20 tests

-- Test 1: statement (line 3)
CREATE DATABASE d

-- Test 2: statement (line 6)
USE d

-- Test 3: query (line 9)
SHOW CREATE ALL ROUTINES;

-- Test 4: statement (line 14)
CREATE FUNCTION add_one(x INT) RETURNS INT AS 'SELECT x + 1' LANGUAGE SQL;

-- Test 5: query (line 17)
SHOW CREATE ALL ROUTINES;

-- Test 6: statement (line 32)
CREATE OR REPLACE PROCEDURE double_triple(INOUT double INT, OUT triple INT)
AS $$
BEGIN
  double := double * 2;
  triple := double * 3;
END;
$$ LANGUAGE PLpgSQL;

-- Test 7: query (line 42)
SHOW CREATE ALL ROUTINES;

-- Test 8: statement (line 66)
CREATE FUNCTION add_one(x FLOAT) RETURNS FLOAT AS 'SELECT x + 1' LANGUAGE SQL;

-- Test 9: query (line 69)
SHOW CREATE ALL ROUTINES;

-- Test 10: statement (line 105)
DROP FUNCTION add_one(x INT8);

-- Test 11: statement (line 108)
DROP FUNCTION add_one(x FLOAT8);

-- Test 12: query (line 111)
SHOW CREATE ALL ROUTINES;

-- Test 13: statement (line 125)
DROP PROCEDURE double_triple;

-- Test 14: query (line 128)
SHOW CREATE ALL ROUTINES;

-- Test 15: statement (line 134)
CREATE SCHEMA s;

-- Test 16: statement (line 137)
CREATE FUNCTION add_one(x INT) RETURNS INT AS 'SELECT x + 1' LANGUAGE SQL;

-- Test 17: statement (line 140)
CREATE FUNCTION s.add_one(x INT) RETURNS INT AS 'SELECT x + 1' LANGUAGE SQL;

-- Test 18: query (line 143)
SHOW CREATE ALL ROUTINES;

-- Test 19: statement (line 171)
CREATE FUNCTION select_invalid() RETURNS TRIGGER AS $$
BEGIN
  SELECT 1 FROM a.b.c;
END;
$$ LANGUAGE PLpgSQL;

-- Test 20: query (line 178)
SELECT * FROM [SHOW CREATE ALL ROUTINES] ORDER BY 1;

