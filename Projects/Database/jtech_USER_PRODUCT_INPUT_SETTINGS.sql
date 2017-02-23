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
-- Table structure for table `USER_PRODUCT_INPUT_SETTINGS`
--

DROP TABLE IF EXISTS `USER_PRODUCT_INPUT_SETTINGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER_PRODUCT_INPUT_SETTINGS` (
  `serial_number` varchar(45) NOT NULL,
  `input_id` int(11) NOT NULL,
  `input_name` varchar(45) DEFAULT NULL,
  `start_timer` varchar(45) DEFAULT NULL,
  `end_timer` varchar(45) DEFAULT NULL,
  `timer_enabled` varchar(45) DEFAULT NULL,
  `value_postfix` varchar(45) DEFAULT NULL,
  `sample_rate` varchar(45) DEFAULT NULL,
  `creation_date` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`serial_number`,`input_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PRODUCT_INPUT_SETTINGS`
--

LOCK TABLES `USER_PRODUCT_INPUT_SETTINGS` WRITE;
/*!40000 ALTER TABLE `USER_PRODUCT_INPUT_SETTINGS` DISABLE KEYS */;
INSERT INTO `USER_PRODUCT_INPUT_SETTINGS` VALUES ('JQ5PXAR7CE',1,'test input 1','13:20','15:40','Y','Celsius','30','2017/01/11 23:09:57','2017/01/13 19:06:04'),('JQ5PXAR7CE',2,'test input 2','13:20','15:40','Y','Celsius','30','2017/01/11 23:09:57','2017/01/13 19:06:04'),('MHOAILZ7VI',1,'test input 1','13:20','15:40','Y','Celsius','30','2017/02/15 21:38:26','2017/02/16 17:13:21'),('MHOAILZ7VI',2,'test input 2','13:20','15:40','Y','Celsius','30','2017/02/15 21:38:26','2017/02/16 17:13:21'),('QU5ZU41HME',1,'test input 1','13:20','15:40','Y','Celsius','30','2017/01/11 13:14:57','2017/02/15 21:56:40'),('QU5ZU41HME',2,'test input 2','13:20','15:40','Y','Celsius','30','2017/01/11 13:14:57','2017/02/15 21:56:40'),('YBDNJ1EL32',1,'test input 1','13:20','15:40','Y','Celsius','30','2017/01/11 13:26:25','2017/02/16 15:14:26'),('YBDNJ1EL32',2,'test input 2','13:20','15:40','Y','Celsius','30','2017/01/11 13:26:25','2017/02/16 15:14:26'),('ZC5RMI57L9',1,'test input 1','13:20','15:40','Y','Celsius','30','2017/02/15 21:37:41','2017/02/15 21:37:41'),('ZC5RMI57L9',2,'test input 2','13:20','15:40','Y','Celsius','30','2017/02/15 21:37:41','2017/02/15 21:37:41');
/*!40000 ALTER TABLE `USER_PRODUCT_INPUT_SETTINGS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-02-17 14:26:16
