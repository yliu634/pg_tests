-- PostgreSQL compatible tests from drop_owned_by
--
-- CockroachDB's logic-test directives (user switching, SHOW TABLES, etc.) are
-- not supported when running directly via psql. This file focuses on the
-- PostgreSQL feature being tested: DROP OWNED BY.

SET client_min_messages = warning;
DROP VIEW IF EXISTS drop_owned_by_v;
DROP TABLE IF EXISTS drop_owned_by_t;
DROP SEQUENCE IF EXISTS drop_owned_by_seq;
DROP TYPE IF EXISTS drop_owned_by_enum;
DROP FUNCTION IF EXISTS drop_owned_by_f();
DROP ROLE IF EXISTS drop_owned_by_u1;
DROP ROLE IF EXISTS drop_owned_by_u2;
RESET client_min_messages;

CREATE ROLE drop_owned_by_u1 LOGIN;
CREATE ROLE drop_owned_by_u2 LOGIN;
GRANT USAGE, CREATE ON SCHEMA public TO drop_owned_by_u1;

-- Create objects owned by drop_owned_by_u1.
SET ROLE drop_owned_by_u1;
CREATE TABLE drop_owned_by_t(a INT);
CREATE VIEW drop_owned_by_v AS SELECT a FROM drop_owned_by_t;
CREATE SEQUENCE drop_owned_by_seq;
CREATE TYPE drop_owned_by_enum AS ENUM ('a', 'b');
CREATE FUNCTION drop_owned_by_f() RETURNS INT LANGUAGE SQL AS $$ SELECT 1 $$;
RESET ROLE;

-- Verify objects exist.
SELECT relkind, relname
FROM pg_class
WHERE relname IN ('drop_owned_by_t', 'drop_owned_by_v', 'drop_owned_by_seq')
ORDER BY relkind, relname;

SELECT typname
FROM pg_type
WHERE typname = 'drop_owned_by_enum';

SELECT proname
FROM pg_proc
WHERE proname = 'drop_owned_by_f';

-- Drop everything owned by drop_owned_by_u1.
DROP OWNED BY drop_owned_by_u1 CASCADE;

-- Verify objects are gone.
SELECT relkind, relname
FROM pg_class
WHERE relname IN ('drop_owned_by_t', 'drop_owned_by_v', 'drop_owned_by_seq')
ORDER BY relkind, relname;

SELECT typname
FROM pg_type
WHERE typname = 'drop_owned_by_enum';

SELECT proname
FROM pg_proc
WHERE proname = 'drop_owned_by_f';

-- Clean up roles.
DROP ROLE drop_owned_by_u1;
DROP ROLE drop_owned_by_u2;
