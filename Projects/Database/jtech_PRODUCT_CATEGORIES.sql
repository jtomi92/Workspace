-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: jtech.cr2mzdew7yg9.eu-west-1.rds.amazonaws.com    Database: jtech
-- ------------------------------------------------------
-- Server version	5.6.27-log

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
-- Table structure for table `PRODUCT_CATEGORIES`
--

DROP TABLE IF EXISTS `PRODUCT_CATEGORIES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PRODUCT_CATEGORIES` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(45) DEFAULT NULL,
  `relay_count` int(11) NOT NULL,
  `input_count` int(11) NOT NULL,
  `host1` varchar(45) DEFAULT NULL,
  `port1` varchar(45) DEFAULT NULL,
  `host2` varchar(45) DEFAULT NULL,
  `port2` varchar(45) DEFAULT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PRODUCT_CATEGORIES`
--

LOCK TABLES `PRODUCT_CATEGORIES` WRITE;
/*!40000 ALTER TABLE `PRODUCT_CATEGORIES` DISABLE KEYS */;
INSERT INTO `PRODUCT_CATEGORIES` VALUES (1,'test product 1',3,2,'jtech-session.eu-west-1.elasticbeanstalk.com','2086','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2016/08/21 15:48:40','2016/08/21 20:36:02'),(2,'test_product 2',3,2,'jtech-session.eu-west-1.elasticbeanstalk.com','2086','jtech-session.eu-west-1.elasticbeanstalk.com','2086','2016/08/21 15:53:45','2016/08/21 15:53:45');
/*!40000 ALTER TABLE `PRODUCT_CATEGORIES` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-17 14:26:22
