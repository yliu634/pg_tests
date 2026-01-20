-- PostgreSQL compatible tests from schema_change_logical_replication
-- 9 tests

-- Test 1: statement (line 4)
CREATE TABLE t (x INT PRIMARY KEY, y INT)

-- Test 2: statement (line 7)
SELECT
	crdb_internal.unsafe_upsert_descriptor(
		d.id,
		crdb_internal.json_to_pb(
			'cockroach.sql.sqlbase.Descriptor',
			json_set(
				crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', d.descriptor),
				ARRAY['table', 'ldrJobIds'],
				'["12345"]'::JSONB
			)
		),
		true
	)
FROM
	system.descriptor AS d INNER JOIN system.namespace AS ns ON d.id = ns.id
WHERE
	name = 't'

-- Test 3: statement (line 26)
ALTER TABLE t ADD COLUMN z INT NOT NULL DEFAULT 10

-- Test 4: statement (line 29)
ALTER TABLE t ALTER PRIMARY KEY USING COLUMNS (y)

-- Test 5: statement (line 32)
CREATE UNIQUE INDEX idx ON t(y)

-- Test 6: statement (line 35)
ALTER TABLE t DROP COLUMN y

-- Test 7: statement (line 38)
ALTER TABLE t ADD COLUMN z INT NULL

-- Test 8: statement (line 43)
CREATE INDEX idx ON t(y)

-- Test 9: statement (line 46)
DROP INDEX idx

