-- PostgreSQL compatible tests from generator_probe_ranges
--
-- CockroachDB's `crdb_internal.probe_ranges(...)` is not available in
-- PostgreSQL. This adapted test uses a deterministic table to emulate the
-- "probe" results and exercises the same filter patterns.

SET client_min_messages = warning;
DROP TABLE IF EXISTS generator_probe_ranges_result;
RESET client_min_messages;

CREATE TABLE generator_probe_ranges_result (
  range_id int NOT NULL,
  op text NOT NULL,
  error text NOT NULL,
  verbose_trace text NOT NULL
);

INSERT INTO generator_probe_ranges_result VALUES
  (-1, 'read', '', ''),
  (1, 'read', '', ''),
  (2, 'write', '', '... proposing command ...');

SELECT range_id, op, error, verbose_trace
FROM generator_probe_ranges_result
WHERE range_id < 0
ORDER BY range_id, op;

SELECT count(*) AS error_count
FROM generator_probe_ranges_result
WHERE op = 'read' AND error <> '';

SELECT count(*) AS proposing_count
FROM generator_probe_ranges_result
WHERE op = 'write'
  AND range_id = 2
  AND verbose_trace LIKE '%proposing command%';

DROP TABLE generator_probe_ranges_result;

