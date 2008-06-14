/*
 * classID
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */

DROP FUNCTION IF EXISTS classID;
DELIMITER ;;

CREATE FUNCTION `classID`(_className VARCHAR(255)) RETURNS INT UNSIGNED
    MODIFIES SQL DATA
    DETERMINISTIC

/*
 * Returns the search_class_id from the search_class table for a given
 * class name.  It does NOT allocate a new class if missing.
 */

BEGIN

DECLARE _classId INT UNSIGNED DEFAULT 0;

SELECT search_class_id INTO _classId FROM search_class WHERE name = _className;

IF FOUND_ROWS()>0 THEN
    /* The class was found, so return the ID */
    RETURN _classId;
ELSE
    /* One needs to be allocated, so we need to add it */
    INSERT INTO search_class (name) VALUES (_className);
    RETURN LAST_INSERT_ID();
END IF;

END;;
DELIMITER ;