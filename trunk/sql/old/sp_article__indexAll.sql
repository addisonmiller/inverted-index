/*
 * article__indexAll
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */

DROP PROCEDURE IF EXISTS article__indexAll;
DELIMITER ;;

CREATE PROCEDURE `article__indexAll`()

/*
 * This procedure resets and reindexes the dataset by deleting the
 * tables and interating over and reindexing all data. 
 * 
 * Hardly efficient, but it works.
 *
 */

BEGIN

DECLARE _id INT DEFAULT NULL;

DECLARE _continue INT DEFAULT 1;
DECLARE cursor1 CURSOR FOR SELECT article_id FROM article;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET _continue = NULL;


--
-- Flushes all index tables.
--
TRUNCATE TABLE article__index;
TRUNCATE TABLE word;


--
-- Iterates over all entries and calls the index procedure.
--

OPEN cursor1;
loop1: LOOP
        FETCH cursor1 INTO _id;
	IF (_continue is NULL) THEN 
	   LEAVE loop1; 
	END IF;

	CALL article__index(_id);	

END LOOP loop1;
CLOSE cursor1;

END;;

DELIMITER ;
