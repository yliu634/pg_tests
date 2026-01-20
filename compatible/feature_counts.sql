-- PostgreSQL compatible tests from feature_counts
--
-- CockroachDB exposes feature usage counts via crdb_internal.feature_usage and
-- toggles auditing via CLUSTER SETTINGS. PostgreSQL does not have these exact
-- features. This file instead checks a few related PostgreSQL settings.

SELECT '1 day'::interval;

-- PostgreSQL connection logging settings (server-side auditing-related).
SELECT name, setting
FROM pg_settings
WHERE name IN ('log_connections', 'log_disconnections')
ORDER BY name;

