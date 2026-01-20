-- PostgreSQL compatible tests from alter_sequence
-- NOTE: CockroachDB-specific features like PER SESSION CACHE and SHOW CREATE SEQUENCE
-- are replaced with PostgreSQL equivalents (ALTER SEQUENCE and pg_sequences).

SET client_min_messages = warning;

-- Cleanup from prior runs.
DROP SEQUENCE IF EXISTS foo;
DROP SEQUENCE IF EXISTS restart_seq;
DROP SEQUENCE IF EXISTS minmax_seq;

-- Test 1: Basic ALTER SEQUENCE.
CREATE SEQUENCE foo START WITH 1 INCREMENT BY 1 CACHE 1;
SELECT nextval('foo');
SELECT nextval('foo');

ALTER SEQUENCE foo INCREMENT BY 5;
SELECT nextval('foo');

ALTER SEQUENCE foo CACHE 100;
SELECT sequencename, start_value, min_value, max_value, increment_by, cache_size, cycle
FROM pg_sequences
WHERE schemaname = 'public' AND sequencename = 'foo';

-- Test 2: RESTART.
CREATE SEQUENCE restart_seq START WITH 5 INCREMENT BY 1;
SELECT nextval('restart_seq');
ALTER SEQUENCE restart_seq RESTART WITH 1;
SELECT nextval('restart_seq');
ALTER SEQUENCE restart_seq RESTART;
SELECT nextval('restart_seq');

-- Test 3: MINVALUE / MAXVALUE and removing bounds.
CREATE SEQUENCE minmax_seq START WITH 1 INCREMENT BY 3 MINVALUE 1 MAXVALUE 100;
SELECT nextval('minmax_seq'), nextval('minmax_seq');
ALTER SEQUENCE minmax_seq NO MINVALUE NO MAXVALUE;
SELECT sequencename, start_value, min_value, max_value, increment_by, cache_size, cycle
FROM pg_sequences
WHERE schemaname = 'public' AND sequencename = 'minmax_seq';

-- Cleanup.
DROP SEQUENCE IF EXISTS foo;
DROP SEQUENCE IF EXISTS restart_seq;
DROP SEQUENCE IF EXISTS minmax_seq;

RESET client_min_messages;
