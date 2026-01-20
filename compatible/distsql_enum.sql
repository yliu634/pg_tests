-- PostgreSQL compatible tests from distsql_enum
-- NOTE: CockroachDB DistSQL is not applicable to PostgreSQL.
-- This file exercises PostgreSQL ENUM basics.

SET client_min_messages = warning;

DROP TYPE IF EXISTS mood;
CREATE TYPE mood AS ENUM ('sad', 'ok', 'happy');

SELECT unnest(enum_range(NULL::mood)) AS val;

DROP TYPE IF EXISTS mood;

RESET client_min_messages;
