-- PostgreSQL compatible tests from impure
--
-- CockroachDB tests exercised impure functions like random() and uuid v4.
-- For deterministic expected output, we fix the random seed and use v5 UUIDs.

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP TABLE IF EXISTS kab;
DROP TABLE IF EXISTS kabc;
DROP TABLE IF EXISTS kabcd;

-- random() is deterministic once the session seed is fixed.
SELECT setseed(0.123);
WITH cte (a, b) AS (SELECT random(), random())
SELECT count(*) FROM cte WHERE a = b;

SELECT setseed(0.456);
WITH cte (x, a, b) AS (
  SELECT x, random(), random()
  FROM (VALUES (1), (2), (3)) AS v(x)
)
SELECT count(*) FROM cte WHERE a = b;

-- Use deterministic UUIDs (uuid v5 is name-based).
CREATE TABLE kab (k INT PRIMARY KEY, a UUID, b UUID);
INSERT INTO kab VALUES
  (1, uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kab-a-1'), uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kab-b-1')),
  (2, uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kab-a-2'), uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kab-b-2')),
  (3, uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kab-a-3'), uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kab-b-3'));
SELECT count(*) FROM kab WHERE a = b;

CREATE TABLE kabc (k INT PRIMARY KEY, a UUID, b UUID);
INSERT INTO kabc VALUES
  (1, uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabc-a-1'), uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabc-b-1')),
  (2, uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabc-a-2'), uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabc-b-2')),
  (3, uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabc-a-3'), uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabc-b-3'));
SELECT count(*) FROM kabc WHERE a = b;

CREATE TABLE kabcd (
  k INT PRIMARY KEY,
  a UUID,
  b UUID,
  c UUID,
  d UUID,
  e UUID,
  f UUID
);
INSERT INTO kabcd VALUES
  (1,
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-a-1'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-b-1'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-c-1'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-d-1'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-e-1'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-f-1')),
  (2,
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-a-2'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-b-2'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-c-2'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-d-2'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-e-2'),
   uuid_generate_v5('00000000-0000-0000-0000-000000000000', 'kabcd-f-2'));

SELECT count(*)
FROM kabcd
WHERE a = b OR a = c OR a = d OR a = e OR a = f
   OR b = c OR b = d OR b = e OR b = f
   OR c = d OR c = e OR c = f
   OR d = e OR d = f OR e = f;

-- Cleanup.
DROP TABLE kab;
DROP TABLE kabc;
DROP TABLE kabcd;

RESET client_min_messages;
