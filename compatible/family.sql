-- PostgreSQL compatible tests from family
--
-- CockroachDB supports column families (FAMILY ...) and table@index access.
-- PostgreSQL does not. This file validates that the core DML works without
-- families, and uses standard indexes and UPSERT syntax.

SET client_min_messages = warning;
DROP TABLE IF EXISTS abcd;
RESET client_min_messages;

CREATE TABLE abcd (
  a INT PRIMARY KEY,
  b INT,
  c INT,
  d INT
);

CREATE INDEX d_idx ON abcd(d);

INSERT INTO abcd VALUES (1, 2, 3, 4), (5, 6, 7, 8);
SELECT * FROM abcd ORDER BY a;

SELECT c FROM abcd WHERE a = 1;
SELECT count(*) FROM abcd;
SELECT count(*) FROM abcd;

UPDATE abcd SET b = 9, d = 10, c = NULL WHERE c = 7;
SELECT * FROM abcd ORDER BY a;

DELETE FROM abcd WHERE c = 3;
SELECT * FROM abcd ORDER BY a;

-- UPSERT -> INSERT .. ON CONFLICT.
INSERT INTO abcd (a, b, c, d) VALUES (1, 2, 3, 4), (5, 6, 7, 8)
ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b, c = EXCLUDED.c, d = EXCLUDED.d;
SELECT * FROM abcd ORDER BY a;

UPDATE abcd SET b = NULL, c = NULL, d = NULL WHERE a = 1;
SELECT * FROM abcd WHERE a = 1;

INSERT INTO abcd (a) VALUES (2);
SELECT * FROM abcd WHERE a = 2;
UPDATE abcd SET d = 5 WHERE a = 2;
SELECT * FROM abcd WHERE a = 2;
DELETE FROM abcd WHERE a = 2;
SELECT * FROM abcd WHERE a = 2;

ALTER TABLE abcd ADD COLUMN f DECIMAL;
ALTER TABLE abcd ADD COLUMN g INT;
ALTER TABLE abcd ADD COLUMN h INT;
ALTER TABLE abcd ADD COLUMN i INT;
ALTER TABLE abcd ADD COLUMN j INT;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'abcd'
ORDER BY ordinal_position;

