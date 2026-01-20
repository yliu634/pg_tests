-- PostgreSQL compatible tests from dependencies
-- 13 tests

-- Test 1: statement (line 4)
CREATE TABLE test_kv(k INT PRIMARY KEY, v INT, w DECIMAL);
  CREATE UNIQUE INDEX test_v_idx ON test_kv(v);
  CREATE INDEX test_v_idx2 ON test_kv(v DESC) STORING(w);
  CREATE INDEX test_v_idx3 ON test_kv(w) STORING(v);
  CREATE TABLE test_kvr1(k INT PRIMARY KEY REFERENCES test_kv(k));
  CREATE TABLE test_kvr2(k INT, v INT UNIQUE REFERENCES test_kv(k));
  CREATE TABLE test_kvr3(k INT, v INT UNIQUE REFERENCES test_kv(v));
  CREATE TABLE test_kvi1(k INT PRIMARY KEY);
  CREATE TABLE test_kvi2(k INT PRIMARY KEY, v INT);
  CREATE UNIQUE INDEX test_kvi2_idx ON test_kvi2(v);
  CREATE VIEW test_v1 AS SELECT v FROM test_kv;
  CREATE VIEW test_v2 AS SELECT v FROM test_v1;
  CREATE TABLE test_uwi_parent(a INT UNIQUE WITHOUT INDEX);
  CREATE TABLE test_uwi_child(a INT REFERENCES test_uwi_parent(a));

-- Test 2: query (line 20)
SELECT * FROM crdb_internal.table_columns WHERE descriptor_name LIKE 'test_%' ORDER BY descriptor_id, column_id

-- Test 3: query (line 44)
SELECT descriptor_id, descriptor_name, index_id, index_name, index_type, is_unique, is_inverted, is_sharded, shard_bucket_count
    FROM crdb_internal.table_indexes
   WHERE descriptor_name LIKE 'test_%'
ORDER BY descriptor_id, index_id

-- Test 4: query (line 68)
SELECT * FROM crdb_internal.index_columns WHERE descriptor_name LIKE 'test_%' ORDER BY descriptor_id, index_id, column_type, column_id

-- Test 5: query (line 96)
SELECT * FROM crdb_internal.backward_dependencies WHERE descriptor_name LIKE 'test_%' ORDER BY descriptor_id, index_id, dependson_type, dependson_id, dependson_index_id

-- Test 6: query (line 107)
SELECT * FROM crdb_internal.forward_dependencies WHERE descriptor_name LIKE 'test_%' ORDER BY descriptor_id, index_id, dependedonby_type, dependedonby_id, dependedonby_index_id

-- Test 7: statement (line 119)
CREATE TABLE moretest_t(k INT, v INT);
  CREATE VIEW moretest_v AS SELECT v FROM moretest_t WHERE FALSE

-- Test 8: query (line 123)
SELECT * FROM crdb_internal.backward_dependencies WHERE descriptor_name LIKE 'moretest_%' ORDER BY descriptor_id, index_id, dependson_type, dependson_id, dependson_index_id

-- Test 9: query (line 129)
SELECT * FROM crdb_internal.forward_dependencies WHERE descriptor_name LIKE 'moretest_%' ORDER BY descriptor_id, index_id, dependedonby_type, dependedonby_id, dependedonby_index_id

-- Test 10: statement (line 137)
CREATE SEQUENCE blog_posts_id_seq

-- Test 11: statement (line 140)
CREATE TABLE blog_posts (id INT PRIMARY KEY DEFAULT nextval('blog_posts_id_seq'), title text)

-- Test 12: query (line 143)
SELECT * FROM crdb_internal.backward_dependencies WHERE descriptor_name LIKE 'blog_posts'

-- Test 13: query (line 149)
SELECT * FROM crdb_internal.forward_dependencies WHERE descriptor_name LIKE 'blog_posts%'

