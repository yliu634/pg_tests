-- PostgreSQL compatible tests from tuple
-- Reduced subset: remove invalid empty IN/ANY syntax and focus on PostgreSQL row
-- (tuple) comparisons.

SET client_min_messages = warning;
DROP TABLE IF EXISTS tb CASCADE;
DROP TABLE IF EXISTS t CASCADE;
RESET client_min_messages;

CREATE TABLE tb(unused INT);
INSERT INTO tb VALUES (1);

SELECT (1, 2, 'hello', NULL, NULL) AS t,
       (true, NULL, (false, 6.6, false)) AS u
FROM tb;

SELECT
  (2, 2) < (1, 1) AS lt,
  (2, 2) = (2, 2) AS eq,
  (2, 2) > (3, 3) AS gt
FROM tb;

CREATE TABLE t (a INT, b INT, c INT);
INSERT INTO t VALUES (1, 2, 3), (2, 3, 1), (3, 1, 2);

SELECT * FROM t WHERE (a, b) < (3, 2) ORDER BY a, b, c;
SELECT (a, b, c) = (1, 2, 3) AS is_123 FROM t ORDER BY a;
SELECT (a, b) IN ((1, 2), (3, 1)) AS in_list FROM t ORDER BY a;
