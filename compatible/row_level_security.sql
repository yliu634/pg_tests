-- PostgreSQL compatible tests from row_level_security
-- 1383 tests

SET client_min_messages = warning;
\set ON_ERROR_STOP 0

-- Ensure Cockroach-style roles exist so we can emulate `user root`/`user testuser`.
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'root') THEN
    CREATE ROLE root SUPERUSER;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'testuser') THEN
    CREATE ROLE testuser;
  END IF;
END
$$;

-- Cleanup leftovers from prior runs (roles and cross-db artifacts are cluster-wide).
DROP DATABASE IF EXISTS roachdb;
DROP DATABASE IF EXISTS db2;
DROP ROLE IF EXISTS alice;
DROP ROLE IF EXISTS alter_policy_role;
DROP ROLE IF EXISTS aux1;
DROP ROLE IF EXISTS aux2;
DROP ROLE IF EXISTS bob;
DROP ROLE IF EXISTS buck;
DROP ROLE IF EXISTS bypassrls_user;
DROP ROLE IF EXISTS can_bypassrls;
DROP ROLE IF EXISTS can_bypassrls_global;
DROP ROLE IF EXISTS can_createdb;
DROP ROLE IF EXISTS can_createdb_global;
DROP ROLE IF EXISTS can_createrole;
DROP ROLE IF EXISTS can_createrole_global;
DROP ROLE IF EXISTS cannot_bypassrls;
DROP ROLE IF EXISTS cannot_createdb;
DROP ROLE IF EXISTS cannot_createrole;
DROP ROLE IF EXISTS child_role;
DROP ROLE IF EXISTS deleter;
DROP ROLE IF EXISTS fk_user;
DROP ROLE IF EXISTS forcer;
DROP ROLE IF EXISTS fred;
DROP ROLE IF EXISTS funuser;
DROP ROLE IF EXISTS ins;
DROP ROLE IF EXISTS john;
DROP ROLE IF EXISTS mc;
DROP ROLE IF EXISTS multi_user;
DROP ROLE IF EXISTS nontab_owner;
DROP ROLE IF EXISTS papa_roach;
DROP ROLE IF EXISTS parent_role;
DROP ROLE IF EXISTS pat;
DROP ROLE IF EXISTS r1_user;
DROP ROLE IF EXISTS rgb_only_user;
DROP ROLE IF EXISTS rls_cache_user;
DROP ROLE IF EXISTS sensitive_user;
DROP ROLE IF EXISTS tab_owner;
DROP ROLE IF EXISTS test_role1;
DROP ROLE IF EXISTS test_role2;
DROP ROLE IF EXISTS test_user1;
DROP ROLE IF EXISTS test_user2;
DROP ROLE IF EXISTS u1;
DROP ROLE IF EXISTS uniq_user;
DROP ROLE IF EXISTS ups;
DROP ROLE IF EXISTS user_158154;
DROP ROLE IF EXISTS z;
DROP ROLE IF EXISTS zeke;

SET ROLE root;

-- Keep track of the original DB so we can hop across databases and return.
SELECT current_database() AS orig_db \gset

-- CockroachDB `SHOW POLICIES` equivalent for PostgreSQL.
CREATE OR REPLACE FUNCTION pg_show_policies(target text)
RETURNS TABLE(
  name text,
  cmd text,
  type text,
  roles text,
  using_expr text,
  with_check_expr text
)
LANGUAGE SQL STABLE AS $$
  WITH parts AS (
    SELECT
      CASE
        WHEN strpos(target, '.') > 0 THEN split_part(target, '.', 1)
        ELSE current_schema()
      END AS schemaname,
      CASE
        WHEN strpos(target, '.') > 0 THEN split_part(target, '.', 2)
        ELSE target
      END AS tablename
  )
  SELECT
    policyname::text AS name,
    cmd::text AS cmd,
    permissive::text AS type,
    array_to_string(roles, ',') AS roles,
    COALESCE(qual, '')::text AS using_expr,
    COALESCE(with_check, '')::text AS with_check_expr
  FROM pg_policies p
  JOIN parts
    ON p.schemaname = parts.schemaname
   AND p.tablename = parts.tablename
  ORDER BY name;
$$;

-- Test 1: statement (line 8)
-- CockroachDB `CREATE DATABASE`/`USE` is unnecessary; each file already runs in its own database.
-- CREATE DATABASE db1;

-- Test 2: statement (line 11)
-- USE db1;  -- already connected to :orig_db

-- Test 3: statement (line 14)
-- GRANT ADMIN to testuser;

-- Test 4: statement (line 19)
CREATE TABLE sanity1();

-- Test 5: statement (line 22)
CREATE POLICY p1 on sanity1 USING (true);

-- Test 6: query (line 26)
-- select "eventType" from system.eventlog WHERE "eventType" <> 'finish_schema_change' order by timestamp desc limit 1;

-- Test 7: statement (line 31)
ALTER POLICY p1 ON sanity1 WITH CHECK (true);

-- Test 8: statement (line 34)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'sanity1' AND policyname = 'p1') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p1 on sanity1;
\else
CREATE POLICY p1 on sanity1;
\endif

-- Test 9: statement (line 37)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'sanity1' AND policyname = 'p2') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p2 on sanity1 AS PERMISSIVE WITH CHECK (true);
\else
CREATE POLICY p2 on sanity1 AS PERMISSIVE WITH CHECK (true);
\endif

-- onlyif config schema-locked-disabled

-- Test 10: query (line 41)
-- SHOW CREATE TABLE sanity1;

-- Test 11: query (line 52)
-- SHOW CREATE TABLE sanity1;

-- Test 12: statement (line 62)
DROP POLICY IF EXISTS notthere on nonexist;

-- Test 13: statement (line 65)
DROP POLICY IF EXISTS notthere on sanity1;

-- Test 14: statement (line 68)
\set ON_ERROR_STOP 0
DROP POLICY notthere on sanity1;
\set ON_ERROR_STOP 0

-- Test 15: statement (line 71)
DROP POLICY p1 on sanity1;

-- Test 16: query (line 75)
-- select "eventType" from system.eventlog WHERE "eventType" <> 'finish_schema_change' order by timestamp desc limit 1;

-- Test 17: statement (line 80)
DROP POLICY p2 on sanity1;

-- Test 18: statement (line 83)
CREATE POLICY newp1 on sanity1 AS PERMISSIVE USING (true) WITH CHECK (true);

-- Test 19: statement (line 86)
DROP TABLE sanity1;

-- Test 20: statement (line 91)
CREATE TABLE explicit1();

-- Test 21: statement (line 94)
-- SET use_declarative_schema_changer = 'unsafe_always';

-- Test 22: statement (line 97)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 23: statement (line 100)
CREATE POLICY p1 on explicit1;

-- Test 24: statement (line 103)
DROP POLICY p1 on explicit1;

-- Test 25: statement (line 106)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'explicit1' AND policyname = 'p1') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p1 on explicit1 AS PERMISSIVE USING (false);
\else
CREATE POLICY p1 on explicit1 AS PERMISSIVE USING (false);
\endif

-- Test 26: statement (line 109)
COMMIT;

-- Test 27: statement (line 112)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Test 28: statement (line 115)
DROP POLICY p1 on explicit1;

-- Test 29: statement (line 118)
CREATE POLICY p1 on explicit1 USING (false) WITH CHECK (true);

-- Test 30: statement (line 121)
COMMIT;

-- Test 31: statement (line 124)
DROP TABLE explicit1;

-- Test 32: statement (line 127)
-- SET use_declarative_schema_changer = $use_decl_sc;

-- Test 33: statement (line 132)
CREATE TABLE multi_pol_tab1 (c1 INT NOT NULL PRIMARY KEY);

-- Test 34: statement (line 135)
CREATE POLICY "policy1" ON multi_pol_tab1 AS PERMISSIVE;

-- Test 35: statement (line 138)
CREATE POLICY "policy2" ON multi_pol_tab1 AS RESTRICTIVE;

-- Test 36: statement (line 141)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'multi_pol_tab1' AND policyname = 'policy3') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS "policy3" ON multi_pol_tab1 FOR ALL
\else
CREATE POLICY "policy3" ON multi_pol_tab1 FOR ALL;
\endif

-- Test 37: statement (line 144)
CREATE POLICY "policy4" ON multi_pol_tab1 FOR INSERT;

-- Test 38: statement (line 147)
CREATE POLICY "policy5" ON multi_pol_tab1 FOR UPDATE;

-- Test 39: statement (line 150)
CREATE POLICY "policy6" ON multi_pol_tab1 FOR DELETE;

-- Test 40: statement (line 153)
CREATE POLICY "policy7" ON multi_pol_tab1 FOR SELECT;

-- Test 41: statement (line 156)
CREATE USER papa_roach;

-- Test 42: statement (line 159)
CREATE POLICY "policy8" ON multi_pol_tab1 FOR ALL TO papa_roach, public;

-- onlyif config schema-locked-disabled

-- Test 43: query (line 163)
-- SHOW CREATE TABLE multi_pol_tab1

-- Test 44: query (line 180)
-- SHOW CREATE TABLE multi_pol_tab1

-- Test 45: query (line 209)
select schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check from pg_catalog.pg_policies;

-- Test 46: query (line 222)
SELECT * FROM pg_show_policies('multi_pol_tab1');

-- Test 47: statement (line 235)
CREATE DATABASE roachdb;

-- Test 48: statement (line 238)
\connect roachdb
SET client_min_messages = warning;
SET ROLE root;

-- Test 49: query (line 241)
select schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check from pg_catalog.pg_policies;

-- Test 50: statement (line 246)
\connect :orig_db
SET client_min_messages = warning;
SET ROLE root;

-- Test 51: statement (line 249)
DROP DATABASE roachdb;

-- Test 52: statement (line 252)
CREATE TABLE multi_pol_tab2 (c1 INT NOT NULL PRIMARY KEY);

-- Test 53: statement (line 255)
CREATE POLICY "policy9" ON multi_pol_tab2 FOR ALL;

-- Test 54: statement (line 258)
CREATE POLICY "policy10" ON multi_pol_tab2 FOR ALL;

-- Test 55: statement (line 261)
CREATE TABLE multi_pol_tab3 (c1 INT NOT NULL PRIMARY KEY);

-- Test 56: statement (line 264)
CREATE POLICY "policy11" ON multi_pol_tab3 FOR ALL;

-- Test 57: statement (line 267)
CREATE POLICY "policy12" ON multi_pol_tab3 FOR ALL;

-- skipif config fakedist-vec-off local-vec-off

-- Test 58: query (line 289)
select schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check from pg_catalog.pg_policies where tablename = 'multi_pol_tab2';

-- Test 59: query (line 303)
select schemaname, tablename, policyname, permissive, roles, cmd, qual, with_check from pg_catalog.pg_policies where tablename = 'multi_pol_tab3';

-- Test 60: query (line 310)
SELECT * FROM pg_show_policies('multi_pol_tab2');

-- Test 61: query (line 317)
SELECT * FROM pg_show_policies('public.multi_pol_tab3');

-- Test 62: statement (line 324)
DROP POLICY "policy1" ON multi_pol_tab1;

-- Test 63: statement (line 327)
DROP POLICY "policy3" ON multi_pol_tab1;

-- Test 64: statement (line 330)
DROP POLICY "policy5" ON multi_pol_tab1;

-- onlyif config schema-locked-disabled

-- Test 65: query (line 334)
-- SHOW CREATE TABLE multi_pol_tab1

-- Test 66: query (line 348)
-- SHOW CREATE TABLE multi_pol_tab1

-- Test 67: statement (line 361)
DROP POLICY "policy9" ON multi_pol_tab2;

-- Test 68: statement (line 364)
DROP POLICY "policy10" ON multi_pol_tab2;

-- Test 69: statement (line 367)
DROP POLICY "policy11" ON multi_pol_tab3;

-- Test 70: statement (line 370)
DROP POLICY "policy12" ON multi_pol_tab3;

-- Test 71: statement (line 373)
DROP TABLE multi_pol_tab1;

-- Test 72: statement (line 376)
DROP TABLE multi_pol_tab2;

-- Test 73: statement (line 379)
DROP TABLE multi_pol_tab3;

-- Test 74: statement (line 384)
CREATE TABLE drop_role_chk();

-- Test 75: statement (line 387)
CREATE USER fred;

-- Test 76: statement (line 390)
CREATE USER bob;

-- Test 77: statement (line 393)
CREATE POLICY p1 on drop_role_chk to fred,bob;

-- Test 78: statement (line 396)
DROP POLICY p1 on drop_role_chk;

-- Test 81: statement (line 405)
DROP ROLE bob,fred;

-- Test 82: statement (line 408)
DROP TABLE drop_role_chk;

-- Test 83: statement (line 413)
CREATE TABLE role_exist_chk();

-- Test 84: statement (line 416)
-- Postgres requires policy roles to exist.
CREATE USER zeke;

SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'role_exist_chk' AND policyname = 'p1') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p1 on role_exist_chk to zeke;
\else
CREATE POLICY p1 on role_exist_chk to zeke;
\endif

-- Test 85: statement (line 419)
-- (created above)

-- Test 86: statement (line 422)
ALTER POLICY p1 ON role_exist_chk TO zeke;

-- Test 87: statement (line 425)
DROP TABLE role_exist_chk;

-- Test 88: statement (line 428)
DROP ROLE zeke;

-- Test 89: statement (line 433)
CREATE TABLE target();

-- Test 90: statement (line 436)
CREATE USER john;

GRANT john TO testuser;

-- Test 91: statement (line 439)
-- GRANT ALL ON db1.* to testuser;
GRANT ALL PRIVILEGES ON DATABASE :"orig_db" TO testuser;
GRANT ALL PRIVILEGES ON SCHEMA public TO testuser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO testuser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO testuser;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO testuser;

-- Test 92: statement (line 442)
-- GRANT ALL ON db1.* to john;
GRANT ALL PRIVILEGES ON DATABASE :"orig_db" TO john;
GRANT ALL PRIVILEGES ON SCHEMA public TO john;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO john;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO john;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO john;

-- Test 93: statement (line 445)
ALTER TABLE target OWNER TO john;

-- Test 94: statement (line 448)
-- GRANT SYSTEM MODIFYCLUSTERSETTING TO testuser;

-- user testuser
SET SESSION AUTHORIZATION testuser;

-- Test 95: statement (line 453)
-- USE db1;  -- already connected to :orig_db

-- Test 96: statement (line 456)
SET ROLE john;

-- Test 97: query (line 459)
SELECT current_user, session_user;

-- Test 98: statement (line 464)
CREATE POLICY pol on target TO current_user,session_user;

-- onlyif config schema-locked-disabled

-- Test 99: query (line 468)
-- SHOW CREATE TABLE target

-- Test 100: query (line 478)
-- SHOW CREATE TABLE target

-- Test 101: statement (line 489)
-- USE db1;  -- already connected to :orig_db

-- Test 102: query (line 492)
SELECT current_user, session_user;

-- Test 103: statement (line 497)
RESET SESSION AUTHORIZATION;

-- Test 104: statement (line 500)
DROP TABLE target;

REVOKE ALL PRIVILEGES ON DATABASE :"orig_db" FROM testuser, john;
REVOKE ALL PRIVILEGES ON SCHEMA public FROM testuser, john;
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM testuser, john;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM testuser, john;
REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM testuser, john;

DROP ROLE john;
DROP ROLE testuser;

-- Test 107: statement (line 511)
CREATE TYPE greeting AS ENUM ('hello', 'hi', 'howdy');

-- Test 108: statement (line 514)
CREATE TABLE z1 (c1 text);

-- Test 109: statement (line 517)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'z1' AND policyname = 'p1') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p1 on z1 WITH CHECK (c1::greeting = 'hi'::greeting);
\else
CREATE POLICY p1 on z1 WITH CHECK (c1::greeting = 'hi'::greeting);
\endif

-- Test 110: query (line 520)
select polwithcheck from pg_catalog.pg_policy;

-- Test 111: query (line 525)
select with_check_expr from pg_show_policies('z1');

-- Test 112: statement (line 530)
\set ON_ERROR_STOP 0
DROP TYPE greeting;
\set ON_ERROR_STOP 0

-- Test 113: statement (line 533)
-- SET use_declarative_schema_changer = 'off';

-- Test 114: statement (line 536)
\set ON_ERROR_STOP 0
DROP TYPE greeting;
\set ON_ERROR_STOP 0

-- Test 115: statement (line 539)
-- SET use_declarative_schema_changer = $use_decl_sc;

-- Test 116: statement (line 542)
DROP POLICY p1 on z1;

-- Test 117: statement (line 545)
DROP TYPE greeting;

-- Test 118: statement (line 548)
\set ON_ERROR_STOP 0
CREATE POLICY p1 on z1 WITH CHECK (c1::greeting = 'hi'::greeting);
\set ON_ERROR_STOP 0

-- Test 119: statement (line 551)
DROP TABLE z1;

-- Test 120: statement (line 556)
CREATE SEQUENCE seq1;

-- Test 121: statement (line 559)
CREATE TABLE pws ();

-- Test 122: statement (line 562)
CREATE POLICY p1 on pws AS RESTRICTIVE WITH CHECK (nextval('seq1') < 100);

-- Test 123: statement (line 565)
\set ON_ERROR_STOP 0
DROP SEQUENCE seq1;
\set ON_ERROR_STOP 0

-- Test 124: statement (line 568)
DROP POLICY p1 on pws;

-- Test 125: statement (line 571)
DROP SEQUENCE seq1;

-- Test 126: statement (line 574)
DROP TABLE pws;

-- Test 127: statement (line 579)
CREATE FUNCTION is_valid(n INT) RETURNS BOOL AS $$
BEGIN
  RETURN n < 10;
END;
$$ LANGUAGE PLpgSQL;

-- Test 128: statement (line 586)
CREATE TABLE funcref (c1 int);

-- Test 129: statement (line 589)
CREATE POLICY pol1 on funcref USING (is_valid(c1)) WITH CHECK (is_valid(c1));

-- Test 130: query (line 592)
select polqual from pg_catalog.pg_policy;

-- Test 131: query (line 597)
select using_expr from pg_show_policies('funcref');

-- Test 132: query (line 602)
select qual, with_check from pg_catalog.pg_policies where tablename = 'funcref';

-- Test 133: statement (line 608)
\set ON_ERROR_STOP 0
DROP FUNCTION is_valid;
\set ON_ERROR_STOP 0

-- Test 134: statement (line 611)
DROP POLICY pol1 on funcref;

-- Test 135: statement (line 614)
DROP FUNCTION is_valid;

-- Test 136: statement (line 617)
DROP TABLE funcref;

-- Test 137: statement (line 622)
CREATE TABLE colref (rename_c1 INT, rename_c2 INT, C3 INT);

-- Test 138: statement (line 625)
CREATE POLICY p1 ON colref USING (rename_c1 < 10);

-- Test 139: statement (line 628)
CREATE POLICY p2 ON colref WITH CHECK (rename_c2 < 100);

-- Test 140: statement (line 632)
ALTER TABLE colref RENAME COLUMN rename_c1 to c1;

-- Test 141: statement (line 635)
ALTER TABLE colref DROP COLUMN c1;

-- Test 142: statement (line 638)
-- SET use_declarative_schema_changer = 'off';

-- skipif config schema-locked-disabled

-- Test 143: statement (line 642)
ALTER TABLE colref SET (schema_locked=false);

-- Test 144: statement (line 645)
ALTER TABLE colref DROP COLUMN c1;


-- skipif config schema-locked-disabled

-- Test 145: statement (line 650)
ALTER TABLE colref RESET (schema_locked);

-- Test 146: statement (line 653)
-- SET use_declarative_schema_changer = $use_decl_sc;

-- Test 147: statement (line 656)
ALTER TABLE colref ALTER COLUMN c1 SET DATA TYPE TEXT USING c1::text;

-- Test 148: statement (line 659)
DROP POLICY p1 ON colref;

-- Test 149: statement (line 662)
ALTER TABLE colref ALTER COLUMN c1 SET DATA TYPE TEXT USING c1::text;

-- Test 150: statement (line 665)
ALTER TABLE colref DROP COLUMN c1;

-- Test 151: statement (line 669)
ALTER TABLE colref RENAME COLUMN rename_c2 TO c2;

-- Test 152: statement (line 672)
ALTER TABLE colref DROP COLUMN c2;

-- Test 153: statement (line 675)
-- SET use_declarative_schema_changer = 'off';

-- skipif config schema-locked-disabled

-- Test 154: statement (line 679)
ALTER TABLE colref SET (schema_locked=false);

-- Test 155: statement (line 682)
ALTER TABLE colref DROP COLUMN c2;

-- skipif config schema-locked-disabled

-- Test 156: statement (line 686)
ALTER TABLE colref RESET (schema_locked);

-- Test 157: statement (line 689)
-- SET use_declarative_schema_changer = $use_decl_sc;

-- Test 158: statement (line 692)
ALTER TABLE colref ALTER COLUMN c2 SET DATA TYPE TEXT USING c2::text;

-- Test 159: statement (line 695)
DROP POLICY p2 ON colref;

-- Test 160: statement (line 698)
ALTER TABLE colref ALTER COLUMN c2 SET DATA TYPE TEXT USING c2::text;

-- Test 161: statement (line 701)
ALTER TABLE colref DROP COLUMN c2;

-- Test 162: statement (line 704)
DROP TABLE colref;

-- Test 163: statement (line 710)
CREATE FUNCTION f() RETURNS BOOL LANGUAGE SQL AS $$ SELECT true; $$;

-- Test 164: statement (line 713)
CREATE TABLE t (x INT, y INT, b BOOL DEFAULT f());

-- Test 165: statement (line 716)
CREATE POLICY p ON t USING (f());

-- Test 166: query (line 719)
SELECT jsonb_pretty(crdb_internal.pb_to_json('descriptor', descriptor)->'function'->'dependedOnBy') as dependedOnBy
FROM system.descriptor
WHERE id = (select 'f'::REGPROC::INT - 100000);

-- Test 167: statement (line 737)
ALTER TABLE t DROP COLUMN b;

-- Test 168: query (line 740)
SELECT jsonb_pretty(crdb_internal.pb_to_json('descriptor', descriptor)->'function'->'dependedOnBy') as dependedOnBy
FROM system.descriptor
WHERE id = (select 'f'::REGPROC::INT - 100000);

-- Test 169: query (line 754)
SELECT f();

-- Test 170: statement (line 759)
DROP TABLE t;

-- Test 171: statement (line 762)
DROP FUNCTION f;

-- Test 172: statement (line 767)
CREATE TABLE t1 (c1 int);

-- Test 173: statement (line 770)
CREATE TABLE t2 (c1 int);

-- Test 174: statement (line 773)
CREATE POLICY p1 on t1 USING (c1 < (select max(c1) from t1));

-- Test 175: statement (line 776)
CREATE POLICY p1 on t1 WITH CHECK (c1 < (select max(c1) from t1));

-- Test 176: statement (line 779)
DROP TABLE t1;

-- Test 177: statement (line 782)
DROP TABLE t2;

-- Test 178: statement (line 787)
create type roach_type as enum('flying','crawling');

-- Test 179: statement (line 790)
create table flying_roaches (check ('flying'::roach_type = 'crawling'::roach_type));

-- Test 180: statement (line 793)
create policy p1 on flying_roaches using ('flying'::roach_type = 'crawling'::roach_type);

-- onlyif config schema-locked-disabled

-- Test 181: query (line 797)
-- SHOW CREATE TABLE flying_roaches

-- Test 182: query (line 808)
-- SHOW CREATE TABLE flying_roaches

-- Test 183: query (line 819)
select create_statement from crdb_internal.create_statements where descriptor_name='flying_roaches';

-- Test 184: query (line 829)
select create_statement from crdb_internal.create_statements where descriptor_name='flying_roaches';

-- Test 185: query (line 838)
select rls_statements from crdb_internal.create_statements where descriptor_name='flying_roaches';

-- Test 186: query (line 843)
select fk_statements from crdb_internal.create_statements where descriptor_name='flying_roaches';

-- Test 187: statement (line 848)
drop table flying_roaches;

-- Test 188: statement (line 851)
drop type roach_type;

-- Test 189: statement (line 856)
CREATE TABLE ins (c1 INT);

-- Test 190: statement (line 859)
CREATE USER ins;

-- Test 191: statement (line 862)
CREATE TABLE other (k INT PRIMARY KEY);

-- Test 192: statement (line 865)
INSERT INTO other VALUES (99);

-- Test 193: statement (line 868)
GRANT ALL ON other TO ins;

-- Test 194: statement (line 871)
ALTER TABLE ins OWNER TO ins;

-- Test 195: statement (line 874)
SET ROLE ins;

-- Test 196: statement (line 877)
CREATE POLICY p_ins ON ins FOR INSERT WITH CHECK (c1 > 0);

-- Test 197: statement (line 880)
CREATE POLICY p_sel ON ins FOR SELECT USING (c1 % 2 = 0);

-- Test 198: statement (line 883)
ALTER TABLE ins FORCE ROW LEVEL SECURITY, ENABLE ROW LEVEL SECURITY;

-- Test 199: statement (line 887)
INSERT INTO ins VALUES (1),(2),(3),(4);

-- Test 200: statement (line 892)
INSERT INTO ins VALUES (1),(2),(3),(4) RETURNING c1;

-- Test 201: statement (line 895)
INSERT INTO ins VALUES (5) RETURNING *;

-- Test 202: statement (line 898)
INSERT INTO ins VALUES (7) RETURNING (select ins.c1);

-- Test 203: query (line 901)
INSERT INTO ins VALUES (9) RETURNING 'foo';

-- Test 204: query (line 906)
INSERT INTO ins VALUES (11) RETURNING (select 1);

-- Test 205: query (line 911)
INSERT INTO ins VALUES (13) RETURNING (SELECT k FROM other);

-- Test 206: statement (line 916)
CREATE FUNCTION insert_15(n INT) RETURNS INT AS $$
  INSERT INTO ins VALUES (15) RETURNING n;
$$ LANGUAGE SQL;

-- Test 207: query (line 921)
SELECT insert_15(0);

-- Test 208: statement (line 926)
DROP FUNCTION insert_15;

-- Test 209: statement (line 930)
INSERT INTO ins VALUES (2),(4) RETURNING c1;

-- Test 210: statement (line 934)
INSERT INTO ins VALUES (2),(4),(-2),(-4) RETURNING c1;

-- Test 211: statement (line 937)
SET ROLE root;

-- Test 212: statement (line 940)
DROP TABLE ins;

-- Test 213: statement (line 943)
DROP TABLE other;

-- Test 214: statement (line 946)
DROP USER ins;

-- Test 215: statement (line 951)
-- SET use_declarative_schema_changer = 'off';

-- Test 216: statement (line 954)
CREATE TABLE roaches();

-- Test 217: statement (line 957)
ALTER TABLE roaches SET (schema_locked=false);

-- Test 218: statement (line 960)
ALTER TABLE roaches ENABLE ROW LEVEL SECURITY;

-- Test 219: statement (line 963)
ALTER TABLE roaches RESET (schema_locked);

-- Test 220: statement (line 966)
-- SET use_declarative_schema_changer = $use_decl_sc;

-- Test 221: statement (line 971)
ALTER TABLE roaches ENABLE ROW LEVEL SECURITY;

-- onlyif config schema-locked-disabled

-- Test 222: query (line 975)
-- SHOW CREATE TABLE roaches

-- Test 223: query (line 985)
-- SHOW CREATE TABLE roaches

-- Test 224: statement (line 994)
ALTER TABLE roaches DISABLE ROW LEVEL SECURITY;

-- Test 225: query (line 997)
select relname, relrowsecurity, relforcerowsecurity from pg_class where relname = 'roaches';

-- Test 226: query (line 1003)
-- SHOW CREATE TABLE roaches

-- Test 227: query (line 1012)
-- SHOW CREATE TABLE roaches

-- Test 228: statement (line 1022)
ALTER TABLE roaches FORCE ROW LEVEL SECURITY;

-- Test 229: query (line 1025)
select relname, relrowsecurity, relforcerowsecurity from pg_class where relname = 'roaches';

-- Test 230: query (line 1031)
-- SHOW CREATE TABLE roaches

-- Test 231: query (line 1041)
-- SHOW CREATE TABLE roaches

-- Test 232: statement (line 1050)
ALTER TABLE roaches NO FORCE ROW LEVEL SECURITY;

-- Test 233: query (line 1053)
select relname, relrowsecurity, relforcerowsecurity from pg_class where relname = 'roaches';

-- Test 234: query (line 1059)
-- SHOW CREATE TABLE roaches

-- Test 235: query (line 1068)
-- SHOW CREATE TABLE roaches

-- Test 236: statement (line 1078)
ALTER TABLE roaches ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- onlyif config schema-locked-disabled

-- Test 237: query (line 1082)
-- SHOW CREATE TABLE roaches

-- Test 238: query (line 1092)
-- SHOW CREATE TABLE roaches

-- Test 239: query (line 1102)
select relname, relrowsecurity, relforcerowsecurity from pg_class where relname = 'roaches';

-- Test 240: query (line 1108)
select create_statement from crdb_internal.create_statements where descriptor_name='roaches';

-- Test 241: query (line 1117)
select create_statement from crdb_internal.create_statements where descriptor_name='roaches';

-- Test 242: query (line 1125)
select rls_statements, fk_statements, create_nofks from crdb_internal.create_statements where descriptor_name='roaches';

-- Test 243: statement (line 1133)
ALTER TABLE roaches DISABLE ROW LEVEL SECURITY, NO FORCE ROW LEVEL SECURITY;

-- onlyif config schema-locked-disabled

-- Test 244: query (line 1137)
-- SHOW CREATE TABLE roaches

-- Test 245: query (line 1146)
-- SHOW CREATE TABLE roaches

-- Test 246: query (line 1154)
select rls_statements from crdb_internal.create_statements where descriptor_name='roaches';

-- Test 247: query (line 1159)
select fk_statements from crdb_internal.create_statements where descriptor_name='roaches';

-- Test 248: statement (line 1164)
DROP TABLE roaches;

-- Test 249: statement (line 1169)
CREATE TYPE league AS ENUM('AL','NL');

-- Test 250: statement (line 1172)
CREATE TABLE bbteams (team text, league league);

-- Test 251: statement (line 1175)
ALTER TABLE bbteams ENABLE ROW LEVEL SECURITY;

-- Test 252: statement (line 1178)
INSERT INTO bbteams VALUES ('jays', 'AL'), ('tigers', 'AL'), ('cardinals', 'NL'), ('orioles', 'AL'), ('nationals', 'NL');

-- Test 253: query (line 1182)
select team, league from bbteams order by league, team;

-- Test 254: statement (line 1191)
CREATE USER buck;

-- Test 255: statement (line 1194)
GRANT ALL ON bbteams TO buck;

-- Test 256: statement (line 1197)
set role buck;

-- Test 257: query (line 1201)
select team, league from bbteams order by league, team;

-- Test 258: statement (line 1205)
set role root;

-- Test 259: statement (line 1211)
CREATE FUNCTION is_valid(l league) RETURNS BOOL AS $$
BEGIN
  RETURN l = 'AL';
END;
$$ LANGUAGE PLpgSQL;

-- Test 260: statement (line 1218)
CREATE SEQUENCE seq1;

-- Test 261: statement (line 1221)
GRANT USAGE ON seq1 TO buck;

-- Test 262: statement (line 1224)
create policy restrict_select on bbteams for select to buck,current_user,session_user using (is_valid(league) and nextval('seq1') < 1000);

-- Test 263: query (line 1227)
select using_expr from pg_show_policies('bbteams');

-- Test 264: query (line 1233)
select team, league from bbteams where team != 'cardinals' order by league, team;

-- Test 265: statement (line 1241)
set role buck;

-- Test 266: query (line 1245)
select team, league from bbteams where team != 'cardinals' order by league, team;

-- Test 267: query (line 1253)
select team, league from bbteams where team != 'astros' order by league, team;

-- Test 268: statement (line 1261)
set role root;

-- Test 269: statement (line 1264)
-- GRANT admin TO buck;

-- Test 270: statement (line 1267)
set role buck;

-- Test 271: query (line 1271)
select team, league from bbteams where team != 'astros' order by league, team;

-- Test 272: query (line 1281)
select team, league from bbteams where team != 'mariners' order by league, team;

-- Test 273: statement (line 1290)
set role root;

-- Test 274: statement (line 1293)
REVOKE admin FROM buck;

-- Test 275: statement (line 1296)
set role buck;

-- Test 276: query (line 1300)
select team, league from bbteams where team != 'mariners' order by league, team;

-- Test 277: statement (line 1307)
set role root;

-- Test 278: statement (line 1311)
CREATE POLICY restrict_insert ON bbteams FOR INSERT TO buck WITH CHECK (false);

-- Test 279: statement (line 1314)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'bbteams' AND policyname = 'restrict_delete') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS restrict_delete ON bbteams FOR DELETE TO buck USING (false);
\else
CREATE POLICY restrict_delete ON bbteams FOR DELETE TO buck USING (false);
\endif

-- Test 280: statement (line 1317)
CREATE POLICY restrict_update ON bbteams FOR UPDATE TO buck USING (false);

-- Test 281: statement (line 1320)
set role buck;

-- Test 282: query (line 1324)
select team, league from bbteams where team != 'jays' order by league, team;

-- Test 283: statement (line 1331)
UPDATE bbteams SET team = 'blue jays' where team = 'jays';

-- Test 284: query (line 1334)
select team, league from bbteams order by league, team;

-- Test 285: statement (line 1342)
set role root;

-- Test 286: statement (line 1345)
DROP POLICY restrict_update on bbteams;

-- Test 287: statement (line 1348)
create policy restrict_update on bbteams for update to buck using (is_valid(league) and nextval('seq1') < 1000);

-- Test 288: statement (line 1351)
set role buck;

-- Test 289: statement (line 1355)
UPDATE bbteams SET team = 'Jays' where team = 'jays';

-- Test 290: statement (line 1359)
UPDATE bbteams SET team = 'Nationals' where team = 'nationals';

-- Test 291: statement (line 1362)
set role root;

-- Test 292: query (line 1365)
select team, league from bbteams where team in ('jays', 'Jays', 'nationals', 'Nationals') order by league, team;

-- Test 293: statement (line 1371)
set role buck;

-- Test 294: statement (line 1375)
DELETE FROM bbteams;

-- Test 295: query (line 1378)
select team, league from bbteams order by league, team;

-- Test 296: statement (line 1386)
set role root;

-- Test 297: statement (line 1389)
DROP POLICY restrict_delete on bbteams;

-- Test 298: statement (line 1392)
create policy restrict_delete on bbteams for delete to buck using (is_valid(league) and team = 'tigers' and nextval('seq1') < 1000);

-- Test 299: statement (line 1395)
set role buck;

-- Test 300: statement (line 1398)
DELETE FROM bbteams WHERE team != 'pirates';

-- Test 301: query (line 1401)
select team, league from bbteams where team != 'pirates' order by league, team;

-- Test 302: query (line 1408)
-- SHOW CREATE TABLE bbteams

-- Test 303: query (line 1425)
-- SHOW CREATE TABLE bbteams

-- Test 304: statement (line 1441)
set role root;

-- Test 305: statement (line 1444)
DROP TABLE bbteams;

-- Test 306: statement (line 1447)
DROP SEQUENCE seq1;

-- Test 307: statement (line 1450)
DROP FUNCTION is_valid;

-- Test 308: statement (line 1456)
CREATE DATABASE db2;

-- Test 309: statement (line 1459)
\connect db2
SET client_min_messages = warning;
SET ROLE root;

-- Test 310: statement (line 1462)
CREATE TYPE classes AS ENUM('mammals','birds', 'fish', 'reptiles', 'amphibians');

-- Test 311: statement (line 1465)
CREATE TABLE animals (name text, class classes);

-- Test 312: statement (line 1468)
ALTER TABLE animals ENABLE ROW LEVEL SECURITY;

-- Test 313: statement (line 1471)
create policy p1 on animals for select to current_user using (class in ('mammals','birds'));

-- Test 314: statement (line 1474)
\connect :orig_db
SET client_min_messages = warning;
SET ROLE root;

-- Test 315: statement (line 1477)
DROP DATABASE db2;

-- Test 316: statement (line 1483)
CREATE USER sensitive_user;

-- Test 317: statement (line 1486)
CREATE TABLE sensitive_data_table (C1 INT);

-- Test 318: statement (line 1489)
INSERT INTO sensitive_data_table VALUES (0),(1),(2);

-- Test 319: statement (line 1492)
ALTER TABLE sensitive_data_table ENABLE ROW LEVEL SECURITY;

-- Test 320: statement (line 1495)
GRANT ALL ON sensitive_data_table TO sensitive_user;

-- Test 321: statement (line 1498)
CREATE FUNCTION my_sec_definer_reader_function() RETURNS TABLE(ID INT)
LANGUAGE SQL AS
$$
 SELECT * FROM sensitive_data_table
$$ SECURITY DEFINER;

-- Test 322: statement (line 1505)
CREATE FUNCTION my_non_sec_definer_reader_function() RETURNS TABLE(ID INT)
LANGUAGE SQL AS
$$
 SELECT * FROM sensitive_data_table
$$;

-- Test 323: statement (line 1512)
CREATE FUNCTION my_sec_definer_inserter_function(v INT) RETURNS VOID
LANGUAGE SQL AS
$$
 INSERT INTO sensitive_data_table VALUES (v)
$$ SECURITY DEFINER;

-- Test 324: statement (line 1519)
CREATE FUNCTION my_non_sec_definer_inserter_function(v INT) RETURNS VOID
LANGUAGE SQL AS
$$
 INSERT INTO sensitive_data_table VALUES (v)
$$;

-- Test 325: statement (line 1527)
CREATE FUNCTION my_sec_definer_updater_function(v INT) RETURNS VOID
LANGUAGE SQL AS
$$
 UPDATE sensitive_data_table SET c1=v*2 WHERE c1 = v
$$ SECURITY DEFINER;

-- Test 326: statement (line 1534)
CREATE FUNCTION my_non_sec_definer_updater_function(v INT) RETURNS VOID
LANGUAGE SQL AS
$$
 UPDATE sensitive_data_table SET c1=v*2 WHERE c1 = v
$$;

-- Test 327: statement (line 1541)
SET ROLE sensitive_user;

-- Test 328: query (line 1544)
SELECT * FROM sensitive_data_table;

-- Test 329: query (line 1548)
select my_sec_definer_inserter_function(10);

-- Test 330: query (line 1553)
select my_sec_definer_updater_function(2);

-- Test 331: query (line 1558)
SELECT my_sec_definer_reader_function();

-- Test 332: query (line 1566)
SELECT my_non_sec_definer_reader_function();
-- -----

-- statement error pq: new row violates row-level security policy for table "sensitive_data_table"
\set ON_ERROR_STOP 0
select my_non_sec_definer_inserter_function(20);
\set ON_ERROR_STOP 0

-- No error from the update because the lack of policies won't read any rows to
-- update. We verify nothing has changed right after.
-- query I
select my_non_sec_definer_updater_function(4);

-- Test 333: query (line 1580)
SELECT my_sec_definer_reader_function();

-- Test 334: statement (line 1588)
SET ROLE root;

-- Test 335: statement (line 1591)
CREATE POLICY p1 ON sensitive_data_table FOR SELECT TO sensitive_user USING (C1 != 0);

-- Test 336: statement (line 1594)
SET ROLE sensitive_user;

-- Test 337: query (line 1597)
SELECT my_sec_definer_reader_function();

-- Test 338: query (line 1605)
SELECT my_non_sec_definer_reader_function();

-- Test 339: statement (line 1612)
SET ROLE root;

-- Test 340: statement (line 1615)
CREATE POLICY p2 ON sensitive_data_table FOR INSERT TO sensitive_user WITH CHECK (C1 != 55);

-- Test 341: statement (line 1618)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'sensitive_data_table' AND policyname = 'p3') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p3 ON sensitive_data_table FOR UPDATE TO sensitive_user USING (true) WITH CHECK (C1 >= 10);
\else
CREATE POLICY p3 ON sensitive_data_table FOR UPDATE TO sensitive_user USING (true) WITH CHECK (C1 >= 10);
\endif

-- Test 342: statement (line 1621)
SET ROLE sensitive_user;

-- Test 343: statement (line 1625)
select my_non_sec_definer_inserter_function(55);

-- Test 344: query (line 1628)
select my_non_sec_definer_inserter_function(54);

-- Test 345: statement (line 1634)
select my_non_sec_definer_updater_function(4);

-- Test 346: query (line 1637)
select my_non_sec_definer_updater_function(10);

-- Test 347: query (line 1642)
SELECT my_sec_definer_reader_function();

-- Test 348: statement (line 1651)
SET ROLE root;

-- Test 349: statement (line 1654)
DROP FUNCTION my_sec_definer_reader_function;

-- Test 350: statement (line 1657)
DROP FUNCTION my_non_sec_definer_reader_function;

-- Test 351: statement (line 1660)
DROP TABLE sensitive_data_table CASCADE;

-- Test 352: statement (line 1665)
CREATE TABLE alter_policy_table (c1 INT NOT NULL PRIMARY KEY, c2 TEXT);

-- Test 353: statement (line 1668)
ALTER TABLE alter_policy_table ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 354: statement (line 1671)
CREATE ROLE alter_policy_role;

-- Test 355: statement (line 1674)
CREATE ROLE aux1;

-- Test 356: statement (line 1677)
CREATE USER aux2;

-- Test 357: statement (line 1680)
CREATE SEQUENCE seq1;

-- Test 358: statement (line 1683)
GRANT ALL ON seq1 TO alter_policy_role;

-- Test 359: statement (line 1686)
ALTER TABLE alter_policy_table OWNER TO alter_policy_role;

-- Test 360: statement (line 1689)
SET ROLE alter_policy_role;

-- Test 361: statement (line 1692)
CREATE POLICY p ON alter_policy_table FOR INSERT WITH CHECK (false);

-- Test 362: statement (line 1695)
INSERT INTO alter_policy_table VALUES (1, 'one'), (2, 'two'), (3, 'three');

-- Test 363: statement (line 1698)
ALTER POLICY p ON alter_policy_table USING (true);

-- Test 364: statement (line 1701)
ALTER POLICY p ON alter_policy_table WITH CHECK (nextval('seq1') < 10000);

-- Test 365: statement (line 1704)
INSERT INTO alter_policy_table VALUES (1, 'one'), (2, 'two'), (3, 'three');

-- Test 366: query (line 1707)
SELECT c1 FROM alter_policy_table ORDER BY c1;

-- Test 367: statement (line 1711)
ALTER POLICY p ON alter_policy_table RENAME TO p_ins;

-- Test 368: statement (line 1714)
CREATE POLICY p ON alter_policy_table FOR SELECT TO aux1 USING (c1 > 0);

-- Test 369: query (line 1717)
SELECT c1 FROM alter_policy_table ORDER BY c1;

-- Test 370: statement (line 1721)
ALTER POLICY p_sel ON alter_policy_table WITH CHECK (true);

-- Test 371: statement (line 1724)
ALTER POLICY p ON alter_policy_table WITH CHECK (true);

-- Test 372: statement (line 1727)
ALTER POLICY p ON alter_policy_table TO alter_policy_role,aux1,aux2 USING (c1 != 1);

-- Test 373: query (line 1730)
SELECT c1 FROM alter_policy_table ORDER BY c1;

-- Test 374: statement (line 1736)
ALTER POLICY p ON alter_policy_table RENAME TO p_sel;

-- skipif config schema-locked-disabled

-- Test 375: query (line 1740)
-- SHOW CREATE TABLE alter_policy_table;

-- Test 376: query (line 1754)
-- SHOW CREATE TABLE alter_policy_table;

-- Test 377: query (line 1767)
SELECT name,cmd,type,roles,using_expr,with_check_expr
FROM pg_show_policies('alter_policy_table')
ORDER BY name DESC;

-- Test 378: statement (line 1776)
SET ROLE root;

-- Test 379: statement (line 1779)
DROP SEQUENCE seq1;

-- Test 380: statement (line 1783)
ALTER POLICY p_ins ON alter_policy_table WITH CHECK (true);

-- Test 381: statement (line 1786)
DROP SEQUENCE seq1;

-- Test 382: statement (line 1789)
DROP TABLE alter_policy_table;

-- Test 383: statement (line 1792)
DROP ROLE alter_policy_role, aux1, aux2;

-- Test 384: statement (line 1798)
CREATE USER tab_owner;

-- Test 385: statement (line 1801)
CREATE USER nontab_owner;

-- Test 386: statement (line 1804)
CREATE TABLE table_owner_test ();

-- Test 387: statement (line 1807)
ALTER TABLE table_owner_test OWNER TO tab_owner;

-- Test 388: statement (line 1810)
GRANT ALL ON table_owner_test TO nontab_owner;

-- Test 389: statement (line 1813)
SET ROLE tab_owner;

-- Test 390: statement (line 1816)
ALTER TABLE table_owner_test ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 391: statement (line 1819)
CREATE POLICY p1 on table_owner_test;

-- Test 392: statement (line 1822)
DROP POLICY p1 on table_owner_test;

-- Test 393: statement (line 1825)
CREATE POLICY new_p1 on table_owner_test;

-- Test 394: statement (line 1828)
ALTER POLICY new_p1 on table_owner_test RENAME TO p1;

-- Test 395: statement (line 1831)
ALTER POLICY p1 on table_owner_test RENAME TO new_p1;

-- Test 396: statement (line 1834)
ALTER POLICY new_p1 on table_owner_test USING (true);

-- Test 397: statement (line 1837)
SET ROLE nontab_owner;

-- Test 398: statement (line 1840)
ALTER TABLE table_owner_test DISABLE ROW LEVEL SECURITY;

-- Test 399: statement (line 1843)
ALTER TABLE table_owner_test NO FORCE ROW LEVEL SECURITY;

-- Test 400: statement (line 1846)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'table_owner_test' AND policyname = 'p2') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p2 on table_owner_test;
\else
CREATE POLICY p2 on table_owner_test;
\endif

-- Test 401: statement (line 1849)
DROP POLICY new_p1 on table_owner_test;

-- Test 402: statement (line 1852)
ALTER POLICY new_p1 on table_owner_test WITH CHECK (true);

-- Test 403: statement (line 1855)
ALTER POLICY new_p1 on table_owner_test RENAME TO p1;

-- Test 404: statement (line 1858)
SET ROLE root;

-- Test 405: statement (line 1861)
DROP TABLE table_owner_test;

-- Test 406: statement (line 1864)
DROP ROLE nontab_owner, tab_owner;

-- Test 407: statement (line 1869)
CREATE USER forcer;

-- Test 408: statement (line 1872)
CREATE USER funuser;

-- Test 409: statement (line 1875)
GRANT CREATE ON DATABASE db1 TO forcer;

-- Test 410: statement (line 1878)
set role forcer;

-- Test 411: statement (line 1881)
CREATE TABLE force_check (c1 INT NOT NULL PRIMARY KEY, c2 TEXT);

-- Test 412: statement (line 1884)
INSERT INTO force_check VALUES (10, 'ten'), (20, 'twenty'), (50, 'fifty');

-- Test 413: statement (line 1887)
CREATE FUNCTION access_large_c2_as_session_user() RETURNS TABLE(ID INT)
LANGUAGE SQL AS
$$
 SELECT c1 FROM force_check WHERE length(c2) > 3
$$;

-- Test 414: statement (line 1894)
CREATE FUNCTION access_large_c2_as_forcer() RETURNS TABLE(ID INT)
LANGUAGE SQL AS
$$
 SELECT c1 FROM force_check WHERE length(c2) > 3
$$ SECURITY DEFINER;

-- Test 415: statement (line 1901)
CREATE FUNCTION insert_policy_violation_as_session_user(c1 INT) RETURNS TABLE(id INT, description TEXT)
LANGUAGE SQL AS
$$
 INSERT INTO force_check VALUES (c1, 't - violated col value') RETURNING c1, c2
$$;

-- Test 416: statement (line 1908)
CREATE FUNCTION insert_policy_violation_as_forcer(c1 INT) RETURNS TABLE(id INT, description TEXT)
LANGUAGE SQL AS
$$
 INSERT INTO force_check VALUES (c1, 't - violated col value') RETURNING c1, c2
$$ SECURITY DEFINER;

-- Test 417: statement (line 1915)
ALTER TABLE force_check ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 418: statement (line 1918)
CREATE POLICY p_sel ON force_check TO forcer, funuser USING (c2 not like 't%');

-- Test 419: query (line 1928)
SELECT c1, c2 FROM force_check ORDER BY c1;

-- Test 420: query (line 1934)
SELECT c1, c2 FROM force_check WHERE c1 > 0 ORDER BY c1;

-- Test 421: statement (line 1939)
INSERT INTO force_check VALUES (30, 'thirty');

-- Test 422: statement (line 1943)
SET ROLE root;

-- Test 423: query (line 1947)
SELECT c1, c2 FROM force_check ORDER BY c1;

-- Test 424: statement (line 1954)
INSERT INTO force_check VALUES (33, 'thirty-three');

-- Test 425: statement (line 1957)
SET ROLE forcer;

-- Test 426: statement (line 1961)
ALTER TABLE force_check NO FORCE ROW LEVEL SECURITY;

-- Test 427: statement (line 1964)
INSERT INTO force_check VALUES (30, 'thirty');

-- Test 428: query (line 1968)
SELECT c1, c2 FROM force_check WHERE c1 > 0 ORDER BY c1;

-- Test 429: statement (line 1978)
SET ROLE root;

-- Test 430: statement (line 1981)
ALTER TABLE force_check OWNER TO root;

-- Test 431: statement (line 1984)
GRANT ALL ON force_check TO forcer;

-- Test 432: statement (line 1987)
SET ROLE forcer;

-- Test 433: query (line 1992)
SELECT c1, c2 FROM force_check WHERE c1 > 0 ORDER BY c1;

-- Test 434: statement (line 1997)
SET ROLE root;

-- Test 435: statement (line 2001)
ALTER TABLE force_check FORCE ROW LEVEL SECURITY;

-- Test 436: statement (line 2004)
SET ROLE forcer;

-- Test 437: query (line 2008)
SELECT c1, c2 FROM force_check WHERE c1 > 0 ORDER BY c1;

-- Test 438: statement (line 2013)
INSERT INTO force_check VALUES (34, 'thirty-four');

-- Test 439: statement (line 2017)
SET ROLE root;

-- Test 440: statement (line 2020)
ALTER TABLE force_check OWNER TO forcer;

-- Test 441: statement (line 2023)
GRANT ALL ON force_check TO funuser;

-- Test 442: statement (line 2026)
SET ROLE funuser;

-- Test 443: query (line 2033)
select * from access_large_c2_as_session_user();

-- Test 444: query (line 2038)
select * from access_large_c2_as_forcer();

-- Test 445: statement (line 2045)
SELECT insert_policy_violation_as_session_user(110);

-- Test 446: statement (line 2048)
SELECT insert_policy_violation_as_forcer(111);

-- Test 447: statement (line 2052)
SET ROLE forcer;

-- Test 448: statement (line 2055)
ALTER TABLE force_check NO FORCE ROW LEVEL SECURITY;

-- Test 449: statement (line 2058)
SET ROLE funuser;

-- Test 450: query (line 2065)
select * from access_large_c2_as_session_user();

-- Test 451: query (line 2070)
select * from access_large_c2_as_forcer();

-- Test 452: statement (line 2080)
SELECT insert_policy_violation_as_session_user(111);

-- Test 453: query (line 2083)
SELECT * FROM insert_policy_violation_as_forcer(112);

-- Test 454: statement (line 2088)
SET ROLE root;

-- Test 455: statement (line 2091)
DROP TABLE force_check CASCADE;

-- Test 456: statement (line 2097)
CREATE TABLE uniq (rls_col TEXT, uniq_col INT8 UNIQUE);

-- Test 457: statement (line 2100)
CREATE USER uniq_user;

-- Test 458: statement (line 2103)
GRANT ALL ON uniq TO uniq_user;

-- Test 459: statement (line 2106)
ALTER TABLE uniq OWNER TO uniq_user;

-- Test 460: statement (line 2109)
SET ROLE uniq_user;

-- Test 461: statement (line 2112)
ALTER TABLE uniq NO FORCE ROW LEVEL SECURITY, ENABLE ROW LEVEL SECURITY;

-- Test 462: statement (line 2115)
CREATE POLICY access ON uniq USING (rls_col = 'cat');

-- Test 463: statement (line 2118)
INSERT INTO uniq VALUES ('cat', 1), ('cat', 2), ('dog', 3), ('cat', 4), ('hamster', 5);

-- Test 464: statement (line 2121)
ALTER TABLE uniq FORCE ROW LEVEL SECURITY;

-- Test 465: statement (line 2124)
INSERT INTO uniq VALUES ('cat', 3);

-- Test 466: statement (line 2127)
INSERT INTO uniq VALUES ('cat', 6);

-- Test 467: statement (line 2130)
INSERT INTO uniq VALUES ('dog', 6);

-- Test 468: statement (line 2133)
UPDATE uniq SET uniq_col = 5 WHERE uniq_col = 1;

-- Test 469: statement (line 2136)
UPDATE uniq SET uniq_col = 7 WHERE uniq_col = 1;

-- Test 470: query (line 2140)
UPDATE uniq SET uniq_col = 8 WHERE uniq_col = 5 RETURNING rls_col, uniq_col;

-- Test 471: statement (line 2144)
ALTER TABLE uniq NO FORCE ROW LEVEL SECURITY;

-- Test 472: query (line 2147)
select rls_col, uniq_col FROM uniq ORDER BY uniq_col;

-- Test 473: statement (line 2157)
SET ROLE root;

-- Test 474: statement (line 2160)
DROP TABLE uniq;

-- Test 475: statement (line 2163)
DROP USER uniq_user;

-- Test 476: statement (line 2169)
CREATE TABLE parent (key INT8 NOT NULL PRIMARY KEY);

-- Test 477: statement (line 2172)
CREATE TABLE child (
  rls_col TEXT,
  key INT8 NOT NULL,
  CONSTRAINT fk FOREIGN KEY (key) REFERENCES parent(key) ON DELETE CASCADE
);

-- Test 478: statement (line 2179)
CREATE USER fk_user;

-- Test 479: statement (line 2182)
GRANT ALL ON parent TO fk_user;

-- Test 480: statement (line 2185)
GRANT ALL ON child TO fk_user;

-- Test 481: statement (line 2188)
ALTER TABLE parent OWNER TO fk_user;

-- Test 482: statement (line 2191)
ALTER TABLE child OWNER TO fk_user;

-- Test 483: statement (line 2194)
SET ROLE fk_user;

-- Test 484: statement (line 2197)
INSERT INTO parent SELECT * FROM generate_series(1,6);

-- Test 485: statement (line 2200)
INSERT INTO child VALUES ('bedroom', 1), ('office', 2);

-- Test 486: statement (line 2204)
ALTER TABLE parent ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 487: statement (line 2207)
INSERT INTO child VALUES ('hall', 7);

-- Test 488: statement (line 2210)
INSERT INTO child VALUES ('hall', 3);

-- Test 489: query (line 2214)
SELECT 1 FROM parent WHERE key = 3;

-- Test 490: query (line 2218)
SELECT key FROM child ORDER BY key;

-- Test 491: statement (line 2226)
ALTER TABLE child ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 492: statement (line 2229)
CREATE POLICY ins1 ON child FOR INSERT WITH CHECK (rls_col = 'bedroom');

-- Test 493: statement (line 2232)
INSERT INTO child VALUES ('bedroom', 7);

-- Test 494: statement (line 2235)
INSERT INTO child VALUES ('deck', 7);

-- Test 495: statement (line 2238)
INSERT INTO child VALUES ('bedroom', 4);

-- Test 496: statement (line 2242)
ALTER TABLE parent NO FORCE ROW LEVEL SECURITY;

-- Test 497: statement (line 2245)
DELETE FROM parent WHERE key = 1;

-- Test 498: statement (line 2248)
CREATE POLICY sel1 ON child FOR SELECT USING (true);

-- Test 499: query (line 2251)
SELECT key FROM child ORDER BY key;

-- Test 500: statement (line 2258)
SET ROLE root;

-- Test 501: statement (line 2261)
DROP TABLE child;

-- Test 502: statement (line 2264)
DROP TABLE parent;

-- Test 503: statement (line 2267)
DROP USER fk_user;

-- Test 504: statement (line 2273)
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name TEXT
);

-- Test 505: statement (line 2279)
CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(id) ON UPDATE CASCADE ON DELETE SET NULL
);

-- Test 506: statement (line 2285)
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Test 507: statement (line 2288)
INSERT INTO customers VALUES (1, 'bob');

-- Test 508: statement (line 2291)
INSERT INTO orders VALUES (1000, 1), (1001, 1);

-- Test 509: statement (line 2294)
CREATE USER u1;

-- Test 510: statement (line 2297)
GRANT ALL ON orders, customers TO u1;

-- Test 511: statement (line 2300)
SET ROLE u1;

-- Test 512: query (line 2304)
SELECT id, customer_id FROM orders;

-- Test 513: query (line 2309)
UPDATE customers SET id = 2 WHERE id = 1 RETURNING id, name;

-- Test 514: statement (line 2314)
RESET ROLE;

-- Test 515: query (line 2317)
SELECT id, customer_id FROM orders ORDER BY id;

-- Test 516: statement (line 2323)
SET ROLE u1;

-- Test 517: query (line 2327)
DELETE FROM customers WHERE id = 2 RETURNING id, name;

-- Test 518: query (line 2333)
SELECT id, customer_id FROM orders ORDER BY id;

-- Test 519: statement (line 2337)
RESET ROLE;

-- Test 520: query (line 2341)
SELECT id, customer_id FROM orders ORDER BY id;

-- Test 521: statement (line 2347)
DROP TABLE orders;

-- Test 522: statement (line 2350)
DROP TABLE customers;

-- Test 523: statement (line 2353)
DROP USER u1;

-- Test 524: statement (line 2359)
CREATE TABLE rgb_only (col text, check (col = 'red' or col = 'green' or col = 'blue'));

-- Test 525: statement (line 2362)
CREATE USER rgb_only_user;

-- Test 526: statement (line 2365)
ALTER TABLE rgb_only OWNER TO rgb_only_user;

-- Test 527: statement (line 2368)
SET ROLE rgb_only_user;

-- Test 528: statement (line 2371)
ALTER TABLE rgb_only ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 529: statement (line 2374)
CREATE POLICY p_sel ON rgb_only FOR SELECT USING (true);

-- Test 530: statement (line 2377)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'rgb_only' AND policyname = 'p_subset') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p_subset ON rgb_only FOR INSERT WITH CHECK (col = 'red' or col = 'brown');
\else
CREATE POLICY p_subset ON rgb_only FOR INSERT WITH CHECK (col = 'red' or col = 'brown');
\endif

-- Test 531: statement (line 2380)
INSERT INTO rgb_only VALUES ('red');

-- Test 532: statement (line 2384)
INSERT INTO rgb_only VALUES ('brown');

-- Test 533: statement (line 2388)
INSERT INTO rgb_only VALUES ('green');

-- Test 534: statement (line 2391)
DROP POLICY p_subset ON rgb_only;

-- Test 535: statement (line 2394)
CREATE POLICY p_disjoint ON rgb_only FOR INSERT WITH CHECK (col = 'black');

-- Test 536: statement (line 2398)
INSERT INTO rgb_only VALUES ('blue');

-- Test 537: query (line 2401)
SELECT col FROM rgb_only ORDER BY col;

-- Test 538: statement (line 2406)
SET ROLE root;

-- Test 539: statement (line 2409)
DROP TABLE rgb_only;

-- Test 540: statement (line 2412)
DROP USER rgb_only_user;

-- Test 541: statement (line 2417)
CREATE TYPE trunc_type AS ENUM('a', 'b', 'c');

-- Test 542: statement (line 2420)
CREATE TABLE trunc (a INT, b trunc_type);

-- Test 543: statement (line 2423)
INSERT INTO trunc VALUES (1, 'a'), (2, 'b'), (3, 'c');

-- Test 544: statement (line 2426)
CREATE USER deleter;

-- Test 545: statement (line 2429)
GRANT ALL ON trunc TO deleter;

-- Test 546: statement (line 2432)
ALTER TABLE trunc ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 547: statement (line 2435)
CREATE POLICY p1 ON trunc FOR SELECT TO deleter USING (a % 2 = 1 and b != 'b');

-- Test 548: statement (line 2438)
CREATE POLICY p2 ON trunc FOR DELETE TO deleter USING (false);

-- Test 549: statement (line 2441)
CREATE POLICY p3 ON trunc FOR INSERT TO deleter WITH CHECK (true);

-- Test 550: statement (line 2444)
SET ROLE deleter;

-- Test 551: query (line 2447)
SELECT a, b FROM trunc ORDER BY a;

-- Test 552: statement (line 2454)
DELETE FROM trunc;

-- Test 553: query (line 2457)
SELECT a, b FROM trunc ORDER BY a;

-- Test 554: query (line 2464)
-- SHOW CREATE TABLE trunc;

-- Test 555: query (line 2480)
-- SHOW CREATE TABLE trunc;

-- Test 556: statement (line 2496)
ALTER TABLE trunc SET (schema_locked=false);

-- Test 557: statement (line 2499)
TRUNCATE TABLE trunc;

-- Test 558: statement (line 2502)
ALTER TABLE trunc RESET (schema_locked);

-- Test 559: query (line 2505)
SELECT a, b FROM trunc ORDER BY a;

-- Test 560: query (line 2511)
-- SHOW CREATE TABLE trunc;

-- Test 561: query (line 2527)
-- SHOW CREATE TABLE trunc;

-- Test 562: statement (line 2543)
INSERT INTO trunc VALUES (7, 'a'), (8, 'b'), (9, 'c');

-- Test 563: query (line 2546)
SELECT a, b FROM trunc ORDER BY a;

-- Test 564: statement (line 2552)
DELETE FROM trunc;

-- Test 565: query (line 2555)
SELECT a, b FROM TRUNC ORDER BY a;

-- Test 566: statement (line 2561)
SET ROLE root;

-- Test 567: statement (line 2564)
DROP TABLE trunc;

-- Test 568: statement (line 2567)
DROP USER deleter;

-- Test 569: statement (line 2572)
CREATE TABLE rls_cache_test (c1 TEXT);

-- Test 570: statement (line 2575)
INSERT INTO rls_cache_test VALUES ('a'), ('b'), ('c');

-- Test 571: statement (line 2578)
CREATE USER rls_cache_user;

-- Test 572: statement (line 2581)
GRANT ALL ON rls_cache_test TO rls_cache_user;

-- Test 573: statement (line 2584)
SET ROLE rls_cache_user;

-- Test 574: query (line 2588)
SELECT * FROM rls_cache_test ORDER BY c1;

-- Test 575: statement (line 2595)
SET ROLE root;

-- Test 576: statement (line 2598)
ALTER TABLE rls_cache_test ENABLE ROW LEVEL SECURITY;

-- Test 577: statement (line 2601)
SET ROLE rls_cache_user;

-- Test 578: query (line 2605)
SELECT * FROM rls_cache_test ORDER BY c1;

-- Test 579: statement (line 2609)
SET ROLE root;

-- Test 580: statement (line 2612)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'rls_cache_test' AND policyname = 'rls_cache_policy') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS rls_cache_policy ON rls_cache_test FOR SELECT TO rls_cache_user USING (c1 != 'a');
\else
CREATE POLICY rls_cache_policy ON rls_cache_test FOR SELECT TO rls_cache_user USING (c1 != 'a');
\endif

-- Test 581: statement (line 2616)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'rls_cache_test' AND policyname = 'rls_cache_policy') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS rls_cache_policy ON rls_cache_test;
\else
CREATE POLICY rls_cache_policy ON rls_cache_test;
\endif

-- Test 582: statement (line 2619)
SET ROLE rls_cache_user;

-- Test 583: query (line 2623)
SELECT * FROM rls_cache_test ORDER BY c1;

-- Test 584: statement (line 2629)
SET ROLE root;

-- Test 585: statement (line 2632)
ALTER TABLE rls_cache_test DISABLE ROW LEVEL SECURITY;

-- Test 586: statement (line 2635)
SET ROLE rls_cache_user;

-- Test 587: query (line 2639)
SELECT * FROM rls_cache_test ORDER BY c1;

-- Test 588: statement (line 2646)
SET ROLE root;

-- Test 589: statement (line 2650)
DROP TABLE rls_cache_test;

-- Test 590: statement (line 2653)
SET ROLE rls_cache_user;

-- Test 591: statement (line 2656)
SELECT * FROM rls_cache_test ORDER BY c1;

-- Test 592: statement (line 2659)
SET ROLE root;

-- Test 593: statement (line 2662)
DROP ROLE rls_cache_user;

-- Test 594: statement (line 2667)
CREATE ROLE alice LOGIN;

-- Test 595: statement (line 2670)
CREATE TABLE t (
      k INT PRIMARY KEY,
      a INT,
      b INT,
      c INT,
      v INT AS (c + 1) VIRTUAL
);

-- Test 596: statement (line 2679)
INSERT INTO t VALUES (1,1,1,1),(-1,-1,-1,-1);

-- Test 597: statement (line 2682)
GRANT SELECT, INSERT, UPDATE, DELETE ON t TO alice;

-- Test 598: statement (line 2685)
ALTER TABLE t ENABLE ROW LEVEL SECURITY;

-- Test 599: statement (line 2688)
CREATE POLICY select_policy
ON t
FOR SELECT
TO alice
USING (v > 0);

-- Test 600: statement (line 2695)
CREATE POLICY insert_policy
ON t
FOR INSERT
TO alice
WITH CHECK (v > 1);

-- Test 601: statement (line 2702)
CREATE POLICY update_policy
ON t
FOR UPDATE
TO alice
USING (v > 2);

-- Test 602: statement (line 2709)
CREATE POLICY delete_policy
ON t
FOR DELETE
TO alice
USING (v > 3);

-- Test 603: statement (line 2716)
SET ROLE alice;

-- Test 604: query (line 2719)
SELECT * FROM t;

-- Test 605: query (line 2724)
SELECT k,a FROM t WHERE b IS NOT NULL;;

-- Test 606: statement (line 2729)
INSERT INTO t VALUES (2,2,2,2);

-- Test 607: statement (line 2732)
INSERT INTO t VALUES (3,0,0,0);

-- Test 608: query (line 2735)
UPDATE t SET c = 4 WHERE k = 2 RETURNING *;

-- Test 609: statement (line 2740)
UPDATE t SET c = 0 WHERE k = 2 RETURNING *;

-- Test 610: query (line 2743)
DELETE FROM t RETURNING v;

-- Test 611: statement (line 2748)
SET ROLE root;

-- Test 612: query (line 2751)
SELECT * FROM t ORDER BY k;

-- Test 613: statement (line 2757)
DROP TABLE t;

-- Test 614: statement (line 2760)
DROP USER ALICE;

-- Test 615: statement (line 2765)
CREATE ROLE pat LOGIN;

-- Test 616: statement (line 2768)
CREATE TABLE t (
      k INT PRIMARY KEY,
      a INT,
      b INT,
      c INT,
      v INT AS (c + 1) STORED
);

-- Test 617: statement (line 2777)
INSERT INTO t VALUES (1,1,1,1),(-1,-1,-1,-1);

-- Test 618: statement (line 2780)
GRANT SELECT, INSERT, UPDATE, DELETE ON t TO pat;

-- Test 619: statement (line 2783)
ALTER TABLE t ENABLE ROW LEVEL SECURITY;

-- Test 620: statement (line 2786)
CREATE POLICY select_policy
ON t
FOR SELECT
TO pat
USING (v > 0);

-- Test 621: statement (line 2793)
CREATE POLICY insert_policy
ON t
FOR INSERT
TO pat
WITH CHECK (v > 1);

-- Test 622: statement (line 2800)
CREATE POLICY update_policy
ON t
FOR UPDATE
TO pat
USING (v > 2);

-- Test 623: statement (line 2807)
CREATE POLICY delete_policy
ON t
FOR DELETE
TO pat
USING (v > 3);

-- Test 624: statement (line 2814)
SET ROLE pat;

-- Test 625: query (line 2817)
SELECT * FROM t;

-- Test 626: query (line 2822)
SELECT k,a FROM t WHERE b IS NOT NULL;;

-- Test 627: statement (line 2827)
INSERT INTO t VALUES (2,2,2,2);

-- Test 628: statement (line 2830)
INSERT INTO t VALUES (3,0,0,0);

-- Test 629: query (line 2833)
UPDATE t SET c = 4 WHERE k = 2 RETURNING *;

-- Test 630: statement (line 2838)
UPDATE t SET c = 0 WHERE k = 2 RETURNING *;

-- Test 631: query (line 2841)
DELETE FROM t RETURNING v;

-- Test 632: statement (line 2846)
SET ROLE root;

-- Test 633: query (line 2849)
SELECT * FROM t ORDER BY k;

-- Test 634: statement (line 2855)
DROP TABLE t;

-- Test 635: statement (line 2858)
DROP USER PAT;

-- Test 636: statement (line 2863)
CREATE TABLE blocker();

-- Test 637: statement (line 2866)
CREATE POLICY p_insert on blocker FOR INSERT USING (1 = 1);

-- Test 638: statement (line 2869)
CREATE POLICY p_select on blocker FOR SELECT WITH CHECK (false);

-- Test 639: statement (line 2872)
CREATE POLICY p_delete on blocker FOR DELETE WITH CHECK (1 = 1);

-- Test 640: statement (line 2875)
DROP TABLE blocker;

-- Test 641: statement (line 2880)
CREATE TABLE importer (c1 INT);

-- Test 642: statement (line 2883)
ALTER TABLE importer ENABLE ROW LEVEL SECURITY;

-- Test 643: statement (line 2886)
CREATE USER z;

-- Test 644: statement (line 2889)
GRANT ALL ON importer TO z;

-- Test 645: statement (line 2892)
-- GRANT SYSTEM EXTERNALIOIMPLICITACCESS TO z;

-- Test 646: statement (line 2896)
SET ROLE z;

let $exp_file
WITH cte AS (EXPORT INTO CSV 'nodelocal://1/rls-importer' FROM select 99 UNION ALL SELECT 98 UNION ALL SELECT 97) SELECT filename FROM cte;

-- Test 647: statement (line 2902)
IMPORT INTO importer CSV DATA ('nodelocal://1/rls-importer/$exp_file');

-- Test 648: statement (line 2912)
IMPORT INTO importer CSV DATA ('nodelocal://1/rls-importer/$exp_file');

-- skipif config fakedist fakedist-disk fakedist-vec-off

-- Test 649: query (line 2916)
SELECT c1 FROM importer ORDER BY c1;

-- Test 650: statement (line 2923)
DROP TABLE importer;

-- Test 651: statement (line 2926)
-- REVOKE SYSTEM EXTERNALIOIMPLICITACCESS FROM z;

-- Test 652: statement (line 2929)
DROP USER z;

-- Test 653: statement (line 2934)
CREATE TABLE rlsInsert (c1 int not null primary key, c2 text, c3 date);

-- Test 654: statement (line 2937)
ALTER TABLE rlsInsert ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 655: statement (line 2940)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'rlsInsert' AND policyname = 'p_insert') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p_insert ON rlsInsert AS PERMISSIVE FOR INSERT TO buck WITH CHECK (c3 not between '2012-01-01' and '2012-12-31');
\else
CREATE POLICY p_insert ON rlsInsert AS PERMISSIVE FOR INSERT TO buck WITH CHECK (c3 not between '2012-01-01' and '2012-12-31');
\endif

-- Test 656: statement (line 2943)
CREATE POLICY p_select ON rlsInsert AS PERMISSIVE FOR SELECT TO buck USING (true);

-- Test 657: statement (line 2946)
GRANT ALL on rlsInsert TO buck;

-- Test 658: statement (line 2950)
INSERT INTO rlsInsert VALUES (1, 'first', '2012-06-30'),(0, 'zero', NULL);

-- Test 659: statement (line 2953)
SET ROLE buck;

-- Test 660: statement (line 2956)
INSERT INTO rlsInsert VALUES (2, 'second', '2010-06-30');

-- Test 661: statement (line 2960)
INSERT INTO rlsInsert VALUES (3, 'third', '2012-07-08');

-- Test 662: statement (line 2964)
INSERT INTO rlsInsert SELECT c1 + 5, c2, c3 FROM rlsInsert;

-- Test 663: statement (line 2968)
INSERT INTO rlsInsert VALUES (4, 'four', NULL);

-- Test 664: statement (line 2971)
INSERT INTO rlsInsert SELECT c1 + 5, c2, c3 FROM rlsInsert WHERE c3 not between '2012-01-01' and '2012-12-31';

-- Test 665: statement (line 2974)
SET ROLE root;

-- onlyif config schema-locked-disabled

-- Test 666: query (line 2978)
-- SHOW CREATE TABLE rlsInsert

-- Test 667: query (line 2993)
-- SHOW CREATE TABLE rlsInsert

-- Test 668: statement (line 3007)
DROP POLICY p_insert on rlsInsert;

-- Test 669: statement (line 3010)
SET ROLE buck;

-- Test 670: statement (line 3014)
INSERT INTO rlsInsert VALUES (4, 'fourth', '2022-10-08');

-- Test 671: query (line 3017)
select c1 from rlsInsert ORDER BY c1;

-- Test 672: statement (line 3025)
SET ROLE root;

-- Test 673: statement (line 3028)
DROP TABLE rlsInsert;

-- Test 674: statement (line 3033)
CREATE TYPE league AS ENUM('AL','NL');

-- Test 675: statement (line 3036)
CREATE FUNCTION al_only(l league) RETURNS BOOL AS $$
BEGIN
  RETURN l = 'AL';
END;
$$ LANGUAGE PLpgSQL;

-- Test 676: statement (line 3043)
CREATE SEQUENCE seq1;

-- Test 677: statement (line 3046)
CREATE TABLE bbteams (team text, league league, wins int);

-- Test 678: statement (line 3049)
ALTER TABLE bbteams ENABLE ROW LEVEL SECURITY;

-- Test 679: statement (line 3052)
CREATE POLICY p_update ON bbteams FOR UPDATE TO buck USING (true) WITH CHECK (league = 'AL' and nextval('seq1') < 1000);

-- Test 680: statement (line 3055)
CREATE POLICY p_select ON bbteams FOR SELECT TO buck USING (true);

-- Test 681: statement (line 3058)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'bbteams' AND policyname = 'p_insert') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p_insert ON bbteams FOR INSERT TO buck WITH CHECK (nextval('seq1') < 1000);
\else
CREATE POLICY p_insert ON bbteams FOR INSERT TO buck WITH CHECK (nextval('seq1') < 1000);
\endif

-- Test 682: statement (line 3062)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'bbteams' AND policyname = 'p_insert') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p_insert ON bbteams;
\else
CREATE POLICY p_insert ON bbteams;
\endif

-- Test 683: statement (line 3065)
GRANT ALL on bbteams TO buck;

-- Test 684: statement (line 3068)
GRANT USAGE ON seq1 TO buck;

-- Test 685: statement (line 3071)
GRANT UPDATE ON seq1 TO buck;

-- Test 686: statement (line 3074)
SET ROLE buck;

-- Test 687: statement (line 3077)
INSERT INTO bbteams(team, league) VALUES ('guardians', 'AL'), ('royals', 'AL'), ('expos', 'NL');

-- Test 688: statement (line 3081)
UPDATE bbteams SET wins = 91 WHERE team = 'expos';

-- Test 689: statement (line 3085)
UPDATE bbteams SET wins = 87, league = 'AL' WHERE team = 'expos';

-- Test 690: statement (line 3090)
select setval('seq1', 1500, true);

-- Test 691: statement (line 3093)
UPDATE bbteams SET wins = 82  WHERE team = 'royals';

-- Test 692: statement (line 3096)
SET ROLE root;

-- Test 693: query (line 3099)
SELECT nextval('seq1');

-- Test 694: query (line 3104)
select team, league, wins from bbteams order by team;

-- Test 695: statement (line 3111)
DROP TABLE bbteams;

-- Test 696: statement (line 3114)
DROP FUNCTION al_only;

-- Test 697: statement (line 3117)
DROP SEQUENCE seq1;

-- Test 698: statement (line 3122)
CREATE TABLE multip (key INT NOT NULL, value TEXT);

-- Test 699: statement (line 3125)
ALTER TABLE multip ENABLE ROW LEVEL SECURITY;

-- Test 700: statement (line 3129)
CREATE POLICY or1 ON multip AS PERMISSIVE USING (key = 1);

-- Test 701: statement (line 3132)
CREATE POLICY or2 ON multip AS PERMISSIVE USING (key = 2);

-- Test 702: statement (line 3135)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'multip' AND policyname = 'or3') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS or3 ON multip AS PERMISSIVE USING (key = 3);
\else
CREATE POLICY or3 ON multip AS PERMISSIVE USING (key = 3);
\endif

-- Test 703: statement (line 3138)
CREATE POLICY and1 ON multip AS RESTRICTIVE USING (value not like '%sensitive%');

-- Test 704: statement (line 3141)
CREATE POLICY and2 ON multip AS RESTRICTIVE USING (value not like '%confidential%');

-- Test 705: statement (line 3144)
INSERT INTO multip VALUES
 (0, 'key out of bounds'),
 (1, 'okay'),
 (1, 'sensitive - filtered out'),
 (2, 'okay'),
 (2, 'confidential - filtered out'),
 (3, 'okay'),
 (2, 'sensitive - filtered out'),
 (4, 'key out of bounds'),
 (4, 'confidential');

-- Test 706: statement (line 3156)
CREATE USER multi_user;

-- Test 707: statement (line 3159)
GRANT ALL ON multip TO multi_user;

-- Test 708: statement (line 3162)
SET ROLE multi_user;

-- Test 709: query (line 3165)
select * from multip ORDER BY key, value;

-- Test 710: query (line 3172)
select * from multip where key >= 0 ORDER BY key, value;

-- Test 711: statement (line 3179)
SET ROLE root;

-- Test 712: statement (line 3184)
DROP POLICY or1 ON multip;

-- Test 713: statement (line 3187)
DROP POLICY or2 ON multip;

-- Test 714: statement (line 3190)
DROP POLICY or3 ON multip;

-- Test 715: statement (line 3193)
SET ROLE multi_user;

-- onlyif config schema-locked-disabled

-- Test 716: query (line 3197)
SHOW CREATE multip;

-- Test 717: query (line 3212)
SHOW CREATE multip;

-- Test 718: query (line 3226)
select * from multip ORDER BY key, value;

-- Test 719: statement (line 3230)
SET ROLE root;

-- Test 720: statement (line 3233)
ALTER TABLE multip SET (schema_locked=false);

-- Test 721: statement (line 3237)
TRUNCATE TABLE multip;

-- Test 722: statement (line 3240)
ALTER TABLE multip RESET (schema_locked);

-- Test 723: statement (line 3243)
CREATE POLICY or1 ON multip AS PERMISSIVE USING (key = 1);

-- Test 724: statement (line 3246)
CREATE POLICY or2 ON multip AS PERMISSIVE USING (key = 2);

-- Test 725: statement (line 3249)
CREATE POLICY or3 ON multip AS PERMISSIVE USING (key = 3);

-- Test 726: query (line 3252)
select name, cmd, type, roles, with_check_expr from pg_show_policies('multip');

-- Test 727: query (line 3262)
select using_expr from pg_show_policies('multip');

-- Test 728: statement (line 3271)
SET ROLE multi_user;

-- Test 729: statement (line 3274)
INSERT INTO multip VALUES (0, 'key out of bounds');

-- Test 730: statement (line 3277)
INSERT INTO multip VALUES (1, 'okay');

-- Test 731: statement (line 3280)
INSERT INTO multip VALUES (1, 'sensitive - filtered out');

-- Test 732: statement (line 3283)
INSERT INTO multip VALUES (2, 'okay');

-- Test 733: statement (line 3286)
INSERT INTO multip VALUES (2, 'confidential - filtered out');

-- Test 734: statement (line 3289)
INSERT INTO multip VALUES (3, 'okay');

-- Test 735: statement (line 3292)
INSERT INTO multip VALUES (2, 'sensitive - filtered out');

-- Test 736: statement (line 3295)
INSERT INTO multip VALUES (4, 'key out of bounds');

-- Test 737: statement (line 3298)
INSERT INTO multip VALUES (4, 'confidential');

-- Test 738: statement (line 3301)
SET ROLE root;

-- Test 739: query (line 3304)
select * FROM multip ORDER BY key, value;

-- Test 740: statement (line 3311)
DROP TABLE multip;

-- Test 741: statement (line 3314)
DROP USER multi_user;

-- Test 742: statement (line 3321)
CREATE ROLE alice LOGIN;

-- Test 743: statement (line 3324)
CREATE ROLE bob LOGIN;

-- Test 744: statement (line 3327)
CREATE TABLE documents (
    id INT PRIMARY KEY,
    owner TEXT NOT NULL,
    content TEXT NOT NULL
);

-- Test 745: statement (line 3334)
INSERT INTO documents (id, owner, content) VALUES
  (1, 'alice', 'Alice’s first document'),
  (2, 'alice', 'Alice’s second document'),
  (3, 'bob',   'Bob’s only document so far'),
  (4, 'admin', 'Admin’s secret doc');

-- Test 746: statement (line 3341)
GRANT ALL ON documents TO alice;

-- Test 747: statement (line 3344)
GRANT ALL ON documents TO bob;

-- Test 748: statement (line 3347)
GRANT CREATE ON SCHEMA public TO alice;

-- Test 749: statement (line 3350)
GRANT CREATE ON SCHEMA public TO bob;

-- Test 750: statement (line 3353)
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- Test 751: statement (line 3356)
CREATE POLICY alice ON documents TO alice USING (owner = 'alice');

-- Test 752: statement (line 3359)
CREATE POLICY bob ON documents TO bob USING (owner = 'bob');

-- Test 753: statement (line 3362)
SET ROLE alice;

-- Test 754: query (line 3365)
SELECT * FROM documents ORDER BY ID;

-- Test 755: statement (line 3371)
CREATE TABLE ctas1 AS SELECT * FROM documents;

-- Test 756: query (line 3374)
SELECT * FROM ctas1 ORDER BY ID;

-- Test 757: statement (line 3380)
CREATE MATERIALIZED VIEW mqt_doc AS SELECT * FROM documents;

-- Test 758: query (line 3383)
SELECT * FROM mqt_doc ORDER BY ID;

-- Test 759: statement (line 3389)
GRANT ALL ON ctas1 TO bob;

-- Test 760: statement (line 3392)
RESET ROLE;

-- Test 761: statement (line 3395)
ALTER TABLE mqt_doc OWNER TO bob;

-- Test 762: statement (line 3398)
SET ROLE bob;

-- Test 763: query (line 3401)
SELECT * FROM documents ORDER BY ID;

-- Test 764: query (line 3406)
SELECT * FROM ctas1 ORDER BY ID;

-- Test 765: query (line 3412)
SELECT * FROM mqt_doc ORDER BY ID;

-- Test 766: statement (line 3418)
REFRESH MATERIALIZED VIEW mqt_doc;

-- Test 767: query (line 3421)
SELECT * FROM mqt_doc ORDER BY ID;

-- Test 768: statement (line 3426)
RESET ROLE;

-- Test 769: statement (line 3429)
DROP TABLE ctas1;

-- Test 770: statement (line 3432)
DROP MATERIALIZED VIEW mqt_doc;

-- Test 771: statement (line 3435)
DROP TABLE documents;

-- Test 772: statement (line 3438)
REVOKE CREATE ON SCHEMA public FROM bob, alice;

-- Test 773: statement (line 3441)
DROP ROLE alice, bob;

-- Test 774: statement (line 3446)
SELECT * FROM pg_show_policies('nonexistent_table');

-- Test 775: statement (line 3449)
CREATE TABLE rls_disabled (id INT PRIMARY KEY);

-- Test 776: statement (line 3452)
CREATE POLICY p1 ON rls_disabled USING (true);

-- Test 777: statement (line 3455)
ALTER TABLE rls_disabled DISABLE ROW LEVEL SECURITY;

-- Test 778: query (line 3458)
SELECT * FROM pg_show_policies('rls_disabled');

-- Test 779: statement (line 3465)
CREATE TABLE no_policies (id INT PRIMARY KEY);

-- Test 780: statement (line 3468)
ALTER TABLE no_policies ENABLE ROW LEVEL SECURITY;

-- Test 781: query (line 3471)
SELECT * FROM pg_show_policies('no_policies');

-- Test 782: statement (line 3480)
create table r1 (c1 int);

-- Test 783: statement (line 3483)
alter table r1 enable row level security;

-- Test 784: statement (line 3486)
insert into r1 values (0),(1),(2),(3),(4),(5),(22);

-- Test 785: statement (line 3489)
create policy sel1 on r1 for select using (c1 % 2 = 0);

-- Test 786: statement (line 3492)
create policy upd1 on r1 for update using (c1 between 0 and 20);

-- Test 787: statement (line 3495)
create user r1_user;

-- Test 788: statement (line 3498)
grant all on r1 to r1_user;

-- Test 789: statement (line 3501)
set role r1_user;

-- Test 790: statement (line 3505)
update r1 set c1 = c1 ;

-- Test 791: query (line 3508)
update r1 set c1 = c1 returning c1;

-- Test 792: statement (line 3515)
update r1 set c1 = c1 + 1;

-- Test 793: statement (line 3518)
update r1 set c1 = c1 + 1 where c1 between 1 and 3;

-- Test 794: statement (line 3521)
update r1 set c1 = c1 + 2 where c1 between 1 and 10;

-- Test 795: query (line 3524)
update r1 set c1 = c1 + 2 where c1 between 1 and 10 returning c1;

-- Test 796: query (line 3530)
update r1 set c1 = c1 + 2 where c1 > 20 returning c1;

-- Test 797: query (line 3534)
SELECT * FROM r1;

-- Test 798: statement (line 3542)
SET ROLE root;

-- Test 799: query (line 3545)
SELECT * FROM r1;

-- Test 800: statement (line 3556)
DROP TABLE r1;

-- Test 801: statement (line 3561)
CREATE TABLE cnt (counter INT);

-- Test 802: statement (line 3564)
INSERT INTO cnt VALUES (1);

-- Test 803: statement (line 3567)
GRANT ALL ON cnt TO r1_user;

-- Test 804: statement (line 3570)
ALTER TABLE cnt ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 805: statement (line 3573)
ALTER TABLE cnt OWNER TO r1_user;

-- Test 806: statement (line 3576)
SET ROLE r1_user;

-- Test 807: statement (line 3579)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'cnt' AND policyname = 'upd1') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS upd1 ON cnt FOR UPDATE USING (true);
\else
CREATE POLICY upd1 ON cnt FOR UPDATE USING (true);
\endif

-- Test 808: query (line 3583)
UPDATE cnt SET counter = counter + 1 RETURNING counter;

-- Test 809: statement (line 3588)
DROP POLICY upd1 ON cnt;

-- Test 810: statement (line 3591)
CREATE POLICY sel1 ON cnt FOR SELECT USING (true);

-- Test 811: query (line 3594)
SELECT * FROM cnt;

-- Test 812: query (line 3601)
SELECT * FROM cnt FOR UPDATE;

-- Test 813: query (line 3606)
SELECT * FROM cnt FOR SHARE;

-- Test 814: query (line 3614)
SELECT * FROM [$cnt_oid as t];

-- Test 815: query (line 3619)
SELECT * FROM [$cnt_oid as t] FOR UPDATE;

-- Test 816: query (line 3623)
SELECT * FROM [$cnt_oid as t] FOR SHARE;

-- Test 817: query (line 3628)
UPDATE cnt SET counter = counter + 1 RETURNING counter;

-- Test 818: statement (line 3633)
CREATE POLICY upd1 ON cnt FOR UPDATE USING (false);

-- Test 819: query (line 3638)
UPDATE cnt SET counter = counter + 1 RETURNING counter;

-- Test 820: statement (line 3643)
ALTER POLICY upd1 ON cnt USING (true);

-- Test 821: query (line 3646)
UPDATE cnt SET counter = counter + 1 RETURNING counter;

-- Test 822: statement (line 3652)
ALTER POLICY upd1 ON cnt USING (true) WITH CHECK (false);

-- Test 823: statement (line 3657)
UPDATE cnt SET counter = counter + 1 RETURNING counter;

-- Test 824: query (line 3661)
delete from cnt where counter is not null returning counter;

-- Test 825: statement (line 3665)
delete from cnt;

-- Test 826: query (line 3668)
select counter from cnt;

-- Test 827: statement (line 3674)
ALTER POLICY sel1 ON cnt USING (false);

-- Test 828: statement (line 3677)
CREATE POLICY del1 ON cnt FOR DELETE USING (true);

-- Test 829: query (line 3680)
delete from cnt where counter > 0 returning counter;

-- Test 830: statement (line 3684)
delete from cnt;

-- Test 831: statement (line 3687)
ALTER TABLE cnt NO FORCE ROW LEVEL SECURITY;

-- Test 832: query (line 3690)
SELECT counter FROM cnt;

-- Test 833: statement (line 3696)
DROP POLICY sel1 ON cnt;

-- Test 834: statement (line 3699)
ALTER TABLE cnt FORCE ROW LEVEL SECURITY;

-- Test 835: query (line 3702)
delete from cnt where counter > 0 returning counter;

-- Test 836: statement (line 3706)
delete from cnt;

-- Test 837: statement (line 3709)
ALTER TABLE cnt NO FORCE ROW LEVEL SECURITY;

-- Test 838: query (line 3712)
SELECT counter FROM cnt;

-- Test 839: statement (line 3717)
ALTER TABLE cnt FORCE ROW LEVEL SECURITY;

-- Test 840: statement (line 3721)
DROP POLICY del1 ON cnt;

-- Test 841: statement (line 3724)
CREATE POLICY sel1 ON cnt FOR SELECT USING (true);

-- Test 842: statement (line 3727)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 'cnt' AND policyname = 'del1') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS del1 ON cnt FOR DELETE USING (false);
\else
CREATE POLICY del1 ON cnt FOR DELETE USING (false);
\endif

-- Test 843: query (line 3730)
DELETE FROM cnt WHERE counter > 0 RETURNING counter;

-- Test 844: statement (line 3734)
DELETE FROM cnt;

-- Test 845: statement (line 3737)
ALTER TABLE cnt NO FORCE ROW LEVEL SECURITY;

-- Test 846: query (line 3740)
SELECT counter FROM cnt;

-- Test 847: statement (line 3745)
ALTER TABLE cnt NO FORCE ROW LEVEL SECURITY;

-- Test 848: statement (line 3748)
SET ROLE root;

-- Test 849: statement (line 3751)
DROP TABLE cnt;

-- Test 850: statement (line 3754)
DROP USER r1_user;

-- Test 851: statement (line 3759)
CREATE ROLE test_role1;

-- Test 852: statement (line 3762)
CREATE ROLE test_role2;

-- Test 853: statement (line 3765)
CREATE USER test_user1;

-- Test 854: statement (line 3768)
CREATE USER test_user2;

-- Test 855: statement (line 3771)
CREATE TABLE policy_roles_test (id INT PRIMARY KEY, val TEXT);

-- Test 856: statement (line 3774)
CREATE POLICY mixed_policy ON policy_roles_test TO test_role1, test_user1, test_role2, test_user2;

-- Test 857: query (line 3777)
SELECT * FROM pg_show_policies('policy_roles_test');

-- Test 858: statement (line 3783)
CREATE POLICY users_only_policy ON policy_roles_test TO test_user1, test_user2;

-- Test 859: query (line 3786)
SELECT * FROM pg_show_policies('policy_roles_test');

-- Test 860: statement (line 3793)
CREATE POLICY roles_only_policy ON policy_roles_test TO test_role1, test_role2;

-- Test 861: query (line 3796)
SELECT * FROM pg_show_policies('policy_roles_test');

-- Test 862: statement (line 3804)
DROP TABLE policy_roles_test;

-- Test 863: statement (line 3807)
DROP USER test_user1;

-- Test 864: statement (line 3810)
DROP USER test_user2;

-- Test 865: statement (line 3813)
DROP ROLE test_role1;

-- Test 866: statement (line 3816)
DROP ROLE test_role2;

-- Test 867: statement (line 3823)
CREATE TABLE bypassrls (id INT PRIMARY KEY, val TEXT);

-- Test 868: statement (line 3826)
CREATE USER bypassrls_user;

-- Test 869: statement (line 3829)
GRANT ALL ON bypassrls TO bypassrls_user;

-- Test 870: statement (line 3832)
ALTER TABLE bypassrls ENABLE ROW LEVEL SECURITY;

-- Test 871: statement (line 3835)
CREATE POLICY pol1 ON bypassrls TO bypassrls_user USING (val like 'visible: %');

-- Test 872: statement (line 3838)
CREATE FUNCTION insert_policy_violation_as_session_user(id INT) RETURNS TABLE(id INT, description TEXT)
LANGUAGE SQL AS
$$
 INSERT INTO bypassrls VALUES (id, 'hidden: value') RETURNING id, val
$$;

-- Test 873: statement (line 3847)
CREATE FUNCTION insert_policy_violation_as_admin(id INT) RETURNS TABLE(id INT, description TEXT)
LANGUAGE SQL AS
$$
 INSERT INTO bypassrls VALUES (id, 'hidden: value') RETURNING id, val
$$ SECURITY DEFINER;

-- Test 874: statement (line 3854)
INSERT INTO bypassrls VALUES (0, 'visible: 0'), (1, 'hidden: 1'), (2, 'visible: 2');

-- Test 875: query (line 3857)
SELECT * FROM insert_policy_violation_as_admin(10);

-- Test 876: query (line 3862)
SELECT * FROM insert_policy_violation_as_session_user(11);

-- Test 877: query (line 3867)
SELECT * FROM bypassrls ORDER BY id;

-- Test 878: statement (line 3876)
SET ROLE bypassrls_user;

-- Test 879: query (line 3879)
SELECT * FROM bypassrls ORDER BY id;

-- Test 880: query (line 3885)
SELECT * FROM insert_policy_violation_as_admin(20);

-- Test 881: statement (line 3890)
SELECT * FROM insert_policy_violation_as_session_user(21);

-- Test 882: statement (line 3893)
SET ROLE root;

-- Test 883: statement (line 3896)
ALTER ROLE bypassrls_user BYPASSRLS NOBYPASSRLS;

-- Test 884: statement (line 3899)
ALTER ROLE bypassrls_user BYPASSRLS;

-- Test 885: statement (line 3902)
SET ROLE bypassrls_user;

-- Test 886: query (line 3905)
SELECT * FROM bypassrls ORDER BY id;

-- Test 887: query (line 3915)
SELECT * FROM insert_policy_violation_as_admin(30);

-- Test 888: query (line 3920)
SELECT * FROM insert_policy_violation_as_session_user(31);

-- Test 889: statement (line 3925)
SET ROLE root;

-- Test 890: statement (line 3928)
ALTER ROLE bypassrls_user NOBYPASSRLS;

-- Test 891: statement (line 3931)
-- GRANT SYSTEM BYPASSRLS TO bypassrls_user;

-- Test 892: query (line 3934)
SELECT rolname AS grantee, 'BYPASSRLS' AS privilege_type
FROM pg_roles
WHERE rolbypassrls
ORDER BY grantee;

-- Test 893: statement (line 3940)
SET ROLE bypassrls_user;

-- Test 894: query (line 3943)
SELECT * FROM bypassrls ORDER BY id;

-- Test 895: query (line 3955)
SELECT * FROM insert_policy_violation_as_session_user(40);

-- Test 896: statement (line 3960)
SET ROLE root;

-- Test 897: statement (line 3963)
-- REVOKE SYSTEM BYPASSRLS FROM bypassrls_user;

-- Test 898: statement (line 3966)
SET ROLE bypassrls_user;

-- Test 899: query (line 3969)
SELECT * FROM bypassrls ORDER BY id;

-- Test 900: statement (line 3975)
SELECT * FROM insert_policy_violation_as_session_user(50);

-- Test 901: statement (line 3978)
SET ROLE root;

-- Test 902: statement (line 3981)
DROP FUNCTION insert_policy_violation_as_admin, insert_policy_violation_as_session_user;

-- Test 903: statement (line 3984)
DROP TABLE bypassrls;

-- Test 904: statement (line 3987)
DROP USER bypassrls_user;

-- Test 905: statement (line 3992)
CREATE TABLE mc (pk int not null primary key, f1 int, f2 int);

-- Test 906: statement (line 3995)
CREATE ROLE mc;

-- Test 907: statement (line 3998)
ALTER TABLE mc OWNER TO mc;

-- Test 908: statement (line 4001)
SET ROLE mc;

-- Test 909: statement (line 4004)
ALTER TABLE mc ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 910: statement (line 4007)
CREATE POLICY p1 ON mc USING (f1 > 0 and f2 > 0);

-- Test 911: statement (line 4010)
INSERT INTO mc VALUES (1, 1, 1);

-- Test 912: statement (line 4017)
UPDATE mc SET f2 = 10 WHERE f1 = 1;

-- skipif config weak-iso-level-configs

-- Test 913: statement (line 4021)
UPDATE mc SET f2 = 11 WHERE f1 = 1;

-- Test 914: statement (line 4024)
DROP POLICY p1 ON mc;

-- Test 915: statement (line 4027)
CREATE POLICY sel ON mc FOR SELECT USING (f1 > 0);

-- Test 916: statement (line 4030)
CREATE POLICY upd ON mc FOR UPDATE USING (true) WITH CHECK (f2 > 0);

-- Test 917: statement (line 4033)
CREATE POLICY ins ON mc FOR INSERT WITH CHECK (true);

-- onlyif config weak-iso-level-configs

-- Test 918: statement (line 4037)
INSERT INTO mc VALUES(1, 1, 1) ON CONFLICT (pk) DO UPDATE SET f2 = 12;

-- skipif config weak-iso-level-configs

-- Test 919: statement (line 4041)
INSERT INTO mc VALUES(1, 1, 1) ON CONFLICT (pk) DO UPDATE SET f2 = 12;

-- Test 920: statement (line 4046)
ALTER POLICY sel ON mc USING (f2 > 0);

-- Test 921: statement (line 4049)
ALTER POLICY upd ON mc WITH CHECK (f1 > 0);

-- onlyif config weak-iso-level-configs

-- Test 922: statement (line 4053)
INSERT INTO mc VALUES(1, 1, 1) ON CONFLICT (pk) DO UPDATE SET f2 = 13;

-- skipif config weak-iso-level-configs

-- Test 923: statement (line 4057)
INSERT INTO mc VALUES(1, 1, 1) ON CONFLICT (pk) DO UPDATE SET f2 = 13;

-- Test 924: statement (line 4060)
SET ROLE root;

-- Test 925: statement (line 4063)
DROP TABLE mc;

-- Test 926: statement (line 4066)
DROP USER mc;

-- Test 927: statement (line 4071)
CREATE TABLE ups (pk INT NOT NULL PRIMARY KEY, comment TEXT);

-- Test 928: statement (line 4074)
CREATE USER ups;

-- Test 929: statement (line 4077)
ALTER TABLE ups OWNER TO ups;

-- Test 930: statement (line 4080)
SET ROLE ups;

-- Test 931: statement (line 4083)
ALTER TABLE ups ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 932: statement (line 4088)
CREATE POLICY p_sel ON ups FOR SELECT USING (true);

-- Test 933: statement (line 4091)
CREATE POLICY p_ins ON ups FOR INSERT WITH CHECK (true);

-- Test 934: statement (line 4094)
CREATE POLICY p_upd ON ups FOR UPDATE USING (comment = 'upsert') WITH CHECK (true);

-- Test 935: statement (line 4098)
INSERT INTO ups VALUES (1, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 936: statement (line 4102)
INSERT INTO ups VALUES (1, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 937: query (line 4105)
SELECT comment FROM ups WHERE pk = 1;

-- Test 938: statement (line 4112)
ALTER POLICY p_upd ON ups USING (comment = 'original value') WITH CHECK (true);

-- Test 939: statement (line 4116)
INSERT INTO ups VALUES (2, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 940: statement (line 4121)
INSERT INTO ups VALUES (2, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 941: query (line 4124)
SELECT comment FROM ups WHERE pk = 2;

-- Test 942: statement (line 4131)
ALTER POLICY p_upd ON ups USING (true) WITH CHECK (comment = 'upsert');

-- Test 943: statement (line 4134)
INSERT INTO ups VALUES (3, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 944: statement (line 4137)
INSERT INTO ups VALUES (3, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 945: query (line 4140)
SELECT comment FROM ups WHERE pk = 3;

-- Test 946: statement (line 4147)
ALTER POLICY p_upd ON ups USING (true) WITH CHECK (comment = 'original value');

-- Test 947: statement (line 4150)
INSERT INTO ups VALUES (4, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 948: statement (line 4154)
INSERT INTO ups VALUES (4, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 949: query (line 4157)
SELECT comment FROM ups WHERE pk = 4;

-- Test 950: statement (line 4163)
DROP POLICY p_upd ON ups;

-- Test 951: statement (line 4166)
CREATE POLICY p_upd ON ups FOR UPDATE USING (true);

-- Test 952: statement (line 4169)
ALTER POLICY p_ins ON ups WITH CHECK (comment = 'upsert');

-- Test 953: statement (line 4172)
INSERT INTO ups VALUES (5, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 954: statement (line 4175)
ALTER POLICY p_ins ON ups WITH CHECK (comment = 'original value');

-- Test 955: statement (line 4178)
INSERT INTO ups VALUES (5, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 956: statement (line 4183)
INSERT INTO ups VALUES (5, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 957: query (line 4186)
SELECT comment FROM ups WHERE pk = 5;

-- Test 958: statement (line 4192)
ALTER POLICY p_ins ON ups WITH CHECK (true);

-- Test 959: statement (line 4195)
ALTER POLICY p_sel ON ups USING (comment = 'original value');

-- Test 960: statement (line 4198)
INSERT INTO ups VALUES (6, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 961: statement (line 4203)
INSERT INTO ups VALUES (6, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 962: query (line 4206)
SELECT comment FROM ups WHERE pk = 6;

-- Test 963: statement (line 4213)
ALTER POLICY p_sel ON ups USING (comment = 'upsert');

-- Test 964: statement (line 4218)
INSERT INTO ups VALUES (7, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 965: statement (line 4222)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 966: statement (line 4225)
INSERT INTO ups VALUES (7, 'original value');

-- Test 967: statement (line 4228)
ALTER TABLE ups FORCE ROW LEVEL SECURITY;

-- Test 968: statement (line 4233)
INSERT INTO ups VALUES (7, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 969: statement (line 4236)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 970: query (line 4239)
SELECT comment FROM ups WHERE pk = 7;

-- Test 971: statement (line 4244)
ALTER TABLE ups FORCE ROW LEVEL SECURITY;

-- Test 972: statement (line 4248)
DROP POLICY p_sel ON ups;

-- Test 973: statement (line 4251)
DROP POLICY p_ins ON ups;

-- Test 974: statement (line 4254)
DROP POLICY p_upd ON ups;

-- Test 975: statement (line 4257)
CREATE POLICY p_all ON ups FOR ALL USING (comment = 'upsert') WITH CHECK (true);

-- Test 976: statement (line 4261)
INSERT INTO ups VALUES (8, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 977: statement (line 4265)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 978: statement (line 4268)
INSERT INTO ups VALUES (8, 'original value');

-- Test 979: statement (line 4271)
ALTER TABLE ups FORCE ROW LEVEL SECURITY;

-- Test 980: statement (line 4275)
INSERT INTO ups VALUES (8, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 981: statement (line 4278)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 982: query (line 4281)
SELECT comment FROM ups WHERE pk = 8;

-- Test 983: statement (line 4286)
ALTER TABLE ups FORCE ROW LEVEL SECURITY;

-- Test 984: statement (line 4291)
ALTER POLICY p_all ON ups USING (comment = 'original value') WITH CHECK (true);

-- Test 985: statement (line 4294)
INSERT INTO ups VALUES (9, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 986: statement (line 4297)
INSERT INTO ups VALUES (9, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 987: query (line 4300)
SELECT comment FROM ups WHERE pk = 9;

-- Test 988: statement (line 4307)
ALTER POLICY p_all ON ups USING (true) WITH CHECK (comment = 'upsert');

-- Test 989: statement (line 4311)
INSERT INTO ups VALUES (10, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 990: statement (line 4315)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 991: statement (line 4318)
INSERT INTO ups VALUES (10, 'original value');

-- Test 992: statement (line 4321)
ALTER TABLE ups FORCE ROW LEVEL SECURITY;

-- Test 993: statement (line 4331)
INSERT INTO ups VALUES (10, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 994: statement (line 4335)
INSERT INTO ups VALUES (10, 'original value');

-- Test 995: query (line 4338)
SELECT comment FROM ups WHERE pk = 10;

-- Test 996: statement (line 4345)
ALTER POLICY p_all ON ups USING (true) WITH CHECK (comment = 'original value');

-- Test 997: statement (line 4348)
INSERT INTO ups VALUES (11, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 998: statement (line 4352)
INSERT INTO ups VALUES (11, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 999: query (line 4355)
SELECT comment FROM ups WHERE pk = 11;

-- Test 1000: statement (line 4363)
DROP POLICY p_all ON ups;

-- Test 1001: statement (line 4366)
CREATE POLICY p_all ON ups FOR ALL WITH CHECK (true);

-- Test 1002: statement (line 4369)
INSERT INTO ups VALUES (12, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 1003: statement (line 4372)
INSERT INTO ups VALUES (12, 'original value');

-- Test 1004: statement (line 4375)
INSERT INTO ups VALUES (12, 'original value') ON CONFLICT (pk) DO UPDATE SET comment = 'upsert';

-- Test 1005: statement (line 4379)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 1006: query (line 4382)
SELECT comment FROM ups WHERE pk = 12;

-- Test 1007: statement (line 4387)
SET ROLE root;

-- Test 1008: statement (line 4390)
DROP TABLE ups;

-- Test 1009: statement (line 4393)
DROP USER ups;

-- Test 1010: statement (line 4398)
CREATE TABLE ups (pk INT NOT NULL PRIMARY KEY, comment TEXT, c SMALLINT);

-- Test 1011: statement (line 4401)
CREATE USER ups;

-- Test 1012: statement (line 4404)
ALTER TABLE ups OWNER TO ups;

-- Test 1013: statement (line 4407)
SET ROLE ups;

-- Test 1014: statement (line 4410)
ALTER TABLE ups ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 1015: statement (line 4415)
CREATE POLICY p_sel ON ups FOR SELECT USING (comment = 'original value');

-- Test 1016: statement (line 4418)
CREATE POLICY p_ins ON ups FOR INSERT WITH CHECK (true);

-- Test 1017: statement (line 4421)
INSERT INTO ups VALUES (1, 'original value', 1) ON CONFLICT (pk) DO NOTHING;

-- Test 1018: statement (line 4424)
INSERT INTO ups VALUES (1, 'original value', 2) ON CONFLICT (pk) DO NOTHING;

-- Test 1019: statement (line 4431)
INSERT INTO ups VALUES (1, 'upsert', 3) ON CONFLICT (pk) DO NOTHING;

-- Test 1020: query (line 4434)
SELECT comment, c FROM ups WHERE pk = 1;

-- Test 1021: statement (line 4439)
ALTER POLICY p_sel ON ups USING (comment = 'upsert');

-- Test 1022: statement (line 4444)
INSERT INTO ups VALUES (1, 'original value', 4) ON CONFLICT (pk) DO NOTHING;

-- Test 1023: statement (line 4449)
ALTER POLICY p_sel ON ups USING (true);

-- Test 1024: statement (line 4452)
ALTER POLICY p_ins ON ups WITH CHECK (comment = 'original value');

-- Test 1025: statement (line 4455)
INSERT INTO ups VALUES (2, 'first value', 1) ON CONFLICT (pk) DO NOTHING;

-- Test 1026: statement (line 4458)
INSERT INTO ups VALUES (2, 'original value', 2) ON CONFLICT (pk) DO NOTHING;

-- Test 1027: statement (line 4461)
INSERT INTO ups VALUES (2, 'original value', 3) ON CONFLICT (pk) DO NOTHING;

-- Test 1028: statement (line 4467)
INSERT INTO ups VALUES (2, 'upsert', 4) ON CONFLICT (pk) DO NOTHING;

-- Test 1029: query (line 4470)
SELECT comment, c FROM ups WHERE pk = 2;

-- Test 1030: statement (line 4476)
DROP POLICY p_ins ON ups;

-- Test 1031: statement (line 4479)
DROP POLICY p_sel ON ups;

-- Test 1032: statement (line 4482)
CREATE POLICY p_all ON ups FOR ALL USING (comment = 'original value') WITH CHECK (true);

-- Test 1033: statement (line 4485)
INSERT INTO ups VALUES (3, 'first value', 1) ON CONFLICT (pk) DO NOTHING;

-- Test 1034: statement (line 4488)
INSERT INTO ups VALUES (3, 'original value', 2) ON CONFLICT (pk) DO NOTHING;

-- Test 1035: statement (line 4491)
INSERT INTO ups VALUES (3, 'original value', 3) ON CONFLICT (pk) DO NOTHING;

-- Test 1036: statement (line 4497)
INSERT INTO ups VALUES (3, 'upsert', 4) ON CONFLICT (pk) DO NOTHING;

-- Test 1037: query (line 4500)
SELECT comment, c FROM ups WHERE pk = 3;

-- Test 1038: statement (line 4505)
DELETE FROM ups WHERE pk = 3;

-- Test 1039: statement (line 4508)
INSERT INTO ups VALUES (3, 'first value', 5);

-- Test 1040: statement (line 4511)
ALTER POLICY p_all ON ups USING (comment = 'upsert');

-- Test 1041: statement (line 4514)
INSERT INTO ups VALUES (3, 'upsert', 6) ON CONFLICT (pk) DO NOTHING;

-- Test 1042: statement (line 4517)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 1043: query (line 4520)
SELECT comment, c FROM ups WHERE pk = 3;

-- Test 1044: statement (line 4525)
ALTER TABLE ups FORCE ROW LEVEL SECURITY;

-- Test 1045: statement (line 4529)
ALTER POLICY p_all ON ups USING (true) WITH CHECK (comment = 'original value');

-- Test 1046: statement (line 4532)
INSERT INTO ups VALUES (4, 'original value', 1) ON CONFLICT (pk) DO NOTHING;

-- Test 1047: statement (line 4535)
INSERT INTO ups VALUES (4, 'original value', 2) ON CONFLICT (pk) DO NOTHING;

-- Test 1048: statement (line 4541)
INSERT INTO ups VALUES (4, 'upsert', 3) ON CONFLICT (pk) DO NOTHING;

-- Test 1049: query (line 4544)
SELECT comment, c FROM ups WHERE pk = 4;

-- Test 1050: statement (line 4549)
ALTER POLICY p_all ON ups WITH CHECK (comment = 'upsert');

-- Test 1051: statement (line 4552)
INSERT INTO ups VALUES (4, 'upsert', 4) ON CONFLICT (pk) DO NOTHING;

-- Test 1052: statement (line 4555)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 1053: query (line 4558)
SELECT comment, c FROM ups WHERE pk = 4;

-- Test 1054: statement (line 4563)
SET ROLE root;

-- Test 1055: statement (line 4566)
DROP TABLE ups;

-- Test 1056: statement (line 4569)
DROP USER ups;

-- Test 1057: statement (line 4574)
CREATE TABLE ups (pk INT NOT NULL PRIMARY KEY, comment TEXT, c SMALLINT);

-- Test 1058: statement (line 4577)
CREATE USER ups;

-- Test 1059: statement (line 4580)
ALTER TABLE ups OWNER TO ups;

-- Test 1060: statement (line 4583)
SET ROLE ups;

-- Test 1061: statement (line 4586)
ALTER TABLE ups ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 1062: statement (line 4591)
CREATE POLICY p_sel ON ups FOR SELECT USING (true);

-- Test 1063: statement (line 4594)
CREATE POLICY p_ins ON ups FOR INSERT WITH CHECK (true);

-- Test 1064: statement (line 4597)
CREATE POLICY p_upd ON ups FOR UPDATE USING (comment = 'original value') WITH CHECK (true);

-- Test 1065: statement (line 4600)
UPSERT INTO ups VALUES (1, 'original value', 1);

-- Test 1066: statement (line 4604)
UPSERT INTO ups VALUES (1, 'upsert', 2);

-- Test 1067: query (line 4607)
SELECT comment, c FROM ups WHERE pk = 1;

-- Test 1068: statement (line 4613)
UPSERT INTO ups VALUES (1, 'upsert', 3);

-- Test 1069: statement (line 4617)
UPSERT INTO ups VALUES (1, 'original value', 4);

-- Test 1070: query (line 4620)
SELECT comment, c FROM ups WHERE pk = 1;

-- Test 1071: statement (line 4627)
ALTER POLICY p_upd ON ups USING (true) WITH CHECK (comment = 'original value');

-- Test 1072: statement (line 4630)
UPSERT INTO ups VALUES (2, 'original value', 1);

-- Test 1073: statement (line 4634)
UPSERT INTO ups VALUES (2, 'upsert', 2);

-- Test 1074: query (line 4637)
SELECT comment, c FROM ups WHERE pk = 2;

-- Test 1075: statement (line 4643)
ALTER POLICY p_upd ON ups USING (true) WITH CHECK (true);

-- Test 1076: statement (line 4646)
ALTER POLICY p_sel ON ups USING (comment = 'original value');

-- Test 1077: statement (line 4650)
UPSERT INTO ups VALUES (3, 'expect fail', 1);

-- Test 1078: statement (line 4653)
UPSERT INTO ups VALUES (3, 'original value', 2);

-- Test 1079: statement (line 4656)
UPSERT INTO ups VALUES (3, 'original value', 3);

-- Test 1080: statement (line 4659)
UPSERT INTO ups VALUES (3, 'upsert', 4);

-- Test 1081: query (line 4662)
SELECT comment, c FROM ups WHERE pk = 3;

-- Test 1082: statement (line 4667)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 1083: statement (line 4670)
UPSERT INTO ups VALUES (3, 'upsert', 5);

-- Test 1084: statement (line 4673)
ALTER TABLE ups FORCE ROW LEVEL SECURITY;

-- Test 1085: statement (line 4676)
UPSERT INTO ups VALUES (3, 'original value', 6);

-- Test 1086: statement (line 4679)
ALTER TABLE ups NO FORCE ROW LEVEL SECURITY;

-- Test 1087: query (line 4682)
SELECT comment, c FROM ups WHERE pk = 3;

-- Test 1088: statement (line 4687)
ALTER TABLE ups FORCE ROW LEVEL SECURITY;

-- Test 1089: statement (line 4691)
ALTER POLICY p_upd ON ups USING (true) WITH CHECK (true);

-- Test 1090: statement (line 4694)
ALTER POLICY p_ins ON ups WITH CHECK (comment = 'upsert');

-- Test 1091: statement (line 4697)
ALTER POLICY p_sel ON ups USING (true);

-- Test 1092: statement (line 4700)
UPSERT INTO ups VALUES (4, 'original value', 1);

-- Test 1093: statement (line 4703)
ALTER POLICY p_ins ON ups WITH CHECK (comment = 'original value');

-- Test 1094: statement (line 4706)
UPSERT INTO ups VALUES (4, 'original value', 2);

-- Test 1095: statement (line 4710)
UPSERT INTO ups VALUES (4, 'upsert', 3);

-- Test 1096: query (line 4713)
SELECT comment, c FROM ups WHERE pk = 4;

-- Test 1097: statement (line 4718)
SET ROLE root;

-- Test 1098: statement (line 4721)
DROP TABLE ups;

-- Test 1099: statement (line 4724)
DROP USER ups;

-- Test 1100: statement (line 4733)
CREATE ROLE alice LOGIN;

-- Test 1101: statement (line 4736)
CREATE ROLE bob LOGIN;

-- Test 1102: statement (line 4739)
CREATE TABLE t (
  k INT PRIMARY KEY,
  a INT,
  b BOOL,
  FAMILY f (k, a, b)
);

-- Test 1103: statement (line 4747)
INSERT INTO t VALUES (1, 10, true);

-- Test 1104: statement (line 4750)
GRANT SELECT, INSERT, UPDATE, DELETE ON t TO alice, bob;

-- Test 1105: statement (line 4753)
ALTER TABLE t ENABLE ROW LEVEL SECURITY;

-- Test 1106: statement (line 4758)
CREATE POLICY select_policy_alice
ON t
FOR SELECT
TO alice
USING (a > 0 AND b IS true);

-- Test 1107: statement (line 4765)
CREATE POLICY update_policy_alice
ON t
FOR UPDATE
TO alice
USING (true);

-- Test 1108: statement (line 4772)
CREATE POLICY select_policy_bob
ON t
FOR SELECT
TO bob
USING (true);

-- Test 1109: statement (line 4779)
CREATE POLICY update_policy_bob
ON t
FOR UPDATE
TO bob
USING (true);

-- Test 1110: statement (line 4786)
SET ROLE alice;

-- Test 1111: statement (line 4789)
UPDATE t SET a = 0 WHERE true;

-- Test 1112: statement (line 4792)
SET ROLE bob;

-- Test 1113: query (line 4795)
SELECT k, a FROM t;

-- Test 1114: statement (line 4800)
SET ROLE alice;

-- Test 1115: statement (line 4806)
UPDATE t SET a = -1 WHERE true;

-- Test 1116: statement (line 4809)
SET ROLE bob;

-- Test 1117: query (line 4812)
SELECT k, a FROM t;

-- Test 1118: statement (line 4818)
UPDATE t SET k = 1, a = 10 WHERE true;

-- Test 1119: statement (line 4821)
SET ROLE alice;

-- Test 1120: statement (line 4824)
UPDATE t SET a = a - 10 WHERE true;

-- Test 1121: statement (line 4827)
UPDATE t SET a = 0 WHERE k = 1;

-- Test 1122: statement (line 4830)
UPDATE t SET a = 0 WHERE true RETURNING k;

-- Test 1123: statement (line 4833)
UPDATE t SET a = 0 WHERE true RETURNING k + 1;

-- Test 1124: statement (line 4836)
UPDATE t SET a = 0 WHERE true RETURNING (select t.a);

-- Test 1125: statement (line 4839)
UPDATE t SET a = 0 WHERE true RETURNING *;

-- Test 1126: statement (line 4842)
UPDATE t SET a = 0 WHERE true RETURNING t.*;

-- Test 1127: query (line 4845)
UPDATE t SET a = 0 WHERE true RETURNING 'foo';

-- Test 1128: statement (line 4850)
SET ROLE bob;

-- Test 1129: statement (line 4854)
UPDATE t SET k = 1, a = 10 WHERE true;

-- Test 1130: statement (line 4857)
SET ROLE alice;

-- Test 1131: query (line 4860)
UPDATE t SET a = 0 WHERE true RETURNING (select 1);

-- Test 1132: statement (line 4865)
SET ROLE bob;

-- Test 1133: statement (line 4869)
UPDATE t SET k = 1, a = 10 WHERE true;

-- Test 1134: statement (line 4872)
SET ROLE alice;

-- Test 1135: query (line 4875)
UPDATE t SET a = 0 WHERE true RETURNING 1 + 1, 2, 'three';

-- Test 1136: statement (line 4880)
SET ROLE root;

-- Test 1137: statement (line 4884)
UPDATE t SET k = 1, a = 10 WHERE true;

-- Test 1138: statement (line 4889)
CREATE TABLE other (k INT PRIMARY KEY, a INT);

-- Test 1139: statement (line 4895)
INSERT INTO other VALUES (1, -1);

-- Test 1140: statement (line 4898)
GRANT ALL ON other TO alice;

-- Test 1141: statement (line 4901)
SET ROLE alice;

-- Test 1142: statement (line 4904)
UPDATE t SET a = other.a FROM other WHERE true;

-- Test 1143: statement (line 4907)
SET ROLE root;

-- Test 1144: statement (line 4911)
UPDATE t SET k = 1, a = 10 WHERE true;

-- Test 1145: statement (line 4914)
SET ROLE alice;

-- Test 1146: query (line 4919)
UPDATE t SET a = -3 FROM other WHERE true RETURNING other.k;

-- Test 1147: statement (line 4924)
SET ROLE root;

-- Test 1148: query (line 4927)
SELECT a FROM t;

-- Test 1149: statement (line 4933)
UPDATE t SET k = 1, a = 10 WHERE true;

-- Test 1150: statement (line 4936)
SET ROLE alice;

-- Test 1151: statement (line 4939)
UPDATE t SET a = -2 FROM other WHERE other.k = 1;

-- Test 1152: statement (line 4942)
SET ROLE root;

-- Test 1153: query (line 4945)
SELECT a FROM t;

-- Test 1154: statement (line 4950)
DROP TABLE t;

-- Test 1155: statement (line 4953)
DROP TABLE other;

-- Test 1156: statement (line 4956)
DROP ROLE alice, bob;

-- Test 1157: statement (line 4964)
CREATE POLICY p ON alter_policy_table_locked WITH CHECK (TRUE);

-- Test 1158: statement (line 4967)
ALTER POLICY p ON alter_policy_table_locked RENAME TO p_sel;

-- onlyif config schema-locked-disabled

-- Test 1159: query (line 4971)
-- SHOW CREATE TABLE alter_policy_table_locked;

-- Test 1160: query (line 4983)
-- SHOW CREATE TABLE alter_policy_table_locked;

-- Test 1161: statement (line 4994)
ALTER POLICY p_sel ON alter_policy_table_locked WITH CHECK (FALSE);

-- onlyif config schema-locked-disabled

-- Test 1162: query (line 4998)
-- SHOW CREATE TABLE alter_policy_table_locked;

-- Test 1163: query (line 5010)
-- SHOW CREATE TABLE alter_policy_table_locked;

-- Test 1164: statement (line 5023)
CREATE ROLE parent_role;

-- Test 1165: statement (line 5026)
CREATE ROLE child_role;

-- Test 1166: statement (line 5029)
GRANT parent_role TO child_role;

-- Test 1167: statement (line 5032)
CREATE TABLE employees (id SERIAL PRIMARY KEY, name TEXT, department TEXT);

-- Test 1168: statement (line 5035)
INSERT INTO employees VALUES (1, 'Alice', 'Engineering');

-- Test 1169: statement (line 5038)
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;

-- Test 1170: statement (line 5041)
CREATE POLICY parent_policy_select ON employees FOR SELECT TO parent_role USING (true);

-- Test 1171: statement (line 5044)
CREATE POLICY parent_policy_insert ON employees FOR INSERT TO parent_role WITH CHECK (department IN ('Engineering', 'Sales'));

-- Test 1172: statement (line 5047)
CREATE POLICY parent_policy_update ON employees FOR UPDATE TO parent_role USING (false);

-- Test 1173: statement (line 5050)
GRANT SELECT, INSERT, UPDATE ON employees TO parent_role;

-- Test 1174: statement (line 5054)
SET ROLE child_role;

-- Test 1175: query (line 5057)
SELECT * FROM employees;

-- Test 1176: statement (line 5063)
INSERT INTO employees (id, name, department) VALUES (2, 'Bob', 'Engineering');

-- Test 1177: statement (line 5067)
INSERT INTO employees (id, name, department) VALUES (3, 'Carol', 'Sales');

-- Test 1178: statement (line 5071)
INSERT INTO employees (id, name, department) VALUES (4, 'Dave', 'Finance');

-- Test 1179: statement (line 5074)
UPDATE employees SET name = 'Robert' WHERE name = 'Bob';

-- Test 1180: query (line 5077)
SELECT * FROM employees ORDER BY id;

-- Test 1181: statement (line 5084)
RESET ROLE;

-- Test 1182: statement (line 5088)
REVOKE parent_role FROM child_role;

-- Test 1183: statement (line 5091)
GRANT ALL ON employees TO child_role;

-- Test 1184: statement (line 5094)
SET ROLE child_role;

-- Test 1185: query (line 5098)
SELECT * FROM employees;

-- Test 1186: statement (line 5103)
INSERT INTO employees (id, name, department) VALUES (3, 'Eve', 'Engineering');

-- Test 1187: statement (line 5108)
UPDATE employees SET name = 'Alice 2.0' WHERE name = 'Alice';

-- Test 1188: statement (line 5111)
RESET ROLE;

-- Test 1189: query (line 5115)
SELECT * FROM employees ORDER BY id;

-- Test 1190: statement (line 5122)
DROP TABLE employees CASCADE;

-- Test 1191: statement (line 5125)
DROP ROLE child_role;

-- Test 1192: statement (line 5128)
DROP ROLE parent_role;

-- Test 1193: statement (line 5138)
INSERT INTO trigger_rls_table VALUES (1, 100, 'alice'), (2, 200, 'bob'), (3, 300, 'alice'), (4, 400, 'bob');

-- Test 1194: statement (line 5141)
CREATE USER alice;

-- Test 1195: statement (line 5144)
CREATE USER bob;

-- Test 1196: statement (line 5147)
GRANT ALL ON trigger_rls_table TO alice, bob;

-- Test 1197: statement (line 5151)
ALTER TABLE trigger_rls_table ENABLE ROW LEVEL SECURITY;

-- Test 1198: statement (line 5155)
CREATE POLICY owner_policy ON trigger_rls_table
  USING (owner = current_user())
  WITH CHECK (owner = current_user());

-- Test 1199: statement (line 5161)
CREATE FUNCTION log_value_changes() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    RAISE NOTICE 'User % updated value for id % from % to %', current_user(), (NEW).id, (OLD).value, (NEW).value;
  ELSIF TG_OP = 'INSERT' THEN
    RAISE NOTICE 'User % inserted new row with id % and value %', current_user(), (NEW).id, (NEW).value;
  ELSIF TG_OP = 'DELETE' THEN
    RAISE NOTICE 'User % deleted row with id % and value %', current_user(), (OLD).id, (OLD).value;
  END IF;
  RETURN NEW;
END;
$$;

-- Test 1200: statement (line 5176)
CREATE FUNCTION enforce_positive_value() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$
BEGIN
  IF (NEW).value <= 0 THEN
    RAISE EXCEPTION 'Value must be positive';
  END IF;
  RETURN NEW;
END;
$$;

-- Test 1201: statement (line 5187)
CREATE TRIGGER log_changes
  AFTER INSERT OR UPDATE OR DELETE ON trigger_rls_table
  FOR EACH ROW
  EXECUTE FUNCTION log_value_changes();

-- Test 1202: statement (line 5194)
CREATE TRIGGER check_positive_value
  BEFORE INSERT OR UPDATE ON trigger_rls_table
  FOR EACH ROW
  EXECUTE FUNCTION enforce_positive_value();

-- Test 1203: statement (line 5201)
SET ROLE alice;

-- Test 1204: query (line 5205)
SELECT * FROM trigger_rls_table ORDER BY id;

-- Test 1205: query (line 5212)
UPDATE trigger_rls_table SET value = 150 WHERE id = 1;

-- Test 1206: query (line 5218)
UPDATE trigger_rls_table SET value = 250 WHERE id = 2;

-- Test 1207: statement (line 5223)
UPDATE trigger_rls_table SET value = -100 WHERE id = 1;

-- Test 1208: query (line 5227)
INSERT INTO trigger_rls_table VALUES (5, 500, 'alice');

-- Test 1209: statement (line 5233)
INSERT INTO trigger_rls_table VALUES (6, 600, 'bob');

-- Test 1210: query (line 5237)
DELETE FROM trigger_rls_table WHERE id = 3;

-- Test 1211: statement (line 5243)
SET ROLE bob;

-- Test 1212: query (line 5247)
SELECT * FROM trigger_rls_table ORDER BY id;

-- Test 1213: query (line 5254)
UPDATE trigger_rls_table SET value = 250 WHERE id = 2;

-- Test 1214: query (line 5260)
UPDATE trigger_rls_table SET value = 175 WHERE id = 1;

-- Test 1215: query (line 5265)
INSERT INTO trigger_rls_table VALUES (7, 700, 'bob');

-- Test 1216: statement (line 5271)
CREATE FUNCTION try_bypass_rls() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$
BEGIN
  UPDATE trigger_rls_table SET value = 999 WHERE owner = 'alice';
  RETURN NEW;
END;
$$;

-- Test 1217: statement (line 5279)
CREATE TRIGGER bypass_attempt
  AFTER INSERT ON trigger_rls_table
  FOR EACH ROW
  EXECUTE FUNCTION try_bypass_rls();

-- Test 1218: statement (line 5286)
INSERT INTO trigger_rls_table VALUES (8, 800, 'bob');

-- Test 1219: statement (line 5290)
SET ROLE root;

-- Test 1220: query (line 5294)
SELECT * FROM trigger_rls_table WHERE owner = 'alice' ORDER BY id;

-- Test 1221: statement (line 5301)
SET ROLE alice;

-- Test 1222: statement (line 5305)
CREATE FUNCTION change_owner_to_bob() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$
BEGIN
  NEW.owner = 'bob';
  RETURN NEW;
END;
$$;

-- Test 1223: statement (line 5314)
CREATE TRIGGER force_bob_ownership
  BEFORE INSERT ON trigger_rls_table
  FOR EACH ROW
  EXECUTE FUNCTION change_owner_to_bob();

-- Test 1224: statement (line 5322)
INSERT INTO trigger_rls_table VALUES (9, 900, 'alice');

-- Test 1225: statement (line 5326)
CREATE FUNCTION change_updated_owner_to_bob() RETURNS TRIGGER LANGUAGE PLPGSQL AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    NEW.owner = 'bob';
  END IF;
  RETURN NEW;
END;
$$;

-- Test 1226: statement (line 5336)
CREATE TRIGGER force_update_bob_ownership
  BEFORE UPDATE ON trigger_rls_table
  FOR EACH ROW
  EXECUTE FUNCTION change_updated_owner_to_bob();

-- Test 1227: statement (line 5344)
UPDATE trigger_rls_table SET value = 600 WHERE id = 5;

-- Test 1228: statement (line 5348)
SET ROLE bob;

-- Test 1229: query (line 5352)
INSERT INTO trigger_rls_table VALUES (10, 1000, 'alice');

-- Test 1230: query (line 5358)
SELECT * FROM trigger_rls_table WHERE id = 10;

-- Test 1231: statement (line 5364)
SET ROLE root;

-- Test 1232: query (line 5368)
SELECT * FROM trigger_rls_table ORDER BY id;

-- Test 1233: statement (line 5380)
DROP TRIGGER force_bob_ownership ON trigger_rls_table;
DROP TRIGGER force_update_bob_ownership ON trigger_rls_table;
DROP FUNCTION change_owner_to_bob;
DROP FUNCTION change_updated_owner_to_bob;
DROP TRIGGER log_changes ON trigger_rls_table;
DROP TRIGGER check_positive_value ON trigger_rls_table;
DROP TRIGGER bypass_attempt ON trigger_rls_table;
DROP FUNCTION log_value_changes;
DROP FUNCTION enforce_positive_value;
DROP FUNCTION try_bypass_rls;
DROP TABLE trigger_rls_table;
DROP USER alice;
DROP USER bob;

-- Test 1234: statement (line 5397)
CREATE ROLE can_bypassrls WITH BYPASSRLS;

-- Test 1235: statement (line 5400)
CREATE ROLE cannot_bypassrls;

-- Test 1236: statement (line 5403)
CREATE ROLE can_bypassrls_global;

-- Test 1237: statement (line 5406)
-- GRANT SYSTEM BYPASSRLS TO can_bypassrls_global;

-- Test 1238: query (line 5409)
SELECT rolbypassrls FROM pg_authid WHERE rolname = 'can_bypassrls' OR rolname = 'can_bypassrls_global';

-- Test 1239: query (line 5415)
SELECT rolbypassrls FROM pg_authid WHERE rolname = 'cannot_bypassrls';

-- Test 1240: query (line 5420)
SELECT rolbypassrls FROM pg_roles WHERE rolname = 'can_bypassrls' OR rolname = 'can_bypassrls_global';

-- Test 1241: query (line 5427)
SELECT rolbypassrls FROM pg_roles WHERE rolname = 'cannot_bypassrls';

-- Test 1242: statement (line 5433)
DROP ROLE can_bypassrls;

-- Test 1243: statement (line 5436)
DROP ROLE cannot_bypassrls;

-- Test 1244: statement (line 5441)
CREATE ROLE can_createrole WITH CREATEROLE;

-- Test 1245: statement (line 5444)
CREATE ROLE cannot_createrole;

-- Test 1246: statement (line 5447)
CREATE ROLE can_createrole_global;

-- Test 1247: statement (line 5450)
-- GRANT SYSTEM CREATEROLE TO can_createrole_global;

-- Test 1248: query (line 5453)
SELECT rolcreaterole FROM pg_authid WHERE rolname = 'can_createrole' OR rolname = 'can_createrole_global';

-- Test 1249: query (line 5459)
SELECT rolcreaterole FROM pg_authid WHERE rolname = 'cannot_createrole';

-- Test 1250: query (line 5464)
SELECT rolcreaterole FROM pg_roles WHERE rolname = 'can_createrole' OR rolname = 'can_createrole_global';

-- Test 1251: query (line 5470)
SELECT rolcreaterole FROM pg_roles WHERE rolname = 'cannot_createrole';

-- Test 1252: statement (line 5475)
DROP ROLE can_createrole;

-- Test 1253: statement (line 5478)
DROP ROLE cannot_createrole;

-- Test 1254: statement (line 5481)
-- REVOKE SYSTEM CREATEROLE FROM can_createrole_global;

-- Test 1255: statement (line 5484)
DROP ROLE can_createrole_global;

-- Test 1256: statement (line 5489)
CREATE ROLE can_createdb WITH CREATEDB;

-- Test 1257: statement (line 5492)
CREATE ROLE cannot_createdb;

-- Test 1258: statement (line 5495)
CREATE ROLE can_createdb_global;

-- Test 1259: statement (line 5498)
-- GRANT SYSTEM CREATEDB TO can_createdb_global;

-- Test 1260: query (line 5501)
SELECT rolcreatedb FROM pg_authid WHERE rolname = 'can_createdb' OR rolname = 'can_createdb_global';

-- Test 1261: query (line 5507)
SELECT rolcreatedb FROM pg_authid WHERE rolname = 'cannot_createdb';

-- Test 1262: query (line 5512)
SELECT rolcreatedb FROM pg_roles WHERE rolname = 'can_createdb' OR rolname = 'can_createdb_global';

-- Test 1263: query (line 5518)
SELECT rolcreatedb FROM pg_roles WHERE rolname = 'cannot_createdb';

-- Test 1264: statement (line 5523)
DROP ROLE can_createdb;

-- Test 1265: statement (line 5526)
DROP ROLE cannot_createdb;

-- Test 1266: statement (line 5529)
-- REVOKE SYSTEM CREATEDB FROM can_createdb_global;

-- Test 1267: statement (line 5532)
DROP ROLE can_createdb_global;

-- Test 1268: statement (line 5540)
CREATE TABLE dep_test (id INT PRIMARY KEY, value INT);

-- Test 1269: statement (line 5543)
CREATE SEQUENCE seq_with_check;

-- Test 1270: statement (line 5546)
CREATE FUNCTION func_using_old(n INT) RETURNS BOOL AS $$ SELECT n > 0; $$ LANGUAGE SQL;

-- Test 1271: statement (line 5549)
CREATE FUNCTION func_using_new(n INT) RETURNS BOOL AS $$ SELECT n >= 0; $$ LANGUAGE SQL;

-- Test 1272: statement (line 5554)
CREATE POLICY test_policy ON dep_test
  FOR ALL
  USING (func_using_old(value))
  WITH CHECK (nextval('seq_with_check') < 1000);

-- Test 1273: statement (line 5561)
DROP FUNCTION func_using_old;

-- Test 1274: statement (line 5564)
DROP SEQUENCE seq_with_check;

-- Test 1275: statement (line 5569)
ALTER POLICY test_policy ON dep_test USING (func_using_new(value));

-- Test 1276: statement (line 5573)
DROP SEQUENCE seq_with_check;

-- Test 1277: statement (line 5577)
DROP FUNCTION func_using_old;

-- Test 1278: statement (line 5581)
DROP FUNCTION func_using_new;

-- Test 1279: statement (line 5584)
DROP TABLE dep_test CASCADE;

-- Test 1280: statement (line 5587)
DROP SEQUENCE seq_with_check;

-- Test 1281: statement (line 5590)
DROP FUNCTION func_using_new;

-- Test 1282: statement (line 5597)
CREATE ROLE alice;

-- Test 1283: statement (line 5600)
CREATE TABLE t (x INT PRIMARY KEY, y INT, alice_has_access BOOL);

-- Test 1284: statement (line 5603)
CREATE INDEX ON t(y);

-- Test 1285: statement (line 5606)
INSERT INTO t VALUES (1, 10, true), (2, 20, false);

-- Test 1286: statement (line 5609)
GRANT SELECT, INSERT, UPDATE, DELETE ON t TO alice;

-- Test 1287: statement (line 5612)
ALTER TABLE t ENABLE ROW LEVEL SECURITY;

-- Test 1288: statement (line 5615)
CREATE POLICY select_policy_alice
ON t
FOR SELECT
TO alice
USING (alice_has_access);

-- Test 1289: statement (line 5622)
SET ROLE alice;

-- Test 1290: query (line 5629)
SELECT * FROM t WHERE y = 20 AND y/0 = 0;

-- Test 1291: query (line 5634)
SELECT * FROM t WHERE y = 20 AND ARRAY[1,2,3][10] = 1;

-- Test 1292: query (line 5639)
UPDATE t SET y = y WHERE y = 20 AND ARRAY[1,2,3][10] = 1 RETURNING *;

-- Test 1293: statement (line 5644)
CREATE FUNCTION fail() RETURNS INT AS $$ BEGIN RAISE EXCEPTION 'fail'; END; $$ LANGUAGE plpgsql;

-- Test 1294: query (line 5647)
DELETE FROM t WHERE y = 20 AND fail() = 1 RETURNING *;

-- Test 1295: statement (line 5652)
CREATE FUNCTION divbyzero() RETURNS INT IMMUTABLE LEAKPROOF
AS $$
 BEGIN
   SELECT 20 / 0;
   RETURN 1;
 END;
$$ LANGUAGE plpgsql;

-- Test 1296: statement (line 5662)
SELECT * FROM t WHERE y = 10 AND divbyzero() = 1;

-- Test 1297: query (line 5666)
SELECT * FROM t WHERE y = 20 AND divbyzero() = 1;

-- Test 1298: query (line 5671)
SELECT * FROM t WHERE y = 20 AND 'a' ~ '(';

-- Test 1299: query (line 5676)
UPDATE t SET y = y WHERE y = 20 AND power(1e400, 1) > 0 RETURNING *;

-- Test 1300: query (line 5681)
WITH rows AS (
  SELECT x FROM t WHERE y = 20 AND y/0 = 0
)
DELETE FROM t WHERE x IN (SELECT x FROM rows) RETURNING *;

-- Test 1301: statement (line 5691)
INSERT INTO t VALUES (2, 20, false) ON CONFLICT(x) DO UPDATE SET y = 20;

-- Test 1302: statement (line 5694)
RESET ROLE;

-- Test 1303: statement (line 5697)
DROP TABLE t;

-- Test 1304: statement (line 5700)
DROP FUNCTION fail, divbyzero;

-- Test 1305: statement (line 5703)
DROP ROLE alice;

-- Test 1306: statement (line 5708)
CREATE TABLE roach_pg_table ( count INT );

-- Test 1307: statement (line 5711)
SET allow_view_with_security_invoker_clause = on;

-- Test 1308: statement (line 5714)
CREATE VIEW security_invoker_view WITH ( security_invoker = true ) AS SELECT * FROM roach_pg_table;

-- Test 1309: statement (line 5717)
ALTER VIEW security_invoker_view SET ( security_invoker = false );

-- Test 1310: statement (line 5720)
DROP VIEW security_invoker_view;

-- Test 1311: statement (line 5723)
DROP TABLE roach_pg_table;

-- Test 1312: statement (line 5726)
SET allow_view_with_security_invoker_clause = off;

-- Test 1313: statement (line 5733)
CREATE USER alice;

-- Test 1314: statement (line 5736)
CREATE TABLE accounts (
    id INT PRIMARY KEY,
    owner TEXT,
    balance INT
);

-- Test 1315: statement (line 5743)
INSERT INTO accounts VALUES
  (1, 'alice', 100),
  (2, 'bob', 200);

-- Test 1316: statement (line 5748)
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;

-- Test 1317: statement (line 5751)
GRANT ALL ON accounts TO alice;

-- Test 1318: statement (line 5754)
SET ROLE alice;

-- Test 1319: query (line 5758)
SELECT * FROM accounts;

-- Test 1320: statement (line 5762)
SET SESSION row_security = 'off';

-- Test 1321: statement (line 5765)
SELECT * FROM accounts;

-- Test 1322: statement (line 5768)
RESET row_security;

-- Test 1323: statement (line 5771)
SET ROLE root;

-- Test 1324: statement (line 5775)
CREATE POLICY user_is_owner ON accounts
  USING (owner = current_user());

-- Test 1325: statement (line 5779)
SET ROLE alice;

-- Test 1326: query (line 5782)
SELECT * FROM accounts;

-- Test 1327: statement (line 5787)
SET SESSION row_security = 'off';

-- Test 1328: statement (line 5790)
SELECT * FROM accounts;

-- Test 1329: statement (line 5793)
RESET row_security;

-- Test 1330: statement (line 5797)
INSERT INTO accounts VALUES (3, 'alice', 300);

-- Test 1331: statement (line 5800)
UPDATE accounts SET balance = balance + 50 WHERE id = 3;

-- Test 1332: statement (line 5803)
SET SESSION row_security = 'off';

-- Test 1333: statement (line 5806)
INSERT INTO accounts VALUES (5, 'alice', 500);

-- Test 1334: statement (line 5809)
UPDATE accounts SET balance = balance + 50 WHERE id = 3;

-- Test 1335: statement (line 5812)
RESET row_security;

-- Test 1336: statement (line 5816)
DELETE FROM accounts WHERE id = 1;

-- Test 1337: statement (line 5819)
UPSERT INTO accounts VALUES (3, 'alice', 400);

-- Test 1338: statement (line 5822)
SET SESSION row_security = 'off';

-- Test 1339: statement (line 5825)
DELETE FROM accounts WHERE id = 3;

-- Test 1340: statement (line 5828)
UPSERT INTO accounts VALUES (6, 'alice', 600);

-- Test 1341: statement (line 5831)
RESET row_security;

-- Test 1342: statement (line 5834)
SET ROLE root;

-- Test 1343: statement (line 5838)
ALTER TABLE accounts OWNER TO alice;

-- Test 1344: statement (line 5841)
SET ROLE alice;

-- Test 1345: statement (line 5844)
DROP POLICY user_is_owner ON accounts;

-- Test 1346: statement (line 5847)
CREATE POLICY deny_all ON accounts USING (false);

-- Test 1347: query (line 5850)
SELECT * FROM accounts;

-- Test 1348: statement (line 5856)
SET SESSION row_security = 'off';

-- Test 1349: query (line 5859)
SELECT * FROM accounts;

-- Test 1350: statement (line 5865)
RESET row_security;

-- Test 1351: statement (line 5869)
ALTER TABLE accounts FORCE ROW LEVEL SECURITY;

-- Test 1352: query (line 5872)
SELECT * FROM accounts;

-- Test 1353: statement (line 5876)
SET SESSION row_security = 'off';

-- Test 1354: statement (line 5879)
SELECT * FROM accounts;

-- Test 1355: statement (line 5882)
RESET row_security;

-- Test 1356: statement (line 5885)
SET ROLE root;

-- Test 1357: statement (line 5889)
SET SESSION row_security = 'off';

-- Test 1358: query (line 5892)
SELECT * FROM accounts;

-- Test 1359: statement (line 5898)
RESET row_security;

-- Test 1360: statement (line 5902)
CREATE TABLE non_rls (id INT PRIMARY KEY);

-- Test 1361: statement (line 5905)
INSERT INTO non_rls VALUES (1), (2);

-- Test 1362: statement (line 5908)
GRANT ALL ON non_rls TO alice;

-- Test 1363: statement (line 5911)
SET ROLE alice;

-- Test 1364: statement (line 5914)
SET SESSION row_security = 'off';

-- Test 1365: query (line 5917)
SELECT * FROM non_rls;

-- Test 1366: statement (line 5923)
SET ROLE root;

-- Test 1367: statement (line 5926)
DROP TABLE accounts, non_rls;

-- Test 1368: statement (line 5929)
DROP USER alice;

-- Test 1369: statement (line 5932)
RESET SESSION row_security;

-- Test 1370: statement (line 5941)
CREATE TABLE t158154 (c0 INT, c1 TEXT DEFAULT 'foobarbaz');

-- Test 1371: statement (line 5944)
CREATE ROLE user_158154;

-- Test 1372: statement (line 5947)
GRANT ALL ON t158154 TO user_158154;

-- Test 1373: statement (line 5950)
ALTER TABLE t158154 ENABLE ROW LEVEL SECURITY, FORCE ROW LEVEL SECURITY;

-- Test 1374: statement (line 5953)
ALTER TABLE t158154 OWNER TO user_158154;

-- Test 1375: statement (line 5956)
SET ROLE user_158154;

-- Test 1376: statement (line 5959)
SELECT EXISTS (SELECT 1 FROM pg_policies WHERE schemaname = current_schema() AND tablename = 't158154' AND policyname = 'p1') AS policy_exists \gset
\if :policy_exists
-- CREATE POLICY IF NOT EXISTS p1 on t158154 WITH CHECK (c0 > 0 AND c1 = 'foobarbaz');
\else
CREATE POLICY p1 on t158154 WITH CHECK (c0 > 0 AND c1 = 'foobarbaz');
\endif

-- Test 1377: statement (line 5962)
CREATE PROCEDURE p158154() LANGUAGE SQL AS $$
  UPDATE t158154 SET c0 = 1 WHERE true;
$$;

-- Test 1378: statement (line 5967)
CALL p158154();

-- Test 1379: statement (line 5972)
DROP POLICY p1 on t158154;
ALTER TABLE t158154 DROP COLUMN c1;

-- Test 1380: statement (line 5976)
CALL p158154();

-- Test 1381: statement (line 5979)
SET ROLE root;

-- Test 1382: statement (line 5982)
DROP PROCEDURE p158154;
DROP TABLE t158154;

-- Test 1383: statement (line 5986)
DROP ROLE user_158154;
