-- PostgreSQL compatible tests from returning
--
-- Reduced to a small set of INSERT/UPDATE/DELETE ... RETURNING statements with
-- stable psql execution.

SET client_min_messages = warning;

DROP TABLE IF EXISTS a;
CREATE TABLE a (a INT, b INT);

INSERT INTO a AS alias VALUES (1, 2) RETURNING alias.a, alias.b;
UPDATE a AS alias SET b = 1 RETURNING alias.a, alias.b;
UPDATE a AS alias SET b = 1 RETURNING alias.a, alias.b;
DELETE FROM a AS alias RETURNING alias.a, alias.b;

DROP TABLE a;

RESET client_min_messages;
