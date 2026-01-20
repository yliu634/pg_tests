-- PostgreSQL compatible tests from grant_role
-- 41 tests

-- Test 1: statement (line 4)
CREATE USER developer WITH CREATEDB

-- Test 2: statement (line 7)
CREATE USER roach WITH PASSWORD NULL

-- Test 3: statement (line 10)
GRANT developer TO roach

-- Test 4: statement (line 18)
GRANT developer TO roach

-- Test 5: statement (line 31)
GRANT developer TO roach WITH ADMIN OPTION

-- Test 6: statement (line 40)
GRANT developer TO roach WITH ADMIN OPTION

-- Test 7: statement (line 52)
GRANT testuser TO public

-- Test 8: statement (line 55)
REVOKE testuser FROM public

-- Test 9: statement (line 62)
CREATE USER grantor WITH CREATEROLE;
CREATE ROLE transitiveadmin;
GRANT admin TO transitiveadmin

-- Test 10: statement (line 67)
SET ROLE grantor

-- Test 11: statement (line 70)
CREATE ROLE parent1;
CREATE ROLE child1;
GRANT parent1 TO child1

-- Test 12: statement (line 76)
GRANT admin TO child2

-- Test 13: statement (line 80)
GRANT transitiveadmin TO child2

-- Test 14: statement (line 83)
RESET ROLE

-- Test 15: query (line 86)
SHOW GRANTS ON ROLE parent1

-- Test 16: statement (line 92)
SET ROLE grantor;

-- Test 17: statement (line 95)
REVOKE parent1 FROM child1;
RESET ROLE

-- Test 18: statement (line 102)
CREATE ROLE parent2;
CREATE ROLE child2;
GRANT parent2 TO grantor WITH ADMIN OPTION;
ALTER USER grantor WITH NOCREATEROLE

-- Test 19: statement (line 108)
SET ROLE grantor

-- Test 20: statement (line 111)
GRANT parent2 TO child2

-- Test 21: statement (line 114)
RESET ROLE

-- Test 22: query (line 117)
SHOW GRANTS ON ROLE parent2

-- Test 23: statement (line 124)
SET ROLE grantor;

-- Test 24: statement (line 127)
REVOKE parent2 FROM child2;
RESET ROLE

-- Test 25: statement (line 131)
GRANT admin TO grantor;
SET ROLE grantor

-- Test 26: statement (line 137)
GRANT transitiveadmin TO child2

-- Test 27: statement (line 140)
RESET ROLE;

-- Test 28: statement (line 143)
GRANT transitiveadmin TO grantor;
SET ROLE grantor

-- Test 29: statement (line 147)
GRANT transitiveadmin TO child2

-- Test 30: statement (line 150)
RESET ROLE;

-- Test 31: statement (line 153)
GRANT transitiveadmin TO grantor WITH ADMIN OPTION;
SET ROLE grantor

-- Test 32: statement (line 158)
GRANT transitiveadmin TO child2

-- Test 33: statement (line 161)
RESET ROLE;

-- Test 34: statement (line 164)
REVOKE transitiveadmin FROM grantor;
REVOKE transitiveadmin FROM child2;
GRANT admin TO grantor WITH ADMIN OPTION

-- Test 35: statement (line 170)
GRANT transitiveadmin TO child2

-- Test 36: statement (line 173)
RESET ROLE;

-- Test 37: statement (line 176)
REVOKE admin FROM grantor;
REVOKE transitiveadmin FROM child2

-- Test 38: statement (line 184)
CREATE ROLE parent3;
CREATE ROLE child3

-- Test 39: statement (line 188)
SET ROLE grantor

-- Test 40: statement (line 191)
GRANT parent3 TO child3

-- Test 41: statement (line 194)
RESET ROLE

