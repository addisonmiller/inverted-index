/*
 * indexString
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */

DROP PROCEDURE IF EXISTS indexString;
DELIMITER ;;

CREATE PROCEDURE `indexString`(_id INT UNSIGNED, _sentence TEXT, _classId INT UNSIGNED)

/*
 * This routine takes a string ("_sentence") and indexes it by word into
 * the search_index table.
 *
 * _id is the primary key of the base table to associate this index with.
 *
 * _classId is the search_class_id that the sentence is to be indexed to.
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
DELETE FROM search_index WHERE id = _id AND search_class_id = _classId;

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
        INSERT INTO search_index (id, search_class_id, word_id, position)
                            VALUES (_id, _classId, _wordId, _wordCount);

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
