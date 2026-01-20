-- PostgreSQL compatible tests from udf_star
-- 40 tests

-- Test 1: statement (line 3)
CREATE TABLE t_onecol (a INT);
INSERT INTO t_onecol VALUES (1)

-- Test 2: statement (line 7)
CREATE TABLE t_twocol (a INT, b INT);
INSERT INTO t_twocol VALUES (1,2)

-- Test 3: statement (line 11)
CREATE FUNCTION f_unqualified_onecol() RETURNS INT AS
$$
  SELECT * FROM t_onecol;
$$ LANGUAGE SQL;

-- Test 4: statement (line 17)
CREATE FUNCTION f_subquery() RETURNS INT AS
$$
  SELECT * FROM (SELECT a FROM (SELECT * FROM t_onecol) AS foo) AS bar;
$$ LANGUAGE SQL;

-- Test 5: statement (line 23)
CREATE FUNCTION f_subquery_unaliased() RETURNS INT AS
$$
  SELECT * FROM (SELECT a FROM (SELECT * FROM t_onecol));
$$ LANGUAGE SQL;

-- Test 6: statement (line 29)
CREATE FUNCTION f_unqualified_twocol() RETURNS t_twocol AS
$$
  SELECT * FROM t_twocol;
$$ LANGUAGE SQL;

-- Test 7: statement (line 35)
CREATE FUNCTION f_allcolsel() RETURNS t_twocol AS
$$
  SELECT t_twocol.* FROM t_twocol;
$$ LANGUAGE SQL;

-- Test 8: statement (line 41)
CREATE FUNCTION f_allcolsel_alias() RETURNS t_twocol AS
$$
  SELECT t1.* FROM t_twocol AS t1, t_twocol AS t2 WHERE t1.a = t2.a;
$$ LANGUAGE SQL;

-- Test 9: statement (line 47)
CREATE FUNCTION f_tuplestar() RETURNS t_twocol AS
$$
  SELECT (t_twocol.*).* FROM t_twocol;
$$ LANGUAGE SQL;

-- Test 10: statement (line 53)
CREATE FUNCTION f_unqualified_multicol() RETURNS INT AS
$$
  SELECT *, a FROM t_onecol;
  SELECT 1;
$$ LANGUAGE SQL;

-- Test 11: statement (line 60)
CREATE FUNCTION f_unqualified_doublestar() RETURNS INT AS
$$
  SELECT *, * FROM t_onecol;
  SELECT 1;
$$ LANGUAGE SQL;

-- Test 12: statement (line 73)
CREATE FUNCTION f_anon_subqueries() RETURNS INT AS
$$
  SELECT * FROM (SELECT a FROM t_onecol) JOIN (SELECT a FROM t_twocol) ON true;
  SELECT 1;
$$ LANGUAGE SQL;

-- Test 13: statement (line 80)
CREATE FUNCTION f_ambiguous() RETURNS INT AS
$$
  SELECT a FROM (SELECT * FROM (SELECT a FROM t_onecol) AS foo JOIN (SELECT a FROM t_twocol) AS bar ON true) AS baz;
  SELECT 1;
$$ LANGUAGE SQL;

-- Test 14: query (line 87)
SELECT oid, proname, prosrc
FROM pg_catalog.pg_proc WHERE proname LIKE 'f\_%' ORDER BY oid;

-- Test 15: query (line 107)
SHOW CREATE FUNCTION f_subquery

-- Test 16: query (line 121)
SHOW CREATE FUNCTION f_allcolsel_alias

-- Test 17: query (line 135)
SELECT f_unqualified_onecol()

-- Test 18: query (line 140)
SELECT f_subquery()

-- Test 19: query (line 145)
SELECT f_exprstar()

-- Test 20: statement (line 151)
ALTER TABLE t_onecol ADD COLUMN b INT DEFAULT 5;

-- Test 21: query (line 154)
SELECT f_unqualified_onecol()

-- Test 22: query (line 159)
SELECT f_subquery()

-- Test 23: statement (line 165)
ALTER TABLE t_onecol DROP COLUMN b;

-- Test 24: query (line 168)
SELECT f_unqualified_twocol()

-- Test 25: query (line 173)
SELECT f_allcolsel()

-- Test 26: query (line 178)
SELECT f_allcolsel_alias()

-- Test 27: statement (line 185)
ALTER TABLE t_twocol ADD COLUMN c INT DEFAULT 5;

-- Test 28: statement (line 188)
SELECT f_unqualified_twocol()

-- Test 29: statement (line 192)
ALTER TABLE t_twocol DROP COLUMN c;

-- Test 30: statement (line 195)
SELECT f_unqualified_twocol()

-- Test 31: statement (line 199)
ALTER TABLE t_twocol ALTER b TYPE FLOAT;

-- Test 32: statement (line 203)
ALTER TABLE t_twocol RENAME COLUMN a TO d;

-- Test 33: statement (line 208)
ALTER TABLE t_twocol RENAME TO t_twocol_prime;

onlyif config local-legacy-schema-changer

-- Test 34: statement (line 212)
ALTER TABLE t_twocol RENAME TO t_twocol_prime;

-- Test 35: statement (line 216)
ALTER TABLE t_twocol DROP COLUMN b;

-- Test 36: statement (line 220)
DROP FUNCTION f_tuplestar;
DROP FUNCTION f_allcolsel_alias;

-- Test 37: statement (line 228)
ALTER TABLE t_twocol DROP COLUMN b CASCADE;

-- Test 38: statement (line 231)
DROP TABLE t_onecol CASCADE;

-- Test 39: query (line 237)
SELECT oid, proname, prosrc
FROM pg_catalog.pg_proc WHERE proname LIKE 'f\_%' ORDER BY oid;

-- Test 40: query (line 245)
SELECT oid, proname, prosrc
FROM pg_catalog.pg_proc WHERE proname LIKE 'f\_%' ORDER BY oid;

