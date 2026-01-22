-- PostgreSQL compatible tests from pgcrypto_builtins
-- 41 tests

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Test 1: query (line 7)
SELECT
  encode(digest('abc', alg), 'hex') = expected, digest(NULL, alg), digest('abc', NULL)
FROM
  (
    VALUES
      ('md5', md5('abc')),
      ('sha1', encode(digest('abc', 'sha1'), 'hex')),
      ('sha224', encode(digest('abc', 'sha224'), 'hex')),
      ('sha256', encode(digest('abc', 'sha256'), 'hex')),
      ('sha384', encode(digest('abc', 'sha384'), 'hex')),
      ('sha512', encode(digest('abc', 'sha512'), 'hex'))
  )
    AS v (alg, expected);

-- Test 2: query (line 29)
SELECT digest(NULL, 'made up alg');

-- Test 3: statement (line 34)
DO $$
BEGIN
  PERFORM digest('cat', 'made up alg');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 4: query (line 43)
SELECT encode(hmac('abc', 'key', alg), 'hex')
FROM (VALUES ('md5'), ('sha1'), ('sha224'), ('sha256'), ('sha384'), ('sha512')) v(alg)
;

-- Test 5: query (line 54)
SELECT hmac('abc', 'key', NULL), hmac('abc', NULL, 'made up alg'), hmac(NULL, 'key', 'sha256');

-- Test 6: statement (line 59)
DO $$
BEGIN
  PERFORM hmac('dog', 'key', 'made up alg');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 7: query (line 66)
SELECT length(uuid_send(gen_random_uuid())), gen_random_uuid() IS NOT NULL;

-- Test 8: statement (line 75)
DO $$
BEGIN
  PERFORM gen_salt('invalid');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 9: statement (line 78)
DO $$
BEGIN
  PERFORM gen_salt('invalid', 0);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 10: query (line 85)
SELECT char_length(gen_salt('des'));

-- Test 11: query (line 90)
SELECT char_length(gen_salt('des', rounds))
FROM (VALUES (0), (25)) AS t (rounds)
;

-- Test 12: statement (line 98)
DO $$
BEGIN
  PERFORM gen_salt('des', 1);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 13: query (line 105)
SELECT substr(salt, 1, 5), char_length(salt)
FROM (SELECT gen_salt('xdes') AS salt)
;

-- Test 14: query (line 111)
SELECT substr(salt, 1, 5), char_length(salt)
FROM (SELECT gen_salt('xdes', rounds) AS salt FROM (VALUES (0), (1), (16777215)) AS t (rounds))
;

-- Test 15: statement (line 120)
DO $$
BEGIN
  PERFORM gen_salt('xdes', 2);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 16: statement (line 124)
DO $$
BEGIN
  PERFORM gen_salt('xdes', -1);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 17: statement (line 128)
DO $$
BEGIN
  PERFORM gen_salt('xdes', 16777216);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 18: query (line 135)
SELECT substr(salt, 1, 3), char_length(salt)
FROM (SELECT gen_salt('md5') AS salt)
;

-- Test 19: query (line 141)
SELECT substr(salt, 1, 3), char_length(salt)
FROM (SELECT gen_salt('md5', rounds) AS salt FROM (VALUES (0), (1000)) AS t (rounds))
;

-- Test 20: statement (line 149)
DO $$
BEGIN
  PERFORM gen_salt('md5', 1);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 21: query (line 156)
SELECT substr(salt, 1, 7), char_length(salt)
FROM (SELECT gen_salt('bf', rounds) AS salt FROM (VALUES (0), (4), (31)) AS t (rounds))
;

-- Test 22: statement (line 165)
DO $$
BEGIN
  PERFORM gen_salt('bf', 3);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 23: statement (line 169)
DO $$
BEGIN
  PERFORM gen_salt('bf', 32);
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 24: statement (line 175)
DO $$
BEGIN
  PERFORM crypt('password', '');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 25: statement (line 179)
DO $$
BEGIN
  PERFORM crypt('password', '$');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 26: query (line 186)
SELECT crypt(password, '$1$aRnqRmeP')
FROM (VALUES
  (''),
  ('0'),
  ('password'),
  (repeat('a', 50))
) AS t (password)
;

-- Test 27: query (line 201)
SELECT hash1, hash1 = hash2
FROM (SELECT
  crypt('password', '$1$aRnqRmeP') as hash1,
  crypt('password', '$1$aRnqRmePextra') as hash2
) as t
;

-- Test 28: query (line 211)
DO $$
BEGIN
  PERFORM crypt('password', '$1$');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 29: query (line 220)
SELECT crypt(password, '$2a$06$Ukv6DxN3PpZo4YboQRrIVO')
FROM (VALUES
  (''),
  ('0'),
  ('password'),
  (repeat('a', 50))
) AS t (password)
;

-- Test 30: query (line 235)
SELECT hash72, hash71 != hash72, hash72 = hash73
FROM (SELECT
  crypt(repeat('a', 71), salt) as hash71,
  crypt(repeat('a', 72), salt) as hash72,
  crypt(repeat('a', 73), salt) as hash73
  FROM (SELECT '$2a$06$Ukv6DxN3PpZo4YboQRrIVO' as salt) as s
) as t
;

-- Test 31: query (line 247)
SELECT hash1, hash1 = hash2
FROM (SELECT
  crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVO') as hash1,
  crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVOextra') as hash2
) as t
;

-- Test 32: query (line 257)
SELECT crypt('password', concat('$2a$', rounds, '$Ukv6DxN3PpZo4YboQRrIVO'))
FROM (VALUES ('04'), ('10')) AS t (rounds)
;

-- Test 33: statement (line 265)
DO $$
BEGIN
  PERFORM crypt('password', '$2a$06$');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 34: statement (line 269)
DO $$
BEGIN
  PERFORM crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIV');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 35: statement (line 273)
DO $$
BEGIN
  PERFORM crypt('password', '$2a$AA$Ukv6DxN3PpZo4YboQRrIVO');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 36: statement (line 277)
DO $$
BEGIN
  PERFORM crypt('password', '$2a$03$Ukv6DxN3PpZo4YboQRrIVO');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 37: statement (line 281)
DO $$
BEGIN
  PERFORM crypt('password', '$2a$32$Ukv6DxN3PpZo4YboQRrIVO');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 38: statement (line 285)
DO $$
BEGIN
  PERFORM crypt('password', '$2a$06AUkv6DxN3PpZo4YboQRrIVO');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 39: statement (line 289)
DO $$
BEGIN
  PERFORM crypt('password', '$2a$06$#kv6DxN3PpZo4YboQRrIVO');
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END
$$;

-- Test 40: query (line 297)
SELECT encrypt('abc', 'key', 'aes');

-- CockroachDB-specific harness directives; not applicable to PostgreSQL.
-- skipif config enterprise-configs
-- query error pgcode XXC01 encrypt_iv can only be used with a CCL distribution
-- SELECT encrypt_iv('abc', 'key', '123', 'aes')

-- skipif config enterprise-configs
-- query error pgcode XXC01 decrypt can only be used with a CCL distribution
-- SELECT decrypt('\xdb5f149a7caf0cd275ca18c203a212c9', 'key', 'aes')

-- skipif config enterprise-configs
-- query error pgcode XXC01 decrypt_iv can only be used with a CCL distribution
-- SELECT decrypt_iv('\x91b4ef63852013c8da53829da662b871', 'key', '123', 'aes')

-- subtest end

-- subtest gen_random_bytes

-- statement error pgcode 22023 length 0 is outside the range
-- SELECT gen_random_bytes(0)

-- statement error pgcode 22023 length 1025 is outside the range
-- SELECT gen_random_bytes(1025)

-- query I
SELECT length(gen_random_bytes(10));

-- Test 41: query (line 328)
SELECT length(gen_random_bytes(5));
