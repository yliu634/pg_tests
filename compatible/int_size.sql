-- PostgreSQL compatible tests from int_size
-- 41 tests

-- Test 1: query (line 4)
SHOW default_int_size

-- Test 2: statement (line 11)
SET default_int_size=4

-- Test 3: query (line 14)
SHOW default_int_size

-- Test 4: statement (line 21)
CREATE TABLE i4 (i4 INT)

onlyif config schema-locked-disabled

-- Test 5: query (line 25)
SHOW CREATE TABLE i4

-- Test 6: query (line 35)
SHOW CREATE TABLE i4

-- Test 7: statement (line 46)
SET default_int_size=8

-- Test 8: query (line 49)
SHOW default_int_size

-- Test 9: statement (line 54)
CREATE TABLE i8 (i8 INT)

onlyif config schema-locked-disabled

-- Test 10: query (line 58)
SHOW CREATE TABLE i8

-- Test 11: query (line 68)
SHOW CREATE TABLE i8

-- Test 12: statement (line 80)
SET default_int_size=8

-- Test 13: statement (line 85)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET default_int_size=4;
CREATE TABLE late4 (a INT);
COMMIT;

onlyif config schema-locked-disabled

-- Test 14: query (line 92)
SHOW CREATE TABLE late4

-- Test 15: query (line 102)
SHOW CREATE TABLE late4

-- Test 16: query (line 111)
SHOW default_int_size

-- Test 17: statement (line 118)
SET default_int_size=2

-- Test 18: statement (line 128)
SET default_int_size=4; SET serial_normalization='rowid';

-- Test 19: statement (line 131)
CREATE TABLE i4_rowid (a SERIAL)

onlyif config schema-locked-disabled

-- Test 20: query (line 135)
SHOW CREATE TABLE i4_rowid

-- Test 21: query (line 145)
SHOW CREATE TABLE i4_rowid

-- Test 22: statement (line 154)
SET default_int_size=8; SET serial_normalization='rowid';

-- Test 23: statement (line 157)
CREATE TABLE i8_rowid (a SERIAL)

onlyif config schema-locked-disabled

-- Test 24: query (line 161)
SHOW CREATE TABLE i8_rowid

-- Test 25: query (line 171)
SHOW CREATE TABLE i8_rowid

-- Test 26: statement (line 183)
SET default_int_size=4; SET serial_normalization='sql_sequence';

-- Test 27: statement (line 186)
CREATE TABLE i4_sql_sequence (a SERIAL)

onlyif config schema-locked-disabled

-- Test 28: query (line 190)
SHOW CREATE TABLE i4_sql_sequence

-- Test 29: query (line 200)
SHOW CREATE TABLE i4_sql_sequence

-- Test 30: statement (line 209)
SET default_int_size=8; SET serial_normalization='sql_sequence';

-- Test 31: statement (line 212)
CREATE TABLE i8_sql_sequence (a SERIAL)

onlyif config schema-locked-disabled

-- Test 32: query (line 216)
SHOW CREATE TABLE i8_sql_sequence

-- Test 33: query (line 226)
SHOW CREATE TABLE i8_sql_sequence

-- Test 34: statement (line 239)
SET default_int_size=4; SET serial_normalization='virtual_sequence';

-- Test 35: statement (line 242)
CREATE TABLE i4_virtual_sequence (a SERIAL)

onlyif config schema-locked-disabled

-- Test 36: query (line 246)
SHOW CREATE TABLE i4_virtual_sequence

-- Test 37: query (line 256)
SHOW CREATE TABLE i4_virtual_sequence

-- Test 38: statement (line 265)
SET default_int_size=8; SET serial_normalization='virtual_sequence';

-- Test 39: statement (line 268)
CREATE TABLE i8_virtual_sequence (a SERIAL)

onlyif config schema-locked-disabled

-- Test 40: query (line 272)
SHOW CREATE TABLE i8_virtual_sequence

-- Test 41: query (line 282)
SHOW CREATE TABLE i8_virtual_sequence

