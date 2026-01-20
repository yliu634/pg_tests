-- PostgreSQL compatible tests from rand_ident
-- 12 tests

-- Test 1: query (line 3)
SELECT count(*) FROM crdb_internal.gen_rand_ident('hello', 10)

-- Test 2: query (line 11)
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123}')

-- Test 3: query (line 25)
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"suffix":false}')

-- Test 4: query (line 40)
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":true,"emote":-1}')

-- Test 5: query (line 55)
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false}')

-- Test 6: query (line 69)
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"punctuate":1}')

-- Test 7: query (line 83)
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"quote":1}')

-- Test 8: query (line 97)
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"space":1}')

-- Test 9: query (line 111)
SELECT quote_ident(crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"whitespace":1}'))

-- Test 10: query (line 129)
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"emote":1}')

-- Test 11: query (line 143)
SELECT crdb_internal.gen_rand_ident('aeaeiao', 10, '{"seed":123,"noise":false,"diacritics":3,"diacritic_depth":4}')

-- Test 12: query (line 157)
SELECT crdb_internal.gen_rand_ident('aeaeiao', 10, '{"seed":123,"noise":false,"zalgo":true}')

