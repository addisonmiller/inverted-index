/*
 * Index update triggers
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */

DELIMITER ;;

DROP TRIGGER IF EXISTS tr_AU_index_article;;
CREATE TRIGGER tr_AU_index_article
    AFTER UPDATE ON article
    FOR EACH ROW BEGIN
        CALL article__indexString(NEW.article_id, CONCAT_WS(' ', NEW.title, NEW.author, NEW.body), 'C');
        CALL article__indexString(NEW.article_id, NEW.title, 'T');
        CALL article__indexString(NEW.article_id, NEW.author, 'A');
        CALL article__indexString(NEW.article_id, NEW.body, 'B');
    END;
;;

DROP TRIGGER IF EXISTS tr_AI_index_article;;
CREATE TRIGGER tr_AI_index_article
    AFTER INSERT ON article
    FOR EACH ROW BEGIN
        CALL article__indexString(NEW.article_id, CONCAT_WS(' ', NEW.title, NEW.author, NEW.body), 'C');
        CALL article__indexString(NEW.article_id, NEW.title, 'T');
        CALL article__indexString(NEW.article_id, NEW.author, 'A');
        CALL article__indexString(NEW.article_id, NEW.body, 'B');
    END;
;;

DROP TRIGGER IF EXISTS tr_BD_index_article;;
CREATE TRIGGER tr_BD_index_article
    BEFORE DELETE ON article
    FOR EACH ROW BEGIN
        DELETE FROM article__index WHERE article_id = OLD.article_id;
    END;
;;

DELIMITER ;