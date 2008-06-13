/*
 * Example query 3: Phrase searching
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This query will search for a specific phrase.
 */

SELECT a.*
FROM article a
     INNER JOIN article__index ai1 ON ai1.article_id = a.article_id
     INNER JOIN article__index ai2 ON ai2.article_id = a.article_id
     INNER JOIN article__index ai3 ON ai3.article_id = a.article_id
WHERE
     ai1.word_id = wordID(sanitizeWord('bore'), FALSE)

AND  ai2.word_id = wordID(sanitizeWord('golden'), FALSE)
AND  ai2.position = ai1.position + 1
AND  ai2.field = ai1.field

AND  ai3.word_id = wordID(sanitizeWord('apples'), FALSE)
AND  ai3.position = ai2.position + 1
AND  ai3.field = ai2.field

GROUP BY a.article_id;
