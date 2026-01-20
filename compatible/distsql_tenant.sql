-- PostgreSQL compatible tests from distsql_tenant
-- NOTE: CockroachDB tenants are not applicable to PostgreSQL.

SELECT current_user AS user_name, current_database() AS database_name;
