-- PostgreSQL compatible tests from alter_primary_key
-- NOTE: CockroachDB's `ALTER PRIMARY KEY USING COLUMNS (...)` is not supported by
-- PostgreSQL. This file exercises the closest PostgreSQL equivalent: dropping and
-- re-adding PRIMARY KEY constraints.

SET client_min_messages = warning;

-- Test 1: Change a simple PRIMARY KEY.
DROP TABLE IF EXISTS t CASCADE;
CREATE TABLE t (
  x INT PRIMARY KEY,
  y INT NOT NULL,
  z INT NOT NULL,
  w INT
);

INSERT INTO t VALUES (1, 2, 3, 4), (5, 6, 7, 8);

SELECT conname, pg_get_constraintdef(oid) AS def
FROM pg_constraint
WHERE conrelid = 't'::regclass AND contype = 'p'
ORDER BY conname;

ALTER TABLE t DROP CONSTRAINT t_pkey;
ALTER TABLE t ADD PRIMARY KEY (y, z);

SELECT conname, pg_get_constraintdef(oid) AS def
FROM pg_constraint
WHERE conrelid = 't'::regclass AND contype = 'p'
ORDER BY conname;

SELECT * FROM t ORDER BY y, z;

-- Test 2: Change a PRIMARY KEY with a dependent FOREIGN KEY (drop/recreate FK).
DROP TABLE IF EXISTS fk1 CASCADE;
DROP TABLE IF EXISTS fk2 CASCADE;

CREATE TABLE fk2 (
  x INT PRIMARY KEY,
  y INT NOT NULL
);
CREATE TABLE fk1 (
  x INT NOT NULL,
  CONSTRAINT fk FOREIGN KEY (x) REFERENCES fk2(x)
);

INSERT INTO fk2 VALUES (1, 1), (2, 2);
INSERT INTO fk1 VALUES (1), (2);

ALTER TABLE fk1 DROP CONSTRAINT fk;
ALTER TABLE fk2 DROP CONSTRAINT fk2_pkey;
ALTER TABLE fk2 ADD PRIMARY KEY (y);
ALTER TABLE fk1 ADD CONSTRAINT fk FOREIGN KEY (x) REFERENCES fk2(y);

SELECT fk1.x AS fk1_x, fk2.y AS fk2_y
FROM fk1
JOIN fk2 ON fk1.x = fk2.y
ORDER BY 1, 2;

-- Cleanup.
DROP TABLE IF EXISTS fk1 CASCADE;
DROP TABLE IF EXISTS fk2 CASCADE;
DROP TABLE IF EXISTS t CASCADE;

RESET client_min_messages;
