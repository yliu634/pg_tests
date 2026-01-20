-- PostgreSQL compatible tests from create_as
-- NOTE: CockroachDB meta-tests and directives are not supported by PostgreSQL.
-- This file is rewritten to cover core CREATE TABLE AS / SELECT INTO patterns.

SET client_min_messages = warning;

DROP TABLE IF EXISTS src;
DROP TABLE IF EXISTS ctas1;
DROP TABLE IF EXISTS ctas2;
DROP TABLE IF EXISTS ctas_with_constraints;

CREATE TABLE src (a INT, b TEXT);
INSERT INTO src (a, b) VALUES (1, 'one'), (2, 'two'), (3, 'three');

-- Basic CTAS.
CREATE TABLE ctas1 AS
SELECT a, b
FROM src
WHERE a >= 2
ORDER BY a;

SELECT * FROM ctas1 ORDER BY a;

-- CTAS with explicit column names.
CREATE TABLE ctas2 (x, y) AS
SELECT a, b
FROM src
ORDER BY a;

SELECT * FROM ctas2 ORDER BY x;

-- PostgreSQL cannot declare constraints inline in CTAS; use CREATE TABLE + INSERT.
CREATE TABLE ctas_with_constraints (
  a INT PRIMARY KEY,
  b TEXT NOT NULL
);

INSERT INTO ctas_with_constraints (a, b)
SELECT a, b FROM src;

SELECT * FROM ctas_with_constraints ORDER BY a;

RESET client_min_messages;
