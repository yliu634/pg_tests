-- PostgreSQL compatible tests from format
-- 27 tests

SELECT format(NULL);
SELECT format('Hello');
SELECT format('Hello %s', 'World');
SELECT format('Hello %%');
SELECT format('Hello %%%%');
SELECT format('%s%s%s', 'Hello', NULL, 'World');
SELECT format('INSERT INTO %I VALUES(%L,%L)', 'mytab', 10, NULL);
SELECT format('INSERT INTO %I VALUES(%L,%L)', 'mytab', NULL, 'Hello');
SELECT format('INSERT INTO %I VALUES(%L,%L)', 'mytab', 10, 'Hello');

-- Positional args ($) are supported by PostgreSQL's format().
SELECT format('%1$s %3$s', 1, 2, 3);
SELECT format('%1$s %12$s', 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12);
SELECT format('Hello %s %s, %2$s %2$s', 'World', 'Hello again');

SELECT format('>>%10s<<', 'Hello');
SELECT format('>>%10s<<', NULL);
SELECT format('>>%10s<<', '');
SELECT format('>>%-10s<<', '');
SELECT format('>>%-10s<<', 'Hello');
SELECT format('>>%-10s<<', NULL);
SELECT format('>>%1$10s<<', 'Hello');
SELECT format('>>%1$-10I<<', 'Hello');

-- Postgres supports '*' width arguments, but not the CRDB-style positional '*' form.
SELECT format('>>%*L<<', 10, 'Hello');
SELECT format('>>%*L<<', 10, NULL);
SELECT format('>>%*s<<', 10, 'Hello');
SELECT format('>>%*s<<', 10, 'Hello');

SELECT format('>>%-s<<', 'Hello');
SELECT format('>>%10L<<', NULL);
SELECT format('>>%*L<<', NULL::int, 'Hello');
SELECT format('>>%*L<<', 0, 'Hello');

