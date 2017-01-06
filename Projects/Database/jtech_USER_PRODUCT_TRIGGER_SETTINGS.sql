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
-- Table structure for table `USER_PRODUCT_TRIGGER_SETTINGS`
--

DROP TABLE IF EXISTS `USER_PRODUCT_TRIGGER_SETTINGS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `USER_PRODUCT_TRIGGER_SETTINGS` (
  `serial_number` varchar(45) NOT NULL,
  `setting_id` int(11) NOT NULL,
  `input_id` int(11) NOT NULL,
  `trigger_id` int(11) NOT NULL,
  `trigger_relay_id` int(11) DEFAULT NULL,
  `trigger_enabled` varchar(45) DEFAULT NULL,
  `trigger_value` varchar(45) DEFAULT NULL,
  `trigger_state` varchar(45) DEFAULT NULL,
  `trigger_action` varchar(45) DEFAULT NULL,
  `last_update_date` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`serial_number`,`setting_id`,`input_id`,`trigger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER_PRODUCT_TRIGGER_SETTINGS`
--

LOCK TABLES `USER_PRODUCT_TRIGGER_SETTINGS` WRITE;
/*!40000 ALTER TABLE `USER_PRODUCT_TRIGGER_SETTINGS` DISABLE KEYS */;
/*!40000 ALTER TABLE `USER_PRODUCT_TRIGGER_SETTINGS` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-01-06 16:46:07