-- PostgreSQL compatible tests from name_escapes
-- 8 tests

-- Test 1: statement (line 3)
CREATE table "woo; DROP USER humpty;" (x INT PRIMARY KEY); CREATE TABLE ";--notbetter" (;
  x INT, y INT,
  "welp INT); -- concerning much
DROP USER dumpty;
CREATE TABLE unused (x " INT,
  INDEX "helpme ON (x)); -- this must stop!
DROP USER alice;
CREATE TABLE unused2(x INT, INDEX woo ON " (x ASC),
  FAMILY "nonotagain (x)); -- welp!
DROP USER queenofhearts;
CREATE TABLE unused3(x INT, y INT, FAMILY woo " (x, y),
  CONSTRAINT "getmeoutofhere PRIMARY KEY (x ASC)); -- saveme!
DROP USER madhatter;
CREATE TABLE unused4(x INT, CONSTRAINT woo " PRIMARY KEY (x);
);

-- onlyif config schema-locked-disabled

-- Test 2: query (line 21)
SHOW CREATE TABLE ";--notbetter";

-- Test 3: query (line 44)
SHOW CREATE TABLE ";--notbetter";

-- Test 4: statement (line 67)
CREATE VIEW ";--alsoconcerning" AS SELECT x AS a, y AS b FROM ";--notbetter";

-- Test 5: query (line 70)
SHOW CREATE VIEW ";--alsoconcerning";

-- Test 6: statement (line 79)
CREATE TABLE ";--dontask" AS SELECT x AS a, y AS b FROM ";--notbetter";

-- onlyif config schema-locked-disabled

-- Test 7: query (line 83)
SHOW CREATE TABLE ";--dontask";

-- Test 8: query (line 94)
SHOW CREATE TABLE ";--dontask";

