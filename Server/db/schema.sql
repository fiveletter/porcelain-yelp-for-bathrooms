CREATE DATABASE  IF NOT EXISTS `Porcelain` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `Porcelain`;
-- MySQL dump 10.13  Distrib 5.5.44, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: Porcelain
-- ------------------------------------------------------
-- Server version	5.5.44-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Bathrooms`
--

DROP TABLE IF EXISTS `Bathrooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Bathrooms` (
  `BathroomID` int(11) NOT NULL AUTO_INCREMENT,
  `Longitude` float NOT NULL,
  `Latitude` float NOT NULL,
  `Title` varchar(150) NOT NULL,
  `ImagePath` varchar(300) NOT NULL,
  PRIMARY KEY (`BathroomID`),
  UNIQUE KEY `Title_UNIQUE` (`Title`)
) ENGINE=InnoDB AUTO_INCREMENT=206 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bathrooms`
--

LOCK TABLES `Bathrooms` WRITE;
/*!40000 ALTER TABLE `Bathrooms` DISABLE KEYS */;
INSERT INTO `Bathrooms` VALUES (1,-121.881,37.3369,'SJSU Engineering Bathroom','');
/*!40000 ALTER TABLE `Bathrooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Flags`
--

DROP TABLE IF EXISTS `Flags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Flags` (
  `FlagsID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`FlagsID`),
  UNIQUE KEY `FlagsID_UNIQUE` (`FlagsID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Flags`
--

LOCK TABLES `Flags` WRITE;
/*!40000 ALTER TABLE `Flags` DISABLE KEYS */;
INSERT INTO `Flags` VALUES (1,'non existing'),(2,'hard to find'),(3,'paid'),(4,'public');
/*!40000 ALTER TABLE `Flags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Logs`
--

DROP TABLE IF EXISTS `Logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Logs` (
  `LogID` int(11) NOT NULL AUTO_INCREMENT,
  `Message` varchar(2000) NOT NULL,
  PRIMARY KEY (`LogID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Logs`
--

LOCK TABLES `Logs` WRITE;
/*!40000 ALTER TABLE `Logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `Logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Profiles`
--

DROP TABLE IF EXISTS `Profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Profiles` (
  `ProfileID` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(100) NOT NULL,
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `GoogleHash` varchar(45) NOT NULL,
  PRIMARY KEY (`ProfileID`),
  UNIQUE KEY `GoogleHash_UNIQUE` (`GoogleHash`),
  UNIQUE KEY `ProfilesID_UNIQUE` (`ProfileID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Profiles`
--

LOCK TABLES `Profiles` WRITE;
/*!40000 ALTER TABLE `Profiles` DISABLE KEYS */;
INSERT INTO `Profiles` VALUES (1,'unit@test.com','Unit','Test','HashBrowns');
/*!40000 ALTER TABLE `Profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RatingFlags`
--

DROP TABLE IF EXISTS `RatingFlags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RatingFlags` (
  `RatingFlagID` int(11) NOT NULL AUTO_INCREMENT,
  `FlagID` int(11) NOT NULL,
  `RatingID` int(11) NOT NULL,
  PRIMARY KEY (`RatingFlagID`),
  UNIQUE KEY `RatingFlagID_UNIQUE` (`RatingFlagID`),
  KEY `FlagID_idx` (`FlagID`),
  KEY `fk_RatingFlags_PorcelainRatings_idx` (`RatingID`),
  CONSTRAINT `fk_RatingFlags_PorcelainFlags` FOREIGN KEY (`FlagID`) REFERENCES `Flags` (`FlagsID`) ON DELETE CASCADE,
  CONSTRAINT `fk_RatingFlags_PorcelainRatings` FOREIGN KEY (`RatingID`) REFERENCES `Ratings` (`RatingID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=873 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RatingFlags`
--

LOCK TABLES `RatingFlags` WRITE;
/*!40000 ALTER TABLE `RatingFlags` DISABLE KEYS */;
INSERT INTO `RatingFlags` VALUES (1,4,1);
/*!40000 ALTER TABLE `RatingFlags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ratings`
--

DROP TABLE IF EXISTS `Ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Ratings` (
  `RatingID` int(11) NOT NULL AUTO_INCREMENT,
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Rating` int(11) NOT NULL DEFAULT '-1',
  `ProfileID` int(11) DEFAULT NULL,
  `BathroomID` int(11) DEFAULT NULL,
  `Comment` varchar(5000) DEFAULT NULL COMMENT 'Not every rating will have a comment but every comment will have a rating.',
  `PictureURL` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`RatingID`),
  UNIQUE KEY `RatingID_UNIQUE` (`RatingID`),
  KEY `fk_Ratings_2_idx` (`ProfileID`),
  KEY `fk_Ratings_1_idx` (`BathroomID`)
) ENGINE=InnoDB AUTO_INCREMENT=648 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ratings`
--

LOCK TABLES `Ratings` WRITE;
/*!40000 ALTER TABLE `Ratings` DISABLE KEYS */;
INSERT INTO `Ratings` VALUES (1,'2015-11-24 22:57:00',2,1,1,'comment','');
/*!40000 ALTER TABLE `Ratings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-29 10:27:53
