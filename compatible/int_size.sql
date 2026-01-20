-- PostgreSQL compatible tests from int_size
--
-- CockroachDB exposes default_int_size and serial_normalization settings.
-- PostgreSQL uses fixed integer types (smallint/int/bigint) and serial helpers.

SET client_min_messages = warning;

DROP TABLE IF EXISTS int_sizes;

CREATE TABLE int_sizes (
  i2 SMALLINT,
  i4 INT,
  i8 BIGINT,
  s SERIAL,
  bs BIGSERIAL
);

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'int_sizes'
ORDER BY ordinal_position;

INSERT INTO int_sizes(i2, i4, i8) VALUES (1, 2, 3), (10, 20, 30);
SELECT i2, i4, i8, s, bs FROM int_sizes ORDER BY i4;

DROP TABLE int_sizes;

RESET client_min_messages;
