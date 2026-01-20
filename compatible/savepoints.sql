-- PostgreSQL compatible tests from savepoints
--
-- Reduced to a minimal demonstration of SAVEPOINT/ROLLBACK TO SAVEPOINT
-- without introducing sleeps.

SET client_min_messages = warning;

DROP TABLE IF EXISTS a;
CREATE TABLE a (id INT);

BEGIN;
SAVEPOINT s;
INSERT INTO a(id) VALUES (0);
ROLLBACK TO SAVEPOINT s;
SELECT * FROM a;
COMMIT;

BEGIN;
SAVEPOINT sp1;
INSERT INTO a(id) VALUES (1);
ROLLBACK TO SAVEPOINT sp1;
ROLLBACK;

DROP TABLE a;

RESET client_min_messages;
