-- PostgreSQL compatible tests from show_indexes
-- 4 tests

-- Test 1: statement (line 1)
CREATE TABLE t1 (
  a INT,
  b INT,
  c INT,
  d INT,
  PRIMARY KEY (a, b),
  INDEX c_idx (c ASC),
  UNIQUE INDEX d_b_idx (d ASC, b ASC),
  INDEX expr_idx ((a+b), c)
)

-- Test 2: query (line 13)
SELECT * FROM [SHOW INDEXES from t1] ORDER BY index_name, seq_in_index

-- Test 3: statement (line 32)
CREATE TABLE t2 (
  a INT,
  b INT,
  c INT,
  d INT,
  e INT,
  PRIMARY KEY (c, b, a),
  INDEX a_e_c_idx (a ASC, e ASC, c ASC),
  UNIQUE INDEX b_d_idx (b ASC, d ASC),
  UNIQUE INDEX c_e_d_a_idx (c ASC, e ASC, d ASC, a ASC),
  INDEX d_idx (d ASC)
)

-- Test 4: query (line 46)
SHOW INDEXES from t2

