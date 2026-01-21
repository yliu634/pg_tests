-- PostgreSQL compatible tests from ltree
-- 240 tests

SET client_min_messages = warning;

CREATE EXTENSION IF NOT EXISTS ltree;

-- Many ltree cases below are expected to error on invalid input.
\set ON_ERROR_STOP 0

-- Test 1: statement (line 2)
CREATE TABLE l (lt LTREE);

-- Test 2: statement (line 5)
CREATE TABLE la (lta LTREE[]);

-- Test 3: statement (line 8)
INSERT INTO l VALUES ('A'), ('A.B'), ('A.B.C'), ('A.B.D'), ('Z'), (''), (NULL);

-- Test 4: statement (line 11)
INSERT INTO la VALUES
  (ARRAY['A', 'A.B']::LTREE[]),
  (ARRAY['A.B.C', 'A.B.D', 'Z']::LTREE[]),
  (ARRAY['X', 'Y']::LTREE[]),
  (ARRAY[]::LTREE[]),
  (ARRAY['']::LTREE[]),
  (NULL);

-- Test 5: query (line 14)
SELECT * FROM l ORDER BY lt;

-- Test 6: query (line 25)
SELECT * FROM la ORDER BY lta;

-- Test 7: query (line 35)
SELECT pg_typeof(lt) FROM l LIMIT 1;

-- Test 8: query (line 40)
SELECT pg_typeof(lta) FROM la LIMIT 1;

-- Test 9: query (line 45)
INSERT INTO l VALUES (repeat('A', 1001)::LTREE);

-- query error number of ltree labels \(65536\) exceeds the maximum allowed \(65535\)
INSERT INTO l VALUES ((SELECT string_agg('A', '.') FROM generate_series(1, 65536))::LTREE);

-- query T
SELECT * FROM l WHERE lt @> 'A.B'::LTREE ORDER BY lt;

-- Test 10: query (line 58)
SELECT * FROM l WHERE lt <@ 'A.B'::LTREE ORDER BY lt;

-- Test 11: query (line 65)
SELECT * FROM la WHERE lta @> 'A.B'::LTREE ORDER BY lta;

-- Test 12: query (line 71)
SELECT * FROM la WHERE lta <@ 'A.B'::LTREE ORDER BY lta;

-- Test 13: query (line 77)
SELECT lta ?@> 'A.B' FROM la ORDER BY lta;

-- Test 14: query (line 87)
SELECT lta ?<@ 'A.B' FROM la ORDER BY lta;

-- Test 15: query (line 97)
SELECT 'A.B.C'::LTREE = 'A.B.C';

-- Test 16: query (line 102)
SELECT 'A.B.C'::LTREE = 'A.B';

-- Test 17: query (line 107)
SELECT 'A.B'::LTREE || 'C'::LTREE = 'A.B.C';

-- Test 18: query (line 112)
SELECT 'A.B'::LTREE || ''::LTREE = 'A.B';

-- Test 19: query (line 117)
SELECT 'A.B'::LTREE || NULL::LTREE = 'A.B';

-- Test 20: query (line 122)
SELECT 'A.B.C'::LTREE < 'A.B';

-- Test 21: query (line 127)
SELECT 'A.B'::LTREE < 'A.B.C';

-- Test 22: query (line 132)
SELECT ARRAY['A', 'A.B']::LTREE[] = ARRAY['A', 'A.B']::LTREE[];

-- Test 23: query (line 137)
SELECT ARRAY['A', 'A.B']::LTREE[] = ARRAY['A.B', 'A']::LTREE[];

-- Test 24: query (line 142)
SELECT ARRAY['A', 'A.B']::LTREE[] < ARRAY['A', 'A.B.C']::LTREE[];

-- Test 25: query (line 147)
SELECT 'A.B.C'::LTREE > 'A.B';

-- Test 26: query (line 152)
SELECT 'A.B'::LTREE > 'A.B.C';

-- Test 27: query (line 157)
SELECT 'A.B'::LTREE > 'A.B';

-- Test 28: query (line 162)
SELECT 'A.B'::LTREE <= 'A.B.C';

-- Test 29: query (line 167)
SELECT 'A.B.C'::LTREE <= 'A.B';

-- Test 30: query (line 172)
SELECT 'A.B'::LTREE <= 'A.B';

-- Test 31: query (line 177)
SELECT 'A.B.C'::LTREE >= 'A.B';

-- Test 32: query (line 182)
SELECT 'A.B'::LTREE >= 'A.B.C';

-- Test 33: query (line 187)
SELECT 'A.B'::LTREE >= 'A.B';

-- Test 34: query (line 192)
SELECT 'A.B.C'::LTREE != 'A.B';

-- Test 35: query (line 197)
SELECT 'A.B'::LTREE != 'A.B';

-- Test 36: query (line 202)
SELECT 'A.B'::LTREE != NULL::LTREE;

-- Test 37: query (line 207)
SELECT subpath('Top.Child1.Child2'::LTREE, 1);

-- Test 38: query (line 212)
SELECT subpath('Top.Child1.Child2'::LTREE, 3);

-- query T
SELECT subpath('Top.Child1.Child2'::LTREE, -2);

-- Test 39: query (line 220)
SELECT subpath(''::LTREE, 0);

-- query error invalid positions
SELECT subpath(''::LTREE, -1);

-- query error invalid positions
SELECT subpath('Top.Child1.Child2'::LTREE, -4);

-- query T
SELECT subpath('Top.Child1.Child2'::LTREE, 1, 1);

-- Test 40: query (line 234)
SELECT subpath('Top.Child1.Child2'::LTREE, 1, 99);

-- Test 41: query (line 239)
SELECT subpath('Top.Child1.Child2'::LTREE, 0, -1);

-- Test 42: query (line 244)
SELECT subpath('Top.Child1.Child2'::LTREE, 0, -3);

-- Test 43: query (line 249)
SELECT subpath('Top.Child1.Child2'::LTREE, 0, -4);

-- query T
SELECT subpath('Top.Child1.Child2'::LTREE, -3, -2);

-- Test 44: query (line 257)
SELECT subpath('Top.Child1.Child2'::LTREE, -1, -2);

-- query T
SELECT subpath(NULL::LTREE, 99, 99);

-- Test 45: query (line 266)
-- PostgreSQL's subpath() length parameter is INT; use the max INT value to keep this \"very large\" test portable.
SELECT subpath('A.B.C'::LTREE, 1, 2147483647);

-- query T
SELECT subltree('Top.Child1.Child2'::LTREE, 1, 2);

-- Test 46: query (line 274)
SELECT subltree('Top.Child1.Child2'::LTREE, 0, 99);

-- Test 47: query (line 279)
SELECT subltree('Top.Child1.Child2'::LTREE, 3, 2);

-- query error invalid positions
SELECT subltree('Top.Child1.Child2'::LTREE, -1, 2);

-- query error invalid positions
SELECT subltree('Top.Child1.Child2'::LTREE, 0, -1);

-- query T
SELECT subltree(NULL::LTREE, 99, 99);

-- Test 48: query (line 293)
SELECT nlevel('Top.Child1.Child2'::LTREE);

-- Test 49: query (line 298)
SELECT nlevel(''::LTREE);

-- Test 50: query (line 303)
SELECT nlevel(NULL::LTREE);

-- Test 51: query (line 308)
SELECT index('A.B.B.C.B.C'::LTREE, 'A.B.C');

-- Test 52: query (line 313)
SELECT index('A.B.B.C.B.C'::LTREE, 'B.C');

-- Test 53: query (line 318)
SELECT index('A.B.B.C.B.C'::LTREE, 'B.C', 3);

-- Test 54: query (line 323)
SELECT index('A.B.B.C.B.C'::LTREE, 'B.C', -2);

-- Test 55: query (line 328)
SELECT index('A.B.B.C.B.C'::LTREE, 'B.C'::LTREE, -99);

-- Test 56: query (line 333)
SELECT index('A.B.C'::LTREE, NULL::LTREE);

-- Test 57: query (line 338)
SELECT text2ltree('foo_bar-baz.baz');

-- Test 58: query (line 343)
SELECT text2ltree('foo..bar');

-- query TBB
SELECT ltree2text('foo_bar-baz.baz'::LTREE),
    ltree2text('foo'::LTREE) = 'foo'::TEXT,
    ltree2text(NULL::LTREE) IS NULL;

-- Test 59: query (line 353)
SELECT lca('A.B.C'::LTREE, 'A.B.C.D'::LTREE, 'A.B.C.E'::LTREE);

-- Test 60: query (line 358)
SELECT lca('A'::LTREE, 'A'::LTREE, NULL::LTREE);

-- Test 61: query (line 363)
SELECT lca(ARRAY['A.B.C', 'A.B', 'A']::LTREE[]);

-- Test 62: query (line 368)
SELECT lca(ARRAY[]::LTREE[]);

-- Test 63: query (line 373)
SELECT lca(ARRAY['', '']::LTREE[]);

-- Test 64: query (line 378)
SELECT lca(ARRAY['A.B.C', 'A.B', 'A', NULL]::LTREE[]);

-- query T
SELECT lca('A.B'::LTREE, 'C.D'::LTREE);

-- Test 65: query (line 386)
SELECT lca('A'::LTREE, 'A'::LTREE);

-- Test 66: query (line 392)
SELECT lca('A.B'::LTREE, 'A.B'::LTREE);

-- Test 67: query (line 397)
SELECT lca('A.B.C'::LTREE, 'A.B.X'::LTREE);

-- Test 68: query (line 402)
SELECT lca('A.B.C.D.E'::LTREE, 'A.B.X.Y.Z'::LTREE);

-- Test 69: query (line 407)
SELECT lca(''::LTREE, 'A.B.C'::LTREE);

-- Test 70: statement (line 414)
CREATE TABLE t_defaults (
  id INT PRIMARY KEY,
  path LTREE DEFAULT 'default.path',
  path_null LTREE DEFAULT NULL
);

-- Test 71: statement (line 421)
INSERT INTO t_defaults (id) VALUES (1);

-- Test 72: query (line 424)
SELECT * FROM t_defaults;

-- Test 73: statement (line 429)
INSERT INTO t_defaults (id, path) VALUES (2, 'custom.path');

-- Test 74: query (line 432)
SELECT * FROM t_defaults;

-- Test 75: statement (line 438)
DROP TABLE t_defaults;

-- Test 76: statement (line 443)
CREATE TABLE t_invalid_default (
  id INT PRIMARY KEY,
  path LTREE DEFAULT 'invalid..path'
);

-- Test 77: statement (line 451)
CREATE TABLE t_check (
  id INT PRIMARY KEY,
  path LTREE CHECK (path @> 'root.a.b')
);

-- Test 78: statement (line 457)
INSERT INTO t_check VALUES (1, 'root.a.b');

-- Test 79: statement (line 460)
INSERT INTO t_check VALUES (2, 'root');

-- Test 80: query (line 463)
SELECT * FROM t_check;

-- Test 81: statement (line 469)
INSERT INTO t_check VALUES (3, 'other.path');

-- Test 82: statement (line 472)
INSERT INTO t_check VALUES (4, 'roo');

-- Test 83: statement (line 475)
INSERT INTO t_check VALUES (4, 'root.a.b.c');

-- Test 84: statement (line 478)
DROP TABLE t_check;

-- Test 85: statement (line 483)
CREATE TABLE t_check2 (
  id INT PRIMARY KEY,
  path LTREE CHECK (path <@ 'org.company')
);

-- Test 86: statement (line 489)
INSERT INTO t_check2 VALUES (1, 'org.company.dept.team');

-- Test 87: statement (line 492)
INSERT INTO t_check2 VALUES (2, 'org.company');

-- Test 88: statement (line 495)
INSERT INTO t_check2 VALUES (3, 'org');

-- Test 89: statement (line 498)
INSERT INTO t_check2 VALUES (4, 'other.org.company');

-- Test 90: statement (line 501)
DROP TABLE t_check2;

-- Test 91: statement (line 506)
CREATE TABLE t_check3 (
  id INT PRIMARY KEY,
  path LTREE CHECK (nlevel(path) >= 2)
);

-- Test 92: statement (line 512)
INSERT INTO t_check3 VALUES (1, 'a.b');

-- Test 93: statement (line 515)
INSERT INTO t_check3 VALUES (2, 'a.b.c.d.e');

-- Test 94: statement (line 518)
INSERT INTO t_check3 VALUES (3, 'single');

-- Test 95: statement (line 521)
INSERT INTO t_check3 VALUES (4, '');

-- Test 96: statement (line 524)
DROP TABLE t_check3;

-- PostgreSQL: define base table for schema-change tests (missing from extracted source).
CREATE TABLE t_schema (
  id INT PRIMARY KEY,
  name TEXT
);

-- Test 97: statement (line 534)
INSERT INTO t_schema VALUES (1, 'first'), (2, 'second');

-- Test 98: statement (line 537)
ALTER TABLE t_schema ADD COLUMN path LTREE;

-- Test 99: query (line 540)
SELECT * FROM t_schema;

-- Test 100: statement (line 546)
INSERT INTO t_schema VALUES (3, 'third', 'a.b.c');

-- Test 101: query (line 549)
SELECT * FROM t_schema;

-- Test 102: statement (line 558)
ALTER TABLE t_schema ADD COLUMN path2 LTREE DEFAULT 'default.value';

-- Test 103: query (line 561)
SELECT * FROM t_schema;

-- Test 104: statement (line 570)
ALTER TABLE t_schema DROP COLUMN path;

-- Test 105: query (line 573)
SELECT * FROM t_schema;

-- Test 106: statement (line 580)
DROP TABLE t_schema;

-- Test 107: statement (line 585)
CREATE TABLE t_index (id INT PRIMARY KEY, path LTREE);

-- Test 108: statement (line 588)
INSERT INTO t_index VALUES (1, 'a.b'), (2, 'a.b.c'), (3, 'x.y.z');

-- Test 109: statement (line 591)
CREATE INDEX idx_path ON t_index (path);

-- Test 110: query (line 594)
SELECT * FROM t_index WHERE path <@ 'a.b' ORDER BY id;

-- Test 111: statement (line 602)
DROP INDEX idx_path;

-- Test 112: query (line 605)
SELECT * FROM t_index WHERE path <@ 'a.b' ORDER BY id;

-- Test 113: statement (line 611)
DROP TABLE t_index;

-- Test 114: statement (line 618)
CREATE TABLE t_alter_type (id INT PRIMARY KEY, path_text TEXT);

-- skipif config local-legacy-schema-changer

-- Test 115: statement (line 622)
INSERT INTO t_alter_type VALUES (1, 'a.b.c'), (2, 'x.y');

-- skipif config local-legacy-schema-changer

-- Test 116: statement (line 626)
ALTER TABLE t_alter_type ALTER COLUMN path_text TYPE LTREE USING path_text::LTREE;

-- skipif config local-legacy-schema-changer

-- Test 117: query (line 630)
SELECT * FROM t_alter_type;

-- Test 118: query (line 639)
SELECT pg_typeof(path_text) FROM t_alter_type LIMIT 1;

-- Test 119: statement (line 647)
ALTER TABLE t_alter_type ALTER COLUMN path_text TYPE TEXT;

-- skipif config local-legacy-schema-changer

-- Test 120: query (line 651)
SELECT * FROM t_alter_type;

-- Test 121: query (line 658)
SELECT pg_typeof(path_text) FROM t_alter_type LIMIT 1;

-- Test 122: statement (line 664)
DROP TABLE t_alter_type;

-- Test 123: statement (line 670)
CREATE TABLE t_alter_invalid (id INT PRIMARY KEY, path_text TEXT);

-- skipif config local-legacy-schema-changer

-- Test 124: statement (line 674)
INSERT INTO t_alter_invalid VALUES (1, 'valid.path'), (2, 'invalid..path'), (3, 'also.valid');

-- skipif config local-legacy-schema-changer

-- Test 125: statement (line 678)
ALTER TABLE t_alter_invalid ALTER COLUMN path_text TYPE LTREE USING path_text::LTREE;

-- Test 126: query (line 684)
SELECT pg_typeof(path_text) FROM t_alter_invalid LIMIT 1;

-- Test 127: query (line 690)
SELECT * FROM t_alter_invalid;

-- Test 128: statement (line 698)
DROP TABLE t_alter_invalid;

-- PostgreSQL: base table used for view tests (missing from extracted source).
CREATE TABLE t_view_base (
  id INT PRIMARY KEY,
  path LTREE,
  name TEXT
);

-- Test 129: statement (line 706)
INSERT INTO t_view_base VALUES
  (1, 'org.engineering.backend', 'Backend'),
  (2, 'org.engineering.frontend', 'Frontend'),
  (3, 'org.sales', 'Sales'),
  (4, 'org.engineering.backend.api', 'API');

-- Test 130: statement (line 713)
CREATE VIEW v_engineering AS
  SELECT id, path, name
  FROM t_view_base
  WHERE path <@ 'org.engineering';

-- Test 131: query (line 719)
SELECT * FROM v_engineering;

-- Test 132: statement (line 728)
CREATE VIEW v_with_functions AS
  SELECT id, path, name, nlevel(path) as depth, subpath(path, 0, 2) as top_level
  FROM t_view_base;

-- Test 133: query (line 733)
SELECT * FROM v_with_functions;

-- Test 134: statement (line 743)
CREATE VIEW v_top_level AS
  SELECT id, path, name
  FROM t_view_base
  WHERE path <@ 'org' AND nlevel(path) = 2;

-- Test 135: query (line 749)
SELECT * FROM v_top_level;

-- Test 136: statement (line 754)
DROP VIEW v_engineering;

-- Test 137: statement (line 757)
DROP VIEW v_with_functions;

-- Test 138: statement (line 760)
DROP VIEW v_top_level;

-- Test 139: statement (line 763)
DROP TABLE t_view_base;

-- Test 140: statement (line 768)
CREATE TABLE t_computed (
  id INT PRIMARY KEY,
  path LTREE,
  depth INT GENERATED ALWAYS AS (nlevel(path)) STORED,
  parent_path LTREE GENERATED ALWAYS AS (subpath(path, 0, nlevel(path) - 1)) STORED
);

-- Test 141: statement (line 776)
INSERT INTO t_computed (id, path) VALUES
  (1, 'a.b.c'),
  (2, 'x.y'),
  (3, 'p.q.r.s.t');

-- Test 142: query (line 782)
SELECT id, path, depth, parent_path FROM t_computed;

-- Test 143: statement (line 791)
INSERT INTO t_computed (id, path) VALUES (4, 'single');

-- Test 144: query (line 794)
SELECT id, path, depth, parent_path FROM t_computed WHERE id = 4;

-- Test 145: statement (line 801)
UPDATE t_computed SET path = 'a.b.c.d.e' WHERE id = 1;

-- Test 146: query (line 804)
SELECT id, path, depth, parent_path FROM t_computed WHERE id = 1;

-- Test 147: statement (line 809)
DROP TABLE t_computed;

-- Test 148: statement (line 814)
CREATE TABLE t_computed_invalid_stored (
  id INT PRIMARY KEY,
  path TEXT,
  invalid_path LTREE GENERATED ALWAYS AS ((path || '..invalid')::LTREE) STORED
);

-- Test 149: statement (line 821)
INSERT INTO t_computed_invalid_stored (id, path) VALUES (1, 'a.b.c');

-- Test 150: statement (line 824)
DROP TABLE t_computed_invalid_stored;

-- Test 151: statement (line 829)
CREATE TABLE t_computed_invalid_virtual (
  id INT PRIMARY KEY,
  path TEXT,
  -- PostgreSQL does not support VIRTUAL generated columns; model as a STORED generated column instead.
  invalid_path LTREE GENERATED ALWAYS AS ((path || '..invalid')::LTREE) STORED
);

-- Test 152: statement (line 836)
INSERT INTO t_computed_invalid_virtual (id, path) VALUES (1, 'a.b.c');

-- Test 153: statement (line 839)
SELECT invalid_path FROM t_computed_invalid_virtual WHERE id = 1;

-- Test 154: statement (line 842)
DROP TABLE t_computed_invalid_virtual;

-- Test 155: query (line 849)
SELECT NULL::LTREE;

-- Test 156: query (line 854)
SELECT CAST(NULL AS LTREE);

-- Test 157: query (line 861)
SELECT ''::LTREE;

-- Test 158: statement (line 868)
SELECT 'invalid..path'::LTREE;

-- Test 159: statement (line 871)
SELECT 'has spaces'::LTREE;

-- Test 160: statement (line 874)
SELECT 'has@symbol'::LTREE;

-- Test 161: statement (line 877)
SELECT '.starts.with.dot'::LTREE;

-- Test 162: statement (line 880)
SELECT 'ends.with.dot.'::LTREE;

-- Test 163: query (line 885)
SELECT 'a.b.c'::LTREE::TEXT;

-- Test 164: query (line 890)
SELECT ''::LTREE::TEXT;

-- Test 165: query (line 895)
SELECT NULL::LTREE::TEXT;

-- Test 166: query (line 909)
SELECT 'a.b.c'::LTREE::TEXT::LTREE = 'a.b.c'::LTREE;

-- Test 167: query (line 914)
SELECT ''::LTREE::TEXT::LTREE = ''::LTREE;

-- Test 168: query (line 921)
SELECT 'foo.bar'::VARCHAR::LTREE;

-- Test 169: query (line 928)
SELECT ARRAY['a.b', 'x.y.z']::LTREE[]::TEXT[];

-- Test 170: query (line 935)
SELECT ARRAY['a.b', 'x.y.z']::TEXT[]::LTREE[];

-- Test 171: statement (line 942)
SELECT ARRAY['valid', 'invalid..path']::TEXT[]::LTREE[];

-- Test 172: statement (line 949)
CREATE FUNCTION get_depth(path LTREE) RETURNS INT AS $$
  SELECT nlevel(path)
$$ LANGUAGE SQL;

-- Test 173: query (line 954)
SELECT get_depth('a.b.c.d');

-- Test 174: query (line 959)
SELECT get_depth('');

-- Test 175: query (line 964)
SELECT get_depth(NULL);

-- Test 176: statement (line 971)
CREATE FUNCTION make_path(a TEXT, b TEXT) RETURNS LTREE AS $$
  SELECT (a || '.' || b)::LTREE
$$ LANGUAGE SQL;

-- Test 177: query (line 976)
SELECT make_path('org', 'engineering');

-- Test 178: query (line 981)
SELECT make_path('a', 'b');

-- Test 179: statement (line 988)
CREATE FUNCTION is_descendant(child LTREE, parent LTREE) RETURNS BOOL AS $$
  SELECT child <@ parent
$$ LANGUAGE SQL;

-- Test 180: query (line 993)
SELECT is_descendant('a.b.c', 'a.b');

-- Test 181: query (line 998)
SELECT is_descendant('a.b', 'a.b.c');

-- Test 182: query (line 1003)
SELECT is_descendant('x.y', 'a.b');

-- Test 183: statement (line 1010)
CREATE FUNCTION get_parent(path LTREE) RETURNS LTREE AS $$
  SELECT CASE
    WHEN nlevel(path) <= 1 THEN NULL::LTREE
    ELSE subpath(path, 0, nlevel(path) - 1)
  END
$$ LANGUAGE SQL;

-- Test 184: query (line 1018)
SELECT get_parent('a.b.c.d');

-- Test 185: query (line 1023)
SELECT get_parent('single');

-- Test 186: query (line 1028)
SELECT get_parent('');

-- Test 187: statement (line 1035)
CREATE FUNCTION count_ancestors(path LTREE) RETURNS INT AS $$
DECLARE
  count INT := 0;
  current_path LTREE := path;
BEGIN
  WHILE nlevel(current_path) > 0 LOOP
    count := count + 1;
    current_path := subpath(current_path, 0, nlevel(current_path) - 1);
  END LOOP;
  RETURN count;
END;
$$ LANGUAGE PLpgSQL;

-- Test 188: query (line 1049)
SELECT count_ancestors('a.b.c.d');

-- Test 189: query (line 1054)
SELECT count_ancestors('x');

-- Test 190: query (line 1059)
SELECT count_ancestors('');

-- Test 191: statement (line 1066)
CREATE FUNCTION build_path(labels TEXT[]) RETURNS LTREE AS $$
DECLARE
  result TEXT := '';
BEGIN
  FOR i IN 1..array_length(labels, 1) LOOP
    IF result = '' THEN
      result = labels[i];
    ELSE
      result = result || '.' || labels[i];
    END IF;
  END LOOP;
  RETURN result::LTREE;
END;
$$ LANGUAGE PLpgSQL;

-- Test 192: query (line 1082)
SELECT build_path(ARRAY['a', 'b', 'c']);

-- Test 193: query (line 1087)
SELECT build_path(ARRAY['single']);

-- Test 194: statement (line 1094)
DROP FUNCTION get_depth;

-- Test 195: statement (line 1097)
DROP FUNCTION make_path;

-- Test 196: statement (line 1100)
DROP FUNCTION is_descendant;

-- Test 197: statement (line 1103)
DROP FUNCTION get_parent;

-- Test 198: statement (line 1106)
DROP FUNCTION count_ancestors;

-- Test 199: statement (line 1109)
DROP FUNCTION build_path;

-- Test 200: statement (line 1114)
CREATE TABLE t_sort (id INT PRIMARY KEY, path LTREE);

-- Test 201: statement (line 1117)
INSERT INTO t_sort VALUES
  (1, 'org.zoo'),
  (2, 'org.apple.beta'),
  (3, 'org.apple'),
  (4, 'org'),
  (5, 'prod'),
  (6, 'org.apple.beta.v1'),
  (7, ''),
  (8, 'org.application'),
  (9, NULL),
  (10, 'org.apple.alpha');

-- Test 202: query (line 1132)
SELECT * FROM t_sort ORDER BY path ASC;

-- Test 203: query (line 1148)
SELECT * FROM t_sort ORDER BY path DESC;

-- Test 204: statement (line 1164)
CREATE INDEX idx_sort_path ON t_sort (path);

-- Test 205: query (line 1169)
SELECT * FROM t_sort ORDER BY path ASC;

-- Test 206: query (line 1185)
SELECT * FROM t_sort ORDER BY path DESC;

-- Test 207: statement (line 1199)
DROP TABLE t_sort;

-- PostgreSQL: base table for multi-column index tests (missing from extracted source).
CREATE TABLE t_multi_idx (
  id INT PRIMARY KEY,
  path LTREE,
  status TEXT
);

-- Test 208: statement (line 1209)
INSERT INTO t_multi_idx VALUES
  (1, 'org.sales', 'active'),
  (2, 'org.engineering', 'active'),
  (3, 'org.sales', 'inactive'),
  (4, 'org.engineering.backend', 'active'),
  (5, 'org.engineering.frontend', 'inactive');

-- Test 209: statement (line 1217)
CREATE INDEX idx_path_status ON t_multi_idx (path, status);

-- Test 210: query (line 1220)
SELECT * FROM t_multi_idx WHERE path = 'org.sales' ORDER BY status;

-- Test 211: query (line 1226)
SELECT * FROM t_multi_idx WHERE path <@ 'org.engineering' AND status = 'active' ORDER BY path;

-- Test 212: statement (line 1234)
CREATE INDEX idx_status_path ON t_multi_idx (status, path);

-- Test 213: query (line 1237)
SELECT * FROM t_multi_idx WHERE status = 'active' ORDER BY path;

-- Test 214: query (line 1244)
SELECT * FROM t_multi_idx WHERE status = 'inactive' AND path <@ 'org' ORDER BY path;

-- Test 215: statement (line 1252)
DROP TABLE t_multi_idx;

-- PostgreSQL: base table for category/path index tests (missing from extracted source).
CREATE TABLE t_multi_idx2 (
  id INT PRIMARY KEY,
  category INT,
  path LTREE,
  label TEXT
);

-- Test 216: statement (line 1258)
INSERT INTO t_multi_idx2 VALUES
  (1, 1, 'a.b', 'first'),
  (2, 1, 'a.b.c', 'second'),
  (3, 2, 'a.b', 'third'),
  (4, 2, 'x.y', 'fourth');

-- Test 217: statement (line 1265)
CREATE INDEX idx_cat_path ON t_multi_idx2 (category, path);

-- Test 218: query (line 1268)
SELECT * FROM t_multi_idx2 WHERE category = 1 ORDER BY path;

-- Test 219: query (line 1274)
SELECT * FROM t_multi_idx2 WHERE category = 2 AND path <@ 'a' ORDER BY id;

-- Test 220: statement (line 1279)
DROP TABLE t_multi_idx2;

-- Test 221: statement (line 1286)
CREATE TABLE t_boundary (path LTREE);

-- Test 222: statement (line 1289)
INSERT INTO t_boundary VALUES ((repeat('a', 1000))::LTREE);

-- Test 223: query (line 1292)
SELECT nlevel(path) FROM t_boundary;

-- Test 224: statement (line 1299)
INSERT INTO t_boundary VALUES ((repeat('b', 1001))::LTREE);

-- Test 225: statement (line 1304)
INSERT INTO t_boundary VALUES ((SELECT string_agg('x', '.') FROM generate_series(1, 1000))::LTREE);

-- Test 226: query (line 1307)
SELECT nlevel(path) FROM t_boundary WHERE nlevel(path) = 1000;

-- Test 227: statement (line 1314)
INSERT INTO t_boundary VALUES ((SELECT string_agg('a', '.') FROM generate_series(1, 65536))::LTREE);

-- Test 228: statement (line 1319)
SELECT 'test.label with space'::LTREE;

-- Test 229: statement (line 1322)
SELECT 'test.label@domain'::LTREE;

-- Test 230: statement (line 1325)
SELECT 'path.to.item#1'::LTREE;

-- Test 231: statement (line 1328)
SELECT 'folder/subfolder'::LTREE;

-- Test 232: statement (line 1331)
SELECT 'test.label$var'::LTREE;

-- Test 233: statement (line 1334)
SELECT 'test..double.dot'::LTREE;

-- Test 234: statement (line 1337)
SELECT '.leading.dot'::LTREE;

-- Test 235: statement (line 1340)
SELECT 'trailing.dot.'::LTREE;

-- Test 236: statement (line 1345)
INSERT INTO t_boundary VALUES
  ('valid_underscore'::LTREE),
  ('valid-hyphen'::LTREE),
  ('MixedCase123'::LTREE),
  ('a1-b2_c3'::LTREE);

-- Test 237: query (line 1352)
SELECT count(*) FROM t_boundary WHERE nlevel(path) = 1;

-- Test 238: statement (line 1357)
DROP TABLE t_boundary;

-- Test 239: statement (line 1362)
CREATE TABLE t156478 (
  k INT PRIMARY KEY,
  l LTREE
);

CREATE INDEX idx ON t156478 (l);
CREATE INDEX idx_desc ON t156478 (l DESC);

-- Test 240: statement (line 1370)
INSERT INTO t156478 VALUES (1, 'foo.bar_'::LTREE);
