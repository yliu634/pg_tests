-- PostgreSQL compatible tests from set
-- 224 tests

-- Test 1: statement (line 3)
SET foo = bar

-- Test 2: statement (line 6)
SHOW foo

-- Test 3: statement (line 9)
SET database = foo

-- Test 4: statement (line 14)
SHOW TABLES

-- Test 5: statement (line 17)
CREATE DATABASE foo

-- Test 6: statement (line 20)
SET database = foo

-- Test 7: statement (line 24)
CREATE TABLE bar (k INT PRIMARY KEY)

-- Test 8: query (line 28)
SHOW TABLES FROM foo

-- Test 9: statement (line 34)
SET database = ""

-- Test 10: query (line 37)
SHOW database

-- Test 11: statement (line 43)
SHOW TABLES

-- Test 12: query (line 47)
SHOW TABLES FROM foo

-- Test 13: statement (line 53)
SET database = foo; CREATE TABLE bar (k INT PRIMARY KEY)

-- Test 14: query (line 56)
SHOW database

-- Test 15: query (line 63)
SHOW TABLES from foo

-- Test 16: statement (line 68)
SET ROW (1, TRUE, NULL)

-- Test 17: statement (line 71)
SET application_name = helloworld

-- Test 18: query (line 74)
SHOW application_name

-- Test 19: query (line 81)
SHOW session_user

-- Test 20: statement (line 88)
SET distsql TO ON

-- Test 21: query (line 91)
SHOW distsql

-- Test 22: statement (line 97)
SET distsql TO DEFAULT

-- Test 23: query (line 100)
SHOW distsql

-- Test 24: statement (line 108)
SET application_name = 'hello'

-- Test 25: statement (line 111)
SET extra_float_digits = 0

-- Test 26: statement (line 114)
SET extra_float_digits = 123

-- Test 27: statement (line 117)
SET client_min_messages = 'debug1'

-- Test 28: statement (line 120)
SET standard_conforming_strings = 'on'

-- Test 29: statement (line 123)
SET standard_conforming_strings = 'off'

-- Test 30: statement (line 126)
SET client_encoding = 'UTF8'

-- Test 31: statement (line 129)
SET client_encoding = 'UT! '' @#!$%%F------!@!!!8 ''   '

-- Test 32: statement (line 132)
SET client_encoding = 'unicode'

-- Test 33: statement (line 135)
SET client_encoding = 'other'

-- Test 34: statement (line 138)
SET server_encoding = 'UTF8'

-- Test 35: statement (line 141)
SET server_encoding = 'other'

-- Test 36: query (line 144)
SHOW ssl

-- Test 37: statement (line 149)
SET ssl = 'off'

-- Test 38: query (line 152)
SHOW authentication_method

-- Test 39: statement (line 157)
SET authentication_method = 'password'

-- Test 40: statement (line 160)
SET escape_string_warning = 'ON'

-- Test 41: statement (line 163)
SET escape_string_warning = 'off'

-- Test 42: statement (line 166)
SET datestyle = 'ISO'

-- Test 43: query (line 169)
SHOW datestyle

-- Test 44: statement (line 174)
SET datestyle = 'ISO, MDY'

-- Test 45: query (line 177)
SHOW datestyle

-- Test 46: statement (line 182)
SET datestyle = 'mdy, iso'

-- Test 47: query (line 185)
SHOW datestyle

-- Test 48: statement (line 190)
SET datestyle = 'ymd'

-- Test 49: query (line 193)
SHOW datestyle

-- Test 50: statement (line 198)
SET datestyle = 'DMY,   ISo'

-- Test 51: query (line 201)
SHOW datestyle

-- Test 52: statement (line 206)
SET datestyle = 'postgres'

-- Test 53: statement (line 209)
SET datestyle = 'german'

-- Test 54: statement (line 212)
SET datestyle = 'sql'

-- Test 55: statement (line 215)
SET datestyle = 'other'

-- Test 56: statement (line 218)
SET intervalstyle = 'postgres'

-- Test 57: statement (line 221)
SET intervalstyle = 'iso_8601'

-- Test 58: statement (line 224)
SET intervalstyle = 'sql_standard'

-- Test 59: statement (line 227)
SET intervalstyle = 'other'

-- Test 60: statement (line 230)
SET search_path = 'blah'

-- Test 61: statement (line 233)
SET distsql = always

-- Test 62: statement (line 236)
SET distsql = on

-- Test 63: statement (line 239)
SET distsql = off

-- Test 64: statement (line 242)
SET distsql = bogus

-- Test 65: statement (line 245)
SET vectorize = on

-- Test 66: statement (line 251)
SET vectorize = off

-- Test 67: statement (line 254)
SET vectorize = bogus

-- Test 68: statement (line 257)
SET optimizer = on

-- Test 69: statement (line 260)
SET optimizer = local

-- Test 70: statement (line 263)
SET optimizer = off

-- Test 71: statement (line 266)
SET optimizer = bogus

-- Test 72: statement (line 269)
SET bytea_output = escape

-- Test 73: statement (line 272)
SET bytea_output = hex

-- Test 74: statement (line 275)
SET bytea_output = bogus

-- Test 75: statement (line 278)
SET default_tablespace = ''

-- Test 76: statement (line 281)
SET default_tablespace = 'bleepis'

-- Test 77: query (line 284)
SHOW server_version

-- Test 78: query (line 290)
SHOW server_version_num

-- Test 79: query (line 296)
SHOW log_timezone

-- Test 80: statement (line 302)
SET max_index_keys = 32

-- Test 81: statement (line 305)
SET node_id = 123

-- Test 82: statement (line 308)
SET log_timezone = 'Australia/South'

-- Test 83: query (line 311)
SELECT name, value FROM system.settings WHERE name = 'testing.str'

-- Test 84: statement (line 316)
SET "timezone" = 'UTC'

-- Test 85: statement (line 321)
SET "TIMEZONE" = 'UTC'

-- Test 86: query (line 324)
SHOW "TIMEZONE"

-- Test 87: statement (line 330)
SET timezone = 'UTC'

-- Test 88: query (line 333)
SHOW timezone

-- Test 89: statement (line 339)
SET TIME ZONE 'UTC'

-- Test 90: query (line 342)
SHOW TIME ZONE

-- Test 91: statement (line 352)
SET statement_timeout = 1

-- Test 92: statement (line 355)
SELECT * FROM generate_series(1,1000000)

-- Test 93: statement (line 359)
SET statement_timeout = '0ms'

-- Test 94: statement (line 364)
SET statement_timeout = '10000'

-- Test 95: query (line 367)
SHOW statement_timeout

-- Test 96: statement (line 377)
SET statement_timeout = '1us'

-- Test 97: statement (line 380)
SHOW statement_timeout

-- Test 98: statement (line 383)
SET statement_timeout = 0

-- Test 99: query (line 386)
SHOW statement_timeout

-- Test 100: statement (line 391)
SET lock_timeout = '1ms'

-- Test 101: query (line 394)
SHOW lock_timeout

-- Test 102: statement (line 399)
SET lock_timeout = 0

-- Test 103: query (line 402)
SHOW lock_timeout

-- Test 104: statement (line 407)
SET deadlock_timeout = '1ms'

-- Test 105: query (line 410)
SHOW deadlock_timeout

-- Test 106: statement (line 415)
SET deadlock_timeout = 0

-- Test 107: query (line 418)
SHOW deadlock_timeout

-- Test 108: statement (line 423)
SET idle_in_session_timeout = 10000

-- Test 109: query (line 426)
SHOW idle_in_session_timeout

-- Test 110: query (line 431)
SHOW idle_session_timeout

-- Test 111: statement (line 436)
SET idle_session_timeout = 100000

-- Test 112: query (line 439)
SHOW idle_in_session_timeout

-- Test 113: query (line 444)
SHOW idle_session_timeout

-- Test 114: statement (line 449)
SET idle_in_session_timeout = 0;
SET idle_in_transaction_session_timeout = 123456

-- Test 115: query (line 453)
SHOW idle_in_transaction_session_timeout

-- Test 116: statement (line 458)
SET idle_in_transaction_session_timeout = 0

-- Test 117: statement (line 461)
SET ssl_renegotiation_limit = 123

-- Test 118: statement (line 464)
SET SESSION tracing=false

-- Test 119: statement (line 467)
SET SESSION tracing=1

-- Test 120: statement (line 472)
SET DATESTYLE = ISO;
  SET INTERVALSTYLE = POSTGRES;
  SET extra_float_digits TO 3;
  SET synchronize_seqscans TO off;
  SET statement_timeout = 0;
  SET lock_timeout = 0;
  SET idle_in_transaction_session_timeout = 0;
  SET row_security = off;

-- Test 121: statement (line 484)
SET SESSION SCHEMA EXISTS ( TABLE ( ( ( ( ( ( ( ( TABLE error ) ) ) ) ) ) ) ) ORDER BY INDEX FAMILY . IS . MAXVALUE @ OF DESC , INDEX FAMILY . FOR . ident @ ident ASC )

-- Test 122: statement (line 487)
USE EXISTS ( TABLE error ) IS NULL

-- Test 123: statement (line 490)
PREPARE a AS USE EXISTS ( TABLE error ) IS NULL

-- Test 124: statement (line 495)
SET enable_zigzag_join = 'on';
SET enable_zigzag_join = 'off';
SET enable_zigzag_join = 'true';
SET enable_zigzag_join = 'false';
SET enable_zigzag_join = 'yes';
SET enable_zigzag_join = 'no';
SET enable_zigzag_join = on;
SET enable_zigzag_join = off;
SET enable_zigzag_join = true;
SET enable_zigzag_join = false;
SET enable_zigzag_join = yes;
SET enable_zigzag_join = no

-- Test 125: statement (line 510)
SET enable_zigzag_join = nonsense

-- Test 126: query (line 520)
SET synchronous_commit = off; SET enable_seqscan = false

-- Test 127: query (line 526)
SHOW synchronous_commit

-- Test 128: query (line 532)
SHOW enable_seqscan

-- Test 129: query (line 538)
SET synchronous_commit = on; SET enable_seqscan = true

-- Test 130: query (line 544)
SHOW synchronous_commit

-- Test 131: query (line 550)
SHOW enable_seqscan

-- Test 132: statement (line 556)
BEGIN

-- Test 133: statement (line 559)
SET TRANSACTION NOT DEFERRABLE

-- Test 134: statement (line 562)
SET TRANSACTION DEFERRABLE

-- Test 135: statement (line 565)
rollback

-- Test 136: statement (line 568)
SET standard_conforming_strings=true

-- Test 137: statement (line 571)
SET standard_conforming_strings='true'

-- Test 138: statement (line 574)
SET standard_conforming_strings='on'

-- Test 139: query (line 579)
SHOW default_table_access_method

-- Test 140: statement (line 584)
SET default_table_access_method = 'heap'

-- Test 141: query (line 587)
SHOW default_table_access_method

-- Test 142: statement (line 592)
SET default_table_access_method = 'not-heap'

-- Test 143: query (line 597)
SHOW default_with_oids

-- Test 144: statement (line 602)
SET default_with_oids = 'false'

-- Test 145: query (line 605)
SHOW default_with_oids

-- Test 146: statement (line 610)
SET default_with_oids = 'true'

-- Test 147: query (line 615)
SHOW xmloption

-- Test 148: statement (line 620)
SET xmloption = 'content'

-- Test 149: query (line 623)
SHOW xmloption

-- Test 150: statement (line 628)
SET xmloption = 'document'

-- Test 151: statement (line 633)
SET backslash_quote = 'safe_encoding';

-- Test 152: statement (line 636)
SET backslash_quote = 'on';

-- Test 153: statement (line 639)
SET backslash_quote = 'off';

-- Test 154: statement (line 642)
SET backslash_quote = '123';

-- Test 155: statement (line 647)
SET cluster setting sql.trace.txn.enable_threshold='1s'

-- Test 156: statement (line 650)
SET cluster setting sql.trace.txn.enable_threshold='0s'

-- Test 157: statement (line 653)
SET disable_plan_gists = 'true'

-- Test 158: statement (line 656)
SET disable_plan_gists = 'false'

-- Test 159: statement (line 659)
SET index_recommendations_enabled = 'true'

-- Test 160: statement (line 662)
SET index_recommendations_enabled = 'false'

-- Test 161: query (line 665)
SHOW LC_COLLATE

-- Test 162: query (line 670)
SHOW LC_CTYPE

-- Test 163: query (line 675)
SHOW LC_MESSAGES

-- Test 164: query (line 680)
SHOW LC_MONETARY

-- Test 165: query (line 685)
SHOW LC_NUMERIC

-- Test 166: query (line 690)
SHOW LC_TIME

-- Test 167: statement (line 695)
SET LC_COLLATE = 'C.UTF-8'

-- Test 168: statement (line 698)
SET LC_CTYPE = 'C.UTF-8'

-- Test 169: statement (line 701)
SET LC_MESSAGES = 'C.UTF-8'

-- Test 170: statement (line 704)
SET LC_MONETARY = 'C.UTF-8'

-- Test 171: statement (line 707)
SET LC_NUMERIC = 'C.UTF-8'

-- Test 172: statement (line 710)
SET LC_TIME = 'C.UTF-8'

-- Test 173: statement (line 713)
SET LC_MESSAGES = 'en_US.UTF-8'

-- Test 174: statement (line 716)
SET LC_MONETARY = 'en_US.UTF-8'

-- Test 175: statement (line 719)
SET LC_NUMERIC = 'en_US.UTF-8'

-- Test 176: statement (line 722)
SET LC_TIME = 'en_US.UTF-8'

-- Test 177: statement (line 727)
SET check_function_bodies = true

-- Test 178: query (line 730)
SHOW check_function_bodies

-- Test 179: statement (line 735)
SET check_function_bodies = false

-- Test 180: query (line 738)
SHOW check_function_bodies

-- Test 181: query (line 752)
SHOW Custom_option.set_sql

-- Test 182: query (line 758)
SHOW custom_option.set_config

-- Test 183: query (line 763)
SELECT current_setting('custom_option.use_default')

-- Test 184: statement (line 768)
RESET custom_option.set_config

-- Test 185: query (line 771)
SHOW custom_option.set_config

-- Test 186: query (line 777)
SELECT variable FROM [SHOW ALL] WHERE variable LIKE 'custom_option.%'

-- Test 187: query (line 781)
SELECT name FROM pg_catalog.pg_settings WHERE name LIKE 'custom_option.%'

-- Test 188: query (line 785)
SHOW tracing

-- Test 189: query (line 790)
SHOW tracing.custom

-- Test 190: query (line 796)
SET server.shutdown.initial_wait = '10s'

-- Test 191: statement (line 803)
RESET ALL

-- Test 192: query (line 806)
SHOW tracing.custom

-- Test 193: query (line 811)
SHOW custom_option.set_sql

-- Test 194: statement (line 816)
SHOW custom_option.does_not_yet_exist

-- Test 195: statement (line 819)
SET join_reader_ordering_strategy_batch_size = '-1B'

-- Test 196: statement (line 822)
SET join_reader_ordering_strategy_batch_size = '1B'

-- Test 197: statement (line 825)
SET parallelize_multi_key_lookup_joins_enabled = true

-- Test 198: statement (line 828)
SET parallelize_multi_key_lookup_joins_enabled = false

-- Test 199: query (line 831)
SHOW opt_split_scan_limit

-- Test 200: statement (line 836)
SET opt_split_scan_limit = -1

-- Test 201: statement (line 839)
SET opt_split_scan_limit = 2147483648

-- Test 202: statement (line 842)
SET opt_split_scan_limit = 100000

-- Test 203: query (line 845)
SHOW opt_split_scan_limit

-- Test 204: statement (line 850)
RESET opt_split_scan_limit

-- Test 205: query (line 853)
SHOW opt_split_scan_limit

-- Test 206: query (line 858)
SHOW enable_auto_rehoming

-- Test 207: statement (line 868)
SET enable_auto_rehoming = on

-- Test 208: query (line 871)
SHOW enable_auto_rehoming

-- Test 209: query (line 889)
SHOW enable_auto_rehoming

-- Test 210: statement (line 894)
SET enable_auto_rehoming = bogus

-- Test 211: statement (line 900)
SET max_retries_for_read_committed = -1

-- Test 212: statement (line 903)
SET max_retries_for_read_committed = 2147483648

-- Test 213: statement (line 906)
SET max_retries_for_read_committed = 5

-- Test 214: query (line 909)
SHOW max_retries_for_read_committed

-- Test 215: query (line 918)
SHOW application_name

-- Test 216: statement (line 923)
SET application_name TO '🥭db'

-- Test 217: query (line 926)
SHOW application_name

-- Test 218: query (line 933)
SHOW application_name

-- Test 219: statement (line 941)
SET copy_num_retries_per_batch = 5;

-- Test 220: statement (line 946)
SET distsql_workmem = 1048576

-- Test 221: query (line 949)
SHOW distsql_workmem

-- Test 222: statement (line 954)
SET distsql_workmem = -1

-- Test 223: statement (line 957)
SET distsql_workmem = 1

-- Test 224: statement (line 960)
RESET distsql_workmem

