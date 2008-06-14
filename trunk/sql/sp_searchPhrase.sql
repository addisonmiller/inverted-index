/*
 * searchPhrase
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This constructs and executes a simple "AND" query where the words need
 * to be monotonically sequential, based on an input string of words.
 * Rather than including the words themselves in the query, it looks them
 * up in advance.
 */

DROP PROCEDURE IF EXISTS searchPhrase;
DELIMITER ;;

CREATE PROCEDURE `searchPhrase`(_classId INT UNSIGNED, _sentence TEXT)
thisproc:BEGIN

--
-- Internal Variables
--

DECLARE _word VARCHAR(255) DEFAULT NULL;
DECLARE _wordCount INT UNSIGNED DEFAULT '0';
DECLARE _wordId INT UNSIGNED;

DECLARE _wheres TEXT DEFAULT '';

-- Iterator counter for word loop
DECLARE _i INT DEFAULT 0;

-- Defining cursor for iterating over parsed input words
DECLARE _continue_loop_words INT DEFAULT 1;
DECLARE cursor_words CURSOR FOR SELECT word FROM parseWords_result;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET _continue_loop_words = NULL;

-- Call proc to parse input words into temp table.
CALL parseWords(_sentence);
SELECT count(*) FROM parseWords_result INTO _wordCount;

-- Leave procedure if there are no parsed results.
IF !(_wordCount > 0) THEN
   LEAVE thisproc;
END IF;

-- Start the query with the data table itself.
SET @_sql = CONCAT('SELECT i0.id, i0.position FROM ');

OPEN cursor_words;
loop_words: LOOP
    -- Cursor control (the table contains word positions, but its
    -- not fetched)
    FETCH cursor_words INTO _word;
    IF (_continue_loop_words is NULL) THEN
       LEAVE loop_words;
    END IF;


    -- Get the ID for this word
    SET _wordId = wordID(_word, FALSE);

    -- If no word was found, this whole thing's a waste of time
    -- anyway, as no rows will be returned.
    IF (_wordId IS NULL) THEN
        LEAVE thisproc;
    END IF;

    -- Assemble an inner join from one copy of the index table to the
    -- previous one.
    IF (_i>0) THEN
        SET @_sql = CONCAT(@_sql, ' INNER JOIN search_index AS i',_i,
                            ' ON i',(_i-1),'.id = i',_i,'.id ');
        SET _wheres = CONCAT(_wheres,
                            ' AND i',_i,'.search_class_id = ',_classId,
                            ' AND i',_i,'.word_id = ',_wordId,
                            ' AND i',_i,'.position = i',(_i-1),'.position+1');
    ELSE
        SET @_sql = CONCAT(@_sql, ' search_index AS i0 ');
        SET _wheres = CONCAT(' i0.word_id = ',_wordId,
                             ' AND i0.search_class_id = ',_classId);
    END IF;

    SET _i=_i+1;
END LOOP loop_words;


-- Construct query SQL, and execution
SET @_sql = CONCAT(@_sql, ' WHERE ', _wheres, ' GROUP BY i0.id');
PREPARE query FROM @_sql;
EXECUTE query;

-- Clear up
CLOSE cursor_words;
DROP PREPARE query;


END;;
DELIMITER ;
