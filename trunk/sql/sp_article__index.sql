/*
 * article__index
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */

DROP PROCEDURE IF EXISTS article__index;
DELIMITER ;;

CREATE PROCEDURE `article__index`(_id INT UNSIGNED)

/*
 * Indexes the requires columns in an element.
 *
 */

BEGIN
DECLARE _title TEXT;
DECLARE _author TEXT;
DECLARE _body TEXT;

SELECT title, author, body FROM article WHERE article_id=_id INTO _title, _author, _body;

CALL article__indexString(_id, CONCAT_WS(' ', _title, _author, _body), 'C');
CALL article__indexString(_id, _title, 'T');
CALL article__indexString(_id, _author, 'A');
CALL article__indexString(_id, _body, 'B');
END;;

DELIMITER ;