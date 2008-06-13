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

-- The name of the table containing the data, ie. the table being indexed
DECLARE _dataTable VARCHAR(255) DEFAULT 'article';

-- The name of the table containing the index tuples
DECLARE _indexTable VARCHAR(255) DEFAULT 'article__index';

-- The name of the ID column in both the data and index tables
DECLARE _idColumn VARCHAR(255) DEFAULT 'article_id';


-- -- For internal use only...

-- Table alias name to keep track of the join topology.
DECLARE _firstTable VARCHAR(255) DEFAULT 'a';

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

-- Length of input string, for testing end-of-line.
SET _len = LENGTH(_sentence);

-- Skip _incr to start of first word
REPEAT
    SET _incr = _incr + 1;
    SET _nextChar = SUBSTRING(_sentence, _incr, 1);
UNTIL (_nextChar REGEXP '[a-z0-9]' OR _incr > _len) END REPEAT;

-- Check to see if there IS a first word
IF (_incr < _len) THEN

    -- Start the query with the data table itself.
    SET @_sql = CONCAT('SELECT a.* FROM ',_dataTable,' AS ',_firstTable);

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
        SET @_sql = CONCAT(@_sql, ' INNER JOIN ',_indexTable,' AS i',_wordCount,
                            ' ON ',_firstTable,'.',_idColumn,' = i',_wordCount,'.',_idColumn,
                            ' AND i',_wordCount,'.word_id = ',_wordId);

        -- Update word count
        SET _wordCount = _wordCount + 1;

        -- Slew to find start of next word
        REPEAT
            SET _incr = _incr + 1;
            SET _nextChar = SUBSTRING(_sentence, _incr, 1);
        UNTIL (_nextChar REGEXP '[a-z0-9]' OR _incr > _len) END REPEAT;

    -- Do this until end of sentence
    UNTIL _incr>=_len END REPEAT;

    -- Construct query SQL
    SET @_sql = CONCAT(@_sql, ' GROUP BY a.',_idColumn);

    -- Prepare statement
    PREPARE query FROM @_sql;

    -- Execute query
    EXECUTE query;

    -- Clear up
    DROP PREPARE query;

END IF;

END;;
DELIMITER ;
