-- PostgreSQL compatible tests from trigram_indexes
-- Reduced subset: CockroachDB INVERTED indexes and table hints (@idx) are not
-- available in PostgreSQL; validate pg_trgm GIN index behavior instead.

CREATE EXTENSION IF NOT EXISTS pg_trgm;

SET client_min_messages = warning;
DROP TABLE IF EXISTS a CASCADE;
RESET client_min_messages;

CREATE TABLE a (a INT PRIMARY KEY, t TEXT);
CREATE INDEX a_t_idx ON a USING GIN (t gin_trgm_ops);

INSERT INTO a VALUES
  (1, 'foozoopa'),
  (2, 'Foo'),
  (3, 'blah'),
  (4, 'Приветhi');

-- LIKE/ILIKE (index may be used depending on planner; result must be correct).
SELECT * FROM a WHERE t ILIKE '%Foo%' ORDER BY a;
SELECT * FROM a WHERE t LIKE '%Foo%' ORDER BY a;
SELECT * FROM a WHERE t LIKE 'Foo%' ORDER BY a;
SELECT * FROM a WHERE t LIKE '%Foo' ORDER BY a;
SELECT * FROM a WHERE t LIKE '%foo%oop%' ORDER BY a;

-- Non-ascii LIKE.
SELECT * FROM a WHERE t LIKE 'Привет%' ORDER BY a;

-- Similarity operator.
SELECT similarity(t, 'fooz') AS sim, a, t FROM a WHERE t % 'fooz' ORDER BY a;

SET pg_trgm.similarity_threshold = 0.45;
SELECT similarity(t, 'fooz') AS sim, a, t FROM a WHERE t % 'fooz' ORDER BY a;

SET pg_trgm.similarity_threshold = 0.1;
SELECT similarity(t, 'f') AS sim, a, t FROM a WHERE t % 'f' ORDER BY a;
