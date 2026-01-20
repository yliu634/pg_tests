-- PostgreSQL compatible tests from subquery_correlated
-- 116 tests

-- Test 1: statement (line 8)
CREATE TABLE c (c_id INT PRIMARY KEY, bill TEXT);
CREATE TABLE o (o_id INT PRIMARY KEY, c_id INT, ship TEXT);
INSERT INTO c VALUES
    (1, 'CA'),
    (2, 'TX'),
    (3, 'MA'),
    (4, 'TX'),
    (5, NULL),
    (6, 'FL');
INSERT INTO o VALUES
    (10, 1, 'CA'), (20, 1, 'CA'), (30, 1, 'CA'),
    (40, 2, 'CA'), (50, 2, 'TX'), (60, 2, NULL),
    (70, 4, 'WY'), (80, 4, NULL),
    (90, 6, 'WA');

-- Test 2: query (line 29)
SELECT * FROM c WHERE EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id);

-- Test 3: query (line 38)
SELECT * FROM c WHERE NOT EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id);

-- Test 4: query (line 45)
SELECT *
FROM c
WHERE
    EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id)
    OR NOT EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id);

-- Test 5: query (line 60)
SELECT * FROM c WHERE EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id AND c.bill='TX');

-- Test 6: query (line 67)
SELECT * FROM c WHERE 'WY' IN (SELECT ship FROM o WHERE o.c_id=c.c_id);

-- Test 7: query (line 73)
SELECT *
FROM c
WHERE
    'WY' IN (SELECT ship FROM o WHERE o.c_id=c.c_id)
    OR 'WA' IN (SELECT ship FROM o WHERE o.c_id=c.c_id);

-- Test 8: query (line 84)
SELECT *
FROM c
WHERE
    'CA' IN (SELECT ship FROM o WHERE o.c_id=c.c_id)
    AND 'TX' NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id);

-- Test 9: query (line 94)
SELECT * FROM c WHERE bill IN (SELECT ship FROM o WHERE o.c_id=c.c_id);

-- Test 10: query (line 101)
SELECT * FROM c WHERE bill = ALL(SELECT ship FROM o WHERE o.c_id=c.c_id);

-- Test 11: query (line 109)
SELECT * FROM c WHERE bill NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id);

-- Test 12: query (line 117)
SELECT * FROM c WHERE bill NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NOT NULL);

-- Test 13: query (line 126)
SELECT * FROM c WHERE bill NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NULL);

-- Test 14: query (line 135)
SELECT * FROM c WHERE bill < ANY(SELECT ship FROM o WHERE o.c_id=c.c_id);

-- Test 15: query (line 143)
SELECT * FROM c WHERE (bill < ANY(SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NULL;

-- Test 16: query (line 150)
SELECT * FROM c WHERE (bill < ANY(SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NOT NULL;

-- Test 17: query (line 160)
SELECT * FROM c WHERE bill > ANY(SELECT ship FROM o WHERE o.c_id=c.c_id);

-- Test 18: query (line 167)
SELECT * FROM c WHERE (bill > ANY(SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NULL;

-- Test 19: query (line 174)
SELECT * FROM c WHERE (bill > ANY(SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NOT NULL;

-- Test 20: query (line 184)
SELECT * FROM c WHERE bill = ANY(SELECT ship FROM o);

-- Test 21: query (line 192)
SELECT * FROM c WHERE bill = ANY(SELECT ship FROM o) OR bill IS NULL;

-- Test 22: query (line 201)
SELECT * FROM c WHERE (NULL::text IN (SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NOT NULL;

-- Test 23: query (line 208)
SELECT * FROM c WHERE (NULL::text NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NOT NULL;

-- Test 24: query (line 216)
SELECT * FROM c WHERE (replace(bill, 'TX', 'WY') IN (SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NULL;

-- Test 25: query (line 223)
SELECT *
FROM c
WHERE
    bill = ALL(SELECT ship FROM o WHERE o.c_id=c.c_id)
    OR EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id AND ship='WY');

-- Test 26: query (line 237)
SELECT *
FROM c
WHERE
    bill = ALL(SELECT ship FROM o WHERE o.c_id=c.c_id)
    AND EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id);

-- Test 27: query (line 247)
SELECT * FROM c WHERE (SELECT count(*) FROM o WHERE o.c_id=c.c_id) > 1;

-- Test 28: query (line 255)
SELECT * FROM c WHERE (SELECT count(ship) FROM o WHERE o.c_id=c.c_id) > 1;

-- Test 29: query (line 262)
SELECT c.c_id, o.o_id, o.ship
FROM c
INNER JOIN o
ON c.c_id=o.c_id AND o.ship = (SELECT min(o.ship) FROM o WHERE o.c_id=c.c_id);

-- Test 30: query (line 277)
SELECT c.c_id, o.ship, count(*)
FROM c
INNER JOIN o
ON c.c_id=o.c_id
WHERE
    (SELECT count(*) FROM o AS o2 WHERE o2.ship = o.ship AND o2.c_id = o.c_id) >
    (SELECT count(*) FROM o AS o2 WHERE o2.ship = o.ship AND o2.c_id <> o.c_id)
GROUP BY c.c_id, o.ship;

-- Test 31: query (line 293)
SELECT *
FROM c
WHERE
    (SELECT count(*) FROM o WHERE o.c_id=c.c_id) > 1
    AND (SELECT max(ship) FROM o WHERE o.c_id=c.c_id) = 'CA';

-- Test 32: query (line 303)
SELECT *
FROM c
WHERE
    (SELECT count(*) FROM o WHERE o.c_id=c.c_id) > 1
    OR EXISTS(SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NULL);

-- Test 33: query (line 316)
SELECT c_id, bill
FROM c AS c2
WHERE EXISTS
(
    SELECT * FROM c WHERE bill=(SELECT max(ship) FROM o WHERE c_id=c2.c_id AND c_id=c.c_id)
)

-- Test 34: query (line 329)
SELECT c_id, bill
FROM c AS c2
WHERE EXISTS
(
    SELECT *
    FROM (SELECT c_id, coalesce(ship, bill) AS state FROM o WHERE c_id=c2.c_id) AS o
    WHERE state=bill
)

-- Test 35: query (line 344)
SELECT c_id, generate_series(1, (SELECT count(*) FROM o WHERE o.c_id=c.c_id)) FROM c

-- Test 36: query (line 358)
SELECT *
FROM c
WHERE (SELECT ship FROM o WHERE o.c_id=c.c_id ORDER BY ship LIMIT 1) IS NOT NULL

-- Test 37: query (line 367)
SELECT *
FROM c
WHERE
    (SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NOT NULL ORDER BY ship LIMIT 1)='CA'
    OR (SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NOT NULL ORDER BY ship LIMIT 1)='WY'
ORDER BY c_id

-- Test 38: query (line 380)
SELECT *
FROM c
WHERE (SELECT o_id FROM o WHERE o.c_id=c.c_id AND ship='WY')=4;

-- Test 39: query (line 390)
SELECT * FROM c WHERE c_id=(SELECT c_id FROM o WHERE ship='CA' AND c.c_id<>2)

# Find customers other than customer #1 that have at most one order that is
# shipping to 'CA' and a billing state equal to 'TX'. Since there is only one
# other customer who is shipping to 'CA', and this customer has only a single
# order, this attempt is successful.
query IT
SELECT * FROM c WHERE c_id=(SELECT c_id FROM o WHERE ship='CA' AND c_id<>1 AND bill='TX')

-- Test 40: query (line 405)
SELECT * FROM c WHERE c_id=(SELECT c_id FROM o WHERE ship='WA' AND bill='FL')

-- Test 41: query (line 413)
SELECT * FROM c WHERE (SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NOT NULL)='WA'

# Add clause to filter out customers that have more than one order. Find
# remaining customers with at least one order shipping to 'WA'.
query IT
SELECT *
FROM c
WHERE (
  SELECT ship
  FROM o
  WHERE o.c_id=c.c_id AND ship IS NOT NULL AND (SELECT count(*) FROM o WHERE o.c_id=c.c_id)<=1
)='WA'

-- Test 42: query (line 437)
SELECT c_id, EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id) FROM c ORDER BY c_id;

-- Test 43: query (line 448)
SELECT c_id, NOT EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id) FROM c ORDER BY c_id;

-- Test 44: query (line 459)
SELECT
    c_id,
    EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id)
    OR NOT EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id)
FROM c
ORDER BY c_id;

-- Test 45: query (line 475)
SELECT c_id, EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id AND c.bill='TX') FROM c ORDER BY c_id;

-- Test 46: query (line 486)
SELECT c_id, 'WY' IN (SELECT ship FROM o WHERE o.c_id=c.c_id) FROM c ORDER BY c_id;

-- Test 47: query (line 497)
SELECT
    c_id,
    'WY' IN (SELECT ship FROM o WHERE o.c_id=c.c_id)
    OR 'WA' IN (SELECT ship FROM o WHERE o.c_id=c.c_id)
FROM c
ORDER BY c_id;

-- Test 48: query (line 513)
SELECT
    c_id,
    'CA' IN (SELECT ship FROM o WHERE o.c_id=c.c_id)
    AND 'TX' NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id)
FROM c
ORDER BY c_id;

-- Test 49: query (line 529)
SELECT c_id, bill IN (SELECT ship FROM o WHERE o.c_id=c.c_id) FROM c ORDER BY c_id;

-- Test 50: query (line 540)
SELECT c_id, bill = ALL(SELECT ship FROM o WHERE o.c_id=c.c_id) FROM c ORDER BY c_id;

-- Test 51: query (line 551)
SELECT c_id, bill NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id) FROM c ORDER BY c_id;

-- Test 52: query (line 562)
SELECT c_id, bill NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NOT NULL)
FROM c
ORDER BY c_id;

-- Test 53: query (line 575)
SELECT c_id, bill NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NULL)
FROM c
ORDER BY c_id;

-- Test 54: query (line 588)
SELECT c_id, bill < ANY(SELECT ship FROM o WHERE o.c_id=c.c_id) FROM c ORDER BY c_id;

-- Test 55: query (line 599)
SELECT c_id, (bill < ANY(SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NULL FROM c ORDER BY c_id;

-- Test 56: query (line 610)
SELECT c_id, (bill < ANY(SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NOT NULL FROM c ORDER BY c_id;

-- Test 57: query (line 621)
SELECT c_id, bill > ANY(SELECT ship FROM o WHERE o.c_id=c.c_id) FROM c ORDER BY c_id;

-- Test 58: query (line 632)
SELECT c_id, (bill > ANY(SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NULL FROM c ORDER BY c_id;

-- Test 59: query (line 643)
SELECT c_id, (bill > ANY(SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NOT NULL FROM c ORDER BY c_id;

-- Test 60: query (line 654)
SELECT c_id, bill = ANY(SELECT ship FROM o WHERE ship IS NOT NULL) FROM c;

-- Test 61: query (line 665)
SELECT c_id, bill = ANY(SELECT ship FROM o WHERE ship IS NOT NULL) OR bill IS NULL FROM c;

-- Test 62: query (line 676)
SELECT c_id, (NULL::text IN (SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NOT NULL
FROM c
ORDER BY c_id;

-- Test 63: query (line 689)
SELECT c_id, (NULL::text NOT IN (SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NOT NULL
FROM c
ORDER BY c_id;

-- Test 64: query (line 703)
SELECT c_id, (replace(bill, 'TX', 'WY') IN (SELECT ship FROM o WHERE o.c_id=c.c_id)) IS NULL
FROM c
ORDER BY c_id;

-- Test 65: query (line 717)
SELECT
    c_id,
    bill = ALL(SELECT ship FROM o WHERE o.c_id=c.c_id)
    OR EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id AND ship='WY')
FROM c
ORDER BY c_id;

-- Test 66: query (line 734)
SELECT
    c_id,
    bill = ALL(SELECT ship FROM o WHERE o.c_id=c.c_id)
    AND EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id)
FROM c
ORDER BY c_id;

-- Test 67: query (line 750)
SELECT *
FROM c
WHERE (SELECT min(ship) FROM o WHERE o.c_id=c.c_id) IN (SELECT ship FROM o WHERE o.c_id=c.c_id);

-- Test 68: query (line 761)
SELECT
    c_id,
    (SELECT min(ship) FROM o WHERE o.c_id=c.c_id) IN (SELECT ship FROM o WHERE o.c_id=c.c_id)
FROM c
ORDER BY c_id;

-- Test 69: query (line 776)
SELECT max((SELECT count(*) FROM o WHERE o.c_id=c.c_id)) FROM c;

-- Test 70: query (line 782)
SELECT
    c_id,
    (SELECT count(*) FROM o WHERE o.c_id=c.c_id)
FROM c
ORDER BY c_id;

-- Test 71: query (line 797)
SELECT
    s.st,
    (SELECT count(*) FROM c WHERE c.bill=s.st) + (SELECT count(*) FROM o WHERE o.ship=s.st)
FROM (SELECT c.bill AS st FROM c UNION SELECT o.ship AS st FROM o) s
ORDER BY s.st;

-- Test 72: query (line 814)
SELECT c.c_id, o.ship, count(*) AS cust,
    (SELECT count(*) FROM o AS o2 WHERE o2.ship = o.ship AND o2.c_id <> c.c_id) AS other
FROM c
INNER JOIN o
ON c.c_id=o.c_id
GROUP BY c.c_id, o.ship;

-- Test 73: query (line 832)
SELECT
    c.c_id,
    o.o_id,
    (
        SELECT max(CASE WHEN c2.bill > o2.ship THEN c2.bill ELSE o2.ship END)
        FROM c AS c2, o AS o2
        WHERE c2.c_id=o2.c_id AND c2.c_id=c.c_id
    )
FROM c
LEFT JOIN o
ON c.c_id=o.c_id
ORDER BY c.c_id, o.o_id

-- Test 74: query (line 860)
SELECT
    c.c_id,
    (SELECT ship FROM o WHERE o.c_id=c.c_id ORDER BY ship LIMIT 1) IS NOT NULL
FROM c
ORDER BY c.c_id

-- Test 75: query (line 876)
SELECT
    c.c_id,
    (SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NOT NULL ORDER BY ship LIMIT 1)='CA'
    OR (SELECT ship FROM o WHERE o.c_id=c.c_id AND ship IS NOT NULL ORDER BY ship LIMIT 1)='WY'
FROM c
ORDER BY c_id

-- Test 76: query (line 891)
SELECT (SELECT concat_agg(ship || ' ')
  FROM
  (SELECT c_id AS o_c_id, ship FROM o ORDER BY ship)
  WHERE o_c_id=c.c_id)
FROM c ORDER BY c_id

-- Test 77: query (line 905)
SELECT (SELECT string_agg(ship, ', ')
  FROM
  (SELECT c_id AS o_c_id, ship FROM o ORDER BY ship)
  WHERE o_c_id=c.c_id)
FROM c ORDER BY c_id

-- Test 78: query (line 919)
SELECT (SELECT string_agg(DISTINCT ship, ', ')
  FROM
  (SELECT c_id AS o_c_id, ship FROM o ORDER BY ship)
  WHERE o_c_id=c.c_id)
FROM c ORDER BY c_id

-- Test 79: query (line 933)
SELECT
    *
FROM
    (SELECT c_id AS c_c_id, bill FROM c),
    LATERAL (SELECT row_number() OVER () AS rownum FROM o WHERE c_id = c_c_id)
ORDER BY c_c_id, bill, rownum

-- Test 80: query (line 952)
SELECT
    *
FROM
    (SELECT bill FROM c),
    LATERAL (SELECT row_number() OVER (PARTITION BY bill) AS rownum FROM o WHERE ship = bill)
ORDER BY bill, rownum

-- Test 81: query (line 973)
SELECT
    (SELECT count(*) FROM o WHERE o.c_id=c.c_id) AS order_cnt,
    count(*) AS cust_cnt
FROM c
GROUP BY (SELECT count(*) FROM o WHERE o.c_id=c.c_id)
ORDER BY (SELECT count(*) FROM o WHERE o.c_id=c.c_id) DESC;

-- Test 82: query (line 987)
SELECT c_cnt, o_cnt, c_cnt + o_cnt AS total
FROM (VALUES ((SELECT count(*) FROM c), (SELECT count(*) FROM o))) AS v(c_cnt, o_cnt)
WHERE c_cnt > 0 AND o_cnt > 0;

-- Test 83: query (line 995)
SELECT c.c_id, o.o_id
FROM c
INNER JOIN o
ON c.c_id=o.c_id AND EXISTS(SELECT * FROM o WHERE o.c_id=c.c_id AND ship IS NULL);

-- Test 84: query (line 1033)
SELECT
  c_id,
  ARRAY(SELECT o_id FROM o WHERE o.c_id = c.c_id ORDER BY o_id)
FROM c ORDER BY c_id

-- Test 85: statement (line 1048)
CREATE TABLE groups(
  id SERIAL PRIMARY KEY,
  data JSONB
);

-- Test 86: statement (line 1054)
INSERT INTO groups(data) VALUES('{"name": "Group 1", "members": [{"name": "admin", "type": "USER"}, {"name": "user", "type": "USER"}]}');
INSERT INTO groups(data) VALUES('{"name": "Group 2", "members": [{"name": "admin2", "type": "USER"}]}');

-- Test 87: query (line 1058)
SELECT
  g.data->>'name' AS group_name,
  jsonb_array_elements( (SELECT gg.data->'members' FROM groups gg WHERE gg.data->>'name' = g.data->>'name') )
FROM
  groups g
ORDER BY g.data->>'name'

-- Test 88: query (line 1070)
SELECT
    data->>'name',
    members
FROM
    groups AS g,
    jsonb_array_elements(
        (
            SELECT
                gg.data->'members' AS members
            FROM
                groups AS gg
            WHERE
                gg.data->>'name' = g.data->>'name'
        )
    ) AS members
ORDER BY g.data->>'name'

-- Test 89: statement (line 1098)
CREATE TABLE t32786 (id UUID PRIMARY KEY, parent_id UUID, parent_path text)

-- Test 90: statement (line 1101)
INSERT INTO t32786 VALUES ('3AAA2577-DBC3-47E7-9E85-9CC7E19CF48A', null)

-- Test 91: statement (line 1104)
UPDATE t32786 as node
SET parent_path=concat((SELECT parent.parent_path
  FROM t32786 parent
  WHERE parent.id=node.parent_id),
  node.id::varchar, '/')

-- Test 92: statement (line 1111)
INSERT INTO t32786 VALUES ('5AE7EAFD-8277-4F41-83DE-0FD4B4482169', '3AAA2577-DBC3-47E7-9E85-9CC7E19CF48A')

-- Test 93: statement (line 1114)
UPDATE t32786 as node
SET parent_path=concat((SELECT parent.parent_path
  FROM t32786 parent
  WHERE parent.id=node.parent_id),
  node.id::varchar, '/')

-- Test 94: query (line 1121)
SELECT parent_path FROM t32786 ORDER BY id

-- Test 95: query (line 1128)
SELECT
    generate_series(a + 1, a + 1)
FROM
    (SELECT a FROM ((SELECT 1 AS a, 1) EXCEPT ALL (SELECT 0, 0)))

-- Test 96: statement (line 1138)
CREATE TABLE users (
    id INT8 NOT NULL DEFAULT unique_rowid(),
    name VARCHAR(50),
    PRIMARY KEY (id)
);

-- Test 97: statement (line 1145)
INSERT INTO users(id, name) VALUES (1, 'user1');
INSERT INTO users(id, name) VALUES (2, 'user2');
INSERT INTO users(id, name) VALUES (3, 'user3');

-- Test 98: statement (line 1150)
CREATE TABLE stuff (
    id INT8 NOT NULL DEFAULT unique_rowid(),
    date DATE,
    user_id INT8,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users (id)
);

-- Test 99: statement (line 1159)
INSERT INTO stuff(id, date, user_id) VALUES (1, '2007-10-15'::DATE, 1);
INSERT INTO stuff(id, date, user_id) VALUES (2, '2007-12-15'::DATE, 1);
INSERT INTO stuff(id, date, user_id) VALUES (3, '2007-11-15'::DATE, 1);
INSERT INTO stuff(id, date, user_id) VALUES (4, '2008-01-15'::DATE, 2);
INSERT INTO stuff(id, date, user_id) VALUES (5, '2007-06-15'::DATE, 3);
INSERT INTO stuff(id, date, user_id) VALUES (6, '2007-03-15'::DATE, 3);

-- Test 100: query (line 1167)
SELECT
    users.id AS users_id,
    users.name AS users_name,
    stuff_1.id AS stuff_1_id,
    stuff_1.date AS stuff_1_date,
    stuff_1.user_id AS stuff_1_user_id
FROM
    users
    LEFT JOIN stuff AS stuff_1
    ON
        users.id = stuff_1.user_id
        AND stuff_1.id
            = (
                    SELECT
                        stuff_2.id
                    FROM
                        stuff AS stuff_2
                    WHERE
                        stuff_2.user_id = users.id
                    ORDER BY
                        stuff_2.date DESC
                    LIMIT
                        1
                )
ORDER BY
    users.name;

-- Test 101: statement (line 1199)
DROP TABLE stuff;
DROP TABLE users;

-- Test 102: query (line 1204)
SELECT (
		SELECT
			ARRAY (
			  SELECT c.relname
			  FROM pg_inherits AS i JOIN pg_class AS c ON c.oid = i.inhparent
			  WHERE i.inhrelid = rel.oid
			  ORDER BY inhseqno
			)
)
FROM pg_class AS rel
LIMIT 5;

-- Test 103: query (line 1224)
SELECT
    c_id, bill, states
FROM
    c
    JOIN LATERAL (
            SELECT
                COALESCE(array_agg(o.ship), '{}') AS states
            FROM
                o
            WHERE
                o.c_id = c.c_id AND o.ship != c.bill
        ) ON true;

-- Test 104: query (line 1246)
SELECT
    c_id, states
FROM
    c
    LEFT JOIN LATERAL (
            SELECT
                COALESCE(array_agg(o.ship), '{}') AS states
            FROM
                o
            WHERE
                o.c_id = c.c_id AND o.ship != c.bill
        ) ON true
WHERE
    bill IS NOT NULL;

-- Test 105: statement (line 1269)
CREATE TABLE IF NOT EXISTS t_48638 (
  key INTEGER NOT NULL,
  value INTEGER NOT NULL,
  PRIMARY KEY (key, value))

-- Test 106: statement (line 1275)
INSERT INTO t_48638 values (1, 4);
INSERT INTO t_48638 values (4, 3);
INSERT INTO t_48638 values (3, 2);
INSERT INTO t_48638 values (4, 1);
INSERT INTO t_48638 values (1, 2);
INSERT INTO t_48638 values (6, 5);
INSERT INTO t_48638 values (7, 8);

-- Test 107: query (line 1284)
SELECT *
FROM t_48638
WHERE key IN (
  WITH v AS (
    SELECT
      level1.value AS value, level1.key AS level1, level2.key AS level2, level3.key AS level3
    FROM
      t_48638 AS level2
      RIGHT JOIN (SELECT * FROM t_48638 WHERE value = 4) AS level1 ON level1.value = level2.key
      LEFT JOIN (SELECT * FROM t_48638) AS level3 ON level3.key = level2.value
  )
  SELECT v.level1 FROM v WHERE v.level1 IS NOT NULL
  UNION ALL SELECT v.level2 FROM v WHERE v.level2 IS NOT NULL
  UNION ALL SELECT v.level3 FROM v WHERE v.level3 IS NOT NULL
)

-- Test 108: statement (line 1308)
CREATE TABLE t98691 (
  a INT,
  b INT
)

-- Test 109: statement (line 1314)
INSERT INTO t98691 VALUES (1, 10)

-- Test 110: query (line 1317)
SELECT (NULL, NULL) = ANY (
  SELECT a, b FROM t98691 WHERE a > i
) FROM (VALUES (0), (0)) v(i)

-- Test 111: statement (line 1325)
INSERT INTO t98691 VALUES (NULL, NULL)

-- Test 112: query (line 1328)
SELECT (2, 20) = ANY (
  SELECT a, b FROM t98691 WHERE a > i OR a IS NULL
) FROM (VALUES (0), (0)) v(i)

-- Test 113: statement (line 1337)
CREATE TABLE xy108057 (x DECIMAL(10, 2) PRIMARY KEY, y DECIMAL(10, 2));
CREATE TABLE ab108057 (a DECIMAL(10, 0), b DECIMAL(10, 0));

-- Test 114: statement (line 1341)
INSERT INTO xy108057 VALUES (1.00, 1.00);
INSERT INTO ab108057 VALUES (1, 1);

-- Test 115: query (line 1345)
SELECT * FROM xy108057 INNER JOIN LATERAL (SELECT a, a+x FROM ab108057) ON a = x

-- Test 116: query (line 1350)
SELECT * FROM ab108057 INNER JOIN LATERAL (SELECT x, x+a FROM xy108057) ON a = x

