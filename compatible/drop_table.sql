-- PostgreSQL compatible tests from drop_table
-- 38 tests

-- Test 1: statement (line 1)
CREATE TABLE a (id INT PRIMARY KEY)

let $t_id
SELECT id FROM system.namespace WHERE name='a'

-- Test 2: statement (line 7)
CREATE TABLE b (id INT PRIMARY KEY)

-- Test 3: query (line 10)
SHOW TABLES FROM test

-- Test 4: statement (line 16)
INSERT INTO a VALUES (3),(7),(2)

-- Test 5: query (line 19)
SELECT * FROM a

-- Test 6: statement (line 26)
DROP TABLE a

-- Test 7: query (line 50)
SHOW TABLES FROM test

-- Test 8: statement (line 55)
SELECT * FROM a

-- Test 9: statement (line 58)
SELECT * FROM [$t_id AS a]

-- Test 10: statement (line 61)
DROP TABLE a

-- Test 11: statement (line 64)
DROP TABLE IF EXISTS a

-- Test 12: statement (line 67)
CREATE TABLE a (id INT PRIMARY KEY)

-- Test 13: query (line 70)
SELECT * FROM a

-- Test 14: statement (line 74)
GRANT CREATE ON DATABASE test TO testuser

user testuser

-- Test 15: statement (line 79)
CREATE SCHEMA s

user root

-- Test 16: statement (line 84)
CREATE TABLE s.t()

user testuser

-- Test 17: statement (line 90)
DROP TABLE s.t

-- Test 18: statement (line 97)
CREATE TABLE to_drop();

-- Test 19: statement (line 100)
BEGIN;

-- Test 20: statement (line 103)
ALTER TABLE to_drop ADD COLUMN foo int;

-- Test 21: statement (line 106)
DROP TABLE to_drop;

-- Test 22: statement (line 109)
COMMIT;

-- Test 23: statement (line 112)
DROP TABLE to_drop;

-- Test 24: statement (line 117)
CREATE TABLE t_with_not_valid_constraints_1 (i INT PRIMARY KEY, j INT);

-- Test 25: statement (line 120)
CREATE TABLE t_with_not_valid_constraints_2 (i INT PRIMARY KEY, j INT);

-- Test 26: statement (line 123)
ALTER TABLE t_with_not_valid_constraints_1 ADD CHECK (i > 0) NOT VALID;

-- Test 27: statement (line 129)
ALTER TABLE t_with_not_valid_constraints_1 ADD UNIQUE WITHOUT INDEX (j) NOT VALID;

-- Test 28: statement (line 132)
ALTER TABLE t_with_not_valid_constraints_1 ADD FOREIGN KEY (i) REFERENCES t_with_not_valid_constraints_2 (i) NOT VALID;

-- Test 29: statement (line 135)
DROP TABLE t_with_not_valid_constraints_1;

-- Test 30: statement (line 138)
DROP TABLE t_with_not_valid_constraints_2;

-- Test 31: statement (line 144)
CREATE TABLE t_not_valid_src (i INT PRIMARY KEY, j INT);

-- Test 32: statement (line 147)
CREATE TABLE t_not_valid_dst (i INT PRIMARY KEY, j INT, c CHAR);

-- Test 33: statement (line 150)
CREATE SEQUENCE t_not_valid_sq;

-- Test 34: statement (line 153)
ALTER TABLE t_not_valid_dst ADD CONSTRAINT v_fk FOREIGN KEY(j) REFERENCES t_not_valid_src(i) NOT VALID;

-- Test 35: statement (line 156)
ALTER TABLE t_not_valid_dst ADD CHECK (j > currval('t_not_valid_sq')) NOT VALID;

-- Test 36: statement (line 159)
DROP TABLE t_not_valid_src CASCADE;

-- Test 37: statement (line 162)
DROP SEQUENCE t_not_valid_sq CASCADE;

-- Test 38: statement (line 170)
INSERT INTO t_not_valid_dst VALUES(5,5,5);

