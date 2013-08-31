DROP DATABASE IF EXISTS `gideon`;

CREATE DATABASE `gideon`;

USE `gideon`;

CREATE TABLE `author` (
       `id`         INT UNSIGNED AUTO_INCREMENT,
       `name`       VARCHAR(100) NOT NULL,
       `created_at` TIMESTAMP NOT NULL,
       PRIMARY KEY(`id`),
       UNIQUE KEY name (`name`)
) ENGINE = InnoDB CHARACTER SET utf8mb4;

CREATE TABLE `book` (
       `id`         INT UNSIGNED AUTO_INCREMENT,
       `name`       VARCHAR(100) NOT NULL,
       `created_at` TIMESTAMP NOT NULL,
       PRIMARY KEY(`id`),
       UNIQUE KEY `name` (`name`)
) ENGINE = InnoDB CHARACTER SET utf8mb4;

CREATE TABLE `book_author` (
       `id`          INT UNSIGNED AUTO_INCREMENT,
       `author_id`   INT UNSIGNED NOT NULL,
       `book_id`     INT UNSIGNED NOT NULL,
       `created_at`  TIMESTAMP NOT NULL,
       PRIMARY KEY(`id`),
       UNIQUE KEY `author_book` (`author_id`,`book_id`),
       CONSTRAINT `fk_author` 
          FOREIGN KEY (`author_id`) REFERENCES author(`id`)
          ON UPDATE CASCADE
          ON DELETE CASCADE,
       CONSTRAINT `fk_book` 
          FOREIGN KEY (`book_id`) REFERENCES book(`id`)
          ON UPDATE CASCADE
          ON DELETE CASCADE
) ENGINE = InnoDB CHARACTER SET utf8mb4;

GRANT ALL ON `gideon`.* TO `devel`@`localhost`;
