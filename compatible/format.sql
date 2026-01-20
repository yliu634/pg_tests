-- PostgreSQL compatible tests from format
-- 27 tests

-- Test 1: query (line 4)
select format(NULL)

-- Test 2: query (line 9)
select format('Hello')

-- Test 3: query (line 14)
select format('Hello %s', 'World')

-- Test 4: query (line 19)
select format('Hello %%')

-- Test 5: query (line 24)
select format('Hello %%%%')

-- Test 6: query (line 43)
select format('%s%s%s','Hello', NULL,'World')

-- Test 7: query (line 48)
select format('INSERT INTO %I VALUES(%L,%L)', 'mytab', 10, NULL)

-- Test 8: query (line 53)
select format('INSERT INTO %I VALUES(%L,%L)', 'mytab', NULL, 'Hello');

-- Test 9: query (line 58)
select format('INSERT INTO %I VALUES(%L,%L)', NULL, 10, 'Hello')

# Many of the below tests involve strings with a literal $.
# This can break TestLogic under some conditions. If you're seeing mysterious errors in this file,
# they can likely be fixed by escaping $ into \x24, e.g. replace '%1$s' with E'%\x24s'.
# For now, strings are left unescaped here for readability.
query T
select format('%1$s %3$s', 1, 2, 3)

-- Test 10: query (line 70)
select format('%1$s %12$s', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)

-- Test 11: query (line 105)
select format('Hello %s %s, %2$s %2$s', 'World', 'Hello again')

-- Test 12: query (line 110)
select format('>>%10s<<', 'Hello')

-- Test 13: query (line 115)
select format('>>%10s<<', NULL)

-- Test 14: query (line 120)
select format('>>%10s<<', '')

-- Test 15: query (line 125)
select format('>>%-10s<<', '')

-- Test 16: query (line 130)
select format('>>%-10s<<', 'Hello')

-- Test 17: query (line 135)
select format('>>%-10s<<', NULL)

-- Test 18: query (line 140)
select format('>>%1$10s<<', 'Hello')

-- Test 19: query (line 145)
select format('>>%1$-10I<<', 'Hello')

-- Test 20: query (line 150)
select format('>>%2$*1$L<<', 10, 'Hello')

-- Test 21: query (line 155)
select format('>>%2$*1$L<<', 10, NULL)

-- Test 22: query (line 160)
select format('>>%*s<<', 10, 'Hello')

-- Test 23: query (line 165)
select format('>>%*1$s<<', 10, 'Hello')

-- Test 24: query (line 170)
select format('>>%-s<<', 'Hello')

-- Test 25: query (line 175)
select format('>>%10L<<', NULL)

-- Test 26: query (line 182)
select format('>>%2$*1$L<<', NULL, 'Hello')

-- Test 27: query (line 187)
select format('>>%2$*1$L<<', 0, 'Hello')

