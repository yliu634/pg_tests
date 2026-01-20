-- PostgreSQL compatible tests from show_fingerprints
-- 32 tests

SET client_min_messages = warning;

-- Cockroach's `SHOW FINGERPRINTS` surfaces a per-index checksum. PostgreSQL
-- doesn't have an equivalent statement, so we emulate it with a helper that:
-- - returns one row per index (including the PK)
-- - hashes index-relevant row values (and respects an exclude column list)
DROP FUNCTION IF EXISTS crdb_show_fingerprints(regclass, text[]);
CREATE FUNCTION crdb_show_fingerprints(tbl regclass, exclude_cols text[] DEFAULT ARRAY[]::text[])
RETURNS TABLE(index_name text, fingerprint text)
LANGUAGE plpgsql
AS $$
DECLARE
  tbl_oid oid := tbl;
  pk_cols text[] := ARRAY[]::text[];
  idx record;
  key_defs text[];
  all_defs text[];
  fp_defs text[];
  def text;
  def_norm text;
  value_exprs text[];
  order_exprs text[];
  sql text;
BEGIN
  -- Primary key columns are used as a deterministic tie-breaker for ordering.
  SELECT array_agg(format('%I', a.attname) ORDER BY s.ordinality)
    INTO pk_cols
  FROM pg_index i
  JOIN unnest(i.indkey) WITH ORDINALITY AS s(attnum, ordinality) ON true
  JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = s.attnum
  WHERE i.indrelid = tbl_oid AND i.indisprimary;

  IF pk_cols IS NULL THEN
    pk_cols := ARRAY[]::text[];
  END IF;

  FOR idx IN
    SELECT c.oid AS index_oid,
           c.relname AS index_name,
           i.indisprimary,
           i.indnkeyatts,
           i.indnatts
      FROM pg_index i
      JOIN pg_class c ON c.oid = i.indexrelid
     WHERE i.indrelid = tbl_oid
       AND i.indisvalid
       AND i.indisready
     ORDER BY c.relname
  LOOP
    -- Fetch key and full (key+include) column definitions for this index.
    SELECT array_agg(pg_get_indexdef(idx.index_oid, s.i, true) ORDER BY s.i)
      INTO key_defs
    FROM generate_series(1, idx.indnkeyatts) AS s(i);

    SELECT array_agg(pg_get_indexdef(idx.index_oid, s.i, true) ORDER BY s.i)
      INTO all_defs
    FROM generate_series(1, idx.indnatts) AS s(i);

    IF key_defs IS NULL THEN
      key_defs := ARRAY[]::text[];
    END IF;
    IF all_defs IS NULL THEN
      all_defs := ARRAY[]::text[];
    END IF;

    -- Build the list of value expressions to hash for this index.
    fp_defs := ARRAY[]::text[];
    IF idx.indisprimary THEN
      -- Cockroach's "primary index" fingerprint includes all table columns.
      SELECT array_agg(format('%I', a.attname) ORDER BY a.attnum)
        INTO fp_defs
      FROM pg_attribute a
      WHERE a.attrelid = tbl_oid
        AND a.attnum > 0
        AND NOT a.attisdropped;
    ELSE
      -- Secondary index: key cols + INCLUDE cols + PK cols.
      fp_defs := all_defs || pk_cols;
    END IF;

    -- Filter excluded *table columns* from the fingerprint value list. For
    -- expression index columns (e.g. (b + 42)), this is a no-op.
    value_exprs := ARRAY[]::text[];
    FOREACH def IN ARRAY fp_defs LOOP
      def_norm := lower(def);
      IF left(def, 1) = '"' AND right(def, 1) = '"' THEN
        def_norm := lower(replace(substr(def, 2, char_length(def) - 2), '""', '"'));
      END IF;
      IF exclude_cols IS NOT NULL AND def_norm = ANY (SELECT lower(x) FROM unnest(exclude_cols) AS x) THEN
        CONTINUE;
      END IF;
      value_exprs := value_exprs || format('coalesce((%s)::text, ''<NULL>'')', def);
    END LOOP;

    IF array_length(value_exprs, 1) IS NULL THEN
      -- Still incorporate row count even if everything is excluded.
      value_exprs := ARRAY['''<EMPTY>'''];
    END IF;

    -- ORDER BY follows the index key columns, then PK columns for stability.
    order_exprs := key_defs || pk_cols;
    IF array_length(order_exprs, 1) IS NULL THEN
      order_exprs := ARRAY['1'];
    END IF;

    sql := format(
      'SELECT md5(count(*)::text || '':'' || coalesce(string_agg(md5(concat_ws(''|'', %s)), '','' ORDER BY %s), '''')) FROM %s t',
      array_to_string(value_exprs, ', '),
      array_to_string(order_exprs, ', '),
      tbl
    );

    EXECUTE sql INTO fingerprint;
    index_name := idx.index_name;
    RETURN NEXT;
  END LOOP;
END;
$$;

DROP SCHEMA IF EXISTS test CASCADE;
CREATE SCHEMA test;
SET search_path = test, public;

DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS blocks CASCADE;
DROP TABLE IF EXISTS "foo""bar" CASCADE;
DROP TABLE IF EXISTS t_w_expr_index CASCADE;

-- Test 1: statement (line 1)
CREATE TABLE t (a INT PRIMARY KEY, b INT, c INT, d INT);
CREATE INDEX t_b_idx ON t (b) INCLUDE (d);

-- Test 2: query (line 11)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 3: statement (line 17)
INSERT INTO t VALUES (1, 2, 3, 4), (5, 6, 7, 8), (9, 10, 11, 12);

-- Test 4: query (line 27)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 5: query (line 34)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 6: query (line 47)
SELECT * FROM crdb_show_fingerprints('t'::regclass, ARRAY['c']);

-- Test 7: query (line 60)
SELECT * FROM crdb_show_fingerprints('t'::regclass, ARRAY['a', 'b']);

-- Test 8: query (line 92)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 9: statement (line 99)
-- Expected error: `t_b_idx1` does not exist.
\set ON_ERROR_STOP 0
DROP INDEX t_b_idx1;
\set ON_ERROR_STOP 1

-- Test 10: statement (line 102)
UPDATE t SET b = 9;

-- Test 11: query (line 112)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 12: statement (line 118)
UPDATE t SET c = 10;

-- Test 13: query (line 128)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 14: statement (line 134)
UPDATE t SET d = 10;

-- Test 15: query (line 144)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 16: query (line 162)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 17: statement (line 168)
-- Expected error: unknown column.
\set ON_ERROR_STOP 0
UPDATE t SET e = 'foo' WHERE a = 1;
\set ON_ERROR_STOP 1

-- Test 18: query (line 178)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 19: statement (line 184)
DROP INDEX t_b_idx;

-- Test 20: query (line 193)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 21: query (line 204)
SELECT * FROM crdb_show_fingerprints('test.t'::regclass);

-- Test 22: statement (line 209)
CREATE TABLE "foo""bar" ("a""b" INT PRIMARY KEY, b INT);
CREATE INDEX "id""x" ON "foo""bar" (b);

-- Test 23: statement (line 212)
INSERT INTO "foo""bar" VALUES (1, 2), (3, 4), (5, 6);

-- Test 24: query (line 223)
SELECT * FROM crdb_show_fingerprints('"foo""bar"'::regclass);

-- Test 25: statement (line 231)
CREATE TABLE blocks (block_id INT PRIMARY KEY, raw_bytes BYTEA NOT NULL);

-- Test 26: statement (line 234)
INSERT INTO blocks VALUES (1, '\x01'::bytea);

-- Test 27: query (line 242)
SELECT * FROM crdb_show_fingerprints('blocks'::regclass);

-- Test 28: query (line 256)
SELECT * FROM crdb_show_fingerprints('t'::regclass);

-- Test 29: statement (line 261)
BEGIN;
COMMIT;

-- Test 30: statement (line 264)
CREATE TABLE t_w_expr_index (
  a INT PRIMARY KEY,
  b INT,
  c INT GENERATED ALWAYS AS (b + 42) STORED
);
CREATE INDEX t_w_expr_index_c_idx ON t_w_expr_index (c);
CREATE INDEX t_w_expr_index_expr_idx ON t_w_expr_index ((b + 42));

-- Test 31: statement (line 267)
INSERT INTO t_w_expr_index(a, b) VALUES (1, 1), (2, 2), (3, 3);

-- Test 32: query (line 277)
SELECT * FROM crdb_show_fingerprints('t_w_expr_index'::regclass);

RESET client_min_messages;
RESET search_path;
