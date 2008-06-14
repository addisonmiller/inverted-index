/*
 * Tables
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */


DROP TABLE IF EXISTS search_index;
DROP TABLE IF EXISTS search_class;
DROP TABLE IF EXISTS word;
DROP TABLE IF EXISTS article;

/*
 * This table is a simple article table
 */
CREATE TABLE IF NOT EXISTS article (
  article_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  title text NOT NULL,
  author text NOT NULL,
  body text NOT NULL,
  PRIMARY KEY  (article_id)
) ENGINE=InnoDB;

/*
 * This table contains a list of words as used in the search index.
 */
CREATE TABLE word (
  word_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  string VARCHAR(255) NOT NULL,
  PRIMARY KEY  (word_id),
  UNIQUE KEY ix_wordstr (string)
) ENGINE=InnoDB;

/*
 * This table contains a list of search classes.
 */
CREATE TABLE search_class (
  search_class_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  source_table VARCHAR(255) NOT NULL,
  source_columns VARCHAR(255) NOT NULL,
  PRIMARY KEY (search_class_id),
  KEY (name)
) ENGINE=InnoDB;

/*
 * This table contains the search index
 */
CREATE TABLE search_index (
  id INT(10) UNSIGNED NOT NULL,
  search_class_id INT(11) UNSIGNED NOT NULL,
  position INT(10) UNSIGNED NOT NULL,
  word_id INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY  (id,search_class_id,position),
  KEY ix_wfp (word_id,search_class_id,position),
  FOREIGN KEY (word_id) REFERENCES word (word_id),
  FOREIGN KEY (search_class_id) REFERENCES search_class (search_class_id)
) ENGINE=InnoDB;
