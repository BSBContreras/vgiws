-- MySQL Script generated by MySQL Workbench
-- Sáb 30 Dez 2017 22:07:01 -02
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
  `is_email_valid` TINYINT(1) NULL,
  `create_at` TIMESTAMP NULL,
  `removed_at` TIMESTAMP NULL,
  `terms_agreed` TINYINT(1) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`group_`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`group_` ;

CREATE TABLE IF NOT EXISTS `mydb`.`group_` (
  `id` INT NOT NULL,
  `create_at` TIMESTAMP NULL,
  `removed_at` TIMESTAMP NULL,
  `visible` TINYINT(1) NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_group__user_1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_group__user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
  `fk_group_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_project_user_1_idx` (`fk_user_id` ASC),
  INDEX `fk_project_group1_idx` (`fk_group_id` ASC),
  CONSTRAINT `fk_project_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_project_group1`
    FOREIGN KEY (`fk_group_id`)
    REFERENCES `mydb`.`group_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`layer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`layer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`layer` (
  `id` INT NOT NULL,
  `create_at` TIMESTAMP NULL,
  `removed_at` TIMESTAMP NULL,
  `visible` TINYINT(1) NULL,
  `fk_project_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_project_user1_idx` (`fk_user_id` ASC),
  INDEX `fk_layer_project1_idx` (`fk_project_id` ASC),
  CONSTRAINT `fk_project_user1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_layer_project1`
    FOREIGN KEY (`fk_project_id`)
    REFERENCES `mydb`.`project` (`id`)
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
  `fk_layer_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_tb_project_tb_user1_idx` (`fk_user_id` ASC),
  INDEX `fk_change_set_project1_idx` (`fk_layer_id` ASC),
  CONSTRAINT `fk_tb_project_tb_user1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_change_set_project1`
    FOREIGN KEY (`fk_layer_id`)
    REFERENCES `mydb`.`layer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`point`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`point` ;

CREATE TABLE IF NOT EXISTS `mydb`.`point` (
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
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_user_id`),
  INDEX `fk_account_user1_idx` (`fk_user_id` ASC),
  UNIQUE INDEX `k_UNIQUE` (`k` ASC),
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
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_node_comment_change_group1_idx` (`fk_changeset_id` ASC),
  INDEX `fk_node_comment_user1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_node_comment_change_group1`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_node_comment_user1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`line`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`line` ;

CREATE TABLE IF NOT EXISTS `mydb`.`line` (
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
-- Table `mydb`.`line_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`line_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`line_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_line_version` INT NOT NULL,
  `fk_line_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_line_version`, `fk_line_id`),
  INDEX `fk_line_tag_line1_idx` (`fk_line_id` ASC, `fk_line_version` ASC),
  CONSTRAINT `fk_line_tag_line1`
    FOREIGN KEY (`fk_line_id` , `fk_line_version`)
    REFERENCES `mydb`.`line` (`id` , `version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`point_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`point_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`point_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_point_version` INT NOT NULL,
  `fk_point_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_point_version`, `fk_point_id`),
  INDEX `fk_point_tag_point1_idx` (`fk_point_id` ASC, `fk_point_version` ASC),
  CONSTRAINT `fk_point_tag_point1`
    FOREIGN KEY (`fk_point_id` , `fk_point_version`)
    REFERENCES `mydb`.`point` (`id` , `version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user_message` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user_message` (
  `id` INT NOT NULL,
  `body` TEXT NULL,
  `create_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  `is_read` TINYINT(1) NULL,
  `fk_user_id_from` INT NOT NULL,
  `fk_user_id_to` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_message_user1_idx` (`fk_user_id_from` ASC),
  INDEX `fk_user_message_user_1_idx` (`fk_user_id_to` ASC),
  CONSTRAINT `fk_message_user1`
    FOREIGN KEY (`fk_user_id_from`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_message_user_1`
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
-- Table `mydb`.`follow`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`follow` ;

CREATE TABLE IF NOT EXISTS `mydb`.`follow` (
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
-- Table `mydb`.`polygon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`polygon` ;

CREATE TABLE IF NOT EXISTS `mydb`.`polygon` (
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
-- Table `mydb`.`polygon_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`polygon_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`polygon_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_polygon_version` INT NOT NULL,
  `fk_polygon_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_polygon_version`, `fk_polygon_id`),
  INDEX `fk_polygon_tag_polygon1_idx` (`fk_polygon_id` ASC, `fk_polygon_version` ASC),
  CONSTRAINT `fk_polygon_tag_polygon1`
    FOREIGN KEY (`fk_polygon_id` , `fk_polygon_version`)
    REFERENCES `mydb`.`polygon` (`id` , `version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`project_subscriber`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`project_subscriber` ;

CREATE TABLE IF NOT EXISTS `mydb`.`project_subscriber` (
  `fk_project_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  `permission` VARCHAR(45) NULL,
  INDEX `fk_project_subscriber_user1_idx` (`fk_user_id` ASC),
  PRIMARY KEY (`fk_project_id`, `fk_user_id`),
  INDEX `fk_project_subscriber_project1_idx` (`fk_project_id` ASC),
  CONSTRAINT `fk_project_subscriber_user1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_project_subscriber_project1`
    FOREIGN KEY (`fk_project_id`)
    REFERENCES `mydb`.`project` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_point`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_point` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_point` (
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
-- Table `mydb`.`current_polygon`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_polygon` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_polygon` (
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
-- Table `mydb`.`current_polygon_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_polygon_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_polygon_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_current_polygon_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_current_polygon_id`),
  INDEX `fk_current_area_tag_current_area1_idx` (`fk_current_polygon_id` ASC),
  CONSTRAINT `fk_current_area_tag_current_area1`
    FOREIGN KEY (`fk_current_polygon_id`)
    REFERENCES `mydb`.`current_polygon` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_line`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_line` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_line` (
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
-- Table `mydb`.`current_line_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_line_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_line_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_current_line_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_current_line_id`),
  INDEX `fk_current_way_tag_current_way1_idx` (`fk_current_line_id` ASC),
  CONSTRAINT `fk_current_way_tag_current_way1`
    FOREIGN KEY (`fk_current_line_id`)
    REFERENCES `mydb`.`current_line` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_point_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_point_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_point_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_current_point_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_current_point_id`),
  INDEX `fk_current_node_tag_current_node1_idx` (`fk_current_point_id` ASC),
  CONSTRAINT `fk_current_node_tag_current_node1`
    FOREIGN KEY (`fk_current_point_id`)
    REFERENCES `mydb`.`current_point` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`changeset_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`changeset_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`changeset_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_changeset_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_changeset_id`),
  INDEX `fk_way_tag_copy1_changeset1_idx` (`fk_changeset_id` ASC),
  UNIQUE INDEX `k_UNIQUE` (`k` ASC),
  CONSTRAINT `fk_way_tag_copy1_changeset1`
    FOREIGN KEY (`fk_changeset_id`)
    REFERENCES `mydb`.`changeset` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`layer_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`layer_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`layer_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_layer_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_layer_id`),
  INDEX `fk_project_tag_project1_idx` (`fk_layer_id` ASC),
  CONSTRAINT `fk_project_tag_project1`
    FOREIGN KEY (`fk_layer_id`)
    REFERENCES `mydb`.`layer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`project_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`project_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`project_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_project_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_project_id`),
  INDEX `fk_project_project1_idx` (`fk_project_id` ASC),
  CONSTRAINT `fk_project_project1`
    FOREIGN KEY (`fk_project_id`)
    REFERENCES `mydb`.`project` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`layer_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`layer_comment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`layer_comment` (
  `id` INT NOT NULL,
  `body` TEXT NULL,
  `create_at` TIMESTAMP NULL,
  `closed_at` TIMESTAMP NULL,
  `fk_layer_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  `fk_comment_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_review_layer1_idx` (`fk_layer_id` ASC),
  INDEX `fk_review_user_1_idx` (`fk_user_id` ASC),
  INDEX `fk_layer_comment_layer_comment1_idx` (`fk_comment_id` ASC),
  CONSTRAINT `fk_review_layer1`
    FOREIGN KEY (`fk_layer_id`)
    REFERENCES `mydb`.`layer` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_layer_comment_layer_comment1`
    FOREIGN KEY (`fk_comment_id`)
    REFERENCES `mydb`.`layer_comment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`layer_comment_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`layer_comment_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`layer_comment_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_comment_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_comment_id`),
  INDEX `fk_layer_comment_tag_layer_comment1_idx` (`fk_comment_id` ASC),
  CONSTRAINT `fk_layer_comment_tag_layer_comment1`
    FOREIGN KEY (`fk_comment_id`)
    REFERENCES `mydb`.`layer_comment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_group`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user_group` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user_group` (
  `fk_group_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  `create_at` TIMESTAMP NULL,
  PRIMARY KEY (`fk_group_id`, `fk_user_id`),
  INDEX `fk_user_group_user_1_idx` (`fk_user_id` ASC),
  INDEX `fk_user_group_group1_idx` (`fk_group_id` ASC),
  CONSTRAINT `fk_user_group_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_group_group1`
    FOREIGN KEY (`fk_group_id`)
    REFERENCES `mydb`.`group_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`group_comment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`group_comment` ;

CREATE TABLE IF NOT EXISTS `mydb`.`group_comment` (
  `id` INT NOT NULL,
  `body` TEXT NULL,
  `create_at` TIMESTAMP NULL,
  `updated_at` TIMESTAMP NULL,
  `removed_at` TIMESTAMP NULL,
  `visible` TINYINT(1) NULL,
  `fk_group_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  `fk_comment_id_parent` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_group_comment_group1_idx` (`fk_group_id` ASC),
  INDEX `fk_group_comment_user_1_idx` (`fk_user_id` ASC),
  INDEX `fk_group_comment_group_comment1_idx` (`fk_comment_id_parent` ASC),
  CONSTRAINT `fk_group_comment_group1`
    FOREIGN KEY (`fk_group_id`)
    REFERENCES `mydb`.`group_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_comment_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_group_comment_group_comment1`
    FOREIGN KEY (`fk_comment_id_parent`)
    REFERENCES `mydb`.`group_comment` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`polygon_award`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`polygon_award` ;

CREATE TABLE IF NOT EXISTS `mydb`.`polygon_award` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_polygon_version` INT NOT NULL,
  `fk_polygon_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_polygon_version`, `fk_polygon_id`),
  INDEX `fk_polygon_award_polygon1_idx` (`fk_polygon_id` ASC, `fk_polygon_version` ASC),
  INDEX `fk_polygon_award_user_1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_polygon_award_polygon1`
    FOREIGN KEY (`fk_polygon_id` , `fk_polygon_version`)
    REFERENCES `mydb`.`polygon` (`id` , `version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_polygon_award_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`point_award`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`point_award` ;

CREATE TABLE IF NOT EXISTS `mydb`.`point_award` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_point_version` INT NOT NULL,
  `fk_point_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_point_version`, `fk_point_id`),
  INDEX `fk_point_award_point1_idx` (`fk_point_id` ASC, `fk_point_version` ASC),
  INDEX `fk_point_award_user_1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_point_award_point1`
    FOREIGN KEY (`fk_point_id` , `fk_point_version`)
    REFERENCES `mydb`.`point` (`id` , `version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_point_award_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`line_award`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`line_award` ;

CREATE TABLE IF NOT EXISTS `mydb`.`line_award` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_line_version` INT NOT NULL,
  `fk_line_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_line_version`, `fk_line_id`),
  INDEX `fk_line_award_line1_idx` (`fk_line_id` ASC, `fk_line_version` ASC),
  INDEX `fk_line_award_user_1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_line_award_line1`
    FOREIGN KEY (`fk_line_id` , `fk_line_version`)
    REFERENCES `mydb`.`line` (`id` , `version`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_line_award_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_point_award`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_point_award` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_point_award` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_current_point_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_current_point_id`),
  INDEX `fk_current_point_award_current_point1_idx` (`fk_current_point_id` ASC),
  INDEX `fk_current_point_award_user_1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_current_point_award_current_point1`
    FOREIGN KEY (`fk_current_point_id`)
    REFERENCES `mydb`.`current_point` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_current_point_award_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_line_award`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_line_award` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_line_award` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_current_line_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_current_line_id`),
  INDEX `fk_current_line_award_current_line1_idx` (`fk_current_line_id` ASC),
  INDEX `fk_current_line_award_user_1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_current_line_award_current_line1`
    FOREIGN KEY (`fk_current_line_id`)
    REFERENCES `mydb`.`current_line` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_current_line_award_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`current_polygon_award`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`current_polygon_award` ;

CREATE TABLE IF NOT EXISTS `mydb`.`current_polygon_award` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_current_polygon_id` INT NOT NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_current_polygon_id`),
  INDEX `fk_current_polygon_award_current_polygon1_idx` (`fk_current_polygon_id` ASC),
  INDEX `fk_current_polygon_award_user_1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_current_polygon_award_current_polygon1`
    FOREIGN KEY (`fk_current_polygon_id`)
    REFERENCES `mydb`.`current_polygon` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_current_polygon_award_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`user_award`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user_award` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user_award` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_user_id`),
  INDEX `fk_user_award_user_1_idx` (`fk_user_id` ASC),
  UNIQUE INDEX `k_UNIQUE` (`k` ASC),
  CONSTRAINT `fk_user_award_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`notification`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`notification` ;

CREATE TABLE IF NOT EXISTS `mydb`.`notification` (
  `id` INT NOT NULL,
  `body` VARCHAR(128) NULL,
  `url` VARCHAR(255) NULL,
  `icon` TEXT NULL,
  `is_read` TINYINT(1) NULL,
  `fk_user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_notification_user_1_idx` (`fk_user_id` ASC),
  CONSTRAINT `fk_notification_user_1`
    FOREIGN KEY (`fk_user_id`)
    REFERENCES `mydb`.`user_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`group_tag`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`group_tag` ;

CREATE TABLE IF NOT EXISTS `mydb`.`group_tag` (
  `k` VARCHAR(255) NOT NULL,
  `v` VARCHAR(255) NULL,
  `fk_group_id` INT NOT NULL,
  PRIMARY KEY (`k`, `fk_group_id`),
  INDEX `fk_group_tag_group_1_idx` (`fk_group_id` ASC),
  CONSTRAINT `fk_group_tag_group_1`
    FOREIGN KEY (`fk_group_id`)
    REFERENCES `mydb`.`group_` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
