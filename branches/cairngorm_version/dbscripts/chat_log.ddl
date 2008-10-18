CREATE TABLE `fl_chat_log` (
  `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  `session_id` VARCHAR(45) NOT NULL,
  `sender_name` VARCHAR(45) NOT NULL,
  `dest_name` VARCHAR(45) NOT NULL,
  `topic` VARCHAR(45) NOT NULL,
  `message` VARCHAR(255) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = InnoDB;

