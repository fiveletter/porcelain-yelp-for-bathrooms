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
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `GoogleHash` varchar(45) NOT NULL,
  `Username` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ProfileID`),
  UNIQUE KEY `GoogleHash_UNIQUE` (`GoogleHash`),
  UNIQUE KEY `ProfilesID_UNIQUE` (`ProfileID`),
  UNIQUE KEY `Username_UNIQUE` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Profiles`
--

LOCK TABLES `Profiles` WRITE;
/*!40000 ALTER TABLE `Profiles` DISABLE KEYS */;
INSERT INTO `Profiles` VALUES (0,'Root','Admin','HashBrowns','KAMMCE');
/*!40000 ALTER TABLE `Profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ratings`
--

DROP TABLE IF EXISTS `Ratings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Ratings` (
  `RatingID` int(11) NOT NULL AUTO_INCREMENT,
  `Rating` float NOT NULL DEFAULT '-1',
  `Timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ProfileID` int(11) DEFAULT NULL,
  `ToiletID` int(11) DEFAULT NULL,
  `Comment` varchar(5000) DEFAULT NULL COMMENT 'Not every rating will have a comment but every comment will have a rating.',
  PRIMARY KEY (`RatingID`),
  UNIQUE KEY `RatingID_UNIQUE` (`RatingID`),
  KEY `ProfileID_idx` (`ProfileID`),
  KEY `ToiletID_idx` (`ToiletID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ratings`
--

LOCK TABLES `Ratings` WRITE;
/*!40000 ALTER TABLE `Ratings` DISABLE KEYS */;
/*!40000 ALTER TABLE `Ratings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ToiletFlags`
--

DROP TABLE IF EXISTS `ToiletFlags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ToiletFlags` (
  `ToiletFlagID` int(11) NOT NULL,
  `FlagID` int(11) DEFAULT NULL,
  `ToiletID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ToiletFlagID`),
  KEY `ToiletID_idx` (`ToiletID`),
  KEY `FlagID_idx` (`FlagID`),
  CONSTRAINT `FlagID` FOREIGN KEY (`FlagID`) REFERENCES `Flags` (`FlagsID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ToiletID` FOREIGN KEY (`ToiletID`) REFERENCES `Toilets` (`ToiletID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ToiletFlags`
--

LOCK TABLES `ToiletFlags` WRITE;
/*!40000 ALTER TABLE `ToiletFlags` DISABLE KEYS */;
/*!40000 ALTER TABLE `ToiletFlags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Toilets`
--

DROP TABLE IF EXISTS `Toilets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Toilets` (
  `ToiletID` int(11) NOT NULL AUTO_INCREMENT,
  `Longitude` float NOT NULL,
  `Latitude` float NOT NULL,
  `Title` varchar(150) NOT NULL,
  `ImgURI` varchar(300) NOT NULL,
  PRIMARY KEY (`ToiletID`),
  UNIQUE KEY `ImgURI_UNIQUE` (`ImgURI`),
  UNIQUE KEY `ToiletID_UNIQUE` (`ToiletID`),
  UNIQUE KEY `Title_UNIQUE` (`Title`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Toilets`
--

LOCK TABLES `Toilets` WRITE;
/*!40000 ALTER TABLE `Toilets` DISABLE KEYS */;
INSERT INTO `Toilets` VALUES (1,-121.881,37.3369,'SJSU Engineering Bathroom','');
/*!40000 ALTER TABLE `Toilets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-11-22 15:11:53
