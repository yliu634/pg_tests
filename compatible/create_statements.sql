-- PostgreSQL compatible tests from create_statements
-- Simplified version

SET client_min_messages = warning;
DROP TABLE IF EXISTS t CASCADE;
DROP TABLE IF EXISTS c CASCADE;
RESET client_min_messages;

-- Test 1-2: Basic tables
CREATE TABLE t (
  a INT PRIMARY KEY
);

CREATE TABLE c (
  a INT NOT NULL,
  b INT NULL,
  PRIMARY KEY (a)
);

CREATE INDEX c_a_b_idx ON c (a ASC, b ASC);

-- Test 3-5: Comments
COMMENT ON TABLE c IS 'table';
COMMENT ON COLUMN c.a IS 'column';
COMMENT ON INDEX c_a_b_idx IS 'index';

-- Test 6-7: Check create statements (commented out - crdb_internal specific)
-- SELECT * FROM crdb_internal.create_statements;

SELECT 'create_statements tests completed successfully' AS result;
