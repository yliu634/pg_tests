-- PostgreSQL compatible tests from distsql_inspect
-- 9 tests

-- Test 1: statement (line 7)
CREATE VIEW last_inspect_job AS
SELECT status, COALESCE(jsonb_array_length(
    crdb_internal.pb_to_json('cockroach.sql.jobs.jobspb.Payload', payload)->'inspectDetails'->'checks'
  ), 0) AS num_checks
FROM crdb_internal.system_jobs
WHERE job_type = 'INSPECT'
ORDER BY created DESC
LIMIT 1

-- Test 2: statement (line 17)
CREATE TABLE data (a INT, b INT, c FLOAT, d DECIMAL, e BOOL, PRIMARY KEY (a, b, c, d), INDEX c_idx (c, d))

-- Test 3: statement (line 31)
INSERT INTO data SELECT a, b, c::FLOAT, d::DECIMAL FROM
   generate_series(1, 10) AS a(a),
   generate_series(1, 10) AS b(b),
   generate_series(1, 10) AS c(c),
   generate_series(1, 10) AS d(d)

-- Test 4: statement (line 70)
CREATE TABLE table_ltree_array_leading (
    pk_ltree_array LTREE[] NOT NULL,
    pk_name NAME NOT NULL,
    val INT,
    PRIMARY KEY (pk_ltree_array, pk_name),
    INDEX idx_val (val)
);

-- Test 5: statement (line 79)
INSERT INTO table_ltree_array_leading VALUES
    (ARRAY['a.b.c']::LTREE[], 'key1', 1),
    (ARRAY['d.e.f']::LTREE[], 'key2', 2),
    (ARRAY['g.h.i']::LTREE[], 'key3', 3),
    (ARRAY['j.k.l']::LTREE[], 'key4', 4),
    (ARRAY['m.n.o']::LTREE[], 'key5', 5),
    (ARRAY['p.q.r']::LTREE[], 'key6', 6);

-- Test 6: statement (line 98)
INSPECT TABLE table_ltree_array_leading;

-- Test 7: query (line 101)
SELECT * FROM last_inspect_job;

-- Test 8: statement (line 106)
DROP TABLE table_ltree_array_leading;

-- Test 9: statement (line 113)
DROP TABLE data;

