-- PostgreSQL compatible tests from upsert_non_metamorphic
-- 19 tests

-- Test 1: statement (line 13)
INSERT INTO src SELECT repeat('a', 100000) FROM generate_series(1, 60)

user host-cluster-root

-- Test 2: statement (line 20)
SET CLUSTER SETTING kv.raft.command.max_size='5MiB';

user root

-- Test 3: statement (line 25)
SET CLUSTER SETTING sql.mutations.mutation_batch_byte_size='1MiB';

-- Test 4: statement (line 30)
UPSERT INTO dest (s) (SELECT s FROM src)

-- Test 5: statement (line 33)
RESET CLUSTER SETTING sql.mutations.mutation_batch_byte_size;

user host-cluster-root

-- Test 6: statement (line 38)
RESET CLUSTER SETTING kv.raft.command.max_size;

user root

-- Test 7: statement (line 43)
DROP TABLE src;

-- Test 8: statement (line 46)
DROP TABLE dest

-- Test 9: statement (line 52)
SET CLUSTER SETTING kv.raft.command.max_size='4MiB';

user root

-- Test 10: statement (line 62)
SET CLUSTER SETTING kv.transaction.write_buffering.max_buffer_size = '1MiB';

-- Test 11: statement (line 73)
INSERT INTO src
SELECT
	'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
FROM
	generate_series(1, 50000)

-- Test 12: statement (line 82)
UPSERT INTO dest (s) (SELECT s FROM src)

user host-cluster-root

-- Test 13: statement (line 87)
RESET CLUSTER SETTING kv.raft.command.max_size;

user root

-- Test 14: statement (line 92)
DROP TABLE src;

-- Test 15: statement (line 95)
DROP TABLE dest

-- Test 16: statement (line 99)
CREATE TABLE t54456 (c INT PRIMARY KEY);

-- Test 17: statement (line 102)
UPSERT INTO t54456 SELECT i FROM generate_series(1, 25000) AS i

-- Test 18: query (line 105)
SELECT count(*) FROM t54456

-- Test 19: query (line 111)
WITH cte(c) AS (UPSERT INTO t54456 SELECT i FROM generate_series(25001, 40000) AS i RETURNING c) SELECT count(*) FROM cte

