-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema blogdb
-- -----------------------------------------------------
-- This is a blog database.
DROP SCHEMA IF EXISTS `blogdb` ;

-- -----------------------------------------------------
-- Schema blogdb
--
-- This is a blog database.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `blogdb` DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci ;
SHOW WARNINGS;
USE `blogdb` ;

-- -----------------------------------------------------
-- Table `blogdb`.`blogdb_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `blogdb`.`blogdb_user` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `blogdb`.`blogdb_user` (
  `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'The user table id.',
  `user_first_name` VARCHAR(50) NULL COMMENT 'First name of the user.',
  `user_middle_name` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Middle name of the user.',
  `user_last_name` VARCHAR(50) NULL COMMENT 'Last name of the user.',
  `user_mobile` VARCHAR(15) NULL COMMENT 'Users mobile phone.',
  `user_email` VARCHAR(50) NOT NULL DEFAULT 'user@example.com' COMMENT 'Users email.',
  `user_password_hash` VARCHAR(32) NOT NULL COMMENT 'Users hashed password.',
  `user_registered_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of when the user was registered.\nIf the user wasn\'t yet registered the default value shall be 0.',
  `user_last_login` DATETIME NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT 'Timestamp of when the user was last logged in.',
  `user_intro` TINYTEXT NULL DEFAULT NULL COMMENT 'Intro line about the user.',
  `user_profile` TEXT NULL DEFAULT NULL COMMENT 'Profile text about the user.',
  PRIMARY KEY (`user_id`))
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_uq_mobile` USING BTREE ON `blogdb`.`blogdb_user` (`user_mobile`) COMMENT 'Index of all unique mobile phones.' INVISIBLE;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_uq_email` USING BTREE ON `blogdb`.`blogdb_user` (`user_email`) COMMENT 'Index of all unique emails.' INVISIBLE;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_uq_id` USING BTREE ON `blogdb`.`blogdb_user` (`user_id`) INVISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `blogdb`.`blogdb_post`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `blogdb`.`blogdb_post` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `blogdb`.`blogdb_post` (
  `post_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'The post table id.',
  `user_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'The user table id as a foreign key.',
  `post_parent_id` BIGINT(20) UNSIGNED NULL DEFAULT NULL COMMENT 'The parent id indicates the parent of the comment, ie. the already existing comment that the new comment is pointing to.\nSo the new comment in this case can be a reply to the already existing comment.',
  `post_title` VARCHAR(75) NOT NULL DEFAULT 'Title of the post' COMMENT 'The title of the blog post.',
  `post_meta_title` VARCHAR(100) GENERATED ALWAYS AS ('Meta title of the post') VIRTUAL COMMENT 'Meta data of the post.\nIt is used for search engines such as google.\nThis is very important, especially for SEO.',
  `post_slug` VARCHAR(100) NOT NULL COMMENT 'The post slug.',
  `post_summary` TINYTEXT GENERATED ALWAYS AS (NULL) VIRTUAL COMMENT 'Summary of the post, a short excerpt. ',
  `post_published` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'This field indicates wheater or not the post is published.\n0 means it is not published.\n1 means it is published.\nThese act as a boolean since MySQL doesn\'t have a BOOLEAN data type.',
  `post_created _at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'This is a time stamp of when the post was created.',
  `post_updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'This is the time stamp of when the post was last updated, ie. changed.',
  `post_publishet_at` DATETIME NULL DEFAULT NULL COMMENT 'This is the time stamp of when the post was published.\nIf the post isn\'t yet published, the default value shall be null.',
  `post_content` TEXT NOT NULL DEFAULT 'Text of the post' COMMENT 'The post text.',
  PRIMARY KEY (`post_id`),
  CONSTRAINT `fk_post_parent`
    FOREIGN KEY (`post_parent_id`)
    REFERENCES `blogdb`.`blogdb_post` (`post_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_post_user`
    FOREIGN KEY (`user_id`)
    REFERENCES `blogdb`.`blogdb_user` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_uq_slug` USING BTREE ON `blogdb`.`blogdb_post` (`post_slug`) COMMENT 'Index of all the slugs on the blog platform.' INVISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_post_parent_idx` USING BTREE ON `blogdb`.`blogdb_post` (`post_parent_id`) COMMENT 'Index of all parents, ie. of all the posts that are linked to newer posts.' INVISIBLE;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_uq_id` USING BTREE ON `blogdb`.`blogdb_post` (`post_id`) COMMENT 'Index of all the id\'s of all the posts within the post table.' INVISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_post_user_idx` USING BTREE ON `blogdb`.`blogdb_post` (`user_id`) INVISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `blogdb`.`blogdb_post_meta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `blogdb`.`blogdb_post_meta` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `blogdb`.`blogdb_post_meta` (
  `post_meta_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'The post meta table id.',
  `post_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'The post table id as a foreign key.',
  `post_meta_key` VARCHAR(50) NOT NULL COMMENT 'The key of the meta data.',
  `post_meta_value` TEXT NULL DEFAULT NULL COMMENT 'The content of the meta data.',
  PRIMARY KEY (`post_meta_id`),
  CONSTRAINT `fk_post_meta_post`
    FOREIGN KEY (`post_id`)
    REFERENCES `blogdb`.`blogdb_post` (`post_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_uq_id` USING BTREE ON `blogdb`.`blogdb_post_meta` (`post_meta_id`) INVISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_post_meta_post_idx` USING BTREE ON `blogdb`.`blogdb_post_meta` (`post_id`) INVISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `blogdb`.`blogdb_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `blogdb`.`blogdb_comment` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `blogdb`.`blogdb_comment` (
  `comment_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'The comment table id.',
  `post_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'The post table id as a foreign key.',
  `comment_parent_id` BIGINT(20) UNSIGNED NULL,
  `comment_title` VARCHAR(100) NOT NULL COMMENT 'Comment title.',
  `comment_published` TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'This field indicates wheater or not the comment is published.\n0 means it is not published.\n1 means it is published.\nThese act as a boolean since MySQL doesn\'t have a BOOLEAN data type.',
  `comment_created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Timestamp of when the comment was created.',
  `comment_published_at` DATETIME NULL DEFAULT NULL COMMENT 'Timestamp of when the comment was published.\nIf it was not published NULL shall be displayed.',
  `comment_content` TEXT NULL DEFAULT NULL COMMENT 'The content of the comment itself.',
  PRIMARY KEY (`comment_id`),
  CONSTRAINT `fk_comment_post`
    FOREIGN KEY (`post_id`)
    REFERENCES `blogdb`.`blogdb_post` (`post_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_comment_parent`
    FOREIGN KEY (`comment_parent_id`)
    REFERENCES `blogdb`.`blogdb_comment` (`comment_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_uq_id` USING BTREE ON `blogdb`.`blogdb_comment` (`comment_id`) INVISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_comment_post_idx` USING BTREE ON `blogdb`.`blogdb_comment` (`post_id`) INVISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_comment_parent_idx` USING BTREE ON `blogdb`.`blogdb_comment` (`comment_parent_id`) INVISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `blogdb`.`blogdb_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `blogdb`.`blogdb_category` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `blogdb`.`blogdb_category` (
  `category_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'The category table id.',
  `category_title` VARCHAR(75) NOT NULL DEFAULT 'category name' COMMENT 'Title of the category.',
  `category_meta_title` VARCHAR(100) NULL DEFAULT NULL COMMENT 'Meta data of the category.\nIt is used for search engines such as google.\nThis is very important, especially for SEO.',
  `category_slug` VARCHAR(100) NOT NULL COMMENT 'Category slug.',
  `category_content` TEXT NULL DEFAULT NULL COMMENT 'Category text.',
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_uq_id` USING BTREE ON `blogdb`.`blogdb_category` (`category_id`) INVISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `blogdb`.`blogdb_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `blogdb`.`blogdb_tag` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `blogdb`.`blogdb_tag` (
  `tag_id` BIGINT(20) UNSIGNED NOT NULL COMMENT 'The tag table id.',
  `tag_title` VARCHAR(75) NULL DEFAULT 'tag name' COMMENT 'Title of the tag.',
  `tag_meta_title` VARCHAR(100) NULL DEFAULT NULL COMMENT 'Meta data of the category.\nIt is used for search engines such as google.\nThis is very important, especially for SEO.',
  `tag_slug` TEXT NULL COMMENT 'Tag text.',
  `tag_content` VARCHAR(45) NULL DEFAULT NULL COMMENT 'Tag text.',
  PRIMARY KEY (`tag_id`))
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE UNIQUE INDEX `idx_uq_id` ON `blogdb`.`blogdb_tag` (`tag_id` ASC) INVISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `blogdb`.`post_has_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `blogdb`.`post_has_tag` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `blogdb`.`post_has_tag` (
  `post_id` BIGINT(20) UNSIGNED NOT NULL,
  `tag_id` BIGINT(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`post_id`, `tag_id`),
  CONSTRAINT `fk_post_has_tag`
    FOREIGN KEY (`post_id`)
    REFERENCES `blogdb`.`blogdb_post` (`post_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_tag_has_post`
    FOREIGN KEY (`tag_id`)
    REFERENCES `blogdb`.`blogdb_tag` (`tag_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_tag_has_post_idx` USING BTREE ON `blogdb`.`post_has_tag` (`tag_id`) INVISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_post_has_tag_idx` USING BTREE ON `blogdb`.`post_has_tag` (`post_id`) INVISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `blogdb`.`post_has_category`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `blogdb`.`post_has_category` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `blogdb`.`post_has_category` (
  `post_id` BIGINT(20) UNSIGNED NOT NULL,
  `category_id` BIGINT(20) UNSIGNED NOT NULL,
  PRIMARY KEY (`post_id`, `category_id`),
  CONSTRAINT `fk_post_has_category`
    FOREIGN KEY (`post_id`)
    REFERENCES `blogdb`.`blogdb_post` (`post_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_category_has_post`
    FOREIGN KEY (`category_id`)
    REFERENCES `blogdb`.`blogdb_category` (`category_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_category_has_post_idx` USING BTREE ON `blogdb`.`post_has_category` (`category_id`) INVISIBLE;

SHOW WARNINGS;
CREATE INDEX `fk_post_has_category_idx` USING BTREE ON `blogdb`.`post_has_category` (`post_id`) INVISIBLE;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
