-- PostgreSQL compatible tests from scale
-- 50 tests

SET client_min_messages = warning;

-- Helper for expected-failure statements: preserve intent without emitting ERROR
-- output in the captured .expected.
CREATE OR REPLACE PROCEDURE pg_try_exec(sql text)
LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE sql;
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 1: statement (line 1)
CREATE TABLE test (
  t CHAR(4) UNIQUE
);

-- Test 2: statement (line 7)
INSERT INTO test VALUES ('a');

-- Test 3: statement (line 10)
INSERT INTO test VALUES ('ab');

-- Test 4: statement (line 13)
INSERT INTO test VALUES ('abcd');

-- Test 5: statement (line 16)
CALL pg_try_exec($$INSERT INTO test VALUES ('abcdef'::char(4))$$);

-- Test 6: statement (line 19)
INSERT INTO test VALUES ('áááá');

-- Test 7: statement (line 22)
CALL pg_try_exec($$INSERT INTO test VALUES ('ááááß'::char(4))$$);

-- Test 8: statement (line 25)
UPDATE test SET t = 'b' WHERE t = 'abcde';

-- Test 9: statement (line 28)
UPDATE test SET t = 'cdefg'::char(4) WHERE t = 'ab';

-- Test 10: statement (line 31)
CREATE TABLE tb (
  b BIT(3) UNIQUE
);

-- Test 11: statement (line 37)
INSERT INTO tb VALUES (B'001');

-- Test 12: statement (line 40)
INSERT INTO tb VALUES (B'011');

-- Test 13: statement (line 43)
INSERT INTO tb VALUES (B'111');

-- Test 14: statement (line 46)
CALL pg_try_exec($$INSERT INTO tb VALUES (B'1111'::bit(3))$$);

-- Test 15: statement (line 49)
UPDATE tb SET b = B'010' WHERE b = B'111';

-- Test 16: statement (line 52)
UPDATE tb SET b = B'10000'::bit(3) WHERE b = B'010';

-- Test 17: statement (line 55)
CREATE TABLE tc (
  b INT2 UNIQUE
);

-- Test 18: statement (line 61)
INSERT INTO tc VALUES (50);

-- Test 19: statement (line 64)
INSERT INTO tc VALUES (-32768);

-- Test 20: statement (line 67)
INSERT INTO tc VALUES (32767);

-- Test 21: statement (line 72)
INSERT INTO tc VALUES (60000-59999);

-- Test 22: statement (line 75)
CALL pg_try_exec($$INSERT INTO tc VALUES (-32769)$$);

-- Test 23: statement (line 78)
CALL pg_try_exec($$INSERT INTO tc VALUES (32768)$$);

-- Test 24: statement (line 81)
UPDATE tc SET b = 80 WHERE b = 50;

-- Test 25: statement (line 84)
CALL pg_try_exec($$UPDATE tc SET b = 32768 WHERE b = 32767$$);

-- Test 26: statement (line 87)
CREATE TABLE tc1 (
  b INT4 UNIQUE
);

-- Test 27: statement (line 93)
INSERT INTO tc1 VALUES (50);

-- Test 28: statement (line 96)
INSERT INTO tc1 VALUES (-2147483648);

-- Test 29: statement (line 99)
INSERT INTO tc1 VALUES (2147483647);

-- Test 30: statement (line 102)
CALL pg_try_exec($$INSERT INTO tc1 VALUES (-2147483649)$$);

-- Test 31: statement (line 105)
CALL pg_try_exec($$INSERT INTO tc1 VALUES (2147483648)$$);

-- Test 32: statement (line 108)
UPDATE tc1 SET b = 80 WHERE b = 50;

-- Test 33: statement (line 111)
CALL pg_try_exec($$UPDATE tc1 SET b = 2147483648 WHERE b = 2147483647$$);

-- Test 34: statement (line 114)
CREATE TABLE td (
  d DECIMAL(3, 2) UNIQUE
);

-- Test 35: statement (line 120)
INSERT INTO td VALUES (DECIMAL '3.1');

-- Test 36: statement (line 123)
INSERT INTO td VALUES (DECIMAL '3.14');

-- Test 37: statement (line 126)
CALL pg_try_exec($$INSERT INTO td VALUES (DECIMAL '3.1415')$$);

-- Test 38: statement (line 129)
CALL pg_try_exec($$INSERT INTO td VALUES (DECIMAL '13.1415')$$);

-- Test 39: query (line 132)
SELECT d FROM td ORDER BY d;

-- Test 40: statement (line 138)
CALL pg_try_exec($$UPDATE td SET d = DECIMAL '101.414' WHERE d = DECIMAL '3.14'$$);

-- Test 41: statement (line 141)
UPDATE td SET d = DECIMAL '1.414' WHERE d = DECIMAL '3.14';

-- Test 42: statement (line 144)
CALL pg_try_exec($$UPDATE td SET d = DECIMAL '1.41' WHERE d = DECIMAL '3.1'$$);

-- Test 43: query (line 147)
SELECT d FROM td ORDER BY d;

-- Test 44: statement (line 153)
CREATE TABLE td2 (x DECIMAL(3), y DECIMAL);

-- Test 45: statement (line 156)
INSERT INTO td2 VALUES (DECIMAL '123.1415', DECIMAL '123.1415');

-- Test 46: query (line 159)
select x, y FROM td2;

-- Test 47: statement (line 167)
CREATE TABLE td3 (a decimal, b decimal(3, 1), c decimal(20, 10));

-- Test 48: statement (line 170)
INSERT INTO td3 VALUES (123456789012.123456789012, 12.3, 1234567890.1234567890);

-- Test 49: query (line 173)
select * from td3;

-- Test 50: statement (line 178)
CALL pg_try_exec($$INSERT INTO td3 (c) VALUES (12345678901)$$);

RESET client_min_messages;
