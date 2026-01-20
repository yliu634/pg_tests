-- PostgreSQL compatible tests from procedure_params
--
-- The upstream CockroachDB logic-test file contains many negative/invalid
-- cases. This reduced version demonstrates PostgreSQL procedure parameter
-- modes (OUT/INOUT) and how CALL supplies placeholders for OUT parameters.

SET client_min_messages = warning;

DROP PROCEDURE IF EXISTS out_only(INT);
DROP PROCEDURE IF EXISTS in_out(INT, INT);
DROP PROCEDURE IF EXISTS add_inout(INT, INT);

CREATE PROCEDURE out_only(OUT x INT)
LANGUAGE plpgsql
AS $$
BEGIN
  x := 42;
END;
$$;

CALL out_only(NULL::INT);

CREATE PROCEDURE in_out(IN a INT, OUT b INT)
LANGUAGE plpgsql
AS $$
BEGIN
  b := a + 1;
END;
$$;

CALL in_out(1, NULL::INT);

CREATE PROCEDURE add_inout(INOUT x INT, IN y INT)
LANGUAGE plpgsql
AS $$
BEGIN
  x := x + y;
END;
$$;

CALL add_inout(3, 4);

DROP PROCEDURE out_only(INT);
DROP PROCEDURE in_out(INT, INT);
DROP PROCEDURE add_inout(INT, INT);

RESET client_min_messages;
