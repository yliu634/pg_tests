-- PostgreSQL compatible tests from grant_type
-- 23 tests

-- Test 1: statement (line 3)
CREATE SCHEMA schema_a

-- Test 2: statement (line 6)
CREATE USER user1

-- Test 3: statement (line 9)
CREATE TYPE public.enum_a AS ENUM ('hello', 'goodbye');
GRANT USAGE ON TYPE public.enum_a TO user1

-- Test 4: statement (line 13)
CREATE TYPE public."enum_a+b" AS ENUM ('hello', 'goodbye');
GRANT USAGE ON TYPE public."enum_a+b" TO user1

-- Test 5: statement (line 17)
CREATE TYPE schema_a.enum_b AS ENUM ('hi', 'bye');
GRANT ALL ON TYPE schema_a.enum_b TO user1

-- Test 6: query (line 21)
SHOW GRANTS ON TYPE schema_a.enum_b, "enum_a+b", enum_a, int4

-- Test 7: query (line 41)
SHOW GRANTS ON TYPE schema_a.enum_b, enum_a, int4 FOR user1

-- Test 8: query (line 50)
SHOW GRANTS FOR user1

-- Test 9: statement (line 66)
SHOW GRANTS ON TYPE non_existent

-- Test 10: statement (line 71)
CREATE DATABASE other;
CREATE TYPE other.typ AS ENUM();
GRANT ALL ON TYPE other.typ TO user1

-- Test 11: query (line 76)
SHOW GRANTS ON TYPE other.typ

-- Test 12: query (line 84)
SHOW GRANTS ON TYPE other.typ FOR user1

-- Test 13: statement (line 94)
CREATE USER owner_grant_option_child

-- Test 14: statement (line 97)
GRANT testuser to owner_grant_option_child

-- Test 15: statement (line 100)
GRANT CREATE ON DATABASE test TO testuser

user testuser

-- Test 16: statement (line 105)
CREATE TYPE owner_grant_option AS ENUM('a')

-- Test 17: statement (line 108)
GRANT USAGE ON TYPE owner_grant_option TO owner_grant_option_child

-- Test 18: query (line 111)
SHOW GRANTS ON TYPE owner_grant_option

-- Test 19: statement (line 125)
CREATE ROLE other_owner

-- Test 20: statement (line 128)
ALTER TYPE owner_grant_option OWNER TO other_owner

-- Test 21: query (line 131)
SHOW GRANTS ON TYPE owner_grant_option

-- Test 22: statement (line 141)
CREATE USER roach;
CREATE TYPE custom_type1 AS ENUM ('roach1', 'roach2', 'roach3');
CREATE TYPE custom_type2 AS ENUM ('roachA', 'roachB', 'roachC');
CREATE TYPE custom_type3 AS ENUM ('roachI', 'roachII', 'roachIII');
BEGIN;
GRANT ALL ON TYPE custom_type1 TO roach;
GRANT ALL ON TYPE custom_type2 TO roach;
GRANT ALL ON TYPE custom_type3 TO roach;
COMMIT

-- Test 23: query (line 156)
SHOW GRANTS FOR roach

