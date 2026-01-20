-- PostgreSQL compatible tests from drop_temp
--
-- PostgreSQL does not have a GRANT DROP privilege; DROP is governed by object
-- ownership. This file tests creating and dropping temporary objects as the
-- creating role.

SET client_min_messages = warning;
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tmp_dropper') THEN
    EXECUTE 'DROP OWNED BY tmp_dropper';
    EXECUTE 'DROP ROLE tmp_dropper';
  END IF;
END
$$;
RESET client_min_messages;

CREATE ROLE tmp_dropper LOGIN;
GRANT TEMPORARY ON DATABASE pg_tests TO tmp_dropper;

SET ROLE tmp_dropper;
CREATE TEMP TABLE t_tmp(x INT);
CREATE TEMP SEQUENCE s_tmp START 1 INCREMENT 1;
SELECT nextval('s_tmp');
DROP TABLE t_tmp;
DROP SEQUENCE s_tmp;
RESET ROLE;

DROP OWNED BY tmp_dropper;
DROP ROLE tmp_dropper;
