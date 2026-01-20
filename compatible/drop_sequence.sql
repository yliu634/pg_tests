-- PostgreSQL compatible tests from drop_sequence
--
-- CockroachDB cluster settings, cross-database sequences, and SHOW CREATE TABLE
-- directives do not map cleanly to PG. This file exercises basic sequence
-- creation, ownership, and DROP SEQUENCE behavior.

SET client_min_messages = warning;
DROP VIEW IF EXISTS v_seq;
DROP TABLE IF EXISTS t_seq;
DROP SEQUENCE IF EXISTS s_seq;
DROP SEQUENCE IF EXISTS s_owned;
RESET client_min_messages;

-- Basic create/use/drop.
CREATE SEQUENCE s_seq;
SELECT nextval('s_seq');
DROP SEQUENCE s_seq;

-- Sequence used as a column default + OWNED BY.
CREATE SEQUENCE s_owned;
CREATE TABLE t_seq(i INT DEFAULT nextval('s_owned'));
ALTER SEQUENCE s_owned OWNED BY t_seq.i;

SELECT column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 't_seq' AND column_name = 'i';

INSERT INTO t_seq VALUES (DEFAULT);
SELECT * FROM t_seq;

-- Dropping the table should drop the owned sequence as well.
DROP TABLE t_seq;
SELECT to_regclass('s_owned') AS owned_seq_after_drop;

-- Sequence used by a view.
CREATE SEQUENCE s_seq;
CREATE VIEW v_seq AS SELECT nextval('s_seq') AS n;
SELECT * FROM v_seq;
DROP SEQUENCE s_seq CASCADE;
SELECT to_regclass('v_seq') AS view_after_drop;

