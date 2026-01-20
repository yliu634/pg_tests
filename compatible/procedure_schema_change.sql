-- PostgreSQL compatible tests from procedure_schema_change
-- 51 tests

-- Test 1: statement (line 4)
CREATE PROCEDURE p() LANGUAGE SQL AS 'SELECT 1'

-- Test 2: statement (line 7)
CREATE PROCEDURE p2() LANGUAGE SQL AS 'SELECT 1'

-- Test 3: statement (line 10)
CREATE PROCEDURE p_int(INT) LANGUAGE SQL AS 'SELECT 1'

-- Test 4: statement (line 13)
CREATE FUNCTION p_func() RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 5: statement (line 16)
ALTER PROCEDURE p RENAME TO p

-- Test 6: statement (line 19)
ALTER PROCEDURE p RENAME TO p_func

-- Test 7: statement (line 22)
ALTER FUNCTION p RENAME TO p_new

-- Test 8: statement (line 25)
ALTER PROCEDURE p RENAME TO p2

-- Test 9: statement (line 28)
ALTER PROCEDURE p RENAME TO p_new

-- Test 10: statement (line 31)
SELECT create_statement FROM [SHOW CREATE PROCEDURE p];

-- Test 11: query (line 34)
SELECT create_statement FROM [SHOW CREATE PROCEDURE p_new];

-- Test 12: statement (line 46)
ALTER PROCEDURE p_new RENAME to p_int

-- Test 13: statement (line 49)
SELECT create_statement FROM [SHOW CREATE PROCEDURE p_new];

-- Test 14: query (line 52)
SELECT create_statement FROM [SHOW CREATE PROCEDURE p_int] ORDER BY 1

-- Test 15: statement (line 70)
ALTER PROCEDURE p_int(INT) RENAME to p_func

-- Test 16: query (line 73)
SELECT create_statement FROM [SHOW CREATE PROCEDURE p_int] ORDER BY 1

-- Test 17: query (line 83)
SELECT create_statement FROM [SHOW CREATE PROCEDURE p_func]

-- Test 18: statement (line 93)
DROP PROCEDURE p_func(INT);
DROP PROCEDURE p_int();
DROP PROCEDURE p2();
DROP FUNCTION p_func();

-- Test 19: statement (line 104)
CREATE PROCEDURE p() LANGUAGE SQL AS 'SELECT 1'

-- Test 20: statement (line 107)
CREATE PROCEDURE p(INT) LANGUAGE SQL AS 'SELECT 2'

-- Test 21: statement (line 110)
CREATE SCHEMA sc

-- Test 22: statement (line 113)
CREATE PROCEDURE sc.p() LANGUAGE SQL AS 'SELECT 3'

-- Test 23: query (line 134)
SELECT oid, proname, prosrc
FROM pg_catalog.pg_proc WHERE proname IN ('p')
ORDER BY oid

-- Test 24: query (line 143)
WITH procs AS (
  SELECT crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'function' AS proc
  FROM system.descriptor
  WHERE id IN ($public_p, $public_p_int, $sc_p)
)
SELECT proc->>'id' AS id, proc->'parentSchemaId' FROM procs ORDER BY id

-- Test 25: statement (line 155)
ALTER PROCEDURE p() SET SCHEMA pg_catalog

-- Test 26: statement (line 158)
ALTER PROCEDURE p() SET SCHEMA sc

-- Test 27: statement (line 161)
ALTER FUNCTION p(INT) SET SCHEMA sc;

-- Test 28: statement (line 165)
ALTER PROCEDURE p(INT) SET SCHEMA public

-- Test 29: query (line 168)
WITH procs AS (
  SELECT crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'function' AS proc
  FROM system.descriptor
  WHERE id IN ($public_p, $public_p_int, $sc_p)
)
SELECT proc->>'id' AS id, proc->'parentSchemaId' FROM procs ORDER BY id

-- Test 30: query (line 180)
SELECT create_statement FROM [SHOW CREATE PROCEDURE public.p] ORDER BY 1

-- Test 31: statement (line 198)
ALTER PROCEDURE p(INT) SET SCHEMA sc;

-- Test 32: query (line 201)
WITH procs AS (
  SELECT crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor, false)->'function' AS proc
  FROM system.descriptor
  WHERE id IN ($public_p, $public_p_int, $sc_p)
)
SELECT proc->>'id' AS id, proc->'parentSchemaId' FROM procs ORDER BY id

-- Test 33: query (line 213)
SELECT create_statement FROM [SHOW CREATE PROCEDURE public.p];

-- Test 34: query (line 223)
SELECT create_statement FROM [SHOW CREATE PROCEDURE sc.p] ORDER BY 1

-- Test 35: statement (line 239)
DROP PROCEDURE p;
DROP PROCEDURE sc.p(INT);
DROP PROCEDURE sc.p;

-- Test 36: statement (line 248)
CREATE USER u

-- Test 37: statement (line 251)
CREATE PROCEDURE p() LANGUAGE SQL AS 'SELECT 1'

-- Test 38: statement (line 254)
CREATE FUNCTION f() RETURNS INT LANGUAGE SQL AS 'SELECT 1'

-- Test 39: query (line 257)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
WHERE proname = 'p'

-- Test 40: statement (line 264)
ALTER PROCEDURE f OWNER TO u

-- Test 41: statement (line 267)
ALTER PROCEDURE p OWNER TO user_not_exists

-- Test 42: statement (line 270)
ALTER PROCEDURE p OWNER TO u

-- Test 43: query (line 273)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
WHERE proname = 'p'

-- Test 44: statement (line 280)
REASSIGN OWNED BY u TO root

-- Test 45: query (line 283)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
WHERE proname = 'p'

-- Test 46: statement (line 290)
ALTER PROCEDURE p OWNER TO u

-- Test 47: query (line 293)
SELECT rolname FROM pg_catalog.pg_proc f
JOIN pg_catalog.pg_roles r ON f.proowner = r.oid
WHERE proname = 'p'

-- Test 48: statement (line 300)
DROP USER u

-- Test 49: statement (line 303)
DROP PROCEDURE p

-- Test 50: statement (line 306)
DROP USER u

-- Test 51: statement (line 309)
DROP FUNCTION f

