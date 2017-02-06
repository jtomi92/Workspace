-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: localhost    Database: jtech
-- ------------------------------------------------------
-- Server version	5.7.13-log

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
-- Table structure for table `USER_PRODUCT_NOTIFICATIONS`
--

DROP TABLE IF EXISTS `USER_PRODUCT_NOTIFICATIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER_PRODUCT_NOTIFICATIONS` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(45) NOT NULL,
  `notification` varchar(100) DEFAULT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`notification_id`,`serial_number`)
) ENGINE=InnoDB AUTO_INCREMENT=373 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PRODUCT_NOTIFICATIONS`
--

LOCK TABLES `USER_PRODUCT_NOTIFICATIONS` WRITE;
/*!40000 ALTER TABLE `USER_PRODUCT_NOTIFICATIONS` DISABLE KEYS */;
INSERT INTO `USER_PRODUCT_NOTIFICATIONS` VALUES (121,'ON6FAVXXUF','REFRESH','2017/01/03 19:48:05'),(372,'JQ5PXAR7CE','UPDATED','2017/01/13 19:06:04');
/*!40000 ALTER TABLE `USER_PRODUCT_NOTIFICATIONS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-18 15:23:13
