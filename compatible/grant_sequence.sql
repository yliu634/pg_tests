-- PostgreSQL compatible tests from grant_sequence
-- 62 tests

-- Test 1: statement (line 3)
CREATE SEQUENCE a START 1 INCREMENT BY 2

-- Test 2: statement (line 6)
CREATE USER readwrite

-- Test 3: statement (line 9)
SET ROLE readwrite

-- Test 4: statement (line 12)
SELECT * FROM a;

-- Test 5: statement (line 15)
SELECT nextval('a')

-- Test 6: statement (line 18)
SET ROLE root

-- Test 7: statement (line 21)
GRANT USAGE ON SEQUENCE a TO readwrite

-- Test 8: statement (line 24)
SET ROLE readwrite

-- Test 9: query (line 27)
SELECT nextval('a')

-- Test 10: query (line 32)
SELECT currval('a')

-- Test 11: statement (line 37)
SET ROLE root

-- Test 12: statement (line 40)
GRANT ALL ON SEQUENCE a TO readwrite WITH GRANT OPTION

-- Test 13: query (line 43)
SHOW GRANTS ON SEQUENCE a

-- Test 14: statement (line 51)
REVOKE UPDATE ON SEQUENCE a FROM readwrite

-- Test 15: query (line 54)
SHOW GRANTS ON SEQUENCE a

-- Test 16: statement (line 69)
GRANT UPDATE ON SEQUENCE a TO readwrite

-- Test 17: statement (line 72)
SET ROLE readwrite

-- Test 18: query (line 75)
SELECT * FROM a;

-- Test 19: query (line 80)
SELECT nextval('a')

-- Test 20: query (line 85)
SELECT nextval('a')

-- Test 21: statement (line 90)
SET ROLE root

-- Test 22: query (line 93)
GRANT CREATE, DROP, USAGE, UPDATE ON SEQUENCE a TO readwrite WITH GRANT OPTION

-- Test 23: query (line 98)
SELECT * FROM information_schema.table_privileges WHERE grantee = 'readwrite';

-- Test 24: statement (line 111)
REVOKE SELECT,DROP,CREATE ON SEQUENCE a FROM readwrite

-- Test 25: query (line 114)
SELECT * FROM information_schema.table_privileges WHERE grantee = 'readwrite';

-- Test 26: statement (line 124)
CREATE SEQUENCE b START 1 INCREMENT BY 2

-- Test 27: statement (line 127)
GRANT ALL ON ALL SEQUENCES IN SCHEMA test.public TO readwrite WITH GRANT OPTION;

-- Test 28: query (line 130)
SELECT * FROM information_schema.table_privileges WHERE grantee = 'readwrite';

-- Test 29: statement (line 136)
REVOKE SELECT ON ALL SEQUENCES IN SCHEMA test.public FROM readwrite;

-- Test 30: query (line 139)
SELECT * FROM information_schema.table_privileges WHERE grantee = 'readwrite';

-- Test 31: statement (line 161)
SET ROLE root

-- Test 32: statement (line 164)
CREATE SEQUENCE to_drop_seq

-- Test 33: statement (line 167)
CREATE ROLE user1

-- Test 34: statement (line 170)
SET ROLE user1

-- Test 35: statement (line 173)
DROP SEQUENCE to_drop_seq

-- Test 36: statement (line 176)
SET ROLE root

-- Test 37: statement (line 179)
GRANT DROP ON SEQUENCE to_drop_seq TO user1

-- Test 38: statement (line 182)
SET ROLE user1

-- Test 39: statement (line 185)
DROP SEQUENCE to_drop_seq

-- Test 40: statement (line 191)
SET ROLE root

-- Test 41: statement (line 194)
CREATE SEQUENCE to_drop_seq

-- Test 42: statement (line 197)
GRANT DROP ON SEQUENCE to_drop_seq TO user1

-- Test 43: statement (line 200)
CREATE ROLE user2

-- Test 44: statement (line 203)
SET ROLE user1

-- Test 45: statement (line 206)
GRANT DROP ON SEQUENCE to_drop_seq TO user2

-- Test 46: statement (line 209)
SET ROLE root

-- Test 47: statement (line 212)
GRANT DROP ON SEQUENCE to_drop_seq TO user1 WITH GRANT OPTION

-- Test 48: statement (line 215)
SET ROLE user1

-- Test 49: statement (line 218)
GRANT DROP ON SEQUENCE to_drop_seq TO user2

-- Test 50: statement (line 221)
SET ROLE user2

-- Test 51: statement (line 224)
DROP SEQUENCE to_drop_seq

-- Test 52: statement (line 227)
SET ROLE root

-- Test 53: statement (line 232)
CREATE SEQUENCE mix_seq

-- Test 54: statement (line 235)
CREATE TABLE mix_tab (x int)

-- Test 55: statement (line 238)
CREATE ROLE mix_u

-- Test 56: statement (line 241)
GRANT USAGE ON mix_seq TO mix_u WITH GRANT OPTION

-- Test 57: query (line 244)
SELECT * FROM information_schema.table_privileges WHERE grantee = 'mix_u';

-- Test 58: query (line 249)
SELECT has_sequence_privilege('mix_u', 'mix_seq', 'USAGE WITH GRANT OPTION')

-- Test 59: statement (line 254)
GRANT SELECT, UPDATE ON mix_seq, mix_tab TO mix_u WITH GRANT OPTION

-- Test 60: statement (line 257)
GRANT USAGE ON mix_seq, mix_tab TO mix_u WITH GRANT OPTION

-- Test 61: query (line 260)
SELECT * FROM information_schema.table_privileges WHERE grantee = 'mix_u';

-- Test 62: query (line 269)
SELECT has_sequence_privilege('mix_u', 'mix_seq', 'USAGE WITH GRANT OPTION'),
       has_sequence_privilege('mix_u', 'mix_seq', 'SELECT WITH GRANT OPTION'),
       has_sequence_privilege('mix_u', 'mix_seq', 'UPDATE WITH GRANT OPTION')

