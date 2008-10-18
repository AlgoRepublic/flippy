CREATE TABLE  `fl_questions_log` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `session_id` varchar(45) NOT NULL,
  `sender_name` varchar(45) NOT NULL,
  `question` varchar(255) NOT NULL,
  `timestamp` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB;
