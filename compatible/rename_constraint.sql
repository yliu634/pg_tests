-- PostgreSQL compatible tests from rename_constraint
-- 22 tests

-- Test 1: statement (line 1)
CREATE TABLE t (
  x INT, y INT,
  CONSTRAINT cu UNIQUE (x),
  CONSTRAINT cc CHECK (x > 10),
  CONSTRAINT cf FOREIGN KEY (x) REFERENCES t(x),
  FAMILY "primary" (x, y, rowid)
  )

onlyif config schema-locked-disabled

-- Test 2: query (line 11)
SELECT create_statement FROM [SHOW CREATE t]

-- Test 3: query (line 25)
SELECT create_statement FROM [SHOW CREATE t]

-- Test 4: query (line 38)
SELECT conname, contype FROM pg_catalog.pg_constraint ORDER BY conname

-- Test 5: statement (line 48)
ALTER TABLE t RENAME CONSTRAINT cu TO cu2,
              RENAME CONSTRAINT cf TO cf2,
			  RENAME CONSTRAINT cc TO cc2

onlyif config schema-locked-disabled

-- Test 6: query (line 54)
SELECT create_statement FROM [SHOW CREATE t]

-- Test 7: query (line 68)
SELECT create_statement FROM [SHOW CREATE t]

-- Test 8: query (line 81)
SELECT conname, contype FROM pg_catalog.pg_constraint ORDER BY conname

-- Test 9: statement (line 92)
ALTER TABLE t RENAME CONSTRAINT cu2 TO cf2

-- Test 10: statement (line 95)
ALTER TABLE t RENAME CONSTRAINT cu2 TO cc2

-- Test 11: statement (line 98)
ALTER TABLE t RENAME CONSTRAINT cf2 TO cu2

-- Test 12: statement (line 101)
ALTER TABLE t RENAME CONSTRAINT cf2 TO cc2

-- Test 13: statement (line 104)
ALTER TABLE t RENAME CONSTRAINT cc2 TO cf2

-- Test 14: statement (line 107)
ALTER TABLE t RENAME CONSTRAINT cc2 TO cu2

-- Test 15: statement (line 112)
ALTER TABLE t RENAME CONSTRAINT cu2 TO cu3,
			  RENAME CONSTRAINT cc2 TO cc3,
			  RENAME CONSTRAINT cf2 TO cf3,
              RENAME CONSTRAINT cu3 TO cu4,
			  RENAME CONSTRAINT cc3 TO cc4,
			  RENAME CONSTRAINT cf3 TO cf4

onlyif config schema-locked-disabled

-- Test 16: query (line 121)
SELECT create_statement FROM [SHOW CREATE t]

-- Test 17: query (line 135)
SELECT create_statement FROM [SHOW CREATE t]

-- Test 18: query (line 148)
SELECT conname, contype FROM pg_catalog.pg_constraint ORDER BY conname

-- Test 19: statement (line 157)
CREATE TABLE implicit (a int, b int)

-- Test 20: statement (line 160)
ALTER TABLE implicit RENAME CONSTRAINT implicit_pkey TO something_else

-- Test 21: query (line 163)
SHOW CONSTRAINTS FROM implicit

-- Test 22: statement (line 169)
ALTER TABLE implicit ADD CONSTRAINT something_else CHECK(b > 0)

