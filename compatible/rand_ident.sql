-- PostgreSQL compatible tests from rand_ident
--
-- CockroachDB provides `crdb_internal.gen_rand_ident(...)`. PostgreSQL does not
-- have an equivalent builtin, so we implement a small deterministic helper
-- using md5() for repeatable output.

SET client_min_messages = warning;

CREATE SCHEMA IF NOT EXISTS crdb_internal;

CREATE OR REPLACE FUNCTION crdb_internal.gen_rand_ident(
  prefix TEXT,
  ident_len INT,
  opts JSONB DEFAULT '{}'::jsonb
) RETURNS TEXT
LANGUAGE SQL
AS $$
  SELECT left(prefix || '_' || md5(prefix || ':' || coalesce(opts->>'seed', '0')), ident_len);
$$;

SELECT crdb_internal.gen_rand_ident('hello', 10);
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123}'::jsonb);
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"suffix":false}'::jsonb);
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":true,"emote":-1}'::jsonb);
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false}'::jsonb);
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"punctuate":1}'::jsonb);
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"quote":1}'::jsonb);
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"space":1}'::jsonb);
SELECT quote_ident(crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"whitespace":1}'::jsonb));
SELECT crdb_internal.gen_rand_ident('helloworld', 10, '{"seed":123,"noise":false,"emote":1}'::jsonb);
SELECT crdb_internal.gen_rand_ident('aeaeiao', 10, '{"seed":123,"noise":false,"diacritics":3,"diacritic_depth":4}'::jsonb);
SELECT crdb_internal.gen_rand_ident('aeaeiao', 10, '{"seed":123,"noise":false,"zalgo":true}'::jsonb);

RESET client_min_messages;
