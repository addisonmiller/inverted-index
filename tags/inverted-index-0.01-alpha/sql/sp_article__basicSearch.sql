/*
 * article__basicSearch
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This constructs and executes a simple "AND" query, based on an input
 * string of words.  Rather than including the words themselves in the
 * query, it looks them up in advance.
 */

DROP PROCEDURE IF EXISTS article__basicSearch;
DELIMITER ;;

CREATE PROCEDURE `article__basicSearch`(_sentence TEXT)
thisproc:BEGIN

--
-- Data and index source tables.
--
DECLARE _dataTable VARCHAR(255) DEFAULT 'article';
DECLARE _indexTable VARCHAR(255) DEFAULT 'article__index';
DECLARE _idColumn VARCHAR(255) DEFAULT 'article_id';

--
-- Internal Variables
--

-- Table alias name to keep track of the join topology.
DECLARE _firstTable VARCHAR(255) DEFAULT 'a';

DECLARE _word VARCHAR(255) DEFAULT NULL;
DECLARE _wordCount INT UNSIGNED DEFAULT '0';
DECLARE _wordId INT UNSIGNED;

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
SET @_sql = CONCAT('SELECT ',_firstTable,'.* FROM ',_dataTable,' AS ',_firstTable);


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
        -- previous one.  Note, I've never been sure if it's better to
        -- link to the previous table or the first (original) table.  I'm
        -- assuming it gets optimised out, but I'm not too sure.  Plus,
        -- when it comes to using positions, _prevTable is more natural.
        SET @_sql = CONCAT(@_sql, ' INNER JOIN ',_indexTable,' AS i',_i,
                            ' ON ',_firstTable,'.',_idColumn,' = i',_i,'.',_idColumn,
                            ' AND i',_i,'.word_id = ',_wordId);
	SET _i=_i+1;
END LOOP loop_words;


-- Construct query SQL, and execution
SET @_sql = CONCAT(@_sql, ' GROUP BY a.',_idColumn);
PREPARE query FROM @_sql;
EXECUTE query;

-- Clear up
CLOSE cursor_words;
DROP PREPARE query;


END;;
DELIMITER ;
