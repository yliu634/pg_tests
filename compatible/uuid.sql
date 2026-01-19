-- PostgreSQL compatible tests from uuid
-- 39 tests

-- Test 1: statement (line 2)
CREATE TABLE u (token uuid PRIMARY KEY,
                token2 uuid,
                token3 uuid,
                UNIQUE INDEX i_token2 (token2))

-- Test 2: statement (line 8)
INSERT INTO u VALUES
  ('63616665-6630-3064-6465-616462656562', '{63616665-6630-3064-6465-616462656563}', b'kafef00ddeadbeed'),
  ('urn:uuid:63616665-6630-3064-6465-616462656564', '63616665-6630-3064-6465-616462656565'::uuid, b'kafef00ddeadbeee'),
  (b'cafef00ddeadbeef', '63616665-6630-3064-6465-616462656567', b'kafef00ddeadbeef')

-- Test 3: query (line 14)
SELECT * FROM u ORDER BY token

-- Test 4: query (line 21)
SELECT * FROM u WHERE token < '63616665-6630-3064-6465-616462656564'::uuid

-- Test 5: query (line 26)
SELECT * FROM u WHERE token <= '63616665-6630-3064-6465-616462656564'::uuid ORDER BY token

-- Test 6: statement (line 32)
INSERT INTO u VALUES ('63616665-6630-3064-6465-616462656566')

-- Test 7: statement (line 35)
INSERT INTO u VALUES ('63616665-6630-3064-6465-616462656569', '63616665-6630-3064-6465-616462656565')

-- Test 8: statement (line 38)
INSERT INTO u VALUES (b'cafef00ddeadbee')

-- Test 9: statement (line 41)
INSERT INTO u VALUES (b'cafef00ddeadbeefs')

-- Test 10: statement (line 44)
INSERT INTO u VALUES ('63616665-6630-3064-6465-61646265656')

-- Test 11: statement (line 47)
INSERT INTO u VALUES ('63616665-6630-3064-6465-6164626565620')

-- Test 12: statement (line 50)
SELECT token FROM u WHERE token=b'cafef00ddeadbeef'::bytes

-- Test 13: statement (line 56)
SELECT token FROM u WHERE token='63616665-6630-3064-6465-616462656562'::uuid

-- Test 14: query (line 59)
SELECT token FROM u WHERE token='urn:uuid:63616665-6630-3064-6465-616462656562'

-- Test 15: query (line 64)
SELECT token FROM u WHERE token=b'cafef00ddeadbeef'

-- Test 16: query (line 69)
SELECT token2 FROM u WHERE token2='63616665-6630-3064-6465-616462656563'

-- Test 17: query (line 74)
SELECT token FROM u WHERE token IN ('63616665-6630-3064-6465-616462656562', '63616665-6630-3064-6465-616462656564') ORDER BY token

-- Test 18: statement (line 80)
INSERT INTO u VALUES ('63616665-6630-3064-6465-616462656567'::uuid)

-- Test 19: statement (line 83)
INSERT INTO u VALUES ('urn:uuid:63616665-6630-3064-6465-616462656568'::uuid)

-- Test 20: statement (line 86)
INSERT INTO u VALUES (uuid_v4()::uuid)

-- Test 21: statement (line 89)
INSERT INTO u VALUES ('cafef00ddeadbeef'::bytes)

-- Test 22: statement (line 95)
INSERT INTO u VALUES (uuid_v4())

-- Test 23: query (line 98)
SELECT token::uuid FROM u WHERE token=b'cafef00ddeadbeef'

-- Test 24: query (line 108)
SELECT token::bytes FROM u WHERE token=b'cafef00ddeadbeef'

-- Test 25: statement (line 113)
SELECT token::int FROM u

-- Test 26: query (line 116)
SELECT ('63616665-6630-3064-6465-616462656562' COLLATE en)::uuid

-- Test 27: query (line 121)
SELECT uuid_nil()

-- Test 28: query (line 126)
SELECT uuid_ns_dns()

-- Test 29: query (line 131)
SELECT uuid_ns_url()

-- Test 30: query (line 136)
SELECT uuid_ns_oid()

-- Test 31: query (line 141)
SELECT uuid_ns_x500()

-- Test 32: query (line 146)
SELECT uuid_generate_v1() = uuid_generate_v1()

-- Test 33: query (line 151)
SELECT uuid_generate_v1mc() = uuid_generate_v1mc()

-- Test 34: query (line 158)
SELECT substr(uuid_generate_v1()::TEXT, 24) = substr(uuid_generate_v1()::TEXT, 24)

-- Test 35: query (line 163)
SELECT substr(uuid_generate_v1mc()::TEXT, 24) = substr(uuid_generate_v1mc()::TEXT, 24)

-- Test 36: query (line 168)
SELECT uuid_generate_v3(uuid_ns_x500(), 'cat')

-- Test 37: query (line 173)
SELECT uuid_generate_v5(uuid_ns_oid(), 'dog')

-- Test 38: statement (line 180)
CREATE TABLE t83093 (u) AS SELECT 'eb64afe6-ade7-40ce-8352-4bb5eec39075'::UUID

-- Test 39: query (line 183)
SELECT u || 'foo' FROM t83093

