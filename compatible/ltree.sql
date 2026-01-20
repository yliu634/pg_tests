SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS ltree;

-- PostgreSQL compatible tests from ltree
-- Deterministic, error-free subset exercising core ltree features.

DROP TABLE IF EXISTS l CASCADE;
CREATE TABLE l (lt LTREE);
INSERT INTO l VALUES ('A'), ('A.B'), ('A.B.C'), ('A.B.D'), ('Z'), (''), (NULL);

DROP TABLE IF EXISTS la CASCADE;
CREATE TABLE la (lta LTREE[]);
INSERT INTO la VALUES
  (ARRAY['A', 'A.B']::ltree[]),
  (ARRAY['A.B.C', 'A.B.D', 'Z']::ltree[]),
  (ARRAY[]::ltree[]),
  (NULL);

SELECT * FROM l ORDER BY lt;
SELECT * FROM la ORDER BY lta;

SELECT pg_typeof(lt) FROM l WHERE lt IS NOT NULL LIMIT 1;
SELECT pg_typeof(lta) FROM la WHERE lta IS NOT NULL LIMIT 1;

SELECT lt, lt @> 'A.B'::ltree AS contains_ab, lt <@ 'A.B'::ltree AS contained_by_ab
FROM l
WHERE lt IS NOT NULL
ORDER BY lt;

SELECT lta, lta ?@> 'A.B'::ltree AS contains_ab, lta ?<@ 'A.B'::ltree AS contained_by_ab
FROM la
ORDER BY lta;

SELECT ('A.B'::ltree || 'C'::ltree) AS concat_path;
SELECT subpath('Top.Child1.Child2'::ltree, 1) AS sub1;
SELECT subpath('Top.Child1.Child2'::ltree, -2) AS subneg2;
SELECT nlevel('Top.Child1.Child2'::ltree) AS depth;
SELECT index('A.B.B.C.B.C'::ltree, 'B.C'::ltree) AS idx;
SELECT text2ltree('foo_bar-baz.baz') AS t2l;

RESET client_min_messages;
