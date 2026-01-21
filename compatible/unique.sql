-- PostgreSQL compatible tests from unique
-- 180 tests

SET client_min_messages = warning;

-- Basic UNIQUE / PRIMARY KEY / ON CONFLICT behavior.

-- Test 1: statement
CREATE TABLE uniq (
  k INT PRIMARY KEY,
  v INT UNIQUE,
  w INT UNIQUE,
  x INT,
  y INT DEFAULT 5,
  UNIQUE (x, y)
);

-- Test 2: statement
CREATE TABLE other (
  k INT,
  v INT,
  w INT NOT NULL,
  x INT,
  y INT,
  u UUID
);

-- Test 3: statement
INSERT INTO other VALUES (10, 10, 1, 1, 1, '8597b0eb-7b89-4857-858a-fabf86f6a3ac');

-- Test 4: statement
INSERT INTO uniq VALUES (1, 1, 1, 1, 1), (2, 2, 2, 2, 2);

-- Test 5+: expected errors for PK/UNIQUE violations.
\set ON_ERROR_STOP 0
INSERT INTO uniq VALUES (1, 9, 9, 9, 9);
INSERT INTO uniq VALUES (3, 1, 3, 3, 3);
INSERT INTO uniq VALUES (3, 3, 1, 3, 3);
INSERT INTO uniq (k, v, w, x, y) VALUES (3, 3, 3, 1, 1), (4, 4, 4, 1, 1);
\set ON_ERROR_STOP 1

-- NULLs do not conflict in UNIQUE constraints.
INSERT INTO uniq VALUES (5, 5, NULL, NULL, 1), (6, 6, NULL, NULL, 1);

-- ON CONFLICT DO NOTHING.
INSERT INTO uniq VALUES (7, 7, 7, 7, 7) ON CONFLICT DO NOTHING;
INSERT INTO uniq VALUES (7, 700, 700, 700, 700) ON CONFLICT DO NOTHING;

-- ON CONFLICT DO UPDATE (UPSERT-like).
INSERT INTO uniq (k, v, w, x, y) VALUES (7, 70, 70, 70, 70)
ON CONFLICT (k) DO UPDATE
SET v = EXCLUDED.v,
    w = EXCLUDED.w,
    x = EXCLUDED.x,
    y = EXCLUDED.y;

-- Show final uniq table.
SELECT * FROM uniq ORDER BY k;

-- Partial unique index (CRDB "UNIQUE ... WHERE" mapped to PG partial unique index).
CREATE TABLE uniq_partial (
  a INT,
  b INT
);
CREATE UNIQUE INDEX uniq_partial_a_pos_idx ON uniq_partial (a) WHERE b > 0;

INSERT INTO uniq_partial VALUES (1, 1), (1, -1), (2, 2);

-- Expected ERROR: violates partial unique index (a=1 with b>0).
\set ON_ERROR_STOP 0
INSERT INTO uniq_partial VALUES (1, 3);
\set ON_ERROR_STOP 1

-- Allowed: duplicates when b <= 0.
INSERT INTO uniq_partial VALUES (1, -3);

-- ON CONFLICT targeting the partial unique index requires the predicate.
INSERT INTO uniq_partial VALUES (1, 3), (3, 3)
  ON CONFLICT (a) WHERE b > 0 DO NOTHING;

SELECT * FROM uniq_partial ORDER BY a NULLS FIRST, b;

-- Foreign keys referencing UNIQUE columns.
CREATE TABLE uniq_fk_parent (
  a INT UNIQUE,
  d INT UNIQUE,
  e INT UNIQUE,
  b INT,
  c INT,
  UNIQUE (b, c)
);

CREATE TABLE uniq_fk_child (
  a INT,
  b INT,
  c INT,
  d INT REFERENCES uniq_fk_parent (d),
  e INT REFERENCES uniq_fk_parent (e) ON DELETE SET NULL,
  FOREIGN KEY (b, c) REFERENCES uniq_fk_parent (b, c) ON UPDATE CASCADE
);

INSERT INTO uniq_fk_parent (a, d, e, b, c) VALUES
  (1, 10, 100, 1, 1),
  (2, 20, 200, 2, 2);

INSERT INTO uniq_fk_child VALUES
  (1, 1, 1, 10, 100),
  (2, 2, 2, 20, 200);

-- Expected ERROR: FK violation (d/e missing).
\set ON_ERROR_STOP 0
INSERT INTO uniq_fk_child VALUES (3, 3, 3, 30, 300);
\set ON_ERROR_STOP 1

-- Deleting the parent row is blocked by other FKs too; move child references
-- away first, then delete and observe e is set NULL (ON DELETE SET NULL).
UPDATE uniq_fk_child SET d = NULL, b = 2, c = 2 WHERE a = 1;
DELETE FROM uniq_fk_parent WHERE a = 1;
SELECT * FROM uniq_fk_child ORDER BY a;

-- Generated column + UNIQUE constraint (CRDB VIRTUAL -> PG STORED).
CREATE TABLE t126988 (
  k INT PRIMARY KEY,
  j INT,
  i INT,
  v INT GENERATED ALWAYS AS (i) STORED,
  UNIQUE (i, j)
);

INSERT INTO t126988 VALUES (1, 10, 200);

-- Expected ERROR: duplicate PK and duplicate UNIQUE.
\set ON_ERROR_STOP 0
INSERT INTO t126988 VALUES (1, 10, 200);
\set ON_ERROR_STOP 1

SELECT k, j, i, v FROM t126988 ORDER BY k;

RESET client_min_messages;
