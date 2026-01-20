-- PostgreSQL compatible tests from disjunction_in_join
-- 66 tests

SET client_min_messages = warning;
DROP TABLE IF EXISTS a CASCADE;
DROP TABLE IF EXISTS b CASCADE;
DROP TABLE IF EXISTS c CASCADE;
DROP TABLE IF EXISTS d CASCADE;
RESET client_min_messages;

-- Test 1: statement (line 6)
CREATE TABLE a(a1 INT, a2 INT, a3 INT, a4 INT, PRIMARY KEY(a1, a2, a3, a4));

-- Test 2: statement (line 9)
CREATE TABLE b(b1 INT, b2 INT, b3 INT, b4 INT);
CREATE INDEX ON b (b1, b2) INCLUDE (b3, b4);
CREATE INDEX ON b (b2) INCLUDE (b1, b3, b4);
CREATE INDEX ON b (b3) INCLUDE (b1, b2, b4);

-- Test 3: statement (line 15)
CREATE TABLE c(c1 INT, c2 INT, c3 INT, c4 INT);

-- Test 4: statement (line 18)
CREATE TABLE d(d1 INT, d2 INT, d3 INT, d4 INT);
CREATE INDEX d_idx ON d (d1) INCLUDE (d2, d3, d4);

-- Test 5: statement (line 23)
INSERT INTO a VALUES (0, 0, 0, 0),(1, 10, 100, 1000);
INSERT INTO b VALUES (0, 0, 0, 0),(1, 10, 100, 1000);
INSERT INTO c VALUES (0, 0, 0, 0),(1, 10, 100, 1000);
INSERT INTO d VALUES (0, 0, 0, 0),(1, 10, 100, 1000);

-- Test 6: statement (line 30)
INSERT INTO a VALUES (11, 110, 1100, 11000);
INSERT INTO b VALUES (11, 110, 1100, 11000), (11, 110, 1100, 11000);
INSERT INTO c VALUES (11, 110, 1100, 11000), (11, 110, 1100, 11000), (11, 110, 1100, 11000);
INSERT INTO d VALUES (11, 110, 1100, 11000), (11, 110, 1100, 11000), (11, 110, 1100, 11000), (11, 110, 1100, 11000);

-- Test 7: statement (line 37)
INSERT INTO b VALUES (NULL, NULL, NULL, NULL), (NULL, NULL, NULL, NULL);
INSERT INTO d VALUES (NULL, NULL, NULL, NULL), (NULL, NULL, NULL, NULL), (NULL, NULL, NULL, NULL), (NULL, NULL, NULL, NULL);

-- Test 8: statement (line 42)
INSERT INTO a VALUES (12, 120, 1200, 1), (12, 120, 1200, 2);
INSERT INTO b VALUES (12, 120, 1200, 1), (12, 120, 1200, 2), (12, 120, 1200, 2);

-- Test 9: statement (line 47)
INSERT INTO b VALUES (NULL, 120, 1200, 1)   , (12, NULL, 1200, 2);
INSERT INTO d VALUES (11, NULL, NULL, 11000), (NULL, 110, 1100, 11000);

-- Test 10: statement (line 52)
INSERT INTO a VALUES (2, 20, 200, 2000), (3, 30, 300, 3000), (4, 40, 400, 4000), (5, 50, 500, 5000), (6, 60, 600, 6000), (7, 70, 700, 7000);
INSERT INTO b VALUES (2, 20, 200, 2000), (3, 30, 300, 3000),                     (5, 50, 500, 5000), (6, 60, 600, 6000)                    , (8, 80, 800, 8000), (9, 90, 900, 9000);
INSERT INTO c VALUES (2, 20, 200, 2000),                                         (5, 50, 500, 5000)                                        , (8, 80, 800, 8000)                    , (10, 100, 1000, 10000);
INSERT INTO d VALUES                                                             (5, 50, 500, 5000), (6, 60, 600, 6000), (7, 70, 700, 7000);

-- Test 11: statement (line 59)
INSERT INTO b VALUES (2, NULL, 200, NULL), (3, 30, 300, NULL)    , (NULL, 40, 400, 4000)  , (NULL, NULL, NULL, 5000)                       , (7, NULL, 700, NULL);
INSERT INTO b VALUES (2, 20, NULL, 200)  , (3, 30, 300, 3000)    , (4, NULL, NULL, NULL)  , (5, 50, NULL, 5000)                            , (7, NULL, 700, NULL);
INSERT INTO c VALUES                       (3, 30, NULL, NULL)   , (NULL, NULL, 400, 4000), (5, 50, NULL, NULL), (6, NULL, NULL, 6000);
INSERT INTO d VALUES                       (NULL, 30, NULL, 3000)                                                                                                , (NULL, 90, NULL, NULL);

-- Test 12: statement (line 66)
INSERT INTO b VALUES (82, NULL, 207, NULL), (NULL, 567, NULL, 789);
INSERT INTO c VALUES (83, 208, NULL, NULL), (NULL, NULL, 84, 209);
INSERT INTO d VALUES (85, NULL, NULL, 210), (NULL, 86, 211, NULL);

-- Test 13: statement (line 72)
INSERT INTO a VALUES (15,   55, 555, 5555), (15, 55,   500, 5555), (15, 50, 555,  5555);
INSERT INTO b VALUES (17,   77, 777, 7777), (17, 77,   700, 7777), (17, 70, 777,  7777);
INSERT INTO b VALUES (NULL, 77, 777, 7777), (17, NULL, 777, 7777), (17, 77, NULL, 7777);

-- Test 14: statement (line 78)
INSERT INTO a VALUES (101, 200, 3000, 40);
INSERT INTO a VALUES (102, 5, 60, 70);
INSERT INTO a VALUES (103, 7, 8, 70);
INSERT INTO a VALUES (104, 5, 5, 5);
INSERT INTO a VALUES (50, 5, 5000, 500);
INSERT INTO a VALUES (80, 11, 110, 11000);
INSERT INTO b VALUES (30, 7, 40, 2);
INSERT INTO b VALUES (120, 80, 90, 10);
INSERT INTO c VALUES (1, 2, 3, 4);
INSERT INTO d VALUES (5, 6, 7, 8), (9, 10, 11, 12);

-- Test 15: query (line 95)
SELECT t1.*, t2.* FROM a t1, a t2 WHERE t1.a1 = t2.a3 OR t1.a2 = t2.a4 OR t1.a1 = t2.a4;

-- Test 16: query (line 110)
SELECT * FROM a t1, a t2 WHERE (t1.a2 = t2.a2 OR t1.a3 = t2.a3) AND (t1.a1 = t2.a1 OR t1.a4 = t2.a4);

-- Test 17: query (line 140)
SELECT * FROM a, b WHERE (a2 = b2 OR a3 = b3) AND (a1 = b1 OR a4 = b4);

-- Test 18: query (line 169)
SELECT a1,a2,a3 FROM a,b WHERE (a1=b1 AND a2=b2 AND (a1=1 OR b1=1)) OR (a3=b3 AND a4=b4);

-- Test 19: query (line 188)
SELECT a1,a2,a3 FROM a,b WHERE a1=1 AND (a2=b2 OR a3=b3);

-- Test 20: query (line 194)
SELECT * FROM a, c WHERE (a1 = c1 OR a2 = c2 OR a3 = c3 OR a4 = c4);

-- Test 21: query (line 216)
SELECT * FROM a, c WHERE (a1 = c2 OR a2 = c1 OR a3 = c4 OR a3 = c4);

-- Test 22: query (line 234)
SELECT * FROM b, d WHERE (b1 = b2 OR b3 = d3);

-- Test 23: query (line 275)
SELECT * FROM b, d WHERE (b1 = b2 OR b3 = d3 OR b4 = d4 OR d1 = d2);

-- Test 24: query (line 358)
SELECT * FROM b, d WHERE (b1 = 0 OR b1 = d1)   AND
                         (b1 = 0 OR b2 = 5)    AND
                         (b2 = d1 OR b1 = d1)  AND
                         (b2 = d1 OR b2 = 5);

-- Test 25: query (line 367)
SELECT * FROM c, d WHERE (c1 = d1 AND c2 = d2) OR c3 = d3;

-- Test 26: query (line 390)
SELECT * FROM a, d WHERE (a1 = d2 AND a2 = d1) OR (a3 = d4 AND a4 = d3);

-- Test 27: query (line 400)
SELECT * FROM a WHERE EXISTS (SELECT 1 FROM d WHERE d1 = 4 OR d2 = 50);

-- Test 28: query (line 424)
SELECT * FROM a WHERE EXISTS (SELECT 1 FROM c, d WHERE d1 = 4 OR c2 = 50 HAVING sum(d4) > 40);

-- Test 29: query (line 448)
SELECT * FROM a WHERE EXISTS (SELECT 1 FROM c, d WHERE c1 = d2 or c2 = d1);

-- Test 30: query (line 472)
SELECT * FROM a WHERE (a1, a2) IN (SELECT c1, d1 FROM c, d WHERE c3 = d3 or c3 = d4);

-- Test 31: query (line 477)
SELECT * FROM a WHERE (a1, a2) IN (SELECT c1, d1 FROM c, d WHERE c3 = d3 or c2 = d2 EXCEPT ALL
                                   SELECT c1, d1 FROM c, d WHERE c3 = d3 or c2 = d2);

-- Test 32: query (line 482)
SELECT * FROM a WHERE (a1, a2) IN (SELECT c1, d1 FROM c, d WHERE c1 IS NULL OR c1 = d1);

-- Test 33: query (line 487)
SELECT * FROM b WHERE b1 NOT IN (SELECT c1 FROM c, d WHERE c1 IS NULL OR c1 = d1);

-- Test 34: query (line 491)
SELECT * FROM b WHERE (b1, b2) NOT IN (SELECT c1, c2 FROM c, d WHERE c1 IS NULL OR c1 = d1);

-- Test 35: query (line 499)
SELECT * FROM a WHERE NOT EXISTS (SELECT 1 FROM b WHERE b1 = 4 OR b2 = 50);

-- Test 36: query (line 503)
SELECT * FROM a WHERE NOT EXISTS (SELECT 1 FROM c, d WHERE d1 = 4 OR c2 = 50 or d2+c3 > 5);

-- Test 37: query (line 507)
SELECT * FROM a WHERE NOT EXISTS (SELECT 1 FROM c, d WHERE c3 = d4 or c4 = d3);

-- Test 38: query (line 511)
SELECT * FROM a WHERE (a1, a2) NOT IN (SELECT c1, d1 FROM c, d WHERE c3 = d3 or c3 = d4);

-- Test 39: query (line 533)
SELECT * FROM a WHERE (a1, a2) NOT IN (SELECT c1, d1 FROM c, d WHERE c3 = d3 or c2 = d2 EXCEPT ALL
                                       SELECT c1, d1 FROM c, d WHERE c3 = d3 or c2 = d2);

-- Test 40: query (line 558)
SELECT * FROM a WHERE (a1, a2) NOT IN (SELECT c1, d1 FROM c, d WHERE c1 IS NULL OR c1 = d1);

-- Test 41: query (line 566)
SELECT a1,a2,a3 FROM a WHERE EXISTS (SELECT * FROM b WHERE a2 = b2 OR a3 = b3);

-- Test 42: query (line 584)
SELECT a1,a2,a3 FROM a WHERE EXISTS (SELECT * FROM b WHERE a1 = b1 OR a1 = b2);

-- Test 43: query (line 602)
SELECT * FROM a WHERE EXISTS (SELECT * FROM b WHERE a1 = b1 OR a2 = b2 OR a3 = b3 OR a4 = b4);

-- Test 44: query (line 622)
SELECT * FROM a WHERE EXISTS (SELECT * FROM c WHERE a1 = c1 OR a2 = c2 OR a3 = c3 OR a4 = c4);

-- Test 45: query (line 638)
SELECT * FROM a WHERE EXISTS (SELECT * FROM c WHERE a1 = c2 OR a2 = c1 OR a3 = c4 OR a3 = c4);

-- Test 46: query (line 650)
SELECT a1+a3-a2 FROM a WHERE a1 IN (SELECT b1 FROM b WHERE EXISTS (SELECT 1 FROM c WHERE c2 IS NULL OR c2=b2 OR c2=b3));

-- Test 47: query (line 666)
SELECT a1+a3-a2 FROM a WHERE (a1,a2) IN (SELECT b1,b2 FROM b WHERE
                                            EXISTS (SELECT 1 FROM c WHERE c2 IS NULL OR c2=b2 OR c2=b3));

-- Test 48: query (line 681)
SELECT a1,a2,a3,c.* FROM a,c
       WHERE a2 = c2 AND EXISTS (SELECT * FROM b WHERE (a1 = b1 OR a1 = a2) AND (a1 = c1 OR c1 = c2));

-- Test 49: query (line 695)
SELECT a1,a2,a3,c.* FROM a,c
       WHERE a2 = c2 AND EXISTS (SELECT * FROM b WHERE (a1 = b1 OR a1 = b2) AND (c1 = b1 OR c1 = b2));

-- Test 50: query (line 709)
SELECT a1,a2,a3,c.* FROM a,c
       WHERE a2 = c2 AND EXISTS (SELECT * FROM b WHERE (a1 = b1 OR a1 = b3) AND (a1 = c1 OR a1 = c3));

-- Test 51: query (line 724)
SELECT a2,a4 FROM a WHERE EXISTS(SELECT * FROM b WHERE (a1=b1 OR a1=b2) AND EXISTS(SELECT 1 FROM c WHERE b1=c1));

-- Test 52: query (line 738)
SELECT a2,a4 FROM a WHERE EXISTS(SELECT * FROM b WHERE a1=b1 OR a1=b2) AND
                          EXISTS(SELECT * FROM c WHERE a1=c1 OR a1=c2);

-- Test 53: query (line 753)
SELECT a2,a4 FROM a WHERE EXISTS(SELECT * FROM b WHERE a1=b1 OR a1=b2 OR a1=b3 OR a1=b4) AND
                          EXISTS(SELECT * FROM c WHERE a1=c1 OR a1=c2 OR a1=c3 OR a1=c4);

-- Test 54: query (line 769)
SELECT * FROM a JOIN (SELECT * FROM b WHERE b1 > 0 AND EXISTS (SELECT 1 FROM c WHERE c1=b1))
                       AS foo on a1=foo.b1 OR a2=foo.b2;

-- Test 55: query (line 788)
SELECT * FROM a JOIN (SELECT * FROM b WHERE b1 > 0 AND EXISTS (SELECT 1 FROM c WHERE c1=b1 or c2=b2))
                       AS foo on a1=foo.b1;

-- Test 56: query (line 809)
SELECT a1,a2,a3 FROM a WHERE NOT EXISTS (SELECT * FROM b WHERE a2 = b2 OR a3 = b3);

-- Test 57: query (line 819)
SELECT a1,a2,a3 FROM a WHERE NOT EXISTS (SELECT * FROM b WHERE a1 = b1 OR a1 = b2);

-- Test 58: query (line 831)
SELECT * FROM a WHERE NOT EXISTS (SELECT * FROM b WHERE a1 = b1 OR a2 = b2 OR a3 = b3 OR a4 = b4);

-- Test 59: query (line 841)
SELECT * FROM a WHERE NOT EXISTS (SELECT * FROM c WHERE a1 = c1 OR a2 = c2 OR a3 = c3 OR a4 = c4);

-- Test 60: query (line 854)
SELECT * FROM a WHERE NOT EXISTS (SELECT * FROM c WHERE a1 = c2 OR a2 = c1 OR a3 = c4 OR a3 = c4);

-- Test 61: query (line 872)
SELECT a2,a4 FROM a WHERE NOT EXISTS(SELECT * FROM b WHERE (a1=b1 OR a1=b2) AND NOT EXISTS(SELECT 1 FROM c WHERE b1=c1));

-- Test 62: query (line 892)
SELECT a2,a4 FROM a WHERE NOT EXISTS(SELECT * FROM b WHERE a1=b1 OR a1=b2) AND
                          NOT EXISTS(SELECT * FROM c WHERE a1=c1 OR a1=c2);

-- Test 63: query (line 905)
SELECT * FROM a JOIN (SELECT * FROM b WHERE b1 > 0 AND NOT EXISTS (SELECT 1 FROM c WHERE c1=b1))
                       AS foo on a1=foo.b1 OR a2=foo.b2;

-- Test 64: query (line 923)
SELECT * FROM a JOIN (SELECT * FROM b WHERE b1 > 0 AND NOT EXISTS (SELECT 1 FROM c WHERE c1=b1 or c2=b2))
                       AS foo on a1=foo.b1;

-- Test 65: query (line 940)
SELECT d3,d1,d2 FROM d WHERE d1 NOT IN (SELECT b1 FROM b WHERE EXISTS (SELECT 1 FROM c WHERE c2=b2 OR c2=b3));

-- Test 66: query (line 949)
SELECT d3,d1,d2 FROM d WHERE (d1,d3) NOT IN (SELECT b1,b2 FROM b WHERE EXISTS (SELECT 1 FROM c WHERE c2=b2 OR c2=b3));
