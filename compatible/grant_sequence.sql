-- PostgreSQL compatible tests from grant_sequence
--
-- CockroachDB logic tests treated sequences like tables and used SHOW GRANTS.
-- PostgreSQL validates sequence privileges via pg_class.relacl (aclexplode).

SET client_min_messages = warning;

DROP SEQUENCE IF EXISTS gseq_a;
DROP SEQUENCE IF EXISTS gseq_b;
DROP ROLE IF EXISTS gseq_readwrite;

CREATE ROLE gseq_readwrite;

CREATE SEQUENCE gseq_a START 1 INCREMENT BY 2;

-- Grant all sequence privileges with grant option.
GRANT ALL ON SEQUENCE gseq_a TO gseq_readwrite WITH GRANT OPTION;

SELECT
  COALESCE(grantee.rolname, 'PUBLIC') AS grantee,
  x.privilege_type,
  CASE x.is_grantable WHEN true THEN 'YES' ELSE 'NO' END AS is_grantable
FROM (
  SELECT (aclexplode(c.relacl)).*
  FROM pg_class c
  WHERE c.relkind = 'S' AND c.relname = 'gseq_a'
) AS x
LEFT JOIN pg_roles grantee ON grantee.oid = x.grantee
WHERE COALESCE(grantee.rolname, 'PUBLIC') IN ('gseq_readwrite')
ORDER BY 1, 2, 3;

-- Using nextval/currval as the grantee (should succeed with ALL privileges).
SET ROLE gseq_readwrite;
SELECT nextval('gseq_a');
SELECT currval('gseq_a');
RESET ROLE;

-- Revoke UPDATE and show the remaining grants.
REVOKE UPDATE ON SEQUENCE gseq_a FROM gseq_readwrite;
SELECT
  COALESCE(grantee.rolname, 'PUBLIC') AS grantee,
  x.privilege_type,
  CASE x.is_grantable WHEN true THEN 'YES' ELSE 'NO' END AS is_grantable
FROM (
  SELECT (aclexplode(c.relacl)).*
  FROM pg_class c
  WHERE c.relkind = 'S' AND c.relname = 'gseq_a'
) AS x
LEFT JOIN pg_roles grantee ON grantee.oid = x.grantee
WHERE COALESCE(grantee.rolname, 'PUBLIC') IN ('gseq_readwrite')
ORDER BY 1, 2, 3;

-- Grant UPDATE back.
GRANT UPDATE ON SEQUENCE gseq_a TO gseq_readwrite;
SELECT
  COALESCE(grantee.rolname, 'PUBLIC') AS grantee,
  x.privilege_type,
  CASE x.is_grantable WHEN true THEN 'YES' ELSE 'NO' END AS is_grantable
FROM (
  SELECT (aclexplode(c.relacl)).*
  FROM pg_class c
  WHERE c.relkind = 'S' AND c.relname = 'gseq_a'
) AS x
LEFT JOIN pg_roles grantee ON grantee.oid = x.grantee
WHERE COALESCE(grantee.rolname, 'PUBLIC') IN ('gseq_readwrite')
ORDER BY 1, 2, 3;

-- Grant on ALL SEQUENCES in schema (existing sequences only).
CREATE SEQUENCE gseq_b START 1;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO gseq_readwrite;
SELECT
  c.relname AS seq_name,
  has_sequence_privilege('gseq_readwrite', c.relname, 'USAGE') AS has_usage
FROM pg_class c
WHERE c.relkind = 'S' AND c.relname IN ('gseq_a', 'gseq_b')
ORDER BY 1;

-- Cleanup.
DROP SEQUENCE gseq_a;
DROP SEQUENCE gseq_b;
DROP OWNED BY gseq_readwrite;
DROP ROLE gseq_readwrite;

RESET client_min_messages;
