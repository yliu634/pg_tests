-- PostgreSQL compatible tests from uuid
-- 39 tests

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CockroachDB supports casting BYTES <-> UUID. PostgreSQL does not, so emulate:
-- - uuid_from_bytes(bytea): UUID whose hex digits are the raw bytes.
-- - uuid_to_bytes(uuid): the 16 raw bytes of the UUID.
CREATE OR REPLACE FUNCTION uuid_from_bytes(b bytea) RETURNS uuid
LANGUAGE SQL IMMUTABLE AS $$
  SELECT encode(b, 'hex')::uuid;
$$;

CREATE OR REPLACE FUNCTION uuid_to_bytes(u uuid) RETURNS bytea
LANGUAGE SQL IMMUTABLE AS $$
  SELECT decode(replace(u::text, '-', ''), 'hex');
$$;

-- CockroachDB accepts URN-form UUIDs (urn:uuid:...). Emulate that input form.
CREATE OR REPLACE FUNCTION uuid_from_urn(s text) RETURNS uuid
LANGUAGE SQL IMMUTABLE AS $$
  SELECT replace(s, 'urn:uuid:', '')::uuid;
$$;

-- Test 1: statement (line 2)
CREATE TABLE u (
  token uuid PRIMARY KEY,
  token2 uuid,
  token3 uuid
);
CREATE UNIQUE INDEX i_token2 ON u (token2);

-- Test 2: statement (line 8)
INSERT INTO u VALUES
  ('63616665-6630-3064-6465-616462656562', '{63616665-6630-3064-6465-616462656563}', uuid_from_bytes('kafef00ddeadbeed'::bytea)),
  (uuid_from_urn('urn:uuid:63616665-6630-3064-6465-616462656564'), '63616665-6630-3064-6465-616462656565'::uuid, uuid_from_bytes('kafef00ddeadbeee'::bytea)),
  (uuid_from_bytes('cafef00ddeadbeef'::bytea), '63616665-6630-3064-6465-616462656567', uuid_from_bytes('kafef00ddeadbeef'::bytea));

-- Test 3: query (line 14)
SELECT * FROM u ORDER BY token;

-- Test 4: query (line 21)
SELECT * FROM u WHERE token < '63616665-6630-3064-6465-616462656564'::uuid;

-- Test 5: query (line 26)
SELECT * FROM u WHERE token <= '63616665-6630-3064-6465-616462656564'::uuid ORDER BY token;

-- Test 6: statement (line 32)
INSERT INTO u VALUES ('63616665-6630-3064-6465-616462656566') ON CONFLICT DO NOTHING;

-- Test 7: statement (line 35)
INSERT INTO u VALUES ('63616665-6630-3064-6465-616462656569', '63616665-6630-3064-6465-616462656565') ON CONFLICT DO NOTHING;

-- Test 8: statement (line 38)
INSERT INTO u VALUES (uuid_from_bytes('cafef00ddeadbeee'::bytea));

-- Test 9: statement (line 41)
INSERT INTO u VALUES (uuid_from_bytes('cafef00ddeadbees'::bytea));

-- Test 10: statement (line 44)
INSERT INTO u VALUES ('63616665-6630-3064-6465-616462656560');

-- Test 11: statement (line 47)
INSERT INTO u VALUES ('63616665-6630-3064-6465-616462656561');

-- Test 12: statement (line 50)
SELECT token FROM u WHERE token = uuid_from_bytes('cafef00ddeadbeef'::bytea);

-- Test 13: statement (line 56)
SELECT token FROM u WHERE token = '63616665-6630-3064-6465-616462656562'::uuid;

-- Test 14: query (line 59)
SELECT token FROM u WHERE token = uuid_from_urn('urn:uuid:63616665-6630-3064-6465-616462656562');

-- Test 15: query (line 64)
SELECT token FROM u WHERE token = uuid_from_bytes('cafef00ddeadbeef'::bytea);

-- Test 16: query (line 69)
SELECT token2 FROM u WHERE token2 = '63616665-6630-3064-6465-616462656563';

-- Test 17: query (line 74)
SELECT token
FROM u
WHERE token IN (
  '63616665-6630-3064-6465-616462656562',
  '63616665-6630-3064-6465-616462656564'
)
ORDER BY token;

-- Test 18: statement (line 80)
INSERT INTO u VALUES ('63616665-6630-3064-6465-616462656567'::uuid);

-- Test 19: statement (line 83)
INSERT INTO u VALUES (uuid_from_urn('urn:uuid:63616665-6630-3064-6465-616462656568'));

-- Test 20: statement (line 86)
INSERT INTO u VALUES (uuid_generate_v4());

-- Test 21: statement (line 89)
INSERT INTO u VALUES (uuid_from_bytes('cafef00ddeadbeef'::bytea)) ON CONFLICT DO NOTHING;

-- Test 22: statement (line 95)
INSERT INTO u VALUES (uuid_generate_v4());

-- Test 23: query (line 98)
SELECT token::uuid FROM u WHERE token = uuid_from_bytes('cafef00ddeadbeef'::bytea);

-- Test 24: query (line 108)
SELECT uuid_to_bytes(token) AS token_bytes
FROM u
WHERE token = uuid_from_bytes('cafef00ddeadbeef'::bytea);

-- Test 25: statement (line 113)
SELECT encode(uuid_to_bytes(token), 'hex') AS token_hex
FROM u
WHERE token = uuid_from_bytes('cafef00ddeadbeef'::bytea);

-- Test 26: query (line 116)
SELECT ('63616665-6630-3064-6465-616462656562' COLLATE "C")::uuid;

-- Test 27: query (line 121)
SELECT uuid_nil();

-- Test 28: query (line 126)
SELECT uuid_ns_dns();

-- Test 29: query (line 131)
SELECT uuid_ns_url();

-- Test 30: query (line 136)
SELECT uuid_ns_oid();

-- Test 31: query (line 141)
SELECT uuid_ns_x500();

-- Test 32: query (line 146)
SELECT uuid_generate_v1() = uuid_generate_v1();

-- Test 33: query (line 151)
SELECT uuid_generate_v1mc() = uuid_generate_v1mc();

-- Test 34: query (line 158)
SELECT substr(uuid_generate_v1()::TEXT, 24) = substr(uuid_generate_v1()::TEXT, 24);

-- Test 35: query (line 163)
SELECT substr(uuid_generate_v1mc()::TEXT, 24) = substr(uuid_generate_v1mc()::TEXT, 24);

-- Test 36: query (line 168)
SELECT uuid_generate_v3(uuid_ns_x500(), 'cat');

-- Test 37: query (line 173)
SELECT uuid_generate_v5(uuid_ns_oid(), 'dog');

-- Test 38: statement (line 180)
CREATE TABLE t83093 (u) AS
  SELECT 'eb64afe6-ade7-40ce-8352-4bb5eec39075'::UUID;

-- Test 39: query (line 183)
SELECT u || 'foo' FROM t83093;

RESET client_min_messages;
