-- PostgreSQL compatible tests from event_log_legacy
-- 183 tests

SET client_min_messages = warning;

-- PG STUB: system.eventlog
-- CockroachDB's system.eventlog does not exist in PostgreSQL.
-- Create a minimal stub so the original queries can run.
DROP SCHEMA IF EXISTS system CASCADE;
CREATE SCHEMA system;
CREATE TABLE system.eventlog (
  "timestamp" TIMESTAMPTZ NOT NULL DEFAULT now(),
  "eventType" TEXT NOT NULL,
  "reportingID" INT NOT NULL DEFAULT 0,
  info TEXT NOT NULL DEFAULT '{}'::text
);

-- Test 1: statement (line 10)
-- SET distsql_workmem = '64MiB'

-- Test 2: statement (line 20)
CREATE ROLE r;

-- Test 3: statement (line 23)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'r2') THEN
    EXECUTE 'CREATE ROLE r2';
  END IF;
END
$$;

-- Test 4: statement (line 29)
DROP ROLE r, r2;

-- Test 5: query (line 32)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" IN ('create_role', 'drop_role', 'alter_role')
ORDER BY "timestamp", info;

-- Test 6: statement (line 48)
CREATE TABLE a (id INT PRIMARY KEY);

-- Test 7: statement (line 51)
CREATE TABLE IF NOT EXISTS b (id INT PRIMARY KEY);

-- Test 8: statement (line 54)
CREATE TABLE IF NOT EXISTS a (id INT PRIMARY KEY);

-- Test 9: query (line 62)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" = 'create_table'
ORDER BY "timestamp", info;

-- Test 10: query (line 75)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_table'
  AND info::JSONB->>'Statement' LIKE 'CREATE TABLE test.public.a%';

-- Test 11: query (line 83)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_table'
  AND info::JSONB->>'Statement' LIKE 'CREATE TABLE IF NOT EXISTS test.public.b%';

-- Test 12: query (line 94)
SELECT count(*)
FROM system.eventlog
WHERE "eventType" = 'create_table'
  AND info LIKE '%CREATE TABLE badtable%';

-- Test 13: query (line 105)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'alter_table';

-- Test 14: statement (line 110)
ALTER TABLE a ADD val INT;

-- Test 15: query (line 113)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'alter_table';

-- Test 16: query (line 119)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change';

-- Test 17: statement (line 126)
SELECT 1 / coalesce((info::JSONB->'LatencyNanos')::INT, 0) FROM system.eventlog
WHERE "eventType" = 'finish_schema_change';

-- Test 18: query (line 130)
SELECT "reportingID" FROM system.eventlog
WHERE "eventType" = 'reverse_schema_change';

-- Test 19: query (line 138)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'alter_table'
  AND info::JSONB->>'Statement' LIKE 'ALTER TABLE test.public.a%';

-- Test 20: statement (line 149)
INSERT INTO a VALUES (1, 1), (2, 2);

-- Test 21: statement (line 152)
ALTER TABLE a ADD CONSTRAINT foo UNIQUE(val);

-- Test 22: query (line 155)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'alter_table'
ORDER BY "timestamp", info;

-- Test 23: query (line 163)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos'  FROM system.eventlog
WHERE "eventType" = 'finish_schema_change';

-- Test 24: query (line 169)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'Error' - 'LatencyNanos'
  FROM system.eventlog
WHERE "eventType" = 'reverse_schema_change';

-- Test 25: query (line 177)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change_rollback';

-- Test 26: statement (line 186)
CREATE INDEX a_foo ON a (val);

-- Test 27: query (line 189)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'create_index'
  AND info::JSONB->>'Statement' LIKE 'CREATE INDEX %a_foo%';

-- Test 28: query (line 196)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change'
ORDER BY "timestamp", info;

-- Test 29: statement (line 204)
CREATE INDEX ON a (val);

-- Test 30: query (line 207)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'create_index'
  AND info::JSONB->>'Statement' LIKE 'CREATE INDEX ON%';

-- Test 31: query (line 214)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change'
ORDER BY "timestamp", info;

-- Test 32: statement (line 226)
DROP INDEX a_foo;

-- Test 33: query (line 229)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'drop_index'
  AND info::JSONB->>'Statement' LIKE 'DROP INDEX%a_foo';

-- Test 34: query (line 236)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change'
ORDER BY "timestamp", info;

-- Test 35: statement (line 250)
-- ALTER TABLE a SET (schema_locked=false);

-- Test 36: statement (line 253)
TRUNCATE TABLE a;

-- Test 37: statement (line 256)
-- ALTER TABLE a RESET (schema_locked);

-- Test 38: query (line 259)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'truncate_table';

-- Test 39: statement (line 269)
DROP TABLE a;

-- Test 40: statement (line 272)
DROP TABLE IF EXISTS b;

-- Test 41: statement (line 275)
DROP TABLE IF EXISTS b;

-- Test 42: query (line 283)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_table'
ORDER BY "timestamp", info;

-- Test 43: query (line 295)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_table'
  AND info::JSONB->>'Statement' LIKE 'DROP TABLE test.public.a%';

-- Test 44: query (line 303)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_table'
  AND info::JSONB->>'Statement' LIKE 'DROP TABLE IF EXISTS test.public.b%';

-- Test 45: statement (line 314)
CREATE TABLE toberenamed( id SERIAL PRIMARY KEY );

-- Test 46: statement (line 317)
ALTER TABLE toberenamed RENAME TO renamedtable;

-- Test 47: query (line 324)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'rename_table'
  AND info::JSONB->>'Statement' LIKE 'ALTER TABLE %toberenamed% RENAME TO %renamedtable%';

-- Test 48: statement (line 340)
CREATE SCHEMA eventlogtest;

-- Test 49: statement (line 343)
CREATE SCHEMA IF NOT EXISTS othereventlogtest;

-- Test 50: statement (line 346)
CREATE SCHEMA IF NOT EXISTS othereventlogtest;

-- Test 51: query (line 353)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_database'
  AND info::JSONB->>'Statement' LIKE 'CREATE DATABASE eventlogtest%';

-- Test 52: query (line 361)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_database'
  AND info::JSONB->>'Statement' LIKE 'CREATE DATABASE IF NOT EXISTS othereventlogtest%';

-- Test 53: statement (line 372)
-- SET DATABASE = eventlogtest;

-- Test 54: statement (line 375)
CREATE TABLE eventlogtest.testtable (id int PRIMARY KEY);

-- Test 55: statement (line 378)
CREATE TABLE eventlogtest.anothertesttable (id int PRIMARY KEY);

-- Test 56: statement (line 384)
DROP SCHEMA eventlogtest CASCADE;

-- Test 57: statement (line 387)
DROP SCHEMA IF EXISTS othereventlogtest CASCADE;

-- Test 58: statement (line 390)
DROP SCHEMA IF EXISTS othereventlogtest CASCADE;

-- Test 59: query (line 398)
SELECT "reportingID",
       (info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp')
       || (
			SELECT jsonb_build_object(
					'DroppedSchemaObjects',
					jsonb_agg(value ORDER BY value)
			       )
			  FROM ROWS FROM (
					jsonb_array_elements((info::JSONB)->'DroppedSchemaObjects')
			       )
		)
  FROM system.eventlog
 WHERE "eventType" = 'drop_database'
       AND info::JSONB->>'Statement' LIKE 'DROP DATABASE eventlogtest%'
 ORDER BY "timestamp";

-- Test 60: query (line 417)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_database'
  AND info::JSONB->>'Statement' LIKE 'DROP DATABASE IF EXISTS othereventlogtest%';

-- Test 61: statement (line 425)
-- SET DATABASE = test;

-- Test 62: statement (line 431)
CREATE SCHEMA eventlogtorename;

-- Test 63: statement (line 437)
ALTER SCHEMA eventlogtorename RENAME TO eventlogtonewname;
DROP SCHEMA eventlogtonewname CASCADE;

-- Test 64: query (line 443)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'rename_database'
  AND info::JSONB->>'Statement' LIKE 'ALTER DATABASE %eventlogtorename% RENAME TO %eventlogtonewname%';

-- Test 65: statement (line 451)
-- SET DATABASE = test;

-- Test 66: statement (line 465)
-- SET CLUSTER SETTING kv.allocator.load_based_lease_rebalancing.enabled = false

-- onlyif config local

-- Test 67: statement (line 469)
-- SET CLUSTER SETTING kv.allocator.load_based_lease_rebalancing.enabled = DEFAULT

-- Test 68: statement (line 472)
-- PREPARE set_setting AS SET CLUSTER SETTING cluster.label = $1

-- Test 69: query (line 481)
SELECT "reportingID", "info"::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'set_cluster_setting'
AND info NOT LIKE '%version%'
AND info NOT LIKE '%cluster.secret%'
AND info NOT LIKE '%sql.defaults%'
AND info NOT LIKE '%sql.distsql%'
AND info NOT LIKE '%sql.testing%'
AND info NOT LIKE '%sql.stats%'
ORDER BY "timestamp", info;

-- Test 70: query (line 501)
SELECT "reportingID", "info"::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'set_cluster_setting'
AND info NOT LIKE '%version%'
AND info NOT LIKE '%cluster.secret%'
AND info NOT LIKE '%sql.defaults%'
AND info NOT LIKE '%sql.distsql%'
AND info NOT LIKE '%sql.testing%'
AND info NOT LIKE '%sql.stats%'
ORDER BY "timestamp", info;

-- Test 71: statement (line 536)
-- ALTER INDEX a@bar CONFIGURE ZONE USING gc.ttlseconds = 15000

-- Test 72: query (line 542)
SELECT "reportingID", "info"::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'set_zone_config'
ORDER BY "timestamp", info;

-- Test 73: query (line 558)
SELECT "reportingID", "info"::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'remove_zone_config'
ORDER BY "timestamp", info;

-- Test 74: statement (line 566)
DROP TABLE IF EXISTS a;

-- Test 75: statement (line 571)
CREATE SEQUENCE s;

-- Test 76: statement (line 574)
ALTER SEQUENCE s START 10;

-- Test 77: statement (line 577)
DROP SEQUENCE s;

-- Test 78: query (line 580)
SELECT "eventType", "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" in ('create_sequence', 'alter_sequence', 'drop_sequence')
ORDER BY "timestamp", info;

-- Test 79: statement (line 592)
CREATE VIEW v AS SELECT 1;

-- Test 80: statement (line 595)
DROP VIEW v;

-- Test 81: query (line 598)
SELECT "eventType", "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" in ('create_view', 'drop_view')
ORDER BY "timestamp", info;

-- Test 82: statement (line 611)
CREATE TABLE a (id INT PRIMARY KEY);

-- Test 83: statement (line 614)
CREATE TABLE b (id INT PRIMARY KEY);

-- Test 84: statement (line 617)
CREATE VIEW c AS SELECT id FROM b;

-- Test 85: statement (line 620)
CREATE SEQUENCE sq;

-- Test 86: statement (line 623)
CREATE DATABASE dbt;

-- Test 87: statement (line 626)
CREATE SCHEMA sc;

-- Test 88: statement (line 629)
CREATE USER u;

-- Test 89: statement (line 632)
CREATE USER v;

-- Test 90: statement (line 635)
GRANT INSERT ON TABLE a,b TO u;

-- Test 91: statement (line 638)
GRANT USAGE, SELECT ON SEQUENCE sq TO u;

-- Test 92: statement (line 641)
GRANT SELECT ON TABLE c TO u;

-- Test 93: statement (line 644)
GRANT CREATE ON DATABASE dbt TO u;

-- Test 94: statement (line 647)
GRANT CREATE ON SCHEMA sc TO u;

-- Test 95: statement (line 650)
REVOKE UPDATE ON TABLE a FROM u,v;

-- Test 96: statement (line 653)
REVOKE CREATE ON SCHEMA sc FROM u,v;

-- Test 97: statement (line 656)
REVOKE CREATE ON DATABASE dbt FROM u,v;

-- Test 98: statement (line 659)
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO u;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO u;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA sc TO u;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA sc TO u;

-- Test 99: statement (line 662)
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM u;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM u;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA sc FROM u;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA sc FROM u;

-- Test 100: query (line 665)
SELECT "reportingID", "info"::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp', "eventType"
FROM system.eventlog
WHERE "eventType" LIKE 'change_%_privilege'
ORDER BY info::JSONB ->> 'TxnReadTimestamp', info::JSONB ->> 'Grantee', info::JSONB ->> 'TableName';

-- Test 101: statement (line 692)
DROP DATABASE dbt;

-- Test 102: statement (line 695)
DROP SEQUENCE sq;

-- Test 103: statement (line 698)
DROP SCHEMA sc;

-- Test 104: statement (line 701)
DROP VIEW c;

-- Test 105: statement (line 704)
DROP TABLE a;

-- Test 106: statement (line 707)
DROP TABLE b;

-- Test 107: statement (line 710)
DROP USER u;

-- Test 108: statement (line 713)
DROP USER v;

-- Test 109: statement (line 719)
CREATE SCHEMA s;

-- Test 110: statement (line 722)
CREATE USER u;

-- Test 111: statement (line 725)
CREATE SCHEMA u;

-- Test 112: query (line 728)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_schema'
ORDER BY "timestamp", info;

-- Test 113: statement (line 738)
ALTER SCHEMA u RENAME TO t;

-- Test 114: query (line 741)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'rename_schema';

-- Test 115: statement (line 748)
DROP SCHEMA s, t;

-- Test 116: statement (line 751)
DROP USER u;

-- Test 117: query (line 754)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_schema'
ORDER BY "timestamp", info;

-- Test 118: statement (line 767)
-- SET CLUSTER SETTING server.eventlog.enabled = false

-- Test 119: statement (line 770)
CREATE ROLE rinvisible;

-- Test 120: statement (line 773)
DROP ROLE rinvisible;

-- Test 121: query (line 776)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" LIKE '%_role' AND info LIKE '%invisible%';

-- Test 122: statement (line 783)
-- SET CLUSTER SETTING server.eventlog.enabled = true

-- Test 123: statement (line 790)
-- CREATE DATABASE atest;

-- Test 124: statement (line 793)
-- GRANT CREATE ON DATABASE atest TO testuser

-- user testuser

-- Test 125: statement (line 798)
-- CREATE SCHEMA atest.sc;
--   CREATE TABLE atest.sc.t(x INT);
--   CREATE TYPE atest.sc.ty AS ENUM ('foo');
--   CREATE VIEW atest.sc.v AS SELECT x FROM atest.sc.t;
--   CREATE SEQUENCE atest.sc.s

-- user root

-- Test 126: statement (line 809)
-- PREPARE showOwners AS
--   WITH db_id AS (
--                 SELECT id
--                   FROM system.namespace
--                  WHERE "parentID" = 0
--                    AND "parentSchemaID" = 0
--                    AND name = $1
--              ),
--        entities AS (
--                     SELECT ns.id
--                       FROM system.namespace AS ns
--                       JOIN db_id ON (ns."parentID" = db_id.id)
--                 ),
--       descs AS (
--          SELECT crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor) AS jdesc
--            FROM system.descriptor AS sd
--            JOIN entities ON (entities.id = sd.id)
--       )
-- SELECT jdesc->'schema'->>'name' AS schema, jdesc->'schema'->'privileges'->>'ownerProto' AS owner,
--        jdesc->'type'->>'name' AS type, jdesc->'type'->'privileges'->>'ownerProto' AS owner,
--        jdesc->'table'->>'name' AS object, jdesc->'table'->'privileges'->>'ownerProto' AS owner
--        FROM descs
-- ORDER BY 1,2,3,4,5,6

-- Test 127: query (line 834)
-- EXECUTE showOwners('atest')

-- Test 128: statement (line 845)
-- CREATE USER u;
--   GRANT CREATE ON DATABASE atest TO u

-- Test 129: statement (line 849)
-- ALTER DATABASE atest OWNER TO u;
--   ALTER SCHEMA atest.sc OWNER TO u;
--   ALTER TABLE atest.sc.t OWNER TO u;
--   ALTER TYPE atest.sc.ty OWNER TO u

-- Test 130: query (line 860)
-- EXECUTE showOwners('atest')

-- Test 131: query (line 872)
-- SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
--   FROM system.eventlog
--  WHERE "eventType" LIKE '%_owner'
-- ORDER BY "timestamp", info

-- Test 132: statement (line 886)
-- CREATE USER v;
--   GRANT CREATE ON DATABASE atest TO v

-- Test 133: statement (line 890)
-- USE atest -- REASSIGN only works on the current database

-- Test 134: statement (line 893)
-- REASSIGN OWNED BY u TO testuser

-- Test 135: statement (line 896)
-- REASSIGN OWNED BY testuser TO v

-- Test 136: query (line 900)
-- EXECUTE showOwners('atest')

-- Test 137: query (line 912)
-- SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
--   FROM system.eventlog
--  WHERE "eventType" LIKE '%_owner' AND info::JSONB->>'Owner' = 'v'
-- ORDER BY "timestamp", info

-- Test 138: statement (line 926)
-- USE defaultdb

-- Test 139: statement (line 929)
-- DROP DATABASE atest CASCADE;

-- Test 140: statement (line 932)
-- DROP USER v;
-- DROP USER u

-- Test 141: statement (line 940)
CREATE TYPE eventlog AS ENUM ('event', 'log');

-- Test 142: query (line 943)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" = 'create_type' AND info::JSONB->>'TypeName' LIKE '%eventlog'
ORDER BY "timestamp", info;

-- Test 143: statement (line 951)
ALTER TYPE eventlog ADD VALUE 'test';

-- Test 144: statement (line 954)
ALTER TYPE eventlog RENAME VALUE 'test' TO 'testing';

-- Test 145: statement (line 957)
CREATE SCHEMA testing;

-- Test 146: statement (line 960)
ALTER TYPE eventlog SET SCHEMA testing;
ALTER TYPE testing.eventlog SET SCHEMA public;

-- Test 147: statement (line 964)
ALTER TYPE eventlog RENAME TO eventlog_renamed;

-- Test 148: query (line 967)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE ("eventType" = 'alter_type' OR "eventType" = 'rename_type') AND info::JSONB->>'TypeName' LIKE '%eventlog%'
ORDER BY "timestamp", info;

-- Test 149: statement (line 979)
DROP TYPE eventlog_renamed;

-- Test 150: query (line 982)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" = 'drop_type' AND info::JSONB->>'TypeName' LIKE '%eventlog%'
ORDER BY info::JSONB ->> 'TxnReadTimestamp', info::JSONB ->> 'TypeName';

-- Test 151: statement (line 994)
CREATE TABLE a (id INT PRIMARY KEY, b INT NOT NULL);

-- Test 152: statement (line 997)
COMMENT ON COLUMN a.id IS 'This is a column.';

-- Test 153: query (line 1000)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'comment_on_column';

-- Test 154: statement (line 1007)
CREATE INDEX b_index ON a (b);

-- Test 155: statement (line 1010)
COMMENT ON INDEX b_index IS 'This is an index.';

-- Test 156: query (line 1013)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'comment_on_index';

-- Test 157: statement (line 1020)
COMMENT ON TABLE a IS 'This is a table.';

-- Test 158: query (line 1023)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'comment_on_table';

-- Test 159: statement (line 1030)
CREATE SCHEMA sc;
COMMENT ON SCHEMA sc IS 'This is a schema';

-- Test 160: query (line 1034)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'comment_on_schema';

-- Test 161: statement (line 1041)
DROP SCHEMA sc;

-- Test 162: statement (line 1047)
ALTER TABLE a SET SCHEMA testing;

-- Test 163: statement (line 1050)
CREATE SEQUENCE s;

-- Test 164: statement (line 1053)
CREATE SCHEMA test_sc;

-- Test 165: statement (line 1056)
ALTER SEQUENCE s SET SCHEMA testing;

-- Test 166: statement (line 1059)
CREATE VIEW v AS SELECT 1;

-- Test 167: statement (line 1062)
ALTER VIEW v SET SCHEMA test_sc;

-- Test 168: query (line 1065)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'set_schema'
ORDER BY "timestamp", info;

-- Test 169: statement (line 1081)
CREATE TABLE x (a INT PRIMARY KEY, b INT);

-- Test 170: statement (line 1084)
CREATE VIEW y AS SELECT a FROM x;

-- Test 171: statement (line 1087)
CREATE VIEW z AS SELECT b FROM x;

-- Test 172: statement (line 1090)
DROP TABLE x CASCADE;

-- Test 173: query (line 1096)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'CascadedDroppedViews'
FROM system.eventlog
WHERE "eventType" = 'drop_table'
ORDER BY "timestamp" DESC, info
LIMIT 1;

-- Test 174: statement (line 1105)
CREATE TABLE t (i INT PRIMARY KEY);
CREATE INDEX t_i_idx ON t(i);

-- Test 175: statement (line 1108)
CREATE VIEW v AS (SELECT i FROM t);

-- Test 176: statement (line 1111)
CREATE VIEW w AS (SELECT I FROM t);

-- Test 177: statement (line 1114)
DROP INDEX t_i_idx CASCADE;

-- Test 178: query (line 1117)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_index'
ORDER BY "timestamp" DESC, info
LIMIT 1;

-- Test 179: statement (line 1126)
CREATE TABLE x (a INT PRIMARY KEY, b INT);

-- Test 180: statement (line 1129)
DROP VIEW IF EXISTS v;
CREATE VIEW v AS SELECT b FROM x;

-- Test 181: statement (line 1132)
CREATE VIEW vv as SELECT b FROM x;

-- Test 182: statement (line 1135)
ALTER TABLE x DROP COLUMN b CASCADE;

-- Test 183: query (line 1138)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'alter_table'
ORDER BY "timestamp" DESC, info
LIMIT 1;

RESET client_min_messages;
