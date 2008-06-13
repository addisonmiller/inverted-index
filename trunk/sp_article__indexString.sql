/*
 * article__indexString
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */

DROP PROCEDURE IF EXISTS article__indexString;
DELIMITER ;;

CREATE PROCEDURE `article__indexString`(_id INT UNSIGNED, _sentence TEXT, _field CHAR)

/*
 * This routine takes a string ("_sentence") and indexes it by word into
 * the article__index table.
 *
 * _id is the primary key of the base table to associate this index with.
 *
 * _field is an indicator of the "class".  This is to allow multiple
 * indices for the given table.  For example, _field could be "T" to
 * indicate that the occurrence is in the title of the record.  A given
 * string might appear in more than one class to allow union sets.
 */

BEGIN


-- -- Internal variables

-- Current word count
DECLARE _wordCount INT UNSIGNED DEFAULT '0';

-- Found word
DECLARE _word VARCHAR(255);

-- ID for found word
DECLARE _wordId INT UNSIGNED;

-- Character-counting gubbins.
DECLARE _base INT UNSIGNED DEFAULT '0';
DECLARE _incr INT UNSIGNED DEFAULT '0';
DECLARE _len INT UNSIGNED;
DECLARE _nextChar CHAR(1);


-- First, start off with a clean slate for this article.  Far easier
-- than trying to update the index for a changed row
DELETE FROM article__index WHERE article_id = _id AND field = _field;

-- Length of input string, for testing end-of-line.
SET _len = LENGTH(_sentence);

-- Skip _incr to start of first word
REPEAT
    SET _incr = _incr + 1;
    SET _nextChar = SUBSTRING(_sentence, _incr, 1);
UNTIL (_nextChar REGEXP '[a-z0-9]' OR _incr > _len) END REPEAT;

-- Check to see if there IS a first word
IF (_incr < _len) THEN

    -- Okay.  For each word...
    REPEAT
        -- Start where the first word ended
        SET _base = _incr;

        -- Rewind one to allow for the first _incr+=1
        SET _incr = _base-1;

        -- Slew through word looking for first non-word character
        REPEAT
            SET _incr = _incr + 1;
            SET _nextChar = SUBSTRING(_sentence, _incr, 1);
        UNTIL (_nextChar NOT REGEXP '[a-z0-9]' OR _incr > _len) END REPEAT;

        -- Grab this word
        SET _word = SUBSTRING(_sentence, _base, _incr-_base);

        -- Get word ID for this word, allocating a new one if necessary
        SET _wordId = wordID(sanitizeWord(_word), TRUE);

        -- Insert index row for this word.
        INSERT INTO article__index (article_id, field, word_id, position)
                            VALUES (_id, _field, _wordId, _wordCount);

        -- Update word count
        SET _wordCount = _wordCount + 1;

        -- Slew to find start of next word
        REPEAT
            SET _incr = _incr + 1;
            SET _nextChar = SUBSTRING(_sentence, _incr, 1);
        UNTIL (_nextChar REGEXP '[a-z0-9]' OR _incr > _len) END REPEAT;

    -- Do this until end of sentence
    UNTIL _incr>=_len END REPEAT;
END IF;

END;;
DELIMITER ;
