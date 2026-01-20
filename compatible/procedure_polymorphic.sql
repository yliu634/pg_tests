-- PostgreSQL compatible tests from procedure_polymorphic
--
-- The upstream CockroachDB logic-test file contains many negative cases around
-- polymorphic type inference. This reduced version demonstrates PostgreSQL
-- polymorphic procedure parameters (ANYELEMENT/ANYARRAY) using only calls with
-- explicit types to avoid ambiguity.

SET client_min_messages = warning;

DROP TYPE IF EXISTS greetings CASCADE;
DROP TYPE IF EXISTS typ CASCADE;

CREATE TYPE greetings AS ENUM ('hi', 'hello', 'yo');
CREATE TYPE typ AS (x INT, y INT);

DROP PROCEDURE IF EXISTS p_anyelement(ANYELEMENT);
DROP PROCEDURE IF EXISTS p_anyarray(ANYARRAY);
DROP PROCEDURE IF EXISTS p_pair(ANYELEMENT, ANYELEMENT);

CREATE PROCEDURE p_anyelement(x ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;
CALL p_anyelement(1);
CALL p_anyelement('foo'::TEXT);
CALL p_anyelement(false);
CALL p_anyelement('hi'::greetings);

CREATE PROCEDURE p_anyarray(x ANYARRAY) LANGUAGE SQL AS $$ SELECT 1; $$;
CALL p_anyarray(ARRAY[1, 2, 3]);
CALL p_anyarray(ARRAY['one', 'two']);
CALL p_anyarray(ARRAY['hi'::greetings, 'yo'::greetings]);

CREATE PROCEDURE p_pair(x ANYELEMENT, y ANYELEMENT) LANGUAGE SQL AS $$ SELECT 1; $$;
CALL p_pair(1, 2);
CALL p_pair('hi'::greetings, 'hello'::greetings);
CALL p_pair(ROW(1, 2)::typ, ROW(3, 4)::typ);

DROP PROCEDURE p_anyelement(ANYELEMENT);
DROP PROCEDURE p_anyarray(ANYARRAY);
DROP PROCEDURE p_pair(ANYELEMENT, ANYELEMENT);

DROP TYPE greetings;
DROP TYPE typ;

RESET client_min_messages;
