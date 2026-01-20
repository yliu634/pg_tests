-- PostgreSQL compatible tests from drop_procedure
--
-- CockroachDB has SHOW CREATE PROCEDURE and other directives that do not run
-- under plain psql. This file focuses on creating, introspecting, and dropping
-- procedures using PostgreSQL-native catalogs.

SET client_min_messages = warning;
DROP SCHEMA IF EXISTS sc1 CASCADE;
DROP TYPE IF EXISTS t114677 CASCADE;
DROP PROCEDURE IF EXISTS p_test_drop();
DROP PROCEDURE IF EXISTS p_test_drop(int);
DROP PROCEDURE IF EXISTS p142886(varchar);
RESET client_min_messages;

CREATE PROCEDURE p_test_drop() LANGUAGE plpgsql AS $$
BEGIN
  RAISE NOTICE 'p_test_drop()';
END
$$;

CREATE PROCEDURE p_test_drop(int) LANGUAGE plpgsql AS $$
BEGIN
  RAISE NOTICE 'p_test_drop(int)';
END
$$;

CREATE SCHEMA sc1;
CREATE PROCEDURE sc1.p_test_drop(int) LANGUAGE plpgsql AS $$
BEGIN
  RAISE NOTICE 'sc1.p_test_drop(int)';
END
$$;

-- "SHOW CREATE PROCEDURE" equivalent via pg_catalog.
SELECT pg_get_functiondef(p.oid) AS create_statement
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'p_test_drop'
ORDER BY 1;

SELECT pg_get_functiondef(p.oid) AS create_statement
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'sc1' AND p.proname = 'p_test_drop'
ORDER BY 1;

CALL p_test_drop();
CALL p_test_drop(1);

-- Drop a specific overload.
DROP PROCEDURE p_test_drop(int);

SELECT pg_get_functiondef(p.oid) AS create_statement
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public' AND p.proname = 'p_test_drop'
ORDER BY 1;

DROP SCHEMA sc1 CASCADE;

-- Composite-type procedure argument.
CREATE TYPE t114677 AS (x INT, y INT);
CREATE PROCEDURE p114677(v t114677) LANGUAGE plpgsql AS $$
BEGIN
  RAISE NOTICE 'p114677: %', v;
END
$$;
CALL p114677(ROW(1, 2)::t114677);
DROP PROCEDURE p114677(t114677);
DROP TYPE t114677;

-- Drop-by-signature example.
CREATE PROCEDURE p142886(p VARCHAR(10)) LANGUAGE plpgsql AS $$
BEGIN
  RAISE NOTICE 'p142886: %', p;
END
$$;
DROP PROCEDURE p142886(VARCHAR);

-- Clean up.
DROP PROCEDURE p_test_drop();

