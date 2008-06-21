--
-- Tables for "guten" examples.
--

DROP TABLE IF EXISTS doc;

CREATE TABLE IF NOT EXISTS doc (
  doc_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  author text NOT NULL,
  title text NOT NULL,
  subtitle text NOT NULL,
  body text NOT NULL,
  PRIMARY KEY  (doc_id)
) ENGINE=MyISAM;

DELIMITER ;;

DROP TRIGGER IF EXISTS tr_AU_index_doc;;
CREATE TRIGGER tr_AU_index_doc
    AFTER UPDATE ON doc
    FOR EACH ROW BEGIN
        CALL indexString(NEW.doc_id, CONCAT_WS(' ', NEW.title, NEW.author, NEW.body), classID('doc._all'));
        CALL indexString(NEW.doc_id, NEW.title, classID('doc.title'));
        CALL indexString(NEW.doc_id, CONCAT_WS(' ', NEW.title, NEW.subtitle), classID('doc.titles'));
        CALL indexString(NEW.doc_id, NEW.author, classID('doc.author'));
        CALL indexString(NEW.doc_id, NEW.body, classID('doc.body'));
    END;
;;

DROP TRIGGER IF EXISTS tr_AI_index_doc;;
CREATE TRIGGER tr_AI_index_doc
    AFTER INSERT ON doc
    FOR EACH ROW BEGIN
        CALL indexString(NEW.doc_id, CONCAT_WS(' ', NEW.title, NEW.author, NEW.body), classID('doc._all'));
        CALL indexString(NEW.doc_id, NEW.title, classID('doc.title'));
        CALL indexString(NEW.doc_id, CONCAT_WS(' ', NEW.title, NEW.subtitle), classID('doc.titles'));
        CALL indexString(NEW.doc_id, NEW.author, classID('doc.author'));
        CALL indexString(NEW.doc_id, NEW.body, classID('doc.body'));
    END;
;;

DROP TRIGGER IF EXISTS tr_BD_index_doc;;
CREATE TRIGGER tr_BD_index_doc
    BEFORE DELETE ON doc
    FOR EACH ROW BEGIN
        DELETE FROM search_index WHERE id = OLD.doc_id AND search_class_id = classID('doc._all');
        DELETE FROM search_index WHERE id = OLD.doc_id AND search_class_id = classID('doc.title');
        DELETE FROM search_index WHERE id = OLD.doc_id AND search_class_id = classID('doc.titles');
        DELETE FROM search_index WHERE id = OLD.doc_id AND search_class_id = classID('doc.author');
        DELETE FROM search_index WHERE id = OLD.doc_id AND search_class_id = classID('doc.body');
    END;
;;

DELIMITER ;



DROP TABLE IF EXISTS bibleverse;

CREATE TABLE IF NOT EXISTS bibleverse (
  bibleverse_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  book varchar(32) NOT NULL,
  chapter tinyint NOT NULL,
  verse tinyint NOT NULL,
  body text NOT NULL,
  PRIMARY KEY  (bibleverse_id)
) ENGINE=MyISAM;

DELIMITER ;;

DROP TRIGGER IF EXISTS tr_AU_index_bibleverse;;
CREATE TRIGGER tr_AU_index_bibleverse
    AFTER UPDATE ON bibleverse
    FOR EACH ROW BEGIN
        CALL indexString(NEW.bibleverse_id, NEW.body, classID('bibleverse._all'));
    END;
;;

DROP TRIGGER IF EXISTS tr_AI_index_bibleverse;;
CREATE TRIGGER tr_AI_index_bibleverse
    AFTER INSERT ON bibleverse
    FOR EACH ROW BEGIN
        CALL indexString(NEW.bibleverse_id, NEW.body, classID('bibleverse._all'));
    END;
;;

DROP TRIGGER IF EXISTS tr_BD_index_bibleverse;;
CREATE TRIGGER tr_BD_index_bibleverse
    BEFORE DELETE ON bibleverse
    FOR EACH ROW BEGIN
        DELETE FROM search_index WHERE id = OLD.bibleverse_id AND search_class_id = classID('bibleverse._all');
    END;
;;

DELIMITER ;