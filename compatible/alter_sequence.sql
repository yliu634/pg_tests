-- PostgreSQL compatible tests from alter_sequence
-- 111 tests

SET client_min_messages = warning;

-- Cockroach's `SHOW CREATE SEQUENCE` isn't supported in PostgreSQL.
-- Use pg_catalog.pg_sequences to inspect the current sequence properties.
CREATE OR REPLACE VIEW seq_props AS
SELECT
  sequencename,
  data_type,
  start_value,
  min_value,
  max_value,
  increment_by,
  cache_size,
  cycle
FROM pg_catalog.pg_sequences
WHERE schemaname = 'public';

-- Test 1: statement (line 3)
-- GRANT admin TO testuser;

-- user testuser

-- Test 2: statement (line 8)
CREATE SEQUENCE foo;

-- Test 3: query (line 11)
SELECT nextval('foo');

-- Test 4: query (line 16)
SELECT nextval('foo');

-- Test 5: statement (line 21)
ALTER SEQUENCE foo INCREMENT BY 5;

-- Test 6: query (line 24)
SELECT nextval('foo');

-- Test 7: statement (line 29)
ALTER SEQUENCE foo CACHE 100;

-- Test 8: query (line 32)
SELECT nextval('foo');

-- Test 9: query (line 39)
SELECT nextval('foo');

-- Test 10: query (line 46)
SELECT nextval('foo');

-- Test 11: query (line 51)
SELECT * FROM seq_props WHERE sequencename = 'foo';

-- Test 12: statement (line 56)
ALTER SEQUENCE foo CACHE 1;

-- Test 13: query (line 59)
SELECT * FROM seq_props WHERE sequencename = 'foo';

-- Test 14: statement (line 67)
CREATE SEQUENCE seq_as AS int2;

-- Test 15: query (line 70)
SELECT * FROM seq_props WHERE sequencename = 'seq_as';

-- Test 16: statement (line 75)
ALTER SEQUENCE seq_as AS int4;

-- Test 17: query (line 78)
SELECT * FROM seq_props WHERE sequencename = 'seq_as';

-- Test 18: statement (line 83)
ALTER SEQUENCE seq_as AS int8;

-- Test 19: query (line 86)
SELECT * FROM seq_props WHERE sequencename = 'seq_as';

-- Test 20: statement (line 91)
ALTER SEQUENCE seq_as AS int4;

-- Test 21: query (line 94)
SELECT * FROM seq_props WHERE sequencename = 'seq_as';

-- Test 22: statement (line 99)
ALTER SEQUENCE seq_as AS int2;

-- Test 23: query (line 102)
SELECT * FROM seq_props WHERE sequencename = 'seq_as';

-- Test 24: statement (line 109)
CREATE SEQUENCE seq_int4_max_high AS int4 MAXVALUE 99999;

-- Test 25: query (line 112)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_max_high';

-- Test 26: statement (line 117)
\set ON_ERROR_STOP 0
ALTER SEQUENCE seq_int4_max_high AS int2;
\set ON_ERROR_STOP 1

-- Test 27: statement (line 120)
ALTER SEQUENCE seq_int4_max_high AS int8;

-- Test 28: query (line 123)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_max_high';

-- Test 29: statement (line 128)
CREATE SEQUENCE seq_int4_min_high AS int4 MINVALUE 99999;

-- Test 30: query (line 131)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_min_high';

-- Test 31: statement (line 136)
\set ON_ERROR_STOP 0
ALTER SEQUENCE seq_int4_min_high AS int2;
\set ON_ERROR_STOP 1

-- Test 32: statement (line 139)
ALTER SEQUENCE seq_int4_min_high AS int8;

-- Test 33: query (line 142)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_min_high';

-- Test 34: statement (line 147)
CREATE SEQUENCE seq_int4_start_high AS int4 START 99999;

-- Test 35: statement (line 150)
\set ON_ERROR_STOP 0
ALTER SEQUENCE seq_int4_start_high AS int2;
\set ON_ERROR_STOP 1

-- Test 36: statement (line 153)
ALTER SEQUENCE seq_int4_start_high AS int8;

-- Test 37: query (line 156)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_start_high';

-- Test 38: statement (line 161)
CREATE SEQUENCE seq_int4_min_low AS int4 MINVALUE -99999;

-- Test 39: query (line 164)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_min_low';

-- Test 40: statement (line 169)
\set ON_ERROR_STOP 0
ALTER SEQUENCE seq_int4_min_low AS int2;
\set ON_ERROR_STOP 1

-- Test 41: statement (line 172)
ALTER SEQUENCE seq_int4_min_low AS int8;

-- Test 42: query (line 175)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_min_low';

-- Test 43: statement (line 180)
CREATE SEQUENCE seq_int4_max_high_desc AS int4 MAXVALUE 99999 INCREMENT -1;

-- Test 44: query (line 183)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_max_high_desc';

-- Test 45: statement (line 188)
\set ON_ERROR_STOP 0
ALTER SEQUENCE seq_int4_max_high_desc AS int2;
\set ON_ERROR_STOP 1

-- Test 46: statement (line 191)
ALTER SEQUENCE seq_int4_max_high_desc AS int8;

-- Test 47: query (line 194)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_max_high_desc';

-- Test 48: statement (line 199)
CREATE SEQUENCE seq_int4_min_high_desc AS int4 MINVALUE -99999 INCREMENT -1;

-- Test 49: query (line 202)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_min_high_desc';

-- Test 50: statement (line 207)
\set ON_ERROR_STOP 0
ALTER SEQUENCE seq_int4_min_high_desc AS int2;
\set ON_ERROR_STOP 1

-- Test 51: statement (line 210)
ALTER SEQUENCE seq_int4_min_high_desc AS int8;

-- Test 52: query (line 213)
SELECT * FROM seq_props WHERE sequencename = 'seq_int4_min_high_desc';

-- Test 53: statement (line 218)
CREATE SEQUENCE reverse_direction_seqas AS integer;
ALTER SEQUENCE reverse_direction_seqas AS smallint INCREMENT -1;

-- Test 54: query (line 222)
SELECT * FROM seq_props WHERE sequencename = 'reverse_direction_seqas';

-- Test 55: statement (line 227)
ALTER SEQUENCE reverse_direction_seqas AS int INCREMENT 1;

-- Test 56: query (line 230)
SELECT * FROM seq_props WHERE sequencename = 'reverse_direction_seqas';

-- Test 57: statement (line 235)
CREATE SEQUENCE restart_seq START WITH 5;

-- Test 58: query (line 238)
select nextval('restart_seq');

-- Test 59: statement (line 243)
ALTER SEQUENCE restart_seq RESTART 1;

-- Test 60: query (line 246)
select nextval('restart_seq');

-- Test 61: statement (line 251)
ALTER SEQUENCE restart_seq RESTART;

-- Test 62: query (line 254)
select nextval('restart_seq');

-- Test 63: statement (line 262)
ALTER SEQUENCE restart_seq START WITH 3 RESTART 11;

-- Test 64: query (line 265)
select nextval('restart_seq');

-- Test 65: statement (line 270)
ALTER SEQUENCE restart_seq RESTART;

-- Test 66: query (line 273)
select nextval('restart_seq');

-- Test 67: statement (line 278)
CREATE SEQUENCE restart_min_err_seqas MINVALUE 1;

-- Test 68: statement (line 281)
\set ON_ERROR_STOP 0
ALTER SEQUENCE restart_min_err_seqas RESTART 0;
\set ON_ERROR_STOP 1

-- Test 69: statement (line 284)
CREATE SEQUENCE restart_max_err_seqas MAXVALUE 100;

-- Test 70: statement (line 287)
\set ON_ERROR_STOP 0
ALTER SEQUENCE restart_max_err_seqas RESTART 1000;
\set ON_ERROR_STOP 1

-- Test 71: statement (line 291)
CREATE SEQUENCE set_no_maxvalue MAXVALUE 3;

-- Test 72: query (line 294)
select nextval('set_no_maxvalue'),nextval('set_no_maxvalue'),nextval('set_no_maxvalue');

-- Test 73: statement (line 299)
\set ON_ERROR_STOP 0
select nextval('set_no_maxvalue');
\set ON_ERROR_STOP 1

-- Test 74: statement (line 302)
ALTER SEQUENCE set_no_maxvalue NO MAXVALUE;

-- Test 75: query (line 305)
select nextval('set_no_maxvalue');

-- Test 76: statement (line 310)
CREATE SEQUENCE set_no_minvalue INCREMENT -1 MINVALUE -3;

-- Test 77: query (line 313)
select nextval('set_no_minvalue'),nextval('set_no_minvalue'),nextval('set_no_minvalue');

-- Test 78: statement (line 318)
\set ON_ERROR_STOP 0
select nextval('set_no_minvalue');
\set ON_ERROR_STOP 1

-- Test 79: statement (line 321)
ALTER SEQUENCE set_no_minvalue NO MINVALUE;

-- Test 80: query (line 324)
select nextval('set_no_minvalue');

-- Test 81: statement (line 330)
CREATE SEQUENCE seq_inverse_no_change;

-- Test 82: statement (line 333)
ALTER SEQUENCE seq_inverse_no_change INCREMENT BY -1;

-- Test 83: query (line 336)
SELECT * FROM seq_props WHERE sequencename = 'seq_inverse_no_change';

-- Test 84: statement (line 342)
ALTER SEQUENCE seq_inverse_no_change INCREMENT BY 1;

-- Test 85: query (line 345)
SELECT * FROM seq_props WHERE sequencename = 'seq_inverse_no_change';

-- Test 86: statement (line 352)
CREATE SEQUENCE seq_change_type_bounds
  MINVALUE -9223372036854775808 MAXVALUE 9223372036854775807 START 0;

-- Test 87: statement (line 355)
ALTER SEQUENCE seq_change_type_bounds AS smallint;

-- Test 88: query (line 358)
SELECT * FROM seq_props WHERE sequencename = 'seq_change_type_bounds';

-- Test 89: statement (line 364)
ALTER SEQUENCE seq_change_type_bounds AS integer;

-- Test 90: query (line 367)
SELECT * FROM seq_props WHERE sequencename = 'seq_change_type_bounds';

-- Test 91: statement (line 374)
CREATE SEQUENCE seq_alter_no_min_max_asc INCREMENT 1 START 5 MINVALUE -10 MAXVALUE 10;

-- Test 92: statement (line 377)
ALTER SEQUENCE seq_alter_no_min_max_asc NO MINVALUE NO MAXVALUE;

-- Test 93: query (line 380)
SELECT * FROM seq_props WHERE sequencename = 'seq_alter_no_min_max_asc';

-- Test 94: statement (line 387)
CREATE SEQUENCE seq_alter_no_min_max_des INCREMENT -1 START -5 MINVALUE -10 MAXVALUE 10 ;

-- Test 95: statement (line 390)
ALTER SEQUENCE seq_alter_no_min_max_des NO MINVALUE NO MAXVALUE ;

-- Test 96: query (line 393)
SELECT * FROM seq_props WHERE sequencename = 'seq_alter_no_min_max_des';

RESET client_min_messages;

-- Test 97: statement (line 401)
CREATE SEQUENCE test_52552_asc INCREMENT BY 3 MINVALUE 1 MAXVALUE 12;
ALTER SEQUENCE test_52552_asc INCREMENT BY 8;

-- Test 98: query (line 405)
SELECT nextval('test_52552_asc'), nextval('test_52552_asc');

-- Test 99: statement (line 410)
\set ON_ERROR_STOP 0
SELECT nextval('test_52552_asc');
\set ON_ERROR_STOP 1

-- Test 100: statement (line 413)
\set ON_ERROR_STOP 0
SELECT nextval('test_52552_asc');
\set ON_ERROR_STOP 1

-- Test 101: statement (line 416)
ALTER SEQUENCE test_52552_asc NO MAXVALUE;

-- Test 102: query (line 419)
SELECT nextval('test_52552_asc');

-- Test 103: statement (line 424)
CREATE SEQUENCE test_52552_desc INCREMENT BY -5 MINVALUE 1 MAXVALUE 12;
ALTER SEQUENCE test_52552_desc INCREMENT BY -8;

-- Test 104: query (line 428)
SELECT nextval('test_52552_desc'), nextval('test_52552_desc');

-- Test 105: statement (line 433)
\set ON_ERROR_STOP 0
SELECT nextval('test_52552_desc');
\set ON_ERROR_STOP 1

-- Test 106: statement (line 436)
\set ON_ERROR_STOP 0
SELECT nextval('test_52552_desc');
\set ON_ERROR_STOP 1

-- Test 107: statement (line 439)
ALTER SEQUENCE test_52552_desc NO MINVALUE;

-- Test 108: query (line 442)
SELECT nextval('test_52552_desc');

-- Test 109: statement (line 447)
CREATE SEQUENCE test_52552_start INCREMENT BY 3 MINVALUE 1 MAXVALUE 100 START 50;

-- Test 110: statement (line 450)
ALTER SEQUENCE test_52552_start INCREMENT BY 8;

-- Test 111: query (line 453)
SELECT nextval('test_52552_start');
