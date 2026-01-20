-- PostgreSQL compatible tests from tenant
-- Reduced subset: CockroachDB tenants/virtual clusters and SYSTEM privileges are
-- not available in PostgreSQL; validate basic settings and DDL instead.

SET client_min_messages = warning;
DROP TABLE IF EXISTS foo_tbl CASCADE;
DROP SCHEMA IF EXISTS foo_schema CASCADE;
DROP VIEW IF EXISTS foo_view;
DROP ROLE IF EXISTS tenant_testuser;
RESET client_min_messages;

CREATE ROLE tenant_testuser;

SET default_transaction_read_only = on;
SHOW default_transaction_read_only;
SET default_transaction_read_only = off;
SHOW default_transaction_read_only;

-- CockroachDB CLUSTER SETTING equivalents: store as custom GUCs.
SET server.controller.default_target_cluster = 'noservice';
SHOW server.controller.default_target_cluster;
SET server.controller.default_target_cluster = 'withservice';
SHOW server.controller.default_target_cluster;
RESET server.controller.default_target_cluster;

SET sql.restrict_system_interface.enabled = true;
SHOW sql.restrict_system_interface.enabled;
RESET sql.restrict_system_interface.enabled;

CREATE TABLE foo_tbl(x INT);
CREATE SCHEMA foo_schema;
CREATE VIEW foo_view AS SELECT x FROM foo_tbl;
