-- PostgreSQL compatible tests from alter_type
-- NOTE: This is a PostgreSQL-focused port. CockroachDB schema changer directives and
-- config flags are not applicable. This file exercises common ALTER TYPE operations.

SET client_min_messages = warning;

-- Cleanup from prior runs.
DROP TYPE IF EXISTS alphabets2;
DROP TYPE IF EXISTS alphabets;
DROP TYPE IF EXISTS person;

-- Test 1: ALTER TYPE on ENUM (ADD VALUE, RENAME VALUE, RENAME TYPE).
CREATE TYPE alphabets AS ENUM ('a', 'b');
SELECT enumlabel
FROM pg_enum
WHERE enumtypid = 'alphabets'::regtype
ORDER BY enumsortorder;

ALTER TYPE alphabets ADD VALUE 'c';
SELECT enumlabel
FROM pg_enum
WHERE enumtypid = 'alphabets'::regtype
ORDER BY enumsortorder;

ALTER TYPE alphabets RENAME VALUE 'a' TO 'aa';
SELECT enumlabel
FROM pg_enum
WHERE enumtypid = 'alphabets'::regtype
ORDER BY enumsortorder;

ALTER TYPE alphabets RENAME TO alphabets2;
SELECT typname FROM pg_type WHERE oid = 'alphabets2'::regtype;

-- Test 2: ALTER TYPE on composite type (ADD ATTRIBUTE).
CREATE TYPE person AS (
  name TEXT
);
ALTER TYPE person ADD ATTRIBUTE age INT;
SELECT attname, atttypid::regtype::text AS atttype
FROM pg_attribute
WHERE attrelid = 'person'::regclass
  AND attnum > 0
  AND NOT attisdropped
ORDER BY attnum;

-- Cleanup.
DROP TYPE IF EXISTS alphabets2;
DROP TYPE IF EXISTS person;

RESET client_min_messages;
