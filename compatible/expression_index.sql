-- PostgreSQL compatible tests from expression_index
-- Focus: expression indexes, generated columns, and JSON expression indexing.

-- Basic expression indexes over arithmetic and text functions.
CREATE TABLE t (
  k INT PRIMARY KEY,
  a INT NOT NULL,
  b INT NOT NULL,
  c TEXT NOT NULL,
  comp INT GENERATED ALWAYS AS (a + b) STORED
);

CREATE INDEX t_a_plus_b_idx ON t ((a + b));
CREATE INDEX t_lower_c_idx ON t ((lower(c)));
CREATE INDEX t_lower_c_a_plus_b_idx ON t ((lower(c)), (a + b));
CREATE INDEX t_a_times_two_idx ON t ((a * 2));

INSERT INTO t (k, a, b, c) VALUES
  (1, 10, 100, 'Foo'),
  (2, 20, 200, 'FOO'),
  (3, 10, 100, 'foo'),
  (4, 40, 400, 'BAR'),
  (5, 100, 10, 'Food');

SELECT k, a, b, c, comp FROM t WHERE a + b = 110 ORDER BY k;
SELECT k, a, b, c, comp FROM t WHERE a + b > 110 ORDER BY k;
SELECT k, a, b, c, comp FROM t WHERE lower(c) = 'foo' ORDER BY k;
SELECT k, a, b, c, comp FROM t WHERE lower(c) LIKE 'foo%' ORDER BY k;
SELECT k, a, b, c, comp FROM t WHERE lower(c) = 'foo' AND a + b > 110 ORDER BY k;
SELECT k, a, b, c, comp FROM t WHERE a * 2 = 20 ORDER BY k;
SELECT k, a, b, c, comp FROM t WHERE a * 2 < 100 ORDER BY k;

-- Expression index on a JSON field.
CREATE TABLE d (
  a INT PRIMARY KEY,
  j JSONB NOT NULL
);

-- Index the extracted text so equality/range comparisons are btree-indexable.
CREATE INDEX json_expr_index ON d ((j->>'a'));

INSERT INTO d VALUES
  (1, '{"a": "hello"}'),
  (2, '{"a": "b"}'),
  (3, '{"a": "bye"}'),
  (4, '{"a": "json"}');

SELECT a, j FROM d WHERE j->>'a' = 'b' ORDER BY a;
SELECT a, j FROM d WHERE j->>'a' IN ('b', 'bye') ORDER BY a;
SELECT a, j FROM d WHERE j->>'a' > 'a' ORDER BY a;
SELECT a, j FROM d WHERE j->>'a' <= 'hello' ORDER BY a;

-- JSONB containment queries (GIN indexes are the closest PG analogue to CRDB inverted indexes).
CREATE TABLE inv (
  k INT PRIMARY KEY,
  i INT NOT NULL,
  j JSONB NOT NULL
);

CREATE INDEX inv_i_idx ON inv (i);
CREATE INDEX inv_j_idx ON inv USING gin (j);
CREATE INDEX inv_j_a_idx ON inv USING gin ((j->'a'));
CREATE INDEX inv_j_a_b_idx ON inv USING gin ((j->'a'->'b'));

INSERT INTO inv VALUES
  (1, 1, 'null'),
  (2, 1, 'true'),
  (3, 1, '1'),
  (4, 1, '""'),
  (5, 1, '"x"'),
  (6, 1, '{}'),
  (7, 1, '[]'),
  (8, 1, '{"a": null}'),
  (9, 1, '{"a": true}'),
  (10, 1, '{"a": 1}'),
  (11, 1, '{"a": ""}'),
  (12, 1, '{"a": "x"}'),
  (13, 1, '{"a": []}'),
  (14, 1, '{"a": [null, 1, true, ""]}'),
  (15, 1, '{"a": ["x", "y", "z"]}'),
  (16, 2, '{"a": ["x", "y", "z"]}'),
  (17, 1, '{"a": ["p", "q"]}'),
  (18, 1, '{"a": [1, "x"]}'),
  (19, 2, '{"a": [1, "x"]}'),
  (20, 1, '{"a": {}}'),
  (21, 1, '{"a": {"b": null}}'),
  (22, 1, '{"a": {"b": true}}'),
  (23, 1, '{"a": {"b": 1}}'),
  (24, 1, '{"a": {"b": ""}}'),
  (25, 1, '{"a": {"b": "x"}}'),
  (26, 1, '{"a": {"b": []}}'),
  (27, 1, '{"a": {"b": [null, 1, true, ""]}}'),
  (28, 1, '{"a": {"b": ["x", "y", "z"]}}'),
  (29, 1, '{"a": {"b": ["p", "q"]}}'),
  (30, 1, '{"a": {"b": [1, "x"]}}'),
  (31, 1, '{"a": {"b": {}}}'),
  (32, 1, '{"a": {"b": {"x": "y"}}}'),
  (33, 1, '{"a": {"b": {"p": "q"}}}');

SELECT j FROM inv WHERE j->'a' @> '"x"'::jsonb ORDER BY k;
SELECT j FROM inv WHERE j->'a'->'b' @> '"x"'::jsonb ORDER BY k;
SELECT i, j FROM inv WHERE i = 1 AND j->'a' @> '"x"'::jsonb ORDER BY k;
SELECT i, j FROM inv WHERE i + 100 = 101 AND j->'a' @> '"x"'::jsonb ORDER BY k;

-- Unique constraints on expressions via generated columns.
CREATE TABLE uniq (
  k INT PRIMARY KEY,
  a INT NOT NULL,
  b INT NOT NULL,
  ab_sum INT GENERATED ALWAYS AS (a + b) STORED UNIQUE
);

INSERT INTO uniq (k, a, b) VALUES
  (1, 10, 100),
  (2, 20, 200);

-- Duplicate sums become no-ops instead of errors.
INSERT INTO uniq (k, a, b) VALUES (3, 1, 109)
  ON CONFLICT (ab_sum) DO NOTHING;

-- Demonstrate DO UPDATE targeting the expression-derived uniqueness.
INSERT INTO uniq (k, a, b) VALUES (4, 1, 109)
  ON CONFLICT (ab_sum) DO UPDATE SET b = 90;

SELECT k, a, b, ab_sum FROM uniq ORDER BY k;

-- Altering a column used in an expression index.
CREATE TABLE t72012 (col integer);
CREATE INDEX t72012_idx ON t72012 ((abs(col)));

ALTER TABLE t72012 ALTER COLUMN col SET NOT NULL;
ALTER TABLE t72012 ALTER COLUMN col DROP NOT NULL;

INSERT INTO t72012 VALUES (NULL);
DELETE FROM t72012 WHERE col IS NULL;

ALTER TABLE t72012 ALTER COLUMN col SET NOT NULL;

-- Unique JSON field via generated column.
CREATE TABLE uniq_json (
  k INT PRIMARY KEY,
  j JSONB NOT NULL,
  j_a TEXT GENERATED ALWAYS AS (j->>'a') STORED UNIQUE
);

INSERT INTO uniq_json (k, j) VALUES (1, '{"a": "b"}');
INSERT INTO uniq_json (k, j) VALUES (2, '{"a": "b"}')
  ON CONFLICT (j_a) DO NOTHING;

SELECT k, j, j_a FROM uniq_json ORDER BY k;
