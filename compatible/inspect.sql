-- PostgreSQL compatible tests from inspect
--
-- CockroachDB's INSPECT command is not available in PostgreSQL. This file keeps
-- a small deterministic catalog sanity check using pg_indexes.

SET client_min_messages = warning;

DROP TABLE IF EXISTS inspect_foo;
DROP TABLE IF EXISTS inspect_bar;

CREATE TABLE inspect_foo (c1 INT, c2 INT);
CREATE INDEX inspect_foo_c1_idx ON inspect_foo (c1);
CREATE INDEX inspect_foo_c2_idx ON inspect_foo (c2);

CREATE TABLE inspect_bar (c1 INT, c3 INT);
CREATE INDEX inspect_bar_c1_idx ON inspect_bar (c1);
CREATE INDEX inspect_bar_c3_idx ON inspect_bar (c3);

SELECT count(*)
FROM pg_indexes
WHERE schemaname = 'public' AND tablename = 'inspect_foo';

SELECT count(*)
FROM pg_indexes
WHERE schemaname = 'public' AND tablename IN ('inspect_foo', 'inspect_bar');

DROP TABLE inspect_foo;
DROP TABLE inspect_bar;

RESET client_min_messages;
