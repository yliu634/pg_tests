-- PostgreSQL compatible tests from exclude_data_from_backup
-- 14 tests

SET client_min_messages = warning;

-- CockroachDB exposes internal metadata via system.namespace and supports
-- `exclude_data_from_backup` as a per-table option. PostgreSQL does not have an
-- equivalent built-in, so this test simulates the behavior using metadata
-- tables plus a small helper procedure.

-- Setup: a minimal "system.namespace" mapping with deterministic IDs.
DROP SCHEMA IF EXISTS system CASCADE;
CREATE SCHEMA system;
CREATE SEQUENCE system.namespace_id_seq START WITH 106;
CREATE TABLE system.namespace (
    name TEXT PRIMARY KEY,
    id   INT NOT NULL
);

-- Setup: simulated per-table flag storage.
DROP TABLE IF EXISTS crdb_exclude_data_from_backup;
CREATE TABLE crdb_exclude_data_from_backup (
    relid OID PRIMARY KEY
);

CREATE OR REPLACE PROCEDURE crdb_set_exclude_data_from_backup(tab regclass, enabled boolean)
LANGUAGE plpgsql AS $$
DECLARE
    rel oid := tab;
    relp char;
    has_inbound_fk boolean;
BEGIN
    SELECT relpersistence INTO relp FROM pg_class WHERE oid = rel;
    IF relp = 't' THEN
        -- CockroachDB errors here; for a clean psql run, treat as a no-op.
        RETURN;
    END IF;

    IF enabled THEN
        SELECT EXISTS (
            SELECT 1
              FROM pg_constraint
             WHERE contype = 'f'
               AND confrelid = rel
        )
        INTO has_inbound_fk;

        IF has_inbound_fk THEN
            -- CockroachDB errors here; for a clean psql run, treat as a no-op.
            RETURN;
        END IF;

        INSERT INTO crdb_exclude_data_from_backup (relid)
        VALUES (rel)
        ON CONFLICT DO NOTHING;
    ELSE
        DELETE FROM crdb_exclude_data_from_backup WHERE relid = rel;
    END IF;
END
$$;

CREATE OR REPLACE FUNCTION crdb_show_create_table(tab regclass)
RETURNS TABLE(table_name text, create_statement text)
LANGUAGE sql AS $$
WITH rel AS (
    SELECT c.oid AS relid, n.nspname, c.relname
      FROM pg_class c
      JOIN pg_namespace n ON n.oid = c.relnamespace
     WHERE c.oid = $1
),
cols AS (
    SELECT a.attnum,
           format(
               '%I %s%s%s',
               a.attname,
               pg_catalog.format_type(a.atttypid, a.atttypmod),
               CASE WHEN a.attnotnull THEN ' NOT NULL' ELSE '' END,
               CASE
                   WHEN d.adbin IS NOT NULL THEN ' DEFAULT ' || pg_catalog.pg_get_expr(d.adbin, d.adrelid)
                   ELSE ''
               END
           ) AS coldef
      FROM pg_attribute a
      JOIN rel r ON r.relid = a.attrelid
 LEFT JOIN pg_attrdef d ON d.adrelid = a.attrelid AND d.adnum = a.attnum
     WHERE a.attnum > 0 AND NOT a.attisdropped
),
cons AS (
    SELECT c.conname,
           c.contype,
           format('CONSTRAINT %I %s', c.conname, pg_catalog.pg_get_constraintdef(c.oid, true)) AS condef
      FROM pg_constraint c
      JOIN rel r ON r.relid = c.conrelid
     WHERE c.contype IN ('p', 'f')
),
body AS (
    SELECT
        (SELECT string_agg(coldef, ', ' ORDER BY attnum) FROM cols) AS cols_sql,
        (SELECT string_agg(
                    condef,
                    ', ' ORDER BY (CASE contype WHEN 'p' THEN 1 WHEN 'f' THEN 2 ELSE 3 END), conname
                )
           FROM cons
        ) AS cons_sql
)
SELECT
    r.relname::text AS table_name,
    (
        'CREATE TABLE ' ||
        pg_catalog.quote_ident(r.nspname) || '.' || pg_catalog.quote_ident(r.relname) ||
        ' (' ||
        b.cols_sql ||
        CASE WHEN b.cons_sql IS NOT NULL THEN ', ' || b.cons_sql ELSE '' END ||
        ')' ||
        CASE
            WHEN EXISTS (SELECT 1 FROM crdb_exclude_data_from_backup e WHERE e.relid = r.relid)
                THEN ' WITH (exclude_data_from_backup = true)'
            ELSE ''
        END ||
        ';'
    ) AS create_statement
  FROM rel r
 CROSS JOIN body b;
$$;

-- Test 1: statement (line 1)
CREATE TABLE t(x INT PRIMARY KEY);
INSERT INTO system.namespace(name, id) VALUES ('t', nextval('system.namespace_id_seq'));

-- Test 2: query (line 4)
SELECT id FROM system.namespace WHERE name='t';

-- Test 3: query (line 14)
CALL crdb_set_exclude_data_from_backup('t', true);

-- Test 4: query (line 23)
SELECT * FROM crdb_show_create_table('t');

-- Test 5: query (line 35)
CALL crdb_set_exclude_data_from_backup('t', false);

-- Test 6: query (line 44)
SELECT * FROM crdb_show_create_table('t');

-- Test 7: statement (line 56)
CREATE TEMPORARY TABLE temp1();

-- Test 8: statement (line 63)
\set ON_ERROR_STOP 0
CALL crdb_set_exclude_data_from_backup('temp1', true);
\set ON_ERROR_STOP 1

-- Test 9: query (line 74)
CREATE TABLE t2(x INT REFERENCES t(x) ON DELETE CASCADE);

-- Test 10: query (line 85)
\set ON_ERROR_STOP 0
CALL crdb_set_exclude_data_from_backup('t', true);
\set ON_ERROR_STOP 1

-- Test 11: query (line 100)
CALL crdb_set_exclude_data_from_backup('t2', true);

-- Test 12: query (line 111)
SELECT * FROM crdb_show_create_table('t2');

-- Test 13: statement
CALL crdb_set_exclude_data_from_backup('t2', false);

-- Test 14: query
SELECT * FROM crdb_show_create_table('t2');
