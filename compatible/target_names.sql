-- PostgreSQL compatible tests from target_names
-- Reduced subset: replace CockroachDB-only builtins (iferror/iserror/if) and
-- enforce deterministic output.

SET client_min_messages = warning;
DROP TABLE IF EXISTS t CASCADE;
RESET client_min_messages;

CREATE TABLE t (a INT[], t TEXT);
INSERT INTO t VALUES (ARRAY[1,2,3], '123');

SELECT *, a, a[1], (((((((((a))))))))), t COLLATE "C" FROM t;

SELECT
  array_length(a, 1),
  nullif(a, a),
  row(1,2,3),
  coalesce(a,a),
  (CASE WHEN true THEN a ELSE NULL END) AS if_true,
  current_user
FROM t;

SELECT 123, '123', 123.0, TRUE, FALSE, NULL;

-- pg_get_keywords() is a set-returning function.
SELECT word FROM pg_get_keywords() ORDER BY word LIMIT 5;

SELECT ARRAY[1,2,3], ARRAY(SELECT 1);

SELECT EXISTS(SELECT 1 FROM t);

SELECT
  CASE 1 WHEN 2 THEN 3 END,
  CASE 1 WHEN 2 THEN 3 ELSE a[1] END,
  CASE 1 WHEN 2 THEN 3 ELSE length(t) END,
  CASE 1 WHEN 2 THEN 3 ELSE t::INT END,
  CASE 1 WHEN 2 THEN 3 ELSE 4 END
FROM t;

SELECT (SELECT 123 AS a),
       (VALUES (cos(1)::INT)),
       (SELECT cos(0)::INT);
