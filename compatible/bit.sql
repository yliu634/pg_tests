-- PostgreSQL compatible tests from bit
-- 37 tests

-- Test 1: statement (line 8)
CREATE TABLE bits (
  a BIT, b BIT(4), c VARBIT, d VARBIT(4),
  FAMILY "primary" (a, b, c, d, rowid)
)

onlyif config schema-locked-disabled

-- Test 2: query (line 15)
SHOW CREATE TABLE bits

-- Test 3: query (line 29)
SHOW CREATE TABLE bits

-- Test 4: statement (line 44)
INSERT INTO bits(a) VALUES (B'1'), (B'0');

-- Test 5: statement (line 47)
INSERT INTO bits(a) VALUES (B'')

-- Test 6: statement (line 50)
INSERT INTO bits(a) VALUES (B'1110')

-- Test 7: statement (line 55)
INSERT INTO bits(b) VALUES (B'0000'), (B'1001');

-- Test 8: statement (line 58)
INSERT INTO bits(b) VALUES (B'')

-- Test 9: statement (line 61)
INSERT INTO bits(b) VALUES (B'111')

-- Test 10: statement (line 64)
INSERT INTO bits(b) VALUES (B'111000111')

-- Test 11: statement (line 69)
INSERT INTO bits(c) VALUES (B'1'), (B'0'), (B''), (B'1110'),
(B'0101010101010101001101010101010101010101010101010101010101010101010010101') -- more than 64 bits

-- Test 12: statement (line 75)
INSERT INTO bits(d) VALUES (B'1'), (B'0'), (B''), (B'1110')

-- Test 13: statement (line 78)
INSERT INTO bits(d) VALUES
(B'0101010101010101001101010101010101010101010101010101010101010101010010101') -- more than 64 bits

-- Test 14: statement (line 109)
INSERT INTO bits(b) VALUES (B'0110'), (B'0011')

-- Test 15: statement (line 112)
INSERT INTO bits(c) VALUES (B'1010'), (B'11')

-- Test 16: query (line 116)
SELECT x.b,
       x.b << 0 AS l0,
       x.b >> 0 AS r0,
       x.b << -1 AS lm1,
       x.b >> 1 AS r1,
       x.b >> -1 AS rm11,
       x.b << 1 AS l1
  FROM bits x
 WHERE x.b IS NOT NULL
ORDER BY 1,2,3,4,5,6,7

-- Test 17: query (line 163)
SELECT x.b, ~x.b AS comp FROM bits x WHERE b IS NOT NULL

-- Test 18: statement (line 171)
DELETE FROM bits

-- Test 19: statement (line 174)
INSERT INTO bits(c) VALUES (B'0'), (B'1')

-- Test 20: query (line 177)
SELECT x.c, ~x.c AS comp FROM bits x

-- Test 21: query (line 183)
SELECT x.c AS v1, y.c AS v2,
       x.c & y.c AS "and",
       x.c | y.c AS "or",
       x.c # y.c AS "xor"
FROM bits x, bits y

-- Test 22: statement (line 197)
CREATE TABLE obits(x VARBIT);

-- Test 23: statement (line 200)
INSERT INTO obits(x) VALUES
 (B'0'),
 (B'1'),
 (B'0000'),
 (B'0001'),
 (B'010'),
 (B'10'),
 (B'11'),
 (B''),
 (B'00100'),
 (B'00110'),
 (B'00001'),
 (B'1001001010101'),
 (B'01001001010101'),
 (B'11001001010101')

-- Test 24: query (line 218)
SELECT * FROM obits ORDER BY x

-- Test 25: statement (line 237)
CREATE INDEX obits_idx ON obits(x)

-- Test 26: query (line 240)
SELECT * FROM obits@obits_idx ORDER BY x

-- Test 27: query (line 260)
SELECT ARRAY[B'101011'] AS a, '{111001}'::VARBIT[] AS b

-- Test 28: statement (line 266)
CREATE TABLE obitsa(x VARBIT(20)[]);

-- Test 29: statement (line 269)
INSERT INTO obitsa(x) VALUES
 (ARRAY[B'01', B'']),
 (ARRAY[B'01', B'0']),
 (ARRAY[B'01', B'1']),
 (ARRAY[B'01', B'0000']),
 (ARRAY[B'01', B'0001']),
 (ARRAY[B'01', B'010']),
 (ARRAY[B'01', B'10']),
 (ARRAY[B'01', B'11']),
 (ARRAY[B'01', B'']),
 (ARRAY[B'01', B'00100']),
 (ARRAY[B'01', B'00110']),
 (ARRAY[B'01', B'00001']),
 (ARRAY[B'01', B'1001001010101']),
 (ARRAY[B'01', B'01001001010101']),
 (ARRAY[B'01', B'11001001010101'])

onlyif config schema-locked-disabled

-- Test 30: query (line 288)
SELECT create_statement FROM [SHOW CREATE obitsa]

-- Test 31: query (line 298)
SELECT create_statement FROM [SHOW CREATE obitsa]

-- Test 32: query (line 308)
SELECT * FROM obitsa

-- Test 33: statement (line 330)
SELECT B'AB'::BIT(8)

-- Test 34: statement (line 334)
SELECT 'AB'::BIT(8)

-- Test 35: statement (line 344)
SELECT 'xZZ'::BIT(8)

-- Test 36: query (line 353)
SELECT BIT(4) '1101', BIT(1) '1010'

-- Test 37: query (line 358)
SELECT VARBIT(4) '1101', VARBIT(2) '1001'

