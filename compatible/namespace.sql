SET client_min_messages = warning;

-- PostgreSQL compatible tests from namespace
-- 25 tests

-- Test 1: statement (line 2)
DROP TABLE IF EXISTS a CASCADE;
DROP TABLE IF EXISTS a CASCADE;
CREATE TABLE a(a INT);

-- Test 2: statement (line 5)
CREATE DATABASE public; DROP TABLE IF EXISTS public CASCADE;
CREATE TABLE public.public.t(a INT);

-- Test 3: query (line 9)
SHOW TABLES FROM public;

-- Test 4: query (line 16)
SHOW TABLES FROM public.public;

-- Test 5: statement (line 23)
SET database = public;

-- Test 6: query (line 26)
SHOW TABLES;

-- Test 7: statement (line 31)
SET database = test;

-- Test 8: statement (line 34)
DROP DATABASE public;

-- Test 9: query (line 38)
SELECT typname FROM pg_type WHERE typname = 'date';

-- Test 10: statement (line 44)
SET search_path=public,pg_catalog;

-- Test 11: statement (line 47)
DROP TABLE IF EXISTS pg_type CASCADE;
DROP TABLE IF EXISTS pg_type CASCADE;
CREATE TABLE pg_type(x INT); INSERT INTO pg_type VALUES(42);

-- Test 12: query (line 50)
SELECT x FROM pg_type;

-- Test 13: query (line 57)
SET database = ''; SELECT * FROM pg_type;

# Go to different database, check name still resolves to default.
-- query T
CREATE DATABASE foo; SET database = foo; SELECT typname FROM pg_type WHERE typname = 'date';

-- Test 14: query (line 67)
SET database = test; SET search_path = pg_catalog,public; SELECT typname FROM pg_type WHERE typname = 'date';

-- Test 15: query (line 74)
SET search_path = public,pg_catalog; SELECT x FROM pg_type;

-- Test 16: statement (line 79)
DROP TABLE pg_type; RESET search_path; SET database = test;

-- Test 17: statement (line 83)
ALTER INDEX a_pkey RENAME TO a_pk;

-- Test 18: statement (line 87)
ALTER INDEX public.a_pk RENAME TO a_pk2;

-- Test 19: statement (line 91)
ALTER INDEX test.a_pk2 RENAME TO a_pk3;

-- Test 20: statement (line 94)
CREATE DATABASE public; DROP TABLE IF EXISTS public CASCADE;
CREATE TABLE public.public.t(a INT);

-- Test 21: statement (line 98)
ALTER INDEX public.t_pkey RENAME TO t_pk;

-- Test 22: statement (line 102)
ALTER INDEX public.public.t_pkey RENAME TO t_pk;

-- Test 23: statement (line 106)
SET search_path = invalid;

-- Test 24: statement (line 109)
ALTER INDEX a_pk3 RENAME TO a_pk4;

-- Test 25: statement (line 113)
ALTER INDEX public.a_pk3 RENAME TO a_pk4;



RESET client_min_messages;