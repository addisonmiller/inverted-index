/*
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This code is an _example_ implementation of the Inverted Index
 * Technique, coded using MySQL stored procedures and triggers.
 *
 * To run, source the following SQL files, in order.  If you're at the
 * MySQL command prompt, do:
 */

\. sql/tables.sql
\. sql/sp_wordID.sql
\. sql/sp_classID.sql
\. sql/sp_nextWord.sql
\. sql/sp_parseWords.sql
\. sql/sp_sanitizeWord.sql
\. sql/sp_indexString.sql
\. sql/sp_searchBasic.sql
\. sql/sp_searchPhrase.sql

-- -----------------------------------------------------------------------
-- and the sample data, which shows how to set up the correct triggers
-- -----------------------------------------------------------------------

\. tests/setup.sql
\. tests/triggers.sql
\. tests/data.sql

-- -----------------------------------------------------------------------
-- Then try out the searching procedures:
-- -----------------------------------------------------------------------

CALL searchBasic(classID("article._all"), "the air");

CALL searchPhrase(classID("article.body"), "best of times");

-- -----------------------------------------------------------------------
-- or run some of the "manual" SQL queries instead:
-- -----------------------------------------------------------------------

\. tests/query1.sql

\. tests/query2.sql

\. tests/query3.sql

\. tests/query4.sql

-- -----------------------------------------------------------------------
-- After using the searching procedures, you can see what SQL was used to
-- query them:
-- -----------------------------------------------------------------------

SELECT @_sql;


-- -----------------------------------------------------------------------
-- You can also try some of the bigger example files in the 'guten' branch
-- (in SVN).  This is a much larger dataset sourced from Project Gutenberg
-- that takes longer to install, but gives a good test of the search
-- functions.
--
--
-- Notes:
--
-- Column indexing these tables is critical.  It's worth taking a good
-- look at this with real data.  The sample data here will not demonstrate
-- correct indexing.
--
-- Try out a few of the "CREATE INDEX search_index" lines in
-- sql/tables.sql, and see if they improve performance: Do a sample query
-- (using CALL searchBasic(...)), then SELECT @_sql, then DESCRIBE the
-- resulting query to see if the new index was used (by looking in the
-- 'key' column)
--
-- Extra indexes can significantly slow down indexing time, but if they
-- are used, they may massively improve query performance.  The best thing
-- to do is try them out!
--
--
-- This implementation currently processes words in a very simple way: it
-- just trims whitespace from the start and end of the word, and it
-- converts it to lowercase.
--
-- Words are considered to follow the pattern: [[:alnum:]]+, ie. a string
-- of alphanumeric characters.
--
-- Different applications of this code will need different rules.
-- Addresses, in particular, have some specific needs, such as converting
-- ordinals (1st <=> First); adding alternatives (Basement Flat <=> Garden
-- Flat); abbreviations (ave. <=> Avenue).
-- -----------------------------------------------------------------------
