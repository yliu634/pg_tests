-- PostgreSQL compatible tests from event_log
--
-- CockroachDB's system.eventlog table does not exist in PostgreSQL. The closest
-- equivalent is PostgreSQL event triggers. This file logs DDL via an event
-- trigger and verifies entries in a custom log table.

SET client_min_messages = warning;
DROP EVENT TRIGGER IF EXISTS event_log_test_capture_ddl;
DROP FUNCTION IF EXISTS event_log_test.capture_ddl();
DROP SCHEMA IF EXISTS event_log_test CASCADE;
RESET client_min_messages;

CREATE SCHEMA event_log_test;

CREATE TABLE event_log_test.eventlog (
  ts timestamptz NOT NULL DEFAULT now(),
  command_tag text NOT NULL,
  schema_name text,
  object_type text,
  object_identity text
);

CREATE FUNCTION event_log_test.capture_ddl() RETURNS event_trigger LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO event_log_test.eventlog (command_tag, schema_name, object_type, object_identity)
  SELECT command_tag, schema_name, object_type, object_identity
  FROM pg_event_trigger_ddl_commands();
END
$$;

CREATE EVENT TRIGGER event_log_test_capture_ddl ON ddl_command_end
  EXECUTE FUNCTION event_log_test.capture_ddl();

-- Run a few DDL statements.
CREATE TABLE event_log_test.a(id INT);
ALTER TABLE event_log_test.a ADD COLUMN v INT;
CREATE INDEX a_v_idx ON event_log_test.a(v);

SELECT command_tag, object_identity
FROM event_log_test.eventlog
WHERE command_tag IN ('CREATE TABLE', 'ALTER TABLE', 'CREATE INDEX')
ORDER BY ts, command_tag, object_identity;

-- Cleanup.
DROP EVENT TRIGGER event_log_test_capture_ddl;
DROP SCHEMA event_log_test CASCADE;

