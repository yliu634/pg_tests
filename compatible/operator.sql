-- PostgreSQL compatible tests from operator
-- 10 tests

-- Test 1: query (line 1)
-- Expected ERROR (cannot take square root of a negative number):
DO $$
BEGIN
  BEGIN
    PERFORM |/ -1.0::float;
  EXCEPTION WHEN others THEN
    NULL;
  END;
  BEGIN
    PERFORM |/ -1.0::decimal;
  EXCEPTION WHEN others THEN
    NULL;
  END;
END $$;

-- query I
SELECT ~ -1;

-- Test 2: query (line 12)
SELECT ~0;

-- Test 3: query (line 17)
SELECT ~1;

-- Test 4: query (line 22)
SELECT ~2;

-- Test 5: query (line 27)
SELECT ~B'0';

-- Test 6: query (line 32)
SELECT ~B'1';

-- Test 7: statement (line 37)
-- Expected ERROR (invalid bit string literal):
DO $$
BEGIN
  BEGIN
    PERFORM ~B'2';
  EXCEPTION WHEN others THEN
    NULL;
  END;
END $$;

-- Test 8: statement (line 40)
-- Expected ERROR (no unary ~ operator for text):
DO $$
BEGIN
  BEGIN
    PERFORM ~'0';
  EXCEPTION WHEN others THEN
    NULL;
  END;
END $$;

-- Test 9: statement (line 43)
-- Expected ERROR (no unary ~ operator for text):
DO $$
BEGIN
  BEGIN
    PERFORM ~'1';
  EXCEPTION WHEN others THEN
    NULL;
  END;
END $$;

-- Test 10: query (line 46)
SELECT ~2;
