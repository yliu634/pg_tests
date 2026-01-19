-- PostgreSQL compatible tests from show_completions
-- 15 tests

-- Test 1: query (line 3)
SHOW COMPLETIONS AT OFFSET 5 FOR 'creat'

-- Test 2: query (line 11)
SELECT * FROM [SHOW COMPLETIONS AT OFFSET 5 FOR 'creat'] ORDER BY completion

-- Test 3: query (line 23)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 5 FOR 'creat'] ORDER BY completion

-- Test 4: query (line 31)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 5 FOR 'CREAT'] ORDER BY completion

-- Test 5: query (line 39)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 10 FOR 'SHOW CREAT'] ORDER BY completion

-- Test 6: query (line 47)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 10 FOR 'show creat'] ORDER BY completion

-- Test 7: query (line 59)
SELECT count(*) > 0 FROM [SHOW COMPLETIONS AT OFFSET 6 FOR 'creat ']

-- Test 8: query (line 68)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 3 FOR 'sel']

-- Test 9: query (line 77)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 3 FOR 'create ta'] ORDER BY completion

-- Test 10: query (line 89)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 2 FOR 'select']

-- Test 11: query (line 98)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 2 FOR '你好，我的名字是鲍勃 SELECT']

-- Test 12: query (line 102)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 11 FOR '你好，我的名字是鲍勃 SELECT']

-- Test 13: query (line 106)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 33 FOR '你好，我的名字是鲍勃 SELECT']

-- Test 14: query (line 111)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 25 FOR '😋😋😋 😋😋😋']

-- Test 15: query (line 115)
SELECT completion FROM [SHOW COMPLETIONS AT OFFSET 9 FOR 'Jalapeño']

