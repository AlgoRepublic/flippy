DROP TABLE IF EXISTS `flippy`.`fl_login`;
CREATE TABLE  `flippy`.`fl_login` (
  `user_name` varchar(50) NOT NULL,
  `password` varchar(20) NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  `learning_age` int(2) default '-1',
  `city` varchar(50) NOT NULL,
  PRIMARY KEY  (`user_name`)
) ENGINE=InnoDB;
