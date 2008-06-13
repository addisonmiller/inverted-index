/*
 * Example query 1: Single exact word lookup
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This query will search for a complete word in the "body" field only.
 */

SELECT a.*
FROM article a
     INNER JOIN article__index ai1 ON ai1.article_id = a.article_id
WHERE
     ai1.word_id = wordID(sanitizeWord('good'), FALSE)
AND  ai1.field = 'B'
GROUP BY a.article_id;