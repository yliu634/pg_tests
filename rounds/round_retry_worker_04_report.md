RETRY: pg_tests/compatible/udf_record.sql
File size: 503 lines
Password for user pan: 
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: fe_sendauth: no password supplied
NEEDS_AGGRESSIVE_ADAPTATION: pg_tests/compatible/udf_record.sql
Retry config: PG_SUDO_USER=postgres PG_USER=postgres
Password for user postgres: 
psql: error: connection to server at "localhost" (127.0.0.1), port 5432 failed: fe_sendauth: no password supplied
RETRY_FAILED: pg_tests/compatible/udf_record.sql
Retry config: PG_SUDO_USER=postgres PG_USER=postgres PG_HOST=/var/run/postgresql
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
CREATE TABLE
INSERT 0 3
CREATE FUNCTION
 f_one 
-------
 (1)
(1 row)

psql:pg_tests/compatible/udf_record.sql:18: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f_one();
                      ^
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Added ON_ERROR_STOP scoping + PG equivalents (SHOW CREATE FUNCTION, USE)
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
CREATE FUNCTION
     f_tuple     
-----------------
 (4,5,"(6,7,8)")
(1 row)

CREATE FUNCTION
   f_multituple    
-------------------
 ("(1,2)","(3,4)")
(1 row)

CREATE FUNCTION
             pg_get_functiondef              
---------------------------------------------
 CREATE OR REPLACE FUNCTION public.f_table()+
  RETURNS record                            +
  LANGUAGE sql                              +
 AS $function$                              +
   SELECT * FROM t ORDER BY a LIMIT 1;      +
 $function$                                 +
 
(1 row)

 f_table 
---------
 (1,5)
(1 row)

CREATE FUNCTION
 f_multitable 
--------------
 (1,5,1,5)
(1 row)

CREATE FUNCTION
 f_setof 
---------
 (1,5)
 (2,6)
 (3,7)
(3 rows)

CREATE FUNCTION
 f_row 
-------
 (1.1)
(1 row)

ALTER TABLE
 f_table 
---------
 (1,5,0)
(1 row)

DROP DATABASE
CREATE DATABASE
CREATE TABLE
CREATE FUNCTION
          pg_get_functiondef           
---------------------------------------
 CREATE OR REPLACE FUNCTION public.f()+
  RETURNS integer                     +
  LANGUAGE sql                        +
 AS $function$                        +
   SELECT * FROM t1;                  +
 $function$                           +
 
(1 row)

DROP DATABASE
CREATE FUNCTION
  f_tup  
---------
 (1,2,3)
(1 row)

psql:pg_tests/compatible/udf_record.sql:141: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f_tup();
                      ^
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Scoped expected error for SELECT * FROM f_tup()
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
-------
 (1.1)
(1 row)

ALTER TABLE
 f_table 
---------
 (1,5,0)
(1 row)

DROP DATABASE
CREATE DATABASE
CREATE TABLE
CREATE FUNCTION
          pg_get_functiondef           
---------------------------------------
 CREATE OR REPLACE FUNCTION public.f()+
  RETURNS integer                     +
  LANGUAGE sql                        +
 AS $function$                        +
   SELECT * FROM t1;                  +
 $function$                           +
 
(1 row)

DROP DATABASE
CREATE FUNCTION
  f_tup  
---------
 (1,2,3)
(1 row)

psql:pg_tests/compatible/udf_record.sql:142: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f_tup();
                      ^
 a | b | c 
---+---+---
 1 | 2 | 3
(1 row)

CREATE FUNCTION
  f_col  
---------
 (1,2,3)
(1 row)

 a | b | c 
---+---+---
 1 | 2 | 3
(1 row)

 column1 
---------
 (1,2,3)
(1 row)

CREATE TABLE
INSERT 0 3
CREATE FUNCTION
 a | b  
---+----
 1 | 10
(1 row)

CREATE TYPE
CREATE FUNCTION
 f_udt 
-------
 a
(1 row)

CREATE FUNCTION
 f_udt 
-------
 a
(1 row)

psql:pg_tests/compatible/udf_record.sql:198: ERROR:  return type mismatch in function declared to return record
DETAIL:  Final statement returns too many columns.
CONTEXT:  SQL function "f_setof" during startup
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: f_setof() now selects explicit columns (a,b) to avoid schema-change '*' expansion
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
(1 row)

DROP DATABASE
CREATE DATABASE
CREATE TABLE
CREATE FUNCTION
          pg_get_functiondef           
---------------------------------------
 CREATE OR REPLACE FUNCTION public.f()+
  RETURNS integer                     +
  LANGUAGE sql                        +
 AS $function$                        +
   SELECT * FROM t1;                  +
 $function$                           +
 
(1 row)

DROP DATABASE
CREATE FUNCTION
  f_tup  
---------
 (1,2,3)
(1 row)

psql:pg_tests/compatible/udf_record.sql:142: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f_tup();
                      ^
 a | b | c 
---+---+---
 1 | 2 | 3
(1 row)

CREATE FUNCTION
  f_col  
---------
 (1,2,3)
(1 row)

 a | b | c 
---+---+---
 1 | 2 | 3
(1 row)

 column1 
---------
 (1,2,3)
(1 row)

CREATE TABLE
INSERT 0 3
CREATE FUNCTION
 a | b  
---+----
 1 | 10
(1 row)

CREATE TYPE
CREATE FUNCTION
 f_udt 
-------
 a
(1 row)

CREATE FUNCTION
 f_udt 
-------
 a
(1 row)

 a | b 
---+---
 1 | 5
 2 | 6
 3 | 7
(3 rows)

CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:213: ERROR:  syntax error at or near "CREATE"
LINE 3: CREATE FUNCTION f_strict() RETURNS RECORD STRICT AS
        ^
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Fixed missing semicolon after f_setof_imp() call
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
---+---+---
 1 | 2 | 3
(1 row)

CREATE FUNCTION
 a | b  
---+----
 1 | 10
 2 |  4
 3 | 32
(3 rows)

CREATE FUNCTION
 a | b 
---+---
 1 | 2
(1 row)

 a | b 
---+---
   |  
(1 row)

 f_strict_arg 
--------------
 (1,2)
(1 row)

CREATE FUNCTION
 a | b 
---+---
 1 | 2
 1 | 2
 1 | 2
(3 rows)

 a | b 
---+---
(0 rows)

CREATE TABLE
INSERT 0 2
 input | a | b 
-------+---+---
       |   |  
(1 row)

 input | a | b 
-------+---+---
(0 rows)

CREATE FUNCTION
 a | b 
---+---
 1 | 2
(1 row)

CREATE FUNCTION
 f_amb_setof 
-------------
(0 rows)

 a | b 
---+---
(0 rows)

CREATE FUNCTION
 f_amb 
-------
 
(1 row)

 a | b 
---+---
   |  
(1 row)

psql:pg_tests/compatible/udf_record.sql:304: ERROR:  syntax error at or near ")"
LINE 6: SELECT ('a',)
                    ^
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Replaced invalid single-element tuple ('a',) with ROW('a')
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
 3 | 32
(3 rows)

CREATE FUNCTION
 a | b 
---+---
 1 | 2
(1 row)

 a | b 
---+---
   |  
(1 row)

 f_strict_arg 
--------------
 (1,2)
(1 row)

CREATE FUNCTION
 a | b 
---+---
 1 | 2
 1 | 2
 1 | 2
(3 rows)

 a | b 
---+---
(0 rows)

CREATE TABLE
INSERT 0 2
 input | a | b 
-------+---+---
       |   |  
(1 row)

 input | a | b 
-------+---+---
(0 rows)

CREATE FUNCTION
 a | b 
---+---
 1 | 2
(1 row)

CREATE FUNCTION
 f_amb_setof 
-------------
(0 rows)

 a | b 
---+---
(0 rows)

CREATE FUNCTION
 f_amb 
-------
 
(1 row)

 a | b 
---+---
   |  
(1 row)

CREATE FUNCTION
  a  |  b  
-----+-----
 (a) | foo
 (a) | bar
(2 rows)

CREATE TABLE
INSERT 0 1
psql:pg_tests/compatible/udf_record.sql:439: ERROR:  syntax error at or near "SELECT"
LINE 5: SELECT imp_const_tup(), (11,22,'b')::imp = imp_const_tup(), ...
        ^
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Fixed Postgres terminators (added missing semicolons / 1215; for imp_* and err() functions)
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
(1 row)

CREATE FUNCTION
  a  |  b  
-----+-----
 (a) | foo
 (a) | bar
(2 rows)

CREATE TABLE
INSERT 0 1
CREATE FUNCTION
 imp_const_tup | ?column? | pg_typeof 
---------------+----------+-----------
 (11,22,b)     | t        | imp
(1 row)

CREATE FUNCTION
 imp_const_cast | ?column? | pg_typeof 
----------------+----------+-----------
 (11,22,b)      | t        | imp
(1 row)

CREATE FUNCTION
 imp_const | ?column? | pg_typeof 
-----------+----------+-----------
 (11,22,b) | t        | imp
(1 row)

CREATE FUNCTION
 imp_const_unnamed | ?column? | pg_typeof 
-------------------+----------+-----------
 (11,22,b)         | t        | imp
(1 row)

CREATE FUNCTION
 imp_tup | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
   imp   | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
 imp_star | ?column? 
----------+----------
 (1,2,a)  | t
(1 row)

INSERT 0 1
CREATE FUNCTION
 imp_tup_ordered | ?column? 
-----------------+----------
 (100,200,z)     | t
(1 row)

CREATE FUNCTION
 imp_ordered | ?column? 
-------------+----------
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:416: ERROR:  cannot compare dissimilar column types unknown and text at record column 3
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Cast composite literal to imp for equality comparison
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
(2 rows)

CREATE TABLE
INSERT 0 1
CREATE FUNCTION
 imp_const_tup | ?column? | pg_typeof 
---------------+----------+-----------
 (11,22,b)     | t        | imp
(1 row)

CREATE FUNCTION
 imp_const_cast | ?column? | pg_typeof 
----------------+----------+-----------
 (11,22,b)      | t        | imp
(1 row)

CREATE FUNCTION
 imp_const | ?column? | pg_typeof 
-----------+----------+-----------
 (11,22,b) | t        | imp
(1 row)

CREATE FUNCTION
 imp_const_unnamed | ?column? | pg_typeof 
-------------------+----------+-----------
 (11,22,b)         | t        | imp
(1 row)

CREATE FUNCTION
 imp_tup | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
   imp   | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
 imp_star | ?column? 
----------+----------
 (1,2,a)  | t
(1 row)

INSERT 0 1
CREATE FUNCTION
 imp_tup_ordered | ?column? 
-----------------+----------
 (100,200,z)     | t
(1 row)

CREATE FUNCTION
 imp_ordered | ?column? 
-------------+----------
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
 imp_cast | ?column? | pg_typeof 
----------+----------+-----------
 (1,2,3)  | t        | imp
(1 row)

psql:pg_tests/compatible/udf_record.sql:421: ERROR:  cannot cast type record to imp
DETAIL:  Input has too few columns.
CONTEXT:  SQL function "err"
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Allowed expected err() CREATE FUNCTION failures via scoped ON_ERROR_STOP 0
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
 (11,22,b)      | t        | imp
(1 row)

CREATE FUNCTION
 imp_const | ?column? | pg_typeof 
-----------+----------+-----------
 (11,22,b) | t        | imp
(1 row)

CREATE FUNCTION
 imp_const_unnamed | ?column? | pg_typeof 
-------------------+----------+-----------
 (11,22,b)         | t        | imp
(1 row)

CREATE FUNCTION
 imp_tup | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
   imp   | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
 imp_star | ?column? 
----------+----------
 (1,2,a)  | t
(1 row)

INSERT 0 1
CREATE FUNCTION
 imp_tup_ordered | ?column? 
-----------------+----------
 (100,200,z)     | t
(1 row)

CREATE FUNCTION
 imp_ordered | ?column? 
-------------+----------
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
 imp_cast | ?column? | pg_typeof 
----------+----------+-----------
 (1,2,3)  | t        | imp
(1 row)

psql:pg_tests/compatible/udf_record.sql:422: ERROR:  cannot cast type record to imp
DETAIL:  Input has too few columns.
CONTEXT:  SQL function "err"
psql:pg_tests/compatible/udf_record.sql:427: ERROR:  return type mismatch in function declared to return imp
DETAIL:  Final statement returns too few columns.
CONTEXT:  SQL function "err"
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:437: ERROR:  return type mismatch in function declared to return integer
DETAIL:  Actual return type is imp.
CONTEXT:  SQL function "err"
CREATE TYPE
CREATE TYPE
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:448: ERROR:  a column definition list is redundant for a function returning a named composite type
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Scoped expected column-def-list error for f() returning composite
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
-----------+----------+-----------
 (11,22,b) | t        | imp
(1 row)

CREATE FUNCTION
 imp_const_unnamed | ?column? | pg_typeof 
-------------------+----------+-----------
 (11,22,b)         | t        | imp
(1 row)

CREATE FUNCTION
 imp_tup | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
   imp   | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
 imp_star | ?column? 
----------+----------
 (1,2,a)  | t
(1 row)

INSERT 0 1
CREATE FUNCTION
 imp_tup_ordered | ?column? 
-----------------+----------
 (100,200,z)     | t
(1 row)

CREATE FUNCTION
 imp_ordered | ?column? 
-------------+----------
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
 imp_cast | ?column? | pg_typeof 
----------+----------+-----------
 (1,2,3)  | t        | imp
(1 row)

psql:pg_tests/compatible/udf_record.sql:422: ERROR:  cannot cast type record to imp
DETAIL:  Input has too few columns.
CONTEXT:  SQL function "err"
psql:pg_tests/compatible/udf_record.sql:427: ERROR:  return type mismatch in function declared to return imp
DETAIL:  Final statement returns too few columns.
CONTEXT:  SQL function "err"
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:437: ERROR:  return type mismatch in function declared to return integer
DETAIL:  Actual return type is imp.
CONTEXT:  SQL function "err"
CREATE TYPE
CREATE TYPE
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:449: ERROR:  a column definition list is redundant for a function returning a named composite type
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:459: ERROR:  a column definition list is only allowed for functions returning "record"
LINE 1: SELECT * FROM f() AS g(bar FLOAT);
                               ^
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Scoped expected column-def-list error for scalar-returning f()
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
 imp_const_unnamed | ?column? | pg_typeof 
-------------------+----------+-----------
 (11,22,b)         | t        | imp
(1 row)

CREATE FUNCTION
 imp_tup | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
   imp   | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
 imp_star | ?column? 
----------+----------
 (1,2,a)  | t
(1 row)

INSERT 0 1
CREATE FUNCTION
 imp_tup_ordered | ?column? 
-----------------+----------
 (100,200,z)     | t
(1 row)

CREATE FUNCTION
 imp_ordered | ?column? 
-------------+----------
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
 imp_cast | ?column? | pg_typeof 
----------+----------+-----------
 (1,2,3)  | t        | imp
(1 row)

psql:pg_tests/compatible/udf_record.sql:422: ERROR:  cannot cast type record to imp
DETAIL:  Input has too few columns.
CONTEXT:  SQL function "err"
psql:pg_tests/compatible/udf_record.sql:427: ERROR:  return type mismatch in function declared to return imp
DETAIL:  Final statement returns too few columns.
CONTEXT:  SQL function "err"
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:437: ERROR:  return type mismatch in function declared to return integer
DETAIL:  Actual return type is imp.
CONTEXT:  SQL function "err"
CREATE TYPE
CREATE TYPE
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:449: ERROR:  a column definition list is redundant for a function returning a named composite type
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:460: ERROR:  a column definition list is only allowed for functions returning "record"
LINE 1: SELECT * FROM f() AS g(bar FLOAT);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:470: ERROR:  a column definition list is redundant for a function with OUT parameters
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Scoped expected column-def-list error for OUT-parameter f()
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
CREATE FUNCTION
 imp_tup | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
   imp   | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
 imp_star | ?column? 
----------+----------
 (1,2,a)  | t
(1 row)

INSERT 0 1
CREATE FUNCTION
 imp_tup_ordered | ?column? 
-----------------+----------
 (100,200,z)     | t
(1 row)

CREATE FUNCTION
 imp_ordered | ?column? 
-------------+----------
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
 imp_cast | ?column? | pg_typeof 
----------+----------+-----------
 (1,2,3)  | t        | imp
(1 row)

psql:pg_tests/compatible/udf_record.sql:422: ERROR:  cannot cast type record to imp
DETAIL:  Input has too few columns.
CONTEXT:  SQL function "err"
psql:pg_tests/compatible/udf_record.sql:427: ERROR:  return type mismatch in function declared to return imp
DETAIL:  Final statement returns too few columns.
CONTEXT:  SQL function "err"
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:437: ERROR:  return type mismatch in function declared to return integer
DETAIL:  Actual return type is imp.
CONTEXT:  SQL function "err"
CREATE TYPE
CREATE TYPE
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:449: ERROR:  a column definition list is redundant for a function returning a named composite type
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:460: ERROR:  a column definition list is only allowed for functions returning "record"
LINE 1: SELECT * FROM f() AS g(bar FLOAT);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:471: ERROR:  a column definition list is redundant for a function with OUT parameters
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:481: ERROR:  return type mismatch in function declared to return record
DETAIL:  Final statement returns too many columns.
CONTEXT:  SQL function "f" during startup
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Record-returning f() uses ROW(...) to return a single record column
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)

CREATE FUNCTION
 imp_tup | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
   imp   | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
 imp_star | ?column? 
----------+----------
 (1,2,a)  | t
(1 row)

INSERT 0 1
CREATE FUNCTION
 imp_tup_ordered | ?column? 
-----------------+----------
 (100,200,z)     | t
(1 row)

CREATE FUNCTION
 imp_ordered | ?column? 
-------------+----------
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
 imp_cast | ?column? | pg_typeof 
----------+----------+-----------
 (1,2,3)  | t        | imp
(1 row)

psql:pg_tests/compatible/udf_record.sql:422: ERROR:  cannot cast type record to imp
DETAIL:  Input has too few columns.
CONTEXT:  SQL function "err"
psql:pg_tests/compatible/udf_record.sql:427: ERROR:  return type mismatch in function declared to return imp
DETAIL:  Final statement returns too few columns.
CONTEXT:  SQL function "err"
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:437: ERROR:  return type mismatch in function declared to return integer
DETAIL:  Actual return type is imp.
CONTEXT:  SQL function "err"
CREATE TYPE
CREATE TYPE
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:449: ERROR:  a column definition list is redundant for a function returning a named composite type
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:460: ERROR:  a column definition list is only allowed for functions returning "record"
LINE 1: SELECT * FROM f() AS g(bar FLOAT);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:471: ERROR:  a column definition list is redundant for a function with OUT parameters
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:481: ERROR:  function return row and query-specified return row do not match
DETAIL:  Returned row contains 2 attributes, but query expects 1.
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Scoped expected coldeflist mismatch errors for f() returning 2-field record
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
CREATE FUNCTION
   imp   | ?column? 
---------+----------
 (1,2,a) | t
(1 row)

CREATE FUNCTION
 imp_star | ?column? 
----------+----------
 (1,2,a)  | t
(1 row)

INSERT 0 1
CREATE FUNCTION
 imp_tup_ordered | ?column? 
-----------------+----------
 (100,200,z)     | t
(1 row)

CREATE FUNCTION
 imp_ordered | ?column? 
-------------+----------
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
 imp_cast | ?column? | pg_typeof 
----------+----------+-----------
 (1,2,3)  | t        | imp
(1 row)

psql:pg_tests/compatible/udf_record.sql:422: ERROR:  cannot cast type record to imp
DETAIL:  Input has too few columns.
CONTEXT:  SQL function "err"
psql:pg_tests/compatible/udf_record.sql:427: ERROR:  return type mismatch in function declared to return imp
DETAIL:  Final statement returns too few columns.
CONTEXT:  SQL function "err"
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:437: ERROR:  return type mismatch in function declared to return integer
DETAIL:  Actual return type is imp.
CONTEXT:  SQL function "err"
CREATE TYPE
CREATE TYPE
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:449: ERROR:  a column definition list is redundant for a function returning a named composite type
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:460: ERROR:  a column definition list is only allowed for functions returning "record"
LINE 1: SELECT * FROM f() AS g(bar FLOAT);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:471: ERROR:  a column definition list is redundant for a function with OUT parameters
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:482: ERROR:  function return row and query-specified return row do not match
DETAIL:  Returned row contains 2 attributes, but query expects 1.
psql:pg_tests/compatible/udf_record.sql:485: ERROR:  function return row and query-specified return row do not match
DETAIL:  Returned row contains 2 attributes, but query expects 3.
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:495: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f();
                      ^
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Scoped expected missing/invalid coldeflist errors for SELECT * FROM record-returning f()
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
----------+----------
 (1,2,a)  | t
(1 row)

INSERT 0 1
CREATE FUNCTION
 imp_tup_ordered | ?column? 
-----------------+----------
 (100,200,z)     | t
(1 row)

CREATE FUNCTION
 imp_ordered | ?column? 
-------------+----------
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
 imp_cast | ?column? | pg_typeof 
----------+----------+-----------
 (1,2,3)  | t        | imp
(1 row)

psql:pg_tests/compatible/udf_record.sql:422: ERROR:  cannot cast type record to imp
DETAIL:  Input has too few columns.
CONTEXT:  SQL function "err"
psql:pg_tests/compatible/udf_record.sql:427: ERROR:  return type mismatch in function declared to return imp
DETAIL:  Final statement returns too few columns.
CONTEXT:  SQL function "err"
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:437: ERROR:  return type mismatch in function declared to return integer
DETAIL:  Actual return type is imp.
CONTEXT:  SQL function "err"
CREATE TYPE
CREATE TYPE
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:449: ERROR:  a column definition list is redundant for a function returning a named composite type
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:460: ERROR:  a column definition list is only allowed for functions returning "record"
LINE 1: SELECT * FROM f() AS g(bar FLOAT);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:471: ERROR:  a column definition list is redundant for a function with OUT parameters
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:482: ERROR:  function return row and query-specified return row do not match
DETAIL:  Returned row contains 2 attributes, but query expects 1.
psql:pg_tests/compatible/udf_record.sql:485: ERROR:  function return row and query-specified return row do not match
DETAIL:  Returned row contains 2 attributes, but query expects 3.
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:496: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f();
                      ^
psql:pg_tests/compatible/udf_record.sql:499: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f() AS g(bar, baz);
                      ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:509: ERROR:  return type mismatch in function declared to return record
DETAIL:  Final statement returns boolean instead of integer at column 1.
CONTEXT:  SQL function "f" during startup
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Scoped expected type-mismatch error for record-returning f() call
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)

psql:pg_tests/compatible/udf_record.sql:24: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f_one();
                      ^
 a 
---
 1
(1 row)

CREATE FUNCTION
                      f_const                       
----------------------------------------------------
 (1,2.0,"welcome roacher","2021-07-12 17:02:10+00")
(1 row)

CREATE FUNCTION
    f_arr    
-------------
 ("{1,2,3}")
(1 row)

CREATE FUNCTION
     f_tuple     
-----------------
 (4,5,"(6,7,8)")
(1 row)

CREATE FUNCTION
   f_multituple    
-------------------
 ("(1,2)","(3,4)")
(1 row)

CREATE FUNCTION
             pg_get_functiondef              
---------------------------------------------
 CREATE OR REPLACE FUNCTION public.f_table()+
  RETURNS record                            +
  LANGUAGE sql                              +
 AS $function$                              +
   SELECT * FROM t ORDER BY a LIMIT 1;      +
 $function$                                 +
 
(1 row)

 f_table 
---------
 (1,5)
(1 row)

CREATE FUNCTION
 f_multitable 
--------------
 (1,5,1,5)
(1 row)

CREATE FUNCTION
 f_setof 
---------
 (1,5)
 (2,6)
 (3,7)
(3 rows)

CREATE FUNCTION
 f_row 
-------
 (1.1)
(1 row)

ALTER TABLE
 f_table 
---------
 (1,5,0)
(1 row)

DROP DATABASE
CREATE DATABASE
CREATE TABLE
psql:pg_tests/compatible/udf_record.sql:120: ERROR:  function "f" already exists with same argument types
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ENV_CLEANUP: Dropped stray template1.f() and leftover "interesting⨄DbName" DB
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/udf_record.sql
error: (leaving pg_tests/compatible/udf_record.expected unchanged)
 (100,200,z) | t
(1 row)

CREATE FUNCTION
 imp_identity | imp_identity 
--------------+--------------
 (1,2,a)      | (1,2,a)
(1 row)

CREATE FUNCTION
 imp_a | imp_a 
-------+-------
     2 |     2
(1 row)

CREATE FUNCTION
 imp_cast | ?column? | pg_typeof 
----------+----------+-----------
 (1,2,3)  | t        | imp
(1 row)

psql:pg_tests/compatible/udf_record.sql:422: ERROR:  cannot cast type record to imp
DETAIL:  Input has too few columns.
CONTEXT:  SQL function "err"
psql:pg_tests/compatible/udf_record.sql:427: ERROR:  return type mismatch in function declared to return imp
DETAIL:  Final statement returns too few columns.
CONTEXT:  SQL function "err"
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:437: ERROR:  return type mismatch in function declared to return integer
DETAIL:  Actual return type is imp.
CONTEXT:  SQL function "err"
CREATE TYPE
CREATE TYPE
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:449: ERROR:  a column definition list is redundant for a function returning a named composite type
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:460: ERROR:  a column definition list is only allowed for functions returning "record"
LINE 1: SELECT * FROM f() AS g(bar FLOAT);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:471: ERROR:  a column definition list is redundant for a function with OUT parameters
LINE 1: SELECT * FROM f() AS g(bar bar_typ);
                               ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:482: ERROR:  function return row and query-specified return row do not match
DETAIL:  Returned row contains 2 attributes, but query expects 1.
psql:pg_tests/compatible/udf_record.sql:485: ERROR:  function return row and query-specified return row do not match
DETAIL:  Returned row contains 2 attributes, but query expects 3.
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:496: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f();
                      ^
psql:pg_tests/compatible/udf_record.sql:499: ERROR:  a column definition list is required for functions returning "record"
LINE 1: SELECT * FROM f() AS g(bar, baz);
                      ^
DROP FUNCTION
CREATE FUNCTION
psql:pg_tests/compatible/udf_record.sql:510: ERROR:  return type mismatch in function declared to return record
DETAIL:  Final statement returns boolean instead of integer at column 1.
CONTEXT:  SQL function "f" during startup
CREATE FUNCTION
  x   
------
 1.99
(1 row)

 x 
---
 2
(1 row)

psql:pg_tests/compatible/udf_record.sql:523: ERROR:  return type mismatch in function declared to return record
DETAIL:  Final statement returns numeric instead of timestamp without time zone at column 1.
CONTEXT:  SQL function "f113186" during startup
RETRY_FAILED: pg_tests/compatible/udf_record.sql
ADAPTATION: Scoped expected timestamp cast failure for f113186()
NOTICE:  database "crdb_tests_udf_record" does not exist, skipping
wrote pg_tests/compatible/udf_record.expected
RETRY_SUCCESS: pg_tests/compatible/udf_record.sql
RETRY: pg_tests/compatible/update.sql
File size: 510 lines
NOTICE:  database "crdb_tests_update" does not exist, skipping
error: PostgreSQL ERROR while running pg_tests/compatible/update.sql
error: (leaving pg_tests/compatible/update.expected unchanged)
psql:pg_tests/compatible/update.sql:289: ERROR:  syntax error at or near "UPDATE"
LINE 6: UPDATE kv SET v = (SELECT (10, 11))
        ^
NEEDS_AGGRESSIVE_ADAPTATION: pg_tests/compatible/update.sql
ADAPTATION: Added PG statement terminators; removed/rewrote CRDB-only syntax (FAMILY, UNIQUE INDEX, schema_locked, SHOW CREATE, ORDER BY/LIMIT on UPDATE)
NOTICE:  database "crdb_tests_update" does not exist, skipping
wrote pg_tests/compatible/update.expected
RETRY_ADAPTED_SUCCESS: pg_tests/compatible/update.sql

Worker ID: 04
Status: COMPLETE (RETRY ROUND)
