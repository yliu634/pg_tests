-- PostgreSQL compatible tests from pgcrypto_builtins
-- 41 tests

SET client_min_messages = warning;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Test 1: query (line 7)
SELECT
  alg,
  encode(digest('abc'::bytea, alg), 'hex') = expected AS ok,
  digest(NULL::bytea, alg) IS NULL AS null_data_ok,
  digest('abc'::bytea, NULL::text) IS NULL AS null_alg_ok
FROM (
  VALUES
    (1, 'md5', '900150983cd24fb0d6963f7d28e17f72'),
    (2, 'sha1', 'a9993e364706816aba3e25717850c26c9cd0d89d'),
    (3, 'sha224', '23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7'),
    (4, 'sha256', 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'),
    (5, 'sha384', 'cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7'),
    (6, 'sha512', 'ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f')
) AS v (ord, alg, expected)
ORDER BY ord;

-- Test 2: query (line 29)
SELECT digest(NULL::bytea, 'sha256') IS NULL AS null_data;

-- Test 3: statement (line 34)
SELECT encode(digest('cat'::bytea, 'sha256'), 'hex') IS NOT NULL AS has_digest;

-- Test 4: query (line 43)
SELECT alg, encode(hmac('abc'::bytea, 'key'::bytea, alg), 'hex') AS hmac_hex
FROM (VALUES (1, 'md5'), (2, 'sha1'), (3, 'sha224'), (4, 'sha256'), (5, 'sha384'), (6, 'sha512')) v(ord, alg)
ORDER BY ord;

-- Test 5: query (line 54)
SELECT
  hmac('abc'::bytea, 'key'::bytea, NULL::text) IS NULL AS null_alg,
  hmac('abc'::bytea, NULL::bytea, 'sha256') IS NULL AS null_key,
  hmac(NULL::bytea, 'key'::bytea, 'sha256') IS NULL AS null_data;

-- Test 6: statement (line 59)
SELECT encode(hmac('dog'::bytea, 'key'::bytea, 'sha256'), 'hex') IS NOT NULL AS has_hmac;

-- Test 7: query (line 66)
SELECT length(uuid_send(u)) = 16 AS uuid_16_bytes, u IS NOT NULL AS uuid_not_null
FROM (SELECT gen_random_uuid() AS u) s;

-- Test 8: statement (line 75)
SELECT char_length(gen_salt('des')) = 2 AS des_len;

-- Test 9: statement (line 78)
SELECT char_length(gen_salt('des', 0)) = 2 AS des_len_rounds;

-- Test 10: query (line 85)
SELECT char_length(gen_salt('des'));

-- Test 11: query (line 90)
SELECT char_length(gen_salt('des', rounds))
FROM (VALUES (0), (25)) AS t (rounds)
ORDER BY rounds;

-- Test 12: statement (line 98)
SELECT char_length(gen_salt('des', 0));

-- Test 13: query (line 105)
SELECT left(salt, 1), char_length(salt)
FROM (SELECT gen_salt('xdes') AS salt) s;

-- Test 14: query (line 111)
SELECT rounds, left(salt, 1), char_length(salt)
FROM (SELECT rounds, gen_salt('xdes', rounds) AS salt FROM (VALUES (0), (1), (16777215)) AS t (rounds)) s
ORDER BY rounds;

-- Test 15: statement (line 120)
SELECT char_length(gen_salt('xdes', 1));

-- Test 16: statement (line 124)
SELECT char_length(gen_salt('xdes', 0));

-- Test 17: statement (line 128)
SELECT char_length(gen_salt('xdes', 16777215));

-- Test 18: query (line 135)
SELECT substr(salt, 1, 3), char_length(salt)
FROM (SELECT gen_salt('md5') AS salt) s;

-- Test 19: query (line 141)
SELECT substr(salt, 1, 3), char_length(salt)
FROM (SELECT gen_salt('md5', rounds) AS salt FROM (VALUES (0), (1000)) AS t (rounds)) s;

-- Test 20: statement (line 149)
SELECT char_length(gen_salt('md5', 0));

-- Test 21: query (line 156)
SELECT substr(salt, 1, 7), char_length(salt)
FROM (SELECT gen_salt('bf', rounds) AS salt FROM (VALUES (0), (4), (31)) AS t (rounds)) s;

-- Test 22: statement (line 165)
SELECT char_length(gen_salt('bf', 4));

-- Test 23: statement (line 169)
SELECT char_length(gen_salt('bf', 31));

-- Test 24: statement (line 175)
SELECT crypt('password', '$1$aRnqRmeP');

-- Test 25: statement (line 179)
SELECT crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVO');

-- Test 26: query (line 186)
SELECT crypt(password, '$1$aRnqRmeP')
FROM (VALUES
  (''),
  ('0'),
  ('password'),
  (repeat('a', 50))
) AS t (password)
ORDER BY password;

-- Test 27: query (line 201)
SELECT hash1, hash1 = hash2
FROM (SELECT
  crypt('password', '$1$aRnqRmeP') as hash1,
  crypt('password', '$1$aRnqRmePextra') as hash2
) as t;

-- Test 28: query (line 211)
SELECT crypt('password', '$1$aRnqRmeP');

-- Test 29: query (line 220)
SELECT crypt(password, '$2a$06$Ukv6DxN3PpZo4YboQRrIVO')
FROM (VALUES
  (''),
  ('0'),
  ('password'),
  (repeat('a', 50))
) AS t (password)
ORDER BY password;

-- Test 30: query (line 235)
SELECT hash72, hash71 != hash72, hash72 = hash73
FROM (SELECT
  crypt(repeat('a', 71), salt) as hash71,
	  crypt(repeat('a', 72), salt) as hash72,
	  crypt(repeat('a', 73), salt) as hash73
	  FROM (SELECT '$2a$06$Ukv6DxN3PpZo4YboQRrIVO' as salt) as s
) as t;

-- Test 31: query (line 247)
SELECT hash1, hash1 = hash2
FROM (SELECT
  crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVO') as hash1,
  crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVOextra') as hash2
) as t;

-- Test 32: query (line 257)
SELECT crypt('password', concat('$2a$', rounds, '$Ukv6DxN3PpZo4YboQRrIVO'))
FROM (VALUES ('04'), ('10')) AS t (rounds)
ORDER BY rounds;

-- Test 33: statement (line 265)
SELECT crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVO');

-- Test 34: statement (line 269)
SELECT crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVOextra');

-- Test 35: statement (line 273)
SELECT crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVO');

-- Test 36: statement (line 277)
SELECT crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVO');

-- Test 37: statement (line 281)
SELECT crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVO');

-- Test 38: statement (line 285)
SELECT crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVO');

-- Test 39: statement (line 289)
SELECT crypt('password', '$2a$06$Ukv6DxN3PpZo4YboQRrIVO');

-- Test 40: query (line 297)
SELECT encode(encrypt('abc'::bytea, 'key'::bytea, 'aes'), 'hex');

SELECT encode(encrypt_iv('abc'::bytea, 'key'::bytea, '123'::bytea, 'aes'), 'hex');

SELECT convert_from(decrypt('\xdb5f149a7caf0cd275ca18c203a212c9'::bytea, 'key'::bytea, 'aes'), 'UTF8');

SELECT convert_from(decrypt_iv('\x91b4ef63852013c8da53829da662b871'::bytea, 'key'::bytea, '123'::bytea, 'aes'), 'UTF8');

SELECT length(gen_random_bytes(1));

SELECT length(gen_random_bytes(1024));

SELECT length(gen_random_bytes(10));

-- Test 41: query (line 328)
SELECT length(gen_random_bytes(5)) = 5;
