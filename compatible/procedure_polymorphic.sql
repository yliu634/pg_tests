-- PostgreSQL compatible tests from procedure_polymorphic
-- 113 tests

-- Test 1: statement (line 2)
CREATE TYPE greetings AS ENUM('hi', 'hello', 'yo');
CREATE TYPE foo AS ENUM('bar', 'baz');
CREATE TYPE typ AS (x INT, y INT);

-- Test 2: statement (line 10)
CREATE PROCEDURE p(x ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 3: statement (line 13)
CALL p(1);
CALL p('foo'::TEXT);
CALL p(False);
CALL p(NULL::INT);
CALL p('hi'::greetings);
CALL p(ARRAY[1, 2, 3]);

-- Test 4: statement (line 22)
CALL p('foo');

-- Test 5: statement (line 25)
CALL p(NULL);

-- Test 6: statement (line 29)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYARRAY) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 7: statement (line 33)
CALL p(ARRAY[1, 2, 3]);
CALL p(ARRAY['one', 'two', 'three']);
CALL p(NULL::INT[]);
CALL p('{1, 2, 3}'::INT[]);

-- Test 8: statement (line 40)
CALL p('{1, 2, 3}');

-- Test 9: statement (line 43)
CALL p(NULL);

-- Test 10: statement (line 46)
CALL p(1);

-- Test 11: statement (line 49)
CALL p('hi'::greetings);

-- Test 12: statement (line 77)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYELEMENT, y ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 13: statement (line 81)
CALL p(1, 2);
CALL p(NULL, 1);
CALL p(ARRAY[1, 2], ARRAY[3, 4]);
CALL p('hi'::greetings, 'hello'::greetings);

-- Test 14: statement (line 88)
CALL p(1, '2');

-- Test 15: statement (line 92)
CALL p('hi'::greetings, 'hello');

-- Test 16: statement (line 97)
CALL p('1', '2');

-- Test 17: statement (line 100)
CALL p(NULL, NULL);

-- Test 18: statement (line 103)
CALL p(1, False);

-- Test 19: statement (line 106)
CALL p(ARRAY[1, 2], ARRAY[False, True]);

-- Test 20: statement (line 111)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYARRAY, y ANYARRAY) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 21: statement (line 115)
CALL p(ARRAY[1, 2, 3], ARRAY[4, 5, 6]);
CALL p(ARRAY[True, False], ARRAY[False, NULL]);
CALL p(NULL, ARRAY[1, 2]);
CALL p(ARRAY['hi'::greetings, 'hello'::greetings], ARRAY['yo'::greetings, NULL]);
CALL p(ARRAY[ROW(1, 2)::typ, NULL], ARRAY[ROW(3, 4)::typ]);

-- Test 22: statement (line 122)
CALL p(NULL, NULL);

-- Test 23: statement (line 126)
CALL p('{1, 2}', '{3, 4}');

-- Test 24: statement (line 129)
CALL p(1, 2);

-- Test 25: statement (line 132)
CALL p(ARRAY[1, 2], 3);

-- Test 26: statement (line 135)
CALL p('hi'::greetings, 'hello'::greetings);

-- Test 27: statement (line 170)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYARRAY, y ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 28: statement (line 174)
CALL p(ARRAY[1, 2], 1);
CALL p(ARRAY[1, 2], NULL);
CALL p(NULL, 1);
CALL p(ARRAY[True], False);
CALL p(ARRAY['hi'], 'hello');
CALL p(ARRAY['hi'::greetings], 'hello'::greetings);
CALL p(ARRAY['hi']::greetings[], 'hello'::greetings);

-- Test 29: statement (line 184)
CALL p(ARRAY[1, 2], '1');

-- Test 30: statement (line 187)
CALL p(NULL, NULL);

-- Test 31: statement (line 190)
CALL p(ARRAY['hi'], 'hello'::greetings);

-- Test 32: statement (line 193)
CALL p('hello'::greetings, ARRAY['hi']);

-- Test 33: statement (line 196)
CALL p(1, 2);

-- Test 34: statement (line 199)
CALL p(ARRAY[1, 2], ARRAY[3, 4]);

-- Test 35: statement (line 202)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYELEMENT, y ANYARRAY) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 36: statement (line 206)
CALL p(1, ARRAY[1, 2]);
CALL p(NULL, ARRAY[1, 2]);
CALL p(1, NULL);
CALL p(False, ARRAY[True]);
CALL p('hello', ARRAY['hi']);
CALL p('hello'::greetings, ARRAY['hi'::greetings]);
CALL p('hello'::greetings, ARRAY['hi']::greetings[]);

-- Test 37: statement (line 216)
CALL p('1', ARRAY[1, 2]);

-- Test 38: statement (line 219)
CALL p(NULL, NULL);

-- Test 39: statement (line 222)
CALL p(ARRAY['hi'], 'hello'::greetings);

-- Test 40: statement (line 225)
CALL p('hello'::greetings, ARRAY['hi']);

-- Test 41: statement (line 228)
CALL p(1, 2);

-- Test 42: statement (line 231)
CALL p(ARRAY[1, 2], ARRAY[3, 4]);

-- Test 43: statement (line 353)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYELEMENT, OUT y INT) LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 44: query (line 357)
CALL p(1, NULL);

-- Test 45: query (line 362)
CALL p(2, NULL);

-- Test 46: query (line 367)
CALL p(NULL::INT, NULL);

-- Test 47: statement (line 372)
CALL p('foo'::TEXT, NULL);

-- Test 48: statement (line 375)
CALL p(True, NULL);

-- Test 49: statement (line 378)
DROP PROCEDURE p;

-- Test 50: statement (line 384)
CREATE PROCEDURE p(OUT x ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 51: statement (line 388)
CREATE PROCEDURE p(OUT x ANYARRAY) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 52: statement (line 392)
CREATE PROCEDURE p(x INT, OUT y ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 53: statement (line 396)
CREATE PROCEDURE p(x INT, OUT y ANYARRAY, z OUT ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1, 2; $$;

-- Test 54: statement (line 406)
CREATE PROCEDURE p(INOUT x ANYELEMENT) LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 55: query (line 409)
CALL p(1);

-- Test 56: query (line 414)
CALL p(True);

-- Test 57: query (line 419)
CALL p(ARRAY[1, 2]);

-- Test 58: statement (line 429)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYELEMENT, OUT y ANYELEMENT) LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 59: query (line 433)
CALL p(1, NULL);

-- Test 60: query (line 438)
CALL p(True, NULL);

-- Test 61: query (line 443)
CALL p(ARRAY[1, 2], NULL);

-- Test 62: statement (line 449)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYELEMENT, OUT y ANYARRAY) LANGUAGE SQL AS $$ SELECT ARRAY[x]; $$;

-- Test 63: query (line 453)
CALL p(1, NULL);

-- Test 64: query (line 458)
CALL p(True, NULL);

-- Test 65: statement (line 463)
CALL p(ARRAY[1, 2], NULL);

-- Test 66: statement (line 471)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYARRAY, OUT y ANYELEMENT) LANGUAGE SQL AS $$ SELECT x[1]; $$;

-- Test 67: query (line 475)
CALL p(ARRAY[1, 2], NULL);

-- Test 68: query (line 480)
CALL p(ARRAY[True, False], NULL);

-- Test 69: statement (line 487)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYELEMENT, OUT y ANYELEMENT) LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 70: statement (line 491)
CALL p(true, ARRAY[True]);

-- Test 71: statement (line 494)
CALL p(1, ARRAY[2]);

-- Test 72: statement (line 497)
CALL p(1, True);

-- Test 73: statement (line 500)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYELEMENT, OUT y ANYARRAY) LANGUAGE SQL AS $$ SELECT ARRAY[x]; $$;

-- Test 74: statement (line 504)
CALL p(true, false);

-- Test 75: statement (line 507)
CALL p(1, 2);

-- Test 76: statement (line 517)
DROP PROCEDURE p;
CREATE PROCEDURE p(OUT ret ANYELEMENT, x ANYELEMENT DEFAULT 1) LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 77: query (line 521)
CALL p(NULL);

-- Test 78: query (line 526)
CALL p(NULL, True);

-- Test 79: query (line 531)
CALL p(NULL, 'foo'::TEXT);

-- Test 80: statement (line 541)
DROP PROCEDURE p;
CREATE PROCEDURE p(OUT ret ANYELEMENT, x ANYELEMENT, y ANYELEMENT DEFAULT 1) LANGUAGE SQL AS $$ SELECT y; $$;

-- Test 81: query (line 545)
CALL p(NULL, 1);

-- Test 82: query (line 550)
CALL p(NULL, 1, 2);

-- Test 83: query (line 555)
CALL p(NULL, 'foo'::TEXT, 'bar'::TEXT);

-- Test 84: query (line 560)
CALL p(NULL, True, False);

-- Test 85: statement (line 565)
CALL p(NULL, True);

-- Test 86: statement (line 568)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYARRAY, OUT ret ANYARRAY, y ANYARRAY DEFAULT ARRAY[1, 2]) LANGUAGE SQL AS $$ SELECT y; $$;

-- Test 87: query (line 572)
CALL p(ARRAY[4, 5], NULL);

-- Test 88: statement (line 577)
CALL p(ARRAY[True], NULL);

-- Test 89: statement (line 591)
DROP PROCEDURE p;
CREATE PROCEDURE p(OUT ret ANYELEMENT, x ANYELEMENT DEFAULT True, y ANYELEMENT DEFAULT 1) LANGUAGE SQL AS $$ SELECT x; $$;

-- Test 90: query (line 595)
CALL p(NULL, 10);

-- Test 91: query (line 600)
CALL p(NULL, 10, 100);

-- Test 92: statement (line 605)
CALL p(NULL);

-- Test 93: statement (line 608)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYELEMENT DEFAULT 10, y ANYARRAY DEFAULT ARRAY[1, 2]) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 94: statement (line 612)
CALL p();
CALL p(1);
CALL p(1, ARRAY[100]);
CALL p(True, ARRAY[False]);

-- Test 95: statement (line 618)
CALL p(True);

-- Test 96: statement (line 621)
DROP PROCEDURE p;
CREATE PROCEDURE p(x ANYELEMENT DEFAULT True, y ANYARRAY DEFAULT ARRAY[1, 2]) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 97: statement (line 625)
CALL p(1);
CALL p(1, ARRAY[100]);
CALL p(True, ARRAY[False]);

-- Test 98: statement (line 630)
CALL p();

-- Test 99: statement (line 633)
DROP PROCEDURE p;

-- Test 100: statement (line 636)
CREATE PROCEDURE p(x ANYARRAY DEFAULT 1) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 101: statement (line 641)
CREATE PROCEDURE p(OUT y INT, x ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 102: statement (line 644)
DROP PROCEDURE p(OUT INT, INT);

-- Test 103: statement (line 647)
DROP PROCEDURE p(OUT INT, TEXT);

-- Test 104: statement (line 650)
DROP PROCEDURE p(OUT INT);

-- Test 105: statement (line 653)
DROP PROCEDURE p();

-- Test 106: statement (line 656)
DROP PROCEDURE p(OUT INT, ANYARRAY);

-- Test 107: statement (line 659)
DROP PROCEDURE p(OUT INT, ANYELEMENT);

-- Test 108: statement (line 662)
CREATE PROCEDURE p(x INT, OUT ret INT) LANGUAGE SQL AS $$ SELECT 1; $$;

-- Test 109: statement (line 665)
DROP PROCEDURE p(ANYARRAY, OUT INT);

-- Test 110: statement (line 668)
DROP PROCEDURE p(ANYELEMENT, OUT INT);

-- Test 111: statement (line 671)
DROP PROCEDURE p(INT, OUT INT);

-- Test 112: statement (line 679)
CREATE OR REPLACE PROCEDURE dup (INOUT f2 ANYELEMENT, OUT f3 ANYARRAY) AS 'SELECT $1, ARRAY[$1,$1]' LANGUAGE SQL;

-- Test 113: query (line 682)
CALL dup(22, NULL);

