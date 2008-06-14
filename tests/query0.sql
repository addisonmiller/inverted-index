/*
 * Example query 0: Simple AND search using procedure
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This query will search for a set of words
 */

CALL searchBasic("article._all", "the air");
