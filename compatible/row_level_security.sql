-- PostgreSQL compatible tests from row_level_security
--
-- The upstream CockroachDB logic-test file is large and depends on Cockroach
-- system tables and database-switching directives. This reduced version
-- exercises PostgreSQL Row Level Security (RLS) with a simple policy.

SET client_min_messages = warning;

DROP TABLE IF EXISTS rls_t;
DROP ROLE IF EXISTS rls_alice;
DROP ROLE IF EXISTS rls_bob;

CREATE ROLE rls_alice;
CREATE ROLE rls_bob;

CREATE TABLE rls_t (
  owner  TEXT NOT NULL,
  secret TEXT NOT NULL
);

INSERT INTO rls_t(owner, secret) VALUES
  ('rls_alice', 'alice_secret'),
  ('rls_bob', 'bob_secret');

ALTER TABLE rls_t ENABLE ROW LEVEL SECURITY;

CREATE POLICY rls_owner_only ON rls_t
  FOR SELECT
  USING (owner = current_user);

GRANT SELECT ON rls_t TO rls_alice;
GRANT SELECT ON rls_t TO rls_bob;

SET ROLE rls_alice;
SELECT * FROM rls_t ORDER BY owner;
RESET ROLE;

SET ROLE rls_bob;
SELECT * FROM rls_t ORDER BY owner;
RESET ROLE;

DROP TABLE rls_t;
DROP ROLE rls_alice;
DROP ROLE rls_bob;

RESET client_min_messages;
