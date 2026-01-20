-- PostgreSQL compatible tests from subquery_correlated
-- Reduced subset: keep a small, deterministic set of correlated subquery cases.

SET client_min_messages = warning;
DROP TABLE IF EXISTS o CASCADE;
DROP TABLE IF EXISTS c CASCADE;
RESET client_min_messages;

CREATE TABLE c (c_id INT PRIMARY KEY, bill TEXT);
CREATE TABLE o (o_id INT PRIMARY KEY, c_id INT REFERENCES c(c_id), ship TEXT);

INSERT INTO c VALUES
  (1, 'CA'),
  (2, 'TX'),
  (3, 'MA'),
  (4, 'TX'),
  (5, NULL),
  (6, 'FL');

INSERT INTO o VALUES
  (10, 1, 'CA'), (20, 1, 'CA'), (30, 1, 'CA'),
  (40, 2, 'CA'), (50, 2, 'TX'), (60, 2, NULL),
  (70, 4, 'WY'), (80, 4, NULL),
  (90, 6, 'WA');

-- EXISTS / NOT EXISTS.
SELECT c_id, bill
FROM c
WHERE EXISTS (SELECT 1 FROM o WHERE o.c_id = c.c_id)
ORDER BY c_id;

SELECT c_id, bill
FROM c
WHERE NOT EXISTS (SELECT 1 FROM o WHERE o.c_id = c.c_id)
ORDER BY c_id;

-- Correlated IN.
SELECT c_id, bill
FROM c
WHERE 'WY' IN (SELECT ship FROM o WHERE o.c_id = c.c_id)
ORDER BY c_id;

-- Correlated IN using a column.
SELECT c_id, bill
FROM c
WHERE bill IN (SELECT ship FROM o WHERE o.c_id = c.c_id)
ORDER BY c_id;

-- Correlated scalar subquery (counts).
SELECT
  c_id,
  bill,
  (SELECT count(*) FROM o WHERE o.c_id = c.c_id) AS order_count,
  (SELECT count(ship) FROM o WHERE o.c_id = c.c_id) AS nonnull_ship_count
FROM c
ORDER BY c_id;

-- Correlated filter on aggregate.
SELECT c_id, bill
FROM c
WHERE (SELECT count(*) FROM o WHERE o.c_id = c.c_id) > 1
ORDER BY c_id;
