-- PostgreSQL compatible tests from drop_view
--
-- CockroachDB includes SHOW TABLES, SET DATABASE, and user switching directives
-- that don't run under plain psql. This file exercises CREATE VIEW / DROP VIEW
-- dependency behavior using PG-native catalogs.

SET client_min_messages = warning;
DROP VIEW IF EXISTS drop_view_y;
DROP VIEW IF EXISTS drop_view_x;
DROP VIEW IF EXISTS drop_view_c;
DROP VIEW IF EXISTS drop_view_b;
DROP TABLE IF EXISTS drop_view_a;
RESET client_min_messages;

CREATE TABLE drop_view_a(k TEXT, v TEXT);
INSERT INTO drop_view_a VALUES ('a', '1'), ('b', '2'), ('c', '3');

CREATE VIEW drop_view_b AS SELECT k, v FROM drop_view_a;
CREATE VIEW drop_view_c AS SELECT k, v FROM drop_view_b;

SELECT viewname
FROM pg_views
WHERE schemaname = 'public' AND viewname LIKE 'drop_view_%'
ORDER BY viewname;

-- Dropping a view with dependents requires CASCADE.
DROP VIEW drop_view_b CASCADE;

SELECT viewname
FROM pg_views
WHERE schemaname = 'public' AND viewname LIKE 'drop_view_%'
ORDER BY viewname;

-- Views built from VALUES.
CREATE VIEW drop_view_x AS VALUES (1, 2), (3, 4);
CREATE VIEW drop_view_y AS SELECT column1, column2 FROM drop_view_x;

SELECT viewname
FROM pg_views
WHERE schemaname = 'public' AND viewname LIKE 'drop_view_%'
ORDER BY viewname;

DROP VIEW drop_view_x CASCADE;

SELECT viewname
FROM pg_views
WHERE schemaname = 'public' AND viewname LIKE 'drop_view_%'
ORDER BY viewname;

DROP TABLE drop_view_a;

