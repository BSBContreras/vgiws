-- MySQL Script generated by MySQL Workbench
-- Ter 28 Nov 2017 19:39:37 -02
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`user_`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user_` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user_` (
  `id` INT NOT NULL,
  `username` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(45) NULL,
  `name` VARCHAR(50) NULL,
  `is_email_valid` TINYINT(1) NULL,
  `description` TEXT NULL,
  `create_at` TIMESTAMP NULL,
  `removed_at` TIMESTAMP NULL,
  `terms_agreed` TIMESTAMP NULL,
  `terms_seen` TINYINT(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`project`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`project` ;

CREATE TABLE IF NOT EXISTS `mydb`.`project` (
  `id` INT NOT NULL,
  `create_at` TIMESTAMP NULL,
  `removed_at` TIMESTAMP NULL,
  `visible` TINYINT(1) NULL,
  `fk_user_id_owner` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_project_user1_idx` (`fk_user_id_owner` ASC),
  CONSTRAINT `fk_project_user1`
    FOREIGN KEY (`fk_user_id_owner`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`changeset`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`changeset` ;

CREATE TABLE IF NOT EXISTS `mydb`.`changeset` (
  `id` INT NOT NULL,
  `create_at` TIMESTAMP NULL,
  `closed_at` TIMESTAMP NULL,
  `visible` TINYINT(1) NULL,
  `fk_project_id` INT NOT NULL,
  `fk_user_id_owner` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tb_project_tb_user1_idx` (`fk_user_id_owner` ASC),
  INDEX `fk_change_set_project1_idx` (`fk_project_id` ASC),
  CONSTRAINT `fk_tb_project_tb_user1`
    FOREIGN KEY (`fk_user_id_owner`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_change_set_project1`
    FOREIGN KEY (`fk_project_id`)
    REFERENCES `mydb`.`project` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`node`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`node` ;

CREATE TABLE IF NOT EXISTS `mydb`.`node` (
  `id` INT NOT NULL,
  `geom` MULTIPOINT NULL,
  `visible` TINYINT(1) NULL,
  `version` INT NOT NULL,
  `fk_changeset_id` INT NOT NULL,
  PRIMARY KEY (`id`, `version`),
  INDEX `fk_tb_contribution_tb_project1_idx` (`fk_changeset_id` ASC),
  CONSTRAINT `fk_tb_contribution_tb_project1`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user_tag` (
  `id` INT NOT NULL,
  `k` TEXT NOT NULL,
  `v` TEXT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`id`, `k`),
  INDEX `fk_account_user1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_account_user1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`changeset_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`changeset_comment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`changeset_comment` (
  `id` INT NOT NULL,
  `body` TEXT NULL,
  `create_at` TIMESTAMP NULL,
  `visible` TINYINT(1) NULL,
  `fk_changeset_id` INT NOT NULL,
  `fk_user_id_author` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_node_comment_change_group1_idx` (`fk_changeset_id` ASC),
  INDEX `fk_node_comment_user1_idx` (`fk_user_id_author` ASC),
  CONSTRAINT `fk_node_comment_change_group1`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_node_comment_user1`
    FOREIGN KEY (`fk_user_id_author`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`way`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`way` ;

CREATE TABLE IF NOT EXISTS `mydb`.`way` (
  `id` INT NOT NULL,
  `geom` MULTILINESTRING NULL,
  `visible` TINYINT(1) NULL,
  `version` INT NOT NULL,
  `fk_changeset_id` INT NOT NULL,
  PRIMARY KEY (`id`, `version`),
  INDEX `fk_table1_changeset1_idx` (`fk_changeset_id` ASC),
  CONSTRAINT `fk_table1_changeset1`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`way_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`way_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`way_tag` (
  `id` INT NOT NULL,
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `version` INT NOT NULL,
  `fk_way_id` INT NOT NULL,
  PRIMARY KEY (`id`, `version`, `k`),
  INDEX `fk_way_tag_way1_idx` (`fk_way_id` ASC),
  CONSTRAINT `fk_way_tag_way1`
    FOREIGN KEY (`fk_way_id`)
    REFERENCES `mydb`.`way` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`node_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`node_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`node_tag` (
  `id` INT NOT NULL,
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `version` INT NOT NULL,
  `fk_node_id` INT NOT NULL,
  PRIMARY KEY (`id`, `version`, `k`),
  INDEX `fk_node_tag_node1_idx` (`fk_node_id` ASC),
  CONSTRAINT `fk_node_tag_node1`
    FOREIGN KEY (`fk_node_id`)
    REFERENCES `mydb`.`node` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`message` ;

CREATE TABLE IF NOT EXISTS `mydb`.`message` (
  `id` INT NOT NULL,
  `title` TEXT NULL,
  `body` TEXT NULL,
  `sent_on` TIMESTAMP NULL,
  `message_read` TINYINT(1) NULL,
  `fk_user_id_from` INT NOT NULL,
  `fk_user_id_to` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_message_user1_idx` (`fk_user_id_from` ASC),
  INDEX `fk_message_user2_idx` (`fk_user_id_to` ASC),
  CONSTRAINT `fk_message_user1`
    FOREIGN KEY (`fk_user_id_from`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_message_user2`
    FOREIGN KEY (`fk_user_id_to`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`auth`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`auth` ;

CREATE TABLE IF NOT EXISTS `mydb`.`auth` (
  `id` INT NOT NULL,
  `is_admin` TINYINT(1) NULL,
  `allow_import_bulk` TINYINT(1) NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_auth_user1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_auth_user1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`friend`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`friend` ;

CREATE TABLE IF NOT EXISTS `mydb`.`friend` (
  `fk_user_id` INT NOT NULL,
  `fk_user_id_friend` INT NOT NULL,
  PRIMARY KEY (`fk_user_id`, `fk_user_id_friend`),
  INDEX `fk_friend_user1_idx` (`fk_user_id` ASC),
  INDEX `fk_friend_user2_idx` (`fk_user_id_friend` ASC),
  CONSTRAINT `fk_friend_user1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_friend_user2`
    FOREIGN KEY (`fk_user_id_friend`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`area`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`area` ;

CREATE TABLE IF NOT EXISTS `mydb`.`area` (
  `id` INT NOT NULL,
  `geom` MULTIPOLYGON NULL,
  `visible` TINYINT(1) NULL,
  `version` INT NOT NULL,
  `fk_changeset_id` INT NOT NULL,
  PRIMARY KEY (`id`, `version`),
  INDEX `fk_area_change_set1_idx` (`fk_changeset_id` ASC),
  CONSTRAINT `fk_area_change_set1`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`area_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`area_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`area_tag` (
  `id` INT NOT NULL,
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `version` INT NOT NULL,
  `fk_area_id` INT NOT NULL,
  PRIMARY KEY (`id`, `version`, `k`),
  INDEX `fk_area_tag_area1_idx` (`fk_area_id` ASC),
  CONSTRAINT `fk_area_tag_area1`
    FOREIGN KEY (`fk_area_id`)
    REFERENCES `mydb`.`area` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`project_subscriber`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`project_subscriber` ;

CREATE TABLE IF NOT EXISTS `mydb`.`project_subscriber` (
  `permission` VARCHAR(45) NULL,
  `fk_id_user` INT NOT NULL,
  `fk_id_project` INT NOT NULL,
  INDEX `fk_project_subscriber_user1_idx` (`fk_id_user` ASC),
  INDEX `fk_project_subscriber_project1_idx` (`fk_id_project` ASC),
  PRIMARY KEY (`fk_id_user`, `fk_id_project`),
  CONSTRAINT `fk_project_subscriber_user1`
    FOREIGN KEY (`fk_id_user`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_project_subscriber_project1`
    FOREIGN KEY (`fk_id_project`)
    REFERENCES `mydb`.`project` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_node`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_node` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_node` (
  `id` INT NOT NULL,
  `geom` MULTIPOINT NULL,
  `visible` TINYINT(1) NULL,
  `version` INT NULL,
  `fk_changeset_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tb_contribution_tb_project1_idx` (`fk_changeset_id` ASC),
  CONSTRAINT `fk_tb_contribution_tb_project10`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_area`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_area` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_area` (
  `id` INT NOT NULL,
  `geom` MULTIPOLYGON NULL,
  `visible` TINYINT(1) NULL,
  `version` INT NULL,
  `fk_changeset_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_area_change_set1_idx` (`fk_changeset_id` ASC),
  CONSTRAINT `fk_area_change_set10`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_area_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_area_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_area_tag` (
  `id` INT NOT NULL,
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_current_area_id` INT NOT NULL,
  PRIMARY KEY (`id`, `k`),
  INDEX `fk_current_area_tag_current_area1_idx` (`fk_current_area_id` ASC),
  CONSTRAINT `fk_current_area_tag_current_area1`
    FOREIGN KEY (`fk_current_area_id`)
    REFERENCES `mydb`.`current_area` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_way`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_way` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_way` (
  `id` INT NOT NULL,
  `geom` MULTILINESTRING NULL,
  `visible` TINYINT(1) NULL,
  `version` INT NULL,
  `fk_changeset_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_table1_changeset1_idx` (`fk_changeset_id` ASC),
  CONSTRAINT `fk_table1_changeset10`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_way_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_way_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_way_tag` (
  `id` INT NOT NULL,
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_current_way_id` INT NOT NULL,
  PRIMARY KEY (`id`, `k`),
  INDEX `fk_current_way_tag_current_way1_idx` (`fk_current_way_id` ASC),
  CONSTRAINT `fk_current_way_tag_current_way1`
    FOREIGN KEY (`fk_current_way_id`)
    REFERENCES `mydb`.`current_way` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_node_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_node_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_node_tag` (
  `id` INT NOT NULL,
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_current_node_id` INT NOT NULL,
  PRIMARY KEY (`id`, `k`),
  INDEX `fk_current_node_tag_current_node1_idx` (`fk_current_node_id` ASC),
  CONSTRAINT `fk_current_node_tag_current_node1`
    FOREIGN KEY (`fk_current_node_id`)
    REFERENCES `mydb`.`current_node` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`changeset_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`changeset_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`changeset_tag` (
  `id` INT NOT NULL,
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_changeset_id` INT NOT NULL,
  PRIMARY KEY (`id`, `k`),
  INDEX `fk_way_tag_copy1_changeset1_idx` (`fk_changeset_id` ASC),
  CONSTRAINT `fk_way_tag_copy1_changeset1`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`project_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`project_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`project_tag` (
  `id` INT NOT NULL,
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_project_id` INT NOT NULL,
  PRIMARY KEY (`id`, `k`),
  INDEX `fk_project_tag_project1_idx` (`fk_project_id` ASC),
  CONSTRAINT `fk_project_tag_project1`
    FOREIGN KEY (`fk_project_id`)
    REFERENCES `mydb`.`project` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
