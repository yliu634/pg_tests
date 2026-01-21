-- PostgreSQL compatible tests from sequences
--
-- NOTE: This file is adapted from CockroachDB's sequences logic tests, but
-- rewritten as a plain psql script.
--
-- CockroachDB-only features such as:
--   - CLUSTER SETTING / SET DATABASE / USE
--   - SHOW CREATE SEQUENCE / crdb_internal.*
--   - KV trace directives and schema-changer config gates
-- do not have direct PostgreSQL equivalents and are omitted here.
--
-- This PG adaptation focuses on:
--   - nextval / currval / lastval behavior
--   - sequence options (increment, min/max, cycle)
--   - setval and is_called semantics
--   - schema-qualified sequences (schemas in place of CRDB databases)
--   - sequences used in DEFAULT expressions
--   - OWNED BY metadata via pg_depend

SET client_min_messages = warning;

-- Schema used for most objects (mimics the CRDB "test" database).
CREATE SCHEMA IF NOT EXISTS test;
SET search_path TO test;

-- Basic nextval/lastval/currval behavior.
DROP SEQUENCE IF EXISTS lastval_test;
DROP SEQUENCE IF EXISTS lastval_test_2;

CREATE SEQUENCE lastval_test;
CREATE SEQUENCE lastval_test_2 START WITH 10;

SELECT nextval('lastval_test');
SELECT lastval();
SELECT nextval('lastval_test_2');
SELECT lastval();
SELECT nextval('lastval_test');
SELECT lastval();
SELECT currval('lastval_test');

-- regclass-by-oid via psql vars (avoid printing OIDs).
SELECT 'lastval_test'::regclass::oid AS lastval_test_id,
       'lastval_test_2'::regclass::oid AS lastval_test_2_id \gset
SELECT nextval(:lastval_test_id::regclass);
SELECT nextval(:lastval_test_2_id::regclass);

-- Sequence options + pg_sequence_parameters.
DROP SEQUENCE IF EXISTS bar;
CREATE SEQUENCE bar INCREMENT BY 5;
SELECT nextval('bar');
SELECT nextval('bar');
SELECT pg_sequence_parameters('bar'::regclass::oid);

DROP SEQUENCE IF EXISTS baz;
CREATE SEQUENCE baz START WITH 2 INCREMENT BY 5;
SELECT nextval('baz');
SELECT nextval('baz');
SELECT 'baz'::regclass::oid AS baz_id \gset
SELECT nextval(:baz_id::regclass);
SELECT pg_sequence_parameters('baz'::regclass::oid);

DROP SEQUENCE IF EXISTS down_test;
CREATE SEQUENCE down_test INCREMENT BY -1 START WITH -5;
SELECT nextval('down_test');
SELECT nextval('down_test');
SELECT 'down_test'::regclass::oid AS down_test_id \gset
SELECT nextval(:down_test_id::regclass);
SELECT pg_sequence_parameters('down_test'::regclass::oid);

-- MIN/MAX and CYCLE.
DROP SEQUENCE IF EXISTS limit_test;
CREATE SEQUENCE limit_test MAXVALUE 12 START WITH 9;
SELECT nextval('limit_test');
SELECT nextval('limit_test');
SELECT nextval('limit_test');
SELECT 'limit_test'::regclass::oid AS limit_test_id \gset
SELECT nextval(:limit_test_id::regclass);
SELECT currval('limit_test');

DROP SEQUENCE IF EXISTS cycle_test;
CREATE SEQUENCE cycle_test MAXVALUE 3 CYCLE;
SELECT nextval('cycle_test');
SELECT nextval('cycle_test');
SELECT nextval('cycle_test');
SELECT nextval('cycle_test');

-- setval and is_called semantics.
DROP SEQUENCE IF EXISTS setval_test;
CREATE SEQUENCE setval_test;
SELECT nextval('setval_test');
SELECT nextval('setval_test');
SELECT setval('setval_test', 10, false);
SELECT currval('setval_test');
SELECT lastval();
SELECT nextval('setval_test');
SELECT currval('setval_test');
SELECT lastval();

SELECT 'setval_test'::regclass::oid AS setval_test_id \gset
SELECT setval(:setval_test_id::regclass, 20, true);
SELECT currval(:setval_test_id::regclass);
SELECT lastval();
SELECT nextval(:setval_test_id::regclass);

-- A sequence name with non-ASCII characters.
DROP SEQUENCE IF EXISTS spécial;
CREATE SEQUENCE spécial;
SELECT nextval('spécial');

-- Sequences in other schemas (CRDB cross-db adapted to schemas).
CREATE SCHEMA IF NOT EXISTS other_schema;
DROP SEQUENCE IF EXISTS other_schema.seq;
CREATE SEQUENCE other_schema.seq;
SELECT nextval('other_schema.seq');

CREATE SCHEMA IF NOT EXISTS foo;
DROP SEQUENCE IF EXISTS foo.x;
CREATE SEQUENCE foo.x;
SELECT nextval('foo.x');

-- List the sequences we created (avoid system schemas).
SELECT schemaname,
       sequencename,
       start_value,
       increment_by,
       min_value,
       max_value,
       cycle
FROM pg_sequences
WHERE schemaname IN ('test', 'other_schema', 'foo')
ORDER BY schemaname, sequencename;

-- Sequences used by DEFAULTs; nextval is not rolled back.
DROP TABLE IF EXISTS blog_posts;
DROP SEQUENCE IF EXISTS blog_posts_id_seq;

CREATE SEQUENCE blog_posts_id_seq;
CREATE TABLE blog_posts (
  id INT PRIMARY KEY DEFAULT nextval('blog_posts_id_seq'),
  title TEXT
);

INSERT INTO blog_posts (title) VALUES ('foo');
INSERT INTO blog_posts (title) VALUES ('bar');
SELECT id, title FROM blog_posts ORDER BY id;

BEGIN;
INSERT INTO blog_posts (title) VALUES ('txn_rolled_back');
ROLLBACK;

SELECT last_value, is_called FROM blog_posts_id_seq;

-- OWNED BY dependency metadata.
DROP TABLE IF EXISTS owner;
DROP SEQUENCE IF EXISTS owned_seq;

CREATE TABLE owner(owner_col INT);
CREATE SEQUENCE owned_seq OWNED BY owner.owner_col;

SELECT seqclass.relname AS sequence_name,
       depclass.relname AS table_name,
       attrib.attname   AS column_name
FROM pg_class AS seqclass
JOIN pg_depend AS dep ON seqclass.oid = dep.objid
JOIN pg_class AS depclass ON dep.refobjid = depclass.oid
JOIN pg_attribute AS attrib
  ON attrib.attnum = dep.refobjsubid
 AND attrib.attrelid = dep.refobjid
WHERE seqclass.relkind = 'S'
  AND seqclass.relname = 'owned_seq';

ALTER SEQUENCE owned_seq OWNED BY NONE;

SELECT count(*) AS owned_by_deps_after_none
FROM pg_depend d
JOIN pg_class c ON c.oid = d.objid
WHERE c.relkind = 'S'
  AND c.relname = 'owned_seq';

DROP TABLE owner;
DROP SEQUENCE owned_seq;

RESET search_path;
RESET client_min_messages;
