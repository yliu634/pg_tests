-- PostgreSQL compatible tests from poison_after_push
--
-- CockroachDB-specific cluster settings and transaction priority are not
-- supported by PostgreSQL. This file keeps a small subset that exercises basic
-- permissions and transaction isolation levels.

SET client_min_messages = warning;

DROP TABLE IF EXISTS t;
DROP ROLE IF EXISTS testuser;
CREATE ROLE testuser;

CREATE TABLE t (id INT PRIMARY KEY);
INSERT INTO t VALUES (1);

GRANT ALL ON t TO testuser;

-- Simulated sequential transactions (PostgreSQL has no PRIORITY clause).
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO t VALUES (2);
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM t ORDER BY id;
COMMIT;

BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
INSERT INTO t VALUES (3);
COMMIT;

SET ROLE testuser;
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM t ORDER BY id;
COMMIT;
RESET ROLE;

SELECT * FROM t ORDER BY id;

DROP TABLE IF EXISTS t;
DROP ROLE IF EXISTS testuser;

RESET client_min_messages;
