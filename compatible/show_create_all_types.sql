-- PostgreSQL compatible tests from show_create_all_types
-- 20 tests

-- Test 1: statement (line 3)
CREATE DATABASE d

-- Test 2: statement (line 6)
USE d

-- Test 3: query (line 9)
SHOW CREATE ALL TYPES

-- Test 4: statement (line 14)
CREATE TYPE status AS ENUM ('open', 'closed', 'inactive');

-- Test 5: query (line 17)
SHOW CREATE ALL TYPES

-- Test 6: statement (line 23)
CREATE TYPE tableObj AS ENUM('row', 'col');

-- Test 7: query (line 26)
SHOW CREATE ALL TYPES

-- Test 8: statement (line 33)
DROP TYPE status

-- Test 9: query (line 36)
SHOW CREATE ALL TYPES

-- Test 10: statement (line 43)
CREATE SCHEMA s

-- Test 11: statement (line 46)
CREATE TYPE s.status AS ENUM ('a', 'b', 'c');

-- Test 12: query (line 49)
SHOW CREATE ALL TYPES

-- Test 13: statement (line 57)
CREATE DATABASE "d-d";
USE "d-d";
SHOW CREATE ALL TYPES;

-- Test 14: statement (line 63)
CREATE DATABASE "a""bc";
USE "a""bc";
SHOW CREATE ALL TYPES;

-- Test 15: statement (line 80)
COMMENT ON TYPE address IS 'comment for composite type address';

skipif config local-legacy-schema-changer

-- Test 16: query (line 84)
SHOW CREATE ALL TYPES

-- Test 17: statement (line 92)
DROP TYPE address;

skipif config local-legacy-schema-changer

-- Test 18: statement (line 96)
CREATE TYPE roaches AS ENUM('papa_roach','mama_roach','baby_roach');

skipif config local-legacy-schema-changer

-- Test 19: statement (line 100)
COMMENT ON TYPE roaches IS 'comment for enum type roaches';

skipif config local-legacy-schema-changer

-- Test 20: query (line 104)
SHOW CREATE ALL TYPES

