-- PostgreSQL compatible tests from show_transfer_state
-- 2 tests

-- NOTE: CockroachDB `SHOW TRANSFER STATE` has no PostgreSQL equivalent.
-- Provide a stable, empty stub so the surrounding harness can generate output.
CREATE OR REPLACE FUNCTION public.pg_show_transfer_state(arg TEXT DEFAULT NULL)
RETURNS TABLE (range_id INT, info TEXT)
LANGUAGE sql
AS $$
  SELECT NULL::INT AS range_id, NULL::TEXT AS info WHERE false;
$$;

-- Test 1: query (line 4)
SELECT * FROM public.pg_show_transfer_state();

-- Test 2: query (line 10)
SELECT * FROM public.pg_show_transfer_state('foo-bar');
