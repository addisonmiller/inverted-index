/*
 * Example query 4: Substring'ed words
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This allows searching for the starts of multiple words which allows
 * things like "nine centu" for Nineteenth Century.  It may be less (or
 * more!)  efficient than the simpler query3.sql, which looks up the
 * word_id in advance.  However, MySQL might optimise this out anyway.
 *
 * Note, this avoids the word sanitizer, which is probably not good.
 */

SELECT a.*
FROM article a
     INNER JOIN article__index ai1 ON ai1.article_id = a.article_id
     INNER JOIN word w1 ON w1.word_id = ai1.word_id
     INNER JOIN article__index ai2 ON ai2.article_id = a.article_id
     INNER JOIN word w2 ON w2.word_id = ai2.word_id
WHERE
     w1.string LIKE 'nine%'
AND  w2.string LIKE 'centu%'
AND  ai2.position > ai1.position
AND  ai2.field = ai1.field
GROUP BY a.article_id;