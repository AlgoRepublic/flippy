CREATE TABLE `fl_room` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `learning_age` int(11) NOT NULL,
  `description` text,
  `status` smallint(6) NOT NULL default '100',
  `dt_create` datetime NOT NULL,
  `dt_last_change` datetime NOT NULL,
  PRIMARY KEY  (`id`)
)
ENGINE = InnoDB;
