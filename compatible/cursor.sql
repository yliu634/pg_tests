-- PostgreSQL compatible tests from cursor
-- NOTE: CockroachDB cursor tests often rely on logic-test formatting and directives.
-- This file is rewritten as a small PostgreSQL cursor smoke test.

SET client_min_messages = warning;

DROP TABLE IF EXISTS cursor_tbl;
CREATE TABLE cursor_tbl (id INT PRIMARY KEY, v TEXT);
INSERT INTO cursor_tbl (id, v) VALUES (1, 'a'), (2, 'b'), (3, 'c');

BEGIN;
DECLARE cur CURSOR FOR
  SELECT id, v FROM cursor_tbl ORDER BY id;

FETCH 1 FROM cur;
FETCH 2 FROM cur;
MOVE BACKWARD 1 FROM cur;
FETCH 1 FROM cur;
CLOSE cur;
COMMIT;

RESET client_min_messages;
