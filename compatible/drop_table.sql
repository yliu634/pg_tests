-- PostgreSQL compatible tests from drop_table
--
-- CockroachDB logic-test directives (let/user/SHOW TABLES/system.namespace) do
-- not run under plain psql. This file focuses on DROP TABLE behavior in PG.

SET client_min_messages = warning;
DROP TABLE IF EXISTS drop_table_a CASCADE;
DROP TABLE IF EXISTS drop_table_b CASCADE;
DROP TABLE IF EXISTS drop_table_to_drop CASCADE;
DROP TABLE IF EXISTS t_with_not_valid_constraints_1 CASCADE;
DROP TABLE IF EXISTS t_with_not_valid_constraints_2 CASCADE;
RESET client_min_messages;

CREATE TABLE drop_table_a (id INT PRIMARY KEY);
CREATE TABLE drop_table_b (id INT PRIMARY KEY);

INSERT INTO drop_table_a VALUES (3), (7), (2);
SELECT * FROM drop_table_a ORDER BY id;

DROP TABLE drop_table_a;
SELECT to_regclass('drop_table_a') AS a_after_drop;

DROP TABLE IF EXISTS drop_table_a;

-- Drop inside a transaction block.
CREATE TABLE drop_table_to_drop();
BEGIN;
ALTER TABLE drop_table_to_drop ADD COLUMN foo INT;
DROP TABLE drop_table_to_drop;
COMMIT;
SELECT to_regclass('drop_table_to_drop') AS to_drop_after_commit;

-- Tables with NOT VALID constraints (supported for CHECK/FK in PG).
CREATE TABLE t_with_not_valid_constraints_2 (i INT PRIMARY KEY, j INT);
CREATE TABLE t_with_not_valid_constraints_1 (i INT PRIMARY KEY, j INT);

ALTER TABLE t_with_not_valid_constraints_1
  ADD CONSTRAINT chk_i_pos CHECK (i > 0) NOT VALID;

ALTER TABLE t_with_not_valid_constraints_1
  ADD CONSTRAINT fk_i FOREIGN KEY (i) REFERENCES t_with_not_valid_constraints_2 (i) NOT VALID;

DROP TABLE t_with_not_valid_constraints_1;
DROP TABLE t_with_not_valid_constraints_2;

DROP TABLE drop_table_b;

