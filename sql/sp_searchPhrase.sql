/*
 * searchPhrase
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 *
 * This constructs and executes a simple "AND" query where the words need
 * to be monotonically sequential, based on an input string of words.
 * Rather than including the words themselves in the query, it looks them
 * up in advance.
 *
 * Parameters:
 *
 * _classId:   the class ID to be searched.  eg. classID('doc')
 *
 * _sentence:  the sentence to be searched.  eg. "best of times"
 *
 * Optional control variables:
 *
 *   SET @_noExecute = TRUE;
 *      -- Returns the query parts, rather than executing it, to assist
 *      -- building of custom queries.
 *
 *   SET @_suppressGlobals = TRUE;
 *      -- Do not set the global variable parts, and preserve @_sql if
 *      -- possible.
 *
 */

DROP PROCEDURE IF EXISTS searchPhrase;
DELIMITER ;;

CREATE PROCEDURE `searchPhrase`(_classId INT UNSIGNED, _sentence TEXT)
thisproc:BEGIN

CALL search(_classId, _sentence, 'phrase', NULL, NULL, NULL);

END;;
DELIMITER ;
