-- ----------------------------------------------------------------------
-- MySQL Migration Toolkit
-- SQL Create Script
-- ----------------------------------------------------------------------

-- Modified by SPJ for early versions of MySql 4 (4.0.SomeAncientVersion)
-- in which foreign key creation fails unless an index is explicitly created
-- for the foreign key field.  I also re-ordered the creation of the tables
-- so that foreign key indices can be created.  Silly MySql.

CREATE DATABASE IF NOT EXISTS `ReactorBlog`;
-- -------------------------------------
-- Tables

USE `ReactorBlog`;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `ReactorBlog`.`User`;
CREATE TABLE `ReactorBlog`.`User` (
  `userId` INT(10) NOT NULL auto_increment,
  `username` VARCHAR(20) NOT NULL,
  `password` VARCHAR(20) NOT NULL,
  `firstName` VARCHAR(20) NOT NULL,
  `lastName` VARCHAR(20) NOT NULL,
  `emailAddress` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`userId`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `ReactorBlog`.`Subscriber`;
CREATE TABLE `ReactorBlog`.`Subscriber` (
  `subscriberId` INT(10) NOT NULL auto_increment,
  `fullName` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`subscriberId`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `ReactorBlog`.`Category`;
CREATE TABLE `ReactorBlog`.`Category` (
  `categoryId` INT(10) NOT NULL auto_increment,
  `name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`categoryId`)
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `ReactorBlog`.`Entry`;
CREATE TABLE `ReactorBlog`.`Entry` (
  `entryId` INT(10) NOT NULL auto_increment,
  `title` VARCHAR(200) NOT NULL,
  `preview` TEXT NULL,
  `article` LONGTEXT NOT NULL,
  `publicationDate` DATETIME NOT NULL,
  `postedByUserId` INT(10) NOT NULL,
  `disableComments` TINYINT NOT NULL,
  `views` INT(10) NOT NULL,
  `totalRating` INT(10) NOT NULL,
  `timesRated` INT(10) NOT NULL,
  PRIMARY KEY (`entryId`),
  INDEX `IX_Entry_PostedByUserId` (postedByUserID),
  CONSTRAINT `FK_Entry_User` FOREIGN KEY `FK_Entry_User` (`postedByUserId`)
    REFERENCES `ReactorBlog`.`User` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `ReactorBlog`.`Comment`;
CREATE TABLE `ReactorBlog`.`Comment` (
  `commentId` INT(10) NOT NULL auto_increment,
  `entryId` INT(10) NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `emailAddress` VARCHAR(50) NULL,
  `comment` LONGTEXT NOT NULL,
  `posted` DATETIME NOT NULL,
  `subscribe` BIT NOT NULL DEFAULT 1,
  PRIMARY KEY (`commentId`),
  INDEX `IX_Comment_EntryID` (entryID),
  CONSTRAINT `FK_Comments_Entry` FOREIGN KEY `FK_Comments_Entry` (`entryId`)
    REFERENCES `ReactorBlog`.`Entry` (`entryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = INNODB;

DROP TABLE IF EXISTS `ReactorBlog`.`EntryCategory`;
CREATE TABLE `ReactorBlog`.`EntryCategory` (
  `entryCategoryId` INT(10) NOT NULL auto_increment,
  `entryId` INT(10) NOT NULL,
  `categoryId` INT(10) NOT NULL,
  PRIMARY KEY (`entryCategoryId`),
  INDEX `IX_EntryCategory_EntryID` (entryID),
  INDEX `IX_EntryCategory_CategoryID` (categoryID),  
  CONSTRAINT `FK_EntryCategory_Entry` FOREIGN KEY `FK_EntryCategory_Entry` (`entryId`)
    REFERENCES `ReactorBlog`.`Entry` (`entryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `FK_EntryCategory_Category` FOREIGN KEY `FK_EntryCategory_Category` (`categoryId`)
    REFERENCES `ReactorBlog`.`Category` (`categoryId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = INNODB;

SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO `ReactorBlog`.`User`
(
  `userName`,
  `password`,
  `firstName`,
  `lastName`,
  `emailAddress`
)
VALUES
(
  'admin',
  'admin',
  'Admin',
  'User',
  'admin@example.com'
);

-- ----------------------------------------------------------------------
-- EOF