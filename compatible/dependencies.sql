-- PostgreSQL compatible tests from dependencies
-- NOTE: CockroachDB crdb_internal.* dependency introspection is not available in PostgreSQL.
-- This file is rewritten to create a small dependency graph and inspect it via PostgreSQL catalogs.

SET client_min_messages = warning;

DROP VIEW IF EXISTS test_v2;
DROP VIEW IF EXISTS test_v1;
DROP VIEW IF EXISTS moretest_v;
DROP TABLE IF EXISTS test_kvr3;
DROP TABLE IF EXISTS test_kvr2;
DROP TABLE IF EXISTS test_kvr1;
DROP TABLE IF EXISTS test_kvi2;
DROP TABLE IF EXISTS test_kvi1;
DROP TABLE IF EXISTS test_uwi_child;
DROP TABLE IF EXISTS test_uwi_parent;
DROP TABLE IF EXISTS test_kv;
DROP TABLE IF EXISTS moretest_t;
DROP TABLE IF EXISTS blog_posts;
DROP SEQUENCE IF EXISTS blog_posts_id_seq;

CREATE TABLE test_kv(k INT PRIMARY KEY, v INT, w NUMERIC);
CREATE UNIQUE INDEX test_v_idx ON test_kv(v);
CREATE INDEX test_v_idx2 ON test_kv(v DESC) INCLUDE (w);
CREATE INDEX test_v_idx3 ON test_kv(w) INCLUDE (v);

CREATE TABLE test_kvr1(k INT PRIMARY KEY REFERENCES test_kv(k));
CREATE TABLE test_kvr2(k INT, v INT UNIQUE, FOREIGN KEY (k) REFERENCES test_kv(k));
CREATE TABLE test_kvr3(k INT, v INT UNIQUE, FOREIGN KEY (v) REFERENCES test_kv(v));

CREATE TABLE test_kvi1(k INT PRIMARY KEY);
CREATE TABLE test_kvi2(k INT PRIMARY KEY, v INT);
CREATE UNIQUE INDEX test_kvi2_idx ON test_kvi2(v);

CREATE VIEW test_v1 AS SELECT v FROM test_kv;
CREATE VIEW test_v2 AS SELECT v FROM test_v1;

-- CockroachDB UNIQUE WITHOUT INDEX has no PG equivalent; use a regular UNIQUE constraint.
CREATE TABLE test_uwi_parent(a INT UNIQUE);
CREATE TABLE test_uwi_child(a INT REFERENCES test_uwi_parent(a));

CREATE TABLE moretest_t(k INT, v INT);
CREATE VIEW moretest_v AS SELECT v FROM moretest_t WHERE FALSE;

CREATE SEQUENCE blog_posts_id_seq;
CREATE TABLE blog_posts (id INT PRIMARY KEY DEFAULT nextval('blog_posts_id_seq'), title TEXT);

-- Column catalog.
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema = current_schema()
  AND (table_name LIKE 'test_%' OR table_name LIKE 'moretest_%' OR table_name = 'blog_posts')
ORDER BY table_name, ordinal_position;

-- Index catalog.
SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE schemaname = current_schema()
  AND (tablename LIKE 'test_%' OR tablename = 'blog_posts')
ORDER BY tablename, indexname;

-- View definitions.
SELECT schemaname, viewname, definition
FROM pg_views
WHERE schemaname = current_schema()
  AND (viewname LIKE 'test_%' OR viewname LIKE 'moretest_%')
ORDER BY viewname;

RESET client_min_messages;
