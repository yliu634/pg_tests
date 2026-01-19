-- PostgreSQL compatible tests from event_log
-- 189 tests

-- Test 1: statement (line 10)
SET distsql_workmem = '64MiB'

-- Test 2: statement (line 20)
CREATE ROLE r

-- Test 3: statement (line 23)
CREATE ROLE IF NOT EXISTS r2

-- Test 4: statement (line 29)
DROP ROLE r, r2

-- Test 5: query (line 32)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" IN ('create_role', 'drop_role', 'alter_role')
ORDER BY "timestamp", info

-- Test 6: statement (line 48)
CREATE TABLE a (id INT PRIMARY KEY)

-- Test 7: statement (line 51)
CREATE TABLE IF NOT EXISTS b (id INT PRIMARY KEY)

-- Test 8: statement (line 54)
CREATE TABLE IF NOT EXISTS a (id INT PRIMARY KEY)

-- Test 9: query (line 62)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" = 'create_table'
ORDER BY "timestamp", info

-- Test 10: query (line 75)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_table'
  AND info::JSONB->>'Statement' LIKE 'CREATE TABLE test.public.a%'

-- Test 11: query (line 83)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_table'
  AND info::JSONB->>'Statement' LIKE 'CREATE TABLE IF NOT EXISTS test.public.b%'

-- Test 12: query (line 94)
SELECT count(*)
FROM system.eventlog
WHERE "eventType" = 'create_table'
  AND info LIKE '%CREATE TABLE badtable%'

-- Test 13: query (line 105)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'alter_table'

-- Test 14: statement (line 110)
ALTER TABLE a ADD val INT

-- Test 15: query (line 113)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'alter_table'

-- Test 16: query (line 119)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change'

-- Test 17: statement (line 126)
SELECT 1 / coalesce((info::JSONB->'LatencyNanos')::INT, 0) FROM system.eventlog
WHERE "eventType" = 'finish_schema_change'

-- Test 18: query (line 130)
SELECT "reportingID" FROM system.eventlog
WHERE "eventType" = 'reverse_schema_change'

-- Test 19: query (line 138)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'alter_table'
  AND info::JSONB->>'Statement' LIKE 'ALTER TABLE test.public.a%'

-- Test 20: statement (line 149)
INSERT INTO a VALUES (1, 1), (2, 1)

-- Test 21: statement (line 152)
ALTER TABLE a ADD CONSTRAINT foo UNIQUE(val)

-- Test 22: query (line 155)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" in ('alter_table', 'create_index')
ORDER BY "timestamp", info

-- Test 23: query (line 163)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change'

-- Test 24: query (line 169)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'Error' - 'LatencyNanos'
  FROM system.eventlog
WHERE "eventType" = 'reverse_schema_change'

-- Test 25: query (line 176)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change_rollback'

-- Test 26: statement (line 185)
CREATE INDEX a_foo ON a (val)

-- Test 27: query (line 188)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'create_index'
  AND info::JSONB->>'Statement' LIKE 'CREATE INDEX %a_foo%'

-- Test 28: query (line 195)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change'
ORDER BY "timestamp", info

-- Test 29: statement (line 203)
CREATE INDEX ON a (val)

-- Test 30: query (line 206)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'create_index'
  AND info::JSONB->>'Statement' LIKE 'CREATE INDEX ON%'

-- Test 31: query (line 213)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change'
ORDER BY "timestamp", info

-- Test 32: statement (line 225)
DROP INDEX a@a_foo

-- Test 33: query (line 228)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'drop_index'
  AND info::JSONB->>'Statement' LIKE 'DROP INDEX%a_foo'

-- Test 34: query (line 235)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'LatencyNanos' FROM system.eventlog
WHERE "eventType" = 'finish_schema_change'
ORDER BY "timestamp", info

-- Test 35: statement (line 248)
TRUNCATE TABLE a

-- Test 36: query (line 251)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'truncate_table'

-- Test 37: statement (line 261)
DROP TABLE a

-- Test 38: statement (line 264)
DROP TABLE IF EXISTS b

-- Test 39: statement (line 267)
DROP TABLE IF EXISTS b

-- Test 40: query (line 275)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_table'
ORDER BY "timestamp", info

-- Test 41: query (line 287)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_table'
  AND info::JSONB->>'Statement' LIKE 'DROP TABLE test.public.a%'

-- Test 42: query (line 295)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_table'
  AND info::JSONB->>'Statement' LIKE 'DROP TABLE IF EXISTS test.public.b%'

-- Test 43: statement (line 306)
CREATE TABLE toberenamed( id SERIAL PRIMARY KEY );

-- Test 44: statement (line 309)
ALTER TABLE toberenamed RENAME TO renamedtable;

-- Test 45: query (line 316)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'rename_table'
  AND info::JSONB->>'Statement' LIKE 'ALTER TABLE %toberenamed% RENAME TO %renamedtable%'

-- Test 46: statement (line 332)
CREATE DATABASE eventlogtest

-- Test 47: statement (line 335)
CREATE DATABASE IF NOT EXISTS othereventlogtest

-- Test 48: statement (line 338)
CREATE DATABASE IF NOT EXISTS othereventlogtest

-- Test 49: query (line 345)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_database'
  AND info::JSONB->>'Statement' LIKE 'CREATE DATABASE eventlogtest%'

-- Test 50: query (line 353)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_database'
  AND info::JSONB->>'Statement' LIKE 'CREATE DATABASE IF NOT EXISTS othereventlogtest%'

-- Test 51: statement (line 364)
SET DATABASE = eventlogtest

-- Test 52: statement (line 367)
CREATE TABLE eventlogtest.testtable (id int PRIMARY KEY)

-- Test 53: statement (line 370)
CREATE TABLE eventlogtest.anothertesttable (id int PRIMARY KEY)

-- Test 54: statement (line 376)
DROP DATABASE eventlogtest CASCADE

-- Test 55: statement (line 379)
DROP DATABASE IF EXISTS othereventlogtest CASCADE

-- Test 56: statement (line 382)
DROP DATABASE IF EXISTS othereventlogtest CASCADE

-- Test 57: query (line 390)
SELECT "reportingID",
       (info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp')
       || (
			SELECT json_build_object(
					'DroppedSchemaObjects',
					json_agg(value ORDER BY value)
			       )
			  FROM ROWS FROM (
					json_array_elements((info::JSONB)->'DroppedSchemaObjects')
			       )
		)
  FROM system.eventlog
 WHERE "eventType" = 'drop_database'
       AND info::JSONB->>'Statement' LIKE 'DROP DATABASE eventlogtest%'
 ORDER BY "timestamp";

-- Test 58: query (line 409)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_database'
  AND info::JSONB->>'Statement' LIKE 'DROP DATABASE IF EXISTS othereventlogtest%'

-- Test 59: statement (line 417)
SET DATABASE = test

-- Test 60: statement (line 423)
CREATE DATABASE eventlogtorename

-- Test 61: statement (line 429)
ALTER DATABASE eventlogtorename RENAME TO eventlogtonewname

-- Test 62: query (line 435)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'rename_database'
  AND info::JSONB->>'Statement' LIKE 'ALTER DATABASE %eventlogtorename% RENAME TO %eventlogtonewname%'

-- Test 63: statement (line 443)
SET DATABASE = test

-- Test 64: statement (line 457)
SET CLUSTER SETTING kv.allocator.load_based_lease_rebalancing.enabled = false

onlyif config local

-- Test 65: statement (line 461)
SET CLUSTER SETTING kv.allocator.load_based_lease_rebalancing.enabled = DEFAULT

-- Test 66: statement (line 464)
PREPARE set_setting AS SET CLUSTER SETTING cluster.label = $1

-- Test 67: query (line 473)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'set_cluster_setting'
AND info NOT LIKE '%version%'
AND info NOT LIKE '%cluster.secret%'
AND info NOT LIKE '%sql.defaults%'
AND info NOT LIKE '%sql.distsql%'
AND info NOT LIKE '%sql.testing%'
AND info NOT LIKE '%sql.stats%'
AND info NOT LIKE '%sql.catalog.allow_leased_descriptor%'
AND info NOT LIKE '%sql.catalog.descriptor_lease.use_locked_timestamps.enabled%'
ORDER BY "timestamp", info

-- Test 68: query (line 495)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'set_cluster_setting'
AND info NOT LIKE '%version%'
AND info NOT LIKE '%cluster.secret%'
AND info NOT LIKE '%sql.defaults%'
AND info NOT LIKE '%sql.distsql%'
AND info NOT LIKE '%sql.testing%'
AND info NOT LIKE '%sql.stats%'
AND info NOT LIKE '%sql.catalog.allow_leased_descriptor%'
AND info NOT LIKE '%sql.catalog.descriptor_lease.use_locked_timestamps.enabled%'
ORDER BY "timestamp", info

-- Test 69: statement (line 522)
ALTER DATABASE test CONFIGURE ZONE DISCARD

-- Test 70: statement (line 541)
ALTER INDEX a@bar CONFIGURE ZONE USING gc.ttlseconds = 15000

-- Test 71: query (line 547)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'Statement'
FROM system.eventlog
WHERE "eventType" = 'set_zone_config'
ORDER BY "timestamp", info

-- Test 72: query (line 564)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'Statement'
FROM system.eventlog
WHERE "eventType" = 'remove_zone_config'
ORDER BY "timestamp", info

-- Test 73: statement (line 573)
DROP TABLE a

-- Test 74: statement (line 578)
CREATE SEQUENCE s

-- Test 75: statement (line 581)
ALTER SEQUENCE s START 10

-- Test 76: statement (line 584)
DROP SEQUENCE s

-- Test 77: query (line 587)
SELECT "eventType", "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" in ('create_sequence', 'alter_sequence', 'drop_sequence')
ORDER BY "timestamp", info

-- Test 78: statement (line 599)
CREATE VIEW v AS SELECT 1

-- Test 79: statement (line 602)
DROP VIEW v

-- Test 80: query (line 605)
SELECT "eventType", "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" in ('create_view', 'drop_view')
ORDER BY "timestamp", info

-- Test 81: statement (line 618)
CREATE TABLE a (id INT PRIMARY KEY)

-- Test 82: statement (line 621)
CREATE TABLE b (id INT PRIMARY KEY)

-- Test 83: statement (line 624)
CREATE VIEW c AS SELECT id FROM b

-- Test 84: statement (line 627)
CREATE SEQUENCE sq

-- Test 85: statement (line 630)
CREATE DATABASE dbt

-- Test 86: statement (line 633)
CREATE SCHEMA sc

-- Test 87: statement (line 636)
CREATE USER u

-- Test 88: statement (line 639)
CREATE USER v

-- Test 89: statement (line 642)
GRANT INSERT ON TABLE a,b TO u

-- Test 90: statement (line 645)
GRANT SELECT ON TABLE sq TO u

-- Test 91: statement (line 648)
GRANT SELECT ON TABLE c TO u

-- Test 92: statement (line 651)
GRANT CREATE ON DATABASE dbt TO u

-- Test 93: statement (line 654)
GRANT CREATE ON SCHEMA sc TO u

-- Test 94: statement (line 657)
REVOKE UPDATE ON TABLE a FROM u,v

-- Test 95: statement (line 660)
REVOKE CREATE ON SCHEMA sc FROM u,v

-- Test 96: statement (line 663)
REVOKE CREATE ON DATABASE dbt FROM u,v

-- Test 97: statement (line 666)
GRANT ALL ON * TO u

-- Test 98: statement (line 669)
REVOKE ALL ON * FROM u

-- Test 99: query (line 672)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp', "eventType"
FROM system.eventlog
WHERE "eventType" LIKE 'change_%_privilege'
ORDER BY info::JSONB ->> 'TxnReadTimestamp', info::JSONB ->> 'Grantee', info::JSONB ->> 'TableName'

-- Test 100: statement (line 699)
DROP DATABASE dbt

-- Test 101: statement (line 702)
DROP SEQUENCE sq

-- Test 102: statement (line 705)
DROP SCHEMA sc

-- Test 103: statement (line 708)
DROP VIEW c

-- Test 104: statement (line 711)
DROP TABLE a

-- Test 105: statement (line 714)
DROP TABLE b

-- Test 106: statement (line 717)
DROP USER u

-- Test 107: statement (line 720)
DROP USER v

-- Test 108: statement (line 726)
CREATE SCHEMA s

-- Test 109: statement (line 729)
CREATE USER u

-- Test 110: statement (line 732)
CREATE SCHEMA AUTHORIZATION u

-- Test 111: query (line 735)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'create_schema'
ORDER BY "timestamp", info

-- Test 112: statement (line 745)
ALTER SCHEMA u RENAME TO t

-- Test 113: query (line 748)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'rename_schema'

-- Test 114: statement (line 755)
DROP SCHEMA s, t

-- Test 115: statement (line 758)
DROP USER u

-- Test 116: query (line 761)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_schema'
ORDER BY "timestamp", info

-- Test 117: statement (line 774)
SET CLUSTER SETTING server.eventlog.enabled = false

-- Test 118: statement (line 777)
CREATE ROLE rinvisible

-- Test 119: statement (line 780)
DROP ROLE rinvisible

-- Test 120: query (line 783)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" LIKE '%_role' AND info LIKE '%invisible%'

-- Test 121: statement (line 790)
SET CLUSTER SETTING server.eventlog.enabled = true

-- Test 122: statement (line 797)
CREATE DATABASE atest;

-- Test 123: statement (line 800)
GRANT CREATE ON DATABASE atest TO testuser

user testuser

-- Test 124: statement (line 805)
CREATE SCHEMA atest.sc;
  CREATE TABLE atest.sc.t(x INT);
  CREATE TYPE atest.sc.ty AS ENUM ('foo');
  CREATE VIEW atest.sc.v AS SELECT x FROM atest.sc.t;
  CREATE SEQUENCE atest.sc.s

user root

-- Test 125: statement (line 816)
PREPARE showOwners AS
  WITH db_id AS (
                SELECT id
                  FROM system.namespace
                 WHERE "parentID" = 0
                   AND "parentSchemaID" = 0
                   AND name = $1
             ),
       entities AS (
                    SELECT ns.id
                      FROM system.namespace AS ns
                      JOIN db_id ON (ns."parentID" = db_id.id)
                ),
      descs AS (
         SELECT crdb_internal.pb_to_json('cockroach.sql.sqlbase.Descriptor', descriptor) AS jdesc
           FROM system.descriptor AS sd
           JOIN entities ON (entities.id = sd.id)
      )
SELECT jdesc->'schema'->>'name' AS schema, jdesc->'schema'->'privileges'->>'ownerProto' AS owner,
       jdesc->'type'->>'name' AS type, jdesc->'type'->'privileges'->>'ownerProto' AS owner,
       jdesc->'table'->>'name' AS object, jdesc->'table'->'privileges'->>'ownerProto' AS owner
       FROM descs
ORDER BY 1,2,3,4,5,6

-- Test 126: query (line 841)
EXECUTE showOwners('atest')

-- Test 127: statement (line 852)
CREATE USER u;
  GRANT CREATE ON DATABASE atest TO u

-- Test 128: statement (line 856)
ALTER DATABASE atest OWNER TO u;
  ALTER SCHEMA atest.sc OWNER TO u;
  ALTER TABLE atest.sc.t OWNER TO u;
  ALTER TYPE atest.sc.ty OWNER TO u

-- Test 129: query (line 867)
EXECUTE showOwners('atest')

-- Test 130: query (line 879)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" LIKE '%_owner'
ORDER BY "timestamp", info

-- Test 131: statement (line 893)
CREATE USER v;
  GRANT CREATE ON DATABASE atest TO v

-- Test 132: statement (line 897)
USE atest -- REASSIGN only works on the current database

-- Test 133: statement (line 900)
REASSIGN OWNED BY u TO testuser

-- Test 134: statement (line 903)
REASSIGN OWNED BY testuser TO v

-- Test 135: query (line 907)
EXECUTE showOwners('atest')

-- Test 136: query (line 919)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" LIKE '%_owner' AND info::JSONB->>'Owner' = 'v'
ORDER BY "timestamp", info

-- Test 137: statement (line 933)
USE defaultdb

-- Test 138: statement (line 936)
DROP DATABASE atest CASCADE;

-- Test 139: statement (line 939)
DROP USER v;
DROP USER u

-- Test 140: statement (line 947)
CREATE TYPE eventlog AS ENUM ('event', 'log')

-- Test 141: query (line 950)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" = 'create_type' AND info::JSONB->>'TypeName' LIKE '%eventlog'
ORDER BY "timestamp", info

-- Test 142: statement (line 958)
ALTER TYPE eventlog ADD VALUE 'test'

-- Test 143: statement (line 961)
ALTER TYPE eventlog RENAME VALUE 'test' TO 'testing'

-- Test 144: statement (line 964)
CREATE SCHEMA testing

-- Test 145: statement (line 967)
ALTER TYPE eventlog SET SCHEMA testing;
ALTER TYPE testing.eventlog SET SCHEMA public

-- Test 146: statement (line 971)
ALTER TYPE eventlog RENAME TO eventlog_renamed

-- Test 147: query (line 974)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE ("eventType" = 'alter_type' OR "eventType" = 'rename_type') AND info::JSONB->>'TypeName' LIKE '%eventlog%'
ORDER BY "timestamp", info

-- Test 148: statement (line 986)
DROP TYPE eventlog_renamed

-- Test 149: query (line 989)
SELECT "reportingID", "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
  FROM system.eventlog
 WHERE "eventType" = 'drop_type' AND info::JSONB->>'TypeName' LIKE '%eventlog%'
ORDER BY "timestamp", info

-- Test 150: statement (line 1000)
CREATE TABLE a (id INT PRIMARY KEY, b INT NOT NULL)

-- Test 151: statement (line 1003)
COMMENT ON COLUMN a.id IS 'This is a column.'

-- Test 152: query (line 1006)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'comment_on_column'

-- Test 153: statement (line 1013)
CREATE INDEX b_index ON a (b)

-- Test 154: statement (line 1016)
COMMENT ON INDEX b_index IS 'This is an index.'

-- Test 155: query (line 1019)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'comment_on_index'

-- Test 156: statement (line 1026)
COMMENT ON TABLE a IS 'This is a table.'

-- Test 157: query (line 1029)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'comment_on_table'

-- Test 158: statement (line 1036)
CREATE SCHEMA sc;
COMMENT ON SCHEMA defaultdb.sc IS 'This is a schema';

-- Test 159: query (line 1040)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'comment_on_schema'

-- Test 160: statement (line 1047)
DROP SCHEMA sc;

-- Test 161: statement (line 1053)
ALTER TABLE a SET SCHEMA testing

-- Test 162: statement (line 1056)
CREATE SEQUENCE s

-- Test 163: statement (line 1059)
CREATE SCHEMA test_sc

-- Test 164: statement (line 1062)
ALTER SEQUENCE s SET SCHEMA testing

-- Test 165: statement (line 1065)
CREATE VIEW v AS SELECT 1

-- Test 166: statement (line 1068)
ALTER VIEW v SET SCHEMA test_sc

-- Test 167: query (line 1071)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'set_schema'
ORDER BY "timestamp", info

-- Test 168: statement (line 1087)
CREATE TABLE x (a INT PRIMARY KEY, b INT)

-- Test 169: statement (line 1090)
CREATE VIEW y AS SELECT a FROM x

-- Test 170: statement (line 1093)
CREATE VIEW z AS SELECT b FROM x

-- Test 171: statement (line 1096)
DROP TABLE x CASCADE

-- Test 172: query (line 1102)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' - 'CascadedDroppedViews'
FROM system.eventlog
WHERE "eventType" = 'drop_table'
ORDER BY "timestamp" DESC, info
LIMIT 1

-- Test 173: statement (line 1111)
CREATE TABLE t (i INT PRIMARY KEY, INDEX (i))

-- Test 174: statement (line 1114)
CREATE VIEW v AS (SELECT i FROM t@t_i_idx)

-- Test 175: statement (line 1117)
CREATE VIEW w AS (SELECT I FROM t@t_i_idx)

-- Test 176: statement (line 1120)
DROP INDEX t@t_i_idx CASCADE

-- Test 177: query (line 1123)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'drop_index'
ORDER BY "timestamp" DESC, info
LIMIT 1

-- Test 178: statement (line 1132)
CREATE TABLE x (a INT PRIMARY KEY, b INT)

-- Test 179: statement (line 1135)
CREATE VIEW v AS SELECT b FROM x

-- Test 180: statement (line 1138)
CREATE VIEW vv as SELECT b FROM x

-- Test 181: statement (line 1141)
ALTER TABLE x DROP COLUMN b CASCADE

-- Test 182: query (line 1144)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" = 'alter_table'
ORDER BY "timestamp" DESC, info
LIMIT 1

-- Test 183: statement (line 1156)
create function f (input int) returns int stable language sql as $$ select 123$$;

-- Test 184: statement (line 1159)
drop function f

-- Test 185: query (line 1162)
SELECT "eventType", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp'
FROM system.eventlog
WHERE "eventType" IN ('create_function', 'drop_function')
ORDER BY "timestamp" DESC, info
LIMIT 2

-- Test 186: statement (line 1174)
CREATE TABLE t1(n int);

-- Test 187: statement (line 1177)
EXPLAIN (DDL) ALTER TABLE t1 ADD COLUMN j int;

-- Test 188: query (line 1180)
SELECT "reportingID", info::JSONB - 'Timestamp' - 'DescriptorID' - 'TxnReadTimestamp' FROM system.eventlog
WHERE "eventType" = 'alter_table'
AND info::JSONB->>'Statement' LIKE 'ALTER TABLE t1%'
ORDER BY "timestamp" DESC, info

-- Test 189: statement (line 1188)
DROP table t1;

