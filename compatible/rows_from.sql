-- PostgreSQL compatible tests from rows_from
--
-- The upstream CockroachDB logic-test file includes non-PostgreSQL uses of
-- ROWS FROM (e.g. `current_user` as a function). This reduced version keeps
-- simple PostgreSQL ROWS FROM usage with generate_series().

SET client_min_messages = warning;

SELECT * FROM ROWS FROM (generate_series(1,2), generate_series(4,8));
SELECT * FROM ROWS FROM (generate_series(1,4), generate_series(4,5));
SELECT * FROM ROWS FROM (generate_series(1,0), generate_series(1,0));
SELECT * FROM ROWS FROM (generate_series(1,0), generate_series(1,1));

RESET client_min_messages;
