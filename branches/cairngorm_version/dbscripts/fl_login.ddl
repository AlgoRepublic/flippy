DROP TABLE IF EXISTS `flippy`.`fl_login`;
CREATE TABLE  `flippy`.`fl_login` (
  `user_name` varchar(50) character set latin1 collate latin1_bin NOT NULL,
  `password` varchar(20) character set latin1 collate latin1_bin NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  `learning_age` int(2) default '-1',
  PRIMARY KEY  (`user_name`,`password`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
