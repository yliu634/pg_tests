-- PostgreSQL compatible tests from temp_table_txn
-- Reduced subset: CockroachDB force-retry/autocommit_before_ddl are not
-- applicable to PostgreSQL.

BEGIN;
SET LOCAL crdb.autocommit_before_ddl = off;
CREATE TEMP TABLE tbl (a INT PRIMARY KEY);
INSERT INTO tbl VALUES (1);
COMMIT;

SELECT * FROM tbl ORDER BY a;
