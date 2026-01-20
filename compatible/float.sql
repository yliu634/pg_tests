-- PostgreSQL compatible tests from float
--
-- CockroachDB supports inline index definitions, table@index access, IS NAN,
-- and integer division (//) syntax not present in PostgreSQL. This file tests
-- NaN/Infinity handling, ordering, and float formatting in PG.

SET client_min_messages = warning;
DROP TABLE IF EXISTS float_p CASCADE;
DROP TABLE IF EXISTS float_i CASCADE;
DROP TABLE IF EXISTS float_vals CASCADE;
DROP TABLE IF EXISTS float_t87605 CASCADE;
DROP TABLE IF EXISTS float_t89961 CASCADE;
RESET client_min_messages;

CREATE TABLE float_p (f float8);
CREATE UNIQUE INDEX float_p_f_uq ON float_p(f);

INSERT INTO float_p VALUES
  (NULL),
  ('NaN'::float8),
  ('Infinity'::float8),
  ('-Infinity'::float8),
  (0::float8),
  (1::float8),
  (-1::float8);

SELECT f, (f = 'NaN'::float8) AS is_nan
FROM float_p
ORDER BY f NULLS LAST;

CREATE TABLE float_i (f float8);
INSERT INTO float_i VALUES (0::float8), ('-0'::float8);
CREATE INDEX float_i_f_asc ON float_i (f);
CREATE INDEX float_i_f_desc ON float_i (f DESC);

SELECT * FROM float_i WHERE f = 0 ORDER BY f;
SELECT * FROM float_i ORDER BY f;
SELECT * FROM float_i ORDER BY f DESC;

CREATE TABLE float_vals(f float8);
INSERT INTO float_vals VALUES (0.0), (123.4567890123456789), (0.0001234567890123456789);

SET extra_float_digits = 3;
SELECT f FROM float_vals ORDER BY f;
SET extra_float_digits = -15;
SELECT f FROM float_vals ORDER BY f;
RESET extra_float_digits;
DROP TABLE float_vals;

CREATE TABLE float_t87605 (col2 float8);
INSERT INTO float_t87605 VALUES (1.234567890123456e+13), (1.234567890123456e+6);
SELECT floor(col2 / 1.0)::float8 FROM float_t87605 ORDER BY 1;

CREATE TABLE float_t89961 (a float8 PRIMARY KEY);
CREATE INDEX float_t89961_a_desc ON float_t89961 (a DESC);
INSERT INTO float_t89961 VALUES ('NaN'::float8);
SELECT a, (a = 'NaN'::float8) AS is_nan FROM float_t89961;
