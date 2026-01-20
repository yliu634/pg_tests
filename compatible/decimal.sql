-- PostgreSQL compatible tests from decimal
-- NOTE: CockroachDB DECIMAL tests may rely on CRDB-specific casting/printing rules.
-- This file is rewritten to cover core PostgreSQL numeric/decimal behavior.

SET client_min_messages = warning;

SELECT 1::numeric / 3 AS one_third;
SELECT round(1.2345::numeric, 2) AS round_2;
SELECT (12345678901234567890::numeric + 1) AS big_add;
SELECT (10::numeric ^ 10) AS pow_10_10;
SELECT to_char(12345.6789::numeric, 'FM9999990.0000') AS formatted;

RESET client_min_messages;
