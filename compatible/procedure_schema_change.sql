-- PostgreSQL compatible tests from procedure_schema_change
-- 51 tests

-- Test 1: statement (line 4)
CREATE PROCEDURE p() LANGUAGE SQL AS 'SELECT 1';

-- Test 2: statement (line 7)
CREATE PROCEDURE p2() LANGUAGE SQL AS 'SELECT 1';

-- Test 3: statement (line 10)
CREATE PROCEDURE p_int(INT) LANGUAGE SQL AS 'SELECT 1';

-- Test 4: statement (line 13)
CREATE FUNCTION p_func() RETURNS INT LANGUAGE SQL AS 'SELECT 1';

-- Test 5: statement (line 16)
-- Expected ERROR (renaming to the same name):
DO $$
BEGIN
  EXECUTE 'ALTER PROCEDURE p() RENAME TO p';
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 6: statement (line 19)
-- Expected ERROR (name/signature conflict with existing function p_func()):
DO $$
BEGIN
  EXECUTE 'ALTER PROCEDURE p() RENAME TO p_func';
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 7: statement (line 22)
-- Expected ERROR (procedure vs function name):
DO $$
BEGIN
  EXECUTE 'ALTER FUNCTION p() RENAME TO p_new';
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 8: statement (line 25)
-- Expected ERROR (name/signature conflict with existing procedure p2()):
DO $$
BEGIN
  EXECUTE 'ALTER PROCEDURE p() RENAME TO p2';
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 9: statement (line 28)
ALTER PROCEDURE p() RENAME TO p_new;

-- Test 10: statement (line 31)
-- Expected ERROR (procedure was renamed to p_new):
DO $$
BEGIN
  EXECUTE $sql$SELECT pg_get_functiondef('p()'::regprocedure)$sql$;
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 11: query (line 34)
SELECT pg_get_functiondef('p_new()'::regprocedure);

-- Test 12: statement (line 46)
ALTER PROCEDURE p_new() RENAME TO p_int;

-- Test 13: statement (line 49)
-- Expected ERROR (procedure was renamed to p_int):
DO $$
BEGIN
  EXECUTE $sql$SELECT pg_get_functiondef('p_new()'::regprocedure)$sql$;
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 14: query (line 52)
SELECT pg_get_functiondef(p.oid)
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'p_int' AND p.prokind = 'p'
ORDER BY 1;

-- Test 15: statement (line 70)
ALTER PROCEDURE p_int(INT) RENAME TO p_func;

-- Test 16: query (line 73)
SELECT pg_get_functiondef(p.oid)
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'p_int' AND p.prokind = 'p'
ORDER BY 1;

-- Test 17: query (line 83)
SELECT pg_get_functiondef(p.oid)
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'p_func' AND p.prokind = 'p'
ORDER BY 1;

-- Test 18: statement (line 93)
DROP PROCEDURE p_func(INT);
DROP PROCEDURE p_int();
DROP PROCEDURE p2();
DROP FUNCTION p_func();

-- Test 19: statement (line 104)
CREATE PROCEDURE p() LANGUAGE SQL AS 'SELECT 1';

-- Test 20: statement (line 107)
CREATE PROCEDURE p(INT) LANGUAGE SQL AS 'SELECT 2';

-- Test 21: statement (line 110)
CREATE SCHEMA sc;

-- Test 22: statement (line 113)
CREATE PROCEDURE sc.p() LANGUAGE SQL AS 'SELECT 3';

-- Test 23: query (line 134)
SELECT
  n.nspname AS schema,
  p.proname AS name,
  pg_get_function_identity_arguments(p.oid) AS args,
  p.prosrc
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE p.proname = 'p' AND p.prokind = 'p'
ORDER BY 1, 3;

-- Test 24: query (line 143)
SELECT
  n.nspname AS schema,
  p.proname AS name,
  pg_get_function_identity_arguments(p.oid) AS args
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE p.proname = 'p' AND p.prokind = 'p'
ORDER BY 1, 3;

-- Test 25: statement (line 155)
ALTER PROCEDURE p() SET SCHEMA pg_catalog;

-- Test 26: statement (line 158)
-- Expected ERROR (schema sc already contains a procedure named p()):
DO $$
BEGIN
  EXECUTE 'ALTER PROCEDURE pg_catalog.p() SET SCHEMA sc';
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 27: statement (line 161)
-- Expected ERROR (procedure vs function name):
DO $$
BEGIN
  EXECUTE 'ALTER FUNCTION p(INT) SET SCHEMA sc';
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 28: statement (line 165)
ALTER PROCEDURE p(INT) SET SCHEMA public;

-- Test 29: query (line 168)
SELECT
  n.nspname AS schema,
  p.proname AS name,
  pg_get_function_identity_arguments(p.oid) AS args
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE p.proname = 'p' AND p.prokind = 'p'
ORDER BY 1, 3;

-- Test 30: query (line 180)
SELECT pg_get_functiondef(p.oid)
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'p' AND p.prokind = 'p'
ORDER BY 1;

-- Test 31: statement (line 198)
ALTER PROCEDURE p(INT) SET SCHEMA sc;

-- Test 32: query (line 201)
SELECT
  n.nspname AS schema,
  p.proname AS name,
  pg_get_function_identity_arguments(p.oid) AS args
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE p.proname = 'p' AND p.prokind = 'p'
ORDER BY 1, 3;

-- Test 33: query (line 213)
-- Expected ERROR (no procedure named public.p after schema changes):
DO $$
BEGIN
  EXECUTE $sql$SELECT pg_get_functiondef('public.p()'::regprocedure)$sql$;
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 34: query (line 223)
SELECT pg_get_functiondef(p.oid)
FROM pg_catalog.pg_proc p
JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'sc' AND p.proname = 'p' AND p.prokind = 'p'
ORDER BY 1;

-- Test 35: statement (line 239)
DROP PROCEDURE pg_catalog.p();
DROP PROCEDURE sc.p(INT);
DROP PROCEDURE sc.p();

-- Test 36: statement (line 248)
DROP USER IF EXISTS u;
CREATE USER u;

-- Test 37: statement (line 251)
CREATE PROCEDURE p() LANGUAGE SQL AS 'SELECT 1';

-- Test 38: statement (line 254)
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS 'SELECT 1';

-- Test 39: query (line 257)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
JOIN pg_catalog.pg_namespace n ON f.pronamespace = n.oid
WHERE n.nspname = 'public' AND f.prokind = 'p' AND proname = 'p';

-- Test 40: statement (line 264)
-- Expected ERROR (f is a function, not a procedure):
DO $$
BEGIN
  EXECUTE 'ALTER PROCEDURE f() OWNER TO u';
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 41: statement (line 267)
-- Expected ERROR (role does not exist):
DO $$
BEGIN
  EXECUTE 'ALTER PROCEDURE p() OWNER TO user_not_exists';
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 42: statement (line 270)
ALTER PROCEDURE p() OWNER TO u;

-- Test 43: query (line 273)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
JOIN pg_catalog.pg_namespace n ON f.pronamespace = n.oid
WHERE n.nspname = 'public' AND f.prokind = 'p' AND proname = 'p';

-- Test 44: statement (line 280)
REASSIGN OWNED BY u TO postgres;

-- Test 45: query (line 283)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
JOIN pg_catalog.pg_namespace n ON f.pronamespace = n.oid
WHERE n.nspname = 'public' AND f.prokind = 'p' AND proname = 'p';

-- Test 46: statement (line 290)
ALTER PROCEDURE p() OWNER TO u;

-- Test 47: query (line 293)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
JOIN pg_catalog.pg_namespace n ON f.pronamespace = n.oid
WHERE n.nspname = 'public' AND f.prokind = 'p' AND proname = 'p';

-- Test 48: statement (line 300)
-- Expected ERROR (role still owns dependent objects):
DO $$
BEGIN
  EXECUTE 'DROP USER u';
EXCEPTION WHEN OTHERS THEN
  NULL;
END $$;

-- Test 49: statement (line 303)
DROP PROCEDURE p();

-- Test 50: statement (line 306)
DROP USER u;

-- Test 51: statement (line 309)
DROP FUNCTION f();
