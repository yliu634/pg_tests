-- PostgreSQL compatible tests from rename_constraint
--
-- CockroachDB features like column families and `SHOW CREATE` are not
-- available in PostgreSQL. This reduced version exercises renaming constraints
-- and observing changes via pg_constraint.

SET client_min_messages = warning;

DROP TABLE IF EXISTS implicit;
DROP TABLE IF EXISTS t;

CREATE TABLE t (
  x INT,
  y INT,
  CONSTRAINT cu UNIQUE (x),
  CONSTRAINT cc CHECK (x > 10),
  CONSTRAINT cf FOREIGN KEY (x) REFERENCES t(x)
);

SELECT conname, contype
  FROM pg_constraint
 WHERE conrelid = 't'::regclass
 ORDER BY conname;

ALTER TABLE t RENAME CONSTRAINT cu TO cu2;
ALTER TABLE t RENAME CONSTRAINT cc TO cc2;
ALTER TABLE t RENAME CONSTRAINT cf TO cf2;

SELECT conname, contype
  FROM pg_constraint
 WHERE conrelid = 't'::regclass
 ORDER BY conname;

CREATE TABLE implicit (a INT PRIMARY KEY, b INT);

SELECT conname, contype
  FROM pg_constraint
 WHERE conrelid = 'implicit'::regclass
 ORDER BY conname;

ALTER TABLE implicit RENAME CONSTRAINT implicit_pkey TO implicit_pk_renamed;
ALTER TABLE implicit ADD CONSTRAINT implicit_b_positive CHECK (b > 0);

SELECT conname, contype
  FROM pg_constraint
 WHERE conrelid = 'implicit'::regclass
 ORDER BY conname;

DROP TABLE implicit;
DROP TABLE t;

RESET client_min_messages;
