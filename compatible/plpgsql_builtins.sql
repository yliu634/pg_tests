-- PostgreSQL compatible tests from plpgsql_builtins
--
-- CockroachDB exposes several cursor/RAISE helpers in `crdb_internal.plpgsql_*`.
-- PostgreSQL does not provide those, so this test focuses on equivalent native
-- cursor behavior and pg_cursors visibility.

SET client_min_messages = warning;

DROP TABLE IF EXISTS xy;
CREATE TABLE xy (x INT, y INT);
INSERT INTO xy VALUES (1, 2), (3, 4), (5, 6);

-- Basic cursor visibility via pg_cursors.
BEGIN;
DECLARE "portal_1" CURSOR FOR SELECT 1;
SELECT name FROM pg_cursors ORDER BY name;
CLOSE "portal_1";
ROLLBACK;

-- Fetch/move behavior (use SCROLL for backward fetches).
BEGIN;
DECLARE foo SCROLL CURSOR FOR SELECT * FROM xy ORDER BY x DESC;
FETCH FORWARD 1 FROM foo;
FETCH NEXT FROM foo;
FETCH PRIOR FROM foo;
FETCH ABSOLUTE 1 FROM foo;
FETCH RELATIVE 1 FROM foo;
MOVE FORWARD ALL FROM foo;
FETCH BACKWARD 2 FROM foo;
CLOSE foo;
ROLLBACK;

DROP TABLE IF EXISTS xy;

RESET client_min_messages;
