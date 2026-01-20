-- PostgreSQL compatible tests from show_commit_timestamp
-- 56 tests

-- Test 1: statement (line 2)
create table foo (i int primary key)

-- Test 2: statement (line 7)
begin;
insert into foo values (1)

let $commit_ts
show commit timestamp

-- Test 3: statement (line 14)
commit

let $commit_ts_after_txn
show commit timestamp

-- Test 4: query (line 20)
select $commit_ts_after_txn = $commit_ts

-- Test 5: query (line 25)
select * from foo where crdb_internal_mvcc_timestamp = $commit_ts

-- Test 6: statement (line 32)
begin;
savepoint cockroach_restart;
insert into foo values (2);
release cockroach_restart

let $commit_ts
show commit timestamp

let $commit_ts_again
show commit timestamp

-- Test 7: statement (line 44)
commit

let $commit_ts_after_txn
show commit timestamp

-- Test 8: query (line 50)
select $commit_ts_after_txn = $commit_ts, $commit_ts = $commit_ts_again

-- Test 9: query (line 55)
select * from foo where crdb_internal_mvcc_timestamp = $commit_ts

-- Test 10: statement (line 62)
begin;
savepoint cockroach_restart;
insert into foo values (3);
release cockroach_restart;
commit

let $commit_ts
show commit timestamp

let $commit_ts_again
show commit timestamp

-- Test 11: query (line 75)
select $commit_ts_after_txn = $commit_ts, $commit_ts = $commit_ts_again

-- Test 12: query (line 80)
select * from foo where crdb_internal_mvcc_timestamp = $commit_ts

-- Test 13: statement (line 87)
insert into foo values (4);

let $commit_ts
show commit timestamp

let $commit_ts_again
show commit timestamp

-- Test 14: query (line 96)
select * from foo where crdb_internal_mvcc_timestamp = $commit_ts

-- Test 15: query (line 101)
select * from foo where crdb_internal_mvcc_timestamp = $commit_ts_again

-- Test 16: query (line 106)
select * from foo where crdb_internal_mvcc_timestamp = ($commit_ts) + 0.0000000001

-- Test 17: query (line 110)
select * from foo where crdb_internal_mvcc_timestamp = ($commit_ts) + 1

-- Test 18: statement (line 116)
begin;
rollback

-- Test 19: statement (line 120)
show commit timestamp

-- Test 20: statement (line 123)
insert into foo values (5)

-- Test 21: statement (line 126)
show commit timestamp

-- Test 22: statement (line 129)
begin;
select 1/0;

-- Test 23: statement (line 133)
show commit timestamp

-- Test 24: statement (line 136)
rollback

-- Test 25: statement (line 139)
show commit timestamp

-- Test 26: query (line 149)
select * from foo where crdb_internal_mvcc_timestamp = $commit_ts order by i

-- Test 27: statement (line 155)
insert into foo values (8);
show commit timestamp;
insert into foo values (9)

-- Test 28: query (line 173)
select * from foo where crdb_internal_mvcc_timestamp = $commit_ts order by i

-- Test 29: statement (line 192)
insert into foo values(16);

-- Test 30: statement (line 195)
commit

-- Test 31: query (line 198)
select * from foo where crdb_internal_mvcc_timestamp = $commit_ts order by i

-- Test 32: statement (line 207)
create function f() returns decimal volatile language sql as $$ show commit timestamp $$;

-- Test 33: statement (line 214)
prepare s as show commit timestamp;

-- Test 34: statement (line 222)
with committs as (show commit timestamp) select * from committs;

-- Test 35: statement (line 225)
select * from [show commit timestamp]

-- Test 36: statement (line 232)
drop table foo;
create table foo (i int primary key)

-- Test 37: statement (line 236)
insert into foo values (1)

-- Test 38: statement (line 239)
begin;
alter table foo add column j int default 42

let $commit_ts
show commit timestamp

-- Test 39: statement (line 246)
commit;

-- Test 40: query (line 249)
select * from foo

-- Test 41: statement (line 262)
drop table foo;
create table foo (i int primary key) WITH (schema_locked=false);
insert into foo values (1);

-- Test 42: statement (line 267)
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET LOCAL autocommit_before_ddl=off;
alter table foo add check (i <= 0)

-- Test 43: statement (line 274)
show commit timestamp

-- Test 44: statement (line 277)
rollback;
drop table foo

-- Test 45: statement (line 286)
begin;
show commit timestamp

-- Test 46: statement (line 290)
release savepoint cockroach_restart;

-- Test 47: statement (line 293)
rollback

-- Test 48: statement (line 302)
create table foo (i int primary key);

-- Test 49: statement (line 305)
begin;
insert into foo values (1), (3);

let $ts1
show commit timestamp

-- Test 50: statement (line 312)
commit

-- Test 51: statement (line 315)
begin;
insert into foo values (2), (4);

user root

-- Test 52: statement (line 321)
begin priority high; select * from foo; commit;

user testuser

let $ts2
show commit timestamp

-- Test 53: statement (line 329)
commit

-- Test 54: query (line 334)
SELECT i,
         CASE
         WHEN ts = $ts1 THEN 'ts1'
         WHEN ts = $ts2 THEN 'ts2'
         END
    FROM (SELECT i, crdb_internal_mvcc_timestamp AS ts FROM foo)
ORDER BY i ASC;

-- Test 55: query (line 349)
SELECT i,
         CASE
         WHEN ts = $ts1 THEN 'ts1'
         WHEN ts = $ts2 THEN 'ts2'
         END
    FROM (SELECT i, crdb_internal_mvcc_timestamp AS ts FROM foo)
ORDER BY i ASC;

-- Test 56: statement (line 363)
drop table foo

