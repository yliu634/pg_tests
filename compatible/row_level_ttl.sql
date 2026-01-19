-- PostgreSQL compatible tests from row_level_ttl
-- 211 tests

-- Test 1: statement (line 4)
CREATE TABLE tbl (id INT PRIMARY KEY) WITH (ttl_expire_after = ' xx invalid interval xx')

-- Test 2: statement (line 11)
CREATE TABLE tbl (id INT PRIMARY KEY) WITH (ttl_expire_after = '-10 minutes')

-- Test 3: statement (line 18)
CREATE TABLE tbl (id INT PRIMARY KEY) WITH (ttl_expiration_expression = 0)

-- Test 4: statement (line 25)
CREATE TABLE tbl (id INT PRIMARY KEY) WITH (ttl_expiration_expression = '; DROP DATABASE defaultdb')

-- Test 5: statement (line 28)
CREATE TABLE tbl (id INT PRIMARY KEY) WITH (ttl_expiration_expression = 'now(), now()')

-- Test 6: statement (line 35)
CREATE TABLE tbl (id INT PRIMARY KEY) WITH (ttl_expiration_expression = 'id')

-- Test 7: statement (line 43)
CREATE TABLE tbl_ttl_expiration_expression_volatility_stable (
  id INT PRIMARY KEY,
  expire_at timestamptz
) WITH (ttl_expiration_expression = $$expire_at + '10 minutes'$$)

-- Test 8: statement (line 53)
CREATE TABLE tbl (id INT PRIMARY KEY) WITH (ttl = 'on')

-- Test 9: query (line 62)
CREATE TABLE tbl_ttl_automatic_column (id INT PRIMARY KEY) WITH (ttl_automatic_column = 'on')

-- Test 10: query (line 69)
ALTER TABLE tbl_ttl_automatic_column RESET (ttl_automatic_column)

-- Test 11: query (line 80)
CREATE TABLE tbl_ttl_range_concurrency (id INT PRIMARY KEY) WITH (ttl_range_concurrency = 2)

-- Test 12: query (line 87)
ALTER TABLE tbl_ttl_range_concurrency RESET (ttl_range_concurrency)

-- Test 13: statement (line 96)
CREATE TABLE tbl (
  id INT PRIMARY KEY,
  crdb_internal_expiration TIMESTAMPTZ
) WITH (ttl_expire_after = '10 minutes')

-- Test 14: statement (line 106)
CREATE TABLE tbl (
  id INT PRIMARY KEY,
  crdb_internal_expiration TIMESTAMPTZ DEFAULT current_timestamp() + '10 minutes'
) WITH (ttl_expire_after = '10 minutes')

-- Test 15: statement (line 116)
CREATE TABLE crdb_internal_functions_tbl (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')

onlyif config schema-locked-disabled

-- Test 16: query (line 122)
SELECT create_statement FROM [SHOW CREATE TABLE crdb_internal_functions_tbl]

-- Test 17: query (line 132)
SELECT create_statement FROM [SHOW CREATE TABLE crdb_internal_functions_tbl]

-- Test 18: statement (line 141)
SELECT crdb_internal.validate_ttl_scheduled_jobs()

-- Test 19: statement (line 144)
SELECT crdb_internal.repair_ttl_table_scheduled_job('crdb_internal_functions_tbl'::regclass::oid)

-- Test 20: statement (line 147)
SELECT crdb_internal.validate_ttl_scheduled_jobs()

let $crdb_internal_functions_tbl_oid
SELECT 'crdb_internal_functions_tbl'::regclass::oid

user testuser

-- Test 21: statement (line 155)
SELECT crdb_internal.repair_ttl_table_scheduled_job($crdb_internal_functions_tbl_oid)

-- Test 22: statement (line 158)
SELECT crdb_internal.validate_ttl_scheduled_jobs()

user root

-- Test 23: statement (line 167)
CREATE TABLE ttl_expire_after_required() WITH (ttl_expire_after='10 minutes')

-- Test 24: statement (line 170)
ALTER TABLE ttl_expire_after_required RESET (ttl_expire_after)

-- Test 25: statement (line 177)
CREATE TABLE ttl_expiration_expression_required(expire_at TIMESTAMPTZ) WITH (ttl_expiration_expression='expire_at')

-- Test 26: statement (line 180)
ALTER TABLE ttl_expiration_expression_required RESET (ttl_expiration_expression)

-- Test 27: statement (line 187)
CREATE TABLE alter_table_crdb_internal_expiration_incorrect_explicit_default() WITH (ttl_expire_after='10 minutes')

-- Test 28: statement (line 190)
ALTER TABLE alter_table_crdb_internal_expiration_incorrect_explicit_default ALTER COLUMN crdb_internal_expiration SET DEFAULT current_timestamp()

-- Test 29: statement (line 197)
CREATE TABLE alter_table_crdb_internal_expiration_incorrect_explicit_on_update() WITH (ttl_expire_after='10 minutes')

-- Test 30: statement (line 200)
ALTER TABLE alter_table_crdb_internal_expiration_incorrect_explicit_on_update ALTER COLUMN crdb_internal_expiration SET ON UPDATE current_timestamp()

-- Test 31: statement (line 207)
CREATE TABLE drop_column_crdb_internal_expiration() WITH (ttl_expire_after='10 minutes')

-- Test 32: statement (line 210)
ALTER TABLE drop_column_crdb_internal_expiration DROP COLUMN crdb_internal_expiration

-- Test 33: statement (line 217)
CREATE TABLE alter_column_crdb_internal_expiration() WITH (ttl_expire_after='10 minutes')

-- Test 34: statement (line 220)
ALTER TABLE alter_column_crdb_internal_expiration ALTER COLUMN crdb_internal_expiration SET NOT NULL

-- Test 35: statement (line 227)
CREATE TABLE alter_column_crdb_internal_expiration_rename() WITH (ttl_expire_after='10 minutes')

-- Test 36: statement (line 230)
ALTER TABLE alter_column_crdb_internal_expiration_rename RENAME COLUMN crdb_internal_expiration TO crdb_internal_expiration_2

-- Test 37: query (line 252)
SELECT * FROM (SELECT unnest(reloptions) as opt FROM pg_class WHERE relname = 'tbl_reloptions') WHERE opt NOT LIKE 'schema_locked%'

-- Test 38: statement (line 270)
CREATE TABLE tbl_schedules (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')

let $label_suffix
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl_schedules'

-- Test 39: statement (line 287)
DROP SCHEDULE $schedule_id

-- Test 40: statement (line 298)
SET autocommit_before_ddl = false

onlyif config local-legacy-schema-changer

-- Test 41: statement (line 302)
CREATE TABLE tbl_existing_ttl_concurrent_schema_change (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes', schema_locked=false)

onlyif config local-legacy-schema-changer

-- Test 42: statement (line 308)
ALTER TABLE tbl_existing_ttl_concurrent_schema_change RESET (ttl), RESET (ttl_expire_after)

onlyif config local-legacy-schema-changer

-- Test 43: statement (line 312)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE tbl_existing_ttl_concurrent_schema_change RESET (ttl);
ALTER TABLE tbl_existing_ttl_concurrent_schema_change SET (ttl_select_batch_size = 200)

onlyif config local-legacy-schema-changer

-- Test 44: statement (line 318)
ROLLBACK

onlyif config local-legacy-schema-changer

-- Test 45: statement (line 322)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE tbl_existing_ttl_concurrent_schema_change RESET (ttl);
CREATE INDEX tbl_idx ON tbl_existing_ttl_concurrent_schema_change (id)

onlyif config local-legacy-schema-changer

-- Test 46: statement (line 328)
ROLLBACK

onlyif config local-legacy-schema-changer

-- Test 47: statement (line 332)
RESET autocommit_before_ddl

-- Test 48: statement (line 340)
SET autocommit_before_ddl = false

onlyif config local-legacy-schema-changer

-- Test 49: statement (line 344)
CREATE TABLE tbl_add_ttl_concurrent_schema_change (
   id INT PRIMARY KEY
) WITH (schema_locked = false)

onlyif config local-legacy-schema-changer

-- Test 50: statement (line 350)
ALTER TABLE tbl_add_ttl_concurrent_schema_change SET (ttl_expire_after = '10 minutes'), SET (ttl_select_batch_size = 200)

onlyif config local-legacy-schema-changer

-- Test 51: statement (line 354)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE tbl_add_ttl_concurrent_schema_change SET (ttl_expire_after = '10 minutes');
ALTER TABLE tbl_add_ttl_concurrent_schema_change RESET (ttl_select_batch_size)

onlyif config local-legacy-schema-changer

-- Test 52: statement (line 360)
ROLLBACK

onlyif config local-legacy-schema-changer

-- Test 53: statement (line 364)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
CREATE INDEX tbl_idx ON tbl_add_ttl_concurrent_schema_change (id);
ALTER TABLE tbl_add_ttl_concurrent_schema_change SET (ttl_expire_after = '10 minutes');

onlyif config local-legacy-schema-changer

-- Test 54: statement (line 370)
ROLLBACK

onlyif config local-legacy-schema-changer

-- Test 55: statement (line 374)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ALTER TABLE tbl_add_ttl_concurrent_schema_change SET (ttl_expire_after = '10 minutes');
CREATE INDEX tbl_idx ON tbl_add_ttl_concurrent_schema_change (id)

onlyif config local-legacy-schema-changer

-- Test 56: statement (line 380)
ROLLBACK

onlyif config local-legacy-schema-changer

-- Test 57: statement (line 384)
RESET autocommit_before_ddl

-- Test 58: statement (line 391)
CREATE TABLE tbl_reset_ttl (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')

let $label_suffix
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl_reset_ttl'

-- Test 59: statement (line 406)
ALTER TABLE tbl_reset_ttl SET (ttl = 'off')

-- Test 60: statement (line 410)
ALTER TABLE tbl_reset_ttl RESET (ttl)

onlyif config schema-locked-disabled

-- Test 61: query (line 414)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_reset_ttl]

-- Test 62: query (line 423)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_reset_ttl]

-- Test 63: statement (line 431)
SELECT crdb_internal.validate_ttl_scheduled_jobs()

-- Test 64: statement (line 446)
CREATE TABLE tbl_rename (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')

let $label_suffix
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl_rename'

-- Test 65: statement (line 460)
ALTER TABLE tbl_rename RENAME TO tbl_renamed

-- Test 66: statement (line 482)
CREATE TABLE tbl_rename_legacy_label (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')

let $label_suffix
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl_rename_legacy_label'

-- Test 67: statement (line 498)
UPDATE system.scheduled_jobs SET schedule_name = 'row-level-ttl-1234' WHERE schedule_name = 'row-level-ttl: $label_suffix';

-- Test 68: statement (line 501)
ALTER TABLE tbl_rename_legacy_label RENAME TO tbl_renamed2

let $label_suffix
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl_renamed2'

-- Test 69: statement (line 525)
CREATE TABLE tbl_drop_table (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')


let $label_suffix
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl_drop_table'

-- Test 70: statement (line 540)
DROP TABLE tbl_drop_table

-- Test 71: statement (line 554)
CREATE SCHEMA drop_me

-- Test 72: statement (line 557)
CREATE TABLE drop_me.tbl () WITH (ttl_expire_after = '10 minutes');
CREATE TABLE drop_me.tbl2 () WITH (ttl_expire_after = '10 minutes')

let $label_suffix
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl'

let $label_suffix2
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl2'

-- Test 73: statement (line 573)
DROP SCHEMA drop_me CASCADE

-- Test 74: statement (line 587)
CREATE DATABASE drop_me

-- Test 75: statement (line 590)
USE drop_me

-- Test 76: statement (line 593)
CREATE TABLE tbl () WITH (ttl_expire_after = '10 minutes');
CREATE TABLE tbl2 () WITH (ttl_expire_after = '10 minutes')

let $label_suffix
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl'

let $label_suffix2
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl2'

-- Test 77: statement (line 609)
USE test;

-- Test 78: statement (line 612)
DROP DATABASE drop_me CASCADE

-- Test 79: statement (line 625)
CREATE TABLE tbl (
  id INT PRIMARY KEY,
  crdb_internal_expiration INTERVAL
) WITH (ttl_expire_after = '10 minutes')

-- Test 80: statement (line 635)
CREATE TABLE tbl_ttl_on_noop (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')

onlyif config schema-locked-disabled

-- Test 81: query (line 641)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_ttl_on_noop]

-- Test 82: query (line 651)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_ttl_on_noop]

-- Test 83: statement (line 661)
ALTER TABLE tbl_ttl_on_noop SET (ttl = 'on')

onlyif config schema-locked-disabled

-- Test 84: query (line 665)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_ttl_on_noop]

-- Test 85: query (line 675)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_ttl_on_noop]

-- Test 86: query (line 697)
SELECT create_statement FROM [SHOW CREATE SCHEDULE $schedule_id]

-- Test 87: statement (line 706)
CREATE TABLE tbl () WITH (ttl_expire_after = '10 seconds', ttl_job_cron = 'bad expr')

-- Test 88: statement (line 713)
CREATE TABLE tbl_create_ttl_job_cron (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes', ttl_job_cron = '@daily')

onlyif config schema-locked-disabled

-- Test 89: query (line 719)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_create_ttl_job_cron]

-- Test 90: query (line 729)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_create_ttl_job_cron]

-- Test 91: statement (line 753)
CREATE TABLE tbl_set_ttl_job_cron (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes', ttl_job_cron = '@daily')

-- Test 92: statement (line 758)
ALTER TABLE tbl_set_ttl_job_cron SET (ttl_job_cron = '@weekly')

let $label_suffix
SELECT relname || ' [' || oid || ']' FROM pg_class WHERE relname = 'tbl_set_ttl_job_cron'

-- Test 93: query (line 771)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_ttl_job_cron]

-- Test 94: query (line 781)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_ttl_job_cron]

-- Test 95: statement (line 805)
CREATE TABLE tbl_reset_ttl_job_cron (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes', ttl_job_cron = '@daily')

-- Test 96: statement (line 810)
ALTER TABLE tbl_reset_ttl_job_cron RESET (ttl_job_cron)

onlyif config schema-locked-disabled

-- Test 97: query (line 814)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_reset_ttl_job_cron]

-- Test 98: query (line 824)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_reset_ttl_job_cron]

-- Test 99: statement (line 846)
CREATE TABLE no_ttl_table ()

-- Test 100: statement (line 849)
ALTER TABLE no_ttl_table SET (ttl_select_batch_size = 50)

-- Test 101: statement (line 852)
ALTER TABLE no_ttl_table SET (ttl_delete_batch_size = 50)

-- Test 102: statement (line 855)
ALTER TABLE no_ttl_table SET (ttl_job_cron = '@weekly')

-- Test 103: statement (line 858)
ALTER TABLE no_ttl_table SET (ttl_pause = true)

-- Test 104: statement (line 861)
ALTER TABLE no_ttl_table SET (ttl_label_metrics = true)

-- Test 105: statement (line 868)
CREATE TABLE tbl_ttl_params_non_negative (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes')

-- Test 106: statement (line 873)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_select_batch_size = -1)

-- Test 107: statement (line 876)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_delete_batch_size = -1)

-- Test 108: statement (line 879)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_select_rate_limit = -1)

-- Test 109: statement (line 882)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_delete_rate_limit = -1)

-- Test 110: statement (line 885)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_row_stats_poll_interval = '-1 second')

-- Test 111: statement (line 888)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_select_batch_size = 0)

-- Test 112: statement (line 891)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_delete_batch_size = 0)

-- Test 113: statement (line 894)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_select_rate_limit = 0)

-- Test 114: statement (line 897)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_delete_rate_limit = 0)

-- Test 115: statement (line 900)
ALTER TABLE tbl_ttl_params_non_negative SET (ttl_row_stats_poll_interval = '0 second')

-- Test 116: query (line 943)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_ttl_params]

-- Test 117: query (line 953)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_ttl_params]

-- Test 118: query (line 963)
ALTER TABLE tbl_set_ttl_params SET (ttl_select_batch_size = 110, ttl_delete_batch_size = 120, ttl_select_rate_limit = 130, ttl_delete_rate_limit = 140, ttl_row_stats_poll_interval = '2m0s')

-- Test 119: statement (line 970)
ALTER TABLE tbl_set_ttl_params SET (ttl_select_batch_size = 110, ttl_delete_batch_size = 120, ttl_select_rate_limit = 130, ttl_delete_rate_limit = 140, ttl_row_stats_poll_interval = '2m0s')

onlyif config schema-locked-disabled

-- Test 120: query (line 974)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_ttl_params]

-- Test 121: query (line 984)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_ttl_params]

-- Test 122: query (line 1007)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_ttl_params]

-- Test 123: query (line 1017)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_ttl_params]

-- Test 124: statement (line 1032)
CREATE TABLE tbl_create_table_ttl_expiration_expression (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ,
  FAMILY (id, expire_at)
) WITH (ttl_expiration_expression = 'expire_at')

onlyif config schema-locked-disabled

-- Test 125: query (line 1040)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_create_table_ttl_expiration_expression]

-- Test 126: query (line 1051)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_create_table_ttl_expiration_expression]

-- Test 127: statement (line 1061)
ALTER TABLE tbl_create_table_ttl_expiration_expression RESET (ttl)

onlyif config schema-locked-disabled

-- Test 128: query (line 1065)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_create_table_ttl_expiration_expression]

-- Test 129: query (line 1076)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_create_table_ttl_expiration_expression]

-- Test 130: statement (line 1090)
CREATE TABLE tbl_create_table_ttl_expiration_expression_escape_sql (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ,
  FAMILY (id, expire_at)
) WITH (ttl_expiration_expression = 'IF(expire_at > parse_timestamp(''2020-01-01 00:00:00'') AT TIME ZONE ''UTC'', expire_at, NULL)')

onlyif config schema-locked-disabled

-- Test 131: query (line 1098)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_create_table_ttl_expiration_expression_escape_sql]

-- Test 132: query (line 1109)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_create_table_ttl_expiration_expression_escape_sql]

-- Test 133: statement (line 1123)
CREATE TABLE tbl_alter_table_ttl_expiration_expression (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ,
  FAMILY (id, expire_at)
)

-- Test 134: statement (line 1130)
ALTER TABLE tbl_alter_table_ttl_expiration_expression SET (ttl_expiration_expression = 'id')

-- Test 135: statement (line 1133)
ALTER TABLE tbl_alter_table_ttl_expiration_expression SET (ttl_expiration_expression = 'expire_at')

skipif config schema-locked-disabled

-- Test 136: statement (line 1137)
ALTER TABLE tbl_alter_table_ttl_expiration_expression SET (schema_locked = false)

-- Test 137: statement (line 1140)
ALTER TABLE tbl_alter_table_ttl_expiration_expression DROP COLUMN expire_at

skipif config schema-locked-disabled

-- Test 138: statement (line 1144)
ALTER TABLE tbl_alter_table_ttl_expiration_expression SET (schema_locked = true)

-- Test 139: statement (line 1147)
ALTER TABLE tbl_alter_table_ttl_expiration_expression ALTER expire_at TYPE TIMESTAMP USING (expire_at AT TIME ZONE 'UTC')

onlyif config schema-locked-disabled

-- Test 140: query (line 1151)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_alter_table_ttl_expiration_expression]

-- Test 141: query (line 1162)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_alter_table_ttl_expiration_expression]

-- Test 142: statement (line 1173)
ALTER TABLE tbl_alter_table_ttl_expiration_expression SET (ttl_expiration_expression = '((expire_at AT TIME ZONE ''UTC'') + ''5 minutes'':::INTERVAL) AT TIME ZONE ''UTC''')

onlyif config schema-locked-disabled

-- Test 143: query (line 1177)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_alter_table_ttl_expiration_expression]

-- Test 144: query (line 1188)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_alter_table_ttl_expiration_expression]

-- Test 145: statement (line 1198)
ALTER TABLE tbl_alter_table_ttl_expiration_expression RESET (ttl)

onlyif config schema-locked-disabled

-- Test 146: query (line 1202)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_alter_table_ttl_expiration_expression]

-- Test 147: query (line 1213)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_alter_table_ttl_expiration_expression]

-- Test 148: statement (line 1227)
CREATE TABLE tbl_add_ttl_expiration_expression_to_ttl_expire_after (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ,
  FAMILY (id, expire_at)
) WITH (ttl_expire_after = '10 minutes')

-- Test 149: statement (line 1234)
ALTER TABLE tbl_add_ttl_expiration_expression_to_ttl_expire_after SET (ttl_expiration_expression = 'crdb_internal_expiration')

onlyif config schema-locked-disabled

-- Test 150: query (line 1238)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_add_ttl_expiration_expression_to_ttl_expire_after]

-- Test 151: query (line 1250)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_add_ttl_expiration_expression_to_ttl_expire_after]

-- Test 152: statement (line 1274)
CREATE TABLE tbl_add_ttl_expire_after_to_ttl_expiration_expression (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ,
  FAMILY (id, expire_at)
) WITH (ttl_expiration_expression = 'expire_at', schema_locked = false)

-- Test 153: statement (line 1281)
ALTER TABLE tbl_add_ttl_expire_after_to_ttl_expiration_expression SET (ttl_expire_after = '10 minutes')

-- Test 154: query (line 1284)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_add_ttl_expire_after_to_ttl_expiration_expression]

-- Test 155: statement (line 1308)
CREATE TABLE create_table_ttl_expire_after_and_ttl_expiration_expression (
  id INT PRIMARY KEY
) WITH (ttl_expire_after = '10 minutes', ttl_expiration_expression = 'crdb_internal_expiration')

onlyif config schema-locked-disabled

-- Test 156: query (line 1314)
SELECT create_statement FROM [SHOW CREATE TABLE create_table_ttl_expire_after_and_ttl_expiration_expression]

-- Test 157: query (line 1324)
SELECT create_statement FROM [SHOW CREATE TABLE create_table_ttl_expire_after_and_ttl_expiration_expression]

-- Test 158: statement (line 1333)
ALTER TABLE create_table_ttl_expire_after_and_ttl_expiration_expression RESET (ttl)

onlyif config schema-locked-disabled

-- Test 159: query (line 1337)
SELECT create_statement FROM [SHOW CREATE TABLE create_table_ttl_expire_after_and_ttl_expiration_expression]

-- Test 160: query (line 1346)
SELECT create_statement FROM [SHOW CREATE TABLE create_table_ttl_expire_after_and_ttl_expiration_expression]

-- Test 161: statement (line 1358)
CREATE TABLE tbl_alter_table_ttl_expire_after_and_ttl_expiration_expression (
  id INT PRIMARY KEY
) WITH (schema_locked = false)

-- Test 162: statement (line 1363)
ALTER TABLE tbl_alter_table_ttl_expire_after_and_ttl_expiration_expression SET (ttl_expire_after = '10 minutes', ttl_expiration_expression = 'crdb_internal_expiration')

-- Test 163: query (line 1366)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_alter_table_ttl_expire_after_and_ttl_expiration_expression]

-- Test 164: statement (line 1375)
ALTER TABLE tbl_alter_table_ttl_expire_after_and_ttl_expiration_expression RESET (ttl)

-- Test 165: query (line 1378)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_alter_table_ttl_expire_after_and_ttl_expiration_expression]

-- Test 166: statement (line 1390)
CREATE TABLE tbl_ttl_expiration_expression_renamed (
  id INT PRIMARY KEY,
  expires_at TIMESTAMPTZ,
  FAMILY fam (id, expires_at)
) WITH (ttl_expiration_expression = 'expires_at')

-- Test 167: statement (line 1397)
ALTER TABLE tbl_ttl_expiration_expression_renamed RENAME expires_at TO expires_at_renamed

onlyif config schema-locked-disabled

-- Test 168: query (line 1401)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_ttl_expiration_expression_renamed]

-- Test 169: query (line 1412)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_ttl_expiration_expression_renamed]

-- Test 170: statement (line 1426)
CREATE TABLE tbl_crdb_internal_expiration_already_defined (
  id INT PRIMARY KEY,
  crdb_internal_expiration TIMESTAMPTZ
) WITH (schema_locked = false)

-- Test 171: statement (line 1432)
ALTER TABLE tbl_crdb_internal_expiration_already_defined SET (ttl_expire_after = '10 minutes')

-- Test 172: statement (line 1439)
CREATE TABLE tbl_desc_pk_with_ttl (id INT, id2 INT, PRIMARY KEY (id, id2 DESC)) WITH (ttl_expire_after = '10 minutes')

-- Test 173: statement (line 1446)
CREATE TABLE tbl_desc_pk_without_ttl_add_ttl (id INT, id2 INT, PRIMARY KEY (id, id2 DESC)) WITH (schema_locked = false)

-- Test 174: statement (line 1449)
ALTER TABLE tbl_desc_pk_without_ttl_add_ttl SET (ttl_expire_after = '10 minutes')

-- Test 175: statement (line 1456)
CREATE TABLE tbl_asc_pk_alter_desc_pk (id INT, id2 INT, PRIMARY KEY (id, id2)) WITH (ttl_expire_after = '10 minutes')

-- Test 176: statement (line 1459)
ALTER TABLE tbl_asc_pk_alter_desc_pk ALTER PRIMARY KEY USING COLUMNS (id, id2 DESC)

-- Test 177: statement (line 1466)
CREATE TABLE create_table_no_ttl_set_ttl_expire_after (
   id INT PRIMARY KEY
) WITH (schema_locked = false)

-- Test 178: statement (line 1471)
ALTER TABLE create_table_no_ttl_set_ttl_expire_after SET (ttl_expire_after = '10 minutes')

-- Test 179: query (line 1474)
SELECT create_statement FROM [SHOW CREATE TABLE create_table_no_ttl_set_ttl_expire_after]

-- Test 180: statement (line 1492)
ALTER TABLE create_table_no_ttl_set_ttl_expire_after RESET (ttl)

-- Test 181: statement (line 1504)
CREATE TABLE create_table_no_ttl_set_ttl_expiration_expression (
   id INT PRIMARY KEY,
   expire_at TIMESTAMPTZ,
   FAMILY (id, expire_at)
)

-- Test 182: statement (line 1511)
ALTER TABLE create_table_no_ttl_set_ttl_expiration_expression SET (ttl_expiration_expression = 'expire_at')

onlyif config schema-locked-disabled

-- Test 183: query (line 1515)
SELECT create_statement FROM [SHOW CREATE TABLE create_table_no_ttl_set_ttl_expiration_expression]

-- Test 184: query (line 1526)
SELECT create_statement FROM [SHOW CREATE TABLE create_table_no_ttl_set_ttl_expiration_expression]

-- Test 185: statement (line 1545)
ALTER TABLE create_table_no_ttl_set_ttl_expiration_expression RESET (ttl)

-- Test 186: query (line 1567)
SELECT create_statement FROM [SHOW CREATE SCHEDULE $schedule_id]

-- Test 187: statement (line 1572)
DROP TABLE "Table-Name"

-- Test 188: statement (line 1580)
CREATE TABLE tbl_set_both_reset_ttl_expire_after (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ,
  FAMILY (id, expire_at)
) WITH (
  ttl_expire_after = '10m',
  ttl_expiration_expression = 'expire_at'
)

-- Test 189: statement (line 1590)
ALTER TABLE tbl_set_both_reset_ttl_expire_after RESET (ttl_expire_after)

onlyif config schema-locked-disabled

-- Test 190: query (line 1594)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_both_reset_ttl_expire_after]

-- Test 191: query (line 1605)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_both_reset_ttl_expire_after]

-- Test 192: statement (line 1629)
CREATE TABLE tbl_set_both_reset_ttl_expiration_expression (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ,
  FAMILY (id, expire_at)
) WITH (
  ttl_expire_after = '10m',
  ttl_expiration_expression = 'expire_at'
)

-- Test 193: statement (line 1639)
ALTER TABLE tbl_set_both_reset_ttl_expiration_expression RESET (ttl_expiration_expression)

onlyif config schema-locked-disabled

-- Test 194: query (line 1643)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_both_reset_ttl_expiration_expression]

-- Test 195: query (line 1655)
SELECT create_statement FROM [SHOW CREATE TABLE tbl_set_both_reset_ttl_expiration_expression]

-- Test 196: statement (line 1683)
CREATE TABLE tbl_with_ttl (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ,
  FAMILY (id, expire_at)
) WITH (
  ttl_expiration_expression = 'expire_at'
)

skipif config weak-iso-level-configs

-- Test 197: query (line 1693)
CREATE TABLE tbl_with_dep(
  id1 INT PRIMARY KEY,
  id INT REFERENCES tbl_with_ttl(id) ON DELETE CASCADE
)

-- Test 198: query (line 1704)
CREATE TABLE tbl_with_dep_2(
  id1 INT PRIMARY KEY,
  id INT REFERENCES tbl_with_ttl(id)
)

-- Test 199: query (line 1720)
ALTER TABLE tbl_to_alter ADD CONSTRAINT fk_tbl_with_ttl FOREIGN KEY(f_id) REFERENCES tbl_with_ttl(id) ON DELETE CASCADE

-- Test 200: query (line 1735)
ALTER TABLE tbl_to_alter_2 ADD CONSTRAINT fk_tbl_with_ttl FOREIGN KEY(f_id) REFERENCES tbl_with_ttl(id)

-- Test 201: statement (line 1741)
CREATE TABLE tbl_to_add_ttl(
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ NOT NULL DEFAULT now() + '30 days'
)

-- Test 202: query (line 1756)
ALTER TABLE tbl_to_add_ttl SET (ttl_expiration_expression = 'expire_at')

-- Test 203: statement (line 1760)
ALTER TABLE tbl_to_add_ttl RESET (ttl);

-- Test 204: query (line 1772)
ALTER TABLE tbl_to_add_ttl SET (ttl_expiration_expression = 'expire_at')

-- Test 205: statement (line 1781)
CREATE TABLE tbl_execute_schedule (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ NOT NULL DEFAULT now() - '1 day'
) WITH (ttl_expiration_expression = 'expire_at', ttl_job_cron = '@daily')

-- Test 206: statement (line 1787)
CREATE TABLE tbl_execute_schedule_2 (
  id INT PRIMARY KEY,
  expire_at TIMESTAMPTZ NOT NULL DEFAULT now() - '1 day'
) WITH (ttl_expiration_expression = 'expire_at', ttl_job_cron = '@daily')

-- Test 207: statement (line 1813)
EXECUTE SCHEDULE $schedule_id_1

-- Test 208: statement (line 1824)
EXECUTE SCHEDULES SELECT $schedule_id_2

-- Test 209: statement (line 1844)
PAUSE SCHEDULE $schedule_id_1

-- Test 210: statement (line 1847)
EXECUTE SCHEDULE $schedule_id_1

-- Test 211: statement (line 1850)
RESUME SCHEDULE $schedule_id_1

