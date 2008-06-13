/*
 * wordID
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */

DROP FUNCTION IF EXISTS wordID;
DELIMITER ;;

CREATE FUNCTION `wordID`(_word VARCHAR(255), _allocateIfNone BOOLEAN) RETURNS int(10) unsigned
    MODIFIES SQL DATA
    DETERMINISTIC

/*
 * Returns the word_id from the word table for a given input string.  The
 * word should be pre-processed.  If no word_id currently exists and
 * _allocateIfNone is TRUE, then it is allocated.
 */

BEGIN

DECLARE _word_id INT UNSIGNED DEFAULT 0;

/* Find the word in the index, if it's there */
SELECT word_id INTO _word_id FROM word WHERE string = _word;

IF FOUND_ROWS()>0 THEN
    /* The word was found, so return the ID */
    RETURN _word_id;
ELSE
    /* The word was not found */
    IF _allocateIfNone THEN
        /* One needs to be allocated, so we need to add it */
        INSERT INTO word (string) VALUES (_word);
        RETURN LAST_INSERT_ID();
    ELSE
        /* No allocation requested */
        RETURN NULL;
    END IF;
END IF;


END;;
DELIMITER ;
