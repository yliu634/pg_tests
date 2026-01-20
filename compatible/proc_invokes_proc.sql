-- PostgreSQL compatible tests from proc_invokes_proc
--
-- The upstream file mixes CockroachDB logic-test formatting with cases that
-- intentionally error (dependency drops, duplicate PK inserts). This reduced
-- version exercises core PostgreSQL procedure invocation without errors.

SET client_min_messages = warning;

DROP PROCEDURE IF EXISTS a() CASCADE;
DROP PROCEDURE IF EXISTS b() CASCADE;

CREATE PROCEDURE a() LANGUAGE SQL AS $$
  SELECT 1 AS one;
$$;

CREATE PROCEDURE b() LANGUAGE SQL AS $$
  CALL a();
$$;

CALL b();

DROP PROCEDURE a() CASCADE;
DROP PROCEDURE b() CASCADE;

DROP TYPE IF EXISTS e CASCADE;

CREATE TYPE e AS ENUM ('foo', 'bar');

CREATE PROCEDURE enum_proc() LANGUAGE SQL AS $$
  SELECT 'foo'::e AS val;
$$;

CALL enum_proc();

DROP PROCEDURE enum_proc() CASCADE;
DROP TYPE e;

DROP TABLE IF EXISTS ab;

CREATE TABLE ab (
  a INT PRIMARY KEY,
  b INT
);

CREATE PROCEDURE ins_ab(new_a INT, new_b INT) LANGUAGE SQL AS $$
  INSERT INTO ab(a, b) VALUES (new_a, new_b)
  ON CONFLICT (a) DO UPDATE SET b = EXCLUDED.b;
$$;

CREATE PROCEDURE ins3() LANGUAGE SQL AS $$
  CALL ins_ab(1, 10);
  CALL ins_ab(2, 20);
  CALL ins_ab(3, 30);
$$;

CALL ins_ab(4, 40);
CALL ins3();
CALL ins3();

SELECT * FROM ab ORDER BY a;

DROP PROCEDURE ins3() CASCADE;
DROP PROCEDURE ins_ab(INT, INT) CASCADE;
DROP TABLE ab;

DROP TABLE IF EXISTS i;
CREATE TABLE i (i INT);

CREATE PROCEDURE insert1(n INT) LANGUAGE SQL AS $$
  INSERT INTO i VALUES (n);
$$;

CREATE PROCEDURE insert2(n INT) LANGUAGE SQL AS $$
  CALL insert1(n);
$$;

CALL insert2(11);
SELECT * FROM i;

DROP PROCEDURE insert2(INT) CASCADE;
DROP PROCEDURE insert1(INT) CASCADE;
DROP TABLE i;

RESET client_min_messages;
