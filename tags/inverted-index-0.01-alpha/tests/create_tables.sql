/*
 * Tables
 * Inverted Index Toolkit  <http://code.google.com/p/inverted-index/>
 * Apache License 2.0, blah blah blah.
 */


DROP TABLE IF EXISTS article__index;
DROP TABLE IF EXISTS word;
DROP TABLE IF EXISTS article;

/*
 * This table is a simple article table
 */
CREATE TABLE IF NOT EXISTS article (
  article_id int(11) unsigned NOT NULL auto_increment,
  title text NOT NULL,
  author text NOT NULL,
  body text NOT NULL,
  PRIMARY KEY  (article_id)
) ENGINE=InnoDB;

/*
 * This table contains a list of words as used in the inverted index.
 */
CREATE TABLE word (
  word_id int(10) unsigned NOT NULL auto_increment,
  string varchar(255) NOT NULL,
  PRIMARY KEY  (word_id),
  UNIQUE KEY ix_wordstr (string)
) ENGINE=InnoDB;


/*
 * This table contains the inverted index for the articles table.
 */
CREATE TABLE article__index (
  article_id int(10) unsigned NOT NULL,
  field char(1) NOT NULL,
  position int(10) unsigned NOT NULL,
  word_id int(10) unsigned NOT NULL,
  PRIMARY KEY  (article_id,field,position),
  KEY ix_wfp (word_id,field,position),
  FOREIGN KEY (word_id) REFERENCES word (word_id),
  FOREIGN KEY (article_id) REFERENCES article (article_id)
) ENGINE=InnoDB;
