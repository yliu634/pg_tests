-- PostgreSQL compatible tests from typing
-- Reduced subset: remove CockroachDB BYTES/STRING types and error-expecting
-- casts; validate basic PostgreSQL type coercion and comparisons.

SET client_min_messages = warning;
DROP TABLE IF EXISTS f CASCADE;
DROP TABLE IF EXISTS d CASCADE;
DROP TABLE IF EXISTS untyped CASCADE;
RESET client_min_messages;

CREATE TABLE f (x DOUBLE PRECISION);
INSERT INTO f(x) VALUES (3.0/2), (1);
SELECT * FROM f ORDER BY x;

CREATE TABLE d (x NUMERIC);
INSERT INTO d(x) VALUES ((9/3)::numeric * (1/3.0)::numeric), (2.0), (2.4 + 4.6);
SELECT * FROM d ORDER BY x;
UPDATE d SET x = x + 1 WHERE x + sqrt(x) >= 2 + .1;
SELECT * FROM d ORDER BY x;

SELECT COALESCE(1, 2) AS coalesce_int,
       COALESCE(NULL::text, 'foo') AS coalesce_text;

SELECT greatest(-1, 1, 2, 123456789, 3 + 5, -(-4)) AS greatest_int;
SELECT greatest(-1.123, 1.21313, 2.3, 123456789.321, 3 + 5.3213, -(-4.3213), abs(-9)) AS greatest_float;

CREATE TABLE untyped (
  b  bool,
  n  int,
  f  float,
  e  numeric,
  d  date,
  ts timestamp,
  tz timestamptz,
  i  interval
);

INSERT INTO untyped VALUES
  (false, 42, 4.2, 4.20, '2010-09-28', '2010-09-28 12:00:00.1', '2010-09-29 12:00:00.1+00', interval '12 hours 2 minutes');

SELECT * FROM untyped;

SELECT VARCHAR(4) 'foo' AS v4,
       CHAR(2) 'bar' AS c2,
       'cat'::text AS txt;

SELECT
  'foo'::bpchar = 'foo   '::bpchar AS bpchar_eq,
  'foo'::bpchar < 'foo   '::bpchar AS bpchar_lt,
  'foo'::bpchar > 'foo   '::bpchar AS bpchar_gt;
