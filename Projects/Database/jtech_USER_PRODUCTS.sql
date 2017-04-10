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
-- Table structure for table `USER_PRODUCTS`
--

DROP TABLE IF EXISTS `USER_PRODUCTS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER_PRODUCTS` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(45) NOT NULL,
  `name` varchar(45) DEFAULT NULL,
  `phone_number` varchar(45) DEFAULT NULL,
  `host1` varchar(45) DEFAULT NULL,
  `port1` varchar(45) DEFAULT NULL,
  `host2` varchar(45) DEFAULT NULL,
  `port2` varchar(45) DEFAULT NULL,
  `edited` varchar(1) NOT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`group_id`,`serial_number`),
  KEY `user_product_settings1_fk_idx` (`serial_number`),
  KEY `test_idx` (`serial_number`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PRODUCTS`
--

LOCK TABLES `USER_PRODUCTS` WRITE;
/*!40000 ALTER TABLE `USER_PRODUCTS` DISABLE KEYS */;
INSERT INTO `USER_PRODUCTS` VALUES (35,'QU5ZU41HME','Teszt 1','','jtech-session.eu-west-1.elasticbeanstalk.com','2086','jtech-session.eu-west-1.elasticbeanstalk.com','2086','N','2017/01/11 13:14:57','2017/02/15 21:56:38'),(36,'YBDNJ1EL32','test product 1','','jtech-session.eu-west-1.elasticbeanstalk.com','2086','jtech-session.eu-west-1.elasticbeanstalk.com','2086','N','2017/01/11 13:26:25','2017/03/17 16:01:24'),(37,'JQ5PXAR7CE','test product 1','','jtech-session.eu-west-1.elasticbeanstalk.com','2086','jtech-session.eu-west-1.elasticbeanstalk.com','2086','N','2017/01/11 23:09:57','2017/01/13 19:06:03'),(38,'ZC5RMI57L9','test product 1','','jtech-session.eu-west-1.elasticbeanstalk.com','2086','jtech-session.eu-west-1.elasticbeanstalk.com','2086','Y','2017/02/15 21:37:41','2017/02/15 21:37:41'),(39,'MHOAILZ7VI','Eszközöm','','jtech-session.eu-west-1.elasticbeanstalk.com','2086','jtech-session.eu-west-1.elasticbeanstalk.com','2086','N','2017/02/15 21:38:26','2017/03/20 23:48:15');
/*!40000 ALTER TABLE `USER_PRODUCTS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-04-02 16:14:26
