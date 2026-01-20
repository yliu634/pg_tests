-- PostgreSQL compatible tests from custom_escape_character
-- NOTE: PostgreSQL requires the ESCAPE clause to be a single character (not an empty string).
-- This file is rewritten to cover representative LIKE / SIMILAR TO escape behavior.

SELECT 'A' LIKE E'\\A' ESCAPE E'\\' AS like_escape_backslash;
SELECT '%A' LIKE '!%A' ESCAPE '!' AS like_escape_percent;
SELECT '123A_' SIMILAR TO '%A!_' ESCAPE '!' AS similar_escape_underscore;
SELECT '春A' LIKE '春春_' ESCAPE '春' AS unicode_escape_like;
SELECT '春A_春春' SIMILAR TO '%春_春%春' ESCAPE '春' AS unicode_escape_similar;
