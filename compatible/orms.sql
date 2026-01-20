SET client_min_messages = warning;

-- PostgreSQL compatible tests from orms
-- 29 tests

-- Test 1: query (line 12)
SELECT a.attname, format_type(a.atttypid, a.atttypmod), pg_get_expr(d.adbin, d.adrelid), a.attnotnull, a.atttypid, a.atttypmod
    FROM pg_attribute a
    LEFT JOIN pg_attrdef d
    ON a.attrelid = d.adrelid
    AND a.attnum = d.adnum
    WHERE a.attrelid = 'a'::regclass
    AND a.attnum > 0 AND NOT a.attisdropped
    ORDER BY a.attnum

-- Test 2: query (line 29)
SELECT t.typname enum_name, array_agg(e.enumlabel ORDER BY enumsortorder) enum_value
    FROM pg_type t
    JOIN pg_enum e ON t.oid = e.enumtypid
    JOIN pg_catalog.pg_namespace n ON n.oid = t.typnamespace
    WHERE n.nspname = 'public'
    GROUP BY 1

-- Test 3: statement (line 47)
INSERT INTO customers VALUES ('jordan', 12), ('cuong', 13);

-- Test 4: query (line 50)
SELECT i.relname AS name,
       ix.indisprimary AS PRIMARY,
       ix.indisunique AS UNIQUE,
       ix.indkey AS indkey,
       array_agg(a.attnum) AS column_indexes,
       array_agg(a.attname) AS column_names,
       pg_get_indexdef(ix.indexrelid) AS definition
FROM pg_class t,
     pg_class i,
     pg_index ix,
     pg_attribute a
WHERE t.oid = ix.indrelid
AND   i.oid = ix.indexrelid
AND   a.attrelid = t.oid
AND   t.relkind = 'r'
AND   t.relname = 'customers' -- this query is run once for each table
GROUP BY i.relname,
         ix.indexrelid,
         ix.indisprimary,
         ix.indisunique,
         ix.indkey
ORDER BY i.relname

-- Test 5: query (line 79)
SELECT a.attname, format_type(a.atttypid, a.atttypmod) AS data_type
FROM   pg_index i
JOIN   pg_attribute a ON a.attrelid = i.indrelid
                     AND a.attnum = ANY(i.indkey)
                     WHERE  i.indrelid = '"a"'::regclass
                     AND    i.indisprimary

-- Test 6: statement (line 90)
DROP TABLE IF EXISTS b CASCADE;
CREATE TABLE b (id INT, a_id INT, FOREIGN KEY (a_id) REFERENCES a (id));

-- Test 7: query (line 95)
SELECT t2.oid::regclass::text AS to_table, a1.attname AS column, a2.attname AS primary_key, c.conname AS name, c.confupdtype AS on_update, c.confdeltype AS on_delete
FROM pg_constraint c
JOIN pg_class t1 ON c.conrelid = t1.oid
JOIN pg_class t2 ON c.confrelid = t2.oid
JOIN pg_attribute a1 ON a1.attnum = c.conkey[1] AND a1.attrelid = t1.oid
JOIN pg_attribute a2 ON a2.attnum = c.confkey[1] AND a2.attrelid = t2.oid
JOIN pg_namespace t3 ON c.connamespace = t3.oid
WHERE c.contype = 'f'
AND t1.relname ='b'
AND t3.nspname = ANY (current_schemas(false))
ORDER BY c.conname

-- Test 8: query (line 111)
SELECT 'decimal(18,2)'::regtype::oid;

-- Test 9: query (line 119)
SELECT 'character varying'::regtype::oid;

-- Test 10: statement (line 124)
CREATE INDEX b_idx ON b(a_id);

-- Test 11: query (line 129)
SELECT count(*)
FROM pg_class t
INNER JOIN pg_index d ON t.oid = d.indrelid
INNER JOIN pg_class i ON d.indexrelid = i.oid
WHERE i.relkind = 'i'
AND i.relname = 'b_idx'
AND t.relname = 'b'
AND i.relnamespace IN (SELECT oid FROM pg_namespace WHERE nspname = ANY (current_schemas(false)));

-- Test 12: statement (line 141)
DROP TABLE IF EXISTS c CASCADE;
CREATE TABLE c (a INT, b INT, PRIMARY KEY (a, b));

-- Test 13: query (line 145)
SELECT;
    a.attname
FROM
    (
        SELECT;
            indrelid, indkey, generate_subscripts(indkey, 1) AS idx
        FROM
            pg_index
        WHERE
            indrelid = '"c"'::REGCLASS AND indisprimary
    )
        AS i
    JOIN pg_attribute AS a ON
            a.attrelid = i.indrelid AND a.attnum = i.indkey[i.idx]
ORDER BY
    i.idx

-- Test 14: statement (line 166)
DROP TABLE IF EXISTS metatest CASCADE;
CREATE TABLE metatest (a INT PRIMARY KEY);

-- Test 15: query (line 170)
SELECT a.attname,
  format_type(a.atttypid, a.atttypmod),
  pg_get_expr(d.adbin, d.adrelid),
  a.attnotnull,
  a.atttypid,
  a.atttypmod,
  (SELECT c.collname
   FROM pg_collation c, pg_type t
   WHERE c.oid = a.attcollation
   AND t.oid = a.atttypid
   AND a.attcollation <> t.typcollation),
   col_description(a.attrelid, a.attnum) AS comment
FROM pg_attribute a LEFT JOIN pg_attrdef d
ON a.attrelid = d.adrelid AND a.attnum = d.adnum
WHERE a.attrelid = '"metatest"'::regclass
AND a.attnum > 0 AND NOT a.attisdropped
ORDER BY a.attnum

-- Test 16: query (line 193)
SELECT;
    attname AS name,
    attrelid AS tid,
    COALESCE(
        (
            SELECT;
                attnum = ANY conkey
            FROM
                pg_constraint
            WHERE
                contype = 'p' AND conrelid = attrelid
        ),
        false
    )
        AS primarykey,
    NOT (attnotnull) AS allownull,
    (
        SELECT;
            seq.oid
        FROM
            pg_class AS seq
            LEFT JOIN pg_depend AS dep
            ON seq.oid = dep.objid
        WHERE
            (
                seq.relkind = 'S'::CHAR
                AND dep.refobjsubid = attnum
            )
            AND dep.refobjid = attrelid
    )
    IS NOT NULL
        AS autoincrement
FROM
    pg_attribute
WHERE
    (
        attisdropped = false
        AND attrelid
            = (
                    SELECT;
                        tbl.oid
                    FROM
                        pg_class AS tbl
                        LEFT JOIN pg_namespace AS sch
                        ON tbl.relnamespace = sch.oid
                    WHERE
                        (
                            tbl.relkind = 'r'::"char"
                            AND tbl.relname = 'metatest'
                        )
                        AND sch.nspname = 'public'
                )
    )
    AND attname = 'a';

-- Test 17: query (line 253)
SELECT * FROM (SELECT n.nspname, c.relname, a.attname, a.atttypid, a.attnotnull OR ((t.typtype = 'd') AND t.typnotnull) AS attnotnull, a.atttypmod, a.attlen, row_number() OVER (PARTITION BY a.attrelid ORDER BY a.attnum) AS attnum, pg_get_expr(def.adbin, def.adrelid) AS adsrc, dsc.description, t.typbasetype, t.typtype FROM pg_catalog.pg_namespace AS n JOIN pg_catalog.pg_class AS c ON (c.relnamespace = n.oid) JOIN pg_catalog.pg_attribute AS a ON (a.attrelid = c.oid) JOIN pg_catalog.pg_type AS t ON (a.atttypid = t.oid) LEFT JOIN pg_catalog.pg_attrdef AS def ON ((a.attrelid = def.adrelid) AND (a.attnum = def.adnum)) LEFT JOIN pg_catalog.pg_description AS dsc ON ((c.oid = dsc.objoid) AND (a.attnum = dsc.objsubid)) LEFT JOIN pg_catalog.pg_class AS dc ON ((dc.oid = dsc.classoid) AND (dc.relname = 'pg_class')) LEFT JOIN pg_catalog.pg_namespace AS dn ON ((dc.relnamespace = dn.oid) AND (dn.nspname = 'pg_catalog')) WHERE (((c.relkind IN ('r', 'v', 'f', 'm')) AND (a.attnum > 0)) AND (NOT a.attisdropped)) AND (n.nspname LIKE 'public')) AS c;

-- Test 18: statement (line 270)
SELECT;
	array_agg(t_pk.table_name ORDER BY t_pk.table_name)
FROM
	information_schema.statistics AS i
	LEFT JOIN (
			SELECT;
				array_agg(c.column_name) AS table_primary_key_columns,
				c.table_name
			FROM
				information_schema.columns AS c
			GROUP BY
				c.table_name
		)
			AS t_pk ON i.table_name = t_pk.table_name
GROUP BY
	t_pk.table_primary_key_columns

-- Test 19: query (line 289)
SELECT;
  s_p.nspname AS parentschema,
  t_p.relname AS parenttable,
  unnest(
    (
      SELECT;
        array_agg(attname ORDER BY i)
      FROM
        (
          SELECT;
            unnest(confkey) AS attnum,
            generate_subscripts(confkey, 1) AS i
        )
          AS x
        JOIN pg_catalog.pg_attribute AS c USING (attnum)
      WHERE
        c.attrelid = fk.confrelid
    )
  )
    AS parentcolumn,
  s_c.nspname AS childschema,
  t_c.relname AS childtable,
  unnest(
    (
      SELECT;
        array_agg(attname ORDER BY i)
      FROM
        (
          SELECT;
            unnest(conkey) AS attnum,
            generate_subscripts(conkey, 1) AS i
        )
          AS x
        JOIN pg_catalog.pg_attribute AS c USING (attnum)
      WHERE
        c.attrelid = fk.conrelid
    )
  )
    AS childcolumn
FROM
  pg_catalog.pg_constraint AS fk
  JOIN pg_catalog.pg_class AS t_p ON t_p.oid = fk.confrelid
  JOIN pg_catalog.pg_namespace AS s_p ON
      s_p.oid = t_p.relnamespace
  JOIN pg_catalog.pg_class AS t_c ON t_c.oid = fk.conrelid
  JOIN pg_catalog.pg_namespace AS s_c ON
      s_c.oid = t_c.relnamespace
WHERE
  fk.contype = 'f';

-- Test 20: statement (line 344)
DROP TABLE IF EXISTS regression_66576 CASCADE;
CREATE TABLE regression_66576 ();

-- Test 21: query (line 347)
SELECT;
  typname,
  typnamespace,
  typtype,
  typcategory,
  typnotnull,
  typelem,
  typlen,
  typbasetype,
  typtypmod,
  typdefaultbin
FROM pg_type WHERE typname = 'regression_66576'

-- Test 22: query (line 363)
SELECT reltype FROM pg_class WHERE relname = 'regression_65576';

-- Test 23: query (line 370)
SELECT typname FROM pg_type WHERE oid = $oid;

-- Test 24: query (line 378)
SELECT relname FROM pg_class WHERE oid = $oid;

-- Test 25: statement (line 386)
DROP TABLE IF EXISTS dst CASCADE;
CREATE TABLE dst (a int primary key, b int);

-- Test 26: statement (line 389)
DROP TABLE IF EXISTS src CASCADE;
create table src (c int primary key, d int references dst(a));

-- Test 27: query (line 392)
WITH
pks_uniques_cols AS (
  SELECT;
    connamespace,
    conrelid,
    jsonb_agg(column_info.cols) as cols
  FROM pg_constraint
  JOIN lateral (
    SELECT array_agg(cols.attname order by cols.attnum) as cols
    FROM ( select unnest(conkey) as col) _
    JOIN pg_attribute cols on cols.attrelid = conrelid and cols.attnum = col
  ) column_info ON TRUE
  WHERE
    contype IN ('p', 'u') and
    connamespace::regnamespace::text <> 'pg_catalog'
  GROUP BY connamespace, conrelid
)
SELECT;
  ns1.nspname AS table_schema,
  tab.relname AS table_name,
  ns2.nspname AS foreign_table_schema,
  other.relname AS foreign_table_name,
  (ns1.nspname, tab.relname) = (ns2.nspname, other.relname) AS is_self,
  traint.conname  AS constraint_name,
  column_info.cols_and_fcols,
  (column_info.cols IN (SELECT * FROM jsonb_array_elements(pks_uqs.cols))) AS one_to_one
FROM pg_constraint traint
JOIN LATERAL (
  SELECT;
    array_agg(row(cols.attname, refs.attname) order by ord) AS cols_and_fcols,
    jsonb_agg(cols.attname order by ord) AS cols
  FROM unnest(traint.conkey, traint.confkey) WITH ORDINALITY AS _(col, ref, ord)
  JOIN pg_attribute cols ON cols.attrelid = traint.conrelid AND cols.attnum = col
  JOIN pg_attribute refs ON refs.attrelid = traint.confrelid AND refs.attnum = ref
) AS column_info ON TRUE
JOIN pg_namespace ns1 ON ns1.oid = traint.connamespace
JOIN pg_class tab ON tab.oid = traint.conrelid
JOIN pg_class other ON other.oid = traint.confrelid
JOIN pg_namespace ns2 ON ns2.oid = other.relnamespace
LEFT JOIN pks_uniques_cols pks_uqs ON pks_uqs.connamespace = traint.connamespace AND pks_uqs.conrelid = traint.conrelid
WHERE traint.contype = 'f'
and traint.conparentid = 0 ORDER BY traint.conrelid, traint.conname

-- Test 28: statement (line 442)
DROP TABLE IF EXISTS efcore_identity_test CASCADE;
CREATE TABLE efcore_identity_test (;
  id INT8 NOT NULL GENERATED BY DEFAULT AS IDENTITY,
  CONSTRAINT pk_testtable PRIMARY KEY (id ASC)
);

-- Test 29: query (line 448)
SELECT;
  nspname,
  cls.relname,
  typ.typname,
  basetyp.typname AS basetypname,
  attname,
  description,
  collname,
  attisdropped,
  attidentity::TEXT,
  attgenerated::TEXT,
  ''::text as attcompression,
  format_type(typ.oid, atttypmod) AS formatted_typname,
  format_type(basetyp.oid, typ.typtypmod) AS formatted_basetypname,
  CASE
    WHEN pg_proc.proname = 'array_recv' THEN 'a'
    ELSE typ.typtype
  END AS typtype,
  CASE WHEN pg_proc.proname='array_recv' THEN elemtyp.typname END AS elemtypname,
  NOT (attnotnull OR typ.typnotnull) AS nullable,
  CASE
    WHEN atthasdef THEN (SELECT pg_get_expr(adbin, cls.oid) FROM pg_attrdef WHERE adrelid = cls.oid AND adnum = attr.attnum)
  END AS default,
  -- Sequence options for identity columns
  format_type(seqtypid, 0) AS seqtype, seqstart, seqmin, seqmax, seqincrement, seqcycle, seqcache
FROM pg_class AS cls
JOIN pg_namespace AS ns ON ns.oid = cls.relnamespace
LEFT JOIN pg_attribute AS attr ON attrelid = cls.oid
LEFT JOIN pg_type AS typ ON attr.atttypid = typ.oid
LEFT JOIN pg_proc ON pg_proc.oid = typ.typreceive
LEFT JOIN pg_type AS elemtyp ON (elemtyp.oid = typ.typelem)
LEFT JOIN pg_type AS basetyp ON (basetyp.oid = typ.typbasetype)
LEFT JOIN pg_description AS des ON des.objoid = cls.oid AND des.objsubid = attnum
LEFT JOIN pg_collation as coll ON coll.oid = attr.attcollation
-- Bring in identity sequences the depend on this column.
LEFT JOIN pg_depend AS dep ON dep.refobjid = cls.oid AND dep.refobjsubid = attr.attnum AND dep.deptype = 'i'
LEFT JOIN pg_sequence AS seq ON seq.seqrelid = dep.objid
WHERE
  cls.relkind IN ('r', 'v', 'm', 'f') AND
-- COMMENTED: CockroachDB-specific:   nspname NOT IN ('pg_catalog', 'information_schema', 'crdb_internal') AND
  attnum > 0 AND
  cls.relname = 'efcore_identity_test' AND
  NOT EXISTS (
    SELECT 1 FROM pg_depend WHERE;
      classid=(
        SELECT cls.oid
        FROM pg_class AS cls
        JOIN pg_namespace AS ns ON ns.oid = cls.relnamespace
        WHERE relname='pg_class' AND ns.nspname='pg_catalog'
      ) AND
      objid=cls.oid AND
      deptype IN ('e', 'x')
  )
ORDER BY attnum;



RESET client_min_messages;