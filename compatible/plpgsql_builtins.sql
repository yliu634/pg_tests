-- PostgreSQL compatible tests from plpgsql_builtins
-- 111 tests

-- Test 1: statement (line 3)
CREATE TABLE xy (x INT, y INT);
INSERT INTO xy VALUES (1, 2), (3, 4), (5, 6);

-- Test 2: query (line 8)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 3: query (line 13)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 4: statement (line 18)
BEGIN;
DECLARE "<unnamed portal 3>" CURSOR FOR SELECT 1;

-- Test 5: query (line 22)
SELECT name FROM pg_cursors;

-- Test 6: query (line 28)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 7: query (line 33)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 8: statement (line 38)
CLOSE "<unnamed portal 3>";

-- Test 9: query (line 42)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 10: statement (line 47)
ABORT;

-- Test 11: query (line 51)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 12: query (line 57)
SELECT crdb_internal.plpgsql_gen_cursor_name('foo');

-- Test 13: query (line 62)
SELECT crdb_internal.plpgsql_gen_cursor_name('bar');

-- Test 14: query (line 67)
SELECT crdb_internal.plpgsql_gen_cursor_name('');

-- Test 15: query (line 72)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 16: query (line 80)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 17: query (line 85)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 18: query (line 93)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 19: query (line 98)
SELECT crdb_internal.plpgsql_gen_cursor_name(NULL);

-- Test 20: statement (line 104)
BEGIN;
DECLARE foo CURSOR FOR SELECT generate_series(1, 5);

-- Test 21: query (line 108)
SELECT name FROM pg_cursors;

-- Test 22: statement (line 113)
SELECT crdb_internal.plpgsql_close('foo');

-- Test 23: query (line 116)
SELECT name FROM pg_cursors;

-- Test 24: statement (line 120)
ABORT;

-- Test 25: statement (line 123)
SELECT crdb_internal.plpgsql_close('foo');

-- Test 26: query (line 136)
SELECT crdb_internal.plpgsql_raise('DEBUG1', 'foo', '', '', '');

-- Test 27: query (line 140)
SELECT crdb_internal.plpgsql_raise('LOG', 'foo', '', '', '');

-- Test 28: query (line 144)
SELECT crdb_internal.plpgsql_raise('INFO', 'foo', '', '', '');

-- Test 29: query (line 150)
SELECT crdb_internal.plpgsql_raise('NOTICE', 'foo', '', '', '');

-- Test 30: query (line 156)
SELECT crdb_internal.plpgsql_raise('WARNING', 'foo', '', '', '');

-- Test 31: statement (line 162)
SET client_min_messages = 'debug1';

-- Test 32: query (line 165)
SELECT crdb_internal.plpgsql_raise('DEBUG1', 'foo', '', '', '');

-- Test 33: query (line 171)
SELECT crdb_internal.plpgsql_raise('LOG', 'foo', '', '', '');

-- Test 34: query (line 177)
SELECT crdb_internal.plpgsql_raise('INFO', 'foo', '', '', '');

-- Test 35: query (line 183)
SELECT crdb_internal.plpgsql_raise('NOTICE', 'foo', '', '', '');

-- Test 36: query (line 189)
SELECT crdb_internal.plpgsql_raise('WARNING', 'foo', '', '', '');

-- Test 37: statement (line 195)
SET client_min_messages = 'WARNING';

-- Test 38: query (line 198)
SELECT crdb_internal.plpgsql_raise('DEBUG1', 'foo', '', '', '');

-- Test 39: query (line 202)
SELECT crdb_internal.plpgsql_raise('LOG', 'foo', '', '', '');

-- Test 40: query (line 207)
SELECT crdb_internal.plpgsql_raise('INFO', 'foo', '', '', '');

-- Test 41: query (line 213)
SELECT crdb_internal.plpgsql_raise('NOTICE', 'foo', '', '', '');

-- Test 42: query (line 217)
SELECT crdb_internal.plpgsql_raise('WARNING', 'foo', '', '', '');

-- Test 43: statement (line 223)
RESET client_min_messages;

-- Test 44: query (line 227)
SELECT crdb_internal.plpgsql_raise('NOTICE', 'bar', 'this is a detail', '', '');

-- Test 45: query (line 234)
SELECT crdb_internal.plpgsql_raise('NOTICE', 'baz', '', 'this is a hint', '');

-- Test 46: query (line 241)
SELECT crdb_internal.plpgsql_raise('NOTICE', 'division by zero', '', '', '22012');

-- Test 47: query (line 247)
SELECT crdb_internal.plpgsql_raise('WARNING', 'invalid password', '', '', '28P01');

-- Test 48: query (line 253)
SELECT crdb_internal.plpgsql_raise('NOTICE', 'this is a message', 'this is a detail', 'this is a hint', 'P0001');

-- Test 49: query (line 261)
SELECT crdb_internal.plpgsql_raise('NOTICE', 'division by zero msg', '', '', 'division_by_zero');

-- Test 50: query (line 267)
SELECT crdb_internal.plpgsql_raise('NOTICE', '', 'message is empty', '', 'P0001');

-- Test 51: query (line 274)
SELECT crdb_internal.plpgsql_raise('NOTICE', '', '', '', '');

-- Test 52: query (line 280)
SELECT crdb_internal.plpgsql_raise('NOTICE', '', '', '', 'this_is_not_valid');

query error pgcode 42704 pq: unrecognized exception condition: \"-50\"
SELECT crdb_internal.plpgsql_raise('NOTICE', '', '', '', '-50');

query error pgcode 22023 pq: severity NOTE is invalid
SELECT crdb_internal.plpgsql_raise('NOTE', '', '', '', '-50');

# Test severity ERROR.
query error pgcode XXUUU pq: foo
SELECT crdb_internal.plpgsql_raise('ERROR', 'foo', '', '', '');

query error pgcode 12345 pq: foo
SELECT crdb_internal.plpgsql_raise('ERROR', 'foo', '', '', '12345');

query error pgcode 12345 pq: msg\nHINT: hint\nDETAIL: detail
SELECT crdb_internal.plpgsql_raise('ERROR', 'msg', 'detail', 'hint', '12345');

query error pgcode XXUUU pq:
SELECT crdb_internal.plpgsql_raise('ERROR', '', '', '', '');

# Testing crdb_internal.plpgsql_fetch.
#
# Parameters:
#   Name:         RefCursor
#   Direction:    Int
#   Count:        Int
#   Result Types: Tuple
#
# Codes for FETCH directions:
#   0: FORWARD, BACKWARD, NEXT, PRIOR
#   1: RELATIVE
#   2: ABSOLUTE
#   3: FIRST
#   4: LAST
#   5: ALL
#   6: BACKWARD ALL
#
statement error pgcode 34000 pq: cursor \"foo\" does not exist
SELECT crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::INT, NULL::INT));

# Retrieve rows in descending order.
statement ok
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;

query T
SELECT crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::INT, NULL::INT));

-- Test 53: query (line 332)
SELECT crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::INT, NULL::INT));

-- Test 54: query (line 337)
SELECT crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::INT, NULL::INT));

-- Test 55: query (line 343)
SELECT crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::INT, NULL::INT));

-- Test 56: query (line 354)
SELECT crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::TEXT, NULL::TEXT, NULL::BOOL, NULL::FLOAT, NULL::DECIMAL, NULL::BIT));

-- Test 57: statement (line 360)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM (VALUES ('abc'), ('100'), ('1.01'), ('1.01'), ('t'), ('1'), ('a'));

-- Test 58: query (line 366)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::BYTES,))).*;

-- Test 59: query (line 372)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::INT,))).*;

-- Test 60: query (line 378)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::FLOAT,))).*;

-- Test 61: query (line 384)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::DECIMAL,))).*;

-- Test 62: query (line 390)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::BOOL,))).*;

-- Test 63: query (line 396)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::BIT,))).*;

-- Test 64: query (line 402)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::CHAR,))).*;

-- Test 65: statement (line 407)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT generate_series(0, 10);

-- Test 66: query (line 413)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::BOOL,))).*;

-- Test 67: query (line 419)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::BIT,))).*;

-- Test 68: query (line 431)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::CHAR,))).*;

-- Test 69: query (line 437)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::FLOAT,))).*;

-- Test 70: query (line 443)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::DECIMAL,))).*;

-- Test 71: statement (line 448)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT 5.0101::FLOAT FROM generate_series(1, 5);

-- Test 72: query (line 454)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::DECIMAL,))).*;

-- Test 73: query (line 460)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::INT,))).*;

-- Test 74: statement (line 471)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT 5.0101::DECIMAL FROM generate_series(1, 5);

-- Test 75: query (line 477)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::FLOAT,))).*;

-- Test 76: query (line 483)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::INT,))).*;

-- Test 77: statement (line 495)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT 'abc';

-- Test 78: statement (line 501)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::CHAR,))).*;

-- Test 79: statement (line 504)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT '101';

-- Test 80: statement (line 510)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::BIT,))).*;

-- Test 81: statement (line 513)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT 10000000;

-- Test 82: statement (line 519)
SELECT (crdb_internal.plpgsql_fetch('foo', 0, 1, (NULL::INT2,))).*;

-- Test 83: statement (line 523)
ABORT;
BEGIN;
INSERT INTO xy VALUES (7, 8), (9, 10), (11, 12), (13, 14), (15, 16);
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;

-- Test 84: query (line 530)
SELECT crdb_internal.plpgsql_fetch('foo', 3, 0, (NULL::INT, NULL::INT));

-- Test 85: query (line 536)
SELECT crdb_internal.plpgsql_fetch('foo', 0, 2, (NULL::INT, NULL::INT));

-- Test 86: query (line 542)
SELECT crdb_internal.plpgsql_fetch('foo', 1, 3, (NULL::INT, NULL::INT));

-- Test 87: query (line 548)
SELECT crdb_internal.plpgsql_fetch('foo', 2, 7, (NULL::INT, NULL::INT));

-- Test 88: query (line 554)
SELECT crdb_internal.plpgsql_fetch('foo', 5, 0, (NULL::INT, NULL::INT));

-- Test 89: statement (line 560)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;

-- Test 90: statement (line 566)
SELECT crdb_internal.plpgsql_fetch('foo', 0, -3, (NULL::INT, NULL::INT));

-- Test 91: statement (line 569)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;

-- Test 92: statement (line 575)
SELECT crdb_internal.plpgsql_fetch('foo', 1, -3, (NULL::INT, NULL::INT));

-- Test 93: statement (line 578)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;
MOVE FORWARD 3 foo;

-- Test 94: statement (line 585)
SELECT crdb_internal.plpgsql_fetch('foo', 2, 2, (NULL::INT, NULL::INT));

-- Test 95: statement (line 588)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;
MOVE FORWARD 3 foo;

-- Test 96: statement (line 595)
SELECT crdb_internal.plpgsql_fetch('foo', 3, 0, (NULL::INT, NULL::INT));

-- Test 97: statement (line 598)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;

-- Test 98: statement (line 604)
SELECT crdb_internal.plpgsql_fetch('foo', 4, 0, (NULL::INT, NULL::INT));

-- Test 99: statement (line 607)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;

-- Test 100: statement (line 613)
SELECT crdb_internal.plpgsql_fetch('foo', 6, 0, (NULL::INT, NULL::INT));

-- Test 101: statement (line 616)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;

-- Test 102: statement (line 622)
SELECT crdb_internal.plpgsql_fetch('foo', -1, 0, (NULL::INT, NULL::INT));

-- Test 103: statement (line 625)
ABORT;
BEGIN;
DECLARE foo CURSOR FOR SELECT * FROM xy ORDER BY x DESC;

-- Test 104: statement (line 630)
SELECT crdb_internal.plpgsql_fetch('foo', 10, 0, (NULL::INT, NULL::INT));

-- Test 105: statement (line 633)
ABORT;

-- Test 106: statement (line 640)
SELECT crdb_internal.plpgsql_fetch(NULL, 0, 1, (NULL::INT, NULL::INT));

-- Test 107: statement (line 643)
SELECT crdb_internal.plpgsql_fetch('foo', NULL, 1, (NULL::INT, NULL::INT));

-- Test 108: statement (line 646)
SELECT crdb_internal.plpgsql_fetch('foo', 0, NULL, (NULL::INT, NULL::INT));

-- Test 109: statement (line 649)
SELECT crdb_internal.plpgsql_fetch('foo', 0, 1, NULL);

-- Test 110: statement (line 652)
SELECT crdb_internal.plpgsql_fetch(NULL, NULL, NULL, NULL);

-- Test 111: statement (line 655)
SELECT crdb_internal.plpgsql_close(NULL);

