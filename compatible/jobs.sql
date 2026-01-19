-- PostgreSQL compatible tests from jobs
-- 54 tests

-- Test 1: statement (line 5)
SET CLUSTER SETTING sql.defaults.use_declarative_schema_changer = 'off';

-- Test 2: statement (line 8)
SET CLUSTER SETTING sql.defaults.create_table_with_schema_locked = 'off'

-- Test 3: statement (line 11)
SET use_declarative_schema_changer = 'off';
SET create_table_with_schema_locked = 'off';

-- Test 4: statement (line 20)
GRANT ALL ON DATABASE test TO testuser

-- Test 5: statement (line 23)
CREATE TABLE t(x INT);

-- Test 6: statement (line 26)
INSERT INTO t(x) VALUES (1);

-- Test 7: statement (line 29)
CREATE INDEX ON t(x)

-- Test 8: query (line 40)
SELECT job_type, description, user_name FROM crdb_internal.jobs WHERE user_name = 'root'
AND job_type LIKE 'SCHEMA CHANGE%' ORDER BY 1, 2, 3

-- Test 9: query (line 48)
SELECT job_type, description, user_name FROM crdb_internal.jobs WHERE user_name = 'node'
AND job_type LIKE 'AUTO SPAN%'

-- Test 10: query (line 62)
SELECT job_type, description, user_name FROM crdb_internal.jobs

-- Test 11: statement (line 68)
CREATE TABLE u(x INT); INSERT INTO u(x) VALUES (1)

-- Test 12: statement (line 71)
CREATE INDEX ON u(x);

-- Test 13: query (line 81)
SELECT job_type, description, user_name FROM crdb_internal.jobs ORDER BY 1, 2, 3

-- Test 14: query (line 101)
SELECT job_type, description, user_name FROM crdb_internal.jobs WHERE user_name IN ('root', 'testuser', 'node')
AND (job_type LIKE 'AUTO SPAN%' OR job_type LIKE 'SCHEMA CHANGE%') ORDER BY 1, 2, 3

-- Test 15: statement (line 112)
CREATE USER testuser2

-- Test 16: statement (line 115)
GRANT CREATE ON DATABASE test TO testuser2

-- Test 17: statement (line 118)
ALTER ROLE testuser CONTROLJOB

user testuser2

-- Test 18: statement (line 123)
CREATE TABLE t1(x INT);

-- Test 19: statement (line 126)
INSERT INTO t1(x) VALUES (1);

-- Test 20: statement (line 129)
CREATE INDEX ON t1(x);

-- Test 21: statement (line 132)
DROP TABLE t1

user testuser

-- Test 22: query (line 138)
SELECT job_type, description, user_name FROM crdb_internal.jobs WHERE job_type = 'SCHEMA CHANGE GC' ORDER BY 1, 2, 3

-- Test 23: statement (line 160)
PAUSE JOB (SELECT $job_id)

user root

-- Test 24: statement (line 175)
PAUSE JOB (SELECT $job_id)

-- Test 25: statement (line 178)
CANCEL JOB (SELECT $job_id)

-- Test 26: statement (line 181)
RESUME JOB (SELECT $job_id)

user root

-- Test 27: statement (line 186)
GRANT SYSTEM VIEWJOB TO testuser

user testuser

-- Test 28: query (line 192)
SELECT job_type, description, user_name FROM crdb_internal.jobs WHERE job_type = 'SCHEMA CHANGE GC' ORDER BY 1, 2, 3

-- Test 29: statement (line 203)
REVOKE SYSTEM VIEWJOB FROM testuser

user testuser

-- Test 30: query (line 209)
SELECT job_type, description, user_name FROM crdb_internal.jobs WHERE job_type = 'SCHEMA CHANGE GC' ORDER BY 1, 2, 3

-- Test 31: statement (line 216)
CREATE ROLE jobviewer

-- Test 32: statement (line 219)
GRANT SYSTEM VIEWJOB TO jobviewer

-- Test 33: statement (line 222)
GRANT jobviewer TO testuser

user testuser

-- Test 34: query (line 228)
SELECT job_type, description, user_name FROM crdb_internal.jobs WHERE job_type = 'SCHEMA CHANGE GC' ORDER BY 1, 2, 3

-- Test 35: statement (line 238)
REVOKE jobviewer FROM testuser

user testuser

-- Test 36: query (line 244)
SELECT job_type, description, user_name FROM crdb_internal.jobs WHERE job_type = 'SCHEMA CHANGE GC' ORDER BY 1, 2, 3

-- Test 37: query (line 252)
SELECT feature_name FROM crdb_internal.feature_usage
WHERE feature_name in ('job.schema_change.successful') AND
usage_count > 0
ORDER BY feature_name DESC

-- Test 38: query (line 261)
SELECT count(*) FROM [SHOW AUTOMATIC JOBS] WHERE job_type = 'POLL JOBS STATS' AND status = 'running'

-- Test 39: statement (line 270)
CREATE TABLE t_control_job_priv(x INT)

-- Test 40: statement (line 275)
INSERT INTO t_control_job_priv VALUES (1)

-- Test 41: statement (line 286)
PAUSE JOB (SELECT $job_id)

user root

-- Test 42: statement (line 291)
GRANT SYSTEM CONTROLJOB TO testuser

user testuser

-- Test 43: statement (line 296)
PAUSE JOB (SELECT $job_id)

user root

-- Test 44: statement (line 301)
REVOKE SYSTEM CONTROLJOB FROM testuser

-- Test 45: statement (line 310)
CREATE TABLE t_control_job_priv_inherited(x INT)

-- Test 46: statement (line 315)
INSERT INTO t_control_job_priv_inherited VALUES (1)

-- Test 47: statement (line 326)
PAUSE JOB (SELECT $job_id)

user root

-- Test 48: statement (line 331)
CREATE ROLE jobcontroller

-- Test 49: statement (line 334)
GRANT SYSTEM CONTROLJOB TO jobcontroller

-- Test 50: statement (line 337)
GRANT jobcontroller TO testuser

user testuser

-- Test 51: statement (line 342)
PAUSE JOB (SELECT $job_id)

user root

-- Test 52: statement (line 347)
REVOKE SYSTEM CONTROLJOB FROM jobcontroller

-- Test 53: statement (line 350)
REVOKE jobcontroller FROM testuser

-- Test 54: statement (line 353)
DROP ROLE jobcontroller

