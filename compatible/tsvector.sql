-- PostgreSQL compatible tests from tsvector
-- Reduced subset: remove CockroachDB INVERTED indexes/table hints and focus on
-- PostgreSQL full-text search (tsvector/tsquery + GIN).

SET client_min_messages = warning;
DROP TABLE IF EXISTS a CASCADE;
DROP TABLE IF EXISTS sentences CASCADE;
RESET client_min_messages;

SELECT
  'foo:1,2 bar:3'::tsvector @@ 'foo <-> bar'::tsquery AS match_left,
  'foo <-> bar'::tsquery @@ 'foo:1,2 bar:3'::tsvector AS match_right;

CREATE TABLE a (v tsvector, q tsquery);
INSERT INTO a VALUES ('foo:1,2 bar:4B'::tsvector, 'foo <2> bar'::tsquery);

SELECT * FROM a;
SELECT v @@ q FROM a;

-- Index-assisted search.
CREATE INDEX a_v_gin ON a USING GIN (v);
SELECT v FROM a WHERE v @@ 'foo'::tsquery;
SELECT v FROM a WHERE v @@ '!foo'::tsquery;

-- ts* builtins.
SELECT * FROM ts_parse('default', 'Hello this is a parsi-ng t.est 1.234 4 case324');
SELECT to_tsvector('simple', 'Hello this is a parsi-ng t.est 1.234 4 case324');
SELECT phraseto_tsquery('simple', 'Hello this is a parsi-ng t.est 1.234 4 case324');

SHOW default_text_search_config;
SELECT to_tsvector('Hello I am a potato');

SET default_text_search_config = 'english';
SELECT to_tsvector('Hello I am a potato');

-- Basic end-to-end example.
CREATE TABLE sentences (sentence text);
INSERT INTO sentences VALUES
  ('Future users of large data banks must be protected from having to know how the data is organized in the machine.'),
  ('A prompting service which supplies such information is not a satisfactory solution.');

SELECT sentence
FROM sentences
WHERE to_tsvector('english', sentence) @@ plainto_tsquery('english', 'data banks')
ORDER BY sentence;
