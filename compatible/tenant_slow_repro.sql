-- PostgreSQL compatible tests from tenant_slow_repro
-- 1 tests

-- Test 1: statement (line 3)
CREATE TABLE parent_multi (pa INT, pb INT, pc INT, UNIQUE (pa,pb,pc));
CREATE TABLE child_multi_1 (
  c INT,
  a INT,
  b INT,
  FOREIGN KEY (a,b,c) REFERENCES parent_multi(pa,pb,pc) ON DELETE CASCADE
);
CREATE TABLE child_multi_2 (
  b INT,
  c INT,
  a INT,
  FOREIGN KEY (a,b,c) REFERENCES parent_multi(pa,pb,pc) ON DELETE CASCADE
);
