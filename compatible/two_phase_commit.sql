-- PostgreSQL compatible tests from two_phase_commit
-- Reduced subset: PREPARE TRANSACTION requires server setting
-- max_prepared_transactions > 0. This environment keeps it at the default (0),
-- so we only validate read-only inspection queries.

SHOW max_prepared_transactions;

SELECT gid, owner, database
FROM pg_catalog.pg_prepared_xacts
ORDER BY gid;
