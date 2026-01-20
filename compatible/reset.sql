-- PostgreSQL compatible tests from reset
--
-- The upstream CockroachDB logic-test file references settings that are not
-- applicable to PostgreSQL (unknown GUCs, follower reads). This reduced version
-- exercises common RESET/SHOW behavior for standard PostgreSQL settings.

SET client_min_messages = warning;

SHOW search_path;
SET search_path = public;
SHOW search_path;
RESET search_path;
SHOW search_path;

SHOW TimeZone;
SET TimeZone TO 'Europe/Amsterdam';
SHOW TimeZone;
RESET TimeZone;
SHOW TimeZone;

BEGIN TRANSACTION READ ONLY;
SHOW transaction_read_only;
RESET ALL;
SHOW transaction_read_only;
COMMIT;

RESET client_min_messages;
