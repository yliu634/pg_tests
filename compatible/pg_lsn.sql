-- PostgreSQL compatible tests from pg_lsn
-- 19 tests

SET client_min_messages = warning;

-- Test 1: query (line 3)
SELECT 'A01F0/1AAA'::pg_lsn;

-- Test 2: statement (line 8)
DROP TABLE IF EXISTS pg_lsn_table CASCADE;
CREATE TABLE pg_lsn_table(id pg_lsn PRIMARY KEY, val pg_lsn);

-- Test 3: statement (line 11)
INSERT INTO pg_lsn_table VALUES ('10/10', 'A01/A100'), ('100/100', 'A01/A1000'), ('FFFFF100/100', 'A001/A100');

-- Test 4: query (line 14)
SELECT * FROM pg_lsn_table ORDER BY id;

-- Test 5: query (line 21)
SELECT * FROM pg_lsn_table WHERE id = '10/10' ORDER BY id;

-- Test 6: query (line 26)
SELECT * FROM pg_lsn_table WHERE val = 'A01/A1000' ORDER BY id;

-- Test 7: statement (line 31)
SELECT '0/0'::pg_lsn + 0;

-- Test 8: statement (line 34)
SELECT '0/0'::pg_lsn + 1;

-- Test 9: statement (line 37)
SELECT '1/0'::pg_lsn - 1;

-- Test 10: statement (line 40)
SELECT '50/0'::pg_lsn - 50;

-- Test 11: statement (line 43)
SELECT '0/0'::pg_lsn + 50;

-- Test 12: query (line 46)
SELECT * FROM ( VALUES
  ('0/0'::pg_lsn + 1),
  (1.5 + '0/0'::pg_lsn),
  ('0/0'::pg_lsn + 1.4),
  ('0/0'::pg_lsn + 1.5),
  ('0/0'::pg_lsn + 1.6),
  ('FFFFFFFF/FFFFFFFF'::pg_lsn - 1),
  ('FFFFFFFF/FFFFFFFF'::pg_lsn - 1.4),
  ('FFFFFFFF/FFFFFFFF'::pg_lsn - 1.5),
  ('FFFFFFFF/FFFFFFFF'::pg_lsn - 1.6)
) AS t(val);

-- Test 13: query (line 69)
SELECT * FROM ( VALUES
  ('0/0'::pg_lsn - '10/100'::pg_lsn),
  ('1500/100' - '10/0'::pg_lsn),
  ('FFFFFFFF/FFFFFFFF' - '0/0'::pg_lsn),
  ('0/0'::pg_lsn - 'FFFFFFFF/FFFFFFFF'::pg_lsn)
) AS t(val);

-- Test 14: statement (line 82)
SELECT '0/0'::pg_lsn;

-- Test 15: statement (line 85)
SELECT '1/0'::pg_lsn;

-- Test 16: statement (line 88)
SELECT '2/0'::PG_LSN;

-- Test 17: statement (line 91)
SELECT pg_lsn('3/0');

-- Test 18: statement (line 94)
SELECT '4/0'::PG_LSN;

-- Test 19: statement (line 97)
SELECT '5/0'::PG_LSN;
