-- PostgreSQL compatible tests from inet
--
-- CockroachDB logic tests used a non-psql format; this file keeps a small set
-- of deterministic inet/cidr sanity checks for PostgreSQL.

SET client_min_messages = warning;

SELECT '192.168.1.2/24'::INET;
SELECT '192.168.1.2/32'::INET;
SELECT '192.168.1.2'::INET;

SELECT '::/0'::INET::text::INET;
SELECT '::ffff:192.168.1.2'::INET;
SELECT '::ffff:192.168.1.2/120'::INET;
SELECT '2001:4f8:3:ba:2e0:81ff:fe22:d1f1/120'::INET;

SELECT family('192.168.1.2/24'::INET) AS ipv4_family,
       family('::1/128'::INET) AS ipv6_family;

SELECT host('192.168.1.2/24'::INET) AS host_v4,
       host('::ffff:192.168.1.2/120'::INET) AS host_v6;

SELECT netmask('192.168.1.2/24'::INET) AS v4_netmask,
       broadcast('192.168.1.2/24'::INET) AS v4_broadcast;

SELECT set_masklen('192.168.1.2/24'::INET, 32) AS v4_set_masklen;

SELECT '::ffff:192.168.0.1/24'::INET = '::ffff:192.168.0.1/24'::INET AS same_addr,
       '::ffff:192.168.0.1/24'::INET = '::ffff:192.168.0.1/25'::INET AS diff_mask;

SELECT text('192.168.0.1/32'::INET);

RESET client_min_messages;
