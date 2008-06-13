/*
 * Example query 2: Exact-AND
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This query will search for complete words in any order.
 */

SELECT a.*
FROM article a
     INNER JOIN article__index ai1 ON ai1.article_id = a.article_id
     INNER JOIN article__index ai2 ON ai2.article_id = a.article_id
WHERE
     ai1.word_id = wordID(sanitizeWord('good'), FALSE)
AND  ai2.word_id = wordID(sanitizeWord('evil'), FALSE)
GROUP BY a.article_id;