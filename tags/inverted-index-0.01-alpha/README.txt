/*
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This code is an _example_ implementation of the Inverted Index
 * Technique, coded using MySQL stored procedures and triggers.  It's
 * written in terms of an article table "article".
 *
 * To run, source the following SQL files, in order.  If you're at the
 * MySQL command prompt, do:
 */

\. tests/create_tables.sql
\. sql/sp_wordID.sql
\. sql/sp_sanitizeWord.sql
\. sql/sp_article__indexString.sql
\. sql/sp_article__basicSearch.sql
\. sql/sp_article__basicSearchWithWords.sql
\. sql/triggers.sql
\. tests/data.sql

/*
 * then try out the searching procedures:
 */

CALL article__basicSearch("the air");

CALL article__basicSearch("best of times");

/*
 * or run some of the "manual" SQL queries instead:
 */

\. tests/query1.sql

\. tests/query2.sql

\. tests/query3.sql

\. tests/query4.sql

/*
 * After using the searching procedures, you can see what SQL was used to query them:
 */

SELECT @_sql;


/*
 *
 * Notes:
 *
 *  Column indexing these tables is critical.  It's worth taking a good look
 *  at this with real data.  The sample data here will not demonstrate
 *  correct indexing.  Use DESCRIBE/EXPLAIN to view the query plan.
 *
 *  This implementation currently processes words in a very simple way: it
 *  just trims whitespace from the start and end of the word, and it
 *  converts it to lowercase.
 *
 *  Words are considered to follow the pattern: [a-z0-9]+
 *
 *  Different applications of this code will need different rules.
 *  Addresses, in particular, have some specific needs, such as converting
 *  ordinals (1st <=> First); adding alternatives (Basement Flat <=> Garden
 *  Flat); abbreviations (ave. <=> Avenue).
 *
 *  This example provides for a single base table -- article -- but it
 *  could easily be used for multiple tables in two ways:
 *
 *  a) Copy this structure for different tables, eg. foo, foo__index,
 *     foo__indexString, foo__basicSearch, and some triggers
 *
 *  b) Use a single index (and the 'field' column) to index several tables
 *     at once, even with one-to-many relationships.
 *
 *     If data IS combined in this way, it's important to make sure the
 *     index is kept up-to-date: the triggers currently only provide for a
 *     single table, so changes to the other tables will ALSO need to
 *     trigger re-indexing.
 */
