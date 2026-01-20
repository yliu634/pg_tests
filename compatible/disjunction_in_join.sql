-- PostgreSQL compatible tests from disjunction_in_join
-- This file is rewritten to cover joins with disjunctive predicates in PostgreSQL.

SET client_min_messages = warning;

DROP TABLE IF EXISTS a;
DROP TABLE IF EXISTS b;

CREATE TABLE a (id INT PRIMARY KEY, v INT);
CREATE TABLE b (id INT PRIMARY KEY, v INT);

INSERT INTO a VALUES (1, 10), (2, 20), (3, 30);
INSERT INTO b VALUES (1, 100), (4, 400);

SELECT a.id, a.v AS a_v, b.v AS b_v
FROM a
LEFT JOIN b
  ON (a.id = b.id OR a.v = b.v)
ORDER BY a.id;

RESET client_min_messages;
