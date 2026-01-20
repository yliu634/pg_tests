-- PostgreSQL compatible tests from redact_descriptor
-- 3 tests

-- Test 1: statement (line 34)
CREATE TABLE foo (
    i INT8 DEFAULT 42 ON UPDATE 43 PRIMARY KEY,
    j INT8 AS (44) STORED,
    INDEX (j) WHERE (i = 41),
    FAMILY "primary" (i, j)
);

onlyif config schema-locked-disabled

-- Test 2: query (line 43)
SELECT descriptor FROM redacted_descriptors WHERE id = 'foo'::REGCLASS;

-- Test 3: query (line 179)
SELECT descriptor FROM redacted_descriptors WHERE id = 'foo'::REGCLASS;

