-- PostgreSQL compatible tests from event_log_legacy
--
-- CockroachDB's legacy event log relies on system tables that do not exist in
-- PostgreSQL. We approximate the intent using an event trigger that records
-- DDL statements into a table.

SET client_min_messages = warning;
DROP EVENT TRIGGER IF EXISTS event_log_legacy_test_capture_ddl;
DROP FUNCTION IF EXISTS event_log_legacy_test.capture_ddl();
DROP SCHEMA IF EXISTS event_log_legacy_test CASCADE;
RESET client_min_messages;

CREATE SCHEMA event_log_legacy_test;

CREATE TABLE event_log_legacy_test.eventlog (
  ts timestamptz NOT NULL DEFAULT now(),
  command_tag text NOT NULL,
  object_identity text
);

CREATE FUNCTION event_log_legacy_test.capture_ddl() RETURNS event_trigger LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO event_log_legacy_test.eventlog (command_tag, object_identity)
  SELECT command_tag, object_identity
  FROM pg_event_trigger_ddl_commands();
END
$$;

CREATE EVENT TRIGGER event_log_legacy_test_capture_ddl ON ddl_command_end
  EXECUTE FUNCTION event_log_legacy_test.capture_ddl();

-- DDL that should be logged.
CREATE TABLE event_log_legacy_test.t(id INT);
ALTER TABLE event_log_legacy_test.t ADD COLUMN v INT;

SELECT command_tag, object_identity
FROM event_log_legacy_test.eventlog
WHERE command_tag IN ('CREATE TABLE', 'ALTER TABLE')
ORDER BY ts, command_tag, object_identity;

-- Cleanup.
DROP EVENT TRIGGER event_log_legacy_test_capture_ddl;
DROP SCHEMA event_log_legacy_test CASCADE;

